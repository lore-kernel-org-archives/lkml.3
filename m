Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaEHRXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:23:42 -0400
Received: from shelob.surriel.com ([74.92.59.67]:53776 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaEHRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:23:41 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 3/4] sched,numa: store numa_group's preferred nid
Date: Thu,  8 May 2014 13:23:30 -0400
Message-Id: <1399569811-14362-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1399569811-14362-1-git-send-email-riel@redhat.com>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Store a numa_group's preferred nid. Used by the next patch to pull
workloads towards their preferred nodes.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5925667..99cc829 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -864,6 +864,7 @@ struct numa_group {
 
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
+	int preferred_nid;
 	pid_t gid;
 	struct list_head task_list;
 
@@ -1642,6 +1643,7 @@ static void task_numa_placement(struct task_struct *p)
 
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
+		p->numa_group->preferred_nid = max_group_nid;
 		/*
 		 * If the preferred task and group nids are different,
 		 * iterate over the nodes again to find the best place.
@@ -1701,6 +1703,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		spin_lock_init(&grp->lock);
 		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
+		grp->preferred_nid = -1;
 		/* Second half of the array tracks nids where faults happen */
 		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
 						nr_node_ids;
-- 
1.8.5.3

