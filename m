Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3HaIQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:16:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3HaIP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:57 -0400
Date: Sat, 31 Aug 2013 01:15:16 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-6810fc915f7a89d8134edb3996dbbf8eac386c26@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1377750593-48046-3-git-send-email-dsahern@gmail.com>
References: <1377750593-48046-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add option to analyze events in a file versus live
Git-Commit-ID: 6810fc915f7a89d8134edb3996dbbf8eac386c26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:15:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6810fc915f7a89d8134edb3996dbbf8eac386c26
Gitweb:     http://git.kernel.org/tip/6810fc915f7a89d8134edb3996dbbf8eac386c26
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 28 Aug 2013 22:29:52 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 17:42:34 -0300

perf trace: Add option to analyze events in a file versus live

Allows capture of raw_syscall:* events and analyzed at a later time.

v2: change -i option from inherit to input name for consistency with
    other perf commands

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377750593-48046-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  4 ++
 tools/perf/builtin-trace.c              | 98 ++++++++++++++++++++++++++++++++-
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index fe19811..daccd2c 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -74,6 +74,10 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --sched:
 	Accrue thread runtime and provide a summary at the end of the session.
 
+-i
+--input
+	Process events from a given perf data file.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 88387c5..2a6ebe1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -4,6 +4,7 @@
 #include "util/debug.h"
 #include "util/evlist.h"
 #include "util/machine.h"
+#include "util/session.h"
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/strlist.h"
@@ -652,6 +653,36 @@ out_dump:
 	return 0;
 }
 
+static int trace__process_sample(struct perf_tool *tool,
+				 union perf_event *event __maybe_unused,
+				 struct perf_sample *sample,
+				 struct perf_evsel *evsel,
+				 struct machine *machine __maybe_unused)
+{
+	struct trace *trace = container_of(tool, struct trace, tool);
+	int err = 0;
+
+	tracepoint_handler handler = evsel->handler.func;
+
+	if (trace->base_time == 0)
+		trace->base_time = sample->time;
+
+	if (handler)
+		handler(trace, evsel, sample);
+
+	return err;
+}
+
+static bool
+perf_session__has_tp(struct perf_session *session, const char *name)
+{
+	struct perf_evsel *evsel;
+
+	evsel = perf_evlist__find_tracepoint_by_name(session->evlist, name);
+
+	return evsel != NULL;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -791,6 +822,65 @@ out:
 	return err;
 }
 
+static int trace__replay(struct trace *trace)
+{
+	const struct perf_evsel_str_handler handlers[] = {
+		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
+		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
+	};
+
+	struct perf_session *session;
+	int err = -1;
+
+	trace->tool.sample	  = trace__process_sample;
+	trace->tool.mmap	  = perf_event__process_mmap;
+	trace->tool.comm	  = perf_event__process_comm;
+	trace->tool.exit	  = perf_event__process_exit;
+	trace->tool.fork	  = perf_event__process_fork;
+	trace->tool.attr	  = perf_event__process_attr;
+	trace->tool.tracing_data = perf_event__process_tracing_data;
+	trace->tool.build_id	  = perf_event__process_build_id;
+
+	trace->tool.ordered_samples = true;
+	trace->tool.ordering_requires_timestamps = true;
+
+	/* add tid to output */
+	trace->multiple_threads = true;
+
+	if (symbol__init() < 0)
+		return -1;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false,
+				    &trace->tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	err = perf_session__set_tracepoints_handlers(session, handlers);
+	if (err)
+		goto out;
+
+	if (!perf_session__has_tp(session, "raw_syscalls:sys_enter")) {
+		pr_err("Data file does not have raw_syscalls:sys_enter events\n");
+		goto out;
+	}
+
+	if (!perf_session__has_tp(session, "raw_syscalls:sys_exit")) {
+		pr_err("Data file does not have raw_syscalls:sys_exit events\n");
+		goto out;
+	}
+
+	setup_pager();
+
+	err = perf_session__process_events(session, &trace->tool);
+	if (err)
+		pr_err("Failed to process events, error %d", err);
+
+out:
+	perf_session__delete(session);
+
+	return err;
+}
+
 static size_t trace__fprintf_threads_header(FILE *fp)
 {
 	size_t printed;
@@ -892,6 +982,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('e', "expr", &ev_qualifier_str, "expr",
 		    "list of events to trace"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
+	OPT_STRING('i', "input", &input_name, "file", "Analyze events in file"),
 	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
 		    "trace events on existing process id"),
 	OPT_STRING('t', "tid", &trace.opts.target.tid, "tid",
@@ -900,7 +991,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &trace.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
-	OPT_BOOLEAN('i', "no-inherit", &trace.opts.no_inherit,
+	OPT_BOOLEAN(0, "no-inherit", &trace.opts.no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_UINTEGER('m', "mmap-pages", &trace.opts.mmap_pages,
 		     "number of mmap data pages"),
@@ -958,7 +1049,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc && perf_target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
-	err = trace__run(&trace, argc, argv);
+	if (input_name)
+		err = trace__replay(&trace);
+	else
+		err = trace__run(&trace, argc, argv);
 
 	if (trace.sched && !err)
 		trace__fprintf_thread_summary(&trace, trace.output);
