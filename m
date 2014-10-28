Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaJ1LF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:05:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaJ1LFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:05:24 -0400
Date: Tue, 28 Oct 2014 04:04:17 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-e3fe70b1f72e3f83a00d9c332ec09ab347a981e2@git.kernel.org>
Cc: peterz@infradead.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org, chegu_vinod@hp.com,
        hpa@zytor.com, riel@redhat.com
Reply-To: torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        hpa@zytor.com, chegu_vinod@hp.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1413530994-9732-3-git-send-email-riel@redhat.com>
References: <1413530994-9732-3-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Classify the NUMA topology of a system
Git-Commit-ID: e3fe70b1f72e3f83a00d9c332ec09ab347a981e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3fe70b1f72e3f83a00d9c332ec09ab347a981e2
Gitweb:     http://git.kernel.org/tip/e3fe70b1f72e3f83a00d9c332ec09ab347a981e2
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 17 Oct 2014 03:29:50 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:48 +0100

sched/numa: Classify the NUMA topology of a system

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
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
[ Changed to use kernel/sched/sched.h ]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Link: http://lkml.kernel.org/r/1413530994-9732-3-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |  6 ++++++
 2 files changed, 59 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4007595..cde8481 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6128,6 +6128,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
+enum numa_topology_type sched_numa_topology_type;
 static int *sched_domains_numa_distance;
 int sched_max_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
@@ -6316,6 +6317,56 @@ bool find_numa_distance(int distance)
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
+	n = sched_max_numa_distance;
+
+	if (n <= 1)
+		sched_numa_topology_type = NUMA_DIRECT;
+
+	for_each_online_node(a) {
+		for_each_online_node(b) {
+			/* Find two nodes furthest removed from each other. */
+			if (node_distance(a, b) < n)
+				continue;
+
+			/* Is there an intermediary node between a and b? */
+			for_each_online_node(c) {
+				if (node_distance(a, c) < n &&
+				    node_distance(b, c) < n) {
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
@@ -6449,6 +6500,8 @@ static void sched_init_numa(void)
 
 	sched_domains_numa_levels = level;
 	sched_max_numa_distance = sched_domains_numa_distance[level - 1];
+
+	init_numa_topology_type();
 }
 
 static void sched_domains_numa_masks_set(int cpu)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 443d6e1..57aacea 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -679,6 +679,12 @@ static inline u64 rq_clock_task(struct rq *rq)
 }
 
 #ifdef CONFIG_NUMA
+enum numa_topology_type {
+	NUMA_DIRECT,
+	NUMA_GLUELESS_MESH,
+	NUMA_BACKPLANE,
+};
+extern enum numa_topology_type sched_numa_topology_type;
 extern int sched_max_numa_distance;
 extern bool find_numa_distance(int distance);
 #endif
