Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaA1TYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:24:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbaA1TYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:24:37 -0500
Date: Tue, 28 Jan 2014 11:24:04 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-20e07dea286a90f096a779706861472d296397c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-5-git-send-email-riel@redhat.com>
References: <1390860228-21539-5-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Build per numa_group active node mask from numa_faults_cpu statistics
Git-Commit-ID: 20e07dea286a90f096a779706861472d296397c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:24:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20e07dea286a90f096a779706861472d296397c6
Gitweb:     http://git.kernel.org/tip/20e07dea286a90f096a779706861472d296397c6
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:43 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:17:06 +0100

sched/numa: Build per numa_group active node mask from numa_faults_cpu statistics

The numa_faults_cpu statistics are used to maintain an active_nodes nodemask
per numa_group. This allows us to be smarter about when to do numa migrations.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-5-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4841aaf..1ee921f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -885,6 +885,7 @@ struct numa_group {
 	struct list_head task_list;
 
 	struct rcu_head rcu;
+	nodemask_t active_nodes;
 	unsigned long total_faults;
 	unsigned long *faults_cpu;
 	unsigned long faults[0];
@@ -918,6 +919,12 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 		p->numa_group->faults[task_faults_idx(nid, 1)];
 }
 
+static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
+{
+	return group->faults_cpu[task_faults_idx(nid, 0)] +
+		group->faults_cpu[task_faults_idx(nid, 1)];
+}
+
 /*
  * These return the fraction of accesses done by a particular task, or
  * task group, on a particular numa node.  The group weight is given a
@@ -1271,6 +1278,38 @@ static void numa_migrate_preferred(struct task_struct *p)
 }
 
 /*
+ * Find the nodes on which the workload is actively running. We do this by
+ * tracking the nodes from which NUMA hinting faults are triggered. This can
+ * be different from the set of nodes where the workload's memory is currently
+ * located.
+ *
+ * The bitmask is used to make smarter decisions on when to do NUMA page
+ * migrations, To prevent flip-flopping, and excessive page migrations, nodes
+ * are added when they cause over 6/16 of the maximum number of faults, but
+ * only removed when they drop below 3/16.
+ */
+static void update_numa_active_node_mask(struct numa_group *numa_group)
+{
+	unsigned long faults, max_faults = 0;
+	int nid;
+
+	for_each_online_node(nid) {
+		faults = group_faults_cpu(numa_group, nid);
+		if (faults > max_faults)
+			max_faults = faults;
+	}
+
+	for_each_online_node(nid) {
+		faults = group_faults_cpu(numa_group, nid);
+		if (!node_isset(nid, numa_group->active_nodes)) {
+			if (faults > max_faults * 6 / 16)
+				node_set(nid, numa_group->active_nodes);
+		} else if (faults < max_faults * 3 / 16)
+			node_clear(nid, numa_group->active_nodes);
+	}
+}
+
+/*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
  * period will be for the next scan window. If local/remote ratio is below
@@ -1412,6 +1451,7 @@ static void task_numa_placement(struct task_struct *p)
 	update_task_scan_period(p, fault_types[0], fault_types[1]);
 
 	if (p->numa_group) {
+		update_numa_active_node_mask(p->numa_group);
 		/*
 		 * If the preferred task and group nids are different,
 		 * iterate over the nodes again to find the best place.
@@ -1474,6 +1514,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		/* Second half of the array tracks nids where faults happen */
 		grp->faults_cpu = grp->faults + 2 * nr_node_ids;
 
+		node_set(task_node(current), grp->active_nodes);
+
 		for (i = 0; i < 4*nr_node_ids; i++)
 			grp->faults[i] = p->numa_faults_memory[i];
 
