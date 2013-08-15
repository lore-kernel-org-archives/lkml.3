Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676Ab3HOH6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:58:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3HOH6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:58:40 -0400
Date: Thu, 15 Aug 2013 00:58:02 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-5zku7q5wug3103k1dzn3yy63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Allow specifying which syscalls to trace
Git-Commit-ID: 2ae3a312c0ccd8ff615372f00aab1700aac27474
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:58:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ae3a312c0ccd8ff615372f00aab1700aac27474
Gitweb:     http://git.kernel.org/tip/2ae3a312c0ccd8ff615372f00aab1700aac27474
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Aug 2013 12:28:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Aug 2013 11:44:21 -0300

perf trace: Allow specifying which syscalls to trace

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
