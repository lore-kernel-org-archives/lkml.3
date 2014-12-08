Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaLHGxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:53:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHGxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:53:38 -0500
Date: Sun, 7 Dec 2014 22:53:26 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-fa94c36c29ed8bb4749b5fd7ea51a593f673dcef@git.kernel.org>
Cc: acme@redhat.com, tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org
Reply-To: namhyung@kernel.org, acme@redhat.com, tglx@linutronix.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        hpa@zytor.com, mingo@kernel.org
In-Reply-To: <1415844328-4884-5-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add --branch-history option
Git-Commit-ID: fa94c36c29ed8bb4749b5fd7ea51a593f673dcef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa94c36c29ed8bb4749b5fd7ea51a593f673dcef
Gitweb:     http://git.kernel.org/tip/fa94c36c29ed8bb4749b5fd7ea51a593f673dcef
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:22 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:31 -0300

perf report: Add --branch-history option

Add a --branch-history option to perf report that changes all the
settings necessary for using the branches in callstacks.

This is just a short cut to make this nicer to use, it does not enable
any functionality by itself.

v2: Change sort order. Rename option to --branch-history to
    be less confusing.
v3: Updates
v4: Fix conflict with newer perf base
v5: Port to latest tip
v6: Add more comments. Remove CCKEY_ADDRESS setting. Remove
    unnecessary branch_mode setting. Use a boolean.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-5-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 26 ++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 22706be..dd7cccd 100644
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
index 410d44f..fb272ff 100644
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
@@ -575,6 +576,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
+	bool branch_call_mode = false;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -684,7 +686,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
-		    "use branch records for histogram filling", parse_branch_mode),
+		    "use branch records for per branch histogram filling",
+		    parse_branch_mode),
+	OPT_BOOLEAN(0, "branch-history", &branch_call_mode,
+		    "add last branch records to call history"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
@@ -745,10 +750,23 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
+	/*
+	 * Branch mode is a tristate:
+	 * -1 means default, so decide based on the file having branch data.
+	 * 0/1 means the user chose a mode.
+	 */
+	if (((branch_mode == -1 && has_br_stack) || branch_mode == 1) &&
+	    branch_call_mode == -1) {
 		sort__mode = SORT_MODE__BRANCH;
 		symbol_conf.cumulate_callchain = false;
 	}
+	if (branch_call_mode) {
+		callchain_param.branch_callstack = 1;
+		symbol_conf.use_callchain = true;
+		callchain_register_param(&callchain_param);
+		if (sort_order == NULL)
+			sort_order = "srcline,symbol,dso";
+	}
 
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
