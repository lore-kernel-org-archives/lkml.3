Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbbAHPhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:37:06 -0500
Received: from mail.kernel.org ([198.145.29.136]:48844 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbbAHPhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:37:01 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf hists: Fix children sort key behavior
Date: Thu,  8 Jan 2015 12:36:46 -0300
Message-Id: <1420731408-8631-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420731408-8631-1-git-send-email-acme@kernel.org>
References: <1420731408-8631-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf report --children resorts output fields, it tries to put
caller above the callee.  But this was only meaningful for a same thread
and doing this requires callchain enabled.  So fix its check before
comparing the callchain depth.

This also changes the hist accumulation tests: In test 3, xmalloc in
bash thread should be above than other perf threads due to alphabetical
order of comm string.  Also it's under page_fault in bash thread since
alphabetical order of dso name.  The sys_perf_event_open in perf thread
is put on the last line since it's self overhead is 0.

In test 4, the sys_perf_event_open is put above other perf entries that
have same children overhead since its callchain depth is smaller.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1419309381-2593-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/hists_cumulate.c | 64 +++++++++++++++++++--------------------
 tools/perf/ui/hist.c              |  3 ++
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 4b8226e19a91..8d110dec393e 100644
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
1.9.3

