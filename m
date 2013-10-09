Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3JIRZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:25:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3JIRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:25:46 -0400
Date: Wed, 9 Oct 2013 10:25:02 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-8191acbd30c73e45c24ad16c372e0b42cc7ac8f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-8-git-send-email-mgorman@suse.de>
References: <1381141781-10992-8-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa: Sanitize task_numa_fault() callsites
Git-Commit-ID: 8191acbd30c73e45c24ad16c372e0b42cc7ac8f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:25:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8191acbd30c73e45c24ad16c372e0b42cc7ac8f8
Gitweb:     http://git.kernel.org/tip/8191acbd30c73e45c24ad16c372e0b42cc7ac8f8
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:44 +0200

mm: numa: Sanitize task_numa_fault() callsites

There are three callers of task_numa_fault():

 - do_huge_pmd_numa_page():
     Accounts against the current node, not the node where the
     page resides, unless we migrated, in which case it accounts
     against the node we migrated to.

 - do_numa_page():
     Accounts against the current node, not the node where the
     page resides, unless we migrated, in which case it accounts
     against the node we migrated to.

 - do_pmd_numa_page():
     Accounts not at all when the page isn't migrated, otherwise
     accounts against the node we migrated towards.

This seems wrong to me; all three sites should have the same
sementaics, furthermore we should accounts against where the page
really is, we already know where the task is.

So modify all three sites to always account; we did after all receive
the fault; and always account to where the page is after migration,
regardless of success.

They all still differ on when they clear the PTE/PMD; ideally that
would get sorted too.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-8-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 25 +++++++++++++------------
 mm/memory.c      | 53 +++++++++++++++++++++--------------------------------
 2 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d6334f..c3bb65f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1281,18 +1281,19 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct anon_vma *anon_vma = NULL;
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	int page_nid = -1, this_nid = numa_node_id();
 	int target_nid;
-	int current_nid = -1;
-	bool migrated, page_locked;
+	bool page_locked;
+	bool migrated = false;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
 	page = pmd_page(pmd);
-	current_nid = page_to_nid(page);
+	page_nid = page_to_nid(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (current_nid == numa_node_id())
+	if (page_nid == this_nid)
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 
 	/*
@@ -1335,19 +1336,18 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
-	if (!migrated)
+	if (migrated)
+		page_nid = target_nid;
+	else
 		goto check_same;
 
-	task_numa_fault(target_nid, HPAGE_PMD_NR, true);
-	if (anon_vma)
-		page_unlock_anon_vma_read(anon_vma);
-	return 0;
+	goto out;
 
 check_same:
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		/* Someone else took our fault */
-		current_nid = -1;
+		page_nid = -1;
 		goto out_unlock;
 	}
 clear_pmdnuma:
@@ -1362,8 +1362,9 @@ out:
 	if (anon_vma)
 		page_unlock_anon_vma_read(anon_vma);
 
-	if (current_nid != -1)
-		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
+	if (page_nid != -1)
+		task_numa_fault(page_nid, HPAGE_PMD_NR, migrated);
+
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index ca00039..42ae82e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3519,12 +3519,12 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 }
 
 int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
-				unsigned long addr, int current_nid)
+				unsigned long addr, int page_nid)
 {
 	get_page(page);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (current_nid == numa_node_id())
+	if (page_nid == numa_node_id())
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 
 	return mpol_misplaced(page, vma, addr);
@@ -3535,7 +3535,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	int current_nid = -1;
+	int page_nid = -1;
 	int target_nid;
 	bool migrated = false;
 
@@ -3565,15 +3565,10 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return 0;
 	}
 
-	current_nid = page_to_nid(page);
-	target_nid = numa_migrate_prep(page, vma, addr, current_nid);
+	page_nid = page_to_nid(page);
+	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
 	pte_unmap_unlock(ptep, ptl);
 	if (target_nid == -1) {
-		/*
-		 * Account for the fault against the current node if it not
-		 * being replaced regardless of where the page is located.
-		 */
-		current_nid = numa_node_id();
 		put_page(page);
 		goto out;
 	}
@@ -3581,11 +3576,11 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Migrate to the requested node */
 	migrated = migrate_misplaced_page(page, target_nid);
 	if (migrated)
-		current_nid = target_nid;
+		page_nid = target_nid;
 
 out:
-	if (current_nid != -1)
-		task_numa_fault(current_nid, 1, migrated);
+	if (page_nid != -1)
+		task_numa_fault(page_nid, 1, migrated);
 	return 0;
 }
 
@@ -3600,7 +3595,6 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long offset;
 	spinlock_t *ptl;
 	bool numa = false;
-	int local_nid = numa_node_id();
 
 	spin_lock(&mm->page_table_lock);
 	pmd = *pmdp;
@@ -3623,9 +3617,10 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	for (addr = _addr + offset; addr < _addr + PMD_SIZE; pte++, addr += PAGE_SIZE) {
 		pte_t pteval = *pte;
 		struct page *page;
-		int curr_nid = local_nid;
+		int page_nid = -1;
 		int target_nid;
-		bool migrated;
+		bool migrated = false;
+
 		if (!pte_present(pteval))
 			continue;
 		if (!pte_numa(pteval))
@@ -3647,25 +3642,19 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (unlikely(page_mapcount(page) != 1))
 			continue;
 
-		/*
-		 * Note that the NUMA fault is later accounted to either
-		 * the node that is currently running or where the page is
-		 * migrated to.
-		 */
-		curr_nid = local_nid;
-		target_nid = numa_migrate_prep(page, vma, addr,
-					       page_to_nid(page));
-		if (target_nid == -1) {
+		page_nid = page_to_nid(page);
+		target_nid = numa_migrate_prep(page, vma, addr, page_nid);
+		pte_unmap_unlock(pte, ptl);
+		if (target_nid != -1) {
+			migrated = migrate_misplaced_page(page, target_nid);
+			if (migrated)
+				page_nid = target_nid;
+		} else {
 			put_page(page);
-			continue;
 		}
 
-		/* Migrate to the requested node */
-		pte_unmap_unlock(pte, ptl);
-		migrated = migrate_misplaced_page(page, target_nid);
-		if (migrated)
-			curr_nid = target_nid;
-		task_numa_fault(curr_nid, 1, migrated);
+		if (page_nid != -1)
+			task_numa_fault(page_nid, 1, migrated);
 
 		pte = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	}
