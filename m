Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaJQHaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:30:21 -0400
Received: from shelob.surriel.com ([74.92.59.67]:35975 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaJQHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:30:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mingo@redhat.com,
        mgorman@suse.de
Subject: [PATCH 5/6] sched,numa: find the preferred nid with complex NUMA topology
Date: Fri, 17 Oct 2014 03:29:53 -0400
Message-Id: <1413530994-9732-6-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413530994-9732-1-git-send-email-riel@redhat.com>
References: <1413530994-9732-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

On systems with complex NUMA topologies, the node scoring is adjusted
to allow workloads to converge on nodes that are near each other.

The way a task group's preferred nid is determined needs to be adjusted,
in order for the preferred_nid to be consistent with group_weight scoring.
This ensures that we actually try to converge workloads on adjacent nodes.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6df460f..b973d77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1648,6 +1648,92 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 	return delta;
 }
 
+/*
+ * Determine the preferred nid for a task in a numa_group. This needs to
+ * be done in a way that produces consistent results with group_weight,
+ * otherwise workloads might not converge.
+ */ 
+static int preferred_group_nid(struct task_struct *p, int nid)
+{
+	nodemask_t nodes;
+	int dist;
+
+	/* Direct connections between all NUMA nodes. */
+	if (sched_numa_topology_type == NUMA_DIRECT)
+		return nid;
+
+	/*
+	 * On a system with glueless mesh NUMA topology, group_weight
+	 * scores nodes according to the number of NUMA hinting faults on
+	 * both the node itself, and on nearby nodes.
+	 */
+	if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
+		unsigned long score, max_score = 0;
+		int node, max_node = nid;
+
+		dist = sched_max_numa_distance;
+
+		for_each_online_node(node) {
+			score = group_weight(p, node, dist);
+			if (score > max_score) {
+				max_score = score;
+				max_node = node;
+			}
+		}
+		return max_node;
+	}
+
+	/*
+	 * Finding the preferred nid in a system with NUMA backplane
+	 * interconnect topology is more involved. The goal is to locate
+	 * tasks from numa_groups near each other in the system, and
+	 * untangle workloads from different sides of the system. This requires
+	 * searching down the hierarchy of node groups, recursively searching
+	 * inside the highest scoring group of nodes. The nodemask tricks
+	 * keep the complexity of the search down.
+	 */
+	nodes = node_online_map;
+	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
+		unsigned long max_faults = 0;
+		nodemask_t max_group;
+		int a, b;
+
+		/* Are there nodes at this distance from each other? */
+		if (!find_numa_distance(dist))
+			continue;
+
+		for_each_node_mask(a, nodes) {
+			unsigned long faults = 0;
+			nodemask_t this_group;
+			nodes_clear(this_group);
+
+			/* Sum group's NUMA faults; includes a==b case. */
+			for_each_node_mask(b, nodes) {
+				if (node_distance(a, b) < dist) {
+					faults += group_faults(p, b);
+					node_set(b, this_group);
+					node_clear(b, nodes);
+				}
+			}
+
+			/* Remember the top group. */
+			if (faults > max_faults) {
+				max_faults = faults;
+				max_group = this_group;
+				/*
+				 * subtle: at the smallest distance there is
+				 * just one node left in each "group", the
+				 * winner is the preferred nid.
+				 */
+				nid = a;
+			}
+		}
+		/* Next round, evaluate the nodes within max_group. */
+		nodes = max_group;
+	}
+	return nid;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
@@ -1730,7 +1816,7 @@ static void task_numa_placement(struct task_struct *p)
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
 		spin_unlock_irq(group_lock);
-		max_nid = max_group_nid;
+		max_nid = preferred_group_nid(p, max_group_nid);
 	}
 
 	if (max_faults) {
-- 
1.9.3

