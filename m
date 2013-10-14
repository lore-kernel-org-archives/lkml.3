Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3JNUSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:18:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39051 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab3JNUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 123/161] perf trace: Fix comm resolution when reading events from file
Date: Mon, 14 Oct 2013 17:01:52 -0300
Message-Id: <1381780950-25642-124-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Task comm's are getting lost when processing events from a file. The
problem is that the trace struct used by the live processing has its
host machine and the perf-session used for file based processing has its
host machine.  Fix by having both references point to the same machine.

Before:

     0.030 ( 0.001 ms): :27743/27743 brk( ...
     0.057 ( 0.004 ms): :27743/27743 mmap(len: 4096, prot: READ|WRITE, flags: ...
     0.075 ( 0.006 ms): :27743/27743 access(filename: 0x7f3809fbce00, mode: R ...
     0.091 ( 0.005 ms): :27743/27743 open(filename: 0x7f3809fba14c, flags: CLOEXEC ...
...

After:
     0.030 ( 0.001 ms): make/27743 brk( ...
     0.057 ( 0.004 ms): make/27743 mmap(len: 4096, prot: READ|WRITE, flags: ...
     0.075 ( 0.006 ms): make/27743 access(filename: 0x7f3809fbce00, mode: R ...
     0.091 ( 0.005 ms): make/27743 open(filename: 0x7f3809fba14c, flags: CLOEXEC ...
...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-4-git-send-email-dsahern@gmail.com
[ Moved creation of new host machine to a separate constructor: machine__new_host() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 25 +++++++++++++------------
 tools/perf/util/machine.c  | 17 +++++++++++++++++
 tools/perf/util/machine.h  |  1 +
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fcc157fce6c6..5776b5f829e1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -906,7 +906,7 @@ struct trace {
 		struct syscall  *table;
 	} syscalls;
 	struct perf_record_opts opts;
-	struct machine		host;
+	struct machine		*host;
 	u64			base_time;
 	bool			full_time;
 	FILE			*output;
@@ -1083,16 +1083,17 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	if (err)
 		return err;
 
-	machine__init(&trace->host, "", HOST_KERNEL_ID);
-	machine__create_kernel_maps(&trace->host);
+	trace->host = machine__new_host();
+	if (trace->host == NULL)
+		return -ENOMEM;
 
 	if (perf_target__has_task(&trace->opts.target)) {
 		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
 							trace__tool_process,
-							&trace->host);
+							trace->host);
 	} else {
 		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
-						     &trace->host);
+						     trace->host);
 	}
 
 	if (err)
@@ -1304,8 +1305,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->pid,
-					 sample->tid);
+	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
@@ -1357,8 +1357,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->pid,
-					 sample->tid);
+	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
@@ -1414,7 +1413,7 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host,
+	struct thread *thread = machine__findnew_thread(trace->host,
 							sample->pid,
 							sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread, trace->output);
@@ -1597,7 +1596,7 @@ again:
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(trace, &trace->host, event);
+				trace__process_event(trace, trace->host, event);
 				continue;
 			}
 
@@ -1681,6 +1680,8 @@ static int trace__replay(struct trace *trace)
 	if (session == NULL)
 		return -ENOMEM;
 
+	trace->host = &session->machines.host;
+
 	err = perf_session__set_tracepoints_handlers(session, handlers);
 	if (err)
 		goto out;
@@ -1728,7 +1729,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 	size_t printed = trace__fprintf_threads_header(fp);
 	struct rb_node *nd;
 
-	for (nd = rb_first(&trace->host.threads); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&trace->host->threads); nd; nd = rb_next(nd)) {
 		struct thread *thread = rb_entry(nd, struct thread, rb_node);
 		struct thread_trace *ttrace = thread->priv;
 		const char *color;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ddf917b787fa..fc14f9bf82c8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -46,6 +46,23 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	return 0;
 }
 
+struct machine *machine__new_host(void)
+{
+	struct machine *machine = malloc(sizeof(*machine));
+
+	if (machine != NULL) {
+		machine__init(machine, "", HOST_KERNEL_ID);
+
+		if (machine__create_kernel_maps(machine) < 0)
+			goto out_delete;
+	}
+
+	return machine;
+out_delete:
+	free(machine);
+	return NULL;
+}
+
 static void dsos__delete(struct list_head *dsos)
 {
 	struct dso *pos, *n;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 58a6be1fc739..5150d5e1db67 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -74,6 +74,7 @@ char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
 void machines__set_symbol_filter(struct machines *machines,
 				 symbol_filter_t symbol_filter);
 
+struct machine *machine__new_host(void);
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *machine);
 void machine__delete_dead_threads(struct machine *machine);
-- 
1.8.1.4

