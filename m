Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3IZJA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:00:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50010 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3IZI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:18 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-e0-5243f725d867
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf tools: Use an accessor to read thread comm
Date: Thu, 26 Sep 2013 17:58:06 +0900
Message-Id: <1380185890-25758-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
Link: http://lkml.kernel.org/n/tip-wr683zwy94hmj4ibogmnv9ce@git.kernel.org
[ Fixed up some minor const pointer issues ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-kmem.c                              |  2 +-
 tools/perf/builtin-lock.c                              |  2 +-
 tools/perf/builtin-sched.c                             | 16 ++++++++--------
 tools/perf/builtin-script.c                            |  6 +++---
 tools/perf/builtin-trace.c                             |  5 +++--
 tools/perf/tests/hists_link.c                          |  2 +-
 tools/perf/ui/browsers/hists.c                         | 10 +++++-----
 tools/perf/util/event.c                                |  4 ++--
 tools/perf/util/scripting-engines/trace-event-perl.c   |  2 +-
 tools/perf/util/scripting-engines/trace-event-python.c |  4 ++--
 tools/perf/util/sort.c                                 | 10 +++++-----
 tools/perf/util/thread.c                               |  7 ++++++-
 tools/perf/util/thread.h                               |  1 +
 13 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 9b5f077fee5b..1a85296f6af1 100644
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
index 6a9076f165f4..69670c6bc165 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -766,7 +766,7 @@ static void dump_threads(void)
 	while (node) {
 		st = container_of(node, struct thread_stat, rb);
 		t = perf_session__findnew(session, st->tid);
-		pr_info("%10d: %s\n", st->tid, t->comm);
+		pr_info("%10d: %s\n", st->tid, thread__comm_curr(t));
 		node = rb_next(node);
 	};
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d8c51b2f263f..2699719dfde2 100644
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
index 7f31a3ded1b6..50258aa8cea1 100644
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
index 1bb8f154852a..a96fd47b369b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1025,7 +1025,8 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 
 	if (trace->multiple_threads) {
 		if (trace->show_comm)
-			printed += fprintf(fp, "%.14s/", thread->comm);
+			printed += fprintf(fp, "%.14s/",
+					   thread__comm_curr(thread));
 		printed += fprintf(fp, "%d ", thread->tid);
 	}
 
@@ -1730,7 +1731,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 		else if (ratio > 5.0)
 			color = PERF_COLOR_YELLOW;
 
-		printed += color_fprintf(fp, color, "%20s", thread->comm);
+		printed += color_fprintf(fp, color, "%20s", thread__comm_curr(thread));
 		printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 		printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 		printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 3b5faaa5c8cf..735cff2c52ce 100644
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
index 7ef36c360471..abb68e24d858 100644
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
index 9b393e7dca6f..d639bfe29309 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -725,10 +725,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
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
index a85e4ae5f3ac..c4065ed3ae5a 100644
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
index cc75a3cef388..b532675be3c1 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -239,7 +239,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	char *comm = thread->comm;
+	const char *comm = thread__comm_curr(thread);
 
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
index 082480579861..65fe958ce30b 100644
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
index e3d4a550a703..bb50b9fda9c2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -45,6 +45,11 @@ int thread__set_comm(struct thread *self, const char *comm)
 	return err;
 }
 
+const char *thread__comm_curr(const struct thread *thread)
+{
+	return thread->comm;
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
index 4ebbb40d46d4..84db214d90bd 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -35,6 +35,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
+const char *thread__comm_curr(const struct thread *thread);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
-- 
1.7.11.7

