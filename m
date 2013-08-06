Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3HFN2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:28:19 -0400
Received: from ozlabs.org ([203.10.76.45]:35557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3HFN2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:28:14 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, jolsa@redhat.com
Subject: [PATCH v2 2/2] perf tests: Add tests of new pinned modifier
Date: Tue,  6 Aug 2013 23:28:06 +1000
Message-Id: <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a negative test to test__checkevent_pmu_events() to get lots of
coverage of the negative case, ie. when the modifier is not specified.

Add a test of a single event, and of the group case.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/perf/tests/parse-events.c | 53 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index b46379c..48114d1 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -452,6 +452,7 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 			evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
 
 	return 0;
 }
@@ -1070,6 +1071,50 @@ static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
 	return 0;
 }
 
+static int test__checkevent_pinned_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", evsel->attr.pinned);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__pinned_group(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* cycles - group leader */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong pinned", evsel->attr.pinned);
+
+	/* cache-misses - can not be pinned, but will go on with the leader */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	/* branch-misses - ditto */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_BRANCH_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	return 0;
+}
+
 static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
@@ -1294,6 +1339,14 @@ static struct evlist_test test__events[] = {
 		.name  = "{instructions,branch-misses}:Su",
 		.check = test__leader_sample2,
 	},
+	[40] = {
+		.name  = "instructions:uDp",
+		.check = test__checkevent_pinned_modifier,
+	},
+	[41] = {
+		.name  = "{cycles,cache-misses,branch-misses}:D",
+		.check = test__pinned_group,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.8.1.2

