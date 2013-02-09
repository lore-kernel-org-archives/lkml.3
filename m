Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947509Ab3BIAE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:04:56 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:63105 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947321Ab3BIAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:04:06 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] mm: accelerate munlock() treatment of THP pages
Date: Fri,  8 Feb 2013 16:03:57 -0800
Message-Id: <1360368237-26768-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360368237-26768-1-git-send-email-walken@google.com>
References: <1360368237-26768-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

munlock_vma_pages_range() was always incrementing addresses by PAGE_SIZE
at a time. When munlocking THP pages (or the huge zero page), this resulted
in taking the mm->page_table_lock 512 times in a row.

We can do better by making use of the page_mask returned by follow_page_mask
(for the huge zero page case), or the size of the page munlock_vma_page()
operated on (for the true THP page case).

Note - I am sending this as RFC only for now as I can't currently put
my finger on what if anything prevents split_huge_page() from operating
concurrently on the same page as munlock_vma_page(), which would mess
up our NR_MLOCK statistics. Is this a latent bug or is there a subtle
point I missed here ?

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/internal.h |  2 +-
 mm/mlock.c    | 34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1c0c4cc0fcf7..8562de0a5197 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -195,7 +195,7 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
  * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
-extern void munlock_vma_page(struct page *page);
+extern unsigned int munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
diff --git a/mm/mlock.c b/mm/mlock.c
index 1f863a1481d3..486c7f1b5462 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -102,13 +102,16 @@ void mlock_vma_page(struct page *page)
  * can't isolate the page, we leave it for putback_lru_page() and vmscan
  * [page_referenced()/try_to_unmap()] to deal with.
  */
-void munlock_vma_page(struct page *page)
+unsigned int munlock_vma_page(struct page *page)
 {
+	unsigned int page_mask = 0;
+
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    -hpage_nr_pages(page));
+		unsigned int nr_pages = hpage_nr_pages(page);
+		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		page_mask = nr_pages - 1;
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
@@ -141,6 +144,8 @@ void munlock_vma_page(struct page *page)
 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 		}
 	}
+
+	return page_mask;
 }
 
 /**
@@ -159,7 +164,6 @@ long __mlock_vma_pages_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 
@@ -185,7 +189,7 @@ long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
 		gup_flags |= FOLL_FORCE;
 
-	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
+	return __get_user_pages(current, mm, start, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }
 
@@ -222,13 +226,12 @@ static int __mlock_posix_error_return(long retval)
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
-	unsigned long addr;
-
-	lru_add_drain();
 	vma->vm_flags &= ~VM_LOCKED;
 
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
+	while (start < end) {
 		struct page *page;
+		unsigned int page_mask, page_increm;
+
 		/*
 		 * Although FOLL_DUMP is intended for get_dump_page(),
 		 * it just so happens that its special treatment of the
@@ -236,13 +239,22 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 		 * suits munlock very well (and if somehow an abnormal page
 		 * has sneaked into the range, we won't oops here: great).
 		 */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
+					&page_mask);
 		if (page && !IS_ERR(page)) {
 			lock_page(page);
-			munlock_vma_page(page);
+			lru_add_drain();
+			/*
+			 * Any THP page found by follow_page_mask() may have
+			 * gotten split before reaching munlock_vma_page(),
+			 * so we need to recompute the page_mask here.
+			 */
+			page_mask = munlock_vma_page(page);
 			unlock_page(page);
 			put_page(page);
 		}
+		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+		start += page_increm * PAGE_SIZE;
 		cond_resched();
 	}
 }
-- 
1.8.1
