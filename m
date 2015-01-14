Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbbANIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:53:49 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:12615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756321AbbANIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:43 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56041185"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH 2/2 shit_A] workqueue: update wq_numa when cpu_present_mask changed
Date: Wed, 14 Jan 2015 16:54:16 +0800
Message-ID: <1421225658-3978-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
References: <54B5D8B4.7010708@cn.fujitsu.com>
 <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 76 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 19bca3e..5289892 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -266,8 +266,8 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static cpumask_var_t *wq_numa_possible_cpumask;
-					/* possible CPUs of each node */
+static cpumask_var_t *wq_numa_present_cpumask;
+					/* present CPUs of each node */
 
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);
@@ -3506,7 +3506,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (wq_numa_enabled) {
 		for_each_node(node) {
 			if (cpumask_subset(pool->attrs->cpumask,
-					   wq_numa_possible_cpumask[node])) {
+					   wq_numa_present_cpumask[node])) {
 				pool->node = node;
 				break;
 			}
@@ -3727,8 +3727,8 @@ static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
 	if (cpumask_empty(cpumask))
 		goto use_dfl;
 
-	/* yeap, return possible CPUs in @node that @attrs wants */
-	cpumask_and(cpumask, attrs->cpumask, wq_numa_possible_cpumask[node]);
+	/* yeap, return present CPUs in @node that @attrs wants */
+	cpumask_and(cpumask, attrs->cpumask, wq_numa_present_cpumask[node]);
 	return !cpumask_equal(cpumask, attrs->cpumask);
 
 use_dfl:
@@ -3876,8 +3876,8 @@ enomem:
 /**
  * wq_update_unbound_numa - update NUMA affinity of a wq for CPU hot[un]plug
  * @wq: the target workqueue
- * @cpu: the CPU coming up or going down
- * @online: whether @cpu is coming up or going down
+ * @node: the node to be updated
+ * @cpu_off: the CPU going down
  *
  * This function is to be called from %CPU_DOWN_PREPARE, %CPU_ONLINE and
  * %CPU_DOWN_FAILED.  @cpu is being hot[un]plugged, update NUMA affinity of
@@ -3895,11 +3895,9 @@ enomem:
  * affinity, it's the user's responsibility to flush the work item from
  * CPU_DOWN_PREPARE.
  */
-static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
-				   bool online)
+static void wq_update_unbound_numa(struct workqueue_struct *wq, int node,
+				   int cpu_off)
 {
-	int node = cpu_to_node(cpu);
-	int cpu_off = online ? -1 : cpu;
 	struct pool_workqueue *old_pwq = NULL, *pwq;
 	struct workqueue_attrs *target_attrs;
 	cpumask_t *cpumask;
@@ -4565,6 +4563,43 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 						  pool->attrs->cpumask) < 0);
 }
 
+static void wq_numa_notify_cpu_present_set(int cpu, int node)
+{
+	cpumask_set_cpu(cpu, wq_numa_present_cpumask[node]);
+}
+
+static void wq_numa_notify_cpu_present_cleared(int cpu, int node)
+{
+	struct workqueue_struct *wq;
+
+	cpumask_clear_cpu(cpu, wq_numa_present_cpumask[node]);
+
+	list_for_each_entry(wq, &workqueues, list)
+		wq_update_unbound_numa(wq, node, -1);
+}
+
+/*
+ * the memory system code doesn't have notification for cpu_present_mask
+ * changes, we fake one.
+ */
+static void wq_numa_check_present_cpumask_changes(int cpu)
+{
+	int node;
+
+	if (cpumask_test_cpu(cpu, wq_numa_present_cpumask[cpu_to_node(cpu)]))
+		return;
+
+	mutex_lock(&wq_pool_mutex);
+	for_each_node(node) {
+		if (cpumask_test_cpu(cpu, wq_numa_present_cpumask[node])) {
+			wq_numa_notify_cpu_present_cleared(cpu, node);
+			wq_numa_notify_cpu_present_set(cpu, cpu_to_node(cpu));
+			break;
+		}
+	}
+	mutex_unlock(&wq_pool_mutex);
+}
+
 /*
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
@@ -4588,6 +4623,8 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 			if (!create_worker(pool))
 				return NOTIFY_BAD;
 		}
+
+		wq_numa_check_present_cpumask_changes(cpu);
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -4607,7 +4644,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 		/* update NUMA affinity of unbound workqueues */
 		list_for_each_entry(wq, &workqueues, list)
-			wq_update_unbound_numa(wq, cpu, true);
+			wq_update_unbound_numa(wq, node, -1);
 
 		mutex_unlock(&wq_pool_mutex);
 		break;
@@ -4636,7 +4673,7 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 		/* update NUMA affinity of unbound workqueues */
 		mutex_lock(&wq_pool_mutex);
 		list_for_each_entry(wq, &workqueues, list)
-			wq_update_unbound_numa(wq, cpu, false);
+			wq_update_unbound_numa(wq, cpu_to_node(cpu), cpu);
 		mutex_unlock(&wq_pool_mutex);
 
 		/* wait for per-cpu unbinding to finish */
@@ -4854,17 +4891,10 @@ static void __init wq_numa_init(void)
 		BUG_ON(!zalloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
 				node_online(node) ? node : NUMA_NO_NODE));
 
-	for_each_possible_cpu(cpu) {
-		node = cpu_to_node(cpu);
-		if (WARN_ON(node == NUMA_NO_NODE)) {
-			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
-			/* happens iff arch is bonkers, let's just proceed */
-			return;
-		}
-		cpumask_set_cpu(cpu, tbl[node]);
-	}
+	for_each_present_cpu(cpu)
+		cpumask_set_cpu(cpu, tbl[cpu_to_node(cpu)]);
 
-	wq_numa_possible_cpumask = tbl;
+	wq_numa_present_cpumask = tbl;
 	hotplug_memory_notifier(wq_numa_callback, 0);
 	wq_numa_enabled = true;
 }
-- 
2.1.0

