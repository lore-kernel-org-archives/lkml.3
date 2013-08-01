Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3HAGYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:24:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3HAGYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:24:01 -0400
Date: Thu, 1 Aug 2013 02:23:19 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH,RFC] numa,sched: use group fault statistics in numa
 placement
Message-ID: <20130801022319.4a6a977a@annuminas.surriel.com>
In-Reply-To: <20130730113857.GR3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
	<20130730113857.GR3008@twins.programming.kicks-ass.net>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH,RFC] numa,sched: use group fault statistics in numa placement

Here is a quick strawman on how the group fault stuff could be used
to help pick the best node for a task. This is likely to be quite
suboptimal and in need of tweaking. My main goal is to get this to
Peter & Mel before it's breakfast time on their side of the Atlantic...

This goes on top of "sched, numa: Use {cpu, pid} to create task groups for shared faults"

Enjoy :)

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6a06bef..fb2e229 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1135,8 +1135,9 @@ struct numa_group {
 
 static void task_numa_placement(struct task_struct *p)
 {
-	int seq, nid, max_nid = -1;
-	unsigned long max_faults = 0;
+	int seq, nid, max_nid = -1, max_group_nid = -1;
+	unsigned long max_faults = 0, max_group_faults = 0;
+	unsigned long total_faults = 0, total_group_faults = 0;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
@@ -1148,7 +1149,7 @@ static void task_numa_placement(struct task_struct *p)
 
 	/* Find the node with the highest number of faults */
 	for (nid = 0; nid < nr_node_ids; nid++) {
-		unsigned long faults = 0;
+		unsigned long faults = 0, group_faults = 0;
 		int priv, i;
 
 		for (priv = 0; priv < 2; priv++) {
@@ -1169,6 +1170,7 @@ static void task_numa_placement(struct task_struct *p)
 			if (p->numa_group) {
 				/* safe because we can only change our own group */
 				atomic_long_add(diff, &p->numa_group->faults[i]);
+				group_faults += atomic_long_read(&p->numa_group->faults[i]);
 			}
 		}
 
@@ -1176,11 +1178,35 @@ static void task_numa_placement(struct task_struct *p)
 			max_faults = faults;
 			max_nid = nid;
 		}
+
+		if (group_faults > max_group_faults) {
+			max_group_faults = group_faults;
+			max_group_nid = nid;
+		}
+
+		total_faults += faults;
+		total_group_faults += group_faults;
 	}
 
 	if (sched_feat(NUMA_INTERLEAVE))
 		task_numa_mempol(p, max_faults);
 
+	/*
+	 * Should we stay on our own, or move in with the group?
+	 * The absolute count of faults may not be useful, but comparing
+	 * the fraction of accesses in each top node may give us a hint
+	 * where to start looking for a migration target.
+	 *
+	 *  max_group_faults     max_faults
+	 * ------------------ > ------------
+	 * total_group_faults   total_faults
+	 */
+	if (max_group_nid >= 0 && max_group_nid != max_nid) {
+		if (max_group_faults * total_faults >
+				max_faults * total_group_faults)
+			max_nid = max_group_nid;
+	}
+
 	/* Preferred node as the node with the most faults */
 	if (max_faults && max_nid != p->numa_preferred_nid) {
 
