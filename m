Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3AQBpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:45:50 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60719 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290Ab3AQBnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:05 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/17] workqueue: record pool ID instead of CPU in work->data when off-queue
Date: Wed, 16 Jan 2013 17:42:39 -0800
Message-Id: <1358386969-945-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a work item is off-queue, work->data records the CPU
it was last on, which is used to locate the last executing instance
for non-reentrance, flushing, etc.

We're in the process of removing global_cwq and making worker_pool the
top level abstraction.  This patch makes work->data point to the pool
it was last associated with instead of CPU.

After the previous WORK_OFFQ_POOL_CPU and worker_poo->id additions,
the conversion is fairly straight-forward.  WORK_OFFQ constants and
functions are modified to record and read back pool ID instead.
worker_pool_by_id() is added to allow looking up pool from ID.
get_work_pool() replaces get_work_gcwq(), which is reimplemented using
get_work_pool().  get_work_pool_id() replaces work_cpu().

This patch shouldn't introduce any observable behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  18 ++++----
 kernel/workqueue.c        | 111 ++++++++++++++++++++++++++++------------------
 2 files changed, 76 insertions(+), 53 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f8b3576..a94e4e8 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -75,19 +75,19 @@ enum {
 
 	/*
 	 * When a work item is off queue, its high bits point to the last
-	 * cpu it was on.  Cap at 31 bits and use the highest number to
-	 * indicate that no cpu is associated.
+	 * pool it was on.  Cap at 31 bits and use the highest number to
+	 * indicate that no pool is associated.
 	 */
 	WORK_OFFQ_FLAG_BITS	= 1,
-	WORK_OFFQ_CPU_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
-	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_CPU_SHIFT,
-	WORK_OFFQ_CPU_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
-	WORK_OFFQ_CPU_NONE	= (1LU << WORK_OFFQ_CPU_BITS) - 1,
+	WORK_OFFQ_POOL_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
+	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT,
+	WORK_OFFQ_POOL_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
+	WORK_OFFQ_POOL_NONE	= (1LU << WORK_OFFQ_POOL_BITS) - 1,
 
 	/* convenience constants */
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
-	WORK_STRUCT_NO_CPU	= (unsigned long)WORK_OFFQ_CPU_NONE << WORK_OFFQ_CPU_SHIFT,
+	WORK_STRUCT_NO_POOL	= (unsigned long)WORK_OFFQ_POOL_NONE << WORK_OFFQ_POOL_SHIFT,
 
 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
@@ -103,9 +103,9 @@ struct work_struct {
 #endif
 };
 
-#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_POOL)
 #define WORK_DATA_STATIC_INIT()	\
-	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU | WORK_STRUCT_STATIC)
+	ATOMIC_LONG_INIT(WORK_STRUCT_NO_POOL | WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fbe2e24..3b4d8a7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -478,7 +478,6 @@ static DEFINE_MUTEX(worker_pool_idr_mutex);
 static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
-static unsigned int work_cpu(struct work_struct *work);
 
 static int std_worker_pool_pri(struct worker_pool *pool)
 {
@@ -506,6 +505,15 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 	return ret;
 }
 
+/*
+ * Lookup worker_pool by id.  The idr currently is built during boot and
+ * never modified.  Don't worry about locking for now.
+ */
+static struct worker_pool *worker_pool_by_id(int pool_id)
+{
+	return idr_find(&worker_pool_idr, pool_id);
+}
+
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->gcwq->cpu;
@@ -547,17 +555,17 @@ static int work_next_color(int color)
 /*
  * While queued, %WORK_STRUCT_CWQ is set and non flag bits of a work's data
  * contain the pointer to the queued cwq.  Once execution starts, the flag
- * is cleared and the high bits contain OFFQ flags and CPU number.
+ * is cleared and the high bits contain OFFQ flags and pool ID.
  *
- * set_work_cwq(), set_work_cpu_and_clear_pending(), mark_work_canceling()
- * and clear_work_data() can be used to set the cwq, cpu or clear
+ * set_work_cwq(), set_work_pool_and_clear_pending(), mark_work_canceling()
+ * and clear_work_data() can be used to set the cwq, pool or clear
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
- * get_work_[g]cwq() can be used to obtain the gcwq or cwq corresponding to
- * a work.  gcwq is available once the work has been queued anywhere after
- * initialization until it is sync canceled.  cwq is available only while
- * the work item is queued.
+ * get_work_pool() and get_work_cwq() can be used to obtain the pool or cwq
+ * corresponding to a work.  Pool is available once the work has been
+ * queued anywhere after initialization until it is sync canceled.  cwq is
+ * available only while the work item is queued.
  *
  * %WORK_OFFQ_CANCELING is used to mark a work item which is being
  * canceled.  While being canceled, a work item may have its PENDING set
@@ -579,8 +587,8 @@ static void set_work_cwq(struct work_struct *work,
 		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }
 
-static void set_work_cpu_and_clear_pending(struct work_struct *work,
-					   unsigned int cpu)
+static void set_work_pool_and_clear_pending(struct work_struct *work,
+					    int pool_id)
 {
 	/*
 	 * The following wmb is paired with the implied mb in
@@ -589,13 +597,13 @@ static void set_work_cpu_and_clear_pending(struct work_struct *work,
 	 * owner.
 	 */
 	smp_wmb();
-	set_work_data(work, (unsigned long)cpu << WORK_OFFQ_CPU_SHIFT, 0);
+	set_work_data(work, (unsigned long)pool_id << WORK_OFFQ_POOL_SHIFT, 0);
 }
 
 static void clear_work_data(struct work_struct *work)
 {
-	smp_wmb();	/* see set_work_cpu_and_clear_pending() */
-	set_work_data(work, WORK_STRUCT_NO_CPU, 0);
+	smp_wmb();	/* see set_work_pool_and_clear_pending() */
+	set_work_data(work, WORK_STRUCT_NO_POOL, 0);
 }
 
 static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
@@ -608,30 +616,58 @@ static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 		return NULL;
 }
 
-static struct global_cwq *get_work_gcwq(struct work_struct *work)
+/**
+ * get_work_pool - return the worker_pool a given work was associated with
+ * @work: the work item of interest
+ *
+ * Return the worker_pool @work was last associated with.  %NULL if none.
+ */
+static struct worker_pool *get_work_pool(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
-	unsigned int cpu;
+	struct worker_pool *pool;
+	int pool_id;
 
 	if (data & WORK_STRUCT_CWQ)
 		return ((struct cpu_workqueue_struct *)
-			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->gcwq;
+			(data & WORK_STRUCT_WQ_DATA_MASK))->pool;
 
-	cpu = data >> WORK_OFFQ_CPU_SHIFT;
-	if (cpu == WORK_OFFQ_CPU_NONE)
+	pool_id = data >> WORK_OFFQ_POOL_SHIFT;
+	if (pool_id == WORK_OFFQ_POOL_NONE)
 		return NULL;
 
-	BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);
-	return get_gcwq(cpu);
+	pool = worker_pool_by_id(pool_id);
+	WARN_ON_ONCE(!pool);
+	return pool;
+}
+
+/**
+ * get_work_pool_id - return the worker pool ID a given work is associated with
+ * @work: the work item of interest
+ *
+ * Return the worker_pool ID @work was last associated with.
+ * %WORK_OFFQ_POOL_NONE if none.
+ */
+static int get_work_pool_id(struct work_struct *work)
+{
+	struct worker_pool *pool = get_work_pool(work);
+
+	return pool ? pool->id : WORK_OFFQ_POOL_NONE;
+}
+
+static struct global_cwq *get_work_gcwq(struct work_struct *work)
+{
+	struct worker_pool *pool = get_work_pool(work);
+
+	return pool ? pool->gcwq : NULL;
 }
 
 static void mark_work_canceling(struct work_struct *work)
 {
-	struct global_cwq *gcwq = get_work_gcwq(work);
-	unsigned long cpu = gcwq ? gcwq->cpu : WORK_OFFQ_CPU_NONE;
+	unsigned long pool_id = get_work_pool_id(work);
 
-	set_work_data(work, (cpu << WORK_OFFQ_CPU_SHIFT) | WORK_OFFQ_CANCELING,
-		      WORK_STRUCT_PENDING);
+	pool_id <<= WORK_OFFQ_POOL_SHIFT;
+	set_work_data(work, pool_id | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
 }
 
 static bool work_is_canceling(struct work_struct *work)
@@ -2211,12 +2247,12 @@ __acquires(&gcwq->lock)
 		wake_up_worker(pool);
 
 	/*
-	 * Record the last CPU and clear PENDING which should be the last
+	 * Record the last pool and clear PENDING which should be the last
 	 * update to @work.  Also, do this inside @gcwq->lock so that
 	 * PENDING and queued state changes happen together while IRQ is
 	 * disabled.
 	 */
-	set_work_cpu_and_clear_pending(work, gcwq->cpu);
+	set_work_pool_and_clear_pending(work, pool->id);
 
 	spin_unlock_irq(&gcwq->lock);
 
@@ -2977,7 +3013,8 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 	if (unlikely(ret < 0))
 		return false;
 
-	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
+	set_work_pool_and_clear_pending(&dwork->work,
+					get_work_pool_id(&dwork->work));
 	local_irq_restore(flags);
 	return ret;
 }
@@ -3440,20 +3477,6 @@ bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
 EXPORT_SYMBOL_GPL(workqueue_congested);
 
 /**
- * work_cpu - return the last known associated cpu for @work
- * @work: the work of interest
- *
- * RETURNS:
- * CPU number if @work was ever queued.  WORK_CPU_NONE otherwise.
- */
-static unsigned int work_cpu(struct work_struct *work)
-{
-	struct global_cwq *gcwq = get_work_gcwq(work);
-
-	return gcwq ? gcwq->cpu : WORK_CPU_NONE;
-}
-
-/**
  * work_busy - test whether a work is currently pending or running
  * @work: the work to be tested
  *
@@ -3825,9 +3848,9 @@ static int __init init_workqueues(void)
 {
 	unsigned int cpu;
 
-	/* make sure we have enough bits for OFFQ CPU number */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_CPU_SHIFT)) <
-		     WORK_CPU_LAST);
+	/* make sure we have enough bits for OFFQ pool ID */
+	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
+		     WORK_CPU_LAST * NR_STD_WORKER_POOLS);
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
-- 
1.8.0.2

