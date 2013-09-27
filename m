Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3I0N2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:28:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3I0N2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:23 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 33/63] sched: Retry migration of tasks to CPU on a preferred node
Date: Fri, 27 Sep 2013 14:27:18 +0100
Message-Id: <1380288468-5551-34-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a preferred node is selected for a tasks there is an attempt to migrate
the task to a CPU there. This may fail in which case the task will only
migrate if the active load balancer takes action. This may never happen if
the conditions are not right. This patch will check at NUMA hinting fault
time if another attempt should be made to migrate the task. It will only
make an attempt once every five seconds.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6eb8fa6..3418b0b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1333,6 +1333,7 @@ struct task_struct {
 	int numa_migrate_seq;
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
+	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b130014..00ccc68 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1011,6 +1011,23 @@ migrate:
 	return migrate_task_to(p, env.best_cpu);
 }
 
+/* Attempt to migrate a task to a CPU on the preferred node. */
+static void numa_migrate_preferred(struct task_struct *p)
+{
+	/* Success if task is already running on preferred CPU */
+	p->numa_migrate_retry = 0;
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+		return;
+
+	/* This task has no NUMA fault statistics yet */
+	if (unlikely(p->numa_preferred_nid == -1))
+		return;
+
+	/* Otherwise, try migrate to a CPU on the preferred node */
+	if (task_numa_migrate(p) != 0)
+		p->numa_migrate_retry = jiffies + HZ*5;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1;
@@ -1045,17 +1062,12 @@ static void task_numa_placement(struct task_struct *p)
 		}
 	}
 
-	/*
-	 * Record the preferred node as the node with the most faults,
-	 * requeue the task to be running on the idlest CPU on the
-	 * preferred node and reset the scanning rate to recheck
-	 * the working set placement.
-	 */
+	/* Preferred node as the node with the most faults */
 	if (max_faults && max_nid != p->numa_preferred_nid) {
 		/* Update the preferred nid and migrate task if possible */
 		p->numa_preferred_nid = max_nid;
 		p->numa_migrate_seq = 1;
-		task_numa_migrate(p);
+		numa_migrate_preferred(p);
 	}
 }
 
@@ -1111,6 +1123,10 @@ void task_numa_fault(int last_nidpid, int node, int pages, bool migrated)
 
 	task_numa_placement(p);
 
+	/* Retry task to preferred node migration if it previously failed */
+	if (p->numa_migrate_retry && time_after(jiffies, p->numa_migrate_retry))
+		numa_migrate_preferred(p);
+
 	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
 }
 
-- 
1.8.1.4

