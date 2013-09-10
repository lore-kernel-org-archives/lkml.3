Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3IJJeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab3IJJdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:33:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 46/50] sched: numa: Prevent parallel updates to group stats during placement
Date: Tue, 10 Sep 2013 10:32:26 +0100
Message-Id: <1378805550-29949-47-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
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
index 3a92c58..4653f71 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1231,6 +1231,7 @@ static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
+	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
@@ -1239,6 +1240,12 @@ static void task_numa_placement(struct task_struct *p)
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
@@ -1277,20 +1284,24 @@ static void task_numa_placement(struct task_struct *p)
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

