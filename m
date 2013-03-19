Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab3CST3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933698Ab3CST3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:03 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904512"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 17/21] workqueue: simplify workqueue_cpu_up_callback(CPU_ONLINE)
Date: Wed, 20 Mar 2013 03:28:17 +0800
Message-Id: <1363721306-2030-18-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:37,
	Serialize complete at 2013/03/20 03:27:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have 4096 CPUs, workqueue_cpu_up_callback() will travel too much CPUs,
to avoid it, we use for_each_cpu_worker_pool for the cpu pools and
use unbound_pool_hash for unbound pools.

After it, for_each_pool() becomes unused, so we remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   55 +++++++++++++++++-----------------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 29c5baa..21ef721 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -317,23 +317,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 	     (pool)++)
 
 /**
- * for_each_pool - iterate through all worker_pools in the system
- * @pool: iteration cursor
- * @pi: integer used for iteration
- *
- * This must be called either with pools_mutex held or sched RCU read locked.
- * If the pool needs to be used beyond the locking in effect, the caller is
- * responsible for guaranteeing that the pool stays online.
- *
- * The if/else clause exists only for the lockdep assertion and can be
- * ignored.
- */
-#define for_each_pool(pool, pi)						\
-	idr_for_each_entry(&worker_pool_idr, pool, pi)			\
-		if (({ assert_rcu_or_pools_mutex(); false; })) { }		\
-		else
-
-/**
  * for_each_pool_worker - iterate through all workers of a worker_pool
  * @worker: iteration cursor
  * @wi: integer used for iteration
@@ -4011,7 +3994,7 @@ static void associate_cpu_pool(struct worker_pool *pool)
 	struct worker *worker;
 	int wi;
 
-	lockdep_assert_held(&pool->manager_mutex);
+	mutex_lock(&pool->manager_mutex);
 
 	/*
 	 * Restore CPU affinity of all workers.  As all idle workers should
@@ -4023,7 +4006,7 @@ static void associate_cpu_pool(struct worker_pool *pool)
 	for_each_pool_worker(worker, wi, pool)
 		if (WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 				pool->attrs->cpumask) < 0))
-			return;
+			goto out_unlock;
 
 	spin_lock_irq(&pool->lock);
 
@@ -4064,6 +4047,9 @@ static void associate_cpu_pool(struct worker_pool *pool)
 
 	pool->flags &= ~POOL_DISASSOCIATED;
 	spin_unlock_irq(&pool->lock);
+
+out_unlock:
+	mutex_unlock(&pool->manager_mutex);
 }
 
 /**
@@ -4078,25 +4064,28 @@ static void associate_cpu_pool(struct worker_pool *pool)
  */
 static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 {
-	static cpumask_t cpumask;
+	static cpumask_t cpumask; /* protected by pools_mutex */
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
@@ -4109,7 +4098,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 {
 	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
-	int pi;
+	int bkt;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
@@ -4123,20 +4112,12 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		mutex_lock(&pools_mutex);
-
-		for_each_pool(pool, pi) {
-			mutex_lock(&pool->manager_mutex);
-
-			if (pool->cpu == cpu) {
-				associate_cpu_pool(pool);
-			} else if (pool->cpu < 0) {
-				restore_unbound_workers_cpumask(pool, cpu);
-			}
-
-			mutex_unlock(&pool->manager_mutex);
-		}
+		for_each_cpu_worker_pool(pool, cpu)
+			associate_cpu_pool(pool);
 
+		mutex_lock(&pools_mutex);
+		hash_for_each(unbound_pool_hash, bkt, pool, hash_node)
+			restore_unbound_workers_cpumask(pool, cpu);
 		mutex_unlock(&pools_mutex);
 		break;
 	}
-- 
1.7.7.6

