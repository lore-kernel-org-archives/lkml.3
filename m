Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3KZWSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:18:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3KZWSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:18:18 -0500
From: riel@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        peterz@infradead.org
Subject: [RFC PATCH 3/4] build per numa_group active node mask from faults_from statistics
Date: Tue, 26 Nov 2013 17:03:27 -0500
Message-Id: <1385503408-30041-4-git-send-email-riel@redhat.com>
In-Reply-To: <1385503408-30041-1-git-send-email-riel@redhat.com>
References: <1385503408-30041-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The faults_from statistics are used to maintain an active_nodes nodemask
per numa_group. This allows us to be smarter about when to do numa migrations.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 89b5217..91b8f11 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -869,6 +869,7 @@ struct numa_group {
 	struct list_head task_list;
 
 	struct rcu_head rcu;
+	nodemask_t active_nodes;
 	unsigned long total_faults;
 	unsigned long *faults_from;
 	unsigned long faults[0];
@@ -1228,6 +1229,34 @@ static void numa_migrate_preferred(struct task_struct *p)
 	task_numa_migrate(p);
 }
 
+static void update_numa_active_node_mask(struct task_struct *p)
+{
+	unsigned long faults, max_faults = 0;
+	struct numa_group *numa_group = p->numa_group;
+	int nid;
+
+	for_each_online_node(nid) {
+		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
+			 numa_group->faults_from[task_faults_idx(nid, 1)];
+		if (faults > max_faults)
+			max_faults = faults;
+	}
+
+	/*
+	 * Mark any node where more than 40% of the faults
+	 * (half minus some hysteresis) as part of this
+	 * group's active nodes.
+	 */
+	for_each_online_node(nid) {
+		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
+			 numa_group->faults_from[task_faults_idx(nid, 1)];
+		if (faults > max_faults * 4 / 10)
+			node_set(nid, numa_group->active_nodes);
+		else
+			node_clear(nid, numa_group->active_nodes);
+	}
+}
+
 /*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
@@ -1387,6 +1416,8 @@ static void task_numa_placement(struct task_struct *p)
 			}
 		}
 
+		update_numa_active_node_mask(p);
+
 		spin_unlock(group_lock);
 	}
 
@@ -1433,6 +1464,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		/* Second half of the array tracks where faults come from */
 		grp->faults_from = grp->faults + 2 * nr_node_ids;
 
+		node_set(task_node(current), grp->active_nodes);
+
 		for (i = 0; i < 4*nr_node_ids; i++)
 			grp->faults[i] = p->numa_faults[i];
 
-- 
1.8.3.1

