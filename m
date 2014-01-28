Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaA1TYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:24:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbaA1TYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:24:15 -0500
Date: Tue, 28 Jan 2014 11:23:30 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-52bf84aa206cd2c2516dfa3e03b578edf8a3242f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-2-git-send-email-riel@redhat.com>
References: <1390860228-21539-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa, mm: Remove p->numa_migrate_deferred
Git-Commit-ID: 52bf84aa206cd2c2516dfa3e03b578edf8a3242f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:23:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52bf84aa206cd2c2516dfa3e03b578edf8a3242f
Gitweb:     http://git.kernel.org/tip/52bf84aa206cd2c2516dfa3e03b578edf8a3242f
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:40 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:17:04 +0100

sched/numa, mm: Remove p->numa_migrate_deferred

Excessive migration of pages can hurt the performance of workloads
that span multiple NUMA nodes.  However, it turns out that the
p->numa_migrate_deferred knob is a really big hammer, which does
reduce migration rates, but does not actually help performance.

Now that the second stage of the automatic numa balancing code
has stabilized, it is time to replace the simplistic migration
deferral code with something smarter.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 10 +--------
 include/linux/sched.h           |  1 -
 kernel/sched/fair.c             |  8 --------
 kernel/sysctl.c                 |  7 -------
 mm/mempolicy.c                  | 45 -----------------------------------------
 5 files changed, 1 insertion(+), 70 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d48640..760f6e6a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -386,8 +386,7 @@ feature should be disabled. Otherwise, if the system overhead from the
 feature is too high then the rate the kernel samples for NUMA hinting
 faults may be controlled by the numa_balancing_scan_period_min_ms,
 numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
-numa_balancing_scan_size_mb, numa_balancing_settle_count sysctls and
-numa_balancing_migrate_deferred.
+numa_balancing_scan_size_mb, and numa_balancing_settle_count sysctls.
 
 ==============================================================
 
@@ -428,13 +427,6 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
 
-numa_balancing_migrate_deferred is how many page migrations get skipped
-unconditionally, after a page migration is skipped because a page is shared
-with other tasks. This reduces page migration overhead, and determines
-how much stronger the "move task near its memory" policy scheduler becomes,
-versus the "move memory near its task" memory management policy, for workloads
-with shared memory.
-
 ==============================================================
 
 osrelease, ostype & version:
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffccdad..d572d5b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1457,7 +1457,6 @@ struct task_struct {
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
 	int numa_preferred_nid;
-	int numa_migrate_deferred;
 	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index efe6457..7cdde91 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -819,14 +819,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/*
- * After skipping a page migration on a shared page, skip N more numa page
- * migrations unconditionally. This reduces the number of NUMA migrations
- * in shared memory workloads, and has the effect of pulling tasks towards
- * where their memory lives, over pulling the memory towards the task.
- */
-unsigned int sysctl_numa_balancing_migrate_deferred = 16;
-
 static unsigned int task_nr_scan_windows(struct task_struct *p)
 {
 	unsigned long rss = 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c8da99f..b41d61d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -384,13 +384,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname       = "numa_balancing_migrate_deferred",
-		.data           = &sysctl_numa_balancing_migrate_deferred,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0cd2c4d..68d5c7f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2304,35 +2304,6 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-static bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
-{
-	/* Never defer a private fault */
-	if (cpupid_match_pid(p, last_cpupid))
-		return false;
-
-	if (p->numa_migrate_deferred) {
-		p->numa_migrate_deferred--;
-		return true;
-	}
-	return false;
-}
-
-static inline void defer_numa_migrate(struct task_struct *p)
-{
-	p->numa_migrate_deferred = sysctl_numa_balancing_migrate_deferred;
-}
-#else
-static inline bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
-{
-	return false;
-}
-
-static inline void defer_numa_migrate(struct task_struct *p)
-{
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
 /**
  * mpol_misplaced - check whether current page node is valid in policy
  *
@@ -2435,24 +2406,8 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 		 */
 		last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
 		if (!cpupid_pid_unset(last_cpupid) && cpupid_to_nid(last_cpupid) != thisnid) {
-
-			/* See sysctl_numa_balancing_migrate_deferred comment */
-			if (!cpupid_match_pid(current, last_cpupid))
-				defer_numa_migrate(current);
-
 			goto out;
 		}
-
-		/*
-		 * The quadratic filter above reduces extraneous migration
-		 * of shared pages somewhat. This code reduces it even more,
-		 * reducing the overhead of page migrations of shared pages.
-		 * This makes workloads with shared pages rely more on
-		 * "move task near its memory", and less on "move memory
-		 * towards its task", which is exactly what we want.
-		 */
-		if (numa_migrate_deferred(current, last_cpupid))
-			goto out;
 	}
 
 	if (curnid != polnid)
