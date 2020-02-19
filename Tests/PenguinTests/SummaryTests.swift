import XCTest
@testable import Penguin

final class SummaryTests: XCTestCase {

    func testIntSummary() throws {
        let summary = computeNumericSummary([1, 10, 100, -1], PIndexSet([false, false, false, true], setCount: 1))
        XCTAssertEqual(4, summary.rowCount)
        XCTAssertEqual(1, summary.missingCount)
        let details = try assertNumericDetails(summary)
        XCTAssertEqual(1, details.min)
        XCTAssertEqual(100, details.max)
        XCTAssertEqual(111, details.sum)
        XCTAssertEqual(37, details.mean)
        XCTAssertEqual(0, details.zeroCount)
        XCTAssertEqual(0, details.negativeCount)
        XCTAssertEqual(3, details.positiveCount)
        XCTAssertEqual(0, details.nanCount)
        XCTAssertEqual(0, details.infCount)
    }

    func testDoubleSummary() throws {
        let summary = computeNumericSummary([-1, 301, 150, -1, 0, 0], PIndexSet([false, false, false, true, false, true], setCount: 2))
        XCTAssertEqual(6, summary.rowCount)
        XCTAssertEqual(2, summary.missingCount)
        let details = try assertNumericDetails(summary)
        XCTAssertEqual(-1, details.min)
        XCTAssertEqual(301, details.max)
        XCTAssertEqual(450, details.sum)
        XCTAssertEqual(112.5, details.mean)
        XCTAssertEqual(1, details.zeroCount)
        XCTAssertEqual(1, details.negativeCount)
        XCTAssertEqual(2, details.positiveCount)
        XCTAssertEqual(0, details.nanCount)
        XCTAssertEqual(0, details.infCount)
    }

    // TODO: Handle NaN's and Infinities!

    func testStringSummary() throws {
        let summary = computeStringSummary(["a", "b", "cde", "xyz", "fghijkl", "asdf", "mnopqrs"], PIndexSet([true, false, false, false, false, true, false], setCount: 2))
        XCTAssertEqual(7, summary.rowCount)
        XCTAssertEqual(2, summary.missingCount)
        let details = try assertStringDetails(summary)
        XCTAssertEqual("b", details.min)
        XCTAssertEqual("xyz", details.max)
        XCTAssertEqual("b", details.shortest)
        XCTAssertEqual("fghijkl", details.longest)
        XCTAssertEqual(4.2, details.averageLength)  // 21 / 5
        XCTAssertEqual(5, details.asciiOnlyCount)
    }

    static var allTests = [
        ("testIntSummary", testIntSummary),
        ("testDoubleSummary", testDoubleSummary),
        ("testStringSummary", testStringSummary),
    ]
}

func assertNumericDetails(_ summary: PColumnSummary) throws -> PNumericDetails {
    switch summary.details {
    case let .numeric(details):
        return details
    default:
        XCTFail("No numeric details in \(summary).")
        throw TestFailure.bad
    }
}

func assertStringDetails(_ summary: PColumnSummary) throws -> PStringDetails {
    switch summary.details {
    case let .string(details):
        return details
    default:
        XCTFail("No string details in \(summary).")
        throw TestFailure.bad
    }
}

enum TestFailure: Error {
    case bad
}
