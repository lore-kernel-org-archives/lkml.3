Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3IJJgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:36:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3IJJdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:33:14 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 39/50] sched: numa: Favor placing a task on the preferred node
Date: Tue, 10 Sep 2013 10:32:19 +0100
Message-Id: <1378805550-29949-40-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tasks preferred node is selected based on the number of faults
recorded for a node but the actual task_numa_migate() conducts a global
search regardless of the preferred nid. This patch checks if the
preferred nid has capacity and if so, searches for a CPU within that
node. This avoids a global search when the preferred node is not
overloaded.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 54 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 12b42a6..f2bd291 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1052,6 +1052,20 @@ unlock:
 	rcu_read_unlock();
 }
 
+static void task_numa_find_cpu(struct task_numa_env *env, long imp)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(env->dst_nid)) {
+		/* Skip this CPU if the source task cannot migrate */
+		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
+			continue;
+
+		env->dst_cpu = cpu;
+		task_numa_compare(env, imp);
+	}
+}
+
 static int task_numa_migrate(struct task_struct *p)
 {
 	const struct cpumask *cpumask = cpumask_of_node(p->numa_preferred_nid);
@@ -1069,7 +1083,8 @@ static int task_numa_migrate(struct task_struct *p)
 	};
  	struct sched_domain *sd;
 	unsigned long faults;
-	int nid, cpu, ret;
+	int nid, ret;
+	long imp;
 
 	/*
 	 * Find the lowest common scheduling domain covering the nodes of both
@@ -1086,28 +1101,29 @@ static int task_numa_migrate(struct task_struct *p)
 
 	faults = task_faults(p, env.src_nid);
 	update_numa_stats(&env.src_stats, env.src_nid);
+	env.dst_nid = p->numa_preferred_nid;
+	imp = task_faults(env.p, env.dst_nid) - faults;
+	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* Find an alternative node with relatively better statistics */
-	for_each_online_node(nid) {
-		long imp;
-
-		if (nid == env.src_nid)
-			continue;
-
-		/* Only consider nodes that recorded more faults */
-		imp = task_faults(p, nid) - faults;
-		if (imp < 0)
-			continue;
+	/*
+	 * If the preferred nid has capacity then use it. Otherwise find an
+	 * alternative node with relatively better statistics.
+	 */
+	if (env.dst_stats.has_capacity) {
+		task_numa_find_cpu(&env, imp);
+	} else {
+		for_each_online_node(nid) {
+			if (nid == env.src_nid || nid == p->numa_preferred_nid)
+				continue;
 
-		env.dst_nid = nid;
-		update_numa_stats(&env.dst_stats, env.dst_nid);
-		for_each_cpu(cpu, cpumask_of_node(nid)) {
-			/* Skip this CPU if the source task cannot migrate */
-			if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+			/* Only consider nodes that recorded more faults */
+			imp = task_faults(env.p, nid) - faults;
+			if (imp < 0)
 				continue;
 
-			env.dst_cpu = cpu;
-			task_numa_compare(&env, imp);
+			env.dst_nid = nid;
+			update_numa_stats(&env.dst_stats, env.dst_nid);
+			task_numa_find_cpu(&env, imp);
 		}
 	}
 
-- 
1.8.1.4

