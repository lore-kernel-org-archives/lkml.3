Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3AZR2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab3AZR2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:31 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/9] perf tests: Add automated precise term test
Date: Sat, 26 Jan 2013 18:27:53 +0100
Message-Id: <1359221275-24254-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for precise term test in event:
  'cpu/cycles,precise/'
  'cpu/cycles,precise/p'
  'cpu/cycles,precise/u'

to check proper values of precise_ip driven by sysfs
precise attribute.

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
---
 tools/perf/tests/parse-events.c | 75 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 20acaff..f92580d 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -5,6 +5,7 @@
 #include "sysfs.h"
 #include "debugfs.h"
 #include "tests.h"
+#include "util.h"
 #include <linux/hw_breakpoint.h>
 
 #define TEST_ASSERT_VAL(text, cond) \
@@ -445,6 +446,68 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_precise(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* cpu/cycles,precise/ */
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by sysfs precise attribute */
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == perf_precise__get());
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
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by 'p' modifier */
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
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
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	/* precise is driven by sysfs precise attribute */
+	TEST_ASSERT_VAL("wrong precise_ip",
+		evsel->attr.precise_ip == perf_precise__get());
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+
+	return 0;
+}
+
 static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
@@ -994,6 +1057,18 @@ static struct evlist_test test__events_pmu[] = {
 		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
 		.check = test__checkevent_pmu_name,
 	},
+	[2] = {
+		.name  = "cpu/cycles,precise/",
+		.check = test__checkevent_pmu_precise,
+	},
+	[3] = {
+		.name  = "cpu/cycles,precise/p",
+		.check = test__checkevent_pmu_precise1,
+	},
+	[4] = {
+		.name  = "cpu/cycles,precise/u",
+		.check = test__checkevent_pmu_precise2,
+	},
 };
 
 struct terms_test {
-- 
1.7.11.7

