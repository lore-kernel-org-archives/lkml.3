Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaFANgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbaFANcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:12 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 15/27] perf report: Add --children option
Date: Sun,  1 Jun 2014 15:31:26 +0200
Message-Id: <1401629498-8726-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The --children option is for showing accumulated overhead (period)
value as well as self overhead.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-16-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  7 ++++++-
 tools/perf/builtin-report.c              | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index a1b5185..cefdf43 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -111,7 +111,7 @@ OPTIONS
 --fields=::
 	Specify output field - multiple keys can be specified in CSV format.
 	Following fields are available:
-	overhead, overhead_sys, overhead_us, sample and period.
+	overhead, overhead_sys, overhead_us, overhead_children, sample and period.
 	Also it can contain any sort key(s).
 
 	By default, every sort keys not specified in -F will be appended
@@ -163,6 +163,11 @@ OPTIONS
 
 	Default: fractal,0.5,callee,function.
 
+--children::
+	Accumulate callchain of children to parent entry so that then can
+	show up in the output.  The output will have a new "Children" column
+	and will be sorted on the data.  It requires callchains are recorded.
+
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
 	beyond the specified depth will be ignored. This is a trade-off
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e8fa9fe..f27a8aa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -185,6 +185,14 @@ static int report__setup_sample_type(struct report *rep)
 			}
 	}
 
+	if (symbol_conf.cumulate_callchain) {
+		/* Silently ignore if callchain is missing */
+		if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+			symbol_conf.cumulate_callchain = false;
+			perf_hpp__cancel_cumulate();
+		}
+	}
+
 	if (sort__mode == SORT_MODE__BRANCH) {
 		if (!is_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
@@ -568,6 +576,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
 		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
 		    "anything beyond the specified depth will be ignored. "
@@ -660,8 +670,10 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack)
+	if (branch_mode == -1 && has_br_stack) {
 		sort__mode = SORT_MODE__BRANCH;
+		symbol_conf.cumulate_callchain = false;
+	}
 
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
@@ -669,6 +681,7 @@ repeat:
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
+		symbol_conf.cumulate_callchain = false;
 	}
 
 	if (setup_sorting() < 0) {
-- 
1.8.3.1

