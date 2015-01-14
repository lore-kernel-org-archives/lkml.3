Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbbANIxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:53:48 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:33309 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754888AbbANIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:43 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56041194"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH 2/3 shit_B] workqueue: remove wq_numa_possible_cpumask
Date: Wed, 14 Jan 2015 16:54:17 +0800
Message-ID: <1421225658-3978-4-git-send-email-laijs@cn.fujitsu.com>
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

and use online cpumask instead.

This patch will cause the new per-node pwqs/pools/workers of the node
to be recreatd and the old ones to be exiting when any cpu online
or offline. But it fixed the bug. The next patch will remove
(almost remove) these unneeded rebuilding.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 19bca3e..03ce500 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -266,9 +266,6 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static cpumask_var_t *wq_numa_possible_cpumask;
-					/* possible CPUs of each node */
-
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);
 
@@ -3506,7 +3503,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (wq_numa_enabled) {
 		for_each_node(node) {
 			if (cpumask_subset(pool->attrs->cpumask,
-					   wq_numa_possible_cpumask[node])) {
+					   cpumask_of_node(node))) {
 				pool->node = node;
 				break;
 			}
@@ -3727,8 +3724,6 @@ static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
 	if (cpumask_empty(cpumask))
 		goto use_dfl;
 
-	/* yeap, return possible CPUs in @node that @attrs wants */
-	cpumask_and(cpumask, attrs->cpumask, wq_numa_possible_cpumask[node]);
 	return !cpumask_equal(cpumask, attrs->cpumask);
 
 use_dfl:
@@ -4828,9 +4823,6 @@ static int wq_numa_callback(struct notifier_block *self,
 
 static void __init wq_numa_init(void)
 {
-	cpumask_var_t *tbl;
-	int node, cpu;
-
 	if (num_possible_nodes() <= 1)
 		return;
 
@@ -4842,29 +4834,6 @@ static void __init wq_numa_init(void)
 	wq_update_unbound_numa_attrs_buf = alloc_workqueue_attrs(GFP_KERNEL);
 	BUG_ON(!wq_update_unbound_numa_attrs_buf);
 
-	/*
-	 * We want masks of possible CPUs of each node which isn't readily
-	 * available.  Build one from cpu_to_node() which should have been
-	 * fully initialized by now.
-	 */
-	tbl = kzalloc(nr_node_ids * sizeof(tbl[0]), GFP_KERNEL);
-	BUG_ON(!tbl);
-
-	for_each_node(node)
-		BUG_ON(!zalloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
-				node_online(node) ? node : NUMA_NO_NODE));
-
-	for_each_possible_cpu(cpu) {
-		node = cpu_to_node(cpu);
-		if (WARN_ON(node == NUMA_NO_NODE)) {
-			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
-			/* happens iff arch is bonkers, let's just proceed */
-			return;
-		}
-		cpumask_set_cpu(cpu, tbl[node]);
-	}
-
-	wq_numa_possible_cpumask = tbl;
 	hotplug_memory_notifier(wq_numa_callback, 0);
 	wq_numa_enabled = true;
 }
-- 
2.1.0

