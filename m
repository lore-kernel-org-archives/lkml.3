Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3JIR1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:27:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3JIR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:27:20 -0400
Date: Wed, 9 Oct 2013 10:26:41 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-598f0ec0bc996e90a806ee9564af919ea5aad401@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-18-git-send-email-mgorman@suse.de>
References: <1381141781-10992-18-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Set the scan rate proportional to the memory usage of the task being scanned
Git-Commit-ID: 598f0ec0bc996e90a806ee9564af919ea5aad401
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:26:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  598f0ec0bc996e90a806ee9564af919ea5aad401
Gitweb:     http://git.kernel.org/tip/598f0ec0bc996e90a806ee9564af919ea5aad401
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:55 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:20 +0200

sched/numa: Set the scan rate proportional to the memory usage of the task being scanned

The NUMA PTE scan rate is controlled with a combination of the
numa_balancing_scan_period_min, numa_balancing_scan_period_max and
numa_balancing_scan_size. This scan rate is independent of the size
of the task and as an aside it is further complicated by the fact that
numa_balancing_scan_size controls how many pages are marked pte_numa and
not how much virtual memory is scanned.

In combination, it is almost impossible to meaningfully tune the min and
max scan periods and reasoning about performance is complex when the time
to complete a full scan is is partially a function of the tasks memory
size. This patch alters the semantic of the min and max tunables to be
about tuning the length time it takes to complete a scan of a tasks occupied
virtual address space. Conceptually this is a lot easier to understand. There
is a "sanity" check to ensure the scan rate is never extremely fast based on
the amount of virtual memory that should be scanned in a second. The default
of 2.5G seems arbitrary but it is to have the maximum scan rate after the
patch roughly match the maximum scan rate before the patch was applied.

On a similar note, numa_scan_period is in milliseconds and not
jiffies. Properly placed pages slow the scanning rate but adding 10 jiffies
to numa_scan_period means that the rate scanning slows depends on HZ which
is confusing. Get rid of the jiffies_to_msec conversion and treat it as ms.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-18-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 11 +++---
 include/linux/sched.h           |  1 +
 kernel/sched/fair.c             | 88 +++++++++++++++++++++++++++++++++++------
 3 files changed, 83 insertions(+), 17 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1428c66..8cd7e5f 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -403,15 +403,16 @@ workload pattern changes and minimises performance impact due to remote
 memory accesses. These sysctls control the thresholds for scan delays and
 the number of pages scanned.
 
-numa_balancing_scan_period_min_ms is the minimum delay in milliseconds
-between scans. It effectively controls the maximum scanning rate for
-each task.
+numa_balancing_scan_period_min_ms is the minimum time in milliseconds to
+scan a tasks virtual memory. It effectively controls the maximum scanning
+rate for each task.
 
 numa_balancing_scan_delay_ms is the starting "scan delay" used for a task
 when it initially forks.
 
-numa_balancing_scan_period_max_ms is the maximum delay between scans. It
-effectively controls the minimum scanning rate for each task.
+numa_balancing_scan_period_max_ms is the maximum time in milliseconds to
+scan a tasks virtual memory. It effectively controls the minimum scanning
+rate for each task.
 
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2ac5285..fdcb4c8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1339,6 +1339,7 @@ struct task_struct {
 	int numa_scan_seq;
 	int numa_migrate_seq;
 	unsigned int numa_scan_period;
+	unsigned int numa_scan_period_max;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
 #endif /* CONFIG_NUMA_BALANCING */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0966f0c..e08d757 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -818,11 +818,13 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 #ifdef CONFIG_NUMA_BALANCING
 /*
- * numa task sample period in ms
+ * Approximate time to scan a full NUMA task in ms. The task scan period is
+ * calculated based on the tasks virtual memory size and
+ * numa_balancing_scan_size.
  */
-unsigned int sysctl_numa_balancing_scan_period_min = 100;
-unsigned int sysctl_numa_balancing_scan_period_max = 100*50;
-unsigned int sysctl_numa_balancing_scan_period_reset = 100*600;
+unsigned int sysctl_numa_balancing_scan_period_min = 1000;
+unsigned int sysctl_numa_balancing_scan_period_max = 60000;
+unsigned int sysctl_numa_balancing_scan_period_reset = 60000;
 
 /* Portion of address space to scan in MB */
 unsigned int sysctl_numa_balancing_scan_size = 256;
@@ -830,6 +832,51 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
+static unsigned int task_nr_scan_windows(struct task_struct *p)
+{
+	unsigned long rss = 0;
+	unsigned long nr_scan_pages;
+
+	/*
+	 * Calculations based on RSS as non-present and empty pages are skipped
+	 * by the PTE scanner and NUMA hinting faults should be trapped based
+	 * on resident pages
+	 */
+	nr_scan_pages = sysctl_numa_balancing_scan_size << (20 - PAGE_SHIFT);
+	rss = get_mm_rss(p->mm);
+	if (!rss)
+		rss = nr_scan_pages;
+
+	rss = round_up(rss, nr_scan_pages);
+	return rss / nr_scan_pages;
+}
+
+/* For sanitys sake, never scan more PTEs than MAX_SCAN_WINDOW MB/sec. */
+#define MAX_SCAN_WINDOW 2560
+
+static unsigned int task_scan_min(struct task_struct *p)
+{
+	unsigned int scan, floor;
+	unsigned int windows = 1;
+
+	if (sysctl_numa_balancing_scan_size < MAX_SCAN_WINDOW)
+		windows = MAX_SCAN_WINDOW / sysctl_numa_balancing_scan_size;
+	floor = 1000 / windows;
+
+	scan = sysctl_numa_balancing_scan_period_min / task_nr_scan_windows(p);
+	return max_t(unsigned int, floor, scan);
+}
+
+static unsigned int task_scan_max(struct task_struct *p)
+{
+	unsigned int smin = task_scan_min(p);
+	unsigned int smax;
+
+	/* Watch for min being lower than max due to floor calculations */
+	smax = sysctl_numa_balancing_scan_period_max / task_nr_scan_windows(p);
+	return max(smin, smax);
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq;
@@ -840,6 +887,7 @@ static void task_numa_placement(struct task_struct *p)
 	if (p->numa_scan_seq == seq)
 		return;
 	p->numa_scan_seq = seq;
+	p->numa_scan_period_max = task_scan_max(p);
 
 	/* FIXME: Scheduling placement policy hints go here */
 }
@@ -860,9 +908,14 @@ void task_numa_fault(int node, int pages, bool migrated)
 	 * If pages are properly placed (did not migrate) then scan slower.
 	 * This is reset periodically in case of phase changes
 	 */
-        if (!migrated)
-		p->numa_scan_period = min(sysctl_numa_balancing_scan_period_max,
-			p->numa_scan_period + jiffies_to_msecs(10));
+	if (!migrated) {
+		/* Initialise if necessary */
+		if (!p->numa_scan_period_max)
+			p->numa_scan_period_max = task_scan_max(p);
+
+		p->numa_scan_period = min(p->numa_scan_period_max,
+			p->numa_scan_period + 10);
+	}
 
 	task_numa_placement(p);
 }
@@ -884,6 +937,7 @@ void task_numa_work(struct callback_head *work)
 	struct mm_struct *mm = p->mm;
 	struct vm_area_struct *vma;
 	unsigned long start, end;
+	unsigned long nr_pte_updates = 0;
 	long pages;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
@@ -915,7 +969,7 @@ void task_numa_work(struct callback_head *work)
 	 */
 	migrate = mm->numa_next_reset;
 	if (time_after(now, migrate)) {
-		p->numa_scan_period = sysctl_numa_balancing_scan_period_min;
+		p->numa_scan_period = task_scan_min(p);
 		next_scan = now + msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
 		xchg(&mm->numa_next_reset, next_scan);
 	}
@@ -927,8 +981,10 @@ void task_numa_work(struct callback_head *work)
 	if (time_before(now, migrate))
 		return;
 
-	if (p->numa_scan_period == 0)
-		p->numa_scan_period = sysctl_numa_balancing_scan_period_min;
+	if (p->numa_scan_period == 0) {
+		p->numa_scan_period_max = task_scan_max(p);
+		p->numa_scan_period = task_scan_min(p);
+	}
 
 	next_scan = now + msecs_to_jiffies(p->numa_scan_period);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
@@ -965,7 +1021,15 @@ void task_numa_work(struct callback_head *work)
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
 			end = min(end, vma->vm_end);
-			pages -= change_prot_numa(vma, start, end);
+			nr_pte_updates += change_prot_numa(vma, start, end);
+
+			/*
+			 * Scan sysctl_numa_balancing_scan_size but ensure that
+			 * at least one PTE is updated so that unused virtual
+			 * address space is quickly skipped.
+			 */
+			if (nr_pte_updates)
+				pages -= (end - start) >> PAGE_SHIFT;
 
 			start = end;
 			if (pages <= 0)
@@ -1012,7 +1076,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 
 	if (now - curr->node_stamp > period) {
 		if (!curr->node_stamp)
-			curr->numa_scan_period = sysctl_numa_balancing_scan_period_min;
+			curr->numa_scan_period = task_scan_min(curr);
 		curr->node_stamp += period;
 
 		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
