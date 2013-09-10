Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3IJJd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:33:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3IJJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:33:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 49/50] sched: numa: fix task or group comparison
Date: Tue, 10 Sep 2013 10:32:29 +0100
Message-Id: <1378805550-29949-50-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

This patch should probably be folded into

commit 77e0ecbbc5cf0a84764be88b9de5ff13e4338163
Author: Rik van Riel <riel@redhat.com>
Date:   Tue Aug 27 21:52:47 2013 +0100

    sched: numa: Decide whether to favour task or group weights based on swap candidate relationships

This patch separately considers task and group affinities when
searching for swap candidates during NUMA placement. If tasks
are part of the same group, or no group at all, the task weights
are considered.

Some hysteresis is added to prevent tasks within one group from
getting bounced between NUMA nodes due to tiny differences.

If tasks are part of different groups, the code compares group
weights, in order to favor grouping task groups together.

The patch also changes the group weight multiplier to be the
same as the task weight multiplier, since the two are no longer
added up like before.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fdb7923..ac7184d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -962,7 +962,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1200 * group_faults(p, nid) / total_faults;
+	return 1000 * group_faults(p, nid) / total_faults;
 }
 
 static unsigned long weighted_cpuload(const int cpu);
@@ -1068,16 +1068,34 @@ static void task_numa_compare(struct task_numa_env *env,
 
 		/*
 		 * If dst and source tasks are in the same NUMA group, or not
-		 * in any group then look only at task weights otherwise give
-		 * priority to the group weights.
+		 * in any group then look only at task weights.
 		 */
-		if (!cur->numa_group || ! env->p->numa_group ||
-		    cur->numa_group == env->p->numa_group) {
+		if (cur->numa_group == env->p->numa_group) {
 			imp = taskimp + task_weight(cur, env->src_nid) -
 			      task_weight(cur, env->dst_nid);
+			/*
+			 * Add some hysteresis to prevent swapping the
+			 * tasks within a group over tiny differences.
+			 */
+			if (cur->numa_group)
+				imp -= imp/16;
 		} else {
-			imp = groupimp + group_weight(cur, env->src_nid) -
-			       group_weight(cur, env->dst_nid);
+			/*
+			 * Compare the group weights. If a task is all by
+			 * itself (not part of a group), use the task weight
+			 * instead.
+			 */
+			if (env->p->numa_group)
+				imp = groupimp;
+			else
+				imp = taskimp;
+
+			if (cur->numa_group)
+				imp += group_weight(cur, env->src_nid) -
+				       group_weight(cur, env->dst_nid);
+			else
+				imp += task_weight(cur, env->src_nid) -
+				       task_weight(cur, env->dst_nid);
 		}
 	}
 
-- 
1.8.1.4

