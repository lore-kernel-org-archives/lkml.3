Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab3AQBnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:19 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35981 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab3AQBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:16 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/17] workqueue: replace for_each_worker_pool() with for_each_std_worker_pool()
Date: Wed, 16 Jan 2013 17:42:45 -0800
Message-Id: <1358386969-945-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_std_worker_pool() takes @cpu instead of @gcwq.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 766ca67..81f041f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -277,9 +277,9 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
-#define for_each_worker_pool(pool, gcwq)				\
-	for ((pool) = &(gcwq)->pools[0];				\
-	     (pool) < &(gcwq)->pools[NR_STD_WORKER_POOLS]; (pool)++)
+#define for_each_std_worker_pool(pool, cpu)				\
+	for ((pool) = &get_gcwq((cpu))->pools[0];			\
+	     (pool) < &get_gcwq((cpu))->pools[NR_STD_WORKER_POOLS]; (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, pool)			\
 	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
@@ -3509,14 +3509,14 @@ EXPORT_SYMBOL_GPL(work_busy);
 
 static void gcwq_unbind_fn(struct work_struct *work)
 {
-	struct global_cwq *gcwq = get_gcwq(smp_processor_id());
+	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
 	struct hlist_node *pos;
 	int i;
 
-	for_each_worker_pool(pool, gcwq) {
-		BUG_ON(pool->cpu != smp_processor_id());
+	for_each_std_worker_pool(pool, cpu) {
+		BUG_ON(cpu != smp_processor_id());
 
 		mutex_lock(&pool->assoc_mutex);
 		spin_lock_irq(&pool->lock);
@@ -3550,15 +3550,15 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	/*
 	 * Sched callbacks are disabled now.  Zap nr_running.  After this,
 	 * nr_running stays zero and need_more_worker() and keep_working()
-	 * are always true as long as the worklist is not empty.  @gcwq now
-	 * behaves as unbound (in terms of concurrency management) gcwq
-	 * which is served by workers tied to the CPU.
+	 * are always true as long as the worklist is not empty.  Pools on
+	 * @cpu now behave as unbound (in terms of concurrency management)
+	 * pools which are served by workers tied to the CPU.
 	 *
 	 * On return from this function, the current worker would trigger
 	 * unbound chain execution of pending work items if other workers
 	 * didn't already.
 	 */
-	for_each_worker_pool(pool, gcwq)
+	for_each_std_worker_pool(pool, cpu)
 		atomic_set(get_pool_nr_running(pool), 0);
 }
 
@@ -3571,12 +3571,11 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct worker_pool *pool;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		for_each_worker_pool(pool, gcwq) {
+		for_each_std_worker_pool(pool, cpu) {
 			struct worker *worker;
 
 			if (pool->nr_workers)
@@ -3594,7 +3593,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		for_each_worker_pool(pool, gcwq) {
+		for_each_std_worker_pool(pool, cpu) {
 			mutex_lock(&pool->assoc_mutex);
 			spin_lock_irq(&pool->lock);
 
@@ -3691,11 +3690,10 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	for_each_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		for_each_worker_pool(pool, gcwq) {
+		for_each_std_worker_pool(pool, cpu) {
 			spin_lock_irq(&pool->lock);
 
 			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
@@ -3781,11 +3779,10 @@ void thaw_workqueues(void)
 		goto out_unlock;
 
 	for_each_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		for_each_worker_pool(pool, gcwq) {
+		for_each_std_worker_pool(pool, cpu) {
 			spin_lock_irq(&pool->lock);
 
 			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
@@ -3827,11 +3824,10 @@ static int __init init_workqueues(void)
 
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 
-		for_each_worker_pool(pool, gcwq) {
-			pool->gcwq = gcwq;
+		for_each_std_worker_pool(pool, cpu) {
+			pool->gcwq = get_gcwq(cpu);
 			spin_lock_init(&pool->lock);
 			pool->cpu = cpu;
 			pool->flags |= POOL_DISASSOCIATED;
@@ -3856,10 +3852,9 @@ static int __init init_workqueues(void)
 
 	/* create the initial worker */
 	for_each_online_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 
-		for_each_worker_pool(pool, gcwq) {
+		for_each_std_worker_pool(pool, cpu) {
 			struct worker *worker;
 
 			if (cpu != WORK_CPU_UNBOUND)
-- 
1.8.0.2

