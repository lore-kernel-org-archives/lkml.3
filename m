Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIXNrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:01 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43730 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaIXNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:46:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Shin <jacob.w.shin@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/4] perf tools: add hardware breakpoint bp_len test cases
Date: Wed, 24 Sep 2014 15:45:50 +0200
Message-Id: <1411566351-10987-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
References: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/parse-events.c | 58 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 5941927..d32b5c1 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1115,6 +1115,49 @@ static int test__pinned_group(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_breakpoint_len(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_1 ==
+					evsel->attr.bp_len);
+
+	return 0;
+}
+
+static int test__checkevent_breakpoint_len_w(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", HW_BREAKPOINT_W ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_2 ==
+					evsel->attr.bp_len);
+
+	return 0;
+}
+
+static int
+test__checkevent_breakpoint_len_rw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
 static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
@@ -1390,6 +1433,21 @@ static struct evlist_test test__events[] = {
 		.check = test__pinned_group,
 		.id    = 41,
 	},
+	{
+		.name  = "mem:0/1",
+		.check = test__checkevent_breakpoint_len,
+		.id    = 42,
+	},
+	{
+		.name  = "mem:0/2:w",
+		.check = test__checkevent_breakpoint_len_w,
+		.id    = 43,
+	},
+	{
+		.name  = "mem:0/4:rw:u",
+		.check = test__checkevent_breakpoint_len_rw_modifier,
+		.id    = 44
+	},
 #if defined(__s390x__)
 	{
 		.name  = "kvm-s390:kvm_s390_create_vm",
-- 
2.1.0

