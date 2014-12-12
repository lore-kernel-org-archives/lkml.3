Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972AbaLLKQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:22 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:51296 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965640AbaLLKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:16 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44952093"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 3/5] workqueue: fixup existing pool->node
Date: Fri, 12 Dec 2014 18:19:53 +0800
Message-ID: <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasuaki Ishimatsu hit a bug when the numa mapping between CPU and node
is changed.  And the previous path fixup wq_numa_possible_cpumask.
(See more information form the changelog of that patch)

After wq_numa_possible_cpumask was updated, the new pool->node will be
correct, but the existing pools (and workers) are still running, some of
them are running with the wrong pool->node, or even worse, with pool->node
which is quitted node, they create_worker() on wrong pool->node.
These create_worker() may create workers on wrong node or failed without
any progress (when with pool->node which is quitted node).

So we need to update the pool->node when the numa mapping is changed.

We simply re-calc the pool->node when the numa mapping changed. It reuses
the code from get_unbound_pool() for unbound pool.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   53 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4c88b61..7fbabf6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3439,6 +3439,26 @@ static void put_unbound_pool(struct worker_pool *pool)
 	call_rcu_sched(&pool->rcu, rcu_free_pool);
 }
 
+static int calc_pool_node(struct worker_pool *pool)
+{
+	int node;
+
+	if (pool->cpu >= 0)
+		return cpu_to_node(pool->cpu);
+
+	/* if cpumask is contained inside a NUMA node, we belong to that node */
+	if (wq_numa_enabled) {
+		for_each_node(node) {
+			if (cpumask_subset(pool->attrs->cpumask,
+					   wq_numa_possible_cpumask[node])) {
+				return node;
+			}
+		}
+	}
+
+	return NUMA_NO_NODE;
+}
+
 /**
  * get_unbound_pool - get a worker_pool with the specified attributes
  * @attrs: the attributes of the worker_pool to get
@@ -3457,7 +3477,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
-	int node;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
@@ -3482,17 +3501,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
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
+	pool->node = calc_pool_node(pool);
 
 	if (worker_pool_assign_id(pool) < 0)
 		goto fail;
@@ -3952,6 +3961,8 @@ out_unlock:
 static void wq_update_numa_mapping(int cpu)
 {
 	int node, orig_node = NUMA_NO_NODE, new_node = cpu_to_node(cpu);
+	struct worker_pool *pool;
+	int pi;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
@@ -3985,6 +3996,17 @@ static void wq_update_numa_mapping(int cpu)
 		else if (orig_node != NUMA_NO_NODE && node == orig_node)
 			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[orig_node]);
 	}
+
+	/*
+	 * Fixup pool->node, it needs to test for all pools, pool->node might be
+	 * changed from orig_node to new_node or from new_node to NUMA_NO_NODE
+	 * or NUMA_NO_NODE to orig_node or some other possibilities.
+	 */
+	for_each_pool(pool, pi) {
+		node = calc_pool_node(pool);
+		if (pool->node != node)
+			pool->node = node;
+	}
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
@@ -4614,10 +4636,13 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->attach_mutex);
 
-			if (pool->cpu == cpu)
+			if (pool->cpu == cpu) {
+				if (unlikely(pool->node != cpu_to_node(cpu)))
+					pool->node = cpu_to_node(cpu);
 				rebind_workers(pool);
-			else if (pool->cpu < 0)
+			} else if (pool->cpu < 0) {
 				restore_unbound_workers_cpumask(pool, cpu);
+			}
 
 			mutex_unlock(&pool->attach_mutex);
 		}
-- 
1.7.4.4

