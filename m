Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaETJnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:43:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63309 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461AbaETJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:43:02 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762584"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 05/10] workqueue: separate iteration role from worker_idr
Date: Tue, 20 May 2014 17:46:31 +0800
Message-ID: <1400579204-3647-6-git-send-email-laijs@cn.fujitsu.com>
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

worker_idr has the iteration (iterating for attached workers) and worker ID
duties. These two duties are not necessarily tied together. We can separate
them and use a list for tracking attached workers and iteration.

Before this separation, it is not possible to add rescuer workers
to worker_idr due to rescuer workers can't allocate ID in run-time. (Because
ID-allocation depends on memory-allocation. Rescuer rescues the world
when memory is insufficient, so it must avoid to allocate memory.)

After separation, we can easily add the rescuer workers to the list for
iteration without any memory-allocation. It is required when we attach
the rescuer worker to the pool in later patch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   28 +++++++++++++++-------------
 kernel/workqueue_internal.h |    2 ++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1236544..fd2f265 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -161,7 +161,8 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* M: worker IDs and iteration */
+	struct idr		worker_idr;	/* M: worker IDs */
+	struct list_head	workers;	/* M: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
@@ -363,7 +364,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 /**
  * for_each_pool_worker - iterate through all workers of a worker_pool
  * @worker: iteration cursor
- * @wi: integer used for iteration
  * @pool: worker_pool to iterate workers of
  *
  * This must be called with @pool->manager_mutex.
@@ -371,8 +371,8 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
-#define for_each_pool_worker(worker, wi, pool)				\
-	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
+#define for_each_pool_worker(worker, pool)				\
+	list_for_each_entry((worker), &(pool)->workers, node)		\
 		if (({ lockdep_assert_held(&pool->manager_mutex); false; })) { } \
 		else
 
@@ -1674,6 +1674,7 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+		INIT_LIST_HEAD(&worker->node);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
@@ -1696,7 +1697,8 @@ static void worker_detach_from_pool(struct worker *worker,
 
 	mutex_lock(&pool->manager_mutex);
 	idr_remove(&pool->worker_idr, worker->id);
-	if (idr_is_empty(&pool->worker_idr))
+	list_del(&worker->node);
+	if (list_empty(&pool->workers))
 		detach_completion = pool->detach_completion;
 	mutex_unlock(&pool->manager_mutex);
 
@@ -1772,6 +1774,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	/* successful, commit the pointer to idr */
 	idr_replace(&pool->worker_idr, worker, worker->id);
+	/* successful, attach the worker to the pool */
+	list_add_tail(&worker->node, &pool->workers);
 
 	return worker;
 
@@ -3483,6 +3487,7 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
+	INIT_LIST_HEAD(&pool->workers);
 
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3548,7 +3553,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	spin_unlock_irq(&pool->lock);
 
 	mutex_lock(&pool->manager_mutex);
-	if (!idr_is_empty(&pool->worker_idr))
+	if (!list_empty(&pool->workers))
 		pool->detach_completion = &detach_completion;
 	mutex_unlock(&pool->manager_mutex);
 
@@ -4533,7 +4538,6 @@ static void wq_unbind_fn(struct work_struct *work)
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
-	int wi;
 
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
@@ -4548,7 +4552,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		for_each_pool_worker(worker, wi, pool)
+		for_each_pool_worker(worker, pool)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
@@ -4594,7 +4598,6 @@ static void wq_unbind_fn(struct work_struct *work)
 static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker;
-	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -4605,13 +4608,13 @@ static void rebind_workers(struct worker_pool *pool)
 	 * of all workers first and then clear UNBOUND.  As we're called
 	 * from CPU_ONLINE, the following shouldn't fail.
 	 */
-	for_each_pool_worker(worker, wi, pool)
+	for_each_pool_worker(worker, pool)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
 
 	spin_lock_irq(&pool->lock);
 
-	for_each_pool_worker(worker, wi, pool) {
+	for_each_pool_worker(worker, pool) {
 		unsigned int worker_flags = worker->flags;
 
 		/*
@@ -4663,7 +4666,6 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 {
 	static cpumask_t cpumask;
 	struct worker *worker;
-	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -4677,7 +4679,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 		return;
 
 	/* as we're called from CPU_ONLINE, the following shouldn't fail */
-	for_each_pool_worker(worker, wi, pool)
+	for_each_pool_worker(worker, pool)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
 }
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7e2204d..8888e06 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -37,6 +37,8 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
+	struct list_head	node;		/* M: anchored at pool->workers */
+						/* M: runs through worker->node */
 
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.7.4.4

