Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3HLKY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:24:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:23 -0400
Date: Mon, 12 Aug 2013 03:24:02 -0700
From: tip-bot for Michael Ellerman <tipbot@zytor.com>
Message-ID: <tip-c9ee780f2736b7a149658b0cd8c8389da23e190a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, michael@ellerman.id.au,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, michael@ellerman.id.au,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
References: <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add tests of new pinned modifier
Git-Commit-ID: c9ee780f2736b7a149658b0cd8c8389da23e190a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:24:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9ee780f2736b7a149658b0cd8c8389da23e190a
Gitweb:     http://git.kernel.org/tip/c9ee780f2736b7a149658b0cd8c8389da23e190a
Author:     Michael Ellerman <michael@ellerman.id.au>
AuthorDate: Tue, 6 Aug 2013 23:28:06 +1000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:40 -0300

perf tests: Add tests of new pinned modifier

Add a negative test to test__checkevent_pmu_events() to get lots of
coverage of the negative case, ie. when the modifier is not specified.

Add a test of a single event, and of the group case.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1375795686-4226-2-git-send-email-michael@ellerman.id.au
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
