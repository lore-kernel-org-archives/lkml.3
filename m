Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbaGQQWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:22:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:52201 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952AbaGQQNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:31 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/33] perf machine: Fix the value used for unknown pids
Date: Thu, 17 Jul 2014 13:12:10 -0300
Message-Id: <1405613555-23380-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The value used for unknown pids cannot be zero because that is used by
the "idle" task.

Use -1 instead.  Also handle the unknown pid case when creating map
groups.

Note that, threads with an unknown pid should not occur because fork (or
synthesized) events precede the thread's existence.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 12 ++++++------
 tools/perf/util/machine.c  |  6 +++---
 tools/perf/util/session.c  |  5 +++--
 tools/perf/util/thread.c   |  2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c38d06c04775..b7f555add0c8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -935,8 +935,8 @@ static int latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, 0, prev_pid);
-	sched_in = machine__findnew_thread(machine, 0, next_pid);
+	sched_out = machine__findnew_thread(machine, -1, prev_pid);
+	sched_in = machine__findnew_thread(machine, -1, next_pid);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -979,7 +979,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 {
 	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
-	struct thread *thread = machine__findnew_thread(machine, 0, pid);
+	struct thread *thread = machine__findnew_thread(machine, -1, pid);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1012,7 +1012,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	struct thread *wakee;
 	u64 timestamp = sample->time;
 
-	wakee = machine__findnew_thread(machine, 0, pid);
+	wakee = machine__findnew_thread(machine, -1, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1072,7 +1072,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, 0, pid);
+	migrant = machine__findnew_thread(machine, -1, pid);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1290,7 +1290,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_in = machine__findnew_thread(machine, 0, next_pid);
+	sched_in = machine__findnew_thread(machine, -1, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e9b943acaa5e..5b8087728f28 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -34,7 +34,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		return -ENOMEM;
 
 	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(machine, 0,
+		struct thread *thread = machine__findnew_thread(machine, -1,
 								pid);
 		char comm[64];
 
@@ -286,7 +286,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	 * the full rbtree:
 	 */
 	if (machine->last_match && machine->last_match->tid == tid) {
-		if (pid && pid != machine->last_match->pid_)
+		if (pid != -1 && pid != machine->last_match->pid_)
 			machine->last_match->pid_ = pid;
 		return machine->last_match;
 	}
@@ -297,7 +297,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 
 		if (th->tid == tid) {
 			machine->last_match = th;
-			if (pid && pid != th->pid_)
+			if (pid != -1 && pid != th->pid_)
 				th->pid_ = pid;
 			return th;
 		}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64a186edc7be..c2f4ca917469 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1083,13 +1083,14 @@ void perf_event_header__bswap(struct perf_event_header *hdr)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, 0, pid);
+	return machine__findnew_thread(&session->machines.host, -1, pid);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, 0);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(&session->machines.host, 0, 0);
 	if (thread == NULL || thread__set_comm(thread, "swapper", 0)) {
 		pr_err("problem inserting idle task.\n");
 		thread = NULL;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2fde0d5e40b5..7a32f447a8e7 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -13,7 +13,7 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
 	struct thread *leader;
 	pid_t pid = thread->pid_;
 
-	if (pid == thread->tid) {
+	if (pid == thread->tid || pid == -1) {
 		thread->mg = map_groups__new();
 	} else {
 		leader = machine__findnew_thread(machine, pid, pid);
-- 
1.9.3

