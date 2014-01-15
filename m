Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaAOWAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:00:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaAOWAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 083/166] mm: numa: serialise parallel get_user_page against THP migration
Date: Wed, 15 Jan 2014 13:51:37 -0800
Message-Id: <1389822780-4729-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 2b4847e73004c10ae6666c2e27b5c5430aed8698 upstream.

Base pages are unmapped and flushed from cache and TLB during normal
page migration and replaced with a migration entry that causes any
parallel NUMA hinting fault or gup to block until migration completes.

THP does not unmap pages due to a lack of support for migration entries
at a PMD level.  This allows races with get_user_pages and
get_user_pages_fast which commit 3f926ab945b6 ("mm: Close races between
THP migration and PMD numa clearing") made worse by introducing a
pmd_clear_flush().

This patch forces get_user_page (fast and normal) on a pmd_numa page to
go through the slow get_user_page path where it will serialise against
THP migration and properly account for the NUMA hinting fault.  On the
migration side the page table lock is taken for each PTE update.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/mm/gup.c | 13 +++++++++++++
 mm/huge_memory.c  | 24 ++++++++++++++++--------
 mm/migrate.c      | 38 +++++++++++++++++++++++++++++++-------
 3 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..0596e8e 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -83,6 +83,12 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
+		/* Similar to the PMD case, NUMA hinting must take slow path */
+		if (pte_numa(pte)) {
+			pte_unmap(ptep);
+			return 0;
+		}
+
 		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
@@ -167,6 +173,13 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
+			/*
+			 * NUMA hinting faults need to be handled in the GUP
+			 * slowpath for accounting purposes and so that they
+			 * can be serialised against THP migration.
+			 */
+			if (pmd_numa(pmd))
+				return 0;
 			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
 				return 0;
 		} else {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9d0b5f5..a72d5ca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1261,6 +1261,10 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(*pmd))
 		return ERR_PTR(-EFAULT);
 
+	/* Full NUMA hinting faults to serialise migration in fault paths */
+	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
+		goto out;
+
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!PageHead(page));
 	if (flags & FOLL_TOUCH) {
@@ -1325,23 +1329,27 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		/* If the page was locked, there are no parallel migrations */
 		if (page_locked)
 			goto clear_pmdnuma;
+	}
 
-		/*
-		 * Otherwise wait for potential migrations and retry. We do
-		 * relock and check_same as the page may no longer be mapped.
-		 * As the fault is being retried, do not account for it.
-		 */
+	/*
+	 * If there are potential migrations, wait for completion and retry. We
+	 * do not relock and check_same as the page may no longer be mapped.
+	 * Furtermore, even if the page is currently misplaced, there is no
+	 * guarantee it is still misplaced after the migration completes.
+	 */
+	if (!page_locked) {
 		spin_unlock(&mm->page_table_lock);
 		wait_on_page_locked(page);
 		page_nid = -1;
 		goto out;
 	}
 
-	/* Page is misplaced, serialise migrations and parallel THP splits */
+	/*
+	 * Page is misplaced. Page lock serialises migrations. Acquire anon_vma
+	 * to serialises splits
+	 */
 	get_page(page);
 	spin_unlock(&mm->page_table_lock);
-	if (!page_locked)
-		lock_page(page);
 	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PTE did not while locked */
diff --git a/mm/migrate.c b/mm/migrate.c
index d2296c5..09c881c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1671,6 +1671,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	struct page *new_page = NULL;
 	struct mem_cgroup *memcg = NULL;
 	int page_lru = page_is_file_cache(page);
+	pmd_t orig_entry;
 
 	/*
 	 * Don't migrate pages that are mapped in multiple processes.
@@ -1712,7 +1713,8 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 
 	/* Recheck the target PMD */
 	spin_lock(&mm->page_table_lock);
-	if (unlikely(!pmd_same(*pmd, entry))) {
+	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
+fail_putback:
 		spin_unlock(&mm->page_table_lock);
 
 		/* Reverse changes made by migrate_page_copy() */
@@ -1742,16 +1744,34 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	 */
 	mem_cgroup_prepare_migration(page, new_page, &memcg);
 
+	orig_entry = *pmd;
 	entry = mk_pmd(new_page, vma->vm_page_prot);
-	entry = pmd_mknonnuma(entry);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 	entry = pmd_mkhuge(entry);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
+	/*
+	 * Clear the old entry under pagetable lock and establish the new PTE.
+	 * Any parallel GUP will either observe the old page blocking on the
+	 * page lock, block on the page table lock or observe the new page.
+	 * The SetPageUptodate on the new page and page_add_new_anon_rmap
+	 * guarantee the copy is visible before the pagetable update.
+	 */
+	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+	page_add_new_anon_rmap(new_page, vma, haddr);
 	pmdp_clear_flush(vma, haddr, pmd);
 	set_pmd_at(mm, haddr, pmd, entry);
-	page_add_new_anon_rmap(new_page, vma, haddr);
 	update_mmu_cache_pmd(vma, address, &entry);
+
+	if (page_count(page) != 2) {
+		set_pmd_at(mm, haddr, pmd, orig_entry);
+		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+		update_mmu_cache_pmd(vma, address, &entry);
+		page_remove_rmap(new_page);
+		goto fail_putback;
+	}
+
 	page_remove_rmap(page);
+
 	/*
 	 * Finish the charge transaction under the page table lock to
 	 * prevent split_huge_page() from dividing up the charge
@@ -1776,9 +1796,13 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 out_fail:
 	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
-	entry = pmd_mknonnuma(entry);
-	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, &entry);
+	spin_lock(&mm->page_table_lock);
+	if (pmd_same(*pmd, entry)) {
+		entry = pmd_mknonnuma(entry);
+		set_pmd_at(mm, haddr, pmd, entry);
+		update_mmu_cache_pmd(vma, address, &entry);
+	}
+	spin_unlock(&mm->page_table_lock);
 
 	unlock_page(page);
 	put_page(page);
-- 
1.8.3.2

