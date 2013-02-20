Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab3BTSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:11:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758848Ab3BTSLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:11:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,703,1355068800"; 
   d="scan'208";a="6737455"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: clear workers of a pool after the CPU is offline
Date: Thu, 21 Feb 2013 01:04:54 +0800
Message-Id: <1361379899-2232-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/21 01:04:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/21 01:04:31,
	Serialize complete at 2013/02/21 01:04:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we removed the trustee_thread(), the workers of a pool can't
be totally clear after the CPU is offline.

And in future, we will introduce non-std pools, but we still
have no way to clear workers before we try to free the non-std pools.

We add offline_pool() and POOL_OFFLINE flag to do so.

1) Before we try to clear workers, we set the POOL_OFFLINE to the pool,
   and pool will not serve to works, any work which is tried to be queued
   on that pool will be rejected except chained works.
2) when all the pending works are finished and all workers are idle, worker
   thread will schedule offline_pool() to clear workers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b1e6f2..ffdc1db 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -58,14 +58,18 @@ enum {
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
-	 * Note that DISASSOCIATED can be flipped only while holding
-	 * assoc_mutex to avoid changing binding state while
+	 * OFFLINE is further state of DISASSOCIATED when the cpu had finished
+	 * offline and all workers will exit after they finish the last works.
+	 *
+	 * Note that DISASSOCIATED and OFFLINE can be flipped only while
+	 * holding assoc_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
-	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
+	POOL_DISASSOCIATED	= 1 << 2,	/* pool dissociates its cpu */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
+	POOL_OFFLINE		= 1 << 4,	/* pool can't serve work */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -143,6 +147,7 @@ struct worker_pool {
 						/* L: hash of busy workers */
 
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
+	struct work_struct	offline_work;	/* offline the pool */
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	/*
@@ -1228,6 +1233,12 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		} else {
 			spin_lock(&pwq->pool->lock);
 		}
+
+		if (unlikely(pwq->pool->flags & POOL_OFFLINE) &&
+		    WARN_ON_ONCE(!is_chained_work(wq))) {
+			spin_unlock(&pwq->pool->lock);
+			return;
+		}
 	} else {
 		pwq = get_pwq(WORK_CPU_UNBOUND, wq);
 		spin_lock(&pwq->pool->lock);
@@ -2063,6 +2074,55 @@ static bool manage_workers(struct worker *worker)
 }
 
 /**
+ * offline_pool - try to offline a pool
+ * @work: embedded offline work item of the target pool
+ *
+ * Try to offline a pool by destroying all its workers.
+ * offline_pool() only destroys workers which are idle on the idle_list.
+ * If any workers just leaves idle by any reason, it will not be destroyed,
+ * but offline_pool() will be rescheduled via worker_thread() again in
+ * this case. So offline_pool() may be called multi times to finish
+ * offline in this rare case.
+ *
+ * offline_pool() is always scheduled by system_unbound_wq included
+ * high priority pools:
+ *  1) The pool of system_unbound_wq is always online.
+ *  2) The latency of offline_pool() doesn't matter.
+ */
+static void offline_pool(struct work_struct *work)
+{
+	struct worker_pool *pool;
+	struct worker *worker;
+
+	pool = container_of(work, struct worker_pool, offline_work);
+
+	mutex_lock(&pool->assoc_mutex);
+	if (!(pool->flags & POOL_OFFLINE)) {
+		/* the pool is back, cancel offline */
+		mutex_unlock(&pool->assoc_mutex);
+		return;
+	}
+
+	spin_lock_irq(&pool->lock);
+	BUG_ON(!list_empty(&pool->worklist));
+
+	while (!list_empty(&pool->idle_list)) {
+		worker = list_first_entry(&pool->idle_list,
+					  struct worker, entry);
+		destroy_worker(worker);
+	}
+
+	spin_unlock_irq(&pool->lock);
+	mutex_unlock(&pool->assoc_mutex);
+}
+
+static inline bool need_to_offline_pool(struct worker_pool *pool)
+{
+	return (pool->flags & POOL_OFFLINE) &&
+	       (pool->nr_workers == pool->nr_idle);
+}
+
+/**
  * process_one_work - process single work
  * @worker: self
  * @work: work to process
@@ -2222,6 +2282,7 @@ static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct worker_pool *pool = worker->pool;
+	bool pool_offline;
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
@@ -2296,8 +2357,11 @@ sleep:
 	 * event.
 	 */
 	worker_enter_idle(worker);
+	pool_offline = need_to_offline_pool(pool);
 	__set_current_state(TASK_INTERRUPTIBLE);
 	spin_unlock_irq(&pool->lock);
+	if (pool_offline)
+		queue_work(system_unbound_wq, &pool->offline_work);
 	schedule();
 	goto woke_up;
 }
@@ -3487,18 +3551,24 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		for_each_std_worker_pool(pool, cpu) {
-			struct worker *worker;
-
-			if (pool->nr_workers)
-				continue;
+			struct worker *worker = NULL;
 
-			worker = create_worker(pool);
-			if (!worker)
-				return NOTIFY_BAD;
+			mutex_lock(&pool->assoc_mutex);
+			if (!pool->nr_workers) {
+				worker = create_worker(pool);
+				if (!worker) {
+					mutex_unlock(&pool->assoc_mutex);
+					return NOTIFY_BAD;
+				}
+			}
 
 			spin_lock_irq(&pool->lock);
-			start_worker(worker);
+			pool->flags &= ~POOL_OFFLINE;
+			if (worker)
+				start_worker(worker);
+
 			spin_unlock_irq(&pool->lock);
+			mutex_unlock(&pool->assoc_mutex);
 		}
 		break;
 
@@ -3528,6 +3598,7 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	struct worker_pool *pool;
 	struct work_struct unbind_work;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -3537,6 +3608,19 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 		flush_work(&unbind_work);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_POST_DEAD:
+		for_each_std_worker_pool(pool, cpu) {
+			mutex_lock(&pool->assoc_mutex);
+			spin_lock_irq(&pool->lock);
+
+			pool->flags |= POOL_OFFLINE;
+			wake_up_worker(pool);
+
+			spin_unlock_irq(&pool->lock);
+			mutex_unlock(&pool->assoc_mutex);
+		}
+		break;
 	}
 	return NOTIFY_OK;
 }
@@ -3740,6 +3824,7 @@ static int __init init_workqueues(void)
 		for_each_std_worker_pool(pool, cpu) {
 			spin_lock_init(&pool->lock);
 			pool->cpu = cpu;
+			pool->flags |= POOL_OFFLINE;
 			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
@@ -3753,6 +3838,7 @@ static int __init init_workqueues(void)
 				    (unsigned long)pool);
 
 			mutex_init(&pool->assoc_mutex);
+			INIT_WORK(&pool->offline_work, offline_pool);
 			ida_init(&pool->worker_ida);
 
 			/* alloc pool ID */
@@ -3767,6 +3853,7 @@ static int __init init_workqueues(void)
 		for_each_std_worker_pool(pool, cpu) {
 			struct worker *worker;
 
+			pool->flags &= ~POOL_OFFLINE;
 			if (cpu != WORK_CPU_UNBOUND)
 				pool->flags &= ~POOL_DISASSOCIATED;
 
-- 
1.7.7.6

