Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaD0EGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:06:03 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51862 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753054AbaD0EF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:59 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778323"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/10] workqueue: rename manager_mutex to bind_mutex
Date: Sun, 27 Apr 2014 12:09:03 +0800
Message-ID: <1398571754-12443-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

manager_mutex is only used to protect the binding of the pool
and the workers. It protects the bind_list and operations
based on this list, such as:
	cpu-binding for the workers in the bind_list
	concurrency management for the workers in the bind_list

So we can simply rename manager_mutex to bind_mutex without any
functionality changed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   47 +++++++++++++++++++++----------------------
 kernel/workqueue_internal.h |    2 +-
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ff6ec9a..9e0e606 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -65,7 +65,7 @@ enum {
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
-	 * manager_mutex to avoid changing binding state while
+	 * bind_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
@@ -122,7 +122,7 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * M: pool->manager_mutex protected.
+ * B: pool->bind_mutex protected.
  *
  * PL: wq_pool_mutex protected.
  *
@@ -160,8 +160,8 @@ struct worker_pool {
 
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
-	struct mutex		manager_mutex;	/* manager exclusion */
-	struct list_head	bind_list;	/* M: pool-bound workers */
+	struct mutex		bind_mutex;	/* pool-bind/unbind exclusion */
+	struct list_head	bind_list;	/* B: pool-bound workers */
 	wait_queue_head_t	workers_unbound;/* all workers pool-unbound */
 
 	struct ida		worker_ida;	/* worker IDs for task name */
@@ -1677,11 +1677,11 @@ static void worker_unbind_pool(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->bind_mutex);
 	list_del(&worker->bind_entry);
 	if (list_empty(&pool->bind_list))
 		wake_up(&pool->workers_unbound);
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->bind_mutex);
 }
 
 /**
@@ -1731,7 +1731,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->bind_mutex);
 
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
@@ -1740,7 +1740,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * The pool->manager_mutex ensures %POOL_DISASSOCIATED
+	 * The pool->bind_mutex ensures %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
 	 * flag definition for details.
 	 */
@@ -1750,7 +1750,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* successful, bind the worker to the pool */
 	list_add_tail(&worker->bind_entry, &pool->bind_list);
 
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->bind_mutex);
 
 	return worker;
 
@@ -3433,7 +3433,7 @@ static int init_worker_pool(struct worker_pool *pool)
 		    (unsigned long)pool);
 
 	mutex_init(&pool->manager_arb);
-	mutex_init(&pool->manager_mutex);
+	mutex_init(&pool->bind_mutex);
 	INIT_LIST_HEAD(&pool->bind_list);
 	init_waitqueue_head(&pool->workers_unbound);
 
@@ -3489,8 +3489,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
-	 * manager_arb prevents @pool's workers from blocking on
-	 * manager_mutex.
+	 * manager_arb ensures @pool's manager finished.
 	 */
 	mutex_lock(&pool->manager_arb);
 
@@ -3501,12 +3500,12 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->bind_mutex);
 	wait_event_cmd(pool->workers_unbound,
 		       list_empty(&pool->bind_list),
-		       mutex_unlock(&pool->manager_mutex),
-		       mutex_lock(&pool->manager_mutex));
-	mutex_unlock(&pool->manager_mutex);
+		       mutex_unlock(&pool->bind_mutex),
+		       mutex_lock(&pool->bind_mutex));
+	mutex_unlock(&pool->bind_mutex);
 
 	mutex_unlock(&pool->manager_arb);
 
@@ -4490,12 +4489,12 @@ static void wq_unbind_fn(struct work_struct *work)
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
 
-		mutex_lock(&pool->manager_mutex);
+		mutex_lock(&pool->bind_mutex);
 		spin_lock_irq(&pool->lock);
 
 		/*
-		 * We've blocked all manager operations.  Make all workers
-		 * unbound and set DISASSOCIATED.  Before this, all workers
+		 * We've blocked all pool-[un]bind operations. Make all workers
+		 * cpu-unbound and set DISASSOCIATED.  Before this, all workers
 		 * except for the ones which are still executing works from
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
@@ -4506,7 +4505,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->manager_mutex);
+		mutex_unlock(&pool->bind_mutex);
 
 		/*
 		 * Call schedule() so that we cross rq->lock and thus can
@@ -4547,7 +4546,7 @@ static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->bind_mutex);
 
 	/*
 	 * Restore CPU affinity of all workers.  As all idle workers should
@@ -4615,7 +4614,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 	static cpumask_t cpumask;
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->bind_mutex);
 
 	/* is @cpu allowed for @pool? */
 	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
@@ -4660,7 +4659,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		mutex_lock(&wq_pool_mutex);
 
 		for_each_pool(pool, pi) {
-			mutex_lock(&pool->manager_mutex);
+			mutex_lock(&pool->bind_mutex);
 
 			if (pool->cpu == cpu) {
 				spin_lock_irq(&pool->lock);
@@ -4672,7 +4671,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 				restore_unbound_workers_cpumask(pool, cpu);
 			}
 
-			mutex_unlock(&pool->manager_mutex);
+			mutex_unlock(&pool->bind_mutex);
 		}
 
 		/* update NUMA affinity of unbound workqueues */
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7bff111..50f2a3a 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -37,7 +37,7 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
-	struct list_head	bind_entry;	/* M: bound with the pool */
+	struct list_head	bind_entry;	/* B: bound with the pool */
 
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.7.4.4

