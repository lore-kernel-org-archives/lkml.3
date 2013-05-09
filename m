Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3EINdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab3EINdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:33:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/9] perf tests: Add automated precise term test
Date: Thu,  9 May 2013 15:32:22 +0200
Message-Id: <1368106344-23383-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for precise term test in event:
  'cpu/config=1,precise/'
  'cpu/config=2,precise/p'
  'cpu/config=3,precise/u'
  'instructions:p'
  'instructions:pp'

to check proper values of precise_ip driven by sysfs
precise attribute.

Also changing other precise related testcases to follow
new precise sysfs rules.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/tests/parse-events.c | 170 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 161 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index f75328c..3b2e21c 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -5,6 +5,7 @@
 #include "sysfs.h"
 #include <lk/debugfs.h>
 #include "tests.h"
+#include "util.h"
 #include <linux/hw_breakpoint.h>
 
 #define TEST_ASSERT_VAL(text, cond) \
@@ -18,6 +19,21 @@ do { \
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
 			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
 
+static int get_precise(void)
+{
+	int precise = perf_precise__get();
+
+	/*
+	 * The sysfs precise attribute is not supported,
+	 * fill in the 1 as default, check
+	 * util/parse-events.c::precise_default function
+	 */
+	if (precise == -1)
+		precise = 1;
+
+	return precise;
+}
+
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
@@ -228,7 +244,8 @@ static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 
 	return test__checkevent_raw(evlist);
 }
@@ -240,7 +257,8 @@ static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 
 	return test__checkevent_numeric(evlist);
 }
@@ -296,7 +314,8 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 
 	return test__checkevent_genhw(evlist);
 }
@@ -337,7 +356,8 @@ static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 	TEST_ASSERT_VAL("wrong name",
 			!strcmp(perf_evsel__name(evsel), "mem:0:r:hp"));
 
@@ -351,7 +371,8 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 	TEST_ASSERT_VAL("wrong name",
 			!strcmp(perf_evsel__name(evsel), "mem:0:w:up"));
 
@@ -365,7 +386,8 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 	TEST_ASSERT_VAL("wrong name",
 			!strcmp(perf_evsel__name(evsel), "mem:0:rw:kp"));
 
@@ -421,7 +443,8 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 
 	return 0;
 }
@@ -447,6 +470,69 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_precise(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* cpu/cycles,precise/ */
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by sysfs precise attribute */
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+
+	return 0;
+}
+
+static int test__checkevent_pmu_precise1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* cpu/cycles,precise/p */
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong config", 2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by 'p' modifier */
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+
+	return 0;
+}
+
+static int test__checkevent_pmu_precise2(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* cpu/cycles,precise/u */
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by sysfs precise attribute */
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+
+	return 0;
+}
+
 static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
@@ -714,7 +800,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	/* use of precise requires exclude_guest */
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
@@ -732,7 +819,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	/* use of precise requires exclude_guest */
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
@@ -1078,6 +1166,50 @@ static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
 	return 0;
 }
 
+static int test__precise_default1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+
+	/* instructions:p - default precise_ip value */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == get_precise());
+
+	return 0;
+}
+
+static int test__precise_default2(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+
+	/* instructions:pp - precise_ip == 2 */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == 2);
+
+	return 0;
+}
+
 static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
@@ -1302,6 +1434,14 @@ static struct evlist_test test__events[] = {
 		.name  = "{instructions,branch-misses}:Su",
 		.check = test__leader_sample2,
 	},
+	[40] = {
+		.name  = "instructions:p",
+		.check = test__precise_default1,
+	},
+	[41] = {
+		.name  = "instructions:pp",
+		.check = test__precise_default2,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
@@ -1313,6 +1453,18 @@ static struct evlist_test test__events_pmu[] = {
 		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
 		.check = test__checkevent_pmu_name,
 	},
+	[2] = {
+		.name  = "cpu/config=1,precise/",
+		.check = test__checkevent_pmu_precise,
+	},
+	[3] = {
+		.name  = "cpu/config=2,precise/p",
+		.check = test__checkevent_pmu_precise1,
+	},
+	[4] = {
+		.name  = "cpu/config=3,precise/u",
+		.check = test__checkevent_pmu_precise2,
+	},
 };
 
 struct terms_test {
-- 
1.7.11.7

