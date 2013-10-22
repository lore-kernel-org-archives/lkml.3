Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3JVO3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53890 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3JVO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/26] perf trace: Use vfs_getname hook if available
Date: Tue, 22 Oct 2013 11:28:11 -0300
Message-Id: <1382452114-1243-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Initially it tries to find a probe:vfs_getname that should be setup
with:

 perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'

or with slight changes to cope with code flux in the getname_flags code.

In the future, if a "vfs:getname" tracepoint becomes available, then it
will be preferred.

This is not strictly required and more expensive method of reading the
/proc/pid/fd/ symlink will be used when the fd->path array entry is not
populated by a previous vfs_getname + open syscall ret sequence.

As with any other 'perf probe' probe the setup must be done just once
and the probe will be left inactive, waiting for users, be it 'perf
trace' of any other tool.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ujg8se8glq5izmu8cdkq15po@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  4 ++
 tools/perf/builtin-trace.c              | 83 ++++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 54139c6457f8..7b0497f95a75 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -97,6 +97,10 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Show a summary of syscalls by thread with min, max, and average times (in
     msec) and relative stddev.
 
+--tool_stats::
+	Show tool stats such as number of times fd->pathname was discovered thru
+	hooking the open syscall return + vfs_getname or via reading /proc/pid/fd, etc.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 763bef45afad..86d2b1f2399c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -951,7 +951,10 @@ fail:
 
 struct trace {
 	struct perf_tool	tool;
-	int			audit_machine;
+	struct {
+		int		machine;
+		int		open_id;
+	}			audit;
 	struct {
 		int		max;
 		struct syscall  *table;
@@ -965,14 +968,19 @@ struct trace {
 	struct strlist		*ev_qualifier;
 	bool			not_ev_qualifier;
 	bool			live;
+	const char 		*last_vfs_getname;
 	struct intlist		*tid_list;
 	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
 	bool			summary;
 	bool			show_comm;
+	bool			show_tool_stats;
 	double			duration_filter;
 	double			runtime_ms;
+	struct {
+		u64		vfs_getname, proc_getname;
+	} stats;
 };
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
@@ -1027,7 +1035,8 @@ static int thread__read_fd_path(struct thread *thread, int fd)
 	return trace__set_fd_pathname(thread, fd, pathname);
 }
 
-static const char *thread__fd_path(struct thread *thread, int fd, bool live)
+static const char *thread__fd_path(struct thread *thread, int fd,
+				   struct trace *trace)
 {
 	struct thread_trace *ttrace = thread->priv;
 
@@ -1037,9 +1046,13 @@ static const char *thread__fd_path(struct thread *thread, int fd, bool live)
 	if (fd < 0)
 		return NULL;
 
-	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL) &&
-	    (!live || thread__read_fd_path(thread, fd)))
-		return NULL;
+	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL))
+		if (!trace->live)
+			return NULL;
+		++trace->stats.proc_getname;
+		if (thread__read_fd_path(thread, fd)) {
+			return NULL;
+	}
 
 	return ttrace->paths.table[fd];
 }
@@ -1049,7 +1062,7 @@ static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 {
 	int fd = arg->val;
 	size_t printed = scnprintf(bf, size, "%d", fd);
-	const char *path = thread__fd_path(arg->thread, fd, arg->trace->live);
+	const char *path = thread__fd_path(arg->thread, fd, arg->trace);
 
 	if (path)
 		printed += scnprintf(bf + printed, size - printed, "<%s>", path);
@@ -1186,7 +1199,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
 	struct syscall *sc;
-	const char *name = audit_syscall_to_name(id, trace->audit_machine);
+	const char *name = audit_syscall_to_name(id, trace->audit.machine);
 
 	if (name == NULL)
 		return -1;
@@ -1450,6 +1463,12 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 
 	ret = perf_evsel__intval(evsel, sample, "ret");
 
+	if (id == trace->audit.open_id && ret >= 0 && trace->last_vfs_getname) {
+		trace__set_fd_pathname(thread, ret, trace->last_vfs_getname);
+		trace->last_vfs_getname = NULL;
+		++trace->stats.vfs_getname;
+	}
+
 	ttrace = thread->priv;
 
 	ttrace->exit_time = sample->time;
@@ -1494,6 +1513,13 @@ out:
 	return 0;
 }
 
+static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
+			      struct perf_sample *sample)
+{
+	trace->last_vfs_getname = perf_evsel__rawptr(evsel, sample, "pathname");
+	return 0;
+}
+
 static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evsel,
 				     struct perf_sample *sample)
 {
@@ -1616,6 +1642,22 @@ static int trace__record(int argc, const char **argv)
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
 
+static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("probe", "vfs_getname",
+						     evlist->nr_entries);
+	if (evsel == NULL)
+		return;
+
+	if (perf_evsel__field(evsel, "pathname") == NULL) {
+		perf_evsel__delete(evsel);
+		return;
+	}
+
+	evsel->handler.func = trace__vfs_getname;
+	perf_evlist__add(evlist, evsel);
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1635,6 +1677,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit))
 		goto out_error_tp;
 
+	perf_evlist__add_vfs_getname(evlist);
+
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				trace__sched_stat_runtime))
@@ -1741,12 +1785,22 @@ again:
 
 	if (done)
 		perf_evlist__disable(evlist);
-
-	goto again;
+	else
+		goto again;
 
 out_unmap_evlist:
-	if (!err && trace->summary)
-		trace__fprintf_thread_summary(trace, trace->output);
+	if (!err) {
+		if (trace->summary)
+			trace__fprintf_thread_summary(trace, trace->output);
+
+		if (trace->show_tool_stats) {
+			fprintf(trace->output, "Stats:\n "
+					       " vfs_getname : %" PRIu64 "\n"
+					       " proc_getname: %" PRIu64 "\n",
+				trace->stats.vfs_getname,
+				trace->stats.proc_getname);
+		}
+	}
 
 	perf_evlist__munmap(evlist);
 out_close_evlist:
@@ -1788,6 +1842,7 @@ static int trace__replay(struct trace *trace)
 	const struct perf_evsel_str_handler handlers[] = {
 		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
 		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
+		{ "probe:vfs_getname",	     trace__vfs_getname, },
 	};
 
 	struct perf_session *session;
@@ -1997,7 +2052,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 	struct trace trace = {
-		.audit_machine = audit_detect_machine(),
+		.audit = {
+			.machine = audit_detect_machine(),
+			.open_id = audit_name_to_syscall("open", trace.audit.machine),
+		},
 		.syscalls = {
 			. max = -1,
 		},
@@ -2019,6 +2077,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	const struct option trace_options[] = {
 	OPT_BOOLEAN(0, "comm", &trace.show_comm,
 		    "show the thread COMM next to its id"),
+	OPT_BOOLEAN(0, "tool_stats", &trace.show_tool_stats, "show tool stats"),
 	OPT_STRING('e', "expr", &ev_qualifier_str, "expr",
 		    "list of events to trace"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
-- 
1.8.1.4

