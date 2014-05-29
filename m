Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaE2HVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:21:06 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33165 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066AbaE2HVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:21:04 -0400
Subject: [PATCH] mm: make try_to_unmap_one static and cleanup ttu_flags
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 11:20:54 +0400
Message-ID: <20140529072054.12187.36670.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowdays try_to_unmap_one() is used only inside mm/rmap.c, this patch makes it
static. Also it transforms action part of ttu_flags into individiual bits.
These flags aren't part of any uses-space visible api or even trace events.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 include/linux/rmap.h |   11 +++--------
 mm/rmap.c            |   14 +++++++-------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index b66c211..1960daa 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -72,10 +72,9 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
-	TTU_UNMAP = 0,			/* unmap mode */
-	TTU_MIGRATION = 1,		/* migration mode */
-	TTU_MUNLOCK = 2,		/* munlock mode */
-	TTU_ACTION_MASK = 0xff,
+	TTU_UNMAP = 1,			/* unmap mode */
+	TTU_MIGRATION = 2,		/* migration mode */
+	TTU_MUNLOCK = 4,		/* munlock mode */
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
@@ -186,11 +185,7 @@ int page_referenced(struct page *, int is_locked,
 int page_referenced_one(struct page *, struct vm_area_struct *,
 	unsigned long address, void *arg);
 
-#define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
-
 int try_to_unmap(struct page *, enum ttu_flags flags);
-int try_to_unmap_one(struct page *, struct vm_area_struct *,
-			unsigned long address, void *arg);
 
 /*
  * Called from mm/filemap_xip.c to unmap empty zero page
diff --git a/mm/rmap.c b/mm/rmap.c
index 75d9d5c..b8e78be 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1112,8 +1112,8 @@ out:
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
-int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
-		     unsigned long address, void *arg)
+static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
+			    unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte;
@@ -1135,7 +1135,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		if (vma->vm_flags & VM_LOCKED)
 			goto out_mlock;
 
-		if (TTU_ACTION(flags) == TTU_MUNLOCK)
+		if (flags & TTU_MUNLOCK)
 			goto out_unmap;
 	}
 	if (!(flags & TTU_IGNORE_ACCESS)) {
@@ -1203,7 +1203,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
+			BUG_ON(!(flags & TTU_MIGRATION));
 			entry = make_migration_entry(page, pte_write(pteval));
 		}
 		swp_pte = swp_entry_to_pte(entry);
@@ -1212,7 +1212,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		set_pte_at(mm, address, pte, swp_pte);
 		BUG_ON(pte_file(*pte));
 	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
+		   (flags & TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1225,7 +1225,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
+	if (ret != SWAP_FAIL && !(flags & TTU_MUNLOCK))
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
@@ -1512,7 +1512,7 @@ int try_to_unmap(struct page *page, enum ttu_flags flags)
 	 * locking requirements of exec(), migration skips
 	 * temporary VMAs until after exec() completes.
 	 */
-	if (flags & TTU_MIGRATION && !PageKsm(page) && PageAnon(page))
+	if ((flags & TTU_MIGRATION) && !PageKsm(page) && PageAnon(page))
 		rwc.invalid_vma = invalid_migration_vma;
 
 	ret = rmap_walk(page, &rwc);

