Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaFNTku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:40:50 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45551 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaFNTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:40:05 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 1/3] sched,numa: use group's max nid as task's preferred nid
Date: Sat, 14 Jun 2014 15:18:57 -0400
Message-Id: <1402773539-6466-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1402773539-6466-1-git-send-email-riel@redhat.com>
References: <1402773539-6466-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

>From task_numa_placement, always try to consolidate the tasks
in a group on the group's top nid.

In case this task is part of a group that is interleaved over
multiple nodes, task_numa_migrate will set the task's preferred
nid to the best node it could find for the task, so this patch
will cause at most one run through task_numa_migrate.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..86c35d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1595,23 +1595,8 @@ static void task_numa_placement(struct task_struct *p)
 
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
-		/*
-		 * If the preferred task and group nids are different,
-		 * iterate over the nodes again to find the best place.
-		 */
-		if (max_nid != max_group_nid) {
-			unsigned long weight, max_weight = 0;
-
-			for_each_online_node(nid) {
-				weight = task_weight(p, nid) + group_weight(p, nid);
-				if (weight > max_weight) {
-					max_weight = weight;
-					max_nid = nid;
-				}
-			}
-		}
-
 		spin_unlock_irq(group_lock);
+		max_nid = max_group_nid;
 	}
 
 	/* Preferred node as the node with the most faults */
-- 
1.8.5.3

