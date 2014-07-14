Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaGNKEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:04:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:29944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbaGNKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434084"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/41] perf tools: Fix map groups of threads with unknown pids
Date: Mon, 14 Jul 2014 13:02:26 +0300
Message-Id: <1405332185-4050-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events like sched_switch do not provide a pid (tgid)
which can result in threads with an unknown pid.  If
the pid is later discovered, join the map groups.
Note the thread's map groups should be empty because
they are populated by MMAP events which do provide the
pid and tid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 22 ++++++++++++++++------
 tools/perf/util/map.c     | 14 ++++++++++++++
 tools/perf/util/map.h     |  1 +
 tools/perf/util/thread.c  | 35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/thread.h  |  1 +
 5 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5b80877..0fa93c1 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -272,6 +272,17 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
+static void machine__update_thread_pid(struct machine *machine,
+				       struct thread *th, pid_t pid)
+{
+	if (pid != th->pid_ && pid != -1 && th->pid_ == -1) {
+		th->pid_ = pid;
+		if (thread__join_map_groups(th, machine))
+			pr_err("Failed to join map groups for %d:%d\n",
+			       th->pid_, th->tid);
+	}
+}
+
 static struct thread *__machine__findnew_thread(struct machine *machine,
 						pid_t pid, pid_t tid,
 						bool create)
@@ -285,10 +296,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (machine->last_match && machine->last_match->tid == tid) {
-		if (pid != -1 && pid != machine->last_match->pid_)
-			machine->last_match->pid_ = pid;
-		return machine->last_match;
+	th = machine->last_match;
+	if (th && th->tid == tid) {
+		machine__update_thread_pid(machine, th, pid);
+		return th;
 	}
 
 	while (*p != NULL) {
@@ -297,8 +308,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 
 		if (th->tid == tid) {
 			machine->last_match = th;
-			if (pid != -1 && pid != th->pid_)
-				th->pid_ = pid;
+			machine__update_thread_pid(machine, th, pid);
 			return th;
 		}
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 25c571f..7af1480 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -454,6 +454,20 @@ void map_groups__exit(struct map_groups *mg)
 	}
 }
 
+bool map_groups__empty(struct map_groups *mg)
+{
+	int i;
+
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		if (maps__first(&mg->maps[i]))
+			return false;
+		if (!list_empty(&mg->removed_maps[i]))
+			return false;
+	}
+
+	return true;
+}
+
 struct map_groups *map_groups__new(void)
 {
 	struct map_groups *mg = malloc(sizeof(*mg));
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7758c72..5806a90 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -66,6 +66,7 @@ struct map_groups {
 
 struct map_groups *map_groups__new(void);
 void map_groups__delete(struct map_groups *mg);
+bool map_groups__empty(struct map_groups *mg);
 
 static inline struct map_groups *map_groups__get(struct map_groups *mg)
 {
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7a32f44..ca94295 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -24,6 +24,41 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
 	return thread->mg ? 0 : -1;
 }
 
+int thread__join_map_groups(struct thread *thread, struct machine *machine)
+{
+	struct thread *leader;
+	pid_t pid = thread->pid_;
+
+	if (pid == thread->tid)
+		return 0;
+
+	leader = machine__findnew_thread(machine, pid, pid);
+	if (!leader)
+		return -ENOMEM;
+
+	if (!leader->mg)
+		leader->mg = map_groups__new();
+
+	if (!leader->mg)
+		return -ENOMEM;
+
+	if (thread->mg) {
+		/*
+		 * Maps are created from MMAP events which provide the pid and
+		 * tid.  Consequently there never should be any maps on a thread
+		 * with an unknown pid.  Just print an error if there are.
+		 */
+		if (!map_groups__empty(thread->mg))
+			pr_err("Discarding thread maps for %d:%d\n",
+			       thread->pid_, thread->tid);
+		map_groups__delete(thread->mg);
+	}
+
+	thread->mg = map_groups__get(leader->mg);
+
+	return 0;
+}
+
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
 	char *comm_str;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 3c0c272..9de0629 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -31,6 +31,7 @@ struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
 int thread__init_map_groups(struct thread *thread, struct machine *machine);
+int thread__join_map_groups(struct thread *thread, struct machine *machine);
 void thread__delete(struct thread *thread);
 static inline void thread__exited(struct thread *thread)
 {
-- 
1.8.3.2

