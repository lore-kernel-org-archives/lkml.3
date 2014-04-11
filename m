Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbaDKRYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:24:15 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48402 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaDKRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:24:12 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: [PATCH 1/3] sched,numa: count pages on active node as local
Date: Fri, 11 Apr 2014 13:00:27 -0400
Message-Id: <1397235629-16328-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397235629-16328-1-git-send-email-riel@redhat.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The NUMA code is smart enough to distribute the memory of workloads
that span multiple NUMA nodes across those NUMA nodes.

However, it still has a pretty high scan rate for such workloads,
because any memory that is left on a node other than the node of
the CPU that faulted on the memory is counted as non-local, which
causes the scan rate to go up.

Counting the memory on any node where the task's numa group is
actively running as local, allows the scan rate to slow down
once the application is settled in.

This should reduce the overhead of the automatic NUMA placement
code, when a workload spans multiple NUMA nodes.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Vinod Chegu <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e9bd0b..12de50a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1737,6 +1737,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct task_struct *p = current;
 	bool migrated = flags & TNF_MIGRATED;
 	int cpu_node = task_node(current);
+	int local = !!(flags & TNF_FAULT_LOCAL);
 	int priv;
 
 	if (!numabalancing_enabled)
@@ -1785,6 +1786,17 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 			task_numa_group(p, last_cpupid, flags, &priv);
 	}
 
+	/*
+	 * If a workload spans multiple NUMA nodes, a shared fault that
+	 * occurs wholly within the set of nodes that the workload is
+	 * actively using should be counted as local. This allows the
+	 * scan rate to slow down when a workload has settled down.
+	 */
+	if (!priv && !local && p->numa_group &&
+			node_isset(cpu_node, p->numa_group->active_nodes) &&
+			node_isset(mem_node, p->numa_group->active_nodes))
+		local = 1;
+
 	task_numa_placement(p);
 
 	/*
@@ -1799,7 +1811,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 
 	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
 	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
-	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
+	p->numa_faults_locality[local] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
-- 
1.8.5.3

