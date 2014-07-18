Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbaGREYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:24:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33110 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaGREYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:24:40 -0400
Date: Thu, 17 Jul 2014 21:23:15 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1fcb8768636d38cb6fdfeef83a5ee596c4bd9c56@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-2-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Fix the value used for unknown pids
Git-Commit-ID: 1fcb8768636d38cb6fdfeef83a5ee596c4bd9c56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fcb8768636d38cb6fdfeef83a5ee596c4bd9c56
Gitweb:     http://git.kernel.org/tip/1fcb8768636d38cb6fdfeef83a5ee596c4bd9c56
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:25 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:33 -0300

perf machine: Fix the value used for unknown pids

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
index c38d06c..b7f555a 100644
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
index e9b943a..5b80877 100644
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
index 64a186e..c2f4ca9 100644
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
index 2fde0d5..7a32f44 100644
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
