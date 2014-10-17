Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaJQHaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:30:10 -0400
Received: from shelob.surriel.com ([74.92.59.67]:35997 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaJQHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:30:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mingo@redhat.com,
        mgorman@suse.de
Subject: [PATCH 4/6] sched,numa: calculate node scores in complex NUMA topologies
Date: Fri, 17 Oct 2014 03:29:52 -0400
Message-Id: <1413530994-9732-5-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413530994-9732-1-git-send-email-riel@redhat.com>
References: <1413530994-9732-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

In order to do task placement on systems with complex NUMA topologies,
it is necessary to count the faults on nodes nearby the node that is
being examined for a potential move.

In case of a system with a backplane interconnect, we are dealing with
groups of NUMA nodes; each of the nodes within a group is the same number
of hops away from nodes in other groups in the system. Optimal placement
on this topology is achieved by counting all nearby nodes equally. When
comparing nodes A and B at distance N, nearby nodes are those at distances
smaller than N from nodes A or B.

Placement strategy on a system with a glueless mesh NUMA topology needs
to be different, because there are no natural groups of nodes determined
by the hardware. Instead, when dealing with two nodes A and B at distance
N, N >= 2, there will be intermediate nodes at distance < N from both nodes
A and B. Good placement can be achieved by right shifting the faults on
nearby nodes by the number of hops from the node being scored. In this
context, a nearby node is any node less than the maximum distance in the
system away from the node. Those nodes are skipped for efficiency reasons,
there is no real policy reason to do so.

Placement policy on directly connected NUMA systems is not affected.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1c540f5..6df460f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -924,6 +924,71 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 		group->faults_cpu[task_faults_idx(nid, 1)];
 }
 
+/* Handle placement on systems where not all nodes are directly connected. */
+static unsigned long score_nearby_nodes(struct task_struct *p, int nid,
+					int maxdist, bool task)
+{
+	unsigned long score = 0;
+	int node;
+
+	/*
+	 * All nodes are directly connected, and the same distance
+	 * from each other. No need for fancy placement algorithms.
+	 */
+	if (sched_numa_topology_type == NUMA_DIRECT)
+		return 0;
+
+	/*
+	 * This code is called for each node, introducing N^2 complexity,
+	 * which should be ok given the number of nodes rarely exceeds 8.
+	 */
+	for_each_online_node(node) {
+		unsigned long faults;
+		int dist = node_distance(nid, node);
+
+		/*
+		 * The furthest away nodes in the system are not interesting
+		 * for placement; nid was already counted.
+		 */
+		if (dist == sched_max_numa_distance || node == nid)
+			continue;
+
+		/*
+		 * On systems with a backplane NUMA topology, compare groups
+		 * of nodes, and move tasks towards the group with the most
+		 * memory accesses. When comparing two nodes at distance
+		 * "hoplimit", only nodes closer by than "hoplimit" are part
+		 * of each group. Skip other nodes.
+		 */
+		if (sched_numa_topology_type == NUMA_BACKPLANE &&
+					dist > maxdist)
+			continue;
+
+		/* Add up the faults from nearby nodes. */
+		if (task)
+			faults = task_faults(p, node);
+		else
+			faults = group_faults(p, node);
+
+		/*
+		 * On systems with a glueless mesh NUMA topology, there are
+		 * no fixed "groups of nodes". Instead, nodes that are not
+		 * directly connected bounce traffic through intermediate
+		 * nodes; a numa_group can occupy any set of nodes.
+		 * The further away a node is, the less the faults count.
+		 * This seems to result in good task placement.
+		 */
+		if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
+			faults *= (sched_max_numa_distance - dist);
+			faults /= (sched_max_numa_distance - LOCAL_DISTANCE);
+		}
+
+		score += faults;
+	}
+
+	return score;
+}
+
 /*
  * These return the fraction of accesses done by a particular task, or
  * task group, on a particular numa node.  The group weight is given a
@@ -944,6 +1009,8 @@ static inline unsigned long task_weight(struct task_struct *p, int nid,
 		return 0;
 
 	faults = task_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, dist, true);
+
 	return 1000 * faults / total_faults;
 }
 
@@ -961,6 +1028,8 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
 		return 0;
 
 	faults = group_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, dist, false);
+
 	return 1000 * faults / total_faults;
 }
 
@@ -1363,6 +1432,11 @@ static int task_numa_migrate(struct task_struct *p)
 				continue;
 
 			dist = node_distance(env.src_nid, env.dst_nid);
+			if (sched_numa_topology_type == NUMA_BACKPLANE &&
+						dist != env.dist) {
+				taskweight = task_weight(p, env.src_nid, dist);
+				groupweight = group_weight(p, env.src_nid, dist);
+			}
 
 			/* Only consider nodes where both task and groups benefit */
 			taskimp = task_weight(p, nid, dist) - taskweight;
-- 
1.9.3

