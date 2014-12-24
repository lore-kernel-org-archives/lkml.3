Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaLXHWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:22:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39726 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaLXHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:55 -0500
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
Subject: [PATCH 14/37] perf tools: Convert dead thread list into rbtree
Date: Wed, 24 Dec 2014 16:15:10 +0900
Message-Id: <1419405333-27952-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf maintains dead threads in a linked list but this can be
a problem if someone needs to search from it.  Convert it to a rbtree
like normal threads and it'll be used later with multi-file changes.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 59 +++++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/machine.h |  2 +-
 tools/perf/util/thread.c  |  1 +
 tools/perf/util/thread.h  | 11 ++++-----
 4 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 15dd0a9691ce..582e011adc92 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -28,7 +28,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	dsos__init(&machine->kernel_dsos);
 
 	machine->threads = RB_ROOT;
-	INIT_LIST_HEAD(&machine->dead_threads);
+	machine->dead_threads = RB_ROOT;
 	machine->last_match = NULL;
 
 	machine->vdso_info = NULL;
@@ -91,10 +91,21 @@ static void dsos__delete(struct dsos *dsos)
 
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
+		while (!list_empty(&t->node)) {
+			pos = list_first_entry(&t->node, struct thread, node);
+			list_del(&pos->node);
+			thread__delete(pos);
+		}
 
-	list_for_each_entry_safe(t, n, &machine->dead_threads, node) {
-		list_del(&t->node);
 		thread__delete(t);
 	}
 }
@@ -106,8 +117,8 @@ void machine__delete_threads(struct machine *machine)
 	while (nd) {
 		struct thread *t = rb_entry(nd, struct thread, rb_node);
 
-		rb_erase(&t->rb_node, &machine->threads);
 		nd = rb_next(nd);
+		rb_erase(&t->rb_node, &machine->threads);
 		thread__delete(t);
 	}
 }
@@ -1236,13 +1247,36 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
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
+			list_add_tail(&th->node, &pos->node);
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
@@ -1649,7 +1683,7 @@ int machine__for_each_thread(struct machine *machine,
 			     void *priv)
 {
 	struct rb_node *nd;
-	struct thread *thread;
+	struct thread *thread, *pos;
 	int rc = 0;
 
 	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
@@ -1659,10 +1693,17 @@ int machine__for_each_thread(struct machine *machine,
 			return rc;
 	}
 
-	list_for_each_entry(thread, &machine->dead_threads, node) {
+	for (nd = rb_first(&machine->dead_threads); nd; nd = rb_next(nd)) {
+		thread = rb_entry(nd, struct thread, rb_node);
 		rc = fn(thread, priv);
 		if (rc != 0)
 			return rc;
+
+		list_for_each_entry(pos, &thread->node, node) {
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
index 083fa0fcf316..b9c5c5d5e718 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -38,6 +38,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->ppid = -1;
 		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
+		INIT_LIST_HEAD(&thread->node);
 
 		if (unwind__prepare_access(thread) < 0)
 			goto err_thread;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0b6dcd70bc8b..413f28cf689b 100644
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
+	struct list_head 	node;
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
2.1.3

