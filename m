Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaJHTiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:38:06 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34509 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaJHTiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:38:02 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: [PATCH RFC 2/5] sched,numa: classify the NUMA topology of a system
Date: Wed,  8 Oct 2014 15:37:27 -0400
Message-Id: <1412797050-8903-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412797050-8903-1-git-send-email-riel@redhat.com>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Smaller NUMA systems tend to have all NUMA nodes directly connected
to each other. This includes the degenerate case of a system with just
one node, ie. a non-NUMA system.

Larger systems can have two kinds of NUMA topology, which affects how
tasks and memory should be placed on the system.

On glueless mesh systems, nodes that are not directly connected to
each other will bounce traffic through intermediary nodes. Task groups
can be run closer to each other by moving tasks from a node to an
intermediary node between it and the task's preferred node.

On NUMA systems with backplane controllers, the intermediary hops
are incapable of running programs. This creates "islands" of nodes
that are at an equal distance to anywhere else in the system.

Each kind of topology requires a slightly different placement
algorithm; this patch provides the mechanism to detect the kind
of NUMA topology of a system.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/core.c      | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 33002f4..bf40d46 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -49,6 +49,13 @@
 int arch_update_cpu_topology(void);
 extern int node_hops(int i, int j);
 
+enum numa_topology_type {
+	NUMA_DIRECT,
+	NUMA_GLUELESS_MESH,
+	NUMA_BACKPLANE,
+};
+extern enum numa_topology_type sched_numa_topology_type;
+
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0cf501e..1898914 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6075,6 +6075,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
+enum numa_topology_type sched_numa_topology_type;
 static int *sched_domains_numa_distance;
 static int *sched_domains_numa_hops;
 static struct cpumask ***sched_domains_numa_masks;
@@ -6276,6 +6277,56 @@ static bool find_numa_distance(int distance)
 	return false;
 }
 
+/*
+ * A system can have three types of NUMA topology:
+ * NUMA_DIRECT: all nodes are directly connected, or not a NUMA system
+ * NUMA_GLUELESS_MESH: some nodes reachable through intermediary nodes
+ * NUMA_BACKPLANE: nodes can reach other nodes through a backplane
+ *
+ * The difference between a glueless mesh topology and a backplane
+ * topology lies in whether communication between not directly
+ * connected nodes goes through intermediary nodes (where programs
+ * could run), or through backplane controllers. This affects
+ * placement of programs.
+ *
+ * The type of topology can be discerned with the following tests:
+ * - If the maximum distance between any nodes is 1 hop, the system
+ *   is directly connected.
+ * - If for two nodes A and B, located N > 1 hops away from each other,
+ *   there is an intermediary node C, which is < N hops away from both
+ *   nodes A and B, the system is a glueless mesh.
+ */
+static void init_numa_topology_type(void)
+{
+	int a, b, c, n;
+
+	n = sched_domains_numa_levels;
+
+	if (n <= 1)
+		sched_numa_topology_type = NUMA_DIRECT;
+
+	for_each_online_node(a) {
+		for_each_online_node(b) {
+			/* Find two nodes furthest removed from each other. */
+			if (node_hops(a, b) < n)
+				continue;
+
+			/* Is there an intermediary node between a and b? */
+			for_each_online_node(c) {
+				if (node_hops(a, c) < n &&
+				    node_hops(b, c) < n) {
+					sched_numa_topology_type =
+							NUMA_GLUELESS_MESH;
+					return;
+				}
+			}
+
+			sched_numa_topology_type = NUMA_BACKPLANE;
+			return;
+		}
+	}
+}
+
 static void sched_init_numa(void)
 {
 	int next_distance, curr_distance = node_distance(0, 0);
@@ -6425,6 +6476,8 @@ static void sched_init_numa(void)
 	sched_domain_topology = tl;
 
 	sched_domains_numa_levels = level;
+
+	init_numa_topology_type();
 }
 
 static void sched_domains_numa_masks_set(int cpu)
-- 
1.9.3

