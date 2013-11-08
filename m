Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3KHCTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:19:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3KHCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:19:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 77/91] mm: numa: Sanitize task_numa_fault() callsites
Date: Thu,  7 Nov 2013 18:15:32 -0800
Message-Id: <1383876946-2396-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit c61109e34f60f6e85bb43c5a1cd51c0e3db40847 upstream.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 23 ++++++++++++-----------
 mm/memory.c      | 53 +++++++++++++++++++++--------------------------------
 2 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b698c7b..1390fdd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1300,18 +1300,19 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -1354,13 +1355,12 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -1378,8 +1378,9 @@ out:
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
index 35b6109..5bcfbc1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3485,12 +3485,12 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3501,7 +3501,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	int current_nid = -1;
+	int page_nid = -1;
 	int target_nid;
 	bool migrated = false;
 
@@ -3531,15 +3531,10 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3547,11 +3542,11 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
 
@@ -3566,7 +3561,6 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long offset;
 	spinlock_t *ptl;
 	bool numa = false;
-	int local_nid = numa_node_id();
 
 	spin_lock(&mm->page_table_lock);
 	pmd = *pmdp;
@@ -3589,9 +3583,10 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3613,25 +3608,19 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
-- 
1.8.1.2

