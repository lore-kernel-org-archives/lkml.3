Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab3HNSZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34383 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab3HNSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/21] perf trace: Allow specifying which syscalls to trace
Date: Wed, 14 Aug 2013 15:25:15 -0300
Message-Id: <1376504715-28107-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Similar to -e in strace, i.e. a comma separated list of syscall names
to trace.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5zku7q5wug3103k1dzn3yy63@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  4 +++
 tools/perf/builtin-trace.c              | 52 +++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 68718cc..3b3552a 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -26,6 +26,10 @@ OPTIONS
 --all-cpus::
         System-wide collection from all CPUs.
 
+-e::
+--expr::
+	List of events to show, currently only syscall names.
+
 -p::
 --pid=::
 	Record events on existing process ID (comma separated list).
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index da7ae01..120fdfb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -5,6 +5,7 @@
 #include "util/machine.h"
 #include "util/thread.h"
 #include "util/parse-options.h"
+#include "util/strlist.h"
 #include "util/thread_map.h"
 
 #include <libaudit.h>
@@ -47,6 +48,7 @@ static struct syscall_fmt *syscall_fmt__find(const char *name)
 struct syscall {
 	struct event_format *tp_format;
 	const char	    *name;
+	bool		    filtered;
 	struct syscall_fmt  *fmt;
 };
 
@@ -110,6 +112,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	struct strlist		*ev_qualifier;
 	unsigned long		nr_events;
 	bool			sched;
 	bool			multiple_threads;
@@ -226,6 +229,16 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 
 	sc = trace->syscalls.table + id;
 	sc->name = name;
+
+	if (trace->ev_qualifier && !strlist__find(trace->ev_qualifier, name)) {
+		sc->filtered = true;
+		/*
+ 		 * No need to do read tracepoint information since this will be
+ 		 * filtered out.
+ 		 */
+		return 0;
+	}
+
 	sc->fmt  = syscall_fmt__find(sc->name);
 
 	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
@@ -302,11 +315,19 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	char *msg;
 	void *args;
 	size_t printed = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread;
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
-	struct thread_trace *ttrace = thread__trace(thread);
+	struct thread_trace *ttrace;
+
+	if (sc == NULL)
+		return -1;
 
-	if (ttrace == NULL || sc == NULL)
+	if (sc->filtered)
+		return 0;
+
+	thread = machine__findnew_thread(&trace->host, sample->tid);
+	ttrace = thread__trace(thread);
+	if (ttrace == NULL)
 		return -1;
 
 	args = perf_evsel__rawptr(evsel, sample, "args");
@@ -345,11 +366,19 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 {
 	int ret;
 	u64 duration = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
-	struct thread_trace *ttrace = thread__trace(thread);
+	struct thread *thread;
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	struct thread_trace *ttrace;
+
+	if (sc == NULL)
+		return -1;
 
-	if (ttrace == NULL || sc == NULL)
+	if (sc->filtered)
+		return 0;
+
+	thread = machine__findnew_thread(&trace->host, sample->tid);
+	ttrace = thread__trace(thread);
+	if (ttrace == NULL)
 		return -1;
 
 	ret = perf_evsel__intval(evsel, sample, "ret");
@@ -634,7 +663,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.mmap_pages    = 1024,
 		},
 	};
+	const char *ev_qualifier_str = NULL;
 	const struct option trace_options[] = {
+	OPT_STRING('e', "expr", &ev_qualifier_str, "expr",
+		    "list of events to trace"),
 	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
 		    "trace events on existing process id"),
 	OPT_STRING(0, "tid", &trace.opts.target.tid, "tid",
@@ -660,6 +692,14 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
+	if (ev_qualifier_str != NULL) {
+		trace.ev_qualifier = strlist__new(true, ev_qualifier_str);
+		if (trace.ev_qualifier == NULL) {
+			puts("Not enough memory to parse event qualifier");
+			return -ENOMEM;
+		}
+	}
+
 	err = perf_target__validate(&trace.opts.target);
 	if (err) {
 		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
-- 
1.8.1.4

