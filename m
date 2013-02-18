Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3BRQMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:12:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3BRQMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:12:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724938"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 01/15] workqueue: add lock_work_pool()
Date: Tue, 19 Feb 2013 00:12:02 +0800
Message-Id: <1361203940-6300-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:55,
	Serialize complete at 2013/02/19 00:11:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_work_pool() is too weak, the caller *always* has to lock and check.
We merge all the code and name it lock_work_pool() and remove get_work_pool().

This patch has a little overhead for __queue_work() and try_to_grab_pending():
	Even worker_pool_by_id(pool_id) == get_cwq(cpu, wq)->pool,
	It will still look up the worker.
	But this lookup is neeeded in later patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  170 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 93 insertions(+), 77 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ea7f696..f90d0bd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -516,10 +516,8 @@ static int work_next_color(int color)
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
- * get_work_pool() and get_work_cwq() can be used to obtain the pool or cwq
- * corresponding to a work.  Pool is available once the work has been
- * queued anywhere after initialization until it is sync canceled.  cwq is
- * available only while the work item is queued.
+ * get_work_cwq() can be used to obtain the cwq corresponding to a work.
+ * It is available only while the work item is queued.
  *
  * %WORK_OFFQ_CANCELING is used to mark a work item which is being
  * canceled.  While being canceled, a work item may have its PENDING set
@@ -578,31 +576,6 @@ static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 }
 
 /**
- * get_work_pool - return the worker_pool a given work was associated with
- * @work: the work item of interest
- *
- * Return the worker_pool @work was last associated with.  %NULL if none.
- */
-static struct worker_pool *get_work_pool(struct work_struct *work)
-{
-	unsigned long data = atomic_long_read(&work->data);
-	struct worker_pool *pool;
-	int pool_id;
-
-	if (data & WORK_STRUCT_CWQ)
-		return ((struct cpu_workqueue_struct *)
-			(data & WORK_STRUCT_WQ_DATA_MASK))->pool;
-
-	pool_id = data >> WORK_OFFQ_POOL_SHIFT;
-	if (pool_id == WORK_OFFQ_POOL_NONE)
-		return NULL;
-
-	pool = worker_pool_by_id(pool_id);
-	WARN_ON_ONCE(!pool);
-	return pool;
-}
-
-/**
  * get_work_pool_id - return the worker pool ID a given work is associated with
  * @work: the work item of interest
  *
@@ -921,6 +894,64 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 }
 
 /**
+ * lock_work_pool - return and lock the pool a given work was associated with
+ * @work: the work item of interest
+ * @queued_cwq: set to the queued cwq if the work is still queued
+ * @running_worker: set to the running worker if the work is still running
+ *
+ * CONTEXT:
+ * local_irq_disable().
+ *
+ * Return the worker_pool @work was last associated with.  %NULL if none.
+ */
+
+static
+struct worker_pool *lock_work_pool(struct work_struct *work,
+				   struct cpu_workqueue_struct **queued_cwq,
+				   struct worker **running_worker)
+{
+	unsigned long data = atomic_long_read(&work->data);
+	unsigned long pool_id;
+	struct worker_pool *pool;
+	struct cpu_workqueue_struct *cwq;
+	struct worker *worker = NULL;
+
+	if (data & WORK_STRUCT_CWQ) {
+		cwq = (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
+		pool = cwq->pool;
+		spin_lock(&pool->lock);
+		/*
+		 * work->data is guaranteed to point to cwq only while the work
+		 * item is queued on cwq->wq, and both updating work->data to
+		 * point to cwq on queueing and to pool on dequeueing are done
+		 * under cwq->pool->lock.  This in turn guarantees that,
+		 * if work->data points to cwq which is associated with a
+		 * locked pool, the work item is currently queued on that pool.
+		 */
+		cwq = get_work_cwq(work);
+		if (cwq && cwq->pool == pool) {
+			*queued_cwq = cwq;
+			worker = find_worker_executing_work(pool, work);
+		}
+	} else {
+		pool_id = data >> WORK_OFFQ_POOL_SHIFT;
+		if (pool_id == WORK_OFFQ_POOL_NONE)
+			return NULL;
+
+		pool = worker_pool_by_id(pool_id);
+		if (!pool)
+			return NULL;
+
+		spin_lock(&pool->lock);
+		worker = find_worker_executing_work(pool, work);
+	}
+
+	if (worker)
+		*running_worker = worker;
+	return pool;
+}
+
+/**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
  * @head: target list to append @work to
@@ -1053,7 +1084,8 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
 {
 	struct worker_pool *pool;
-	struct cpu_workqueue_struct *cwq;
+	struct cpu_workqueue_struct *cwq = NULL;
+	struct worker *worker = NULL;
 
 	local_irq_save(*flags);
 
@@ -1078,21 +1110,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 * The queueing is in progress, or it is already queued. Try to
 	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
 	 */
-	pool = get_work_pool(work);
+	pool = lock_work_pool(work, &cwq, &worker);
 	if (!pool)
 		goto fail;
 
-	spin_lock(&pool->lock);
-	/*
-	 * work->data is guaranteed to point to cwq only while the work
-	 * item is queued on cwq->wq, and both updating work->data to point
-	 * to cwq on queueing and to pool on dequeueing are done under
-	 * cwq->pool->lock.  This in turn guarantees that, if work->data
-	 * points to cwq which is associated with a locked pool, the work
-	 * item is currently queued on that pool.
-	 */
-	cwq = get_work_cwq(work);
-	if (cwq && cwq->pool == pool) {
+	if (cwq) {
 		debug_work_deactivate(work);
 
 		/*
@@ -1199,34 +1221,27 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	/* determine the cwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct worker_pool *last_pool;
+		struct worker *worker = NULL;
+		struct cpu_workqueue_struct *dummy_cwq;
 
 		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
 
 		/*
 		 * It's multi cpu.  If @work was previously on a different
-		 * cpu, it might still be running there, in which case the
-		 * work needs to be queued on that cpu to guarantee
+		 * pool, it might still be running there, in which case the
+		 * work needs to be queued on that pool to guarantee
 		 * non-reentrancy.
 		 */
 		cwq = get_cwq(cpu, wq);
-		last_pool = get_work_pool(work);
-
-		if (last_pool && last_pool != cwq->pool) {
-			struct worker *worker;
-
-			spin_lock(&last_pool->lock);
-
-			worker = find_worker_executing_work(last_pool, work);
+		last_pool = lock_work_pool(work, &dummy_cwq, &worker);
 
-			if (worker && worker->current_cwq->wq == wq) {
-				cwq = get_cwq(last_pool->cpu, wq);
-			} else {
-				/* meh... not running there, queue here */
+		if (worker && worker->current_cwq->wq == wq) {
+			cwq = get_cwq(last_pool->cpu, wq);
+		} else if (cwq->pool != last_pool) {
+			/* meh... not running there, queue here */
+			if (last_pool)
 				spin_unlock(&last_pool->lock);
-				spin_lock(&cwq->pool->lock);
-			}
-		} else {
 			spin_lock(&cwq->pool->lock);
 		}
 	} else {
@@ -2749,25 +2764,22 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 {
 	struct worker *worker = NULL;
 	struct worker_pool *pool;
-	struct cpu_workqueue_struct *cwq;
+	struct cpu_workqueue_struct *cwq = NULL;
 
 	might_sleep();
-	pool = get_work_pool(work);
-	if (!pool)
+	local_irq_disable();
+	pool = lock_work_pool(work, &cwq, &worker);
+	if (!pool) {
+		local_irq_enable();
 		return false;
+	}
 
-	spin_lock_irq(&pool->lock);
-	/* see the comment in try_to_grab_pending() with the same code */
-	cwq = get_work_cwq(work);
-	if (cwq) {
-		if (unlikely(cwq->pool != pool))
-			goto already_gone;
-	} else {
-		worker = find_worker_executing_work(pool, work);
-		if (!worker)
-			goto already_gone;
+	if (cwq)
+		worker = NULL;
+	else if (worker)
 		cwq = worker->current_cwq;
-	}
+	else
+		goto already_gone;
 
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&pool->lock);
@@ -3386,19 +3398,23 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  */
 unsigned int work_busy(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
+	struct worker_pool *pool;
+	struct cpu_workqueue_struct *cwq = NULL;
+	struct worker *worker = NULL;
 	unsigned long flags;
 	unsigned int ret = 0;
 
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
 
+	local_irq_save(flags);
+	pool = lock_work_pool(work, &cwq, &worker);
 	if (pool) {
-		spin_lock_irqsave(&pool->lock, flags);
-		if (find_worker_executing_work(pool, work))
+		if (worker)
 			ret |= WORK_BUSY_RUNNING;
-		spin_unlock_irqrestore(&pool->lock, flags);
+		spin_unlock(&pool->lock);
 	}
+	local_irq_restore(flags);
 
 	return ret;
 }
-- 
1.7.7.6

