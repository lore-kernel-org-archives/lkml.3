Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaB1EXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:23:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:2072 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaB1EWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:22:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="489674325"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/8] perf, tools: Add --branch-history option to report v2
Date: Thu, 27 Feb 2014 20:22:27 -0800
Message-Id: <1393561352-23448-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 28 +++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 349cd2a..5b270fe 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -228,6 +228,11 @@ OPTIONS
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
index f7a9e3d..302c4e8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -691,6 +691,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
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
@@ -705,7 +715,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
-	int branch_mode = -1;
+	int branch_mode = -1, branch_call_mode = -1;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -814,7 +824,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -862,8 +876,16 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack)
+	if (branch_mode == -1 && has_br_stack && branch_call_mode == -1)
 		sort__mode = SORT_MODE__BRANCH;
+	if (branch_call_mode != -1) {
+		callchain_param.branch_callstack = 1;
+		callchain_param.key = CCKEY_ADDRESS;
+		symbol_conf.use_callchain = true;
+		callchain_register_param(&callchain_param);
+		if (sort_order == default_sort_order)
+			sort_order = "srcline,symbol,dso";
+	}
 
 	/* sort__mode could be NORMAL if --no-branch-stack */
 	if (sort__mode == SORT_MODE__BRANCH) {
-- 
1.8.5.3

