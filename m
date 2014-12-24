Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaLXHPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:15:25 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39890 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaLXHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:22 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/37] perf tools: Maintain map groups list in a leader thread
Date: Wed, 24 Dec 2014 16:15:13 +0900
Message-Id: <1419405333-27952-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support multi-threaded perf report, we need to maintain time-sorted
map groups.  Add ->mg_list member to struct thread and sort the list
by time.  Now leader threads have one more refcnt for map groups in
the list so also update the thread-mg-share test case.

Currently only add a new map groups when an exec (comm) event is
received.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/thread-mg-share.c |  7 +++-
 tools/perf/util/event.c            |  2 +
 tools/perf/util/machine.c          |  2 +-
 tools/perf/util/map.c              |  1 +
 tools/perf/util/map.h              |  2 +
 tools/perf/util/thread.c           | 80 +++++++++++++++++++++++++++++++++++++-
 tools/perf/util/thread.h           |  3 ++
 7 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
index b028499dd3cf..8933e01d0549 100644
--- a/tools/perf/tests/thread-mg-share.c
+++ b/tools/perf/tests/thread-mg-share.c
@@ -23,6 +23,9 @@ int test__thread_mg_share(void)
 	 * with several threads and checks they properly share and
 	 * maintain map groups info (struct map_groups).
 	 *
+	 * Note that a leader thread has one more refcnt for its
+	 * (current) map groups.
+	 *
 	 * thread group (pid: 0, tids: 0, 1, 2, 3)
 	 * other  group (pid: 4, tids: 4, 5)
 	*/
@@ -43,7 +46,7 @@ int test__thread_mg_share(void)
 			leader && t1 && t2 && t3 && other);
 
 	mg = leader->mg;
-	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 4);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 5);
 
 	/* test the map groups pointer is shared */
 	TEST_ASSERT_VAL("map groups don't match", mg == t1->mg);
@@ -59,7 +62,7 @@ int test__thread_mg_share(void)
 	TEST_ASSERT_VAL("failed to find other leader", other_leader);
 
 	other_mg = other->mg;
-	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 2);
+	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 3);
 
 	TEST_ASSERT_VAL("map groups don't match", other_mg == other_leader->mg);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ff7594a27c73..2d04949bdc7d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -750,6 +750,8 @@ void thread__find_addr_map(struct thread *thread, u8 cpumode,
 		return;
 	}
 
+	BUG_ON(mg == NULL);
+
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
 		mg = &machine->kmaps;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 2cc088d71922..031bace39fdc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -330,7 +330,7 @@ static void machine__update_thread_pid(struct machine *machine,
 		goto out_err;
 
 	if (!leader->mg)
-		leader->mg = map_groups__new(machine);
+		thread__set_map_groups(leader, map_groups__new(machine), 0);
 
 	if (!leader->mg)
 		goto out_err;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 62ca9f2607d5..f0c1e2a24fee 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -422,6 +422,7 @@ void map_groups__init(struct map_groups *mg, struct machine *machine)
 	}
 	mg->machine = machine;
 	mg->refcnt = 1;
+	mg->timestamp = 0;
 }
 
 static void maps__delete(struct rb_root *maps)
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 6951a9d42339..dd92510b03d1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -61,7 +61,9 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	u64		 timestamp;
 	int		 refcnt;
+	struct list_head list;
 };
 
 struct map_groups *map_groups__new(struct machine *machine);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index f2465f17cf16..109ceb5e2a85 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -10,13 +10,64 @@
 #include "comm.h"
 #include "unwind.h"
 
+struct map_groups *thread__get_map_groups(struct thread *thread, u64 timestamp)
+{
+	struct map_groups *mg;
+
+	list_for_each_entry(mg, &thread->mg_list, list)
+		if (timestamp >= mg->timestamp)
+			return mg;
+
+	return thread->mg;
+}
+
+int thread__set_map_groups(struct thread *thread, struct map_groups *mg,
+			   u64 timestamp)
+{
+	struct list_head *pos;
+	struct map_groups *old;
+
+	if (mg == NULL)
+		return -ENOMEM;
+
+	/*
+	 * Only a leader thread can have map groups list - others
+	 * reference it through map_groups__get.  This means the
+	 * leader thread will have one more refcnt than others.
+	 */
+	if (thread->tid != thread->pid_)
+		return -EINVAL;
+
+	if (thread->mg) {
+		BUG_ON(thread->mg->refcnt <= 1);
+		map_groups__put(thread->mg);
+	}
+
+	/* sort by time */
+	list_for_each(pos, &thread->mg_list) {
+		old = list_entry(pos, struct map_groups, list);
+		if (timestamp > old->timestamp)
+			break;
+	}
+
+	list_add_tail(&mg->list, pos);
+	mg->timestamp = timestamp;
+
+	/* set current ->mg to most recent one */
+	thread->mg = list_first_entry(&thread->mg_list, struct map_groups, list);
+	/* increase one more refcnt for current */
+	map_groups__get(thread->mg);
+
+	return 0;
+}
+
 int thread__init_map_groups(struct thread *thread, struct machine *machine)
 {
 	struct thread *leader;
 	pid_t pid = thread->pid_;
 
 	if (pid == thread->tid || pid == -1) {
-		thread->mg = map_groups__new(machine);
+		thread__set_map_groups(thread, map_groups__new(machine), 0);
 	} else {
 		leader = machine__findnew_thread(machine, pid, pid);
 		if (leader)
@@ -39,6 +90,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 		INIT_LIST_HEAD(&thread->node);
+		INIT_LIST_HEAD(&thread->mg_list);
 
 		if (unwind__prepare_access(thread) < 0)
 			goto err_thread;
@@ -67,6 +119,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
+	struct map_groups *mg, *tmp_mg;
 
 	thread_stack__free(thread);
 
@@ -74,6 +127,11 @@ void thread__delete(struct thread *thread)
 		map_groups__put(thread->mg);
 		thread->mg = NULL;
 	}
+	/* only leader threads have mg list */
+	list_for_each_entry_safe(mg, tmp_mg, &thread->mg_list, list) {
+		list_del(&mg->list);
+		map_groups__put(mg);
+	}
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
@@ -150,6 +208,26 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 			unwind__flush_access(thread);
 	}
 
+	if (exec) {
+		struct machine *machine;
+
+		BUG_ON(thread->mg == NULL || thread->mg->machine == NULL);
+
+		if (thread->tid != thread->pid_) {
+			/* now it'll be a new leader */
+			thread->pid_ = thread->tid;
+
+			/* current mg of leader thread needs one more refcnt */
+			map_groups__get(thread->mg);
+
+			thread__set_map_groups(thread, thread->mg,
+					       thread->mg->timestamp);
+		}
+
+		machine = thread->mg->machine;
+		thread__set_map_groups(thread, map_groups__new(machine), timestamp);
+	}
+
 	thread->comm_set = true;
 
 	return 0;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5c07cee3b64e..8b9a67764613 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -14,6 +14,7 @@ struct thread {
 	struct rb_node	 	rb_node;
 	struct list_head 	node;
 	struct map_groups	*mg;
+	struct list_head	mg_list;
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
@@ -56,6 +57,8 @@ struct comm *thread__exec_comm(const struct thread *thread);
 struct comm *thread__comm_time(const struct thread *thread, u64 timestamp);
 const char *thread__comm_str(const struct thread *thread);
 const char *thread__comm_time_str(const struct thread *thread, u64 timestamp);
+struct map_groups *thread__get_map_groups(struct thread *thread, u64 timestamp);
+int thread__set_map_groups(struct thread *thread, struct map_groups *mg, u64 timestamp);
 void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
-- 
2.1.3

