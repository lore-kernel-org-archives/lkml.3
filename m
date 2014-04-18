Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaDRKcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaDRKcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:32:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/5] perf callchain: Add generic report parse callchain callback function
Date: Fri, 18 Apr 2014 12:31:59 +0200
Message-Id: <1397817119-15195-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
References: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

This takes the parse_callchain_opt function and copies it into the
callchain.c file.  Now the c2c tool can use it too without duplicating.

Update perf-report to use the new routine too.

V3: rename function
V2: remove commented code, combine with perf-report change

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1396896924-129847-5-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-report.c | 81 ++------------------------------------------
 tools/perf/util/callchain.c | 82 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  1 +
 3 files changed, 86 insertions(+), 78 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index af8cb7a..76e2bb6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -589,11 +589,9 @@ static int __cmd_report(struct report *rep)
 }
 
 static int
-parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+report_parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
 	struct report *rep = (struct report *)opt->value;
-	char *tok, *tok2;
-	char *endptr;
 
 	/*
 	 * --no-call-graph
@@ -603,80 +601,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return 0;
 	}
 
-	symbol_conf.use_callchain = true;
-
-	if (!arg)
-		return 0;
-
-	tok = strtok((char *)arg, ",");
-	if (!tok)
-		return -1;
-
-	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_ABS;
-
-	else if (!strncmp(tok, "flat", strlen(arg)))
-		callchain_param.mode = CHAIN_FLAT;
-
-	else if (!strncmp(tok, "fractal", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_REL;
-
-	else if (!strncmp(tok, "none", strlen(arg))) {
-		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = false;
-
-		return 0;
-	}
-
-	else
-		return -1;
-
-	/* get the min percentage */
-	tok = strtok(NULL, ",");
-	if (!tok)
-		goto setup;
-
-	callchain_param.min_percent = strtod(tok, &endptr);
-	if (tok == endptr)
-		return -1;
-
-	/* get the print limit */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-
-	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
-		tok2 = strtok(NULL, ",");
-		if (!tok2)
-			goto setup;
-	}
-
-	/* get the call chain order */
-	if (!strncmp(tok2, "caller", strlen("caller")))
-		callchain_param.order = ORDER_CALLER;
-	else if (!strncmp(tok2, "callee", strlen("callee")))
-		callchain_param.order = ORDER_CALLEE;
-	else
-		return -1;
-
-	/* Get the sort key */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-	if (!strncmp(tok2, "function", strlen("function")))
-		callchain_param.key = CCKEY_FUNCTION;
-	else if (!strncmp(tok2, "address", strlen("address")))
-		callchain_param.key = CCKEY_ADDRESS;
-	else
-		return -1;
-setup:
-	if (callchain_register_param(&callchain_param) < 0) {
-		pr_err("Can't register callchain params\n");
-		return -1;
-	}
-	return 0;
+	return parse_callchain_report_opt(arg);
 }
 
 int
@@ -788,7 +713,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
-		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
+		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
 		    "anything beyond the specified depth will be ignored. "
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 8d9db45..2fa48a9 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -25,6 +25,88 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
+int
+parse_callchain_report_opt(const char *arg)
+{
+	char *tok, *tok2;
+	char *endptr;
+
+	symbol_conf.use_callchain = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+
+		return 0;
+	}
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strncmp(tok2, "caller", strlen("caller")))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strncmp(tok2, "callee", strlen("callee")))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
+
+	/* Get the sort key */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "function", strlen("function")))
+		callchain_param.key = CCKEY_FUNCTION;
+	else if (!strncmp(tok2, "address", strlen("address")))
+		callchain_param.key = CCKEY_ADDRESS;
+	else
+		return -1;
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		pr_err("Can't register callchain params\n");
+		return -1;
+	}
+	return 0;
+}
+
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9..dda4cf8 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -157,4 +157,5 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
 
 extern const char record_callchain_help[];
+int parse_callchain_report_opt(const char *arg);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.8.3.1

