Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3KHCUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:20:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab3KHCU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:20:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 78/91] mm: Close races between THP migration and PMD numa clearing
Date: Thu,  7 Nov 2013 18:15:33 -0800
Message-Id: <1383876946-2396-79-git-send-email-kamal@canonical.com>
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

commit 3f926ab945b60a5824369d21add7710622a2eac0 upstream.

THP migration uses the page lock to guard against parallel allocations
but there are cases like this still open

  Task A					Task B
  ---------------------				---------------------
  do_huge_pmd_numa_page				do_huge_pmd_numa_page
  lock_page
  mpol_misplaced == -1
  unlock_page
  goto clear_pmdnuma
						lock_page
						mpol_misplaced == 2
						migrate_misplaced_transhuge
  pmd = pmd_mknonnuma
  set_pmd_at

During hours of testing, one crashed with weird errors and while I have
no direct evidence, I suspect something like the race above happened.
This patch extends the page lock to being held until the pmd_numa is
cleared to prevent migration starting in parallel while the pmd_numa is
being cleared. It also flushes the old pmd entry and orders pagetable
insertion before rmap insertion.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-9-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 29 +++++++++++++++--------------
 mm/migrate.c     | 19 +++++++++++--------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1390fdd..9c37776 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1323,24 +1323,25 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	target_nid = mpol_misplaced(page, vma, haddr);
 	if (target_nid == -1) {
 		/* If the page was locked, there are no parallel migrations */
-		if (page_locked) {
-			unlock_page(page);
+		if (page_locked)
 			goto clear_pmdnuma;
-		}
 
-		/* Otherwise wait for potential migrations and retry fault */
+		/*
+		 * Otherwise wait for potential migrations and retry. We do
+		 * relock and check_same as the page may no longer be mapped.
+		 * As the fault is being retried, do not account for it.
+		 */
 		spin_unlock(&mm->page_table_lock);
 		wait_on_page_locked(page);
+		page_nid = -1;
 		goto out;
 	}
 
 	/* Page is misplaced, serialise migrations and parallel THP splits */
 	get_page(page);
 	spin_unlock(&mm->page_table_lock);
-	if (!page_locked) {
+	if (!page_locked)
 		lock_page(page);
-		page_locked = true;
-	}
 	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PTE did not while locked */
@@ -1348,29 +1349,29 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);
 		put_page(page);
+		page_nid = -1;
 		goto out_unlock;
 	}
 
-	/* Migrate the THP to the requested node */
+	/*
+	 * Migrate the THP to the requested node, returns with page unlocked
+	 * and pmd_numa cleared.
+	 */
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
 	if (migrated)
 		page_nid = target_nid;
-	else
-		goto check_same;
 
 	goto out;
 
-check_same:
-	spin_lock(&mm->page_table_lock);
-	if (unlikely(!pmd_same(pmd, *pmdp)))
-		goto out_unlock;
 clear_pmdnuma:
+	BUG_ON(!PageLocked(page));
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	VM_BUG_ON(pmd_numa(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
+	unlock_page(page);
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 811a2ca..d2296c5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1725,12 +1725,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 		unlock_page(new_page);
 		put_page(new_page);		/* Free it */
 
-		unlock_page(page);
+		/* Retake the callers reference and putback on LRU */
+		get_page(page);
 		putback_lru_page(page);
-
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
-		isolated = 0;
-		goto out;
+		mod_zone_page_state(page_zone(page),
+			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
+		goto out_fail;
 	}
 
 	/*
@@ -1747,9 +1747,9 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 	entry = pmd_mkhuge(entry);
 
-	page_add_new_anon_rmap(new_page, vma, haddr);
-
+	pmdp_clear_flush(vma, haddr, pmd);
 	set_pmd_at(mm, haddr, pmd, entry);
+	page_add_new_anon_rmap(new_page, vma, haddr);
 	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	/*
@@ -1768,7 +1768,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
 	count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);
 
-out:
 	mod_zone_page_state(page_zone(page),
 			NR_ISOLATED_ANON + page_lru,
 			-HPAGE_PMD_NR);
@@ -1777,6 +1776,10 @@ out:
 out_fail:
 	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
+	entry = pmd_mknonnuma(entry);
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
+
 	unlock_page(page);
 	put_page(page);
 	return 0;
-- 
1.8.1.2

