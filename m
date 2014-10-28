Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaJ1LGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:06:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbaJ1LGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:06:08 -0400
Date: Tue, 28 Oct 2014 04:05:11 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-54009416ac3b5f219c0df68559ce534287ae97b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, riel@redhat.com,
        peterz@infradead.org, torvalds@linux-foundation.org,
        chegu_vinod@hp.com, mingo@kernel.org, hpa@zytor.com
Reply-To: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org, riel@redhat.com,
        torvalds@linux-foundation.org, chegu_vinod@hp.com
In-Reply-To: <1413530994-9732-6-git-send-email-riel@redhat.com>
References: <1413530994-9732-6-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Find the preferred nid with complex NUMA topology
Git-Commit-ID: 54009416ac3b5f219c0df68559ce534287ae97b1
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

Commit-ID:  54009416ac3b5f219c0df68559ce534287ae97b1
Gitweb:     http://git.kernel.org/tip/54009416ac3b5f219c0df68559ce534287ae97b1
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 17 Oct 2014 03:29:53 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:51 +0100

sched/numa: Find the preferred nid with complex NUMA topology

On systems with complex NUMA topologies, the node scoring is adjusted
to allow workloads to converge on nodes that are near each other.

The way a task group's preferred nid is determined needs to be adjusted,
in order for the preferred_nid to be consistent with group_weight scoring.
This ensures that we actually try to converge workloads on adjacent nodes.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413530994-9732-6-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e5712a..7760c2a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1659,6 +1659,92 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 	return delta;
 }
 
+/*
+ * Determine the preferred nid for a task in a numa_group. This needs to
+ * be done in a way that produces consistent results with group_weight,
+ * otherwise workloads might not converge.
+ */
+static int preferred_group_nid(struct task_struct *p, int nid)
+{
+	nodemask_t nodes;
+	int dist;
+
+	/* Direct connections between all NUMA nodes. */
+	if (sched_numa_topology_type == NUMA_DIRECT)
+		return nid;
+
+	/*
+	 * On a system with glueless mesh NUMA topology, group_weight
+	 * scores nodes according to the number of NUMA hinting faults on
+	 * both the node itself, and on nearby nodes.
+	 */
+	if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
+		unsigned long score, max_score = 0;
+		int node, max_node = nid;
+
+		dist = sched_max_numa_distance;
+
+		for_each_online_node(node) {
+			score = group_weight(p, node, dist);
+			if (score > max_score) {
+				max_score = score;
+				max_node = node;
+			}
+		}
+		return max_node;
+	}
+
+	/*
+	 * Finding the preferred nid in a system with NUMA backplane
+	 * interconnect topology is more involved. The goal is to locate
+	 * tasks from numa_groups near each other in the system, and
+	 * untangle workloads from different sides of the system. This requires
+	 * searching down the hierarchy of node groups, recursively searching
+	 * inside the highest scoring group of nodes. The nodemask tricks
+	 * keep the complexity of the search down.
+	 */
+	nodes = node_online_map;
+	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
+		unsigned long max_faults = 0;
+		nodemask_t max_group;
+		int a, b;
+
+		/* Are there nodes at this distance from each other? */
+		if (!find_numa_distance(dist))
+			continue;
+
+		for_each_node_mask(a, nodes) {
+			unsigned long faults = 0;
+			nodemask_t this_group;
+			nodes_clear(this_group);
+
+			/* Sum group's NUMA faults; includes a==b case. */
+			for_each_node_mask(b, nodes) {
+				if (node_distance(a, b) < dist) {
+					faults += group_faults(p, b);
+					node_set(b, this_group);
+					node_clear(b, nodes);
+				}
+			}
+
+			/* Remember the top group. */
+			if (faults > max_faults) {
+				max_faults = faults;
+				max_group = this_group;
+				/*
+				 * subtle: at the smallest distance there is
+				 * just one node left in each "group", the
+				 * winner is the preferred nid.
+				 */
+				nid = a;
+			}
+		}
+		/* Next round, evaluate the nodes within max_group. */
+		nodes = max_group;
+	}
+	return nid;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
@@ -1741,7 +1827,7 @@ static void task_numa_placement(struct task_struct *p)
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
 		spin_unlock_irq(group_lock);
-		max_nid = max_group_nid;
+		max_nid = preferred_group_nid(p, max_group_nid);
 	}
 
 	if (max_faults) {
