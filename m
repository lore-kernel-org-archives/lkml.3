Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3JIRaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:30:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3JIR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:29:59 -0400
Date: Wed, 9 Oct 2013 10:29:23 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-6b9a7460b6baf6c77fc3d23d927ddfc3f3f05bf3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-34-git-send-email-mgorman@suse.de>
References: <1381141781-10992-34-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Retry migration of tasks to CPU on a preferred node
Git-Commit-ID: 6b9a7460b6baf6c77fc3d23d927ddfc3f3f05bf3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:29:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b9a7460b6baf6c77fc3d23d927ddfc3f3f05bf3
Gitweb:     http://git.kernel.org/tip/6b9a7460b6baf6c77fc3d23d927ddfc3f3f05bf3
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:11 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:40 +0200

sched/numa: Retry migration of tasks to CPU on a preferred node

When a preferred node is selected for a tasks there is an attempt to migrate
the task to a CPU there. This may fail in which case the task will only
migrate if the active load balancer takes action. This may never happen if
the conditions are not right. This patch will check at NUMA hinting fault
time if another attempt should be made to migrate the task. It will only
make an attempt once every five seconds.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-34-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d946195..14251a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1341,6 +1341,7 @@ struct task_struct {
 	int numa_migrate_seq;
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
+	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 51a7600..f84ac3f 100644
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
 
