Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaEHKnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:43:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaEHKnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:43:37 -0400
Date: Thu, 8 May 2014 03:42:39 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-792568ec6a31ca560ca4d528782cbc6cd2cea8b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1397235629-16328-2-git-send-email-riel@redhat.com>
References: <1397235629-16328-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Count pages on active node as local
Git-Commit-ID: 792568ec6a31ca560ca4d528782cbc6cd2cea8b0
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

Commit-ID:  792568ec6a31ca560ca4d528782cbc6cd2cea8b0
Gitweb:     http://git.kernel.org/tip/792568ec6a31ca560ca4d528782cbc6cd2cea8b0
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 11 Apr 2014 13:00:27 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:45 +0200

sched/numa: Count pages on active node as local

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
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1397235629-16328-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5d859ec..f6457b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1738,6 +1738,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct task_struct *p = current;
 	bool migrated = flags & TNF_MIGRATED;
 	int cpu_node = task_node(current);
+	int local = !!(flags & TNF_FAULT_LOCAL);
 	int priv;
 
 	if (!numabalancing_enabled)
@@ -1786,6 +1787,17 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
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
@@ -1800,7 +1812,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 
 	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
 	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
-	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
+	p->numa_faults_locality[local] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
