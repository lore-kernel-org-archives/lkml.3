Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaLXHVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:21:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39744 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaLXHO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:56 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/37] perf tools: Introduce machine__find*_thread_time()
Date: Wed, 24 Dec 2014 16:15:11 +0900
Message-Id: <1419405333-27952-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With multi-file data storage is enabled, it needs to search thread
based on sample time since sample processing is done after other
(task, comm and mmap) events are processed.  This can be a problem if
a session is very long and pid is recycled - in that case it'll only
see the last one.

So keep thread start time in it, and search thread based on the time.
This patch introduces machine__find{,new}_thread_time() function for
this.  It'll first search current thread rbtree and then dead thread
tree and list.  If it couldn't find anyone, it'll create a new thread.

The sample timestamp of 0 means that this is called from synthesized
event so just use current rbtree.  The timestamp will be -1 if sample
didn't record the timestamp so will see current threads automatically.

Dead threads are managed in a rbtree, and if there's more than one
thread has sample tid/pid, it'll be saved in a list.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c     |   5 +-
 tools/perf/tests/dwarf-unwind.c |  10 ++--
 tools/perf/tests/hists_common.c |   3 +-
 tools/perf/tests/hists_link.c   |   2 +-
 tools/perf/util/event.c         |   4 +-
 tools/perf/util/machine.c       | 109 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/machine.h       |   8 ++-
 tools/perf/util/thread.c        |   4 ++
 tools/perf/util/thread.h        |   1 +
 9 files changed, 132 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ce304dfd962a..85122b388d8e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -549,8 +549,9 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->tid);
+	struct thread *thread = machine__findnew_thread_time(machine, sample->pid,
+							     sample->tid,
+							     sample->time);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index ab28cca2cb97..dfecd49fef90 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -13,10 +13,10 @@
 
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
-			struct perf_sample *sample __maybe_unused,
+			struct perf_sample *sample,
 			struct machine *machine)
 {
-	return machine__process_mmap2_event(machine, event, NULL);
+	return machine__process_mmap2_event(machine, event, sample);
 }
 
 static int init_live_machine(struct machine *machine)
@@ -61,12 +61,12 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 __attribute__ ((noinline))
 static int unwind_thread(struct thread *thread)
 {
-	struct perf_sample sample;
+	struct perf_sample sample = {
+		.time = -1ULL,
+	};
 	unsigned long cnt = 0;
 	int err = -1;
 
-	memset(&sample, 0, sizeof(sample));
-
 	if (test__arch_unwind_sample(&sample, thread)) {
 		pr_debug("failed to get unwind sample\n");
 		goto out;
diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
index a62c09134516..86a8fdb41804 100644
--- a/tools/perf/tests/hists_common.c
+++ b/tools/perf/tests/hists_common.c
@@ -80,6 +80,7 @@ static struct {
 struct machine *setup_fake_machine(struct machines *machines)
 {
 	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
+	struct perf_sample sample = { .time = -1ULL, };
 	size_t i;
 
 	if (machine == NULL) {
@@ -113,7 +114,7 @@ struct machine *setup_fake_machine(struct machines *machines)
 		strcpy(fake_mmap_event.mmap.filename,
 		       fake_mmap_info[i].filename);
 
-		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
+		machine__process_mmap_event(machine, &fake_mmap_event, &sample);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index fe7cb886c23e..07f1d19b88b5 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -64,7 +64,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	struct perf_evsel *evsel;
 	struct addr_location al;
 	struct hist_entry *he;
-	struct perf_sample sample = { .period = 1, };
+	struct perf_sample sample = { .period = 1, .time = -1ULL, };
 	size_t i = 0, k;
 
 	/*
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6c6d044e959a..ff7594a27c73 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -825,8 +825,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->tid);
+	struct thread *thread = machine__findnew_thread_time(machine, sample->pid,
+							     sample->tid, sample->time);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 582e011adc92..2cc088d71922 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -431,6 +431,103 @@ struct thread *machine__find_thread(struct machine *machine, pid_t pid,
 	return __machine__findnew_thread(machine, pid, tid, false);
 }
 
+static void machine__remove_thread(struct machine *machine, struct thread *th);
+
+static struct thread *__machine__findnew_thread_time(struct machine *machine,
+						     pid_t pid, pid_t tid,
+						     u64 timestamp, bool create)
+{
+	struct thread *curr, *pos, *new;
+	struct thread *th = NULL;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	bool initial = timestamp == (u64)0;
+
+	curr = __machine__findnew_thread(machine, pid, tid, initial);
+	if (curr && timestamp >= curr->start_time)
+		return curr;
+
+	p = &machine->dead_threads.rb_node;
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
+
+		if (th->tid == tid) {
+			list_for_each_entry(pos, &th->node, node) {
+				if (timestamp >= pos->start_time &&
+				    pos->start_time > th->start_time) {
+					th = pos;
+					break;
+				}
+			}
+
+			if (timestamp >= th->start_time) {
+				machine__update_thread_pid(machine, th, pid);
+				return th;
+			}
+			break;
+		}
+
+		if (tid < th->tid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	if (!create)
+		return NULL;
+
+	if (!curr)
+		return __machine__findnew_thread(machine, pid, tid, true);
+
+	new = thread__new(pid, tid);
+	if (new == NULL)
+		return NULL;
+
+	new->start_time = timestamp;
+
+	if (*p) {
+		list_for_each_entry(pos, &th->node, node) {
+			/* sort by time */
+			if (timestamp >= pos->start_time) {
+				th = pos;
+				break;
+			}
+		}
+		list_add_tail(&new->node, &th->node);
+	} else {
+		rb_link_node(&new->rb_node, parent, p);
+		rb_insert_color(&new->rb_node, &machine->dead_threads);
+	}
+
+	/*
+	 * We have to initialize map_groups separately
+	 * after rb tree is updated.
+	 *
+	 * The reason is that we call machine__findnew_thread
+	 * within thread__init_map_groups to find the thread
+	 * leader and that would screwed the rb tree.
+	 */
+	if (thread__init_map_groups(new, machine)) {
+		thread__delete(new);
+		return NULL;
+	}
+
+	return new;
+}
+
+struct thread *machine__find_thread_time(struct machine *machine, pid_t pid,
+					 pid_t tid, u64 timestamp)
+{
+	return __machine__findnew_thread_time(machine, pid, tid, timestamp, false);
+}
+
+struct thread *machine__findnew_thread_time(struct machine *machine, pid_t pid,
+					    pid_t tid, u64 timestamp)
+{
+	return __machine__findnew_thread_time(machine, pid, tid, timestamp, true);
+}
+
 struct comm *machine__thread_exec_comm(struct machine *machine,
 				       struct thread *thread)
 {
@@ -1169,7 +1266,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.tid);
+					 event->mmap2.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1265,6 +1362,16 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 		pos = rb_entry(parent, struct thread, rb_node);
 
 		if (pos->tid == th->tid) {
+			struct thread *old;
+
+			/* sort by time */
+			list_for_each_entry(old, &pos->node, node) {
+				if (th->start_time >= old->start_time) {
+					pos = old;
+					break;
+				}
+			}
+
 			list_add_tail(&th->node, &pos->node);
 			return;
 		}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 4349946a38ff..9571b6b1c5b5 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -68,8 +68,6 @@ static inline bool machine__kernel_ip(struct machine *machine, u64 ip)
 	return ip >= kernel_start;
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t pid,
-				    pid_t tid);
 struct comm *machine__thread_exec_comm(struct machine *machine,
 				       struct thread *thread);
 
@@ -149,6 +147,12 @@ static inline bool machine__is_host(struct machine *machine)
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
 				       pid_t tid);
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    pid_t tid);
+struct thread *machine__findnew_thread_time(struct machine *machine, pid_t pid,
+					    pid_t tid, u64 timestamp);
+struct thread *machine__find_thread_time(struct machine *machine, pid_t pid,
+					 pid_t tid, u64 timestamp);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b9c5c5d5e718..f2465f17cf16 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -128,6 +128,9 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 
 	/* Override the default :tid entry */
 	if (!thread->comm_set) {
+		if (!thread->start_time)
+			thread->start_time = timestamp;
+
 		err = comm__override(curr, str, timestamp, exec);
 		if (err)
 			return err;
@@ -229,6 +232,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 	}
 
 	thread->ppid = parent->tid;
+	thread->start_time = timestamp;
 	return thread__clone_map_groups(thread, parent);
 }
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 413f28cf689b..5c07cee3b64e 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -25,6 +25,7 @@ struct thread {
 	struct list_head	comm_list;
 	int			comm_len;
 	u64			db_id;
+	u64			start_time;
 
 	void			*priv;
 	struct thread_stack	*ts;
-- 
2.1.3

