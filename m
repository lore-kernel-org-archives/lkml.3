Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJVPQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:16:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41961 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaJVPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:16:14 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>
Subject: [PATCH 4/5] perf tools: Add support for exclusive option
Date: Thu, 23 Oct 2014 00:15:48 +0900
Message-Id: <1413990949-13953-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some options cannot be used at the same time.  To handle such options
add a new PARSE_OPT_EXCLUSIVE flag and show error message if more than
one of them is used.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-options.c | 59 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/parse-options.h |  2 ++
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index b6016101b40b..f62dee7bd924 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -45,6 +45,23 @@ static int get_value(struct parse_opt_ctx_t *p,
 	if (opt->flags & PARSE_OPT_DISABLED)
 		return opterror(opt, "is not usable", flags);
 
+	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
+		if (p->excl_opt) {
+			char msg[128];
+
+			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
+			    p->excl_opt->long_name == NULL) {
+				scnprintf(msg, sizeof(msg), "cannot be used with switch `%c'",
+					  p->excl_opt->short_name);
+			} else {
+				scnprintf(msg, sizeof(msg), "cannot be used with %s",
+					  p->excl_opt->long_name);
+			}
+			opterror(opt, msg, flags);
+			return -3;
+		}
+		p->excl_opt = opt;
+	}
 	if (!(flags & OPT_SHORT) && p->opt) {
 		switch (opt->type) {
 		case OPTION_CALLBACK:
@@ -345,13 +362,14 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		       const char * const usagestr[])
 {
 	int internal_help = !(ctx->flags & PARSE_OPT_NO_INTERNAL_HELP);
+	int excl_short_opt = 1;
+	const char *arg;
 
 	/* we must reset ->opt, unknown short option leave it dangling */
 	ctx->opt = NULL;
 
 	for (; ctx->argc; ctx->argc--, ctx->argv++) {
-		const char *arg = ctx->argv[0];
-
+		arg = ctx->argv[0];
 		if (*arg != '-' || !arg[1]) {
 			if (ctx->flags & PARSE_OPT_STOP_AT_NON_OPTION)
 				break;
@@ -360,19 +378,21 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		}
 
 		if (arg[1] != '-') {
-			ctx->opt = arg + 1;
+			ctx->opt = ++arg;
 			if (internal_help && *ctx->opt == 'h')
 				return usage_with_options_internal(usagestr, options, 0);
 			switch (parse_short_opt(ctx, options)) {
 			case -1:
-				return parse_options_usage(usagestr, options, arg + 1, 1);
+				return parse_options_usage(usagestr, options, arg, 1);
 			case -2:
 				goto unknown;
+			case -3:
+				goto exclusive;
 			default:
 				break;
 			}
 			if (ctx->opt)
-				check_typos(arg + 1, options);
+				check_typos(arg, options);
 			while (ctx->opt) {
 				if (internal_help && *ctx->opt == 'h')
 					return usage_with_options_internal(usagestr, options, 0);
@@ -389,6 +409,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 					ctx->argv[0] = strdup(ctx->opt - 1);
 					*(char *)ctx->argv[0] = '-';
 					goto unknown;
+				case -3:
+					goto exclusive;
 				default:
 					break;
 				}
@@ -404,19 +426,23 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			break;
 		}
 
-		if (internal_help && !strcmp(arg + 2, "help-all"))
+		arg += 2;
+		if (internal_help && !strcmp(arg, "help-all"))
 			return usage_with_options_internal(usagestr, options, 1);
-		if (internal_help && !strcmp(arg + 2, "help"))
+		if (internal_help && !strcmp(arg, "help"))
 			return usage_with_options_internal(usagestr, options, 0);
-		if (!strcmp(arg + 2, "list-opts"))
+		if (!strcmp(arg, "list-opts"))
 			return PARSE_OPT_LIST_OPTS;
-		if (!strcmp(arg + 2, "list-cmds"))
+		if (!strcmp(arg, "list-cmds"))
 			return PARSE_OPT_LIST_SUBCMDS;
-		switch (parse_long_opt(ctx, arg + 2, options)) {
+		switch (parse_long_opt(ctx, arg, options)) {
 		case -1:
-			return parse_options_usage(usagestr, options, arg + 2, 0);
+			return parse_options_usage(usagestr, options, arg, 0);
 		case -2:
 			goto unknown;
+		case -3:
+			excl_short_opt = 0;
+			goto exclusive;
 		default:
 			break;
 		}
@@ -428,6 +454,17 @@ unknown:
 		ctx->opt = NULL;
 	}
 	return PARSE_OPT_DONE;
+
+exclusive:
+	parse_options_usage(usagestr, options, arg, excl_short_opt);
+	if ((excl_short_opt && ctx->excl_opt->short_name) ||
+	    ctx->excl_opt->long_name == NULL) {
+		char opt = ctx->excl_opt->short_name;
+		parse_options_usage(NULL, options, &opt, 1);
+	} else {
+		parse_options_usage(NULL, options, ctx->excl_opt->long_name, 0);
+	}
+	return PARSE_OPT_HELP;
 }
 
 int parse_options_end(struct parse_opt_ctx_t *ctx)
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index b7c80dbc7627..97b153fb4999 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -39,6 +39,7 @@ enum parse_opt_option_flags {
 	PARSE_OPT_HIDDEN  = 8,
 	PARSE_OPT_LASTARG_DEFAULT = 16,
 	PARSE_OPT_DISABLED = 32,
+	PARSE_OPT_EXCLUSIVE = 64,
 };
 
 struct option;
@@ -174,6 +175,7 @@ struct parse_opt_ctx_t {
 	const char **out;
 	int argc, cpidx;
 	const char *opt;
+	const struct option *excl_opt;
 	int flags;
 };
 
-- 
2.0.0

