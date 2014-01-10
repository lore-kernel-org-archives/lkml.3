Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaAJMcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:32:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:35595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaAJMcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:32:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="464666395"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        jolsa@redhat.com, fweisbec@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf, tools: Add --branch-call-stack option to report
Date: Fri, 10 Jan 2014 04:32:04 -0800
Message-Id: <1389357126-3003-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a --branch-call-stack option toperf report that changes all
the settings necessary for using the branches in callstacks.

This is just a short cut to make this nicer to use.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 25 ++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a2798..77ec0b9 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -223,6 +223,11 @@ OPTIONS
 	branch stacks and it will automatically switch to the branch view mode,
 	unless --no-branch-stack is used.
 
+--branch-call-stack::
+	Add the addresses of sampled taken branches to the callstack.
+	This allows to examine the path the program took to each sample.
+	The data collection must have used -b or -j.	
+
 --objdump=<path>::
         Path to objdump binary.
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c2e6e43..c39d1ac 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -763,6 +763,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
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
@@ -777,7 +787,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
-	int branch_mode = -1;
+	int branch_mode = -1, branch_call_mode = -1;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -883,7 +893,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
-		    "use branch records for histogram filling", parse_branch_mode),
+		    "use branch records for per branch histogram filling", parse_branch_mode),
+	OPT_CALLBACK_NOOPT(0, "branch-call-stack", &branch_call_mode, "",
+		    "add last branch records to call stack",
+		    parse_branch_call_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
@@ -931,8 +944,14 @@ repeat:
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
+	}
 
 	/* sort__mode could be NORMAL if --no-branch-stack */
 	if (sort__mode == SORT_MODE__BRANCH) {
-- 
1.8.3.1

