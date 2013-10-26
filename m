Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3JZO0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:26:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3JZO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:26:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/4] perf tools: Split -g and --call-graph for record command
Date: Sat, 26 Oct 2013 16:25:33 +0200
Message-Id: <1382797536-32303-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-1-git-send-email-jolsa@redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitting -g and --call-graph for record command, so we could
use '-g' with no option.

The '-g' option now takes NO argument and enables the configured
unwind method, which is currently the frame pointers method.

It will be possible to configure unwind method via config
file in upcoming patches.

All current '-g' arguments is overtaken by --call-graph option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt |  6 ++-
 tools/perf/builtin-record.c              | 71 ++++++++++++++++++++++----------
 tools/perf/util/callchain.h              |  3 ++
 3 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index f10ab63..7be62770 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -92,8 +92,12 @@ OPTIONS
 	size is rounded up to have nearest pages power of two value.
 
 -g::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-	Do call-graph (stack chain/backtrace) recording.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -g.
+
 
 -q::
 --quiet::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ab8d15e..27622bb 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -678,21 +678,12 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* HAVE_LIBUNWIND_SUPPORT */
 
-int record_parse_callchain_opt(const struct option *opt,
-			       const char *arg, int unset)
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts)
 {
-	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
 	int ret = -1;
 
-	/* --no-call-graph */
-	if (unset)
-		return 0;
-
-	/* We specified default option if none is provided. */
-	BUG_ON(!arg);
-
 	/* We need buffer that we know we can write to. */
 	buf = malloc(strlen(arg) + 1);
 	if (!buf)
@@ -730,10 +721,6 @@ int record_parse_callchain_opt(const struct option *opt,
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-
-			if (!ret)
-				pr_debug("callchain: stack dump size %d\n",
-					 opts->stack_dump_size);
 #endif /* HAVE_LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
@@ -744,13 +731,52 @@ int record_parse_callchain_opt(const struct option *opt,
 	} while (0);
 
 	free(buf);
+	return ret;
+}
+
+static void callchain_debug(struct perf_record_opts *opts)
+{
+	pr_debug("callchain: type %d\n", opts->call_graph);
 
+	if (opts->call_graph == CALLCHAIN_DWARF)
+		pr_debug("callchain: stack dump size %d\n",
+			 opts->stack_dump_size);
+}
+
+int record_parse_callchain_opt(const struct option *opt,
+			       const char *arg,
+			       int unset)
+{
+	struct perf_record_opts *opts = opt->value;
+	int ret;
+
+	/* --no-call-graph */
+	if (unset) {
+		opts->call_graph = CALLCHAIN_NONE;
+		pr_debug("callchain: disabled\n");
+		return 0;
+	}
+
+	ret = record_parse_callchain(arg, opts);
 	if (!ret)
-		pr_debug("callchain: type %d\n", opts->call_graph);
+		callchain_debug(opts);
 
 	return ret;
 }
 
+int record_callchain_opt(const struct option *opt,
+			 const char *arg __maybe_unused,
+			 int unset __maybe_unused)
+{
+	struct perf_record_opts *opts = opt->value;
+
+	if (opts->call_graph == CALLCHAIN_NONE)
+		opts->call_graph = CALLCHAIN_FP;
+
+	callchain_debug(opts);
+	return 0;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -779,12 +805,12 @@ static struct perf_record record = {
 	},
 };
 
-#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+#define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
 #ifdef HAVE_LIBUNWIND_SUPPORT
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp";
 #endif
 
 /*
@@ -825,9 +851,12 @@ const struct option record_options[] = {
 		     perf_evlist__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &record_parse_callchain_opt, "fp"),
+	OPT_CALLBACK(0, "call-graph", &record.opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &record_parse_callchain_opt),
+	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
+			   NULL, "enables call-graph recording" ,
+			   &record_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7bb3602..4f7f989 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -146,6 +146,9 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 
 struct option;
 
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+int record_callchain_opt(const struct option *opt, const char *arg, int unset);
+
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.7.11.7

