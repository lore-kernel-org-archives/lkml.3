Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3BRQQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:16:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3BRQOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724948"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 09/15] workqueue: use worker id in work->data instead
Date: Tue, 19 Feb 2013 00:12:10 +0800
Message-Id: <1361203940-6300-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:36,
	Serialize complete at 2013/02/19 00:13:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time, when we need to find the executing worker from work,
we need 2 steps:
	find the pool from the idr by pool id.
	find the worker from the hash table of the pool.

Now we merge them as one step: find the worker directly from the idr by worker ID.
(lock_work_pool(). If the work is queued, we still use hash table.)

It makes the code more straightforward.

In future, we may add "percpu worker ID <--> worker" mapping cache when needed.

And we are planing to add non-std worker_pool, we still don't know how to
implement worker_pool_by_id() for non-std worker_pool, this patch solves it.

This patch slows down the very-slow-path destroy_worker(), if it is required,
we will move the synchronize_sched() out.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |   20 +++---
 kernel/workqueue.c        |  140 ++++++++++++++++++++++-----------------------
 2 files changed, 78 insertions(+), 82 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0be57d4..a8db8c4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -73,20 +73,20 @@ enum {
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
 
 	/*
-	 * When a work item is off queue, its high bits point to the last
-	 * pool it was on.  Cap at 31 bits and use the highest number to
-	 * indicate that no pool is associated.
+	 * When a work item starts to be executed, its high bits point to the
+	 * worker it is running on.  Cap at 31 bits and use the highest number
+	 * to indicate that no worker is associated.
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
index 9086a33..e14a03e 100644
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
@@ -431,10 +431,6 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_std_worker_pools);
 static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
 
-/* idr of all pools */
-static DEFINE_MUTEX(worker_pool_idr_mutex);
-static DEFINE_IDR(worker_pool_idr);
-
 /* idr of all workers */
 static DEFINE_MUTEX(worker_idr_mutex);
 static DEFINE_IDR(worker_idr);
@@ -474,28 +470,6 @@ static void free_worker_id(struct worker *worker)
 	mutex_unlock(&worker_idr_mutex);
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
@@ -533,10 +507,11 @@ static int work_next_color(int color)
 /*
  * While queued, %WORK_STRUCT_CWQ is set and non flag bits of a work's data
  * contain the pointer to the queued cwq.  Once execution starts, the flag
- * is cleared and the high bits contain OFFQ flags and pool ID.
+ * is cleared and the high bits contain OFFQ flags and worker ID.
  *
- * set_work_cwq(), set_work_pool_and_clear_pending(), mark_work_canceling()
- * and clear_work_data() can be used to set the cwq, pool or clear
+ * set_work_cwq(), set_work_worker_and_keep_pending(),
+ * set_work_worker_and_clear_pending(), mark_work_canceling()
+ * and clear_work_data() can be used to set the cwq, worker or clear
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
@@ -563,15 +538,19 @@ static void set_work_cwq(struct work_struct *work,
 		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }
 
-static void set_work_pool_and_keep_pending(struct work_struct *work,
-					   int pool_id)
+static inline unsigned long worker_id_to_data(int worker_id)
 {
-	set_work_data(work, (unsigned long)pool_id << WORK_OFFQ_POOL_SHIFT,
-		      WORK_STRUCT_PENDING);
+	return (unsigned long)worker_id << WORK_OFFQ_WORKER_SHIFT;
 }
 
-static void set_work_pool_and_clear_pending(struct work_struct *work,
-					    int pool_id)
+static void set_work_worker_and_keep_pending(struct work_struct *work,
+					     int worker_id)
+{
+	set_work_data(work, worker_id_to_data(worker_id), WORK_STRUCT_PENDING);
+}
+
+static void set_work_worker_and_clear_pending(struct work_struct *work,
+					      int worker_id)
 {
 	/*
 	 * The following wmb is paired with the implied mb in
@@ -580,13 +559,13 @@ static void set_work_pool_and_clear_pending(struct work_struct *work,
 	 * owner.
 	 */
 	smp_wmb();
-	set_work_data(work, (unsigned long)pool_id << WORK_OFFQ_POOL_SHIFT, 0);
+	set_work_data(work, worker_id_to_data(worker_id), 0);
 }
 
 static void clear_work_data(struct work_struct *work)
 {
-	smp_wmb();	/* see set_work_pool_and_clear_pending() */
-	set_work_data(work, WORK_STRUCT_NO_POOL, 0);
+	smp_wmb();	/* see set_work_worker_and_clear_pending() */
+	set_work_data(work, WORK_STRUCT_NO_WORKER, 0);
 }
 
 static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
@@ -600,29 +579,28 @@ static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 }
 
 /**
- * get_work_pool_id - return the worker pool ID a given work is associated with
+ * get_work_worker_id - return the worker ID a given work was last running on
  * @work: the work item of interest
  *
- * Return the worker_pool ID @work was last associated with.
- * %WORK_OFFQ_POOL_NONE if none.
+ * Return the worker ID @work was last running on.
+ * %WORK_OFFQ_WORKER_NONE if none.
  */
-static int get_work_pool_id(struct work_struct *work)
+static int get_work_worker_id(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
 
-	if (data & WORK_STRUCT_CWQ)
-		return ((struct cpu_workqueue_struct *)
-			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->id;
+	if (WARN_ON_ONCE(data & WORK_STRUCT_CWQ))
+		return WORK_OFFQ_WORKER_NONE;
 
-	return data >> WORK_OFFQ_POOL_SHIFT;
+	return data >> WORK_OFFQ_WORKER_SHIFT;
 }
 
 static void mark_work_canceling(struct work_struct *work)
 {
-	unsigned long pool_id = get_work_pool_id(work);
+	unsigned long data = get_work_worker_id(work);
 
-	pool_id <<= WORK_OFFQ_POOL_SHIFT;
-	set_work_data(work, pool_id | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
+	data <<= WORK_OFFQ_WORKER_SHIFT;
+	set_work_data(work, data | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
 }
 
 static bool work_is_canceling(struct work_struct *work)
@@ -918,6 +896,26 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 }
 
 /**
+ * worker_by_id - lookup worker by id
+ * @id: the worker id of of interest
+ *
+ * CONTEXT:
+ * local_irq_disable().
+ *
+ * local_irq_disable() implies rcu_read_lock_sched().
+ */
+static struct worker *worker_by_id(int id)
+{
+	if (!WARN_ON_ONCE(irqs_disabled()))
+		return NULL;
+
+	if (id == WORK_OFFQ_WORKER_NONE)
+		return NULL;
+
+	return idr_find(&worker_idr, id);
+}
+
+/**
  * lock_work_pool - return and lock the pool a given work was associated with
  * @work: the work item of interest
  * @queued_cwq: set to the queued cwq if the work is still queued
@@ -935,7 +933,6 @@ struct worker_pool *lock_work_pool(struct work_struct *work,
 				   struct worker **running_worker)
 {
 	unsigned long data = atomic_long_read(&work->data);
-	unsigned long pool_id;
 	struct worker_pool *pool;
 	struct cpu_workqueue_struct *cwq;
 	struct worker *worker = NULL;
@@ -958,16 +955,15 @@ struct worker_pool *lock_work_pool(struct work_struct *work,
 			worker = find_worker_executing_work(pool, work);
 		}
 	} else {
-		pool_id = data >> WORK_OFFQ_POOL_SHIFT;
-		if (pool_id == WORK_OFFQ_POOL_NONE)
-			return NULL;
-
-		pool = worker_pool_by_id(pool_id);
-		if (!pool)
+		worker = worker_by_id(data >> WORK_OFFQ_WORKER_SHIFT);
+		if (!worker)
 			return NULL;
 
+		pool = worker->pool;
 		spin_lock(&pool->lock);
-		worker = find_worker_executing_work(pool, work);
+		if (pool != worker->pool || worker->current_work != work ||
+		    worker->current_func != work->func)
+			worker = NULL;
 	}
 
 	if (worker)
@@ -1139,7 +1135,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		goto fail;
 
 	if (cwq) {
-		int pool_id;
+		int worker_id;
 
 		debug_work_deactivate(work);
 
@@ -1158,11 +1154,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 
 		/* work is dequeued, work->data points to pool iff running */
 		if (worker)
-			pool_id = pool->id;
+			worker_id = worker->id;
 		else
-			pool_id = WORK_OFFQ_POOL_NONE;
+			worker_id = WORK_OFFQ_WORKER_NONE;
 
-		set_work_pool_and_keep_pending(work, pool_id);
+		set_work_worker_and_keep_pending(work, worker_id);
 
 		spin_unlock(&pool->lock);
 		return 1;
@@ -1862,6 +1858,7 @@ static void destroy_worker(struct worker *worker)
 
 	kthread_stop(worker->task);
 	free_worker_id(worker);
+	synchronize_sched();
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
@@ -2196,12 +2193,12 @@ __acquires(&pool->lock)
 		wake_up_worker(pool);
 
 	/*
-	 * Record the last pool and clear PENDING which should be the last
+	 * Record this worker and clear PENDING which should be the last
 	 * update to @work.  Also, do this inside @pool->lock so that
 	 * PENDING and queued state changes happen together while IRQ is
 	 * disabled.
 	 */
-	set_work_pool_and_clear_pending(work, pool->id);
+	set_work_worker_and_clear_pending(work, worker->id);
 
 	spin_unlock_irq(&pool->lock);
 
@@ -2961,8 +2958,8 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 	if (unlikely(ret < 0))
 		return false;
 
-	set_work_pool_and_clear_pending(&dwork->work,
-					get_work_pool_id(&dwork->work));
+	set_work_worker_and_clear_pending(&dwork->work,
+					  get_work_worker_id(&dwork->work));
 	local_irq_restore(flags);
 	return ret;
 }
@@ -3780,9 +3777,11 @@ static int __init init_workqueues(void)
 {
 	unsigned int cpu;
 
-	/* make sure we have enough bits for OFFQ pool ID */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_END * NR_STD_WORKER_POOLS);
+	/*
+	 * make sure we have enough bits for OFFQ worker ID,
+	 * at least a 4K stack for every worker.
+	 */
+	BUILD_BUG_ON((BITS_PER_LONG != 64) && (WORK_OFFQ_WORKER_SHIFT > 12));
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
@@ -3808,9 +3807,6 @@ static int __init init_workqueues(void)
 
 			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
-
-			/* alloc pool ID */
-			BUG_ON(worker_pool_assign_id(pool));
 		}
 	}
 
-- 
1.7.7.6

