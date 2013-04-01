Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3DAS2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:28:52 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41018 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3DAS2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:28:50 -0400
Date: Mon, 1 Apr 2013 11:28:43 -0700
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Lai Jiangshan <eag0628@gmail.com>
Subject: [PATCH v5 13/14] workqueue: implement NUMA affinity for unbound
 workqueues
Message-ID: <20130401182843.GC3142@htj.dyndns.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
 <1364453020-2829-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364453020-2829-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4c16bd327c74d6678858706211a0c6e4e53eb3e6 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 1 Apr 2013 11:23:36 -0700

Currently, an unbound workqueue has single current, or first, pwq
(pool_workqueue) to which all new work items are queued.  This often
isn't optimal on NUMA machines as workers may jump around across node
boundaries and work items get assigned to workers without any regard
to NUMA affinity.

This patch implements NUMA affinity for unbound workqueues.  Instead
of mapping all entries of numa_pwq_tbl[] to the same pwq,
apply_workqueue_attrs() now creates a separate pwq covering the
intersecting CPUs for each NUMA node which has online CPUs in
@attrs->cpumask.  Nodes which don't have intersecting possible CPUs
are mapped to pwqs covering whole @attrs->cpumask.

As CPUs come up and go down, the pool association is changed
accordingly.  Changing pool association may involve allocating new
pools which may fail.  To avoid failing CPU_DOWN, each workqueue
always keeps a default pwq which covers whole attrs->cpumask which is
used as fallback if pool creation fails during a CPU hotplug
operation.

This ensures that all work items issued on a NUMA node is executed on
the same node as long as the workqueue allows execution on the CPUs of
the node.

As this maps a workqueue to multiple pwqs and max_active is per-pwq,
this change the behavior of max_active.  The limit is now per NUMA
node instead of global.  While this is an actual change, max_active is
already per-cpu for per-cpu workqueues and primarily used as safety
mechanism rather than for active concurrency control.  Concurrency is
usually limited from workqueue users by the number of concurrently
active work items and this change shouldn't matter much.

v2: Fixed pwq freeing in apply_workqueue_attrs() error path.  Spotted
    by Lai.

v3: The previous version incorrectly made a workqueue spanning
    multiple nodes spread work items over all online CPUs when some of
    its nodes don't have any desired cpus.  Reimplemented so that NUMA
    affinity is properly updated as CPUs go up and down.  This problem
    was spotted by Lai Jiangshan.

v4: destroy_workqueue() was putting wq->dfl_pwq and then clearing it;
    however, wq may be freed at any time after dfl_pwq is put making
    the clearing use-after-free.  Clear wq->dfl_pwq before putting it.

v5: apply_workqueue_attrs() was leaking @tmp_attrs, @new_attrs and
    @pwq_tbl after success.  Fixed.

    Retry loop in wq_update_unbound_numa_attrs() isn't necessary as
    application of new attrs is excluded via CPU hotplug.  Removed.

    Documentation on CPU affinity guarantee on CPU_DOWN added.

    All changes are suggested by Lai Jiangshan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 278 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 259 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d9a4aeb..57cd77d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -45,6 +45,7 @@
 #include <linux/hashtable.h>
 #include <linux/rculist.h>
 #include <linux/nodemask.h>
+#include <linux/moduleparam.h>
 
 #include "workqueue_internal.h"
 
@@ -245,6 +246,7 @@ struct workqueue_struct {
 	int			saved_max_active; /* WQ: saved pwq max_active */
 
 	struct workqueue_attrs	*unbound_attrs;	/* WQ: only for unbound wqs */
+	struct pool_workqueue	*dfl_pwq;	/* WQ: only for unbound wqs */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -268,6 +270,9 @@ static cpumask_var_t *wq_numa_possible_cpumask;
 
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
+/* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
+static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
+
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
@@ -3710,6 +3715,61 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	return pwq;
 }
 
+/* undo alloc_unbound_pwq(), used only in the error path */
+static void free_unbound_pwq(struct pool_workqueue *pwq)
+{
+	lockdep_assert_held(&wq_pool_mutex);
+
+	if (pwq) {
+		put_unbound_pool(pwq->pool);
+		kfree(pwq);
+	}
+}
+
+/**
+ * wq_calc_node_mask - calculate a wq_attrs' cpumask for the specified node
+ * @attrs: the wq_attrs of interest
+ * @node: the target NUMA node
+ * @cpu_going_down: if >= 0, the CPU to consider as offline
+ * @cpumask: outarg, the resulting cpumask
+ *
+ * Calculate the cpumask a workqueue with @attrs should use on @node.  If
+ * @cpu_going_down is >= 0, that cpu is considered offline during
+ * calculation.  The result is stored in @cpumask.  This function returns
+ * %true if the resulting @cpumask is different from @attrs->cpumask,
+ * %false if equal.
+ *
+ * If NUMA affinity is not enabled, @attrs->cpumask is always used.  If
+ * enabled and @node has online CPUs requested by @attrs, the returned
+ * cpumask is the intersection of the possible CPUs of @node and
+ * @attrs->cpumask.
+ *
+ * The caller is responsible for ensuring that the cpumask of @node stays
+ * stable.
+ */
+static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
+				 int cpu_going_down, cpumask_t *cpumask)
+{
+	if (!wq_numa_enabled)
+		goto use_dfl;
+
+	/* does @node have any online CPUs @attrs wants? */
+	cpumask_and(cpumask, cpumask_of_node(node), attrs->cpumask);
+	if (cpu_going_down >= 0)
+		cpumask_clear_cpu(cpu_going_down, cpumask);
+
+	if (cpumask_empty(cpumask))
+		goto use_dfl;
+
+	/* yeap, return possible CPUs in @node that @attrs wants */
+	cpumask_and(cpumask, attrs->cpumask, wq_numa_possible_cpumask[node]);
+	return !cpumask_equal(cpumask, attrs->cpumask);
+
+use_dfl:
+	cpumask_copy(cpumask, attrs->cpumask);
+	return false;
+}
+
 /* install @pwq into @wq's numa_pwq_tbl[] for @node and return the old pwq */
 static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
 						   int node,
@@ -3732,11 +3792,12 @@ static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
  * @wq: the target workqueue
  * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
  *
- * Apply @attrs to an unbound workqueue @wq.  If @attrs doesn't match the
- * current attributes, a new pwq is created and made the first pwq which
- * will serve all new work items.  Older pwqs are released as in-flight
- * work items finish.  Note that a work item which repeatedly requeues
- * itself back-to-back will stay on its current pwq.
+ * Apply @attrs to an unbound workqueue @wq.  Unless disabled, on NUMA
+ * machines, this function maps a separate pwq to each NUMA node with
+ * possibles CPUs in @attrs->cpumask so that work items are affine to the
+ * NUMA node it was issued on.  Older pwqs are released as in-flight work
+ * items finish.  Note that a work item which repeatedly requeues itself
+ * back-to-back will stay on its current pwq.
  *
  * Performs GFP_KERNEL allocations.  Returns 0 on success and -errno on
  * failure.
@@ -3744,8 +3805,8 @@ static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
 int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
-	struct workqueue_attrs *new_attrs;
-	struct pool_workqueue *pwq, *last_pwq = NULL;
+	struct workqueue_attrs *new_attrs, *tmp_attrs;
+	struct pool_workqueue **pwq_tbl, *dfl_pwq;
 	int node, ret;
 
 	/* only unbound workqueues can change attributes */
@@ -3756,40 +3817,191 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
 		return -EINVAL;
 
-	/* make a copy of @attrs and sanitize it */
+	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
 	new_attrs = alloc_workqueue_attrs(GFP_KERNEL);
-	if (!new_attrs)
+	tmp_attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!pwq_tbl || !new_attrs || !tmp_attrs)
 		goto enomem;
 
+	/* make a copy of @attrs and sanitize it */
 	copy_workqueue_attrs(new_attrs, attrs);
 	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, cpu_possible_mask);
 
+	/*
+	 * We may create multiple pwqs with differing cpumasks.  Make a
+	 * copy of @new_attrs which will be modified and used to obtain
+	 * pools.
+	 */
+	copy_workqueue_attrs(tmp_attrs, new_attrs);
+
+	/*
+	 * CPUs should stay stable across pwq creations and installations.
+	 * Pin CPUs, determine the target cpumask for each node and create
+	 * pwqs accordingly.
+	 */
+	get_online_cpus();
+
 	mutex_lock(&wq_pool_mutex);
-	pwq = alloc_unbound_pwq(wq, new_attrs);
+
+	/*
+	 * If something goes wrong during CPU up/down, we'll fall back to
+	 * the default pwq covering whole @attrs->cpumask.  Always create
+	 * it even if we don't use it immediately.
+	 */
+	dfl_pwq = alloc_unbound_pwq(wq, new_attrs);
+	if (!dfl_pwq)
+		goto enomem_pwq;
+
+	for_each_node(node) {
+		if (wq_calc_node_cpumask(attrs, node, -1, tmp_attrs->cpumask)) {
+			pwq_tbl[node] = alloc_unbound_pwq(wq, tmp_attrs);
+			if (!pwq_tbl[node])
+				goto enomem_pwq;
+		} else {
+			dfl_pwq->refcnt++;
+			pwq_tbl[node] = dfl_pwq;
+		}
+	}
+
 	mutex_unlock(&wq_pool_mutex);
-	if (!pwq)
-		goto enomem;
 
+	/* all pwqs have been created successfully, let's install'em */
 	mutex_lock(&wq->mutex);
 
 	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
+
+	/* save the previous pwq and install the new one */
 	for_each_node(node)
-		last_pwq = numa_pwq_tbl_install(wq, node, pwq);
+		pwq_tbl[node] = numa_pwq_tbl_install(wq, node, pwq_tbl[node]);
+
+	/* @dfl_pwq might not have been used, ensure it's linked */
+	link_pwq(dfl_pwq);
+	swap(wq->dfl_pwq, dfl_pwq);
 
 	mutex_unlock(&wq->mutex);
 
-	put_pwq_unlocked(last_pwq);
+	/* put the old pwqs */
+	for_each_node(node)
+		put_pwq_unlocked(pwq_tbl[node]);
+	put_pwq_unlocked(dfl_pwq);
+
+	put_online_cpus();
 	ret = 0;
 	/* fall through */
 out_free:
+	free_workqueue_attrs(tmp_attrs);
 	free_workqueue_attrs(new_attrs);
+	kfree(pwq_tbl);
 	return ret;
 
+enomem_pwq:
+	free_unbound_pwq(dfl_pwq);
+	for_each_node(node)
+		if (pwq_tbl && pwq_tbl[node] != dfl_pwq)
+			free_unbound_pwq(pwq_tbl[node]);
+	mutex_unlock(&wq_pool_mutex);
+	put_online_cpus();
 enomem:
 	ret = -ENOMEM;
 	goto out_free;
 }
 
+/**
+ * wq_update_unbound_numa - update NUMA affinity of a wq for CPU hot[un]plug
+ * @wq: the target workqueue
+ * @cpu: the CPU coming up or going down
+ * @online: whether @cpu is coming up or going down
+ *
+ * This function is to be called from %CPU_DOWN_PREPARE, %CPU_ONLINE and
+ * %CPU_DOWN_FAILED.  @cpu is being hot[un]plugged, update NUMA affinity of
+ * @wq accordingly.
+ *
+ * If NUMA affinity can't be adjusted due to memory allocation failure, it
+ * falls back to @wq->dfl_pwq which may not be optimal but is always
+ * correct.
+ *
+ * Note that when the last allowed CPU of a NUMA node goes offline for a
+ * workqueue with a cpumask spanning multiple nodes, the workers which were
+ * already executing the work items for the workqueue will lose their CPU
+ * affinity and may execute on any CPU.  This is similar to how per-cpu
+ * workqueues behave on CPU_DOWN.  If a workqueue user wants strict
+ * affinity, it's the user's responsibility to flush the work item from
+ * CPU_DOWN_PREPARE.
+ */
+static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
+				   bool online)
+{
+	int node = cpu_to_node(cpu);
+	int cpu_off = online ? -1 : cpu;
+	struct pool_workqueue *old_pwq = NULL, *pwq;
+	struct workqueue_attrs *target_attrs;
+	cpumask_t *cpumask;
+
+	lockdep_assert_held(&wq_pool_mutex);
+
+	if (!wq_numa_enabled || !(wq->flags & WQ_UNBOUND))
+		return;
+
+	/*
+	 * We don't wanna alloc/free wq_attrs for each wq for each CPU.
+	 * Let's use a preallocated one.  The following buf is protected by
+	 * CPU hotplug exclusion.
+	 */
+	target_attrs = wq_update_unbound_numa_attrs_buf;
+	cpumask = target_attrs->cpumask;
+
+	mutex_lock(&wq->mutex);
+
+	copy_workqueue_attrs(target_attrs, wq->unbound_attrs);
+	pwq = unbound_pwq_by_node(wq, node);
+
+	/*
+	 * Let's determine what needs to be done.  If the target cpumask is
+	 * different from wq's, we need to compare it to @pwq's and create
+	 * a new one if they don't match.  If the target cpumask equals
+	 * wq's, the default pwq should be used.  If @pwq is already the
+	 * default one, nothing to do; otherwise, install the default one.
+	 */
+	if (wq_calc_node_cpumask(wq->unbound_attrs, node, cpu_off, cpumask)) {
+		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
+			goto out_unlock;
+	} else {
+		if (pwq == wq->dfl_pwq)
+			goto out_unlock;
+		else
+			goto use_dfl_pwq;
+	}
+
+	mutex_unlock(&wq->mutex);
+
+	/* create a new pwq */
+	pwq = alloc_unbound_pwq(wq, target_attrs);
+	if (!pwq) {
+		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
+			   wq->name);
+		goto out_unlock;
+	}
+
+	/*
+	 * Install the new pwq.  As this function is called only from CPU
+	 * hotplug callbacks and applying a new attrs is wrapped with
+	 * get/put_online_cpus(), @wq->unbound_attrs couldn't have changed
+	 * inbetween.
+	 */
+	mutex_lock(&wq->mutex);
+	old_pwq = numa_pwq_tbl_install(wq, node, pwq);
+	goto out_unlock;
+
+use_dfl_pwq:
+	spin_lock_irq(&wq->dfl_pwq->pool->lock);
+	get_pwq(wq->dfl_pwq);
+	spin_unlock_irq(&wq->dfl_pwq->pool->lock);
+	old_pwq = numa_pwq_tbl_install(wq, node, wq->dfl_pwq);
+out_unlock:
+	mutex_unlock(&wq->mutex);
+	put_pwq_unlocked(old_pwq);
+}
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
@@ -3942,6 +4154,7 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
 void destroy_workqueue(struct workqueue_struct *wq)
 {
 	struct pool_workqueue *pwq;
+	int node;
 
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
@@ -3993,11 +4206,21 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	} else {
 		/*
 		 * We're the sole accessor of @wq at this point.  Directly
-		 * access the first pwq and put the base ref.  @wq will be
-		 * freed when the last pwq is released.
+		 * access numa_pwq_tbl[] and dfl_pwq to put the base refs.
+		 * @wq will be freed when the last pwq is released.
 		 */
-		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
-				       pwqs_node);
+		for_each_node(node) {
+			pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
+			RCU_INIT_POINTER(wq->numa_pwq_tbl[node], NULL);
+			put_pwq_unlocked(pwq);
+		}
+
+		/*
+		 * Put dfl_pwq.  @wq may be freed any time after dfl_pwq is
+		 * put.  Don't access it afterwards.
+		 */
+		pwq = wq->dfl_pwq;
+		wq->dfl_pwq = NULL;
 		put_pwq_unlocked(pwq);
 	}
 }
@@ -4285,6 +4508,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 {
 	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
+	struct workqueue_struct *wq;
 	int pi;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -4317,6 +4541,10 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_unlock(&pool->manager_mutex);
 		}
 
+		/* update NUMA affinity of unbound workqueues */
+		list_for_each_entry(wq, &workqueues, list)
+			wq_update_unbound_numa(wq, cpu, true);
+
 		mutex_unlock(&wq_pool_mutex);
 		break;
 	}
@@ -4333,12 +4561,21 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 {
 	int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
+	struct workqueue_struct *wq;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		/* unbinding should happen on the local CPU */
+		/* unbinding per-cpu workers should happen on the local CPU */
 		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
+
+		/* update NUMA affinity of unbound workqueues */
+		mutex_lock(&wq_pool_mutex);
+		list_for_each_entry(wq, &workqueues, list)
+			wq_update_unbound_numa(wq, cpu, false);
+		mutex_unlock(&wq_pool_mutex);
+
+		/* wait for per-cpu unbinding to finish */
 		flush_work(&unbind_work);
 		break;
 	}
@@ -4526,6 +4763,9 @@ static void __init wq_numa_init(void)
 	if (num_possible_nodes() <= 1)
 		return;
 
+	wq_update_unbound_numa_attrs_buf = alloc_workqueue_attrs(GFP_KERNEL);
+	BUG_ON(!wq_update_unbound_numa_attrs_buf);
+
 	/*
 	 * We want masks of possible CPUs of each node which isn't readily
 	 * available.  Build one from cpu_to_node() which should have been
-- 
1.8.1.4

