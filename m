Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbaFIQEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:04:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:13348 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697AbaFIQEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1003,1392192000"; 
   d="scan'208";a="552722802"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 09/10] futex, thp: remove special case for THP in get_futex_key
Date: Mon,  9 Jun 2014 19:04:20 +0300
Message-Id: <1402329861-7037-10-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With new THP refcounting, we don't need tricks to stabilize huge page.
If we've got reference to tail page, it can't split under us.

This patch effectively reverts a5b338f2b0b1.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 kernel/futex.c | 62 ++++++++++++----------------------------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b632b5f3f094..d13ad5e80ab9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -391,7 +391,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct page *page, *page_head;
+	struct page *page;
 	int err, ro = 0;
 
 	/*
@@ -434,46 +434,10 @@ again:
 	else
 		err = 0;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	page_head = page;
-	if (unlikely(PageTail(page))) {
-		put_page(page);
-		/* serialize against __split_huge_page_splitting() */
-		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
-			page_head = compound_head(page);
-			/*
-			 * page_head is valid pointer but we must pin
-			 * it before taking the PG_lock and/or
-			 * PG_compound_lock. The moment we re-enable
-			 * irqs __split_huge_page_splitting() can
-			 * return and the head page can be freed from
-			 * under us. We can't take the PG_lock and/or
-			 * PG_compound_lock on a page that could be
-			 * freed from under us.
-			 */
-			if (page != page_head) {
-				get_page(page_head);
-				put_page(page);
-			}
-			local_irq_enable();
-		} else {
-			local_irq_enable();
-			goto again;
-		}
-	}
-#else
-	page_head = compound_head(page);
-	if (page != page_head) {
-		get_page(page_head);
-		put_page(page);
-	}
-#endif
-
-	lock_page(page_head);
-
+	page = compound_head(page);
+	lock_page(page);
 	/*
-	 * If page_head->mapping is NULL, then it cannot be a PageAnon
+	 * If page->mapping is NULL, then it cannot be a PageAnon
 	 * page; but it might be the ZERO_PAGE or in the gate area or
 	 * in a special mapping (all cases which we are happy to fail);
 	 * or it may have been a good file page when get_user_pages_fast
@@ -485,12 +449,12 @@ again:
 	 *
 	 * The case we do have to guard against is when memory pressure made
 	 * shmem_writepage move it from filecache to swapcache beneath us:
-	 * an unlikely race, but we do need to retry for page_head->mapping.
+	 * an unlikely race, but we do need to retry for page->mapping.
 	 */
-	if (!page_head->mapping) {
-		int shmem_swizzled = PageSwapCache(page_head);
-		unlock_page(page_head);
-		put_page(page_head);
+	if (!page->mapping) {
+		int shmem_swizzled = PageSwapCache(page);
+		unlock_page(page);
+		put_page(page);
 		if (shmem_swizzled)
 			goto again;
 		return -EFAULT;
@@ -503,7 +467,7 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page_head)) {
+	if (PageAnon(page)) {
 		/*
 		 * A RO anonymous page will never change and thus doesn't make
 		 * sense for futex operations.
@@ -518,15 +482,15 @@ again:
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page_head->mapping->host;
+		key->shared.inode = page->mapping->host;
 		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
-	unlock_page(page_head);
-	put_page(page_head);
+	unlock_page(page);
+	put_page(page);
 	return err;
 }
 
-- 
2.0.0.rc4

