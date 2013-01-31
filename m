Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3AaSnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:43:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab3AaSmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672841"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/13] workqueue: add lock_pool_own_work() and remove get_work_pool()
Date: Fri, 1 Feb 2013 02:41:33 +0800
Message-Id: <1359657696-2767-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:52,
	Serialize complete at 2013/02/01 02:40:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_pool_own_work() reuse lock_pool_queued_work() and lock_pool_executing_work()
to implement "get the correct own pool and lock" logic. It makes all callings
to lock_pool_own_work()'s mean/logic are more clear.

get_work_pool() can't get the really pool which owns the work
and it is not used any more, just remove it.

Add/Use proper locking API.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  123 ++++++++++++++++++++++++++--------------------------
 1 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a108788..04d1286 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -531,10 +531,8 @@ static int work_next_color(int color)
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
- * get_work_pool() and get_work_cwq() can be used to obtain the pool or cwq
- * corresponding to a work.  Pool is available once the work has been
- * queued anywhere after initialization until it is sync canceled.  cwq is
- * available only while the work item is queued.
+ * get_work_cwq() can be used to obtain the cwq, it is available only
+ * while the work item is queued.
  *
  * %WORK_OFFQ_CANCELING is used to mark a work item which is being
  * canceled.  While being canceled, a work item may have its PENDING set
@@ -592,31 +590,6 @@ static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
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
  * offq_work_pool_id - return the worker pool ID a given work is associated with
  * @work: the off-queued work item of interest
  *
@@ -936,6 +909,7 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 
 /** lock_pool_executing_work - lock the pool a given offq work is running on
  * @work: work of interest
+ * @pool_id: pool_id obtained from @work data
  * @worker: return the worker which is executing @work if found
  *
  * CONTEXT:
@@ -946,9 +920,9 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
  * NULL otherwise.
  */
 static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
+						    unsigned long pool_id,
 						    struct worker **worker)
 {
-	unsigned long pool_id = offq_work_pool_id(work);
 	struct worker_pool *pool;
 	struct worker *exec;
 
@@ -973,6 +947,7 @@ static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
 
 /** lock_pool_queued_work - lock the pool a given work is queued on
  * @work: work of interest
+ * @cwq: cwq obtained from @work data
  *
  * CONTEXT:
  * local_irq_disable()
@@ -981,14 +956,12 @@ static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
  * Pointer to work pool(and locked) on which @work is queued if found,
  * NULL otherwise.
  */
-static struct worker_pool *lock_pool_queued_work(struct work_struct *work)
+static
+struct worker_pool *lock_pool_queued_work(struct work_struct *work,
+					  struct cpu_workqueue_struct *cwq)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct worker_pool *pool;
 
-	if (!cwq)
-		return NULL;
-
 	pool = cwq->pool;
 	spin_lock(&pool->lock);
 	/*
@@ -1010,6 +983,40 @@ static struct worker_pool *lock_pool_queued_work(struct work_struct *work)
 	return NULL;
 }
 
+/** lock_pool_own_work - lock the pool a given work is queued/running on
+ * @work: work of interest
+ * @worker: return the worker which is executing off-queued @work if found
+ *
+ * CONTEXT:
+ * local_irq_disable()
+ *
+ * RETURNS:
+ * Pointer to work pool(and locked) on which @work is queued/running if found,
+ * 	- If the work is queued on the pool, lock and return the pool, with
+ * 	  @worker untouched. The work may or may not be running on the pool.
+ * 	- If the work is not queued on the pool, but it is running on the pool,
+ * 	  lock and return the pool with @worker set to the executing worker
+ * 	  (This step will be skipped if @worker is NULL)
+ * NULL otherwise with @worker untouched
+ */
+static struct worker_pool *lock_pool_own_work(struct work_struct *work,
+					      struct worker **worker)
+{
+	unsigned long data = atomic_long_read(&work->data);
+	struct cpu_workqueue_struct *cwq;
+	unsigned long pool_id;
+
+	if (data & WORK_STRUCT_CWQ) {
+		cwq = (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
+		return lock_pool_queued_work(work, cwq);
+	} else if (worker) {
+		pool_id = data >> WORK_OFFQ_POOL_SHIFT;
+		return lock_pool_executing_work(work, pool_id, worker);
+	}
+
+	return NULL;
+}
+
 /**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
@@ -1167,7 +1174,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 * The queueing is in progress, or it is already queued. Try to
 	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
 	 */
-	pool = lock_pool_queued_work(work);
+	pool = lock_pool_own_work(work, NULL);
 	if (pool) {
 		debug_work_deactivate(work);
 
@@ -1301,7 +1308,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * to guarantee non-reentrancy.
 		 */
 		BUG_ON(get_work_cwq(work));
-		pool = lock_pool_executing_work(work, &worker);
+		pool = lock_pool_own_work(work, &worker);
 		if (pool && worker->current_cwq->wq != wq) {
 			spin_unlock(&pool->lock);
 			pool = NULL;
@@ -2834,22 +2841,17 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	struct cpu_workqueue_struct *cwq;
 
 	might_sleep();
-	pool = get_work_pool(work);
-	if (!pool)
+	local_irq_disable();
+	pool = lock_pool_own_work(work, &worker);
+	if (!pool) {
+		local_irq_enable();
 		return false;
+	}
 
-	spin_lock_irq(&pool->lock);
-	/* See the comment near lock_pool_queued_work() with the same code */
-	cwq = get_work_cwq(work);
-	if (cwq) {
-		if (unlikely(pool != cwq->pool))
-			goto already_gone;
-	} else {
-		worker = find_worker_executing_work(pool, work);
-		if (!worker)
-			goto already_gone;
+	if (!worker)
+		cwq = get_work_cwq(work);
+	else
 		cwq = worker->current_cwq;
-	}
 
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&pool->lock);
@@ -2867,9 +2869,6 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	lock_map_release(&cwq->wq->lockdep_map);
 
 	return true;
-already_gone:
-	spin_unlock_irq(&pool->lock);
-	return false;
 }
 
 /**
@@ -3468,19 +3467,21 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  */
 unsigned int work_busy(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
 	unsigned long flags;
+	struct worker_pool *pool;
+	struct worker *worker = NULL;
 	unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;
 
-	if (!pool)
-		return ret;
-
-	spin_lock_irqsave(&pool->lock, flags);
+	local_irq_save(flags);
 
-	if (find_worker_executing_work(pool, work))
-		ret |= WORK_BUSY_RUNNING;
+	pool = lock_pool_own_work(work, &worker);
+	if (pool) {
+		if (worker || find_worker_executing_work(pool, work))
+			ret |= WORK_BUSY_RUNNING;
+		spin_unlock(&pool->lock);
+	}
 
-	spin_unlock_irqrestore(&pool->lock, flags);
+	local_irq_restore(flags);
 
 	return ret;
 }
-- 
1.7.7.6

