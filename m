Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaLWEfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:35:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50194 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaLWEfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:35:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2] perf hists: Fix children sort key behavior
Date: Tue, 23 Dec 2014 13:36:21 +0900
Message-Id: <1419309381-2593-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419309072-1910-1-git-send-email-namhyung@kernel.org>
References: <1419309072-1910-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf report --children resorts output fields, it tries to put
caller above the callee.  But this was only meaningful for a same
thread and doing this requires callchain enabled.  So fix its check
before comparing the callchain depth.

This also changes the hist accumulation tests: In test 3, xmalloc in
bash thread should be above than other perf threads due to
alphabetical order of comm string.  Also it's under page_fault in bash
thread since alphabetical order of dso name.  The sys_perf_event_open
in perf thread is put on the last line since it's self overhead is 0.

In test 4, the sys_perf_event_open is put above other perf entries
that have same children overhead since its callchain depth is smaller.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Do not change return value calculation.

 tools/perf/tests/hists_cumulate.c | 64 +++++++++++++++++++--------------------
 tools/perf/ui/hist.c              |  3 ++
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 5bb3ad42be57..18619966454c 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -454,12 +454,12 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 	 *   30.00%    10.00%     perf  perf           [.] cmd_record
 	 *   20.00%     0.00%     bash  libc           [.] malloc
 	 *   10.00%    10.00%     bash  [kernel]       [k] page_fault
-	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
-	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
 	 *   10.00%    10.00%     perf  [kernel]       [k] page_fault
-	 *   10.00%    10.00%     perf  libc           [.] free
 	 *   10.00%    10.00%     perf  libc           [.] malloc
-	 *   10.00%    10.00%     bash  bash           [.] xmalloc
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%    10.00%     perf  libc           [.] free
+	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
 	 */
 	struct result expected[] = {
 		{ 7000, 2000, "perf", "perf",     "main" },
@@ -468,12 +468,12 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		{ 3000, 1000, "perf", "perf",     "cmd_record" },
 		{ 2000,    0, "bash", "libc",     "malloc" },
 		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
-		{ 1000, 1000, "perf", "[kernel]", "schedule" },
-		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
 		{ 1000, 1000, "perf", "libc",     "free" },
 		{ 1000, 1000, "perf", "libc",     "malloc" },
-		{ 1000, 1000, "bash", "bash",     "xmalloc" },
+		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
 	};
 
 	symbol_conf.use_callchain = false;
@@ -537,10 +537,13 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  malloc
 	 *                  main
 	 *
-	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
 	 *              |
-	 *              --- schedule
-	 *                  run_command
+	 *              --- xmalloc
+	 *                  malloc
+	 *                  xmalloc     <--- NOTE: there's a cycle
+	 *                  malloc
+	 *                  xmalloc
 	 *                  main
 	 *
 	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
@@ -556,6 +559,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  run_command
 	 *                  main
 	 *
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *              |
+	 *              --- schedule
+	 *                  run_command
+	 *                  main
+	 *
 	 *   10.00%    10.00%     perf  libc           [.] free
 	 *              |
 	 *              --- free
@@ -570,15 +579,6 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  run_command
 	 *                  main
 	 *
-	 *   10.00%    10.00%     bash  bash           [.] xmalloc
-	 *              |
-	 *              --- xmalloc
-	 *                  malloc
-	 *                  xmalloc     <--- NOTE: there's a cycle
-	 *                  malloc
-	 *                  xmalloc
-	 *                  main
-	 *
 	 */
 	struct result expected[] = {
 		{ 7000, 2000, "perf", "perf",     "main" },
@@ -587,12 +587,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		{ 3000, 1000, "perf", "perf",     "cmd_record" },
 		{ 2000,    0, "bash", "libc",     "malloc" },
 		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
-		{ 1000, 1000, "perf", "[kernel]", "schedule" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
 		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
 		{ 1000, 1000, "perf", "libc",     "free" },
 		{ 1000, 1000, "perf", "libc",     "malloc" },
-		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 	};
 	struct callchain_result expected_callchain[] = {
 		{
@@ -622,9 +622,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "bash",     "main" }, },
 		},
 		{
-			3, {	{ "[kernel]", "schedule" },
-				{ "perf",     "run_command" },
-				{ "perf",     "main" }, },
+			6, {	{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "bash",     "main" }, },
 		},
 		{
 			3, {	{ "[kernel]", "sys_perf_event_open" },
@@ -638,6 +641,11 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "perf",     "main" }, },
 		},
 		{
+			3, {	{ "[kernel]", "schedule" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
 			4, {	{ "libc",     "free" },
 				{ "perf",     "cmd_record" },
 				{ "perf",     "run_command" },
@@ -649,14 +657,6 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "perf",     "run_command" },
 				{ "perf",     "main" }, },
 		},
-		{
-			6, {	{ "bash",     "xmalloc" },
-				{ "libc",     "malloc" },
-				{ "bash",     "xmalloc" },
-				{ "libc",     "malloc" },
-				{ "bash",     "xmalloc" },
-				{ "bash",     "main" }, },
-		},
 	};
 
 	symbol_conf.use_callchain = true;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index dc0d095f318c..482adae3cc44 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -204,6 +204,9 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 		if (ret)
 			return ret;
 
+		if (a->thread != b->thread || !symbol_conf.use_callchain)
+			return 0;
+
 		ret = b->callchain->max_depth - a->callchain->max_depth;
 	}
 	return ret;
-- 
2.1.3

