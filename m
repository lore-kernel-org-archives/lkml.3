Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3F1Iir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:38:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:40438 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3F1Iik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:38:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323821636"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 13/15] perf tools: struct thread has a tid not a pid
Date: Fri, 28 Jun 2013 11:43:24 +0300
Message-Id: <1372409006-8431-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As evident from 'machine__process_fork_event()' and
'machine__process_exit_event()' the 'pid' member of
struct thread is actually the tid.

Rename 'pid' to 'tid' in struct thread accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-kmem.c      |  2 +-
 tools/perf/builtin-sched.c     | 12 ++++++------
 tools/perf/builtin-trace.c     |  4 ++--
 tools/perf/ui/browsers/hists.c |  6 +++---
 tools/perf/util/event.c        |  2 +-
 tools/perf/util/machine.c      | 20 ++++++++++----------
 tools/perf/util/machine.h      |  4 ++--
 tools/perf/util/sort.c         |  6 +++---
 tools/perf/util/thread.c       | 10 +++++-----
 tools/perf/util/thread.h       |  4 ++--
 10 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 46878da..34647fa 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -313,7 +313,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6c..b1715f4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1075,7 +1075,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
 			return -1;
-		register_pid(sched, migrant->pid, migrant->comm);
+		register_pid(sched, migrant->tid, migrant->comm);
 		atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 		if (!atoms) {
 			pr_err("migration-event: Internal tree error");
@@ -1115,7 +1115,7 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 	sched->all_runtime += work_list->total_runtime;
 	sched->all_count   += work_list->nb_atoms;
 
-	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->pid);
+	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->tid);
 
 	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
@@ -1131,9 +1131,9 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 
 static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
 {
-	if (l->thread->pid < r->thread->pid)
+	if (l->thread->tid < r->thread->tid)
 		return -1;
-	if (l->thread->pid > r->thread->pid)
+	if (l->thread->tid > r->thread->tid)
 		return 1;
 
 	return 0;
@@ -1321,7 +1321,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 			printf("*");
 
 		if (sched->curr_thread[cpu]) {
-			if (sched->curr_thread[cpu]->pid)
+			if (sched->curr_thread[cpu]->tid)
 				printf("%2s ", sched->curr_thread[cpu]->shortname);
 			else
 				printf(".  ");
@@ -1332,7 +1332,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 	printf("  %12.6f secs ", (double)timestamp/1e9);
 	if (new_shortname) {
 		printf("%s => %s:%d\n",
-			sched_in->shortname, sched_in->comm, sched_in->pid);
+			sched_in->shortname, sched_in->comm, sched_in->tid);
 	} else {
 		printf("\n");
 	}
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ab3ed4a..6a36a95 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -142,7 +142,7 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 	printed += fprintf_duration(duration, fp);
 
 	if (trace->multiple_threads)
-		printed += fprintf(fp, "%d ", thread->pid);
+		printed += fprintf(fp, "%d ", thread->tid);
 
 	return printed;
 }
@@ -593,7 +593,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 			color = PERF_COLOR_YELLOW;
 
 		printed += color_fprintf(fp, color, "%20s", thread->comm);
-		printed += fprintf(fp, " - %-5d :%11lu   [", thread->pid, ttrace->nr_events);
+		printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 		printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 		printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
 	}
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index fc0bd38..06e892f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1256,7 +1256,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 		printed += scnprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
 				    (thread->comm_set ? thread->comm : ""),
-				    thread->pid);
+				    thread->tid);
 	if (dso)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", DSO: %s", dso->short_name);
@@ -1579,7 +1579,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
 			     (browser->hists->thread_filter ? "out of" : "into"),
 			     (thread->comm_set ? thread->comm : ""),
-			     thread->pid) > 0)
+			     thread->tid) > 0)
 			zoom_thread = nr_options++;
 
 		if (dso != NULL &&
@@ -1702,7 +1702,7 @@ zoom_out_thread:
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
-						   thread->pid);
+						   thread->tid);
 				browser->hists->thread_filter = thread;
 				sort_thread.elide = true;
 				pstack__push(fstack, &browser->hists->thread_filter);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5cd13d7..9541270 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -686,7 +686,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
 		goto out_filtered;
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
 	 *
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..ef0be97 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -233,7 +233,7 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
-static struct thread *__machine__findnew_thread(struct machine *machine, pid_t pid,
+static struct thread *__machine__findnew_thread(struct machine *machine, pid_t tid,
 						bool create)
 {
 	struct rb_node **p = &machine->threads.rb_node;
@@ -241,23 +241,23 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t p
 	struct thread *th;
 
 	/*
-	 * Font-end cache - PID lookups come in blocks,
+	 * Front-end cache - TID lookups come in blocks,
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (machine->last_match && machine->last_match->pid == pid)
+	if (machine->last_match && machine->last_match->tid == tid)
 		return machine->last_match;
 
 	while (*p != NULL) {
 		parent = *p;
 		th = rb_entry(parent, struct thread, rb_node);
 
-		if (th->pid == pid) {
+		if (th->tid == tid) {
 			machine->last_match = th;
 			return th;
 		}
 
-		if (pid < th->pid)
+		if (tid < th->tid)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -266,7 +266,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t p
 	if (!create)
 		return NULL;
 
-	th = thread__new(pid);
+	th = thread__new(tid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
@@ -276,14 +276,14 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t p
 	return th;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t pid)
+struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, pid, true);
+	return __machine__findnew_thread(machine, tid, true);
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t pid)
+struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, pid, false);
+	return __machine__findnew_thread(machine, tid, false);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 7794068..e49ba01 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -36,7 +36,7 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t pid);
+struct thread *machine__find_thread(struct machine *machine, pid_t tid);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event);
 int machine__process_exit_event(struct machine *machine, union perf_event *event);
@@ -99,7 +99,7 @@ static inline bool machine__is_host(struct machine *machine)
 	return machine ? machine->pid == HOST_KERNEL_ID : false;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
+struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 313a5a7..8deee19 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -55,14 +55,14 @@ static int64_t cmp_null(void *l, void *r)
 static int64_t
 sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->pid - left->thread->pid;
+	return right->thread->tid - left->thread->tid;
 }
 
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
-			      self->thread->comm ?: "", self->thread->pid);
+			      self->thread->comm ?: "", self->thread->tid);
 }
 
 struct sort_entry sort_thread = {
@@ -77,7 +77,7 @@ struct sort_entry sort_thread = {
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->pid - left->thread->pid;
+	return right->thread->tid - left->thread->tid;
 }
 
 static int64_t
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 40399cb..6feeb88 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,17 +7,17 @@
 #include "util.h"
 #include "debug.h"
 
-struct thread *thread__new(pid_t pid)
+struct thread *thread__new(pid_t tid)
 {
 	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
 		map_groups__init(&self->mg);
-		self->pid = pid;
+		self->tid = tid;
 		self->ppid = -1;
 		self->comm = malloc(32);
 		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
+			snprintf(self->comm, 32, ":%d", self->tid);
 	}
 
 	return self;
@@ -57,7 +57,7 @@ int thread__comm_len(struct thread *self)
 
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
-	return fprintf(fp, "Thread %d %s\n", thread->pid, thread->comm) +
+	return fprintf(fp, "Thread %d %s\n", thread->tid, thread->comm) +
 	       map_groups__fprintf(&thread->mg, verbose, fp);
 }
 
@@ -84,7 +84,7 @@ int thread__fork(struct thread *self, struct thread *parent)
 		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
 
-	self->ppid = parent->pid;
+	self->ppid = parent->tid;
 
 	return 0;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index eeb7ac6..37a86a3 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -12,7 +12,7 @@ struct thread {
 		struct list_head node;
 	};
 	struct map_groups	mg;
-	pid_t			pid;
+	pid_t			tid;
 	pid_t			ppid;
 	char			shortname[3];
 	bool			comm_set;
@@ -24,7 +24,7 @@ struct thread {
 
 struct machine;
 
-struct thread *thread__new(pid_t pid);
+struct thread *thread__new(pid_t tid);
 void thread__delete(struct thread *self);
 
 int thread__set_comm(struct thread *self, const char *comm);
-- 
1.7.11.7

