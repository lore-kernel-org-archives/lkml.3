Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3GYKsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:48:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3GYKs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:48:29 -0400
X-IronPort-AV: E=Sophos;i="4.89,742,1367942400"; 
   d="scan'208";a="8021025"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: clear workers of a pool after the CPU is offline
Date: Thu, 25 Jul 2013 18:52:02 +0800
Message-Id: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:46:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:46:24,
	Serialize complete at 2013/07/25 18:46:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unbound pools and their workers can be destroyed/cleared
when their refcnt become zero. But the cpu pool can't be destroyed
due to they are always referenced, their refcnt are always > 0.

We don't want to destroy the cpu pools, but we want to destroy
the workers of the pool when the pool is full idle after the cpu
is offline. This is the default behavior in old days until
we removed the trustee_thread().

We need to find a new way to restore this behavior,
We add offline_pool() and POOL_OFFLINE flag to do so.

1) Before we try to clear workers, we set the POOL_OFFLINE to the pool,
   and pool will not serve to works, any work which is tried to be queued
   on that pool will be rejected except chained works.

2) when all the pending works are finished and all workers are idle, worker
   thread will schedule offline_pool() to clear workers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..2617895 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -63,13 +63,18 @@ enum {
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
-	 * Note that DISASSOCIATED should be flipped only while holding
-	 * manager_mutex to avoid changing binding state while
+	 * OFFLINE is a further state of DISASSOCIATED when the cpu had
+	 * finished offline and all the workers will exit after they
+	 * finish the last works of the pool.
+	 *
+	 * Note that DISASSOCIATED and OFFLINE should be flipped only while
+	 * holding manager_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
+	POOL_DISASSOCIATED	= 1 << 2,	/* pool dissociates its cpu */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
+	POOL_OFFLINE		= 1 << 4,	/* pool can't serve work */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -164,6 +169,7 @@ struct worker_pool {
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
 	struct idr		worker_idr;	/* MG: worker IDs and iteration */
+	struct work_struct	offline_work;	/* offline the pool */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -1372,6 +1378,12 @@ retry:
 			  wq->name, cpu);
 	}
 
+	if (unlikely(pwq->pool->flags & POOL_OFFLINE) &&
+	    WARN_ON_ONCE(!is_chained_work(wq))) {
+		spin_unlock(&pwq->pool->lock);
+		return;
+	}
+
 	/* pwq determined, queue */
 	trace_workqueue_queue_work(req_cpu, pwq, work);
 
@@ -1784,7 +1796,7 @@ static void start_worker(struct worker *worker)
 }
 
 /**
- * create_and_start_worker - create and start a worker for a pool
+ * create_and_start_worker - create and start the initial worker for a pool
  * @pool: the target pool
  *
  * Grab the managership of @pool and create and start a new worker for it.
@@ -1798,6 +1810,7 @@ static int create_and_start_worker(struct worker_pool *pool)
 	worker = create_worker(pool);
 	if (worker) {
 		spin_lock_irq(&pool->lock);
+		pool->flags &= ~POOL_OFFLINE;
 		start_worker(worker);
 		spin_unlock_irq(&pool->lock);
 	}
@@ -2091,6 +2104,54 @@ static bool manage_workers(struct worker *worker)
 }
 
 /**
+ * offline_pool - try to offline a pool
+ * @work: embedded offline work item of the target pool
+ *
+ * Try to offline a pool by destroying all its workers.
+ *
+ * offline_pool() only destroys workers which are idle on the idle_list.
+ * If any worker leaves idle by some reasons, it can not be destroyed,
+ * but this work item will be rescheduled by the worker's worker_thread()
+ * again in this case. So offline_pool() may be called multi times
+ * to finish offline pool in this rare case.
+ *
+ * offline_pool() is always scheduled by system_unbound_wq even the pool
+ * is high priority pool:
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
+	mutex_lock(&pool->manager_mutex);
+	if (!(pool->flags & POOL_OFFLINE)) {
+		/* the pool is back online, cancel offline */
+		mutex_unlock(&pool->manager_mutex);
+		return;
+	}
+
+	spin_lock_irq(&pool->lock);
+	while (!list_empty(&pool->idle_list)) {
+		worker = list_first_entry(&pool->idle_list,
+					  struct worker, entry);
+		destroy_worker(worker);
+	}
+	spin_unlock_irq(&pool->lock);
+
+	mutex_unlock(&pool->manager_mutex);
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
@@ -2251,6 +2312,7 @@ static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct worker_pool *pool = worker->pool;
+	bool pool_offline;
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
@@ -2320,8 +2382,11 @@ sleep:
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
@@ -3451,6 +3516,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	pool->cpu = -1;
 	pool->node = NUMA_NO_NODE;
 	pool->flags |= POOL_DISASSOCIATED;
+	pool->flags |= POOL_OFFLINE;
 	INIT_LIST_HEAD(&pool->worklist);
 	INIT_LIST_HEAD(&pool->idle_list);
 	hash_init(pool->busy_hash);
@@ -3465,6 +3531,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
+	INIT_WORK(&pool->offline_work, offline_pool);
 
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -4702,6 +4769,7 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 void *hcpu)
 {
 	int cpu = (unsigned long)hcpu;
+	struct worker_pool *pool;
 	struct work_struct unbind_work;
 	struct workqueue_struct *wq;
 
@@ -4720,6 +4788,19 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 		/* wait for per-cpu unbinding to finish */
 		flush_work(&unbind_work);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_POST_DEAD:
+		for_each_cpu_worker_pool(pool, cpu) {
+			mutex_lock(&pool->manager_mutex);
+			spin_lock_irq(&pool->lock);
+
+			pool->flags |= POOL_OFFLINE;
+			wake_up_worker(pool);
+
+			spin_unlock_irq(&pool->lock);
+			mutex_unlock(&pool->manager_mutex);
+		}
+		break;
 	}
 	return NOTIFY_OK;
 }
-- 
1.7.4.4

