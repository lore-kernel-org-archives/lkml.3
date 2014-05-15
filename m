Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaEORGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:06:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaEORGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:06:18 -0400
Date: Thu, 15 May 2014 13:03:06 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org
Subject: [PATCH] sched,numa: update migrate_improves/degrades_locality
Message-ID: <20140515130306.61aae7db@cuia.bos.redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the migrate_improves/degrades_locality functions with
knowledge of pseudo-interleaving.

Do not consider moving tasks around within the set of group's active
nodes as improving or degrading locality. Instead, leave the load
balancer free to balance the load between a numa_group's active nodes.

Also, switch from the group/task_weight functions to the group/task_fault
functions. The "weight" functions involve a division, but both calls use
the same divisor, so there's no point in doing that from these functions.

On a 4 node (x10 core) system, performance of SPECjbb2005 seems
unaffected, though the number of migrations with 2 8-warehouse wide
instances seems to have almost halved, due to the scheduler running
each instance on a single node.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6504015..4f01e2f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4971,6 +4971,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 /* Returns true if the destination node has incurred more faults */
 static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 {
+	struct numa_group *numa_group = ACCESS_ONCE(p->numa_group);
 	int src_nid, dst_nid;
 
 	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
@@ -4984,21 +4985,29 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	if (src_nid == dst_nid)
 		return false;
 
-	/* Always encourage migration to the preferred node. */
-	if (dst_nid == p->numa_preferred_nid)
-		return true;
+	if (numa_group) {
+		/* Task is already in the group's interleave set. */
+		if (node_isset(src_nid, numa_group->active_nodes))
+			return false;	
+
+		/* Task is moving into the group's interleave set. */
+		if (node_isset(dst_nid, numa_group->active_nodes))
+			return true;
 
-	/* If both task and group weight improve, this move is a winner. */
-	if (task_weight(p, dst_nid) > task_weight(p, src_nid) &&
-	    group_weight(p, dst_nid) > group_weight(p, src_nid))
+		return group_faults(p, dst_nid) > group_faults(p, src_nid);
+	}
+
+	/* Encourage migration to the preferred node. */
+	if (dst_nid == p->numa_preferred_nid)
 		return true;
 
-	return false;
+	return task_faults(p, dst_nid) > task_faults(p, src_nid);
 }
 
 
 static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 {
+	struct numa_group *numa_group = ACCESS_ONCE(p->numa_group);
 	int src_nid, dst_nid;
 
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
@@ -5013,16 +5022,23 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (src_nid == dst_nid)
 		return false;
 
+	if (numa_group) {
+		/* Task is moving within/into the group's interleave set. */
+		if (node_isset(dst_nid, numa_group->active_nodes))
+			return false;
+
+		/* Task is moving out of the group's interleave set. */
+		if (node_isset(src_nid, numa_group->active_nodes))
+			return true;	
+
+		return group_faults(p, dst_nid) < group_faults(p, src_nid);
+	}
+
 	/* Migrating away from the preferred node is always bad. */
 	if (src_nid == p->numa_preferred_nid)
 		return true;
 
-	/* If either task or group weight get worse, don't do it. */
-	if (task_weight(p, dst_nid) < task_weight(p, src_nid) ||
-	    group_weight(p, dst_nid) < group_weight(p, src_nid))
-		return true;
-
-	return false;
+	return task_faults(p, dst_nid) < task_faults(p, src_nid);
 }
 
 #else

