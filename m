Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3C1GrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:47:24 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40321 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3C1GoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:12 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] workqueue: add wq_numa_tbl_len and wq_numa_possible_cpumask[]
Date: Wed, 27 Mar 2013 23:43:28 -0700
Message-Id: <1364453020-2829-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound workqueues are going to be NUMA-affine.  Add wq_numa_tbl_len
and wq_numa_possible_cpumask[] in preparation.  The former is the
highest NUMA node ID + 1 and the latter is masks of possibles CPUs for
each NUMA node.

This patch only introduces these.  Future patches will make use of
them.

v2: NUMA initialization move into wq_numa_init().  Also, the possible
    cpumask array is not created if there aren't multiple nodes on the
    system.  wq_numa_enabled bool added.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 26771f4e..54b5048 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -44,6 +44,7 @@
 #include <linux/jhash.h>
 #include <linux/hashtable.h>
 #include <linux/rculist.h>
+#include <linux/nodemask.h>
 
 #include "workqueue_internal.h"
 
@@ -253,6 +254,12 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
+static int wq_numa_tbl_len;		/* highest possible NUMA node id + 1 */
+static cpumask_var_t *wq_numa_possible_cpumask;
+					/* possible CPUs of each node */
+
+static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
+
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
@@ -4402,6 +4409,43 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */
 
+static void __init wq_numa_init(void)
+{
+	cpumask_var_t *tbl;
+	int node, cpu;
+
+	/* determine NUMA pwq table len - highest node id + 1 */
+	for_each_node(node)
+		wq_numa_tbl_len = max(wq_numa_tbl_len, node + 1);
+
+	if (num_possible_nodes() <= 1)
+		return;
+
+	/*
+	 * We want masks of possible CPUs of each node which isn't readily
+	 * available.  Build one from cpu_to_node() which should have been
+	 * fully initialized by now.
+	 */
+	tbl = kzalloc(wq_numa_tbl_len * sizeof(tbl[0]), GFP_KERNEL);
+	BUG_ON(!tbl);
+
+	for_each_node(node)
+		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL, node));
+
+	for_each_possible_cpu(cpu) {
+		node = cpu_to_node(cpu);
+		if (WARN_ON(node == NUMA_NO_NODE)) {
+			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
+			/* happens iff arch is bonkers, let's just proceed */
+			return;
+		}
+		cpumask_set_cpu(cpu, tbl[node]);
+	}
+
+	wq_numa_possible_cpumask = tbl;
+	wq_numa_enabled = true;
+}
+
 static int __init init_workqueues(void)
 {
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
@@ -4418,6 +4462,8 @@ static int __init init_workqueues(void)
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
+	wq_numa_init();
+
 	/* initialize CPU pools */
 	for_each_possible_cpu(cpu) {
 		struct worker_pool *pool;
-- 
1.8.1.4

