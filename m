Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaEVMaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:30:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEVMaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:30:09 -0400
Date: Thu, 22 May 2014 05:29:12 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-b1ad065e65f56103db8b97edbd218a271ff5b1bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140515130306.61aae7db@cuia.bos.redhat.com>
References: <20140515130306.61aae7db@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Update migrate_improves/
 degrades_locality()
Git-Commit-ID: b1ad065e65f56103db8b97edbd218a271ff5b1bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1ad065e65f56103db8b97edbd218a271ff5b1bb
Gitweb:     http://git.kernel.org/tip/b1ad065e65f56103db8b97edbd218a271ff5b1bb
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 15 May 2014 13:03:06 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:39 +0200

sched/numa: Update migrate_improves/degrades_locality()

Update the migrate_improves/degrades_locality() functions with
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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Link: http://lkml.kernel.org/r/20140515130306.61aae7db@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b899613..503f750 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5123,6 +5123,7 @@ task_hot(struct task_struct *p, u64 now)
 /* Returns true if the destination node has incurred more faults */
 static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 {
+	struct numa_group *numa_group = rcu_dereference(p->numa_group);
 	int src_nid, dst_nid;
 
 	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
@@ -5136,21 +5137,29 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
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
+	struct numa_group *numa_group = rcu_dereference(p->numa_group);
 	int src_nid, dst_nid;
 
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
@@ -5165,16 +5174,23 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
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
