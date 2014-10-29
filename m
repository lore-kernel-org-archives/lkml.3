Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaJ2OHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:07:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:41137 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906AbaJ2OHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:39 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/25] perf tools: Add PARSE_OPT_DISABLED flag
Date: Wed, 29 Oct 2014 12:06:20 -0200
Message-Id: <1414591597-2763-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

In some cases, we need to reuse exising options with some of them
disabled.  To do that, add PARSE_OPT_DISABLED flag and
set_option_flag() function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1413990949-13953-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c | 17 +++++++++++++++++
 tools/perf/util/parse-options.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index bf48092983c6..b6016101b40b 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -42,6 +42,8 @@ static int get_value(struct parse_opt_ctx_t *p,
 		return opterror(opt, "takes no value", flags);
 	if (unset && (opt->flags & PARSE_OPT_NONEG))
 		return opterror(opt, "isn't available", flags);
+	if (opt->flags & PARSE_OPT_DISABLED)
+		return opterror(opt, "is not usable", flags);
 
 	if (!(flags & OPT_SHORT) && p->opt) {
 		switch (opt->type) {
@@ -509,6 +511,8 @@ static void print_option_help(const struct option *opts, int full)
 	}
 	if (!full && (opts->flags & PARSE_OPT_HIDDEN))
 		return;
+	if (opts->flags & PARSE_OPT_DISABLED)
+		return;
 
 	pos = fprintf(stderr, "    ");
 	if (opts->short_name)
@@ -679,3 +683,16 @@ int parse_opt_verbosity_cb(const struct option *opt,
 	}
 	return 0;
 }
+
+void set_option_flag(struct option *opts, int shortopt, const char *longopt,
+		     int flag)
+{
+	for (; opts->type != OPTION_END; opts++) {
+		if ((shortopt && opts->short_name == shortopt) ||
+		    (opts->long_name && longopt &&
+		     !strcmp(opts->long_name, longopt))) {
+			opts->flags |= flag;
+			break;
+		}
+	}
+}
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index b59ba858e73d..b7c80dbc7627 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -38,6 +38,7 @@ enum parse_opt_option_flags {
 	PARSE_OPT_NONEG   = 4,
 	PARSE_OPT_HIDDEN  = 8,
 	PARSE_OPT_LASTARG_DEFAULT = 16,
+	PARSE_OPT_DISABLED = 32,
 };
 
 struct option;
@@ -211,4 +212,5 @@ extern int parse_opt_verbosity_cb(const struct option *, const char *, int);
 
 extern const char *parse_options_fix_filename(const char *prefix, const char *file);
 
+void set_option_flag(struct option *opts, int sopt, const char *lopt, int flag);
 #endif /* __PERF_PARSE_OPTIONS_H */
-- 
1.9.3

