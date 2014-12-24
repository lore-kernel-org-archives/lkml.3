Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaLXHQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:16:49 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40232 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaLXHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:44 -0500
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
Subject: [PATCH 28/37] perf tools: Add missing_threads rb tree
Date: Wed, 24 Dec 2014 16:15:24 +0900
Message-Id: <1419405333-27952-29-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it's possible to miss certain meta events like fork/exit and
in this case it can fail to find such thread in the machine's rbtree.
But adding a thread to the tree is dangerous since it's now executed
in multi-thread environment otherwise it'll add an overhead in order
to grab a lock for every search.  So adds a separate missing_threads
tree and protect it with a mutex.  It's expected to be accessed only
if a thread is not found in a normal tree.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/thread-lookup-time.c |  8 ++-
 tools/perf/util/build-id.c            |  9 +++-
 tools/perf/util/machine.c             | 91 +++++++++++++++++++++++------------
 tools/perf/util/machine.h             |  2 +
 tools/perf/util/session.c             |  8 +--
 tools/perf/util/thread.h              |  1 +
 6 files changed, 80 insertions(+), 39 deletions(-)

diff --git a/tools/perf/tests/thread-lookup-time.c b/tools/perf/tests/thread-lookup-time.c
index 6237ecf8caae..04cdde9329d6 100644
--- a/tools/perf/tests/thread-lookup-time.c
+++ b/tools/perf/tests/thread-lookup-time.c
@@ -7,7 +7,9 @@
 static int thread__print_cb(struct thread *th, void *arg __maybe_unused)
 {
 	printf("thread: %d, start time: %"PRIu64" %s\n",
-	       th->tid, th->start_time, th->dead ? "(dead)" : "");
+	       th->tid, th->start_time,
+	       th->dead ? "(dead)" : th->exited ? "(exited)" :
+	       th->missing ? "(missing)" : "");
 	return 0;
 }
 
@@ -105,6 +107,8 @@ static int lookup_with_timestamp(struct machine *machine)
 			machine__findnew_thread_time(machine, 0, 0, 70000) == t3);
 
 	machine__delete_threads(machine);
+	machine__delete_dead_threads(machine);
+	machine__delete_missing_threads(machine);
 	return 0;
 }
 
@@ -146,6 +150,8 @@ static int lookup_without_timestamp(struct machine *machine)
 			machine__findnew_thread_time(machine, 0, 0, -1ULL) == t3);
 
 	machine__delete_threads(machine);
+	machine__delete_dead_threads(machine);
+	machine__delete_missing_threads(machine);
 	return 0;
 }
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0c72680a977f..98446d089b08 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -60,7 +60,14 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 		    event->fork.ppid, event->fork.ptid);
 
 	if (thread) {
-		rb_erase(&thread->rb_node, &machine->threads);
+		if (thread->dead)
+			rb_erase(&thread->rb_node, &machine->dead_threads);
+		else if (thread->missing)
+			rb_erase(&thread->rb_node, &machine->missing_threads);
+		else
+			rb_erase(&thread->rb_node, &machine->threads);
+
+		list_del(&thread->node);
 		machine->last_match = NULL;
 		thread__delete(thread);
 	}
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ffce0bcd2d9a..c7492d4fde29 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -29,6 +29,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 
 	machine->threads = RB_ROOT;
 	machine->dead_threads = RB_ROOT;
+	machine->missing_threads = RB_ROOT;
 	machine->last_match = NULL;
 
 	machine->vdso_info = NULL;
@@ -89,6 +90,19 @@ static void dsos__delete(struct dsos *dsos)
 	}
 }
 
+void machine__delete_missing_threads(struct machine *machine)
+{
+	struct rb_node *nd = rb_first(&machine->missing_threads);
+
+	while (nd) {
+		struct thread *t = rb_entry(nd, struct thread, rb_node);
+
+		nd = rb_next(nd);
+		rb_erase(&t->rb_node, &machine->missing_threads);
+		thread__delete(t);
+	}
+}
+
 void machine__delete_dead_threads(struct machine *machine)
 {
 	struct rb_node *nd = rb_first(&machine->dead_threads);
@@ -438,11 +452,12 @@ static struct thread *__machine__findnew_thread_time(struct machine *machine,
 						     pid_t pid, pid_t tid,
 						     u64 timestamp, bool create)
 {
-	struct thread *curr, *pos, *new;
+	struct thread *curr, *pos, *new = NULL;
 	struct thread *th = NULL;
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	bool initial = timestamp == (u64)0;
+	static pthread_mutex_t missing_thread_lock = PTHREAD_MUTEX_INITIALIZER;
 
 	curr = __machine__findnew_thread(machine, pid, tid, initial);
 	if (curr && timestamp >= curr->start_time)
@@ -475,44 +490,49 @@ static struct thread *__machine__findnew_thread_time(struct machine *machine,
 			p = &(*p)->rb_right;
 	}
 
-	if (!create)
-		return NULL;
-
-	if (!curr)
-		return __machine__findnew_thread(machine, pid, tid, true);
+	pthread_mutex_lock(&missing_thread_lock);
 
-	new = thread__new(pid, tid);
-	if (new == NULL)
-		return NULL;
+	p = &machine->missing_threads.rb_node;
+	parent = NULL;
 
-	new->start_time = timestamp;
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
 
-	if (*p) {
-		list_for_each_entry(pos, &th->node, node) {
-			/* sort by time */
-			if (timestamp >= pos->start_time) {
-				th = pos;
-				break;
-			}
+		if (th->tid == tid) {
+			pthread_mutex_unlock(&missing_thread_lock);
+			return th;
 		}
-		list_add_tail(&new->node, &th->node);
-	} else {
-		rb_link_node(&new->rb_node, parent, p);
-		rb_insert_color(&new->rb_node, &machine->dead_threads);
+
+		if (tid < th->tid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
 	}
 
+	if (!create)
+		goto out;
+
+	new = thread__new(pid, tid);
+	if (new == NULL)
+		goto out;
+
+	/* missing threads are not bothered with timestamp */
+	new->start_time = 0;
+	new->missing = true;
+
 	/*
-	 * We have to initialize map_groups separately
-	 * after rb tree is updated.
-	 *
-	 * The reason is that we call machine__findnew_thread
-	 * within thread__init_map_groups to find the thread
-	 * leader and that would screwed the rb tree.
+	 * missing threads have their own map groups regardless of
+	 * leader for the sake of simplicity.  it's okay since the map
+	 * groups has no map in it anyway.
 	 */
-	if (thread__init_map_groups(new, machine)) {
-		thread__delete(new);
-		return NULL;
-	}
+	new->mg = map_groups__new(machine);
+
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &machine->missing_threads);
+
+out:
+	pthread_mutex_unlock(&missing_thread_lock);
 
 	return new;
 }
@@ -1351,6 +1371,7 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 
 	machine->last_match = NULL;
 	rb_erase(&th->rb_node, &machine->threads);
+	RB_CLEAR_NODE(&th->rb_node);
 
 	th->dead = true;
 
@@ -1822,6 +1843,14 @@ int machine__for_each_thread(struct machine *machine,
 				return rc;
 		}
 	}
+
+	for (nd = rb_first(&machine->missing_threads); nd; nd = rb_next(nd)) {
+		thread = rb_entry(nd, struct thread, rb_node);
+		rc = fn(thread, priv);
+		if (rc != 0)
+			return rc;
+	}
+
 	return rc;
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 9571b6b1c5b5..40af1f59e360 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -31,6 +31,7 @@ struct machine {
 	char		  *root_dir;
 	struct rb_root	  threads;
 	struct rb_root	  dead_threads;
+	struct rb_root	  missing_threads;
 	struct thread	  *last_match;
 	struct vdso_info  *vdso_info;
 	struct dsos	  user_dsos;
@@ -116,6 +117,7 @@ void machines__set_comm_exec(struct machines *machines, bool comm_exec);
 struct machine *machine__new_host(void);
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *machine);
+void machine__delete_missing_threads(struct machine *machine);
 void machine__delete_dead_threads(struct machine *machine);
 void machine__delete_threads(struct machine *machine);
 void machine__delete(struct machine *machine);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c1a17110ec6a..34956983ae8e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -138,14 +138,11 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	return NULL;
 }
 
-static void perf_session__delete_dead_threads(struct perf_session *session)
-{
-	machine__delete_dead_threads(&session->machines.host);
-}
-
 static void perf_session__delete_threads(struct perf_session *session)
 {
 	machine__delete_threads(&session->machines.host);
+	machine__delete_dead_threads(&session->machines.host);
+	machine__delete_missing_threads(&session->machines.host);
 }
 
 static void perf_session_env__delete(struct perf_session_env *env)
@@ -167,7 +164,6 @@ static void perf_session_env__delete(struct perf_session_env *env)
 void perf_session__delete(struct perf_session *session)
 {
 	perf_session__destroy_kernel_maps(session);
-	perf_session__delete_dead_threads(session);
 	perf_session__delete_threads(session);
 	perf_session_env__delete(&session->header.env);
 	machines__exit(&session->machines);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0b88ca22bc3d..87188ba9465b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -23,6 +23,7 @@ struct thread {
 	bool			comm_set;
 	bool			exited; /* if set thread has exited */
 	bool			dead; /* thread is in dead_threads list */
+	bool			missing; /* thread is in missing_threads list */
 	struct list_head	comm_list;
 	int			comm_len;
 	u64			db_id;
-- 
2.1.3

