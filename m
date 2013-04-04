Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab3DDCGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:06:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932907Ab3DDCF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:05:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998071"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/7] workqueue: simplify workqueue_cpu_up_callback(CPU_ONLINE)
Date: Thu, 4 Apr 2013 10:05:35 +0800
Message-Id: <1365041143-3088-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:57,
	Serialize complete at 2013/04/04 10:04:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have 4096 CPUs, workqueue_cpu_up_callback() will travel too much CPUs,
to avoid it, we use for_each_cpu_worker_pool() for the cpu pools and
use for_each_unbound_pool() for unbound pools.

After it, for_each_pool() becomes unused, but we keep it for future
possible usage.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   53 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b4369de..a383eaf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -354,6 +354,23 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 		else
 
 /**
+ * for_each_unbound_pool - iterate through all unbound worker_pools in the system
+ * @pool: iteration cursor
+ * @bkt: bucket (of integer) used for iteration
+ *
+ * This must be called either with wq_pool_mutex held or sched RCU read
+ * locked.  If the pool needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pool stays online.
+ *
+ * The if/else clause exists only for the lockdep assertion and can be
+ * ignored.
+ */
+#define for_each_unbound_pool(pool, bkt)				\
+	hash_for_each(unbound_pool_hash, bkt, pool, hash_node)		\
+		if (({ assert_rcu_or_pool_mutex(); false; })) { }	\
+		else
+
+/**
  * for_each_pool_worker - iterate through all workers of a worker_pool
  * @worker: iteration cursor
  * @wi: integer used for iteration
@@ -4442,7 +4459,7 @@ static void associate_cpu_pool(struct worker_pool *pool)
 	struct worker *worker;
 	int wi;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	mutex_lock(&pool->manager_mutex);
 
 	/*
 	 * Restore CPU affinity of all workers.  As all idle workers should
@@ -4454,7 +4471,7 @@ static void associate_cpu_pool(struct worker_pool *pool)
 	for_each_pool_worker(worker, wi, pool)
 		if (WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 				pool->attrs->cpumask) < 0))
-			return;
+			goto out_unlock;
 
 	spin_lock_irq(&pool->lock);
 
@@ -4495,6 +4512,9 @@ static void associate_cpu_pool(struct worker_pool *pool)
 
 	pool->flags &= ~POOL_DISASSOCIATED;
 	spin_unlock_irq(&pool->lock);
+
+out_unlock:
+	mutex_unlock(&pool->manager_mutex);
 }
 
 /**
@@ -4509,25 +4529,28 @@ static void associate_cpu_pool(struct worker_pool *pool)
  */
 static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 {
-	static cpumask_t cpumask;
+	static cpumask_t cpumask; /* protected by wq_pool_mutex */
 	struct worker *worker;
 	int wi;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	mutex_lock(&pool->manager_mutex);
 
 	/* is @cpu allowed for @pool? */
 	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
-		return;
+		goto out_unlock;
 
 	/* is @cpu the only online CPU? */
 	cpumask_and(&cpumask, pool->attrs->cpumask, cpu_online_mask);
 	if (cpumask_weight(&cpumask) != 1)
-		return;
+		goto out_unlock;
 
 	/* as we're called from CPU_ONLINE, the following shouldn't fail */
 	for_each_pool_worker(worker, wi, pool)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
+
+out_unlock:
+	mutex_unlock(&pool->manager_mutex);
 }
 
 /*
@@ -4541,7 +4564,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
 	struct workqueue_struct *wq;
-	int pi;
+	int bkt;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
@@ -4555,19 +4578,13 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		mutex_lock(&wq_pool_mutex);
+		for_each_cpu_worker_pool(pool, cpu)
+			associate_cpu_pool(pool);
 
-		for_each_pool(pool, pi) {
-			mutex_lock(&pool->manager_mutex);
-
-			if (pool->cpu == cpu) {
-				associate_cpu_pool(pool);
-			} else if (pool->cpu < 0) {
-				restore_unbound_workers_cpumask(pool, cpu);
-			}
+		mutex_lock(&wq_pool_mutex);
 
-			mutex_unlock(&pool->manager_mutex);
-		}
+		for_each_unbound_pool(pool, bkt)
+			restore_unbound_workers_cpumask(pool, cpu);
 
 		/* update NUMA affinity of unbound workqueues */
 		list_for_each_entry(wq, &workqueues, list)
-- 
1.7.7.6

