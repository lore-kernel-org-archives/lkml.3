Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3JGKbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:31:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab3JGKal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:30:41 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 63/63] sched: numa: periodically retry task_numa_migrate
Date: Mon,  7 Oct 2013 11:29:41 +0100
Message-Id: <1381141781-10992-64-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Short spikes of CPU load can lead to a task being migrated
away from its preferred node for temporary reasons.

It is important that the task is migrated back to where it
belongs, in order to avoid migrating too much memory to its
new location, and generally disturbing a task's NUMA location.

This patch fixes NUMA placement for 4 specjbb instances on
a 4 node system. Without this patch, things take longer to
converge, and processes are not always completely on their
own node.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f45dd4c..1d5ea2d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1259,18 +1259,19 @@ static int task_numa_migrate(struct task_struct *p)
 /* Attempt to migrate a task to a CPU on the preferred node. */
 static void numa_migrate_preferred(struct task_struct *p)
 {
-	/* Success if task is already running on preferred CPU */
-	p->numa_migrate_retry = 0;
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	/* This task has no NUMA fault statistics yet */
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
 		return;
 
-	/* This task has no NUMA fault statistics yet */
-	if (unlikely(p->numa_preferred_nid == -1))
+	/* Periodically retry migrating the task to the preferred node */
+	p->numa_migrate_retry = jiffies + HZ;
+
+	/* Success if task is already running on preferred CPU */
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
 		return;
 
 	/* Otherwise, try migrate to a CPU on the preferred node */
-	if (task_numa_migrate(p) != 0)
-		p->numa_migrate_retry = jiffies + HZ*5;
+	task_numa_migrate(p);
 }
 
 /*
@@ -1629,8 +1630,11 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 
 	task_numa_placement(p);
 
-	/* Retry task to preferred node migration if it previously failed */
-	if (p->numa_migrate_retry && time_after(jiffies, p->numa_migrate_retry))
+	/*
+	 * Retry task to preferred node migration periodically, in case it
+	 * case it previously failed, or the scheduler moved us.
+	 */
+	if (time_after(jiffies, p->numa_migrate_retry))
 		numa_migrate_preferred(p);
 
 	if (migrated)
-- 
1.8.4

