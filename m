Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbaIPAUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:20:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:10904 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079AbaIPAT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:19:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="600070662"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/8] perf, tools: Add --branch-history option to report
Date: Mon, 15 Sep 2014 16:54:27 -0700
Message-Id: <1410825273-7054-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
References: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a --branch-history option to perf report that changes all
the settings necessary for using the branches in callstacks.

This is just a short cut to make this nicer to use, it does
not enable any functionality by itself.

v2: Change sort order. Rename option to --branch-history to
be less confusing.
v3: Updates
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 35 +++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 3e3801c..fc93f58 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -271,6 +271,11 @@ OPTIONS
 	branch stacks and it will automatically switch to the branch view mode,
 	unless --no-branch-stack is used.
 
+--branch-history::
+	Add the addresses of sampled taken branches to the callstack.
+	This allows to examine the path the program took to each sample.
+	The data collection must have used -b (or -j) and -g.
+
 --objdump=<path>::
         Path to objdump binary.
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fd6b019..f72a6c4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -226,8 +226,9 @@ static int report__setup_sample_type(struct report *rep)
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			ui__error("Selected -g but no callchain data. Did "
-				    "you call 'perf record' without -g?\n");
+			ui__error("Selected -g or --branch-history but no "
+				  "callchain data. Did\n"
+				  "you call 'perf record' without -g?\n");
 			return -1;
 		}
 	} else if (!rep->dont_use_callchains &&
@@ -550,6 +551,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
 }
 
 static int
+parse_branch_call_mode(const struct option *opt __maybe_unused,
+		  const char *str __maybe_unused, int unset)
+{
+	int *branch_mode = opt->value;
+
+	*branch_mode = !unset;
+	return 0;
+}
+
+static int
 parse_percent_limit(const struct option *opt, const char *str,
 		    int unset __maybe_unused)
 {
@@ -564,7 +575,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
-	int branch_mode = -1;
+	int branch_mode = -1, branch_call_mode = -1;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -675,7 +686,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
-		    "use branch records for histogram filling", parse_branch_mode),
+		    "use branch records for per branch histogram filling",
+		    parse_branch_mode),
+	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
+		    "add last branch records to call history",
+		    parse_branch_call_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
@@ -730,10 +745,20 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
+	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1 ||
+	    branch_call_mode == -1) {
 		sort__mode = SORT_MODE__BRANCH;
 		symbol_conf.cumulate_callchain = false;
 	}
+	if (branch_call_mode != -1) {
+		callchain_param.branch_callstack = 1;
+		callchain_param.key = CCKEY_ADDRESS;
+		symbol_conf.use_callchain = true;
+		callchain_register_param(&callchain_param);
+		if (sort_order == default_sort_order)
+			sort_order = "srcline,symbol,dso";
+		branch_mode = 0;
+	}
 
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
-- 
1.9.3

