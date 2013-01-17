Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3AQBp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:45:28 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33472 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3AQBnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:08 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/17] workqueue: move global_cwq->cpu to worker_pool
Date: Wed, 16 Jan 2013 17:42:41 -0800
Message-Id: <1358386969-945-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move gcwq->cpu to pool->cpu.  This introduces a couple places where
gcwq->pools[0].cpu is used.  These will soon go away as gcwq is
further reduced.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/trace/events/workqueue.h |  2 +-
 kernel/workqueue.c               | 42 ++++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index f28d1b6..4e798e3 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -54,7 +54,7 @@ TRACE_EVENT(workqueue_queue_work,
 		__entry->function	= work->func;
 		__entry->workqueue	= cwq->wq;
 		__entry->req_cpu	= req_cpu;
-		__entry->cpu		= cwq->pool->gcwq->cpu;
+		__entry->cpu		= cwq->pool->cpu;
 	),
 
 	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 092d14aa..1720da7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -151,6 +151,7 @@ struct worker {
 
 struct worker_pool {
 	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+	unsigned int		cpu;		/* I: the associated cpu */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
@@ -179,7 +180,6 @@ struct worker_pool {
  */
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
-	unsigned int		cpu;		/* I: the associated cpu */
 
 	struct worker_pool	pools[NR_STD_WORKER_POOLS];
 						/* normal and highpri pools */
@@ -516,7 +516,7 @@ static struct worker_pool *worker_pool_by_id(int pool_id)
 
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
-	int cpu = pool->gcwq->cpu;
+	int cpu = pool->cpu;
 	int idx = std_worker_pool_pri(pool);
 
 	if (cpu != WORK_CPU_UNBOUND)
@@ -791,7 +791,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 	struct worker *worker = kthread_data(task);
 
 	if (!(worker->flags & WORKER_NOT_RUNNING)) {
-		WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
+		WARN_ON_ONCE(worker->pool->cpu != cpu);
 		atomic_inc(get_pool_nr_running(worker->pool));
 	}
 }
@@ -1297,7 +1297,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	}
 
 	/* gcwq determined, get cwq and queue */
-	cwq = get_cwq(gcwq->cpu, wq);
+	cwq = get_cwq(gcwq->pools[0].cpu, wq);
 	trace_workqueue_queue_work(req_cpu, cwq, work);
 
 	if (WARN_ON(!list_empty(&work->entry))) {
@@ -1404,20 +1404,20 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
 	/*
 	 * This stores cwq for the moment, for the timer_fn.  Note that the
-	 * work's gcwq is preserved to allow reentrance detection for
+	 * work's pool is preserved to allow reentrance detection for
 	 * delayed works.
 	 */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		struct global_cwq *gcwq = get_work_gcwq(work);
+		struct worker_pool *pool = get_work_pool(work);
 
 		/*
-		 * If we cannot get the last gcwq from @work directly,
+		 * If we cannot get the last pool from @work directly,
 		 * select the last CPU such that it avoids unnecessarily
 		 * triggering non-reentrancy check in __queue_work().
 		 */
 		lcpu = cpu;
-		if (gcwq)
-			lcpu = gcwq->cpu;
+		if (pool)
+			lcpu = pool->cpu;
 		if (lcpu == WORK_CPU_UNBOUND)
 			lcpu = raw_smp_processor_id();
 	} else {
@@ -1638,14 +1638,14 @@ __acquires(&gcwq->lock)
 		 * against POOL_DISASSOCIATED.
 		 */
 		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+			set_cpus_allowed_ptr(task, get_cpu_mask(pool->cpu));
 
 		spin_lock_irq(&gcwq->lock);
 		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
-		if (task_cpu(task) == gcwq->cpu &&
+		if (task_cpu(task) == pool->cpu &&
 		    cpumask_equal(&current->cpus_allowed,
-				  get_cpu_mask(gcwq->cpu)))
+				  get_cpu_mask(pool->cpu)))
 			return true;
 		spin_unlock_irq(&gcwq->lock);
 
@@ -1766,7 +1766,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 			else
 				wq = system_wq;
 
-			insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
+			insert_work(get_cwq(pool->cpu, wq), rebind_work,
 				    worker->scheduled.next,
 				    work_color_to_flags(WORK_NO_COLOR));
 		}
@@ -1825,10 +1825,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->pool = pool;
 	worker->id = id;
 
-	if (gcwq->cpu != WORK_CPU_UNBOUND)
+	if (pool->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
-					worker, cpu_to_node(gcwq->cpu),
-					"kworker/%u:%d%s", gcwq->cpu, id, pri);
+					worker, cpu_to_node(pool->cpu),
+					"kworker/%u:%d%s", pool->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
 					      "kworker/u:%d%s", id, pri);
@@ -1848,7 +1848,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	 * online, make sure every worker has %PF_THREAD_BOUND set.
 	 */
 	if (!(pool->flags & POOL_DISASSOCIATED)) {
-		kthread_bind(worker->task, gcwq->cpu);
+		kthread_bind(worker->task, pool->cpu);
 	} else {
 		worker->task->flags |= PF_THREAD_BOUND;
 		worker->flags |= WORKER_UNBOUND;
@@ -1955,7 +1955,7 @@ static bool send_mayday(struct work_struct *work)
 		return false;
 
 	/* mayday mayday mayday */
-	cpu = cwq->pool->gcwq->cpu;
+	cpu = cwq->pool->cpu;
 	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
 	if (cpu == WORK_CPU_UNBOUND)
 		cpu = 0;
@@ -2212,7 +2212,7 @@ __acquires(&gcwq->lock)
 	 */
 	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
 		     !(pool->flags & POOL_DISASSOCIATED) &&
-		     raw_smp_processor_id() != gcwq->cpu);
+		     raw_smp_processor_id() != pool->cpu);
 
 	/*
 	 * A single work shouldn't be executed concurrently by
@@ -3562,7 +3562,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	struct hlist_node *pos;
 	int i;
 
-	BUG_ON(gcwq->cpu != smp_processor_id());
+	BUG_ON(gcwq->pools[0].cpu != smp_processor_id());
 
 	gcwq_claim_assoc_and_lock(gcwq);
 
@@ -3869,10 +3869,10 @@ static int __init init_workqueues(void)
 		struct worker_pool *pool;
 
 		spin_lock_init(&gcwq->lock);
-		gcwq->cpu = cpu;
 
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
+			pool->cpu = cpu;
 			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
-- 
1.8.0.2

