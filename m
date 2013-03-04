Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3CDShs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:37:48 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:61439 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab3CDShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:37:47 -0500
Date: Mon, 4 Mar 2013 10:37:42 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
Message-ID: <20130304183742.GI30413@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce struct workqueue_attrs which carries worker attributes -
currently the nice level and allowed cpumask along with helper
routines alloc_workqueue_attrs() and free_workqueue_attrs().

Each worker_pool now carries ->attrs describing the attributes of its
workers.  All functions dealing with cpumask and nice level of workers
are updated to follow worker_pool->attrs instead of determining them
from other characteristics of the worker_pool, and init_workqueues()
is updated to set worker_pool->attrs appropriately for all standard
pools.

Note that create_worker() is updated to always perform set_user_nice()
and use set_cpus_allowed_ptr() combined with manual assertion of
PF_THREAD_BOUND instead of kthread_bind().  This simplifies handling
random attributes without affecting the outcome.

This patch doesn't introduce any behavior changes.

v2: Missing cpumask_var_t definition caused build failure on some
    archs.  linux/cpumask.h included.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 include/linux/workqueue.h |   13 +++++
 kernel/workqueue.c        |  103 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 94 insertions(+), 22 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -11,6 +11,7 @@
 #include <linux/lockdep.h>
 #include <linux/threads.h>
 #include <linux/atomic.h>
+#include <linux/cpumask.h>
 
 struct workqueue_struct;
 
@@ -115,6 +116,15 @@ struct delayed_work {
 	int cpu;
 };
 
+/*
+ * A struct for workqueue attributes.  This can be used to change
+ * attributes of an unbound workqueue.
+ */
+struct workqueue_attrs {
+	int			nice;		/* nice level */
+	cpumask_var_t		cpumask;	/* allowed CPUs */
+};
+
 static inline struct delayed_work *to_delayed_work(struct work_struct *work)
 {
 	return container_of(work, struct delayed_work, work);
@@ -399,6 +409,9 @@ __alloc_workqueue_key(const char *fmt, u
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
+struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
+void free_workqueue_attrs(struct workqueue_attrs *attrs);
+
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
 extern bool queue_work(struct workqueue_struct *wq, struct work_struct *work);
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -148,6 +148,8 @@ struct worker_pool {
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 
+	struct workqueue_attrs	*attrs;		/* I: worker attributes */
+
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
 	 * from other CPUs during try_to_wake_up(), put it in a separate
@@ -1563,14 +1565,13 @@ __acquires(&pool->lock)
 		 * against POOL_DISASSOCIATED.
 		 */
 		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(current, get_cpu_mask(pool->cpu));
+			set_cpus_allowed_ptr(current, pool->attrs->cpumask);
 
 		spin_lock_irq(&pool->lock);
 		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
 		if (task_cpu(current) == pool->cpu &&
-		    cpumask_equal(&current->cpus_allowed,
-				  get_cpu_mask(pool->cpu)))
+		    cpumask_equal(&current->cpus_allowed, pool->attrs->cpumask))
 			return true;
 		spin_unlock_irq(&pool->lock);
 
@@ -1677,7 +1678,7 @@ static void rebind_workers(struct worker
 		 * wq doesn't really matter but let's keep @worker->pool
 		 * and @pwq->pool consistent for sanity.
 		 */
-		if (std_worker_pool_pri(worker->pool))
+		if (worker->pool->attrs->nice < 0)
 			wq = system_highpri_wq;
 		else
 			wq = system_wq;
@@ -1719,7 +1720,7 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct worker_pool *pool)
 {
-	const char *pri = std_worker_pool_pri(pool) ? "H" : "";
+	const char *pri = pool->attrs->nice < 0  ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
@@ -1749,24 +1750,23 @@ static struct worker *create_worker(stru
 	if (IS_ERR(worker->task))
 		goto fail;
 
-	if (std_worker_pool_pri(pool))
-		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
+	set_user_nice(worker->task, pool->attrs->nice);
+	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * Determine CPU binding of the new worker depending on
-	 * %POOL_DISASSOCIATED.  The caller is responsible for ensuring the
-	 * flag remains stable across this function.  See the comments
-	 * above the flag definition for details.
-	 *
-	 * As an unbound worker may later become a regular one if CPU comes
-	 * online, make sure every worker has %PF_THREAD_BOUND set.
+	 * %PF_THREAD_BOUND is used to prevent userland from meddling with
+	 * cpumask of workqueue workers.  This is an abuse.  We need
+	 * %PF_KERNEL_CPUMASK.
 	 */
-	if (!(pool->flags & POOL_DISASSOCIATED)) {
-		kthread_bind(worker->task, pool->cpu);
-	} else {
-		worker->task->flags |= PF_THREAD_BOUND;
+	worker->task->flags |= PF_THREAD_BOUND;
+
+	/*
+	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
+	 * remains stable across this function.  See the comments above the
+	 * flag definition for details.
+	 */
+	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
-	}
 
 	return worker;
 fail:
@@ -3121,7 +3121,52 @@ int keventd_up(void)
 	return system_wq != NULL;
 }
 
-static void init_worker_pool(struct worker_pool *pool)
+/**
+ * free_workqueue_attrs - free a workqueue_attrs
+ * @attrs: workqueue_attrs to free
+ *
+ * Undo alloc_workqueue_attrs().
+ */
+void free_workqueue_attrs(struct workqueue_attrs *attrs)
+{
+	if (attrs) {
+		free_cpumask_var(attrs->cpumask);
+		kfree(attrs);
+	}
+}
+
+/**
+ * alloc_workqueue_attrs - allocate a workqueue_attrs
+ * @gfp_mask: allocation mask to use
+ *
+ * Allocate a new workqueue_attrs, initialize with default settings and
+ * return it.  Returns NULL on failure.
+ */
+struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
+{
+	struct workqueue_attrs *attrs;
+
+	attrs = kzalloc(sizeof(*attrs), gfp_mask);
+	if (!attrs)
+		goto fail;
+	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
+		goto fail;
+
+	cpumask_setall(attrs->cpumask);
+	return attrs;
+fail:
+	free_workqueue_attrs(attrs);
+	return NULL;
+}
+
+/**
+ * init_worker_pool - initialize a newly zalloc'd worker_pool
+ * @pool: worker_pool to initialize
+ *
+ * Initiailize a newly zalloc'd @pool.  It also allocates @pool->attrs.
+ * Returns 0 on success, -errno on failure.
+ */
+static int init_worker_pool(struct worker_pool *pool)
 {
 	spin_lock_init(&pool->lock);
 	pool->flags |= POOL_DISASSOCIATED;
@@ -3139,6 +3184,11 @@ static void init_worker_pool(struct work
 	mutex_init(&pool->manager_mutex);
 	mutex_init(&pool->assoc_mutex);
 	ida_init(&pool->worker_ida);
+
+	pool->attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!pool->attrs)
+		return -ENOMEM;
+	return 0;
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
@@ -3791,7 +3841,8 @@ out_unlock:
 
 static int __init init_workqueues(void)
 {
-	int cpu;
+	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
+	int i, cpu;
 
 	/* make sure we have enough bits for OFFQ pool ID */
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
@@ -3808,10 +3859,18 @@ static int __init init_workqueues(void)
 	for_each_wq_cpu(cpu) {
 		struct worker_pool *pool;
 
+		i = 0;
 		for_each_std_worker_pool(pool, cpu) {
-			init_worker_pool(pool);
+			BUG_ON(init_worker_pool(pool));
 			pool->cpu = cpu;
 
+			if (cpu != WORK_CPU_UNBOUND)
+				cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
+			else
+				cpumask_setall(pool->attrs->cpumask);
+
+			pool->attrs->nice = std_nice[i++];
+
 			/* alloc pool ID */
 			BUG_ON(worker_pool_assign_id(pool));
 		}
