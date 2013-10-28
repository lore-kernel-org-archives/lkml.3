Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3J1TRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:17:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58569 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3J1TRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:17:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf record: Split -g and --call-graph
Date: Mon, 28 Oct 2013 16:16:39 -0300
Message-Id: <1382987801-21896-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382987801-21896-1-git-send-email-acme@infradead.org>
References: <1382987801-21896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Splitting -g and --call-graph for record command, so we could use '-g'
with no option.

The '-g' option now takes NO argument and enables the configured unwind
method, which is currently the frame pointers method.

It will be possible to configure unwind method via config file in
upcoming patches.

All current '-g' arguments is overtaken by --call-graph option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: David Ahern <dsahern@gmail.com>
Tested-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382797536-32303-2-git-send-email-jolsa@redhat.com
[ reordered -g/--call-graph on --help and expanded the man page
  according to comments by David Ahern and Namhyung Kim ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt | 14 +++++-
 tools/perf/builtin-record.c              | 73 ++++++++++++++++++++++----------
 tools/perf/util/callchain.h              |  3 ++
 3 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e297b74471b8..ca0d3d9f4bac 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -90,8 +90,20 @@ OPTIONS
 	Number of mmap data pages. Must be a power of two.
 
 -g::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-	Do call-graph (stack chain/backtrace) recording.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -g.
+
+	Allows specifying "fp" (frame pointer) or "dwarf"
+	(DWARF's CFI - Call Frame Information) as the method to collect
+	the information used to show the call graphs.
+
+	In some systems, where binaries are build with gcc
+	--fomit-frame-pointer, using the "fp" method will produce bogus
+	call graphs, using "dwarf", if available (perf tools linked to
+	the libunwind library) should be used instead.
 
 -q::
 --quiet::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a41ac41546c9..d04651484640 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -712,21 +712,12 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
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
@@ -764,13 +755,9 @@ int record_parse_callchain_opt(const struct option *opt,
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-
-			if (!ret)
-				pr_debug("callchain: stack dump size %d\n",
-					 opts->stack_dump_size);
 #endif /* LIBUNWIND_SUPPORT */
 		} else {
-			pr_err("callchain: Unknown -g option "
+			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
 			break;
 		}
@@ -778,13 +765,52 @@ int record_parse_callchain_opt(const struct option *opt,
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
@@ -813,12 +839,12 @@ static struct perf_record record = {
 	},
 };
 
-#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+#define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
 #ifdef LIBUNWIND_SUPPORT
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp";
 #endif
 
 /*
@@ -858,9 +884,12 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &record_parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
+			   NULL, "enables call-graph recording" ,
+			   &record_callchain_opt),
+	OPT_CALLBACK(0, "call-graph", &record.opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &record_parse_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2b585bc308cf..9e99060408ae 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -147,6 +147,9 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 
 struct option;
 
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+int record_callchain_opt(const struct option *opt, const char *arg, int unset);
+
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.8.1.4

