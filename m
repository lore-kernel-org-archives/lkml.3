Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbaJIV2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbaJIV2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:28:03 -0400
Date: Thu, 9 Oct 2014 17:27:47 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, mgorman@suse.de
Subject: [PATCH] sched,numa: check all nodes when placing a
 pseudo-interleaved group
Message-ID: <20141009172747.0d97c38c@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pseudo-interleaved numa_groups, all tasks try to relocate to
the group's preferred_nid.  When a group is spread across multiple
NUMA nodes, this can lead to tasks swapping their location with
other tasks inside the same group, instead of swapping location with
tasks from other NUMA groups. This can keep NUMA groups from converging.

Examining all nodes, when dealing with a task in a pseudo-interleaved
NUMA group, avoids this problem. Note that only CPUs in nodes that
improve the task or group score are examined, so the loop isn't too
bad.

Tested-by: Vinod Chegu <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
This patch allows the complex NUMA placement patch series to work,
but it also fixes issues on normal NUMA systems, so this is an
independent bugfix that can go in independently.

 kernel/sched/fair.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 17ebf41..78f1ade 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1419,8 +1419,15 @@ static int task_numa_migrate(struct task_struct *p)
 	/* Try to find a spot on the preferred nid. */
 	task_numa_find_cpu(&env, taskimp, groupimp);
 
-	/* No space available on the preferred nid. Look elsewhere. */
-	if (env.best_cpu == -1) {
+	/*
+	 * Look at other nodes in these cases:
+	 * - there is no space available on the preferred_nid
+	 * - the task is part of a numa_group that is interleaved across
+	 *   multiple NUMA nodes; in order to better consolidate the group,
+	 *   we need to check other locations.
+	 */
+	if (env.best_cpu == -1 || (p->numa_group &&
+			nodes_weight(p->numa_group->active_nodes) > 1)) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
