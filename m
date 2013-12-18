Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3LRKdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:33:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:33:31 -0500
Date: Wed, 18 Dec 2013 02:32:48 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-1bd53a7efdc988163ec4c25f656df38dbe500632@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Drop sysctl_numa_balancing_settle_count sysctl
Git-Commit-ID: 1bd53a7efdc988163ec4c25f656df38dbe500632
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bd53a7efdc988163ec4c25f656df38dbe500632
Gitweb:     http://git.kernel.org/tip/1bd53a7efdc988163ec4c25f656df38dbe500632
Author:     Wanpeng Li <liwanp@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Dec 2013 15:23:23 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:24:38 +0100

sched/numa: Drop sysctl_numa_balancing_settle_count sysctl

commit 887c290e (sched/numa: Decide whether to favour task or group weights
based on swap candidate relationships) drop the check against
sysctl_numa_balancing_settle_count, this patch remove the sysctl.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Link: http://lkml.kernel.org/r/1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 5 -----
 include/linux/sched/sysctl.h    | 1 -
 kernel/sched/fair.c             | 9 ---------
 kernel/sysctl.c                 | 7 -------
 4 files changed, 22 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 26b7ee4..6d48640 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -428,11 +428,6 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
 
-numa_balancing_settle_count is how many scan periods must complete before
-the schedule balancer stops pushing the task towards a preferred node. This
-gives the scheduler a chance to place the task on an alternative node if the
-preferred node is overloaded.
-
 numa_balancing_migrate_deferred is how many page migrations get skipped
 unconditionally, after a page migration is skipped because a page is shared
 with other tasks. This reduces page migration overhead, and determines
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 41467f8..31e0193 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -48,7 +48,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_settle_count;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a9185f7..fcb6c17 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -872,15 +872,6 @@ static unsigned int task_scan_max(struct task_struct *p)
 	return max(smin, smax);
 }
 
-/*
- * Once a preferred node is selected the scheduler balancer will prefer moving
- * a task to that node for sysctl_numa_balancing_settle_count number of PTE
- * scans. This will give the process the chance to accumulate more faults on
- * the preferred node but still allow the scheduler to move the task again if
- * the nodes CPUs are overloaded.
- */
-unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
-
 static void account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
 	rq->nr_numa_running += (p->numa_preferred_nid != -1);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..c8da99f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -385,13 +385,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname       = "numa_balancing_settle_count",
-		.data           = &sysctl_numa_balancing_settle_count,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-	{
 		.procname       = "numa_balancing_migrate_deferred",
 		.data           = &sysctl_numa_balancing_migrate_deferred,
 		.maxlen         = sizeof(unsigned int),
