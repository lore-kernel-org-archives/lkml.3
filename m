Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbaGQQOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:52588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934903AbaGQQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:45 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/33] perf machine: Fix map groups of threads with unknown pids
Date: Thu, 17 Jul 2014 13:12:27 -0300
Message-Id: <1405613555-23380-26-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Events like sched_switch do not provide a pid (tgid) which can result in
threads with an unknown pid.  If the pid is later discovered, join the
map groups.

Note the thread's map groups should be empty because they are populated
by MMAP events which do provide the pid and tid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405498033-23817-1-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/map.c     | 14 ++++++++++++
 tools/perf/util/map.h     |  1 +
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5b8087728f28..5484fa4385fc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -272,6 +272,52 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
+static void machine__update_thread_pid(struct machine *machine,
+				       struct thread *th, pid_t pid)
+{
+	struct thread *leader;
+
+	if (pid == th->pid_ || pid == -1 || th->pid_ != -1)
+		return;
+
+	th->pid_ = pid;
+
+	if (th->pid_ == th->tid)
+		return;
+
+	leader = machine__findnew_thread(machine, th->pid_, th->pid_);
+	if (!leader)
+		goto out_err;
+
+	if (!leader->mg)
+		leader->mg = map_groups__new();
+
+	if (!leader->mg)
+		goto out_err;
+
+	if (th->mg == leader->mg)
+		return;
+
+	if (th->mg) {
+		/*
+		 * Maps are created from MMAP events which provide the pid and
+		 * tid.  Consequently there never should be any maps on a thread
+		 * with an unknown pid.  Just print an error if there are.
+		 */
+		if (!map_groups__empty(th->mg))
+			pr_err("Discarding thread maps for %d:%d\n",
+			       th->pid_, th->tid);
+		map_groups__delete(th->mg);
+	}
+
+	th->mg = map_groups__get(leader->mg);
+
+	return;
+
+out_err:
+	pr_err("Failed to join map groups for %d:%d\n", th->pid_, th->tid);
+}
+
 static struct thread *__machine__findnew_thread(struct machine *machine,
 						pid_t pid, pid_t tid,
 						bool create)
@@ -285,10 +331,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
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
@@ -297,8 +343,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 
 		if (th->tid == tid) {
 			machine->last_match = th;
-			if (pid != -1 && pid != th->pid_)
-				th->pid_ = pid;
+			machine__update_thread_pid(machine, th, pid);
 			return th;
 		}
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 25c571f4cba6..7af14807ee90 100644
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
index 7758c72522ef..5806a906198b 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -66,6 +66,7 @@ struct map_groups {
 
 struct map_groups *map_groups__new(void);
 void map_groups__delete(struct map_groups *mg);
+bool map_groups__empty(struct map_groups *mg);
 
 static inline struct map_groups *map_groups__get(struct map_groups *mg)
 {
-- 
1.9.3

