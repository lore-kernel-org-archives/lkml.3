Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaJHTit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:38:49 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34515 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaJHTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:38:05 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: [PATCH RFC 4/5] sched,numa: calculate node scores in complex NUMA topologies
Date: Wed,  8 Oct 2014 15:37:29 -0400
Message-Id: <1412797050-8903-5-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412797050-8903-1-git-send-email-riel@redhat.com>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
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
---
 kernel/sched/fair.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8b3f884..fb22caf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -924,6 +924,65 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 		group->faults_cpu[task_faults_idx(nid, 1)];
 }
 
+/* Handle placement on systems where not all nodes are directly connected. */
+static unsigned long score_nearby_nodes(struct task_struct *p, int nid,
+					int hoplimit, bool task)
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
+	for_each_online_node(node) {
+		unsigned long faults;
+		int hops = node_hops(nid, node);
+
+		/*
+		 * The furthest away nodes in the system are not interesting
+		 * for placement; nid was already counted.
+		 */
+		if (hops == sched_domains_numa_levels || node == nid)
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
+					hops >= hoplimit)
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
+		 * nodes; a numa_group can occupy any set of nodes. Counting
+		 * the faults on nearby hops progressively less as distance
+		 * increases seems to result in good task placement.
+		 */
+		if (sched_numa_topology_type == NUMA_GLUELESS_MESH)
+			faults >>= hops;
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
@@ -944,6 +1003,8 @@ static inline unsigned long task_weight(struct task_struct *p, int nid,
 		return 0;
 
 	faults = task_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, hops, true);
+
 	return 1000 * faults / total_faults;
 }
 
@@ -961,6 +1022,8 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
 		return 0;
 
 	faults = group_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, hops, false);
+
 	return 1000 * faults / total_faults;
 }
 
@@ -1363,6 +1426,11 @@ static int task_numa_migrate(struct task_struct *p)
 				continue;
 
 			hops = node_hops(env.src_nid, env.dst_nid);
+			if (sched_numa_topology_type == NUMA_BACKPLANE &&
+						hops != env.hops) {
+				taskweight = task_weight(p, env.src_nid, hops);
+				groupweight = group_weight(p, env.src_nid, hops);
+			}
 
 			/* Only consider nodes where both task and groups benefit */
 			taskimp = task_weight(p, nid, hops) - taskweight;
-- 
1.9.3

