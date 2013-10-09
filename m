Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3JIRfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:35:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3JIRe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:34:59 -0400
Date: Wed, 9 Oct 2013 10:34:22 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-2739d3eef3a93a92c366a3a0bb85a0afe09e8b8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-64-git-send-email-mgorman@suse.de>
References: <1381141781-10992-64-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Retry task_numa_migrate()
  periodically
Git-Commit-ID: 2739d3eef3a93a92c366a3a0bb85a0afe09e8b8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:34:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2739d3eef3a93a92c366a3a0bb85a0afe09e8b8c
Gitweb:     http://git.kernel.org/tip/2739d3eef3a93a92c366a3a0bb85a0afe09e8b8c
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:25 +0200

sched/numa: Retry task_numa_migrate() periodically

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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-64-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b2208e..e914930 100644
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
