Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaAMQZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:25:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaAMQEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 144/208] mm: numa: call MMU notifiers on THP migration
Date: Mon, 13 Jan 2014 15:59:45 +0000
Message-Id: <1389628849-1614-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit f714f4f20e59ea6eea264a86b9a51fd51b88fc54 upstream.

MMU notifiers must be called on THP page migration or secondary MMUs
will get very confused.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/migrate.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b3ffb81..65bbca5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -36,6 +36,7 @@
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 #include <linux/balloon_compaction.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 
@@ -1652,12 +1653,13 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 				unsigned long address,
 				struct page *page, int node)
 {
-	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated = 0;
 	struct page *new_page = NULL;
 	struct mem_cgroup *memcg = NULL;
 	int page_lru = page_is_file_cache(page);
+	unsigned long mmun_start = address & HPAGE_PMD_MASK;
+	unsigned long mmun_end = mmun_start + HPAGE_PMD_SIZE;
 	pmd_t orig_entry;
 
 	/*
@@ -1699,10 +1701,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	WARN_ON(PageLRU(new_page));
 
 	/* Recheck the target PMD */
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
 fail_putback:
 		spin_unlock(&mm->page_table_lock);
+		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 		/* Reverse changes made by migrate_page_copy() */
 		if (TestClearPageActive(new_page))
@@ -1743,15 +1747,16 @@ fail_putback:
 	 * The SetPageUptodate on the new page and page_add_new_anon_rmap
 	 * guarantee the copy is visible before the pagetable update.
 	 */
-	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-	page_add_new_anon_rmap(new_page, vma, haddr);
-	pmdp_clear_flush(vma, haddr, pmd);
-	set_pmd_at(mm, haddr, pmd, entry);
+	flush_cache_range(vma, mmun_start, mmun_end);
+	page_add_new_anon_rmap(new_page, vma, mmun_start);
+	pmdp_clear_flush(vma, mmun_start, pmd);
+	set_pmd_at(mm, mmun_start, pmd, entry);
+	flush_tlb_range(vma, mmun_start, mmun_end);
 	update_mmu_cache_pmd(vma, address, &entry);
 
 	if (page_count(page) != 2) {
-		set_pmd_at(mm, haddr, pmd, orig_entry);
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+		set_pmd_at(mm, mmun_start, pmd, orig_entry);
+		flush_tlb_range(vma, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
 		page_remove_rmap(new_page);
 		goto fail_putback;
@@ -1766,6 +1771,7 @@ fail_putback:
 	 */
 	mem_cgroup_end_migration(memcg, page, new_page, true);
 	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	unlock_page(new_page);
 	unlock_page(page);
@@ -1786,7 +1792,7 @@ out_dropref:
 	spin_lock(&mm->page_table_lock);
 	if (pmd_same(*pmd, entry)) {
 		entry = pmd_mknonnuma(entry);
-		set_pmd_at(mm, haddr, pmd, entry);
+		set_pmd_at(mm, mmun_start, pmd, entry);
 		update_mmu_cache_pmd(vma, address, &entry);
 	}
 	spin_unlock(&mm->page_table_lock);
-- 
1.8.3.2

