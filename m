Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3JPFBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:01:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62800 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3JPFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:30 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-40-525e1d68d51a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 18/18] perf ftrace: Add --filter option
Date: Wed, 16 Oct 2013 14:00:21 +0900
Message-Id: <1381899621-14638-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --filter (-l) option is for filtering specific functions.  If this
option is given, only these (and their children) functions will be
shown in the output.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-ftrace.txt |  5 +++
 tools/perf/builtin-ftrace.c              | 55 ++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/tools/perf/Documentation/perf-ftrace.txt b/tools/perf/Documentation/perf-ftrace.txt
index 841699f3924d..b0ae286d3e28 100644
--- a/tools/perf/Documentation/perf-ftrace.txt
+++ b/tools/perf/Documentation/perf-ftrace.txt
@@ -50,6 +50,11 @@ OPTIONS
 	tracer in system and outputs trace result directly from the
 	ftrace's trace_pipe.
 
+-l::
+--filter=::
+	Filter given functions to suppress others in the output.
+	Used by 'live' and 'record' subcommands only.
+
 -p::
 --pid=::
 	Record events on existing process ID (comma separated list).
diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 6720d560d6f8..17f37c273b1b 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -22,6 +22,7 @@
 #include "util/thread_map.h"
 #include "util/cpumap.h"
 #include "util/sort.h"
+#include "util/strlist.h"
 #include "util/trace-event.h"
 #include "../lib/traceevent/kbuffer.h"
 #include "../lib/traceevent/event-parse.h"
@@ -36,6 +37,7 @@ struct perf_ftrace {
 	const char *tracer;
 	const char *dirname;
 	const char *clock;
+	struct strlist *filter;
 	struct pevent *pevent;
 	bool show_full_info;
 };
@@ -118,6 +120,12 @@ static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 	if (write_tracing_file("trace_clock", "local") < 0)
 		return -1;
 
+	if (write_tracing_file("set_ftrace_filter", " ") < 0)
+		return -1;
+
+	if (write_tracing_file("set_graph_function", " ") < 0)
+		return -1;
+
 	return 0;
 }
 
@@ -210,6 +218,28 @@ static int set_tracing_clock(struct perf_ftrace *ftrace)
 	return write_tracing_file("trace_clock", "local");
 }
 
+static int set_tracing_filter(struct perf_ftrace *ftrace)
+{
+	const char *filter_file;
+	struct str_node *func;
+
+	if (ftrace->filter == NULL)
+		return 0;
+
+	if (!strcmp(ftrace->tracer, "function_graph"))
+		filter_file = "set_graph_function";
+	else if (!strcmp(ftrace->tracer, "function"))
+		filter_file = "set_ftrace_filter";
+	else
+		return 0;
+
+	strlist__for_each(func, ftrace->filter) {
+		if (append_tracing_file(filter_file, func->s) < 0)
+			return -1;
+	}
+	return 0;
+}
+
 static int setup_tracing_files(struct perf_ftrace *ftrace)
 {
 	int ret = -1;
@@ -240,6 +270,11 @@ static int setup_tracing_files(struct perf_ftrace *ftrace)
 		goto out;
 	}
 
+	if (set_tracing_filter(ftrace) < 0) {
+		pr_err("failed to set ftrace filter\n");
+		goto out;
+	}
+
 	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
 		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
 		goto out;
@@ -1596,6 +1631,22 @@ static void ftrace_teardown(struct perf_ftrace *ftrace)
 {
 	perf_evlist__delete_maps(ftrace->evlist);
 	perf_evlist__delete(ftrace->evlist);
+	strlist__delete(ftrace->filter);
+}
+
+static int function_filters(const struct option *opt, const char *str,
+			    int unset __maybe_unused)
+{
+	struct perf_ftrace *ftrace = opt->value;
+
+	if (ftrace->filter == NULL) {
+		ftrace->filter = strlist__new(true, NULL);
+		if (ftrace->filter == NULL)
+			return -ENOMEM;
+	}
+
+	strlist__parse_list(ftrace->filter, str);
+	return 0;
 }
 
 static int
@@ -1610,6 +1661,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 	const struct option live_options[] = {
 	OPT_STRING('t', "tracer", &ftrace->tracer, "tracer",
 		   "tracer to use: function_graph or function"),
+	OPT_CALLBACK('l', "filter", ftrace, "function[,function,...]",
+		     "show only these functions in the trace", function_filters),
 	OPT_STRING('p', "pid", &ftrace->target.pid, "pid",
 		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
@@ -1652,6 +1705,8 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
 	const struct option record_options[] = {
 	OPT_STRING('t', "tracer", &ftrace->tracer, "tracer",
 		   "tracer to use: function_graph or function"),
+	OPT_CALLBACK('l', "filter", ftrace, "function[,function,...]",
+		     "show only these functions in the trace", function_filters),
 	OPT_STRING('p', "pid", &ftrace->target.pid, "pid",
 		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
-- 
1.7.11.7

