Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaDLKmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:42:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11381 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511AbaDLKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176918"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] workqueue: generic routine to restore percpu/unbound pools' workers' cpumask
Date: Sat, 12 Apr 2014 18:45:30 +0800
Message-ID: <1397299543-12012-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses different routines to restore the cpumask of workers of
percpu&unbound pools.

unbound pools - restore_unbound_workers_cpumask()
percpu pools - rebind_workers()

Actually, restore_unbound_workers_cpumask() can be used for percpu pools.
if percpu_pool->cpu != cpu, restore_unbound_workers_cpumask() will returns at
the first if-branch. if percpu_pool->cpu == cpu, restore_unbound_workers_cpumask()
will call set_cpus_allowed_ptr() for all of its workers.

So we can use restore_unbound_workers_cpumask() for both kinds of pools.

The patch rename restore_unbound_workers_cpumask() to restore_workers_cpumask()
and use it for percpu pools. rebind_workers() will not restore cpumask,
so it is renamed to restore_workers_concurrency().

"pool->flags &= ~POOL_DISASSOCIATED" is also moved into
restore_workers_concurrency(), concurrency is restored atomically.

wq_unbind_fn() is rename to disable_workers_concurrency().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   46 +++++++++++++++-------------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d845bdd..0b56730 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2350,7 +2350,7 @@ recheck:
 	 * worker or that someone else has already assumed the manager
 	 * role.  This is where @worker starts participating in concurrency
 	 * management if applicable and concurrency management is restored
-	 * after being rebound.  See rebind_workers() for details.
+	 * after being rebound.  See restore_workers_concurrency() for details.
 	 */
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
@@ -4586,7 +4586,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
  * cpu comes back online.
  */
 
-static void wq_unbind_fn(struct work_struct *work)
+static void disable_workers_concurrency(struct work_struct *work)
 {
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
@@ -4644,30 +4644,20 @@ static void wq_unbind_fn(struct work_struct *work)
 }
 
 /**
- * rebind_workers - rebind all workers of a pool to the associated CPU
+ * restore_workers_concurrency - restore concurrency management of all workers
  * @pool: pool of interest
  *
- * @pool->cpu is coming online.  Rebind all workers to the CPU.
+ * @pool->cpu is coming online and all workers are alreaddy rebound to the CPU.
  */
-static void rebind_workers(struct worker_pool *pool)
+static void restore_workers_concurrency(struct worker_pool *pool)
 {
 	struct worker *worker;
 	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
 
-	/*
-	 * Restore CPU affinity of all workers.  As all idle workers should
-	 * be on the run-queue of the associated CPU before any local
-	 * wake-ups for concurrency management happen, restore CPU affinty
-	 * of all workers first and then clear UNBOUND.  As we're called
-	 * from CPU_ONLINE, the following shouldn't fail.
-	 */
-	for_each_pool_worker(worker, wi, pool)
-		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
-						  pool->attrs->cpumask) < 0);
-
 	spin_lock_irq(&pool->lock);
+	pool->flags &= ~POOL_DISASSOCIATED;
 
 	for_each_pool_worker(worker, wi, pool) {
 		unsigned int worker_flags = worker->flags;
@@ -4708,16 +4698,16 @@ static void rebind_workers(struct worker_pool *pool)
 }
 
 /**
- * restore_unbound_workers_cpumask - restore cpumask of unbound workers
- * @pool: unbound pool of interest
+ * restore_workers_cpumask - restore cpumask of workers
+ * @pool: pool of interest
  * @cpu: the CPU which is coming up
  *
- * An unbound pool may end up with a cpumask which doesn't have any online
- * CPUs.  When a worker of such pool get scheduled, the scheduler resets
+ * A pool may end up with a cpumask which doesn't have any online CPUS.
+ * When a worker of such pool get scheduled, the scheduler resets
  * its cpus_allowed.  If @cpu is in @pool's cpumask which didn't have any
  * online CPU before, cpus_allowed of all its workers should be restored.
  */
-static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
+static void restore_workers_cpumask(struct worker_pool *pool, int cpu)
 {
 	static cpumask_t cpumask;
 	struct worker *worker;
@@ -4769,16 +4759,10 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->manager_mutex);
+			restore_workers_cpumask(pool, cpu);
 
-			if (pool->cpu == cpu) {
-				spin_lock_irq(&pool->lock);
-				pool->flags &= ~POOL_DISASSOCIATED;
-				spin_unlock_irq(&pool->lock);
-
-				rebind_workers(pool);
-			} else if (pool->cpu < 0) {
-				restore_unbound_workers_cpumask(pool, cpu);
-			}
+			if (pool->cpu == cpu)
+				restore_workers_concurrency(pool);
 
 			mutex_unlock(&pool->manager_mutex);
 		}
@@ -4808,7 +4792,7 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		/* unbinding per-cpu workers should happen on the local CPU */
-		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
+		INIT_WORK_ONSTACK(&unbind_work, disable_workers_concurrency);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 
 		/* update NUMA affinity of unbound workqueues */
-- 
1.7.4.4

