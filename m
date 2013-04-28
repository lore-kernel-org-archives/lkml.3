Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3D1GGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 02:06:08 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:46475
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab3D1GGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 02:06:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLYBLV-02-965-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/3] perf tools: add hardware breakpoint bp_len test cases
Date: Sun, 28 Apr 2013 01:05:52 -0500
Message-ID: <1367129152-11621-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
References: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/tests/parse-events.c |   55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 88e2f44..4fd0f96 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -971,6 +971,49 @@ static int test__group_gh4(struct perf_evlist *evlist)
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
@@ -1187,6 +1230,18 @@ static struct evlist_test test__events[] = {
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
 	},
+	[38] = {
+		.name  = "mem:0/1",
+		.check = test__checkevent_breakpoint_len,
+	},
+	[39] = {
+		.name  = "mem:0/2:w",
+		.check = test__checkevent_breakpoint_len_w,
+	},
+	[40] = {
+		.name  = "mem:0/4:rw:u",
+		.check = test__checkevent_breakpoint_len_rw_modifier,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.7.9.5


