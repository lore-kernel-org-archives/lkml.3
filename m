Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3ILUb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:31:58 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:59918 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3ILU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:29:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf tools: Use an accessor to read thread comm
Date: Thu, 12 Sep 2013 22:29:40 +0200
Message-Id: <1379017783-27032-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the thread comm is going to be implemented by way of a more
complicated data structure than just a pointer to a string from the
thread struct, convert the readers of comm to use an accessor instead
of accessing it directly. The accessor will be later overriden to
support an enhanced comm implementation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-sched.c                         |   16 ++++++++--------
 tools/perf/builtin-script.c                        |    6 +++---
 tools/perf/builtin-trace.c                         |    2 +-
 tools/perf/tests/hists_link.c                      |    2 +-
 tools/perf/ui/browsers/hists.c                     |   10 +++++-----
 tools/perf/util/event.c                            |    4 ++--
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    4 ++--
 tools/perf/util/sort.c                             |   10 +++++-----
 tools/perf/util/thread.c                           |    7 ++++++-
 tools/perf/util/thread.h                           |    1 +
 13 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c2dff9c..707e860 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -314,7 +314,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
+	dump_printf(" ... thread: %s:%d\n", thread__comm_curr(thread), thread->tid);
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ee33ba2..a7862ed 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -762,7 +762,7 @@ static void dump_threads(void)
 	while (node) {
 		st = container_of(node, struct thread_stat, rb);
 		t = perf_session__findnew(session, st->tid);
-		pr_info("%10d: %s\n", st->tid, t->comm);
+		pr_info("%10d: %s\n", st->tid, thread__comm_curr(t));
 		node = rb_next(node);
 	};
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d8c51b2..2699719 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -737,12 +737,12 @@ static int replay_fork_event(struct perf_sched *sched,
 
 	if (verbose) {
 		printf("fork event\n");
-		printf("... parent: %s/%d\n", parent->comm, parent->tid);
-		printf("...  child: %s/%d\n", child->comm, child->tid);
+		printf("... parent: %s/%d\n", thread__comm_curr(parent), parent->tid);
+		printf("...  child: %s/%d\n", thread__comm_curr(child), child->tid);
 	}
 
-	register_pid(sched, parent->tid, parent->comm);
-	register_pid(sched, child->tid, child->comm);
+	register_pid(sched, parent->tid, thread__comm_curr(parent));
+	register_pid(sched, child->tid, thread__comm_curr(child));
 	return 0;
 }
 
@@ -1077,7 +1077,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
 			return -1;
-		register_pid(sched, migrant->tid, migrant->comm);
+		register_pid(sched, migrant->tid, thread__comm_curr(migrant));
 		atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 		if (!atoms) {
 			pr_err("migration-event: Internal tree error");
@@ -1111,13 +1111,13 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 	/*
 	 * Ignore idle threads:
 	 */
-	if (!strcmp(work_list->thread->comm, "swapper"))
+	if (!strcmp(thread__comm_curr(work_list->thread), "swapper"))
 		return;
 
 	sched->all_runtime += work_list->total_runtime;
 	sched->all_count   += work_list->nb_atoms;
 
-	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->tid);
+	ret = printf("  %s:%d ", thread__comm_curr(work_list->thread), work_list->thread->tid);
 
 	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
@@ -1334,7 +1334,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 	printf("  %12.6f secs ", (double)timestamp/1e9);
 	if (new_shortname) {
 		printf("%s => %s:%d\n",
-			sched_in->shortname, sched_in->comm, sched_in->tid);
+		       sched_in->shortname, thread__comm_curr(sched_in), sched_in->tid);
 	} else {
 		printf("\n");
 	}
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 93a34ce..b98ddeb 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -290,11 +290,11 @@ static void print_sample_start(struct perf_sample *sample,
 
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
-			printf("%8.8s ", thread->comm);
+			printf("%8.8s ", thread__comm_curr(thread));
 		else if (PRINT_FIELD(IP) && symbol_conf.use_callchain)
-			printf("%s ", thread->comm);
+			printf("%s ", thread__comm_curr(thread));
 		else
-			printf("%16s ", thread->comm);
+			printf("%16s ", thread__comm_curr(thread));
 	}
 
 	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5aa637..d14ec25 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1125,7 +1125,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 		else if (ratio > 5.0)
 			color = PERF_COLOR_YELLOW;
 
-		printed += color_fprintf(fp, color, "%20s", thread->comm);
+		printed += color_fprintf(fp, color, "%20s", thread__comm_curr(thread));
 		printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 		printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 		printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 4228ffc..274be5d 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -419,7 +419,7 @@ static void print_hists(struct hists *hists)
 		he = rb_entry(node, struct hist_entry, rb_node_in);
 
 		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-			i, he->thread->comm, he->ms.map->dso->short_name,
+			i, thread__comm_curr(he->thread), he->ms.map->dso->short_name,
 			he->ms.sym->name, he->stat.period);
 
 		i++;
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ef36c3..abb68e2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1255,7 +1255,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	if (thread)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
-				    (thread->comm_set ? thread->comm : ""),
+				     (thread->comm_set ? thread__comm_curr(thread) : ""),
 				    thread->tid);
 	if (dso)
 		printed += scnprintf(bf + printed, size - printed,
@@ -1578,7 +1578,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
 			     (browser->hists->thread_filter ? "out of" : "into"),
-			     (thread->comm_set ? thread->comm : ""),
+			     (thread->comm_set ? thread__comm_curr(thread) : ""),
 			     thread->tid) > 0)
 			zoom_thread = nr_options++;
 
@@ -1598,7 +1598,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			struct symbol *sym;
 
 			if (asprintf(&options[nr_options], "Run scripts for samples of thread [%s]",
-				browser->he_selection->thread->comm) > 0)
+				     thread__comm_curr(browser->he_selection->thread)) > 0)
 				scripts_comm = nr_options++;
 
 			sym = browser->he_selection->ms.sym;
@@ -1701,7 +1701,7 @@ zoom_out_thread:
 				sort_thread.elide = false;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
-						   thread->comm_set ? thread->comm : "",
+						   thread->comm_set ? thread__comm_curr(thread) : "",
 						   thread->tid);
 				browser->hists->thread_filter = thread;
 				sort_thread.elide = true;
@@ -1717,7 +1717,7 @@ do_scripts:
 			memset(script_opt, 0, 64);
 
 			if (choice == scripts_comm)
-				sprintf(script_opt, " -c %s ", browser->he_selection->thread->comm);
+				sprintf(script_opt, " -c %s ", thread__comm_curr(browser->he_selection->thread));
 
 			if (choice == scripts_symbol)
 				sprintf(script_opt, " -S %s ", browser->he_selection->ms.sym->name);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 8d51f21..c3a35ca 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -693,10 +693,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		return -1;
 
 	if (symbol_conf.comm_list &&
-	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
+	    !strlist__has_entry(symbol_conf.comm_list, thread__comm_curr(thread)))
 		goto out_filtered;
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
+	dump_printf(" ... thread: %s:%d\n", thread__comm_curr(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
 	 *
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index a85e4ae..c4065ed 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -273,7 +273,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	char *comm = thread->comm;
+	const char *comm = thread__comm_curr(thread);
 
 	dSP;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cc75a3c..422a78d 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -239,7 +239,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	char *comm = thread->comm;
+	char *comm = thread__comm_curr(thread);
 
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
@@ -378,7 +378,7 @@ static void python_process_general_event(union perf_event *perf_event
 	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
 	PyDict_SetItemString(dict, "comm",
-			PyString_FromString(thread->comm));
+			     PyString_FromString(thread__comm_curr(thread)));
 	if (al->map) {
 		PyDict_SetItemString(dict, "dso",
 			PyString_FromString(al->map->dso->name));
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5f118a0..26d8f11 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -42,7 +42,7 @@ static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 	return n;
 }
 
-static int64_t cmp_null(void *l, void *r)
+static int64_t cmp_null(const void *l, const void *r)
 {
 	if (!l && !r)
 		return 0;
@@ -64,7 +64,7 @@ static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
-			      self->thread->comm ?: "", self->thread->tid);
+			       thread__comm_curr(self->thread) ?: "", self->thread->tid);
 }
 
 struct sort_entry sort_thread = {
@@ -85,8 +85,8 @@ sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 static int64_t
 sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
+	const char *comm_l = thread__comm_curr(left->thread);
+	const char *comm_r = thread__comm_curr(right->thread);
 
 	if (!comm_l || !comm_r)
 		return cmp_null(comm_l, comm_r);
@@ -97,7 +97,7 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
+	return repsep_snprintf(bf, size, "%*s", width, thread__comm_curr(self->thread));
 }
 
 struct sort_entry sort_comm = {
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index e3d4a55..a139451 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -45,6 +45,11 @@ int thread__set_comm(struct thread *self, const char *comm)
 	return err;
 }
 
+const char *thread__comm_curr(struct thread *self)
+{
+	return self->comm;
+}
+
 int thread__comm_len(struct thread *self)
 {
 	if (!self->comm_len) {
@@ -58,7 +63,7 @@ int thread__comm_len(struct thread *self)
 
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
-	return fprintf(fp, "Thread %d %s\n", thread->tid, thread->comm) +
+	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_curr(thread)) +
 	       map_groups__fprintf(&thread->mg, verbose, fp);
 }
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 4ebbb40..4eccee7 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -35,6 +35,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
+const char *thread__comm_curr(struct thread *self);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
-- 
1.7.5.4

