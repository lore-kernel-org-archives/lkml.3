Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbbA2IKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51356 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbA2IKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:13 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 21/42] perf tools: Convert dead thread list into rbtree
Date: Thu, 29 Jan 2015 17:07:02 +0900
Message-Id: <1422518843-25818-22-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf maintains dead threads in a linked list but this can be
a problem if someone needs to search from it especially in a large
session which might have many dead threads.  Convert it to a rbtree
like normal threads and it'll be used later with multi-file changes.

The list node is now used for chaining dead threads of same tid since
it's easier to handle such threads in time order.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 70 +++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/machine.h |  2 +-
 tools/perf/util/thread.c  |  1 +
 tools/perf/util/thread.h  | 11 ++++----
 4 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1bca3a9f2b16..d4050fcba851 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -28,7 +28,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	dsos__init(&machine->kernel_dsos);
 
 	machine->threads = RB_ROOT;
-	INIT_LIST_HEAD(&machine->dead_threads);
+	machine->dead_threads = RB_ROOT;
 	machine->last_match = NULL;
 
 	machine->vdso_info = NULL;
@@ -91,10 +91,22 @@ static void dsos__delete(struct dsos *dsos)
 
 void machine__delete_dead_threads(struct machine *machine)
 {
-	struct thread *n, *t;
+	struct rb_node *nd = rb_first(&machine->dead_threads);
+
+	while (nd) {
+		struct thread *t = rb_entry(nd, struct thread, rb_node);
+		struct thread *pos;
+
+		nd = rb_next(nd);
+		rb_erase(&t->rb_node, &machine->dead_threads);
+
+		while (!list_empty(&t->tid_node)) {
+			pos = list_first_entry(&t->tid_node,
+					       struct thread, tid_node);
+			list_del(&pos->tid_node);
+			thread__delete(pos);
+		}
 
-	list_for_each_entry_safe(t, n, &machine->dead_threads, node) {
-		list_del(&t->node);
 		thread__delete(t);
 	}
 }
@@ -106,8 +118,8 @@ void machine__delete_threads(struct machine *machine)
 	while (nd) {
 		struct thread *t = rb_entry(nd, struct thread, rb_node);
 
-		rb_erase(&t->rb_node, &machine->threads);
 		nd = rb_next(nd);
+		rb_erase(&t->rb_node, &machine->threads);
 		thread__delete(t);
 	}
 }
@@ -1238,13 +1250,46 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 static void machine__remove_thread(struct machine *machine, struct thread *th)
 {
+	struct rb_node **p = &machine->dead_threads.rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *pos;
+
 	machine->last_match = NULL;
 	rb_erase(&th->rb_node, &machine->threads);
+
+	th->dead = true;
+
 	/*
 	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
+	 * instances, so just move them to a separate list in rbtree.
 	 */
-	list_add_tail(&th->node, &machine->dead_threads);
+	while (*p != NULL) {
+		parent = *p;
+		pos = rb_entry(parent, struct thread, rb_node);
+
+		if (pos->tid == th->tid) {
+			struct thread *old;
+
+			/* sort by time */
+			list_for_each_entry(old, &pos->tid_node, tid_node) {
+				if (th->start_time >= old->start_time) {
+					pos = old;
+					break;
+				}
+			}
+
+			list_add_tail(&th->tid_node, &pos->tid_node);
+			return;
+		}
+
+		if (th->tid < pos->tid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&th->rb_node, parent, p);
+	rb_insert_color(&th->rb_node, &machine->dead_threads);
 }
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event,
@@ -1649,7 +1694,7 @@ int machine__for_each_thread(struct machine *machine,
 			     void *priv)
 {
 	struct rb_node *nd;
-	struct thread *thread;
+	struct thread *thread, *pos;
 	int rc = 0;
 
 	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
@@ -1659,10 +1704,17 @@ int machine__for_each_thread(struct machine *machine,
 			return rc;
 	}
 
-	list_for_each_entry(thread, &machine->dead_threads, node) {
+	for (nd = rb_first(&machine->dead_threads); nd; nd = rb_next(nd)) {
+		thread = rb_entry(nd, struct thread, rb_node);
 		rc = fn(thread, priv);
 		if (rc != 0)
 			return rc;
+
+		list_for_each_entry(pos, &thread->tid_node, tid_node) {
+			rc = fn(pos, priv);
+			if (rc != 0)
+				return rc;
+		}
 	}
 	return rc;
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index e8b7779a0a3f..4349946a38ff 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -30,7 +30,7 @@ struct machine {
 	bool		  comm_exec;
 	char		  *root_dir;
 	struct rb_root	  threads;
-	struct list_head  dead_threads;
+	struct rb_root	  dead_threads;
 	struct thread	  *last_match;
 	struct vdso_info  *vdso_info;
 	struct dsos	  user_dsos;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index ad96725105c2..c9ae0e1599da 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -38,6 +38,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->ppid = -1;
 		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
+		INIT_LIST_HEAD(&thread->tid_node);
 
 		if (unwind__prepare_access(thread) < 0)
 			goto err_thread;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index be67c3bad5e7..21268e66b2ad 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -11,10 +11,8 @@
 struct thread_stack;
 
 struct thread {
-	union {
-		struct rb_node	 rb_node;
-		struct list_head node;
-	};
+	struct rb_node	 	rb_node;
+	struct list_head 	tid_node;
 	struct map_groups	*mg;
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
@@ -22,7 +20,8 @@ struct thread {
 	int			cpu;
 	char			shortname[3];
 	bool			comm_set;
-	bool			dead; /* if set thread has exited */
+	bool			exited; /* if set thread has exited */
+	bool			dead; /* thread is in dead_threads list */
 	struct list_head	comm_list;
 	int			comm_len;
 	u64			db_id;
@@ -39,7 +38,7 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine);
 void thread__delete(struct thread *thread);
 static inline void thread__exited(struct thread *thread)
 {
-	thread->dead = true;
+	thread->exited = true;
 }
 
 int __thread__set_comm(struct thread *thread, const char *comm, u64 timestamp,
-- 
2.2.2

