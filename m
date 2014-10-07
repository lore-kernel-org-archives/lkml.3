Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaJGILJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:11:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33277 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaJGIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:10:36 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 1/3] perf tools: Add PARSE_OPT_DISABLED flag
Date: Tue,  7 Oct 2014 17:10:30 +0900
Message-Id: <1412669432-14833-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, we need to reuse exising options with some of them
disabled.  To do that, add PARSE_OPT_DISABLED flag and
set_option_flag() function.

Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
2.1.2

