Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaEHRXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:23:46 -0400
Received: from shelob.surriel.com ([74.92.59.67]:53760 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaEHRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:23:41 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 4/4] sched,numa: pull workloads towards their preferred nodes
Date: Thu,  8 May 2014 13:23:31 -0400
Message-Id: <1399569811-14362-5-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1399569811-14362-1-git-send-email-riel@redhat.com>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Give a bonus to nodes near a workload's preferred node. This will pull
workloads towards their preferred node.

For workloads that span multiple NUMA nodes, pseudo-interleaving will
even out the memory use between nodes over time, causing the preferred
node to move around over time.

This movement over time will cause the preferred nodes to be on opposite
sides of the system eventually, untangling workloads that were spread
all over the system, and moving them onto adjacent nodes.

The perturbation introduced by this patch enables the kernel to
reliably untangled 2 4-node wide SPECjbb2005 instances on an 8 node
system, improving average performance from 857814 to 931792 bops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 99cc829..cffa829 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -932,7 +932,7 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
  * the proximity of those nodes.
  */
 static inline unsigned long nearby_nodes_score(struct task_struct *p, int nid,
-						bool task)
+						bool task, bool *preferred_nid)
 {
 	int max_distance = max_node_distance();
 	unsigned long score = 0;
@@ -949,6 +949,15 @@ static inline unsigned long nearby_nodes_score(struct task_struct *p, int nid,
 		int distance;
 		unsigned long faults;
 
+		/*
+		 * Pseudo-interleaving balances out the memory use between the
+		 * nodes where a workload runs, so the preferred node should
+		 * change over time. This helps separate two workloads onto
+		 * separate sides of the system.
+		 */
+		if (p->numa_group && node == p->numa_group->preferred_nid)
+			*preferred_nid = true;
+
 		/* Already scored by the calling function. */
 		if (node == nid)
 			continue;
@@ -989,6 +998,7 @@ static inline unsigned long nearby_nodes_score(struct task_struct *p, int nid,
 static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
 	unsigned long total_faults, score;
+	bool near_preferred_nid = false;
 
 	if (!p->numa_faults_memory)
 		return 0;
@@ -999,7 +1009,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 		return 0;
 
 	score = 1000 * task_faults(p, nid);
-	score += nearby_nodes_score(p, nid, true);
+	score += nearby_nodes_score(p, nid, true, &near_preferred_nid);
 
 	score /= total_faults;
 
@@ -1009,6 +1019,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 static inline unsigned long group_weight(struct task_struct *p, int nid)
 {
 	unsigned long total_faults, score;
+	bool near_preferred_nid = false;
 
 	if (!p->numa_group)
 		return 0;
@@ -1019,7 +1030,15 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 		return 0;
 
 	score = 1000 * group_faults(p, nid);
-	score += nearby_nodes_score(p, nid, false);
+	score += nearby_nodes_score(p, nid, false, &near_preferred_nid);
+
+	/*
+	 * Pull workloads towards their preferred node, with the minimum
+	 * multiplier required to be a tie-breaker when two groups of nodes
+	 * have the same amount of memory.
+	 */
+	if (near_preferred_nid)
+		score *= (max_node_distance() - LOCAL_DISTANCE);
 
 	score /= total_faults;
 
-- 
1.8.5.3

