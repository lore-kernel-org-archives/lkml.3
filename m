Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3JGKaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:30:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3JGKaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:30:20 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 41/63] sched: numa: fix placement of workloads spread across multiple nodes
Date: Mon,  7 Oct 2013 11:29:19 +0100
Message-Id: <1381141781-10992-42-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The load balancer will spread workloads across multiple NUMA nodes,
in order to balance the load on the system. This means that sometimes
a task's preferred node has available capacity, but moving the task
there will not succeed, because that would create too large an imbalance.

In that case, other NUMA nodes need to be considered.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 722baab..9dd35cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1104,13 +1104,12 @@ static int task_numa_migrate(struct task_struct *p)
 	imp = task_faults(env.p, env.dst_nid) - faults;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/*
-	 * If the preferred nid has capacity then use it. Otherwise find an
-	 * alternative node with relatively better statistics.
-	 */
-	if (env.dst_stats.has_capacity) {
+	/* If the preferred nid has capacity, try to use it. */
+	if (env.dst_stats.has_capacity)
 		task_numa_find_cpu(&env, imp);
-	} else {
+
+	/* No space available on the preferred nid. Look elsewhere. */
+	if (env.best_cpu == -1) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
-- 
1.8.4

