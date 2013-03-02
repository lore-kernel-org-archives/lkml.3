Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3CBD3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:29:44 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:60701 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3CBDZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:01 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/31] workqueue: drop "std" from cpu_std_worker_pools and for_each_std_worker_pool()
Date: Fri,  1 Mar 2013 19:24:10 -0800
Message-Id: <1362194662-2344-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All per-cpu pools are standard, so there's no need to use both "cpu"
and "std" and for_each_std_worker_pool() is confusing in that it can
be used only for per-cpu pools.

* s/cpu_std_worker_pools/cpu_worker_pools/

* s/for_each_std_worker_pool()/for_each_cpu_worker_pool()/

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f7f627c..95a3dcc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -252,9 +252,9 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 			   lockdep_is_held(&workqueue_lock),		\
 			   "sched RCU or workqueue lock should be held")
 
-#define for_each_std_worker_pool(pool, cpu)				\
-	for ((pool) = &per_cpu(cpu_std_worker_pools, cpu)[0];		\
-	     (pool) < &per_cpu(cpu_std_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
+#define for_each_cpu_worker_pool(pool, cpu)				\
+	for ((pool) = &per_cpu(cpu_worker_pools, cpu)[0];		\
+	     (pool) < &per_cpu(cpu_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
 	     (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, pool)			\
@@ -416,7 +416,7 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  * POOL_DISASSOCIATED set, and their workers have WORKER_UNBOUND set.
  */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
-				     cpu_std_worker_pools);
+				     cpu_worker_pools);
 
 /*
  * idr of all pools.  Modifications are protected by workqueue_lock.  Read
@@ -3335,7 +3335,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			struct pool_workqueue *pwq =
 				per_cpu_ptr(wq->cpu_pwqs, cpu);
 			struct worker_pool *cpu_pools =
-				per_cpu(cpu_std_worker_pools, cpu);
+				per_cpu(cpu_worker_pools, cpu);
 
 			pwq->pool = &cpu_pools[highpri];
 			list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
@@ -3688,7 +3688,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	struct hlist_node *pos;
 	int i;
 
-	for_each_std_worker_pool(pool, cpu) {
+	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
 
 		mutex_lock(&pool->assoc_mutex);
@@ -3731,7 +3731,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	 * unbound chain execution of pending work items if other workers
 	 * didn't already.
 	 */
-	for_each_std_worker_pool(pool, cpu)
+	for_each_cpu_worker_pool(pool, cpu)
 		atomic_set(&pool->nr_running, 0);
 }
 
@@ -3748,7 +3748,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			struct worker *worker;
 
 			if (pool->nr_workers)
@@ -3766,7 +3766,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			mutex_lock(&pool->assoc_mutex);
 			spin_lock_irq(&pool->lock);
 
@@ -4006,7 +4006,7 @@ static int __init init_workqueues(void)
 		struct worker_pool *pool;
 
 		i = 0;
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			BUG_ON(init_worker_pool(pool));
 			pool->cpu = cpu;
 			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
@@ -4021,7 +4021,7 @@ static int __init init_workqueues(void)
 	for_each_online_cpu(cpu) {
 		struct worker_pool *pool;
 
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			struct worker *worker;
 
 			pool->flags &= ~POOL_DISASSOCIATED;
-- 
1.8.1.2

