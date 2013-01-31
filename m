Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3AaSmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:42:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab3AaSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672844"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 13/13] workqueue: record global worker ID instead of pool ID in work->data when off-queue
Date: Fri, 1 Feb 2013 02:41:36 +0800
Message-Id: <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:41:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:41:07,
	Serialize complete at 2013/02/01 02:41:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time, when we need to find the executing worker from work,
we need 2 steps:
	find the pool from the idr by pool id.
	find the worker from the hash table of the pool.

Now we merge them as one step: find the worker directly from the idr by worker gwid.
(lock_pool_executing_work(). If the work is onq, we still use hash table.)

It makes the code more straightforward.

In future, we may add percpu worker gwid <--> worker mapping cache when needed.

And we are planing to add non-std worker_pool, we still don't know how to
implement worker_pool_by_id() for non-std worker_pool, this patch solves it.

This patch slows down the very-slow-path destroy_worker(), if it is blamed,
we will move the synchronize_rcu() out.

This patch adds a small overhead(rcu_read_[un]lock) in fast path
lock_pool_executing_work(). if it is blamed, we will use rcu_sched instead.
(local_irq_disable() implies rcu_read_lock_sched(), so we can remove
this overhead.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |   18 +++---
 kernel/workqueue.c        |  126 ++++++++++++++++++++-------------------------
 2 files changed, 65 insertions(+), 79 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index cb8e69d..a5c508b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -73,20 +73,20 @@ enum {
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
 
 	/*
-	 * When a work item is off queue, its high bits point to the last
-	 * pool it was on.  Cap at 31 bits and use the highest number to
+	 * When a work item starts to be executed, its high bits point to the
+	 * worker it is running.  Cap at 31 bits and use the highest number to
 	 * indicate that no pool is associated.
 	 */
 	WORK_OFFQ_FLAG_BITS	= 1,
-	WORK_OFFQ_POOL_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
-	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT,
-	WORK_OFFQ_POOL_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
-	WORK_OFFQ_POOL_NONE	= (1LU << WORK_OFFQ_POOL_BITS) - 1,
+	WORK_OFFQ_WORKER_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
+	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_WORKER_SHIFT,
+	WORK_OFFQ_WORKER_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
+	WORK_OFFQ_WORKER_NONE	= (1LU << WORK_OFFQ_WORKER_BITS) - 1,
 
 	/* convenience constants */
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
-	WORK_STRUCT_NO_POOL	= (unsigned long)WORK_OFFQ_POOL_NONE << WORK_OFFQ_POOL_SHIFT,
+	WORK_STRUCT_NO_WORKER	= (unsigned long)WORK_OFFQ_WORKER_NONE << WORK_OFFQ_WORKER_SHIFT,
 
 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
@@ -102,9 +102,9 @@ struct work_struct {
 #endif
 };
 
-#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_POOL)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_WORKER)
 #define WORK_DATA_STATIC_INIT()	\
-	ATOMIC_LONG_INIT(WORK_STRUCT_NO_POOL | WORK_STRUCT_STATIC)
+	ATOMIC_LONG_INIT(WORK_STRUCT_NO_WORKER | WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc57faf..bdaa1f7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -42,6 +42,7 @@
 #include <linux/lockdep.h>
 #include <linux/idr.h>
 #include <linux/hashtable.h>
+#include <linux/rcupdate.h>
 
 #include "workqueue_internal.h"
 
@@ -125,7 +126,6 @@ enum {
 struct worker_pool {
 	spinlock_t		lock;		/* the pool lock */
 	unsigned int		cpu;		/* I: the associated cpu */
-	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
 	struct list_head	worklist;	/* L: list of pending works */
@@ -435,10 +435,6 @@ static atomic_t unbound_std_pool_nr_running[NR_STD_WORKER_POOLS] = {
 	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
 };
 
-/* idr of all pools */
-static DEFINE_MUTEX(worker_pool_idr_mutex);
-static DEFINE_IDR(worker_pool_idr);
-
 /* idr of all workers */
 static DEFINE_MUTEX(worker_gwid_idr_mutex);
 static DEFINE_IDR(worker_gwid_idr);
@@ -478,28 +474,6 @@ static void free_worker_gwid(struct worker *worker)
 	mutex_unlock(&worker_gwid_idr_mutex);
 }
 
-/* allocate ID and assign it to @pool */
-static int worker_pool_assign_id(struct worker_pool *pool)
-{
-	int ret;
-
-	mutex_lock(&worker_pool_idr_mutex);
-	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
-	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
-	mutex_unlock(&worker_pool_idr_mutex);
-
-	return ret;
-}
-
-/*
- * Lookup worker_pool by id.  The idr currently is built during boot and
- * never modified.  Don't worry about locking for now.
- */
-static struct worker_pool *worker_pool_by_id(int pool_id)
-{
-	return idr_find(&worker_pool_idr, pool_id);
-}
-
 static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 {
 	struct worker_pool *pools = std_worker_pools(cpu);
@@ -548,10 +522,10 @@ static int work_next_color(int color)
 /*
  * While queued, %WORK_STRUCT_CWQ is set and non flag bits of a work's data
  * contain the pointer to the queued cwq.  Once execution starts, the flag
- * is cleared and the high bits contain OFFQ flags and pool ID.
+ * is cleared and the high bits contain OFFQ flags and global worker ID.
  *
- * set_work_cwq(), set_work_pool_and_clear_pending(), mark_work_canceling()
- * and clear_work_data() can be used to set the cwq, pool or clear
+ * set_work_cwq(), set_work_worker_and_clear_pending(), mark_work_canceling()
+ * and clear_work_data() can be used to set the cwq, worker or clear
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
@@ -578,15 +552,17 @@ static void set_work_cwq(struct work_struct *work,
 		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }
 
-static void clear_work_cwq(struct work_struct *work, int pool_id)
+static void clear_work_cwq(struct work_struct *work, int worker_gwid)
 {
-	set_work_data(work, pool_id << WORK_OFFQ_POOL_SHIFT,
+	set_work_data(work, worker_gwid << WORK_OFFQ_WORKER_SHIFT,
 		      WORK_STRUCT_PENDING);
 }
 
-static void set_work_pool_and_clear_pending(struct work_struct *work,
-					    int pool_id)
+static void set_work_worker_and_clear_pending(struct work_struct *work,
+					      int worker_gwid)
 {
+	unsigned long data = worker_gwid << WORK_OFFQ_WORKER_SHIFT;
+
 	/*
 	 * The following wmb is paired with the implied mb in
 	 * test_and_set_bit(PENDING) and ensures all updates to @work made
@@ -594,13 +570,13 @@ static void set_work_pool_and_clear_pending(struct work_struct *work,
 	 * owner.
 	 */
 	smp_wmb();
-	set_work_data(work, (unsigned long)pool_id << WORK_OFFQ_POOL_SHIFT, 0);
+	set_work_data(work, data, 0);
 }
 
 static void clear_work_data(struct work_struct *work)
 {
-	smp_wmb();	/* see set_work_pool_and_clear_pending() */
-	set_work_data(work, WORK_STRUCT_NO_POOL, 0);
+	smp_wmb();	/* see set_work_worker_and_clear_pending() */
+	set_work_data(work, WORK_STRUCT_NO_WORKER, 0);
 }
 
 static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
@@ -614,25 +590,25 @@ static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 }
 
 /**
- * offq_work_pool_id - return the worker pool ID a given work is associated with
+ * offq_work_worker_gwid - return the worker gwID a given work is last running on
  * @work: the off-queued work item of interest
  *
- * Return the worker_pool ID @work was last associated with.
+ * Return the worker gwID @work was last running on.
  */
-static int offq_work_pool_id(struct work_struct *work)
+static int offq_work_worker_gwid(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
 
 	BUG_ON(data & WORK_STRUCT_CWQ);
-	return data >> WORK_OFFQ_POOL_SHIFT;
+	return data >> WORK_OFFQ_WORKER_SHIFT;
 }
 
 static void mark_work_canceling(struct work_struct *work)
 {
-	unsigned long pool_id = offq_work_pool_id(work);
+	unsigned long data = offq_work_worker_gwid(work);
 
-	pool_id <<= WORK_OFFQ_POOL_SHIFT;
-	set_work_data(work, pool_id | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
+	data <<= WORK_OFFQ_WORKER_SHIFT;
+	set_work_data(work, data | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
 }
 
 static bool work_is_canceling(struct work_struct *work)
@@ -933,7 +909,7 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 
 /** lock_pool_executing_work - lock the pool a given offq work is running on
  * @work: work of interest
- * @pool_id: pool_id obtained from @work data
+ * @worker_gwid: worker_gwid obtained from @work data
  * @worker: return the worker which is executing @work if found
  *
  * CONTEXT:
@@ -944,27 +920,30 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
  * NULL otherwise.
  */
 static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
-						    unsigned long pool_id,
+						    unsigned long worker_gwid,
 						    struct worker **worker)
 {
 	struct worker_pool *pool;
 	struct worker *exec;
 
-	if (pool_id == WORK_OFFQ_POOL_NONE)
+	if (worker_gwid == WORK_OFFQ_WORKER_NONE)
 		return NULL;
 
-	pool = worker_pool_by_id(pool_id);
-	if (!pool)
-		return NULL;
+	rcu_read_lock();
+	exec = idr_find(&worker_gwid_idr, worker_gwid);
 
-	spin_lock(&pool->lock);
-	exec = find_worker_executing_work(pool, work);
 	if (exec) {
-		BUG_ON(pool != exec->pool);
-		*worker = exec;
-		return pool;
+		pool = exec->pool;
+		spin_lock(&pool->lock);
+		if (exec->current_work == work &&
+		    exec->current_func == work->func) {
+			*worker = exec;
+			rcu_read_unlock();
+			return pool;
+		}
+		spin_unlock(&pool->lock);
 	}
-	spin_unlock(&pool->lock);
+	rcu_read_unlock();
 
 	return NULL;
 }
@@ -1028,14 +1007,14 @@ static struct worker_pool *lock_pool_own_work(struct work_struct *work,
 {
 	unsigned long data = atomic_long_read(&work->data);
 	struct cpu_workqueue_struct *cwq;
-	unsigned long pool_id;
+	unsigned long worker_gwid;
 
 	if (data & WORK_STRUCT_CWQ) {
 		cwq = (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
 		return lock_pool_queued_work(work, cwq);
 	} else if (worker) {
-		pool_id = data >> WORK_OFFQ_POOL_SHIFT;
-		return lock_pool_executing_work(work, pool_id, worker);
+		worker_gwid = data >> WORK_OFFQ_WORKER_SHIFT;
+		return lock_pool_executing_work(work, worker_gwid, worker);
 	}
 
 	return NULL;
@@ -1200,6 +1179,9 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 */
 	pool = lock_pool_own_work(work, NULL);
 	if (pool) {
+		struct worker *worker;
+		int worker_gwid;
+
 		debug_work_deactivate(work);
 
 		/*
@@ -1216,7 +1198,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		list_del_init(&work->entry);
 		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
 
-		clear_work_cwq(work, pool->id);
+		/* Does the work is still running? */
+		worker = find_worker_executing_work(pool, work);
+		worker_gwid = worker ? worker->gwid: WORK_OFFQ_WORKER_NONE;
+		clear_work_cwq(work, worker_gwid);
+
 		spin_unlock(&pool->lock);
 		return 1;
 	}
@@ -1928,6 +1914,7 @@ static void destroy_worker(struct worker *worker)
 
 	kthread_stop(worker->task);
 	free_worker_gwid(worker);
+	synchronize_rcu();
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
@@ -2262,12 +2249,12 @@ __acquires(&pool->lock)
 		wake_up_worker(pool);
 
 	/*
-	 * Record the last pool and clear PENDING which should be the last
+	 * Record this worker and clear PENDING which should be the last
 	 * update to @work.  Also, do this inside @pool->lock so that
 	 * PENDING and queued state changes happen together while IRQ is
 	 * disabled.
 	 */
-	set_work_pool_and_clear_pending(work, pool->id);
+	set_work_worker_and_clear_pending(work, worker->gwid);
 
 	spin_unlock_irq(&pool->lock);
 
@@ -3021,8 +3008,8 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 	if (unlikely(ret < 0))
 		return false;
 
-	set_work_pool_and_clear_pending(&dwork->work,
-					offq_work_pool_id(&dwork->work));
+	set_work_worker_and_clear_pending(&dwork->work,
+					  offq_work_worker_gwid(&dwork->work));
 	local_irq_restore(flags);
 	return ret;
 }
@@ -3838,9 +3825,11 @@ static int __init init_workqueues(void)
 {
 	unsigned int cpu;
 
-	/* make sure we have enough bits for OFFQ pool ID */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_LAST * NR_STD_WORKER_POOLS);
+	/*
+	 * make sure we have enough bits for OFFQ worker gwID,
+	 * at least a 4K stack for every worker.
+	 */
+	BUILD_BUG_ON((BITS_PER_LONG != 64) && (WORK_OFFQ_WORKER_SHIFT > 12));
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
@@ -3866,9 +3855,6 @@ static int __init init_workqueues(void)
 
 			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
-
-			/* alloc pool ID */
-			BUG_ON(worker_pool_assign_id(pool));
 		}
 	}
 
-- 
1.7.7.6

