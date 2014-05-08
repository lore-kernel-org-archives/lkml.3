Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaEHRXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:23:44 -0400
Received: from shelob.surriel.com ([74.92.59.67]:53763 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:23:41 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on complex NUMA topologies
Date: Thu,  8 May 2014 13:23:29 -0400
Message-Id: <1399569811-14362-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1399569811-14362-1-git-send-email-riel@redhat.com>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Workloads that span multiple NUMA nodes benefit greatly from being placed
on nearby nodes. There are two common configurations on 8 node NUMA systems.
One has four "islands" of 2 tighly coupled nodes, another has two "islands"
of 4 tightly coupled nodes.

When dealing with 2 4-node wide workloads on such a system, the current
NUMA code relies on luck. When a workload is placed on adjacent nodes,
performance is great. When a workload is spread across far-away nodes,
performance sucks.

This patch adjusts the numa scores of each node by adding the scores
of nearby nodes, weighted by the NUMA distance. This results in workloads
being pulled together on nearby nodes, and improved performance for
workloads that span multiple nodes, on larger NUMA systems.

This patch does nothing on machines with simple NUMA topologies.

On an 8 node system, this patch manages to correctly place 2 4-node wide
SPECjbb2005 instances on adjacent nodes around 80% of the time, improving
average performance from 857814 to 926054 bops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 302facf..5925667 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -923,6 +923,63 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 }
 
 /*
+ * On systems with complex NUMA topology, we deal with the local node,
+ * far-away nodes, and nodes that are somewhere in-between. The goal is
+ * to pull workloads that span multiple nodes to nodes that are near each
+ * other. This is accomplished adding calculating a score for nearby nodes,
+ * to the local node score, based on the faults on those nearby nodes, and
+ * the proximity of those nodes.
+ */
+static inline unsigned long nearby_nodes_score(struct task_struct *p, int nid,
+						bool task)
+{
+	int max_distance = max_node_distance();
+	unsigned long score = 0;
+	int node;
+
+	/*
+	 * No need to calculate a score if the system has a simple NUMA
+	 * topology, with no node distances between "local" and "far away".
+	 */
+	if (max_distance == LOCAL_DISTANCE)
+		return 0;
+
+	for_each_online_node(node) {
+		int distance;
+		unsigned long faults;
+
+		/* Already scored by the calling function. */
+		if (node == nid)
+			continue;
+
+		/* Skip far-away nodes. We only care about nearby ones. */
+		distance = node_distance(node, nid);
+		if (distance == max_distance)
+			continue;
+
+		/*
+		 * For nodes with distances in-between LOCAL_DISTANCE
+		 * and max_distance, we count the faults on those nodes
+		 * in proportion to their distance, using this formula:
+		 *
+		 * max_distance - node_distance
+		 * -----------------------------
+		 * max_distance - LOCAL_DISTANCE
+		 */
+		if (task)
+			faults = task_faults(p, node);
+		else
+			faults = group_faults(p, node);
+
+		score += 1000 * faults *
+				(max_distance - distance) /
+				(max_distance - LOCAL_DISTANCE);
+	}
+
+	return score;
+}
+
+/*
  * These return the fraction of accesses done by a particular task, or
  * task group, on a particular numa node.  The group weight is given a
  * larger multiplier, in order to group tasks together that are almost
@@ -930,7 +987,7 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
  */
 static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
-	unsigned long total_faults;
+	unsigned long total_faults, score;
 
 	if (!p->numa_faults_memory)
 		return 0;
@@ -940,15 +997,32 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	score = 1000 * task_faults(p, nid);
+	score += nearby_nodes_score(p, nid, true);
+
+	score /= total_faults;
+
+	return score;
 }
 
 static inline unsigned long group_weight(struct task_struct *p, int nid)
 {
-	if (!p->numa_group || !p->numa_group->total_faults)
+	unsigned long total_faults, score;
+
+	if (!p->numa_group)
+		return 0;
+
+	total_faults = p->numa_group->total_faults;
+
+	if (!total_faults)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+	score = 1000 * group_faults(p, nid);
+	score += nearby_nodes_score(p, nid, false);
+
+	score /= total_faults;
+
+	return score;
 }
 
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
-- 
1.8.5.3

