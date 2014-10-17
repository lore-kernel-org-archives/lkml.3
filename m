Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaJQHaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:30:15 -0400
Received: from shelob.surriel.com ([74.92.59.67]:35990 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaJQHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:30:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mingo@redhat.com,
        mgorman@suse.de
Subject: [PATCH 6/6] sched,numa: check all nodes when placing a pseudo-interleaved group
Date: Fri, 17 Oct 2014 03:29:54 -0400
Message-Id: <1413530994-9732-7-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413530994-9732-1-git-send-email-riel@redhat.com>
References: <1413530994-9732-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

In pseudo-interleaved numa_groups, all tasks try to relocate to
the group's preferred_nid.  When a group is spread across multiple
NUMA nodes, this can lead to tasks swapping their location with
other tasks inside the same group, instead of having the group
converge on a few nodes.

When placing a task in a pseudo-interleaved numa_group, it pays
to examine all nodes, to see if it isn't better to move to eg.
the #2 node, so the group locality can be improved.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b973d77..00c1137 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1425,8 +1425,15 @@ static int task_numa_migrate(struct task_struct *p)
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
-- 
1.9.3

