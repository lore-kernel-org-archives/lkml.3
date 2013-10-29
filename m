Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3J2IXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:23:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3J2IXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:23:00 -0400
Date: Tue, 29 Oct 2013 01:22:14 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-09b0fd45ff63413df94cbd832a765076b201edbb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1382797536-32303-2-git-send-email-jolsa@redhat.com>
References: <1382797536-32303-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Split -g and --call-graph
Git-Commit-ID: 09b0fd45ff63413df94cbd832a765076b201edbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 01:22:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09b0fd45ff63413df94cbd832a765076b201edbb
Gitweb:     http://git.kernel.org/tip/09b0fd45ff63413df94cbd832a765076b201edbb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 26 Oct 2013 16:25:33 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Oct 2013 16:05:59 -0300

perf record: Split -g and --call-graph

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
index e297b74..ca0d3d9 100644
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
index a41ac415..d046514 100644
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
index 2b585bc..9e99060 100644
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
