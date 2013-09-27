Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3I0Ndt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:33:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab3I0N2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:40 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 51/63] sched: numa: Prevent parallel updates to group stats during placement
Date: Fri, 27 Sep 2013 14:27:36 +0100
Message-Id: <1380288468-5551-52-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having multiple tasks in a group go through task_numa_placement
simultaneously can lead to a task picking a wrong node to run on, because
the group stats may be in the middle of an update. This patch avoids
parallel updates by holding the numa_group lock during placement
decisions.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5237feb..86511a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1233,6 +1233,7 @@ static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
+	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
@@ -1241,6 +1242,12 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_migrate_seq++;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	/* If the task is part of a group prevent parallel updates to group stats */
+	if (p->numa_group) {
+		group_lock = &p->numa_group->lock;
+		spin_lock(group_lock);
+	}
+
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
 		unsigned long faults = 0, group_faults = 0;
@@ -1279,20 +1286,24 @@ static void task_numa_placement(struct task_struct *p)
 		}
 	}
 
-	/*
-	 * If the preferred task and group nids are different,
-	 * iterate over the nodes again to find the best place.
-	 */
-	if (p->numa_group && max_nid != max_group_nid) {
-		unsigned long weight, max_weight = 0;
-
-		for_each_online_node(nid) {
-			weight = task_weight(p, nid) + group_weight(p, nid);
-			if (weight > max_weight) {
-				max_weight = weight;
-				max_nid = nid;
+	if (p->numa_group) {
+		/*
+		 * If the preferred task and group nids are different,
+		 * iterate over the nodes again to find the best place.
+		 */
+		if (max_nid != max_group_nid) {
+			unsigned long weight, max_weight = 0;
+
+			for_each_online_node(nid) {
+				weight = task_weight(p, nid) + group_weight(p, nid);
+				if (weight > max_weight) {
+					max_weight = weight;
+					max_nid = nid;
+				}
 			}
 		}
+
+		spin_unlock(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
-- 
1.8.1.4

