Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3BRQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab3BRQOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:32 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724953"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 13/15] workqueue: also record worker in work->data if running&&queued
Date: Tue, 19 Feb 2013 00:12:14 +0800
Message-Id: <1361203940-6300-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:51,
	Serialize complete at 2013/02/19 00:13:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current, we always record cwq in work->data if the work is queued.
Even the work is running at the same time. It requires us to use hash table
to lookup the worker.

If we record the worker ID is work->data even the work is queued, we can
remove this hash table lookup:
	in lock_work_pool(), we use worker ID lookup instead
	in process_one_work(), we reduce any lookup in fast path!

Trade-off: get_work_cwq() becomes a little more heavy and slow!
	but (1)after our longterm effort, get_work_cwq() is now only called
	by mayday code which is unlikely path! and (2) get_work_cwq() is as fast
	as before in most cases.

The new semantic of get_work_cwq()
	get_work_cwq() requires the caller hold the pool lock and
	the work must be *queued* on the pool,
we can changes the semantic to this in future when needed(more code and check)
	get_work_cwq() requires the caller hold the pool lock and
	the work must be *owned* by the pool.
	or we can provide even more loose semantic,
	but we don't need loose semantic in any case currently, KISS.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h   |    3 +-
 kernel/workqueue.c          |  175 +++++++++++++++++++++++--------------------
 kernel/workqueue_internal.h |    4 +
 3 files changed, 101 insertions(+), 81 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a8db8c4..f0973a7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -71,13 +71,14 @@ enum {
 	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_COLOR_SHIFT,
 
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
+	WORK_OFFQ_REQUEUED	= (1 << (WORK_OFFQ_FLAG_BASE + 1)),
 
 	/*
 	 * When a work item starts to be executed, its high bits point to the
 	 * worker it is running on.  Cap at 31 bits and use the highest number
 	 * to indicate that no worker is associated.
 	 */
-	WORK_OFFQ_FLAG_BITS	= 1,
+	WORK_OFFQ_FLAG_BITS	= 2,
 	WORK_OFFQ_WORKER_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
 	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_WORKER_SHIFT,
 	WORK_OFFQ_WORKER_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ab5c61a..a23f4fc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -570,16 +570,6 @@ static void clear_work_data(struct work_struct *work)
 	set_work_data(work, WORK_STRUCT_NO_WORKER, 0);
 }
 
-static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
-{
-	unsigned long data = atomic_long_read(&work->data);
-
-	if (data & WORK_STRUCT_CWQ)
-		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
-	else
-		return NULL;
-}
-
 /**
  * get_work_worker_id - return the worker ID a given work was last running on
  * @work: the work item of interest
@@ -849,55 +839,6 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 }
 
 /**
- * find_worker_executing_work - find worker which is executing a work
- * @pool: pool of interest
- * @work: work to find worker for
- *
- * Find a worker which is executing @work on @pool by searching
- * @pool->busy_hash which is keyed by the address of @work.  For a worker
- * to match, its current execution should match the address of @work and
- * its work function.  This is to avoid unwanted dependency between
- * unrelated work executions through a work item being recycled while still
- * being executed.
- *
- * This is a bit tricky.  A work item may be freed once its execution
- * starts and nothing prevents the freed area from being recycled for
- * another work item.  If the same work item address ends up being reused
- * before the original execution finishes, workqueue will identify the
- * recycled work item as currently executing and make it wait until the
- * current execution finishes, introducing an unwanted dependency.
- *
- * This function checks the work item address, work function and workqueue
- * to avoid false positives.  Note that this isn't complete as one may
- * construct a work function which can introduce dependency onto itself
- * through a recycled work item.  Well, if somebody wants to shoot oneself
- * in the foot that badly, there's only so much we can do, and if such
- * deadlock actually occurs, it should be easy to locate the culprit work
- * function.
- *
- * CONTEXT:
- * spin_lock_irq(pool->lock).
- *
- * RETURNS:
- * Pointer to worker which is executing @work if found, NULL
- * otherwise.
- */
-static struct worker *find_worker_executing_work(struct worker_pool *pool,
-						 struct work_struct *work)
-{
-	struct worker *worker;
-	struct hlist_node *tmp;
-
-	hash_for_each_possible(pool->busy_hash, worker, tmp, hentry,
-			       (unsigned long)work)
-		if (worker->current_work == work &&
-		    worker->current_func == work->func)
-			return worker;
-
-	return NULL;
-}
-
-/**
  * worker_by_id - lookup worker by id
  * @id: the worker id of of interest
  *
@@ -917,6 +858,46 @@ static struct worker *worker_by_id(int id)
 	return idr_find(&worker_idr, id);
 }
 
+static struct worker *get_work_worker(struct work_struct *work)
+{
+	return worker_by_id(get_work_worker_id(work));
+}
+
+static
+struct cpu_workqueue_struct *get_work_cwq_no_running(struct work_struct *work)
+{
+	unsigned long data = atomic_long_read(&work->data);
+
+	if (data & WORK_STRUCT_CWQ)
+		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
+	else
+		return NULL;
+}
+
+/**
+ * get_work_cwq - get cwq of the work
+ * @work: the work item of interest
+ *
+ * CONTEXT:
+ * spin_lock_irq(&pool->lock), the work must be queued on this pool
+ */
+static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
+{
+	unsigned long data = atomic_long_read(&work->data);
+	struct worker *worker;
+
+	if (data & WORK_STRUCT_CWQ) {
+		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
+	} else if (data & WORK_OFFQ_REQUEUED) {
+		worker = worker_by_id(data >> WORK_OFFQ_WORKER_SHIFT);
+		BUG_ON(!worker || !worker->requeue);
+		return worker->current_cwq;
+	} else {
+		BUG();
+		return NULL;
+	}
+}
+
 /**
  * lock_work_pool - return and lock the pool a given work was associated with
  * @work: the work item of interest
@@ -951,11 +932,9 @@ struct worker_pool *lock_work_pool(struct work_struct *work,
 		 * if work->data points to cwq which is associated with a
 		 * locked pool, the work item is currently queued on that pool.
 		 */
-		cwq = get_work_cwq(work);
-		if (cwq && cwq->pool == pool) {
+		cwq = get_work_cwq_no_running(work);
+		if (cwq && cwq->pool == pool)
 			*queued_cwq = cwq;
-			worker = find_worker_executing_work(pool, work);
-		}
 	} else {
 		worker = worker_by_id(data >> WORK_OFFQ_WORKER_SHIFT);
 		if (!worker)
@@ -966,6 +945,8 @@ struct worker_pool *lock_work_pool(struct work_struct *work,
 		if (pool != worker->pool || worker->current_work != work ||
 		    worker->current_func != work->func)
 			worker = NULL;
+		else if (worker->requeue)
+			*queued_cwq = worker->current_cwq;
 	}
 
 	if (worker)
@@ -1154,10 +1135,12 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		cwq_dec_nr_in_flight(cwq, get_work_color(work));
 
 		/* work is dequeued, work->data points to pool iff running */
-		if (worker)
+		if (worker) {
 			worker_id = worker->id;
-		else
+			worker->requeue = false;
+		} else {
 			worker_id = WORK_OFFQ_WORKER_NONE;
+		}
 
 		set_work_worker_and_keep_pending(work, worker_id, 0);
 
@@ -1227,6 +1210,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
+	struct worker *worker = NULL;
 	struct list_head *worklist;
 	unsigned int color_flags, delayed_flags = 0;
 	unsigned int req_cpu = cpu;
@@ -1249,7 +1233,6 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	/* determine the cwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct worker_pool *last_pool;
-		struct worker *worker = NULL;
 		struct cpu_workqueue_struct *dummy_cwq;
 
 		if (cpu == WORK_CPU_UNBOUND)
@@ -1266,11 +1249,15 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 		if (worker && worker->current_cwq->wq == wq) {
 			cwq = get_cwq(last_pool->cpu, wq);
-		} else if (cwq->pool != last_pool) {
-			/* meh... not running there, queue here */
-			if (last_pool)
-				spin_unlock(&last_pool->lock);
-			spin_lock(&cwq->pool->lock);
+			BUG_ON(worker->current_cwq != cwq);
+		} else {
+			worker = NULL;
+			if (cwq->pool != last_pool) {
+				/* meh... not running there, queue here */
+				if (last_pool)
+					spin_unlock(&last_pool->lock);
+				spin_lock(&cwq->pool->lock);
+			}
 		}
 	} else {
 		cwq = get_cwq(WORK_CPU_UNBOUND, wq);
@@ -1296,8 +1283,16 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		worklist = &cwq->delayed_works;
 	}
 
-	color_flags = work_color_to_flags(cwq->work_color);
-	insert_work(cwq, work, worklist, color_flags | delayed_flags);
+	if (worker) {
+		worker->requeue = true;
+		worker->requeue_color = cwq->work_color;
+		set_work_worker_and_keep_pending(work, worker->id,
+				delayed_flags | WORK_OFFQ_REQUEUED);
+		list_add_tail(&work->entry, worklist);
+	} else {
+		color_flags = work_color_to_flags(cwq->work_color);
+		insert_work(cwq, work, worklist, color_flags | delayed_flags);
+	}
 
 	spin_unlock(&cwq->pool->lock);
 }
@@ -2131,9 +2126,9 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
+	struct cpu_workqueue_struct *cwq = get_work_cwq_no_running(work);
 	struct worker_pool *pool = worker->pool;
-	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
+	bool cpu_intensive;
 	int work_color;
 	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
@@ -2159,12 +2154,21 @@ __acquires(&pool->lock)
 
 	/*
 	 * A single work shouldn't be executed concurrently by
-	 * multiple workers on a single cpu.  Check whether anyone is
-	 * already processing the work.  If so, defer the work to the
-	 * currently executing one.
+	 * multiple workers on a single pool. get_work_cwq_no_running()
+	 * returning NULL here means someone else is already prcoessing
+	 * the work, defer the work to the currently executing one.
+	 * These BUG_ON()s are just comments, they all are ensured
+	 * by __queue_work().
 	 */
-	collision = find_worker_executing_work(pool, work);
-	if (unlikely(collision)) {
+	if (unlikely(!cwq)) {
+		BUG_ON(!(atomic_long_read(&work->data) | WORK_OFFQ_REQUEUED));
+
+		collision = get_work_worker(work);
+		BUG_ON(!collision || !collision->requeue);
+		BUG_ON(collision->pool != pool);
+		BUG_ON(collision->current_work != work);
+		BUG_ON(collision->current_func != work->func);
+
 		move_linked_works(work, &collision->scheduled, NULL);
 		return;
 	}
@@ -2183,6 +2187,7 @@ __acquires(&pool->lock)
 	 * CPU intensive works don't participate in concurrency
 	 * management.  They're the scheduler's responsibility.
 	 */
+	cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
@@ -2236,6 +2241,16 @@ __acquires(&pool->lock)
 	worker->current_func = NULL;
 	worker->current_cwq = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color);
+
+	if (unlikely(worker->requeue)) {
+		unsigned long color_flags, keep_flags;
+
+		worker->requeue = false;
+		keep_flags = atomic_long_read(&work->data);
+		keep_flags &= WORK_STRUCT_LINKED | WORK_STRUCT_DELAYED;
+		color_flags = work_color_to_flags(worker->requeue_color);
+		set_work_cwq(work, cwq, color_flags | keep_flags);
+	}
 }
 
 /**
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 1040abc..bc0ce95 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -39,6 +39,10 @@ struct worker {
 	int			id_in_pool;	/* I: worker id in the pool */
 	int			id;		/* I: worker id (global) */
 
+	/* requeued work */
+	bool			requeue;	/* L: requeued current_work */
+	unsigned int		requeue_color;	/* L: color of requeued work */
+
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 
-- 
1.7.7.6

