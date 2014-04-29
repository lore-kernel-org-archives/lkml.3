Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaD2GrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:47:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD2GrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:47:04 -0400
Date: Mon, 28 Apr 2014 23:46:39 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cddcef607782966f1601808c17fe9c4c5f79f9f4@git.kernel.org>
Cc: eranian@google.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, eranian@google.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
In-Reply-To: <1397490723-1992-5-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Share map_groups among threads of the same group
Git-Commit-ID: cddcef607782966f1601808c17fe9c4c5f79f9f4
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

Commit-ID:  cddcef607782966f1601808c17fe9c4c5f79f9f4
Gitweb:     http://git.kernel.org/tip/cddcef607782966f1601808c17fe9c4c5f79f9f4
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 9 Apr 2014 20:54:29 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Apr 2014 13:43:33 +0200

perf tools: Share map_groups among threads of the same group

Sharing map groups within all process threads. This way
there's only one copy of mmap info and it's reachable
from any thread within the process.

Original-patch-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1397490723-1992-5-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/machine.c | 11 +++++++++++
 tools/perf/util/thread.c  | 48 ++++++++++++++++++++++++++++++++++-------------
 tools/perf/util/thread.h  |  1 +
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..98ec56d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -316,6 +316,17 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
 		machine->last_match = th;
+
+		/*
+		 * We have to initialize map_groups separately
+		 * after rb tree is updated.
+		 *
+		 * The reason is that we call machine__findnew_thread
+		 * within thread__init_map_groups to find the thread
+		 * leader and that would screwed the rb tree.
+		 */
+		if (thread__init_map_groups(th, machine))
+			return NULL;
 	}
 
 	return th;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b501848..2fde0d5 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,6 +8,22 @@
 #include "debug.h"
 #include "comm.h"
 
+int thread__init_map_groups(struct thread *thread, struct machine *machine)
+{
+	struct thread *leader;
+	pid_t pid = thread->pid_;
+
+	if (pid == thread->tid) {
+		thread->mg = map_groups__new();
+	} else {
+		leader = machine__findnew_thread(machine, pid, pid);
+		if (leader)
+			thread->mg = map_groups__get(leader->mg);
+	}
+
+	return thread->mg ? 0 : -1;
+}
+
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
 	char *comm_str;
@@ -15,10 +31,6 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	struct thread *thread = zalloc(sizeof(*thread));
 
 	if (thread != NULL) {
-		thread->mg = map_groups__new();
-		if (thread->mg == NULL)
-			goto out_free;
-
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
@@ -40,8 +52,6 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	return thread;
 
 err_thread:
-	map_groups__delete(thread->mg);
-out_free:
 	free(thread);
 	return NULL;
 }
@@ -126,9 +136,26 @@ void thread__insert_map(struct thread *thread, struct map *map)
 	map_groups__insert(thread->mg, map);
 }
 
+static int thread__clone_map_groups(struct thread *thread,
+				    struct thread *parent)
+{
+	int i;
+
+	/* This is new thread, we share map groups for process. */
+	if (thread->pid_ == parent->pid_)
+		return 0;
+
+	/* But this one is new process, copy maps. */
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		if (map_groups__clone(thread->mg, parent->mg, i) < 0)
+			return -ENOMEM;
+
+	return 0;
+}
+
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 {
-	int i, err;
+	int err;
 
 	if (parent->comm_set) {
 		const char *comm = thread__comm_str(parent);
@@ -140,13 +167,8 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 		thread->comm_set = true;
 	}
 
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (map_groups__clone(thread->mg, parent->mg, i) < 0)
-			return -ENOMEM;
-
 	thread->ppid = parent->tid;
-
-	return 0;
+	return thread__clone_map_groups(thread, parent);
 }
 
 void thread__find_cpumode_addr_location(struct thread *thread,
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index bee1eb0..3c0c272 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -30,6 +30,7 @@ struct machine;
 struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
+int thread__init_map_groups(struct thread *thread, struct machine *machine);
 void thread__delete(struct thread *thread);
 static inline void thread__exited(struct thread *thread)
 {
