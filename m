Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaETJnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:43:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63309 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752979AbaETJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:43:09 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762590"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 08/10] workqueue: rename manager_mutex to attach_mutex
Date: Tue, 20 May 2014 17:46:34 +0800
Message-ID: <1400579204-3647-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

manager_mutex is only used to protect the attaching for the pool
and the pool->workers list. It protects the pool->workers and operations
based on this list, such as:
	cpu-binding for the workers in the pool->workers
	the operations to set/clear WORKER_UNBOUND

So we can simply rename manager_mutex to attach_mutex without any
functionality changed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   44 +++++++++++++++++++++---------------------
 kernel/workqueue_internal.h |    4 +-
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4ae6a3c..728b515 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -65,7 +65,7 @@ enum {
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
-	 * manager_mutex to avoid changing binding state while
+	 * attach_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
@@ -122,7 +122,7 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * M: pool->manager_mutex protected.
+ * A: pool->attach_mutex protected.
  *
  * PL: wq_pool_mutex protected.
  *
@@ -160,8 +160,8 @@ struct worker_pool {
 
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
-	struct mutex		manager_mutex;	/* manager exclusion */
-	struct list_head	workers;	/* M: attached workers */
+	struct mutex		attach_mutex;	/* attach/detach exclusion */
+	struct list_head	workers;	/* A: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
 
 	struct ida		worker_ida;	/* worker IDs for task name */
@@ -367,14 +367,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @worker: iteration cursor
  * @pool: worker_pool to iterate workers of
  *
- * This must be called with @pool->manager_mutex.
+ * This must be called with @pool->attach_mutex.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool_worker(worker, pool)				\
 	list_for_each_entry((worker), &(pool)->workers, node)		\
-		if (({ lockdep_assert_held(&pool->manager_mutex); false; })) { } \
+		if (({ lockdep_assert_held(&pool->attach_mutex); false; })) { } \
 		else
 
 /**
@@ -1696,11 +1696,11 @@ static void worker_detach_from_pool(struct worker *worker,
 {
 	struct completion *detach_completion = NULL;
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->attach_mutex);
 	list_del(&worker->node);
 	if (list_empty(&pool->workers))
 		detach_completion = pool->detach_completion;
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->attach_mutex);
 
 	if (detach_completion)
 		complete(detach_completion);
@@ -1753,7 +1753,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->attach_mutex);
 
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
@@ -1762,7 +1762,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * The pool->manager_mutex ensures %POOL_DISASSOCIATED
+	 * The pool->attach_mutex ensures %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
 	 * flag definition for details.
 	 */
@@ -1772,7 +1772,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* successful, attach the worker to the pool */
 	list_add_tail(&worker->node, &pool->workers);
 
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->attach_mutex);
 
 	return worker;
 
@@ -3456,7 +3456,7 @@ static int init_worker_pool(struct worker_pool *pool)
 		    (unsigned long)pool);
 
 	mutex_init(&pool->manager_arb);
-	mutex_init(&pool->manager_mutex);
+	mutex_init(&pool->attach_mutex);
 	INIT_LIST_HEAD(&pool->workers);
 
 	ida_init(&pool->worker_ida);
@@ -3513,7 +3513,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
 	 * manager_arb prevents @pool's workers from blocking on
-	 * manager_mutex.
+	 * attach_mutex.
 	 */
 	mutex_lock(&pool->manager_arb);
 
@@ -3523,10 +3523,10 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
 
-	mutex_lock(&pool->manager_mutex);
+	mutex_lock(&pool->attach_mutex);
 	if (!list_empty(&pool->workers))
 		pool->detach_completion = &detach_completion;
-	mutex_unlock(&pool->manager_mutex);
+	mutex_unlock(&pool->attach_mutex);
 
 	if (pool->detach_completion)
 		wait_for_completion(pool->detach_completion);
@@ -4513,11 +4513,11 @@ static void wq_unbind_fn(struct work_struct *work)
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
 
-		mutex_lock(&pool->manager_mutex);
+		mutex_lock(&pool->attach_mutex);
 		spin_lock_irq(&pool->lock);
 
 		/*
-		 * We've blocked all manager operations.  Make all workers
+		 * We've blocked all attach/detach operations. Make all workers
 		 * unbound and set DISASSOCIATED.  Before this, all workers
 		 * except for the ones which are still executing works from
 		 * before the last CPU down must be on the cpu.  After
@@ -4529,7 +4529,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->manager_mutex);
+		mutex_unlock(&pool->attach_mutex);
 
 		/*
 		 * Call schedule() so that we cross rq->lock and thus can
@@ -4570,7 +4570,7 @@ static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->attach_mutex);
 
 	/*
 	 * Restore CPU affinity of all workers.  As all idle workers should
@@ -4638,7 +4638,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 	static cpumask_t cpumask;
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->attach_mutex);
 
 	/* is @cpu allowed for @pool? */
 	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
@@ -4683,7 +4683,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		mutex_lock(&wq_pool_mutex);
 
 		for_each_pool(pool, pi) {
-			mutex_lock(&pool->manager_mutex);
+			mutex_lock(&pool->attach_mutex);
 
 			if (pool->cpu == cpu) {
 				spin_lock_irq(&pool->lock);
@@ -4695,7 +4695,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 				restore_unbound_workers_cpumask(pool, cpu);
 			}
 
-			mutex_unlock(&pool->manager_mutex);
+			mutex_unlock(&pool->attach_mutex);
 		}
 
 		/* update NUMA affinity of unbound workqueues */
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 8888e06..4521587 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -37,8 +37,8 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
-	struct list_head	node;		/* M: anchored at pool->workers */
-						/* M: runs through worker->node */
+	struct list_head	node;		/* A: anchored at pool->workers */
+						/* A: runs through worker->node */
 
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.7.4.4

