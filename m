Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3BDJ5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:57:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab3BDJ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:57:05 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/2] perf tests: Adding automated parsing tests for group :GH modifiers
Date: Mon,  4 Feb 2013 10:56:43 +0100
Message-Id: <1359971803-2343-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359971803-2343-1-git-send-email-jolsa@redhat.com>
References: <1359971803-2343-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ':GH' group modifier handling was just recently fixed,
adding some autommated tests to keep it that way. Adding
tests for following events:

  "{cycles,cache-misses:G}:H"
  "{cycles,cache-misses:H}:G"
  "{cycles:G,cache-misses:H}:u"
  "{cycles:G,cache-misses:H}:uG"

Plus fixing test__group2 test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/parse-events.c | 178 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 177 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 80a8daf..c5636f3 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -577,7 +577,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
@@ -811,6 +811,166 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	return 0;
 }
 
+static int test__group_gh1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
+
+	/* cycles + :H group modifier */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+
+	/* cache-misses:G + :H group modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+
+	return 0;
+}
+
+static int test__group_gh2(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
+
+	/* cycles + :G group modifier */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+
+	/* cache-misses:H + :G group modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+
+	return 0;
+}
+
+static int test__group_gh3(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
+
+	/* cycles:G + :u group modifier */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+
+	/* cache-misses:H + :u group modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+
+	return 0;
+}
+
+static int test__group_gh4(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
+
+	/* cycles:G + :uG group modifier */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+
+	/* cache-misses:H + :uG group modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+
+	return 0;
+}
+
 static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
@@ -1011,6 +1171,22 @@ static struct evlist_test test__events[] = {
 		.name  = "*:*",
 		.check = test__all_tracepoints,
 	},
+	[34] = {
+		.name  = "{cycles,cache-misses:G}:H",
+		.check = test__group_gh1,
+	},
+	[35] = {
+		.name  = "{cycles,cache-misses:H}:G",
+		.check = test__group_gh2,
+	},
+	[36] = {
+		.name  = "{cycles:G,cache-misses:H}:u",
+		.check = test__group_gh3,
+	},
+	[37] = {
+		.name  = "{cycles:G,cache-misses:H}:uG",
+		.check = test__group_gh4,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.7.11.7

