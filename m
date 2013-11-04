Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3KDUT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:19:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3KDUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:19:57 -0500
Date: Mon, 4 Nov 2013 12:19:22 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-wr683zwy94hmj4ibogmnv9ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use an accessor to read thread comm
Git-Commit-ID: b9c5143a012a543c4ee872498d6dbae5c10beb2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:19:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9c5143a012a543c4ee872498d6dbae5c10beb2e
Gitweb:     http://git.kernel.org/tip/b9c5143a012a543c4ee872498d6dbae5c10beb2e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Sep 2013 14:46:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 11:50:28 -0300

perf tools: Use an accessor to read thread comm

As the thread comm is going to be implemented by way of a more
complicated data structure than just a pointer to a string from the
thread struct, convert the readers of comm to use an accessor instead of
accessing it directly.

The accessor will be later overriden to support an enhanced comm
implementation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wr683zwy94hmj4ibogmnv9ce@git.kernel.org
[ Rename thread__comm_curr() to thread__comm_str() ]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
[ Fixed up some minor const pointer issues ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c                              |  2 +-
 tools/perf/builtin-lock.c                              |  2 +-
 tools/perf/builtin-sched.c                             | 16 ++++++++--------
 tools/perf/builtin-script.c                            |  6 +++---
 tools/perf/tests/hists_link.c                          |  2 +-
 tools/perf/ui/browsers/hists.c                         | 10 +++++-----
 tools/perf/util/event.c                                |  4 ++--
 tools/perf/util/scripting-engines/trace-event-perl.c   |  2 +-
 tools/perf/util/scripting-engines/trace-event-python.c |  4 ++--
 tools/perf/util/sort.c                                 | 11 ++++++-----
 tools/perf/util/thread.c                               |  7 ++++++-
 tools/perf/util/thread.h                               |  1 +
 12 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 1126382..a28970f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -315,7 +315,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
+	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 33c7253..35f9aaa 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -767,7 +767,7 @@ static void dump_threads(void)
 	while (node) {
 		st = container_of(node, struct thread_stat, rb);
 		t = perf_session__findnew(session, st->tid);
-		pr_info("%10d: %s\n", st->tid, t->comm);
+		pr_info("%10d: %s\n", st->tid, thread__comm_str(t));
 		node = rb_next(node);
 	};
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ddb5dc1..a81ab18 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -737,12 +737,12 @@ static int replay_fork_event(struct perf_sched *sched,
 
 	if (verbose) {
 		printf("fork event\n");
-		printf("... parent: %s/%d\n", parent->comm, parent->tid);
-		printf("...  child: %s/%d\n", child->comm, child->tid);
+		printf("... parent: %s/%d\n", thread__comm_str(parent), parent->tid);
+		printf("...  child: %s/%d\n", thread__comm_str(child), child->tid);
 	}
 
-	register_pid(sched, parent->tid, parent->comm);
-	register_pid(sched, child->tid, child->comm);
+	register_pid(sched, parent->tid, thread__comm_str(parent));
+	register_pid(sched, child->tid, thread__comm_str(child));
 	return 0;
 }
 
@@ -1077,7 +1077,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
 			return -1;
-		register_pid(sched, migrant->tid, migrant->comm);
+		register_pid(sched, migrant->tid, thread__comm_str(migrant));
 		atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 		if (!atoms) {
 			pr_err("migration-event: Internal tree error");
@@ -1111,13 +1111,13 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 	/*
 	 * Ignore idle threads:
 	 */
-	if (!strcmp(work_list->thread->comm, "swapper"))
+	if (!strcmp(thread__comm_str(work_list->thread), "swapper"))
 		return;
 
 	sched->all_runtime += work_list->total_runtime;
 	sched->all_count   += work_list->nb_atoms;
 
-	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->tid);
+	ret = printf("  %s:%d ", thread__comm_str(work_list->thread), work_list->thread->tid);
 
 	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
@@ -1334,7 +1334,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 	printf("  %12.6f secs ", (double)timestamp/1e9);
 	if (new_shortname) {
 		printf("%s => %s:%d\n",
-			sched_in->shortname, sched_in->comm, sched_in->tid);
+		       sched_in->shortname, thread__comm_str(sched_in), sched_in->tid);
 	} else {
 		printf("\n");
 	}
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0ae88c2..b866cc8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -291,11 +291,11 @@ static void print_sample_start(struct perf_sample *sample,
 
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
-			printf("%8.8s ", thread->comm);
+			printf("%8.8s ", thread__comm_str(thread));
 		else if (PRINT_FIELD(IP) && symbol_conf.use_callchain)
-			printf("%s ", thread->comm);
+			printf("%s ", thread__comm_str(thread));
 		else
-			printf("%16s ", thread->comm);
+			printf("%16s ", thread__comm_str(thread));
 	}
 
 	if (PRINT_FIELD(PID) && PRINT_FIELD(TID))
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index b51abcb..4475b0f 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -421,7 +421,7 @@ static void print_hists(struct hists *hists)
 		he = rb_entry(node, struct hist_entry, rb_node_in);
 
 		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-			i, he->thread->comm, he->ms.map->dso->short_name,
+			i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
 			he->ms.sym->name, he->stat.period);
 
 		i++;
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ef36c3..a91b6b2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1255,7 +1255,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	if (thread)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
-				    (thread->comm_set ? thread->comm : ""),
+				     (thread->comm_set ? thread__comm_str(thread) : ""),
 				    thread->tid);
 	if (dso)
 		printed += scnprintf(bf + printed, size - printed,
@@ -1578,7 +1578,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
 			     (browser->hists->thread_filter ? "out of" : "into"),
-			     (thread->comm_set ? thread->comm : ""),
+			     (thread->comm_set ? thread__comm_str(thread) : ""),
 			     thread->tid) > 0)
 			zoom_thread = nr_options++;
 
@@ -1598,7 +1598,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			struct symbol *sym;
 
 			if (asprintf(&options[nr_options], "Run scripts for samples of thread [%s]",
-				browser->he_selection->thread->comm) > 0)
+				     thread__comm_str(browser->he_selection->thread)) > 0)
 				scripts_comm = nr_options++;
 
 			sym = browser->he_selection->ms.sym;
@@ -1701,7 +1701,7 @@ zoom_out_thread:
 				sort_thread.elide = false;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
-						   thread->comm_set ? thread->comm : "",
+						   thread->comm_set ? thread__comm_str(thread) : "",
 						   thread->tid);
 				browser->hists->thread_filter = thread;
 				sort_thread.elide = true;
@@ -1717,7 +1717,7 @@ do_scripts:
 			memset(script_opt, 0, 64);
 
 			if (choice == scripts_comm)
-				sprintf(script_opt, " -c %s ", browser->he_selection->thread->comm);
+				sprintf(script_opt, " -c %s ", thread__comm_str(browser->he_selection->thread));
 
 			if (choice == scripts_symbol)
 				sprintf(script_opt, " -S %s ", browser->he_selection->ms.sym->name);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 49096ea..7a2842e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -721,10 +721,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		return -1;
 
 	if (symbol_conf.comm_list &&
-	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
+	    !strlist__has_entry(symbol_conf.comm_list, thread__comm_str(thread)))
 		goto out_filtered;
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
+	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
 	 *
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index c0c9795..d5e5969 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -273,7 +273,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	char *comm = thread->comm;
+	const char *comm = thread__comm_str(thread);
 
 	dSP;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 95d91a0..53c20e7 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -250,7 +250,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	char *comm = thread->comm;
+	const char *comm = thread__comm_str(thread);
 
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
@@ -389,7 +389,7 @@ static void python_process_general_event(union perf_event *perf_event
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
-			PyString_FromString(thread->comm));
+			PyString_FromString(thread__comm_str(thread)));
 	if (al->map) {
 		pydict_set_item_string_decref(dict, "dso",
 			PyString_FromString(al->map->dso->name));
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 19b4aa2..835e8bd 100644
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
@@ -63,8 +63,9 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
+	const char *comm = thread__comm_str(he->thread);
 	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
-			      he->thread->comm ?: "", he->thread->tid);
+			       comm ?: "", he->thread->tid);
 }
 
 struct sort_entry sort_thread = {
@@ -85,8 +86,8 @@ sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 static int64_t
 sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
+	const char *comm_l = thread__comm_str(left->thread);
+	const char *comm_r = thread__comm_str(right->thread);
 
 	if (!comm_l || !comm_r)
 		return cmp_null(comm_l, comm_r);
@@ -97,7 +98,7 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, he->thread->comm);
+	return repsep_snprintf(bf, size, "%*s", width, thread__comm_str(he->thread));
 }
 
 struct sort_entry sort_comm = {
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 80d19a0..5676007 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -45,6 +45,11 @@ int thread__set_comm(struct thread *thread, const char *comm)
 	return err;
 }
 
+const char *thread__comm_str(const struct thread *thread)
+{
+	return thread->comm;
+}
+
 int thread__comm_len(struct thread *thread)
 {
 	if (!thread->comm_len) {
@@ -58,7 +63,7 @@ int thread__comm_len(struct thread *thread)
 
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
-	return fprintf(fp, "Thread %d %s\n", thread->tid, thread->comm) +
+	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
 	       map_groups__fprintf(&thread->mg, verbose, fp);
 }
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 4ebbb40..6561ad2 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -35,6 +35,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
+const char *thread__comm_str(const struct thread *thread);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
