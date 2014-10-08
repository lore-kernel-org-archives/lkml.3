Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaJHTiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:38:09 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34514 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaJHTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:38:03 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: [PATCH RFC 1/5] sched,numa: build table of node hop distance
Date: Wed,  8 Oct 2014 15:37:26 -0400
Message-Id: <1412797050-8903-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412797050-8903-1-git-send-email-riel@redhat.com>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

In order to more efficiently figure out where to place workloads
that span multiple NUMA nodes, it makes sense to estimate how
many hops away nodes are from each other.

Also add some comments to sched_init_numa.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/topology.h |  1 +
 kernel/sched/core.c      | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index dda6ee5..33002f4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -47,6 +47,7 @@
 		if (nr_cpus_node(node))
 
 int arch_update_cpu_topology(void);
+extern int node_hops(int i, int j);
 
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5a4ad05..0cf501e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6076,6 +6076,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
 static int *sched_domains_numa_distance;
+static int *sched_domains_numa_hops;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 #endif
@@ -6247,6 +6248,19 @@ static void sched_numa_warn(const char *str)
 	printk(KERN_WARNING "\n");
 }
 
+int node_hops(int i, int j)
+{
+	if (!sched_domains_numa_hops)
+		return 0;
+
+	return sched_domains_numa_hops[i * nr_node_ids + j];
+}
+
+static void set_node_hops(int i, int j, int hops)
+{
+	sched_domains_numa_hops[i * nr_node_ids + j] = hops;
+}
+
 static bool find_numa_distance(int distance)
 {
 	int i;
@@ -6273,6 +6287,10 @@ static void sched_init_numa(void)
 	if (!sched_domains_numa_distance)
 		return;
 
+	sched_domains_numa_hops = kzalloc(sizeof(int) * nr_node_ids * nr_node_ids, GFP_KERNEL);
+	if (!sched_domains_numa_hops)
+		return;
+
 	/*
 	 * O(nr_nodes^2) deduplicating selection sort -- in order to find the
 	 * unique distances in the node_distance() table.
@@ -6340,7 +6358,7 @@ static void sched_init_numa(void)
 
 	/*
 	 * Now for each level, construct a mask per node which contains all
-	 * cpus of nodes that are that many hops away from us.
+	 * cpus of nodes that are that many hops away from us and closer by.
 	 */
 	for (i = 0; i < level; i++) {
 		sched_domains_numa_masks[i] =
@@ -6348,6 +6366,9 @@ static void sched_init_numa(void)
 		if (!sched_domains_numa_masks[i])
 			return;
 
+		/* A node is 0 hops away from itself. */
+		set_node_hops(i, i, 0);
+
 		for (j = 0; j < nr_node_ids; j++) {
 			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
@@ -6356,10 +6377,20 @@ static void sched_init_numa(void)
 			sched_domains_numa_masks[i][j] = mask;
 
 			for (k = 0; k < nr_node_ids; k++) {
-				if (node_distance(j, k) > sched_domains_numa_distance[i])
+				int distance = node_distance(j, k);
+				if (distance > sched_domains_numa_distance[i])
 					continue;
 
+				/* All CPUs at distance or less. */
 				cpumask_or(mask, mask, cpumask_of_node(k));
+
+				/*
+				 * The number of hops is one larger than i,
+				 * because sched_domains_numa_distance[]
+				 * excludes the local distance.
+				 */
+				if (distance == sched_domains_numa_distance[i])
+					set_node_hops(j, k, i+1);
 			}
 		}
 	}
-- 
1.9.3

