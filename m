Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaLOLOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:14:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53682 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaLOLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:14:45 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548EC29A.5080008@jp.fujitsu.com>
Date: Mon, 15 Dec 2014 20:14:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 1/4] workqueue:Fix unbound workqueue's node affinity detection
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com>
In-Reply-To: <548EC1E2.1010101@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound wq pool's node attribute is calculated at its allocation.
But it's now calculated based on possible cpu<->node information
which can be wrong after cpu hotplug/unplug.

If wrong pool->node is set, following allocation error will happen.
==
 SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
  cache: kmalloc-192, object size: 192, buffer size: 192, default order:
1, min order: 0
  node 0: slabs: 6172, objs: 259224, free: 245741
  node 1: slabs: 3261, objs: 136962, free: 127656
==

This patch fixes the node detection by making use of online cpu info.
Unlike cpumask, the best node can be calculated by degree of overlap
between attr->cpumask and numanode->online_cpumask.
This change doesn't corrupt original purpose of the old calculation.

Note: it's expected that this function is called as
      pool_detect_best_node
      get_unbound_pool
      alloc_unbound_pwq
      wq_update_unbound_numa
      called at CPU_ONLINE/CPU_DOWN_PREPARE
and the latest online cpu info can be applied to a new wq pool,
which replaces old one.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685d..7809154 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3440,6 +3440,31 @@ static void put_unbound_pool(struct worker_pool *pool)
 }
 
 /**
+ * pool_detect_best_node - detect a node which contains specified cpumask.
+ * Should be called with wq_pool_mutex held.
+ * Returns a online node where the most of given cpus are tied to. 
+ */
+static int pool_detect_best_node(const struct cpumask *cpumask)
+{
+	int node, best, match, selected = NUMA_NO_NODE;
+	static struct cpumask andmask; /* under wq_pool_mutex */
+
+	if (!wq_numa_enabled ||
+		cpumask_subset(cpu_online_mask, cpumask))
+		goto out;
+	best = 0;
+	/* select a node which contains the most number of cpu */
+	for_each_node_state(node, N_ONLINE) {
+		cpumask_and(&andmask, cpumask, cpumask_of_node(node));
+		match = cpumask_weight(&andmask);
+		if (match > best)
+			selected = best;
+	}
+out:
+	return selected;
+}
+
+/**
  * get_unbound_pool - get a worker_pool with the specified attributes
  * @attrs: the attributes of the worker_pool to get
  *
@@ -3457,7 +3482,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
-	int node;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
@@ -3482,17 +3506,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	 * 'struct workqueue_attrs' comments for detail.
 	 */
 	pool->attrs->no_numa = false;
-
-	/* if cpumask is contained inside a NUMA node, we belong to that node */
-	if (wq_numa_enabled) {
-		for_each_node(node) {
-			if (cpumask_subset(pool->attrs->cpumask,
-					   wq_numa_possible_cpumask[node])) {
-				pool->node = node;
-				break;
-			}
-		}
-	}
+	pool->node = pool_detect_best_node(pool->attrs->cpumask);
 
 	if (worker_pool_assign_id(pool) < 0)
 		goto fail;
-- 
1.8.3.1



