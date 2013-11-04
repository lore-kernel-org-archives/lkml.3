Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3KDUV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3KDUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:21:55 -0500
Date: Mon, 4 Nov 2013 12:21:38 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ac6976255076d4bf761abfbecb19d46af5b88046@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383291195-24386-2-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Show single option when failed to parse
Git-Commit-ID: ac6976255076d4bf761abfbecb19d46af5b88046
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:21:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac6976255076d4bf761abfbecb19d46af5b88046
Gitweb:     http://git.kernel.org/tip/ac6976255076d4bf761abfbecb19d46af5b88046
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 1 Nov 2013 16:33:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:51:45 -0300

perf tools: Show single option when failed to parse

Current option parser outputs whole option help string when it failed to
parse an option.  However this is not good for user if the command has
many option, she might feel hard which one is related easily.

Fix it by just showing the help message of the given option only.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Requested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383291195-24386-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c | 217 ++++++++++++++++++++++++----------------
 tools/perf/util/parse-options.h |   4 +-
 2 files changed, 132 insertions(+), 89 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 2bc9e70..1caf7b9 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -339,10 +339,10 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		if (arg[1] != '-') {
 			ctx->opt = arg + 1;
 			if (internal_help && *ctx->opt == 'h')
-				return parse_options_usage(usagestr, options);
+				return usage_with_options_internal(usagestr, options, 0);
 			switch (parse_short_opt(ctx, options)) {
 			case -1:
-				return parse_options_usage(usagestr, options);
+				return parse_options_usage(usagestr, options, arg + 1, 1);
 			case -2:
 				goto unknown;
 			default:
@@ -352,10 +352,11 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 				check_typos(arg + 1, options);
 			while (ctx->opt) {
 				if (internal_help && *ctx->opt == 'h')
-					return parse_options_usage(usagestr, options);
+					return usage_with_options_internal(usagestr, options, 0);
+				arg = ctx->opt;
 				switch (parse_short_opt(ctx, options)) {
 				case -1:
-					return parse_options_usage(usagestr, options);
+					return parse_options_usage(usagestr, options, arg, 1);
 				case -2:
 					/* fake a short option thing to hide the fact that we may have
 					 * started to parse aggregated stuff
@@ -383,12 +384,12 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		if (internal_help && !strcmp(arg + 2, "help-all"))
 			return usage_with_options_internal(usagestr, options, 1);
 		if (internal_help && !strcmp(arg + 2, "help"))
-			return parse_options_usage(usagestr, options);
+			return usage_with_options_internal(usagestr, options, 0);
 		if (!strcmp(arg + 2, "list-opts"))
 			return PARSE_OPT_LIST;
 		switch (parse_long_opt(ctx, arg + 2, options)) {
 		case -1:
-			return parse_options_usage(usagestr, options);
+			return parse_options_usage(usagestr, options, arg + 2, 0);
 		case -2:
 			goto unknown;
 		default:
@@ -445,6 +446,89 @@ int parse_options(int argc, const char **argv, const struct option *options,
 #define USAGE_OPTS_WIDTH 24
 #define USAGE_GAP         2
 
+static void print_option_help(const struct option *opts, int full)
+{
+	size_t pos;
+	int pad;
+
+	if (opts->type == OPTION_GROUP) {
+		fputc('\n', stderr);
+		if (*opts->help)
+			fprintf(stderr, "%s\n", opts->help);
+		return;
+	}
+	if (!full && (opts->flags & PARSE_OPT_HIDDEN))
+		return;
+
+	pos = fprintf(stderr, "    ");
+	if (opts->short_name)
+		pos += fprintf(stderr, "-%c", opts->short_name);
+	else
+		pos += fprintf(stderr, "    ");
+
+	if (opts->long_name && opts->short_name)
+		pos += fprintf(stderr, ", ");
+	if (opts->long_name)
+		pos += fprintf(stderr, "--%s", opts->long_name);
+
+	switch (opts->type) {
+	case OPTION_ARGUMENT:
+		break;
+	case OPTION_LONG:
+	case OPTION_U64:
+	case OPTION_INTEGER:
+	case OPTION_UINTEGER:
+		if (opts->flags & PARSE_OPT_OPTARG)
+			if (opts->long_name)
+				pos += fprintf(stderr, "[=<n>]");
+			else
+				pos += fprintf(stderr, "[<n>]");
+		else
+			pos += fprintf(stderr, " <n>");
+		break;
+	case OPTION_CALLBACK:
+		if (opts->flags & PARSE_OPT_NOARG)
+			break;
+		/* FALLTHROUGH */
+	case OPTION_STRING:
+		if (opts->argh) {
+			if (opts->flags & PARSE_OPT_OPTARG)
+				if (opts->long_name)
+					pos += fprintf(stderr, "[=<%s>]", opts->argh);
+				else
+					pos += fprintf(stderr, "[<%s>]", opts->argh);
+			else
+				pos += fprintf(stderr, " <%s>", opts->argh);
+		} else {
+			if (opts->flags & PARSE_OPT_OPTARG)
+				if (opts->long_name)
+					pos += fprintf(stderr, "[=...]");
+				else
+					pos += fprintf(stderr, "[...]");
+			else
+				pos += fprintf(stderr, " ...");
+		}
+		break;
+	default: /* OPTION_{BIT,BOOLEAN,SET_UINT,SET_PTR} */
+	case OPTION_END:
+	case OPTION_GROUP:
+	case OPTION_BIT:
+	case OPTION_BOOLEAN:
+	case OPTION_INCR:
+	case OPTION_SET_UINT:
+	case OPTION_SET_PTR:
+		break;
+	}
+
+	if (pos <= USAGE_OPTS_WIDTH)
+		pad = USAGE_OPTS_WIDTH - pos;
+	else {
+		fputc('\n', stderr);
+		pad = USAGE_OPTS_WIDTH;
+	}
+	fprintf(stderr, "%*s%s\n", pad + USAGE_GAP, "", opts->help);
+}
+
 int usage_with_options_internal(const char * const *usagestr,
 				const struct option *opts, int full)
 {
@@ -464,87 +548,9 @@ int usage_with_options_internal(const char * const *usagestr,
 	if (opts->type != OPTION_GROUP)
 		fputc('\n', stderr);
 
-	for (; opts->type != OPTION_END; opts++) {
-		size_t pos;
-		int pad;
-
-		if (opts->type == OPTION_GROUP) {
-			fputc('\n', stderr);
-			if (*opts->help)
-				fprintf(stderr, "%s\n", opts->help);
-			continue;
-		}
-		if (!full && (opts->flags & PARSE_OPT_HIDDEN))
-			continue;
-
-		pos = fprintf(stderr, "    ");
-		if (opts->short_name)
-			pos += fprintf(stderr, "-%c", opts->short_name);
-		else
-			pos += fprintf(stderr, "    ");
-
-		if (opts->long_name && opts->short_name)
-			pos += fprintf(stderr, ", ");
-		if (opts->long_name)
-			pos += fprintf(stderr, "--%s", opts->long_name);
+	for (  ; opts->type != OPTION_END; opts++)
+		print_option_help(opts, full);
 
-		switch (opts->type) {
-		case OPTION_ARGUMENT:
-			break;
-		case OPTION_LONG:
-		case OPTION_U64:
-		case OPTION_INTEGER:
-		case OPTION_UINTEGER:
-			if (opts->flags & PARSE_OPT_OPTARG)
-				if (opts->long_name)
-					pos += fprintf(stderr, "[=<n>]");
-				else
-					pos += fprintf(stderr, "[<n>]");
-			else
-				pos += fprintf(stderr, " <n>");
-			break;
-		case OPTION_CALLBACK:
-			if (opts->flags & PARSE_OPT_NOARG)
-				break;
-			/* FALLTHROUGH */
-		case OPTION_STRING:
-			if (opts->argh) {
-				if (opts->flags & PARSE_OPT_OPTARG)
-					if (opts->long_name)
-						pos += fprintf(stderr, "[=<%s>]", opts->argh);
-					else
-						pos += fprintf(stderr, "[<%s>]", opts->argh);
-				else
-					pos += fprintf(stderr, " <%s>", opts->argh);
-			} else {
-				if (opts->flags & PARSE_OPT_OPTARG)
-					if (opts->long_name)
-						pos += fprintf(stderr, "[=...]");
-					else
-						pos += fprintf(stderr, "[...]");
-				else
-					pos += fprintf(stderr, " ...");
-			}
-			break;
-		default: /* OPTION_{BIT,BOOLEAN,SET_UINT,SET_PTR} */
-		case OPTION_END:
-		case OPTION_GROUP:
-		case OPTION_BIT:
-		case OPTION_BOOLEAN:
-		case OPTION_INCR:
-		case OPTION_SET_UINT:
-		case OPTION_SET_PTR:
-			break;
-		}
-
-		if (pos <= USAGE_OPTS_WIDTH)
-			pad = USAGE_OPTS_WIDTH - pos;
-		else {
-			fputc('\n', stderr);
-			pad = USAGE_OPTS_WIDTH;
-		}
-		fprintf(stderr, "%*s%s\n", pad + USAGE_GAP, "", opts->help);
-	}
 	fputc('\n', stderr);
 
 	return PARSE_OPT_HELP;
@@ -559,9 +565,44 @@ void usage_with_options(const char * const *usagestr,
 }
 
 int parse_options_usage(const char * const *usagestr,
-			const struct option *opts)
+			const struct option *opts,
+			const char *optstr, bool short_opt)
 {
-	return usage_with_options_internal(usagestr, opts, 0);
+	if (!usagestr)
+		return PARSE_OPT_HELP;
+
+	fprintf(stderr, "\n usage: %s\n", *usagestr++);
+	while (*usagestr && **usagestr)
+		fprintf(stderr, "    or: %s\n", *usagestr++);
+	while (*usagestr) {
+		fprintf(stderr, "%s%s\n",
+				**usagestr ? "    " : "",
+				*usagestr);
+		usagestr++;
+	}
+	fputc('\n', stderr);
+
+	for (  ; opts->type != OPTION_END; opts++) {
+		if (short_opt) {
+			if (opts->short_name == *optstr)
+				break;
+			continue;
+		}
+
+		if (opts->long_name == NULL)
+			continue;
+
+		if (!prefixcmp(optstr, opts->long_name))
+			break;
+		if (!prefixcmp(optstr, "no-") &&
+		    !prefixcmp(optstr + 3, opts->long_name))
+			break;
+	}
+
+	if (opts->type != OPTION_END)
+		print_option_help(opts, 0);
+
+	return PARSE_OPT_HELP;
 }
 
 
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 7bb5999..b0241e2 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -158,7 +158,9 @@ struct parse_opt_ctx_t {
 };
 
 extern int parse_options_usage(const char * const *usagestr,
-			       const struct option *opts);
+			       const struct option *opts,
+			       const char *optstr,
+			       bool short_opt);
 
 extern void parse_options_start(struct parse_opt_ctx_t *ctx,
 				int argc, const char **argv, int flags);
