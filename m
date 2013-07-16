Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3GPGcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:32:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:21175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3GPGcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,674,1367996400"; 
   d="scan'208";a="365882663"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V6 04/12] perf tools: change machine__findnew_thread() to set thread pid
Date: Tue, 16 Jul 2013 09:38:10 +0300
Message-Id: <1373956698-27540-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new parameter for 'pid' to machine__findnew_thread().
Change callers to pass 'pid' when it is known.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c   |  2 +-
 tools/perf/builtin-kmem.c     |  3 ++-
 tools/perf/builtin-kvm.c      |  3 ++-
 tools/perf/builtin-lock.c     |  3 ++-
 tools/perf/builtin-sched.c    | 17 +++++++++--------
 tools/perf/builtin-script.c   |  3 ++-
 tools/perf/builtin-trace.c    | 12 +++++++++---
 tools/perf/tests/hists_link.c |  3 ++-
 tools/perf/util/build-id.c    |  7 +++++--
 tools/perf/util/event.c       |  3 ++-
 tools/perf/util/machine.c     | 23 ++++++++++++++++-------
 tools/perf/util/machine.h     |  3 ++-
 tools/perf/util/session.c     |  2 +-
 13 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1d8de2e..0d4ae1d 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, event->ip.pid);
+	thread = machine__findnew_thread(machine, event->ip.pid, event->ip.pid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b49f5c5..c324778 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,7 +305,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 24b78ae..ecbbec8 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -691,7 +691,8 @@ static int process_sample_event(struct perf_tool *tool,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->tid);
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
 						 tool);
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 76543a4..ee33ba2 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -805,7 +805,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 948183a..49593a0 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -934,8 +934,8 @@ static int latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, 0, prev_pid);
+	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -978,7 +978,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 {
 	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
-	struct thread *thread = machine__findnew_thread(machine, pid);
+	struct thread *thread = machine__findnew_thread(machine, 0, pid);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1016,7 +1016,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	if (!success)
 		return 0;
 
-	wakee = machine__findnew_thread(machine, pid);
+	wakee = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1070,7 +1070,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, pid);
+	migrant = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1289,8 +1289,8 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, 0, prev_pid);
+	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
@@ -1425,7 +1425,8 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->tid);
 	int err = 0;
 
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ecb6979..b094b33 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -480,7 +480,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0e4b67f..f8bc748 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -301,7 +301,9 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	char *msg;
 	void *args;
 	size_t printed = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host,
+							sample->pid,
+							sample->tid);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 	struct thread_trace *ttrace = thread__trace(thread);
 
@@ -344,7 +346,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 {
 	int ret;
 	u64 duration = 0;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host,
+							sample->pid,
+							sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 
@@ -397,7 +401,9 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host,
+							sample->pid,
+							sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread);
 
 	if (ttrace == NULL)
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 89085a9..5a178d5 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -88,7 +88,8 @@ static struct machine *setup_fake_machine(struct machines *machines)
 	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
 		struct thread *thread;
 
-		thread = machine__findnew_thread(machine, fake_threads[i].pid);
+		thread = machine__findnew_thread(machine, fake_threads[i].pid,
+						 fake_threads[i].pid);
 		if (thread == NULL)
 			goto out;
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5295625..0f9d27a 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -24,7 +24,8 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.pid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
@@ -47,7 +48,9 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 				       __maybe_unused,
 				       struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *thread = machine__findnew_thread(machine,
+							event->fork.pid,
+							event->fork.tid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
 		    event->fork.ppid, event->fork.ptid);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9541270..ec494a3 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -677,7 +677,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  symbol_filter_t filter)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.pid);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 67ba572..16b84ac 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -30,7 +30,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		return -ENOMEM;
 
 	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(machine, pid);
+		struct thread *thread = machine__findnew_thread(machine, 0,
+								pid);
 		char comm[64];
 
 		if (thread == NULL)
@@ -282,9 +283,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	return th;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
+				       pid_t tid)
 {
-	return __machine__findnew_thread(machine, 0, tid, true);
+	return __machine__findnew_thread(machine, pid, tid, true);
 }
 
 struct thread *machine__find_thread(struct machine *machine, pid_t tid)
@@ -294,7 +296,9 @@ struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread = machine__findnew_thread(machine,
+							event->comm.pid,
+							event->comm.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -975,7 +979,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread(machine, event->mmap.pid,
+					 event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1002,8 +1007,12 @@ out_problem:
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *thread = machine__findnew_thread(machine,
+							event->fork.pid,
+							event->fork.tid);
+	struct thread *parent = machine__findnew_thread(machine,
+							event->fork.ppid,
+							event->fork.ptid);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5bb6244..604be6b 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -101,7 +101,8 @@ static inline bool machine__is_host(struct machine *machine)
 	return machine ? machine->pid == HOST_KERNEL_ID : false;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
+				       pid_t tid);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d4c9a26..708c72b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -991,7 +991,7 @@ void perf_event_header__bswap(struct perf_event_header *self)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, pid);
+	return machine__findnew_thread(&session->machines.host, 0, pid);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
-- 
1.7.11.7

