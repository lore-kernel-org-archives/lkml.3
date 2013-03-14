Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3CNXB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:01:57 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65292 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3CNXBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] workqueue: restore CPU affinity of unbound workers on CPU_ONLINE
Date: Thu, 14 Mar 2013 16:01:30 -0700
Message-Id: <1363302090-16117-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent addition of the custom attributes support, unbound
pools may have allowed cpumask which isn't full.  As long as some of
CPUs in the cpumask are online, its workers will maintain cpus_allowed
as set on worker creation; however, once no online CPU is left in
cpus_allowed, the scheduler will reset cpus_allowed of any workers
which get scheduled so that they can execute.

To remain compliant to the user-specified configuration, CPU affinity
needs to be restored when a CPU becomes online for an unbound pool
which doesn't currently have any online CPUs before.

This patch implement restore_unbound_workers_cpumask(), which is
called from CPU_ONLINE for all unbound pools, checks whether the
coming up CPU is the first allowed online one, and, if so, invokes
set_cpus_allowed_ptr() with the configured cpumask on all workers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9508b5e..e38d035 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4131,6 +4131,39 @@ static void rebind_workers(struct worker_pool *pool)
 	spin_unlock_irq(&pool->lock);
 }
 
+/**
+ * restore_unbound_workers_cpumask - restore cpumask of unbound workers
+ * @pool: unbound pool of interest
+ * @cpu: the CPU which is coming up
+ *
+ * An unbound pool may end up with a cpumask which doesn't have any online
+ * CPUs.  When a worker of such pool get scheduled, the scheduler resets
+ * its cpus_allowed.  If @cpu is in @pool's cpumask which didn't have any
+ * online CPU before, cpus_allowed of all its workers should be restored.
+ */
+static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
+{
+	static cpumask_t cpumask;
+	struct worker *worker;
+	int wi;
+
+	lockdep_assert_held(&pool->manager_mutex);
+
+	/* is @cpu allowed for @pool? */
+	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
+		return;
+
+	/* is @cpu the only online CPU? */
+	cpumask_and(&cpumask, pool->attrs->cpumask, cpu_online_mask);
+	if (cpumask_weight(&cpumask) != 1)
+		return;
+
+	/* as we're called from CPU_ONLINE, the following shouldn't fail */
+	for_each_pool_worker(worker, wi, pool)
+		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
+						  pool->attrs->cpumask) < 0);
+}
+
 /*
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
@@ -4141,6 +4174,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 {
 	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
+	int pi;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
@@ -4154,17 +4188,25 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		for_each_cpu_worker_pool(pool, cpu) {
+		mutex_lock(&wq_mutex);
+
+		for_each_pool(pool, pi) {
 			mutex_lock(&pool->manager_mutex);
 
-			spin_lock_irq(&pool->lock);
-			pool->flags &= ~POOL_DISASSOCIATED;
-			spin_unlock_irq(&pool->lock);
+			if (pool->cpu == cpu) {
+				spin_lock_irq(&pool->lock);
+				pool->flags &= ~POOL_DISASSOCIATED;
+				spin_unlock_irq(&pool->lock);
 
-			rebind_workers(pool);
+				rebind_workers(pool);
+			} else if (pool->cpu < 0) {
+				restore_unbound_workers_cpumask(pool, cpu);
+			}
 
 			mutex_unlock(&pool->manager_mutex);
 		}
+
+		mutex_unlock(&wq_mutex);
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.8.1.4

