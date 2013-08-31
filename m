Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3HaISc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:18:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3HaIOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:14:46 -0400
Date: Sat, 31 Aug 2013 01:13:10 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-314add6b1f045b59ca39683bd0cbc5310cd203f2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-2-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: change machine__findnew_thread()
  to set thread pid
Git-Commit-ID: 314add6b1f045b59ca39683bd0cbc5310cd203f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:13:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  314add6b1f045b59ca39683bd0cbc5310cd203f2
Gitweb:     http://git.kernel.org/tip/314add6b1f045b59ca39683bd0cbc5310cd203f2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:03 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 11:51:31 -0300

perf tools: change machine__findnew_thread() to set thread pid

Add a new parameter for 'pid' to machine__findnew_thread().
Change callers to pass 'pid' when it is known.

Note that callers sometimes want to find the main thread
which has the memory maps.  The main thread has tid == pid
so the usage in that case is:

	machine__findnew_thread(machine, pid, pid)

whereas the usage to find the specific thread is:

	machine__findnew_thread(machine, pid, tid)

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c     |  2 +-
 tools/perf/builtin-kmem.c       |  3 ++-
 tools/perf/builtin-kvm.c        |  2 +-
 tools/perf/builtin-lock.c       |  3 ++-
 tools/perf/builtin-sched.c      | 20 +++++++++++---------
 tools/perf/builtin-script.c     |  3 ++-
 tools/perf/builtin-trace.c      | 10 +++++++---
 tools/perf/tests/code-reading.c |  4 ++--
 tools/perf/tests/hists_link.c   |  3 ++-
 tools/perf/util/build-id.c      |  7 +++++--
 tools/perf/util/event.c         |  3 ++-
 tools/perf/util/machine.c       | 22 +++++++++++++++-------
 tools/perf/util/machine.h       |  3 ++-
 tools/perf/util/session.c       |  2 +-
 14 files changed, 55 insertions(+), 32 deletions(-)

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
index 6cd4de5..47b3540 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -815,7 +815,7 @@ static int process_sample_event(struct perf_tool *tool,
 	if (skip_sample(kvm, sample))
 		return 0;
 
-	thread = machine__findnew_thread(machine, sample->tid);
+	thread = machine__findnew_thread(machine, sample->pid, sample->tid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
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
index f809cc7..d8c51b2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -724,8 +724,10 @@ static int replay_fork_event(struct perf_sched *sched,
 {
 	struct thread *child, *parent;
 
-	child = machine__findnew_thread(machine, event->fork.tid);
-	parent = machine__findnew_thread(machine, event->fork.ptid);
+	child = machine__findnew_thread(machine, event->fork.pid,
+					event->fork.tid);
+	parent = machine__findnew_thread(machine, event->fork.ppid,
+					 event->fork.ptid);
 
 	if (child == NULL || parent == NULL) {
 		pr_debug("thread does not exist on fork event: child %p, parent %p\n",
@@ -934,8 +936,8 @@ static int latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, 0, prev_pid);
+	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -978,7 +980,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 {
 	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
-	struct thread *thread = machine__findnew_thread(machine, pid);
+	struct thread *thread = machine__findnew_thread(machine, 0, pid);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1016,7 +1018,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	if (!success)
 		return 0;
 
-	wakee = machine__findnew_thread(machine, pid);
+	wakee = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1070,7 +1072,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, pid);
+	migrant = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1289,8 +1291,8 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, prev_pid);
-	sched_in = machine__findnew_thread(machine, next_pid);
+	sched_out = machine__findnew_thread(machine, 0, prev_pid);
+	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2ad9d5b..d82712f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -501,7 +501,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b72afc7..88387c5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -521,7 +521,8 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->tid);
+	thread = machine__findnew_thread(&trace->host, sample->pid,
+					 sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
@@ -572,7 +573,8 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->tid);
+	thread = machine__findnew_thread(&trace->host, sample->pid,
+					 sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
@@ -628,7 +630,9 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread *thread = machine__findnew_thread(&trace->host,
+							sample->pid,
+							sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread, trace->output);
 
 	if (ttrace == NULL)
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index df9afd9..6fb781d 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -257,7 +257,7 @@ static int process_sample_event(struct machine *machine,
 		return -1;
 	}
 
-	thread = machine__findnew_thread(machine, sample.pid);
+	thread = machine__findnew_thread(machine, sample.pid, sample.pid);
 	if (!thread) {
 		pr_debug("machine__findnew_thread failed\n");
 		return -1;
@@ -446,7 +446,7 @@ static int do_test_code_reading(bool try_kcore)
 		goto out_err;
 	}
 
-	thread = machine__findnew_thread(machine, pid);
+	thread = machine__findnew_thread(machine, pid, pid);
 	if (!thread) {
 		pr_debug("machine__findnew_thread failed\n");
 		goto out_err;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 50bfb01..87f9f72 100644
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
index 49713ae..61cecf9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -686,7 +686,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
+							event->ip.pid);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 59486c1..1dca61f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -32,7 +32,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		return -ENOMEM;
 
 	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(machine, pid);
+		struct thread *thread = machine__findnew_thread(machine, 0,
+								pid);
 		char comm[64];
 
 		if (thread == NULL)
@@ -302,9 +303,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
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
@@ -314,7 +316,9 @@ struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread = machine__findnew_thread(machine,
+							event->comm.pid,
+							event->comm.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -1012,7 +1016,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread(machine, event->mmap.pid,
+					 event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1051,13 +1056,16 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *parent = machine__findnew_thread(machine,
+							event->fork.ppid,
+							event->fork.ptid);
 
 	/* if a thread currently exists for the thread id remove it */
 	if (thread != NULL)
 		machine__remove_thread(machine, thread);
 
-	thread = machine__findnew_thread(machine, event->fork.tid);
+	thread = machine__findnew_thread(machine, event->fork.pid,
+					 event->fork.tid);
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 603ffba..0df925b 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -106,7 +106,8 @@ static inline bool machine__is_host(struct machine *machine)
 	return machine ? machine->pid == HOST_KERNEL_ID : false;
 }
 
-struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
+				       pid_t tid);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index de16a77..57b6f38 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1099,7 +1099,7 @@ void perf_event_header__bswap(struct perf_event_header *self)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, pid);
+	return machine__findnew_thread(&session->machines.host, 0, pid);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
