Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3GZWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:04:25 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48837 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3GZWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:04:20 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: sample after exit loses thread correlation
Date: Fri, 26 Jul 2013 16:04:14 -0600
Message-Id: <1374876254-44372-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occassionally events (e.g., context-switch, sched tracepoints) are losing
the conversion of sample data associated with a thread. For example:

$ perf record -e sched:sched_switch -c 1 -a -- sleep 5
$ perf script
<selected events shown>
    ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
    ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
:30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

The last line lost the conversion from tid to comm. If you look at the events
(perf script -D) you see why - SAMPLE event is generated after the EXIT:

0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
... thread: :30482:30482

When perf processes the EXIT event the thread is moved to the dead_threads
list. When the SAMPLE event is processed no thread exists for the pid so a new
one is created by machine__findnew_thread.

This patch addresses the problem by saving the exit time and checking the
dead_threads list for the requested tid. If the time passed into
machine_findnew_thread is non-0 the dead_threads list is walked looking for
the tid. If the thread struct associated with the tid exited within 1 msec
of the time passed in the thread is considered a match and returned.

If samples do not contain timestamps then sample->time will be 0 and the
dead_threads list will not be checked. -1 can be used to force always checking
the dead_threads list and returning a match.

With this patch we get the previous example shows:

ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

and

0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
... thread: ls:30482

v2: Rebased to latest perf/core branch. Changed time comparison to use
    a macro which explicitly shows the time basis

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
 tools/perf/builtin-kmem.c     |    3 +--
 tools/perf/builtin-kvm.c      |    2 +-
 tools/perf/builtin-lock.c     |    2 +-
 tools/perf/builtin-sched.c    |   16 +++++++--------
 tools/perf/builtin-script.c   |    2 +-
 tools/perf/builtin-trace.c    |    6 +++---
 tools/perf/perf.h             |    3 +++
 tools/perf/tests/hists_link.c |    2 +-
 tools/perf/util/build-id.c    |    9 ++++-----
 tools/perf/util/event.c       |   10 ++++++++--
 tools/perf/util/machine.c     |   44 ++++++++++++++++++++++++++++++-----------
 tools/perf/util/machine.h     |    6 ++++--
 tools/perf/util/session.c     |    2 +-
 tools/perf/util/thread.h      |    2 +-
 15 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1d8de2e..d65d546 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, event->ip.pid);
+	thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b49f5c5..8283ef2 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,8 +305,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
-
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 24b78ae..1c85050 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -691,7 +691,7 @@ static int process_sample_event(struct perf_tool *tool,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->tid, sample->time);
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
 						 tool);
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 76543a4..037346c 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -805,7 +805,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->tid, sample->time);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 948183a..74e004a 100644
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
 
@@ -1425,7 +1425,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->tid, sample->time);
 	int err = 0;
 
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1cad370..8b405f1 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -480,7 +480,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.tid, sample->time);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0e4b67f..abf2c3e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -301,7 +301,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	char *msg;
 	void *args;
 	size_t printed = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid, sample->time);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 	struct thread_trace *ttrace = thread__trace(thread);
 
@@ -344,7 +344,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 {
 	int ret;
 	u64 duration = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid, sample->time);
 	struct thread_trace *ttrace = thread__trace(thread);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 
@@ -397,7 +397,7 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid, sample->time);
 	struct thread_trace *ttrace = thread__trace(thread);
 
 	if (ttrace == NULL)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..c2c0582 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -125,6 +125,9 @@
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
+#ifndef NSECS_PER_MSEC
+#define NSECS_PER_MSEC          1000000ULL
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
index 5295625..1286dc0 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -18,13 +18,13 @@
 
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
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
@@ -43,11 +43,10 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 
 static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 				       union perf_event *event,
-				       struct perf_sample *sample
-				       __maybe_unused,
+				       struct perf_sample *sample,
 				       struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->fork.tid, sample->time);
 
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
 		    event->fork.ppid, event->fork.ptid);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9541270..b6c0ddb 100644
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
 
@@ -677,7 +683,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  symbol_filter_t filter)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid, sample->time);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f9f9d63..07e3d5b 100644
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
 
 static struct thread *__machine__findnew_thread(struct machine *machine, pid_t tid,
-						bool create)
+						bool create, u64 sample_time)
 {
 	struct rb_node **p = &machine->threads.rb_node;
 	struct rb_node *parent = NULL;
@@ -263,6 +263,26 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
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
+			if (th->tid != tid)
+				continue;
+
+			if ((sample_time == (u64) -1) ||
+			    ((th->t_exit < sample_time) &&
+			    ((sample_time - th->t_exit) < NSECS_PER_MSEC))) {
+				return th;
+			}
+		}
+	}
+
 	if (!create)
 		return NULL;
 
@@ -276,19 +296,21 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 	return th;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
+struct thread *machine__findnew_thread(struct machine *machine, pid_t tid,
+				       u64 sample_time)
 {
-	return __machine__findnew_thread(machine, tid, true);
+	return __machine__findnew_thread(machine, tid, true, sample_time);
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid)
+struct thread *machine__find_thread(struct machine *machine, pid_t tid,
+				    u64 sample_time)
 {
-	return __machine__findnew_thread(machine, tid, false);
+	return __machine__findnew_thread(machine, tid, false, sample_time);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->comm.tid, 0);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -969,7 +991,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread(machine, event->mmap.pid, 0);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -996,8 +1018,8 @@ out_problem:
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *thread = machine__findnew_thread(machine, event->fork.tid, 0);
+	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid, 0);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
@@ -1024,7 +1046,7 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 
 int machine__process_exit_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine, event->fork.tid, 0);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5bb6244..4fb6346 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -37,7 +37,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid);
+struct thread *machine__find_thread(struct machine *machine, pid_t tid,
+				    u64 sample_time);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event);
 int machine__process_exit_event(struct machine *machine, union perf_event *event);
@@ -101,7 +102,8 @@ static inline bool machine__is_host(struct machine *machine)
 	return machine ? machine->pid == HOST_KERNEL_ID : false;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
+struct thread *machine__findnew_thread(struct machine *machine, pid_t tid,
+				       u64 sample_time);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 272c9cf..9c5b945 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -991,7 +991,7 @@ void perf_event_header__bswap(struct perf_event_header *self)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, pid);
+	return machine__findnew_thread(&session->machines.host, pid, 0);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0fe1f9c..b2caf21 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,7 +18,7 @@ struct thread {
 	bool			comm_set;
 	char			*comm;
 	int			comm_len;
-
+	u64			t_exit;
 	void			*priv;
 };
 
-- 
1.7.10.1

