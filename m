Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3EZCzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 22:55:48 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49011 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab3EZCzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 22:55:45 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: sample after exit loses thread correlation
Date: Sat, 25 May 2013 20:55:37 -0600
Message-Id: <1369536937-4815-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some events (context-switch, sched:sched_switch) are losing the conversion of
sample data associated with a thread. For example:

$ perf record -e sched:sched_switch -c 1 -a -- sleep 5
$ perf script
<selected events shown>
    ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
    ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
:30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

The last line lost the conversion from pid to comm. If you look at the events
(perf script -D) you see why - a SAMPLE is generated after the EXIT:

0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
... thread: :30482:30482

When perf processes the EXIT event the thread is moved to the dead_threads
list. When the SAMPLE event is processed no thread exists for the pid so a new
one is created by machine__findnew_thread.

This patch addresses the problem by saving the exit time and checking the
dead_threads list for the requested pid. If the time passed into
machine_findnew_thread is non-0 the dead_threads list is walked looking for the
pid. If the thread struct associated with the pid exited within 1usec of the
time passed in the thread is considered a match and returned.

If samples do not contain timestamps then sample->time will be 0 and the
dead_threads list will not be checked. -1 can be used to force always checking
the dead_threads list and returning a match.

with this patch we get:
ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

and

0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
 ... thread: ls:30482

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-inject.c   |    2 +-
 tools/perf/builtin-kmem.c     |    3 ++-
 tools/perf/builtin-kvm.c      |    3 ++-
 tools/perf/builtin-lock.c     |    3 ++-
 tools/perf/builtin-sched.c    |   17 +++++++-------
 tools/perf/builtin-script.c   |    3 ++-
 tools/perf/builtin-trace.c    |    9 +++++---
 tools/perf/perf.h             |    3 +++
 tools/perf/tests/hists_link.c |    2 +-
 tools/perf/util/build-id.c    |   11 ++++-----
 tools/perf/util/event.c       |   11 +++++++--
 tools/perf/util/machine.c     |   49 ++++++++++++++++++++++++++++++++---------
 tools/perf/util/machine.h     |    6 +++--
 tools/perf/util/session.c     |    2 +-
 tools/perf/util/thread.h      |    2 +-
 15 files changed, 87 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84ad6ab..60f42c8 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -209,7 +209,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, event->ip.pid);
+	thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 46878da..873647a 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,8 +305,9 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 533501e..c9572c2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -688,10 +688,11 @@ static int process_sample_event(struct perf_tool *tool,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread;
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
 						 tool);
 
+	thread = machine__findnew_thread(machine, sample->tid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4258300..1854eb9 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -805,8 +805,9 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, sample->tid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6c..abdcdbc 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -934,8 +934,8 @@ static int latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, prev_pid, timestamp);
+	sched_in = machine__findnew_thread(machine, next_pid, timestamp);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -978,7 +978,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 {
 	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
-	struct thread *thread = machine__findnew_thread(machine, pid);
+	struct thread *thread = machine__findnew_thread(machine, pid, sample->time);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1016,7 +1016,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	if (!success)
 		return 0;
 
-	wakee = machine__findnew_thread(machine, pid);
+	wakee = machine__findnew_thread(machine, pid, timestamp);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1070,7 +1070,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, pid);
+	migrant = machine__findnew_thread(machine, pid, timestamp);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1289,8 +1289,8 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, prev_pid, timestamp);
+	sched_in = machine__findnew_thread(machine, next_pid, timestamp);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
@@ -1425,9 +1425,10 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread;
 	int err = 0;
 
+	thread = machine__findnew_thread(machine, sample->tid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %s event, skipping it.\n",
 			 perf_evsel__name(evsel));
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 92d4658..2e07c70 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -479,8 +479,9 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->ip.tid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ab3ed4a..8f3e3d9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -301,7 +301,8 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	char *msg;
 	void *args;
 	size_t printed = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid,
+							sample->time);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 	struct thread_trace *ttrace = thread__trace(thread);
 
@@ -344,7 +345,8 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 {
 	int ret;
 	u64 duration = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid,
+						       	sample->time);
 	struct thread_trace *ttrace = thread__trace(thread);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 
@@ -397,7 +399,8 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid,
+							sample->time);
 	struct thread_trace *ttrace = thread__trace(thread);
 
 	if (ttrace == NULL)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..c98e9c9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -125,6 +125,9 @@
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
+#ifndef USECS_PER_SEC
+#define USECS_PER_SEC           1000000ULL
+#endif
 
 static inline unsigned long long rdclock(void)
 {
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 89085a9..963d21e 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -88,7 +88,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
 		struct thread *thread;
 
-		thread = machine__findnew_thread(machine, fake_threads[i].pid);
+		thread = machine__findnew_thread(machine, fake_threads[i].pid, 0);
 		if (thread == NULL)
 			goto out;
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5295625..c524906 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -18,14 +18,15 @@
 
 int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 			   union perf_event *event,
-			   struct perf_sample *sample __maybe_unused,
+			   struct perf_sample *sample,
 			   struct perf_evsel *evsel __maybe_unused,
 			   struct machine *machine)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -43,12 +44,12 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 
 static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 				       union perf_event *event,
-				       struct perf_sample *sample
-				       __maybe_unused,
+				       struct perf_sample *sample,
 				       struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->fork.tid, sample->time);
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
 		    event->fork.ppid, event->fork.ptid);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5cd13d7..4c15f82 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -552,9 +552,15 @@ int perf_event__process_fork(struct perf_tool *tool __maybe_unused,
 
 int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
+	struct thread *thread;
+
+	thread = machine__find_thread(machine, event->fork.tid, 0);
+	if (thread)
+		thread->t_exit = sample->time;
+
 	return machine__process_exit_event(machine, event);
 }
 
@@ -677,8 +683,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  symbol_filter_t filter)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL)
 		return -1;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..87211e3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -30,7 +30,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		return -ENOMEM;
 
 	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(machine, pid);
+		struct thread *thread = machine__findnew_thread(machine, pid, 0);
 		char comm[64];
 
 		if (thread == NULL)
@@ -234,7 +234,7 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 }
 
 static struct thread *__machine__findnew_thread(struct machine *machine, pid_t pid,
-						bool create)
+						bool create, u64 sample_time)
 {
 	struct rb_node **p = &machine->threads.rb_node;
 	struct rb_node *parent = NULL;
@@ -263,6 +263,26 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t p
 			p = &(*p)->rb_right;
 	}
 
+
+	/*
+	 * it is possible that we get a sample right after an exit event.
+	 * e.g., scheduling events, the process exits generating an exit
+	 *       event and then is scheduled out (a sample event).
+	 */
+
+	if (sample_time) {
+		list_for_each_entry(th, &machine->dead_threads, node) {
+			if (th->pid != pid)
+				continue;
+
+			if ((sample_time == (u64) -1) ||
+			    ((th->t_exit < sample_time) &&
+			    ((sample_time - th->t_exit) < USECS_PER_SEC))) {
+				return th;
+			}
+		}
+	}
+
 	if (!create)
 		return NULL;
 
@@ -276,20 +296,23 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t p
 	return th;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t pid)
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
+				       u64 sample_time)
 {
-	return __machine__findnew_thread(machine, pid, true);
+	return __machine__findnew_thread(machine, pid, true, sample_time);
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t pid)
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    u64 sample_time)
 {
-	return __machine__findnew_thread(machine, pid, false);
+	return __machine__findnew_thread(machine, pid, false, sample_time);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(machine, event->comm.tid, 0);
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
 
@@ -969,7 +992,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread(machine, event->mmap.pid, 0);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -996,9 +1019,11 @@ out_problem:
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *thread;
+	struct thread *parent;
 
+	thread = machine__findnew_thread(machine, event->fork.tid, 0);
+	parent = machine__findnew_thread(machine, event->fork.ptid, 0);
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
@@ -1024,7 +1049,9 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 
 int machine__process_exit_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread;
+
+	thread = machine__find_thread(machine, event->fork.tid, 0);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 7794068..30612f3 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -36,7 +36,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t pid);
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    u64 sample_time);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event);
 int machine__process_exit_event(struct machine *machine, union perf_event *event);
@@ -99,7 +100,8 @@ static inline bool machine__is_host(struct machine *machine)
 	return machine ? machine->pid == HOST_KERNEL_ID : false;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
+				       u64 sample_time);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..504ae0c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -999,7 +999,7 @@ void perf_event_header__bswap(struct perf_event_header *self)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, pid);
+	return machine__findnew_thread(&session->machines.host, pid, 0);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5ad2664..735b343 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -17,7 +17,7 @@ struct thread {
 	bool			comm_set;
 	char			*comm;
 	int			comm_len;
-
+	u64			t_exit;
 	void			*priv;
 };
 
-- 
1.7.10.1

