Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbaJ3Gov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:44:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553AbaJ3Gos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:44:48 -0400
Date: Wed, 29 Oct 2014 23:43:55 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d152d1be5962ace0706066db71b4f05dff8764eb@git.kernel.org>
Cc: namhyung@kernel.org, yarygin@linux.vnet.ibm.com, hemant@linux.vnet.ibm.com,
        mingo@kernel.org, acme@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dsahern@gmail.com,
        masami.hiramatsu.pt@hitachi.com, peterz@infradead.org,
        jolsa@redhat.com, hpa@zytor.com
Reply-To: masami.hiramatsu.pt@hitachi.com, peterz@infradead.org,
        jolsa@redhat.com, hpa@zytor.com, namhyung@kernel.org,
        yarygin@linux.vnet.ibm.com, hemant@linux.vnet.ibm.com, acme@redhat.com,
        mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        dsahern@gmail.com
In-Reply-To: <1413990949-13953-2-git-send-email-namhyung@kernel.org>
References: <1413990949-13953-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add PARSE_OPT_DISABLED flag
Git-Commit-ID: d152d1be5962ace0706066db71b4f05dff8764eb
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

Commit-ID:  d152d1be5962ace0706066db71b4f05dff8764eb
Gitweb:     http://git.kernel.org/tip/d152d1be5962ace0706066db71b4f05dff8764eb
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 23 Oct 2014 00:15:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:47 -0200

perf tools: Add PARSE_OPT_DISABLED flag

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
index bf48092..b601610 100644
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
index b59ba85..b7c80db 100644
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
