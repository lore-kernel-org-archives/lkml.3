Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaJHDvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:51:38 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:6537 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136AbaJHDvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:51:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406563200"; 
   d="scan'208";a="36937201"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3] workqueue: add wq_unbound_online_cpumask
Date: Wed, 8 Oct 2014 11:53:31 +0800
Message-ID: <1412740423-20782-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current wq_calc_node_cpumask() is complicated by cpumask_of_node(node) whose
value need to be revised before using and the "revising" needs @cpu_going_down
which makes more complicated.

This patch introduces wq_unbound_online_cpumask which is updated before
wq_update_unbound_numa() in the cpu-hotplug callbacks and wq_calc_node_cpumask()
can use it instead of cpumask_of_node(node). Thus wq_calc_node_cpumask()
becomes much simpler and @cpu_going_down is gone.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22a..7a217f0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -282,6 +282,9 @@ module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
+/* PL: online cpumask for all unbound wqs */
+static struct cpumask wq_unbound_online_cpumask;
+
 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
 static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
 
@@ -3675,12 +3678,9 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
  * wq_calc_node_mask - calculate a wq_attrs' cpumask for the specified node
  * @attrs: the wq_attrs of interest
  * @node: the target NUMA node
- * @cpu_going_down: if >= 0, the CPU to consider as offline
  * @cpumask: outarg, the resulting cpumask
  *
- * Calculate the cpumask a workqueue with @attrs should use on @node.  If
- * @cpu_going_down is >= 0, that cpu is considered offline during
- * calculation.  The result is stored in @cpumask.
+ * Calculate the cpumask a workqueue with @attrs should use on @node.
  *
  * If NUMA affinity is not enabled, @attrs->cpumask is always used.  If
  * enabled and @node has online CPUs requested by @attrs, the returned
@@ -3694,22 +3694,17 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
  * %false if equal.
  */
 static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
-				 int cpu_going_down, cpumask_t *cpumask)
+				 struct cpumask *cpumask)
 {
 	if (!wq_numa_enabled || attrs->no_numa)
 		goto use_dfl;
 
 	/* does @node have any online CPUs @attrs wants? */
-	cpumask_and(cpumask, cpumask_of_node(node), attrs->cpumask);
-	if (cpu_going_down >= 0)
-		cpumask_clear_cpu(cpu_going_down, cpumask);
-
-	if (cpumask_empty(cpumask))
-		goto use_dfl;
-
-	/* yeap, return possible CPUs in @node that @attrs wants */
 	cpumask_and(cpumask, attrs->cpumask, wq_numa_possible_cpumask[node]);
-	return !cpumask_equal(cpumask, attrs->cpumask);
+	if (cpumask_intersects(cpumask, &wq_unbound_online_cpumask)) {
+		/* yeap, return possible CPUs in @node that @attrs wants */
+		return !cpumask_equal(cpumask, attrs->cpumask);
+	}
 
 use_dfl:
 	cpumask_copy(cpumask, attrs->cpumask);
@@ -3800,7 +3795,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		goto enomem_pwq;
 
 	for_each_node(node) {
-		if (wq_calc_node_cpumask(attrs, node, -1, tmp_attrs->cpumask)) {
+		if (wq_calc_node_cpumask(attrs, node, tmp_attrs->cpumask)) {
 			pwq_tbl[node] = alloc_unbound_pwq(wq, tmp_attrs);
 			if (!pwq_tbl[node])
 				goto enomem_pwq;
@@ -3857,7 +3852,6 @@ enomem:
  * wq_update_unbound_numa - update NUMA affinity of a wq for CPU hot[un]plug
  * @wq: the target workqueue
  * @cpu: the CPU coming up or going down
- * @online: whether @cpu is coming up or going down
  *
  * This function is to be called from %CPU_DOWN_PREPARE, %CPU_ONLINE and
  * %CPU_DOWN_FAILED.  @cpu is being hot[un]plugged, update NUMA affinity of
@@ -3875,11 +3869,9 @@ enomem:
  * affinity, it's the user's responsibility to flush the work item from
  * CPU_DOWN_PREPARE.
  */
-static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
-				   bool online)
+static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu)
 {
 	int node = cpu_to_node(cpu);
-	int cpu_off = online ? -1 : cpu;
 	struct pool_workqueue *old_pwq = NULL, *pwq;
 	struct workqueue_attrs *target_attrs;
 	cpumask_t *cpumask;
@@ -3910,7 +3902,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	 * a new one if they don't match.  If the target cpumask equals
 	 * wq's, the default pwq should be used.
 	 */
-	if (wq_calc_node_cpumask(wq->unbound_attrs, node, cpu_off, cpumask)) {
+	if (wq_calc_node_cpumask(wq->unbound_attrs, node, cpumask)) {
 		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
 			goto out_unlock;
 	} else {
@@ -4583,9 +4575,11 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_unlock(&pool->attach_mutex);
 		}
 
+		cpumask_set_cpu(cpu, &wq_unbound_online_cpumask);
+
 		/* update NUMA affinity of unbound workqueues */
 		list_for_each_entry(wq, &workqueues, list)
-			wq_update_unbound_numa(wq, cpu, true);
+			wq_update_unbound_numa(wq, cpu);
 
 		mutex_unlock(&wq_pool_mutex);
 		break;
@@ -4611,10 +4605,12 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 
+		cpumask_clear_cpu(cpu, &wq_unbound_online_cpumask);
+
 		/* update NUMA affinity of unbound workqueues */
 		mutex_lock(&wq_pool_mutex);
 		list_for_each_entry(wq, &workqueues, list)
-			wq_update_unbound_numa(wq, cpu, false);
+			wq_update_unbound_numa(wq, cpu);
 		mutex_unlock(&wq_pool_mutex);
 
 		/* wait for per-cpu unbinding to finish */
@@ -4828,6 +4824,8 @@ static int __init init_workqueues(void)
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
+	cpumask_copy(&wq_unbound_online_cpumask, cpu_online_mask);
+
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
-- 
1.7.4.4

