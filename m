Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3CBDZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:08 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47108 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3CBDYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:44 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/31] workqueue: consistently use int for @cpu variables
Date: Fri,  1 Mar 2013 19:24:00 -0800
Message-Id: <1362194662-2344-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue is mixing unsigned int and int for @cpu variables.  There's
no point in using unsigned int for cpus - many of cpu related APIs
take int anyway.  Consistently use int for @cpu variables so that we
can use negative values to mark special ones.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h   |  6 +++---
 kernel/workqueue.c          | 24 +++++++++++-------------
 kernel/workqueue_internal.h |  5 ++---
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5bd030f..899be66 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -435,7 +435,7 @@ extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
-extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
+extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
 
 /*
@@ -466,12 +466,12 @@ static inline bool __deprecated flush_delayed_work_sync(struct delayed_work *dwo
 }
 
 #ifndef CONFIG_SMP
-static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+static inline long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
 	return fn(arg);
 }
 #else
-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
+long work_on_cpu(int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_FREEZER
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8b38d1c..cbdc2ac 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -124,7 +124,7 @@ enum {
 
 struct worker_pool {
 	spinlock_t		lock;		/* the pool lock */
-	unsigned int		cpu;		/* I: the associated cpu */
+	int			cpu;		/* I: the associated cpu */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
@@ -467,8 +467,7 @@ static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 	return &pools[highpri];
 }
 
-static struct pool_workqueue *get_pwq(unsigned int cpu,
-				      struct workqueue_struct *wq)
+static struct pool_workqueue *get_pwq(int cpu, struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND)) {
 		if (likely(cpu < nr_cpu_ids))
@@ -730,7 +729,7 @@ static void wake_up_worker(struct worker_pool *pool)
  * CONTEXT:
  * spin_lock_irq(rq->lock)
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_waking_up(struct task_struct *task, int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
@@ -755,8 +754,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
  * RETURNS:
  * Worker task on @cpu to wake up, %NULL if none.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu)
+struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool;
@@ -1160,7 +1158,7 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	return worker && worker->current_pwq->wq == wq;
 }
 
-static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
+static void __queue_work(int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct pool_workqueue *pwq;
@@ -1716,7 +1714,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
-					"kworker/%u:%d%s", pool->cpu, id, pri);
+					"kworker/%d:%d%s", pool->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
 					      "kworker/u:%d%s", id, pri);
@@ -3347,7 +3345,7 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
  * RETURNS:
  * %true if congested, %false otherwise.
  */
-bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
+bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 {
 	struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
@@ -3464,7 +3462,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
+	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -3510,7 +3508,7 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
+	int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -3550,7 +3548,7 @@ static void work_for_cpu_fn(struct work_struct *work)
  * It is up to the caller to ensure that the cpu doesn't go offline.
  * The caller must not hold any locks which would prevent @fn from completing.
  */
-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
 	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
 
@@ -3708,7 +3706,7 @@ out_unlock:
 
 static int __init init_workqueues(void)
 {
-	unsigned int cpu;
+	int cpu;
 
 	/* make sure we have enough bits for OFFQ pool ID */
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index f9c8877..f116f07 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -59,8 +59,7 @@ static inline struct worker *current_wq_worker(void)
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
  * sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
+void wq_worker_waking_up(struct task_struct *task, int cpu);
+struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu);
 
 #endif /* _KERNEL_WORKQUEUE_INTERNAL_H */
-- 
1.8.1.2

