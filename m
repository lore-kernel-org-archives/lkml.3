Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaCKPZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaCKPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:25:29 -0400
Date: Tue, 11 Mar 2014 16:25:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] perf, tools: Add --branch-history option to report v2
Message-ID: <20140311152501.GB19393@krava.redhat.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-4-git-send-email-andi@firstfloor.org>
 <20140307131940.GB13974@krava.brq.redhat.com>
 <20140311003154.GP22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311003154.GP22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:31:54AM +0100, Andi Kleen wrote:
> > this is *same* as parse_branch_mode function and seems to be not needed,
> > I think both branch-stack and branch-history options could be handled
> > by OPT_BOOLEAN
> 
> They can't because the type checker requires bool, and these variables
> are tristate (UNSET, TRUE, FALSE)
> 
> -Andi

hum, I can see only 2 states there (please check patch below).. what do I miss?

also, I think we need to fix the check for sort_mode setup,
because following: 

  $ perf report -b

wouldn't set sort__mode to SORT_MODE__BRANCH

how about -b and --branch-history .. do we allow?

jirka


---
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 16675a0..1433b9c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -682,26 +682,6 @@ report_parse_ignore_callees_opt(const struct option *opt __maybe_unused,
 }
 
 static int
-parse_branch_mode(const struct option *opt __maybe_unused,
-		  const char *str __maybe_unused, int unset)
-{
-	int *branch_mode = opt->value;
-
-	*branch_mode = !unset;
-	return 0;
-}
-
-static int
-parse_branch_call_mode(const struct option *opt __maybe_unused,
-		  const char *str __maybe_unused, int unset)
-{
-	int *branch_mode = opt->value;
-
-	*branch_mode = !unset;
-	return 0;
-}
-
-static int
 parse_percent_limit(const struct option *opt, const char *str,
 		    int unset __maybe_unused)
 {
@@ -716,7 +696,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
-	int branch_mode = -1, branch_call_mode = -1;
+	bool branch_mode = false, branch_call_mode = false;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -824,12 +804,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show a column with the sum of periods"),
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
-	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
-		    "use branch records for per branch histogram filling",
-		    parse_branch_mode),
-	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
-		    "add last branch records to call history",
-		    parse_branch_call_mode),
+	OPT_BOOLEAN('b', "branch-stack", &branch_mode,
+		    "use branch records for per branch histogram filling"),
+	OPT_BOOLEAN(0, "branch-history", &branch_call_mode,
+		    "add last branch records to call history"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
@@ -877,9 +855,9 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack && branch_call_mode == -1)
+	if (!branch_mode && has_br_stack && !branch_call_mode)
 		sort__mode = SORT_MODE__BRANCH;
-	if (branch_call_mode != -1) {
+	if (branch_call_mode) {
 		callchain_param.branch_callstack = 1;
 		callchain_param.key = CCKEY_ADDRESS;
 		symbol_conf.use_callchain = true;
