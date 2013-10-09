Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3JIR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:28:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:28:44 -0400
Date: Wed, 9 Oct 2013 10:28:02 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-ac8e895bd260cb8bb19ade6a3abd44e7abe9a01d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-26-git-send-email-mgorman@suse.de>
References: <1381141781-10992-26-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Add infrastructure for split shared/
 private accounting of NUMA hinting faults
Git-Commit-ID: ac8e895bd260cb8bb19ade6a3abd44e7abe9a01d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:28:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac8e895bd260cb8bb19ade6a3abd44e7abe9a01d
Gitweb:     http://git.kernel.org/tip/ac8e895bd260cb8bb19ade6a3abd44e7abe9a01d
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:30 +0200

sched/numa: Add infrastructure for split shared/private accounting of NUMA hinting faults

Ideally it would be possible to distinguish between NUMA hinting faults
that are private to a task and those that are shared.  This patch prepares
infrastructure for separately accounting shared and private faults by
allocating the necessary buffers and passing in relevant information. For
now, all faults are treated as private and detection will be introduced
later.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-26-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  5 +++--
 kernel/sched/fair.c   | 46 +++++++++++++++++++++++++++++++++++-----------
 mm/huge_memory.c      |  5 +++--
 mm/memory.c           |  8 ++++++--
 4 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index aecdc5a..d946195 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1445,10 +1445,11 @@ struct task_struct {
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
 #ifdef CONFIG_NUMA_BALANCING
-extern void task_numa_fault(int node, int pages, bool migrated);
+extern void task_numa_fault(int last_node, int node, int pages, bool migrated);
 extern void set_numabalancing_state(bool enabled);
 #else
-static inline void task_numa_fault(int node, int pages, bool migrated)
+static inline void task_numa_fault(int last_node, int node, int pages,
+				   bool migrated)
 {
 }
 static inline void set_numabalancing_state(bool enabled)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8b15e9e..89eeb89 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -886,6 +886,20 @@ static unsigned int task_scan_max(struct task_struct *p)
  */
 unsigned int sysctl_numa_balancing_settle_count __read_mostly = 3;
 
+static inline int task_faults_idx(int nid, int priv)
+{
+	return 2 * nid + priv;
+}
+
+static inline unsigned long task_faults(struct task_struct *p, int nid)
+{
+	if (!p->numa_faults)
+		return 0;
+
+	return p->numa_faults[task_faults_idx(nid, 0)] +
+		p->numa_faults[task_faults_idx(nid, 1)];
+}
+
 static unsigned long weighted_cpuload(const int cpu);
 
 
@@ -928,13 +942,19 @@ static void task_numa_placement(struct task_struct *p)
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
 		unsigned long faults;
+		int priv, i;
 
-		/* Decay existing window and copy faults since last scan */
-		p->numa_faults[nid] >>= 1;
-		p->numa_faults[nid] += p->numa_faults_buffer[nid];
-		p->numa_faults_buffer[nid] = 0;
+		for (priv = 0; priv < 2; priv++) {
+			i = task_faults_idx(nid, priv);
 
-		faults = p->numa_faults[nid];
+			/* Decay existing window, copy faults since last scan */
+			p->numa_faults[i] >>= 1;
+			p->numa_faults[i] += p->numa_faults_buffer[i];
+			p->numa_faults_buffer[i] = 0;
+		}
+
+		/* Find maximum private faults */
+		faults = p->numa_faults[task_faults_idx(nid, 1)];
 		if (faults > max_faults) {
 			max_faults = faults;
 			max_nid = nid;
@@ -970,16 +990,20 @@ static void task_numa_placement(struct task_struct *p)
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int node, int pages, bool migrated)
+void task_numa_fault(int last_nid, int node, int pages, bool migrated)
 {
 	struct task_struct *p = current;
+	int priv;
 
 	if (!numabalancing_enabled)
 		return;
 
+	/* For now, do not attempt to detect private/shared accesses */
+	priv = 1;
+
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults)) {
-		int size = sizeof(*p->numa_faults) * nr_node_ids;
+		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
 
 		/* numa_faults and numa_faults_buffer share the allocation */
 		p->numa_faults = kzalloc(size * 2, GFP_KERNEL|__GFP_NOWARN);
@@ -987,7 +1011,7 @@ void task_numa_fault(int node, int pages, bool migrated)
 			return;
 
 		BUG_ON(p->numa_faults_buffer);
-		p->numa_faults_buffer = p->numa_faults + nr_node_ids;
+		p->numa_faults_buffer = p->numa_faults + (2 * nr_node_ids);
 	}
 
 	/*
@@ -1005,7 +1029,7 @@ void task_numa_fault(int node, int pages, bool migrated)
 
 	task_numa_placement(p);
 
-	p->numa_faults_buffer[node] += pages;
+	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
@@ -4146,7 +4170,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 		return false;
 
 	if (dst_nid == p->numa_preferred_nid ||
-	    p->numa_faults[dst_nid] > p->numa_faults[src_nid])
+	    task_faults(p, dst_nid) > task_faults(p, src_nid))
 		return true;
 
 	return false;
@@ -4170,7 +4194,7 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	    p->numa_migrate_seq >= sysctl_numa_balancing_settle_count)
 		return false;
 
-	if (p->numa_faults[dst_nid] < p->numa_faults[src_nid])
+	if (task_faults(p, dst_nid) < task_faults(p, src_nid))
 		return true;
 
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8677dbf..9142167 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1282,7 +1282,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	int page_nid = -1, this_nid = numa_node_id();
-	int target_nid;
+	int target_nid, last_nid = -1;
 	bool page_locked;
 	bool migrated = false;
 
@@ -1293,6 +1293,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	page = pmd_page(pmd);
 	BUG_ON(is_huge_zero_page(page));
 	page_nid = page_to_nid(page);
+	last_nid = page_nid_last(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
 	if (page_nid == this_nid)
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
@@ -1361,7 +1362,7 @@ out:
 		page_unlock_anon_vma_read(anon_vma);
 
 	if (page_nid != -1)
-		task_numa_fault(page_nid, HPAGE_PMD_NR, migrated);
+		task_numa_fault(last_nid, page_nid, HPAGE_PMD_NR, migrated);
 
 	return 0;
 }
diff --git a/mm/memory.c b/mm/memory.c
index ed51f15..24bc9b8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3536,6 +3536,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page = NULL;
 	spinlock_t *ptl;
 	int page_nid = -1;
+	int last_nid;
 	int target_nid;
 	bool migrated = false;
 
@@ -3566,6 +3567,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
+	last_nid = page_nid_last(page);
 	page_nid = page_to_nid(page);
 	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
 	pte_unmap_unlock(ptep, ptl);
@@ -3581,7 +3583,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 out:
 	if (page_nid != -1)
-		task_numa_fault(page_nid, 1, migrated);
+		task_numa_fault(last_nid, page_nid, 1, migrated);
 	return 0;
 }
 
@@ -3596,6 +3598,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long offset;
 	spinlock_t *ptl;
 	bool numa = false;
+	int last_nid;
 
 	spin_lock(&mm->page_table_lock);
 	pmd = *pmdp;
@@ -3643,6 +3646,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (unlikely(page_mapcount(page) != 1))
 			continue;
 
+		last_nid = page_nid_last(page);
 		page_nid = page_to_nid(page);
 		target_nid = numa_migrate_prep(page, vma, addr, page_nid);
 		pte_unmap_unlock(pte, ptl);
@@ -3655,7 +3659,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 
 		if (page_nid != -1)
-			task_numa_fault(page_nid, 1, migrated);
+			task_numa_fault(last_nid, page_nid, 1, migrated);
 
 		pte = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	}
