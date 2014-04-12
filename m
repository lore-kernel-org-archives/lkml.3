Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbaDLKnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:43:09 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51779 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756085AbaDLKmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176930"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] workqueue: generic framework to manage normal&rescuer workers' cpumask
Date: Sat, 12 Apr 2014 18:45:31 +0800
Message-ID: <1397299543-12012-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a worker's cpumask need to be kept co-ordinate with the pool
during cpu-hotpug, we add this worker to a special set which
will be used to manage workers' cpumask.

This special set is worker_idr currently and it serves for normal workers only.
But we can't add rescuer to this set due to we can't allocate id from
worker_idr for rescuers. We need to introduce a new set(bind_list).

When the rescuer adds itself to bind_list. it needs some synchronization.
but we can't re-use manager_mutex due to manager_mutex has dependency
to memory allocation. So we introduce a new mutex - bind_mutex.

Now restore_workers_cpumask() also restore rescuers' cpumask via bind_list.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |  129 +++++++++++++++++++------------------------
 kernel/workqueue_internal.h |    1 +
 2 files changed, 57 insertions(+), 73 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b56730..743917d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -135,6 +135,8 @@ enum {
  * WR: wq->mutex protected for writes.  Sched-RCU protected for reads.
  *
  * MD: wq_mayday_lock protected.
+ *
+ * B:  pool->bind_mutex protected.
  */
 
 /* struct worker is defined in workqueue_internal.h */
@@ -165,6 +167,17 @@ struct worker_pool {
 	struct mutex		manager_mutex;	/* manager exclusion */
 	struct idr		worker_idr;	/* MG: worker IDs and iteration */
 
+	/*
+	 * A worker is bound to the pool, it means:
+	 * 1) the worker's cpumask is bound to the pool.
+	 *
+	 * bind_mutex is held in rescuer before processing works,
+	 * so bind_mutex shouldn't have any directly nor indirecty dependency
+	 * to sleepable-memory-allocation.
+	 */
+	struct mutex		bind_mutex;	/* workers binding */
+	struct list_head	bind_list;	/* B: bound workers*/
+
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
 	int			refcnt;		/* PL: refcnt for unbound pools */
@@ -1625,70 +1638,6 @@ static void worker_leave_idle(struct worker *worker)
 	list_del_init(&worker->entry);
 }
 
-/**
- * worker_maybe_bind_and_lock - try to bind %current to worker_pool and lock it
- * @pool: target worker_pool
- *
- * Bind %current to the cpu of @pool if it is associated and lock @pool.
- *
- * Works which are scheduled while the cpu is online must at least be
- * scheduled to a worker which is bound to the cpu so that if they are
- * flushed from cpu callbacks while cpu is going down, they are
- * guaranteed to execute on the cpu.
- *
- * This function is to be used by unbound workers and rescuers to bind
- * themselves to the target cpu and may race with cpu going down or
- * coming online.  kthread_bind() can't be used because it may put the
- * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
- * verbatim as it's best effort and blocking and pool may be
- * [dis]associated in the meantime.
- *
- * This function tries set_cpus_allowed() and locks pool and verifies the
- * binding against %POOL_DISASSOCIATED which is set during
- * %CPU_DOWN_PREPARE and cleared during %CPU_ONLINE, so if the worker
- * enters idle state or fetches works without dropping lock, it can
- * guarantee the scheduling requirement described in the first paragraph.
- *
- * CONTEXT:
- * Might sleep.  Called without any lock but returns with pool->lock
- * held.
- *
- * Return:
- * %true if the associated pool is online (@worker is successfully
- * bound), %false if offline.
- */
-static bool worker_maybe_bind_and_lock(struct worker_pool *pool)
-__acquires(&pool->lock)
-{
-	while (true) {
-		/*
-		 * The following call may fail, succeed or succeed
-		 * without actually migrating the task to the cpu if
-		 * it races with cpu hotunplug operation.  Verify
-		 * against POOL_DISASSOCIATED.
-		 */
-		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(current, pool->attrs->cpumask);
-
-		spin_lock_irq(&pool->lock);
-		if (pool->flags & POOL_DISASSOCIATED)
-			return false;
-		if (task_cpu(current) == pool->cpu &&
-		    cpumask_equal(&current->cpus_allowed, pool->attrs->cpumask))
-			return true;
-		spin_unlock_irq(&pool->lock);
-
-		/*
-		 * We've raced with CPU hot[un]plug.  Give it a breather
-		 * and retry migration.  cond_resched() is required here;
-		 * otherwise, we might deadlock against cpu_stop trying to
-		 * bring down the CPU on non-preemptive kernel.
-		 */
-		cpu_relax();
-		cond_resched();
-	}
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -1697,12 +1646,33 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+		INIT_LIST_HEAD(&worker->bind_entry);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
 	return worker;
 }
 
+static void bind_worker(struct worker *worker, struct worker_pool *pool)
+{
+	mutex_lock(&pool->bind_mutex);
+	list_add(&worker->bind_entry, &pool->bind_list);
+	/*
+	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
+	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
+	 */
+	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+	mutex_unlock(&pool->bind_mutex);
+}
+
+
+static void unbind_worker(struct worker *worker, struct worker_pool *pool)
+{
+	mutex_lock(&pool->bind_mutex);
+	list_del(&worker->bind_entry);
+	mutex_unlock(&pool->bind_mutex);
+}
+
 /**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
@@ -1762,11 +1732,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
-	/*
-	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
-	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
-	 */
-	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+	bind_worker(worker, pool);
 
 	/*
 	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
@@ -2325,6 +2291,8 @@ woke_up:
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
 		worker->task->flags &= ~PF_WQ_WORKER;
+
+		unbind_worker(worker, pool);
 		return 0;
 	}
 
@@ -2447,9 +2415,9 @@ repeat:
 		spin_unlock_irq(&wq_mayday_lock);
 
 		/* migrate to the target cpu if possible */
-		worker_maybe_bind_and_lock(pool);
+		bind_worker(rescuer, pool);
+		spin_lock_irq(&pool->lock);
 		rescuer->pool = pool;
-		put_unbound_pwq(pwq);
 
 		/*
 		 * Slurp in all works issued via this workqueue and
@@ -2470,6 +2438,17 @@ repeat:
 		if (keep_working(pool))
 			wake_up_worker(pool);
 
+		spin_unlock_irq(&pool->lock);
+
+		/*
+		 * We still hold an indrectly reference(via pwq) to the pool.
+		 * So the pool can't be destroyed even all works had been
+		 * processed.
+		 */
+		unbind_worker(rescuer, pool);
+
+		spin_lock_irq(&pool->lock);
+		put_unbound_pwq(pwq);
 		rescuer->pool = NULL;
 		spin_unlock(&pool->lock);
 		spin_lock(&wq_mayday_lock);
@@ -3548,6 +3527,9 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
 
+	mutex_init(&pool->bind_mutex);
+	INIT_LIST_HEAD(&pool->bind_list);
+
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
 
@@ -4711,7 +4693,6 @@ static void restore_workers_cpumask(struct worker_pool *pool, int cpu)
 {
 	static cpumask_t cpumask;
 	struct worker *worker;
-	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -4724,10 +4705,12 @@ static void restore_workers_cpumask(struct worker_pool *pool, int cpu)
 	if (cpumask_weight(&cpumask) != 1)
 		return;
 
+	mutex_lock(&pool->bind_mutex);
 	/* as we're called from CPU_ONLINE, the following shouldn't fail */
-	for_each_pool_worker(worker, wi, pool)
+	list_for_each_entry(worker, &pool->bind_list, bind_entry)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
+	mutex_unlock(&pool->bind_mutex);
 }
 
 /*
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7e2204d..50f2a3a 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -37,6 +37,7 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
+	struct list_head	bind_entry;	/* B: bound with the pool */
 
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.7.4.4

