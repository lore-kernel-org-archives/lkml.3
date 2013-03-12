Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab3CLSUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:20:50 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47402 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3CLSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:20:49 -0400
Date: Tue, 12 Mar 2013 11:20:45 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCH v2 13/31] workqueue: update synchronization rules on
 worker_pool_idr
Message-ID: <20130312182045.GE25266@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 854a1fa808ed339280eb61b31f18c496c56c7796 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 12 Mar 2013 11:14:45 -0700

Make worker_pool_idr protected by workqueue_lock for writes and
sched-RCU protected for reads.  Lockdep assertions are added to
for_each_pool() and get_work_pool() and all their users are converted
to either hold workqueue_lock or disable preemption/irq.

worker_pool_assign_id() is updated to hold workqueue_lock when
allocating a pool ID.  As idr_get_new() always performs RCU-safe
assignment, this is enough on the writer side.

As standard pools are never destroyed, there's nothing to do on that
side.

The locking is superflous at this point.  This is to help
implementation of unbound pools/pwqs with custom attributes.

This patch doesn't introduce any behavior changes.

v2: Updated for_each_pwq() use if/else for the hidden assertion
    statement instead of just if as suggested by Lai.  This avoids
    confusing the following else clause.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 71 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e060ff2..4638149 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -282,9 +282,18 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
  * for_each_pool - iterate through all worker_pools in the system
  * @pool: iteration cursor
  * @id: integer used for iteration
+ *
+ * This must be called either with workqueue_lock held or sched RCU read
+ * locked.  If the pool needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pool stays online.
+ *
+ * The if/else clause exists only for the lockdep assertion and can be
+ * ignored.
  */
 #define for_each_pool(pool, id)						\
-	idr_for_each_entry(&worker_pool_idr, pool, id)
+	idr_for_each_entry(&worker_pool_idr, pool, id)			\
+		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
+		else
 
 /**
  * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
@@ -432,8 +441,10 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_std_worker_pools);
 static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
 
-/* idr of all pools */
-static DEFINE_MUTEX(worker_pool_idr_mutex);
+/*
+ * idr of all pools.  Modifications are protected by workqueue_lock.  Read
+ * accesses are protected by sched-RCU protected.
+ */
 static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
@@ -456,21 +467,16 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
-	mutex_lock(&worker_pool_idr_mutex);
-	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
-	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
-	mutex_unlock(&worker_pool_idr_mutex);
+	do {
+		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
+			return -ENOMEM;
 
-	return ret;
-}
+		spin_lock_irq(&workqueue_lock);
+		ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
+		spin_unlock_irq(&workqueue_lock);
+	} while (ret == -EAGAIN);
 
-/*
- * Lookup worker_pool by id.  The idr currently is built during boot and
- * never modified.  Don't worry about locking for now.
- */
-static struct worker_pool *worker_pool_by_id(int pool_id)
-{
-	return idr_find(&worker_pool_idr, pool_id);
+	return ret;
 }
 
 static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
@@ -586,13 +592,23 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  * @work: the work item of interest
  *
  * Return the worker_pool @work was last associated with.  %NULL if none.
+ *
+ * Pools are created and destroyed under workqueue_lock, and allows read
+ * access under sched-RCU read lock.  As such, this function should be
+ * called under workqueue_lock or with preemption disabled.
+ *
+ * All fields of the returned pool are accessible as long as the above
+ * mentioned locking is in effect.  If the returned pool needs to be used
+ * beyond the critical section, the caller is responsible for ensuring the
+ * returned pool is and stays online.
  */
 static struct worker_pool *get_work_pool(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
-	struct worker_pool *pool;
 	int pool_id;
 
+	assert_rcu_or_wq_lock();
+
 	if (data & WORK_STRUCT_PWQ)
 		return ((struct pool_workqueue *)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool;
@@ -601,9 +617,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	if (pool_id == WORK_OFFQ_POOL_NONE)
 		return NULL;
 
-	pool = worker_pool_by_id(pool_id);
-	WARN_ON_ONCE(!pool);
-	return pool;
+	return idr_find(&worker_pool_idr, pool_id);
 }
 
 /**
@@ -2767,11 +2781,15 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	struct pool_workqueue *pwq;
 
 	might_sleep();
+
+	local_irq_disable();
 	pool = get_work_pool(work);
-	if (!pool)
+	if (!pool) {
+		local_irq_enable();
 		return false;
+	}
 
-	spin_lock_irq(&pool->lock);
+	spin_lock(&pool->lock);
 	/* see the comment in try_to_grab_pending() with the same code */
 	pwq = get_work_pwq(work);
 	if (pwq) {
@@ -3414,19 +3432,22 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  */
 unsigned int work_busy(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
+	struct worker_pool *pool;
 	unsigned long flags;
 	unsigned int ret = 0;
 
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
 
+	local_irq_save(flags);
+	pool = get_work_pool(work);
 	if (pool) {
-		spin_lock_irqsave(&pool->lock, flags);
+		spin_lock(&pool->lock);
 		if (find_worker_executing_work(pool, work))
 			ret |= WORK_BUSY_RUNNING;
-		spin_unlock_irqrestore(&pool->lock, flags);
+		spin_unlock(&pool->lock);
 	}
+	local_irq_restore(flags);
 
 	return ret;
 }
-- 
1.8.1.4

