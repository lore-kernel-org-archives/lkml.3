Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074AbaGRE1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:27:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934821AbaGRE1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:48 -0400
Date: Thu, 17 Jul 2014 21:26:56 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-29ce36121e6738012aaf00d983d25260627f2b0d@git.kernel.org>
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
In-Reply-To: <1405498033-23817-1-git-send-email-adrian.hunter@intel.com>
References: <1405498033-23817-1-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Fix map groups of threads with unknown pids
Git-Commit-ID: 29ce36121e6738012aaf00d983d25260627f2b0d
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

Commit-ID:  29ce36121e6738012aaf00d983d25260627f2b0d
Gitweb:     http://git.kernel.org/tip/29ce36121e6738012aaf00d983d25260627f2b0d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 16 Jul 2014 11:07:13 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 10:31:02 -0300

perf machine: Fix map groups of threads with unknown pids

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
index 5b80877..5484fa4 100644
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
