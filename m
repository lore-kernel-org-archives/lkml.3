Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaKYTsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:48:54 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:50774 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaKYTsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:48:53 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [rfc patch] mm: protect set_page_dirty() from ongoing truncation
Date: Tue, 25 Nov 2014 14:48:41 -0500
Message-Id: <1416944921-14164-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, while reviewing the code, spotted the following race condition
between the dirtying and truncation of a page:

__set_page_dirty_nobuffers()       __delete_from_page_cache()
  if (TestSetPageDirty(page))
                                     page->mapping = NULL
				     if (PageDirty())
				       dec_zone_page_state(page, NR_FILE_DIRTY);
				       dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
    if (page->mapping)
      account_page_dirtied(page)
        __inc_zone_page_state(page, NR_FILE_DIRTY);
	__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);

which results in an imbalance of NR_FILE_DIRTY and BDI_RECLAIMABLE.

Dirtiers usually lock out truncation, either by holding the page lock
directly, or in case of zap_pte_range(), by pinning the mapcount with
the page table lock held.  The notable exception to this rule, though,
is do_wp_page(), for which this race exists.  However, do_wp_page()
already waits for a locked page to unlock before setting the dirty
bit, in order to prevent a race where clear_page_dirty() misses the
page bit in the presence of dirty ptes.  Upgrade that wait to a fully
locked set_page_dirty() to also cover the situation explained above.

Afterwards, the code in set_page_dirty() dealing with a truncation
race is no longer needed.  Remove it.

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c         | 11 ++---------
 mm/page-writeback.c | 33 ++++++++++++---------------------
 2 files changed, 14 insertions(+), 30 deletions(-)

It is unfortunate to hold the page lock while balancing dirty pages,
but I don't see what else would protect mapping at that point.  The
same btw applies for the page_mkwrite case: how is mapping safe to
pass to balance_dirty_pages() after unlocking page table and page?

diff --git a/mm/memory.c b/mm/memory.c
index 3e503831e042..27aaee6b6f4a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2150,17 +2150,10 @@ reuse:
 		if (!dirty_page)
 			return ret;
 
-		/*
-		 * Yes, Virginia, this is actually required to prevent a race
-		 * with clear_page_dirty_for_io() from clearing the page dirty
-		 * bit after it clear all dirty ptes, but before a racing
-		 * do_wp_page installs a dirty pte.
-		 *
-		 * do_shared_fault is protected similarly.
-		 */
 		if (!page_mkwrite) {
-			wait_on_page_locked(dirty_page);
+			lock_page(dirty_page);
 			set_page_dirty_balance(dirty_page);
+			unlock_page(dirty_page);
 			/* file_update_time outside page_lock */
 			if (vma->vm_file)
 				file_update_time(vma->vm_file);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 19ceae87522d..86773236f42a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2123,32 +2123,25 @@ EXPORT_SYMBOL(account_page_dirtied);
  * page dirty in that case, but not all the buffers.  This is a "bottom-up"
  * dirtying, whereas __set_page_dirty_buffers() is a "top-down" dirtying.
  *
- * Most callers have locked the page, which pins the address_space in memory.
- * But zap_pte_range() does not lock the page, however in that case the
- * mapping is pinned by the vma's ->vm_file reference.
- *
- * We take care to handle the case where the page was truncated from the
- * mapping by re-checking page_mapping() inside tree_lock.
+ * The caller must ensure this doesn't race with truncation.  Most will simply
+ * hold the page lock, but e.g. zap_pte_range() calls with the page mapped and
+ * the pte lock held, which also locks out truncation.
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
-		struct address_space *mapping2;
 		unsigned long flags;
 
 		if (!mapping)
 			return 1;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
-		mapping2 = page_mapping(page);
-		if (mapping2) { /* Race with truncate? */
-			BUG_ON(mapping2 != mapping);
-			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
-			account_page_dirtied(page, mapping);
-			radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-		}
+		BUG_ON(page_mapping(page) != mapping);
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		account_page_dirtied(page, mapping);
+		radix_tree_tag_set(&mapping->page_tree, page_index(page),
+				   PAGECACHE_TAG_DIRTY);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
@@ -2305,12 +2298,10 @@ int clear_page_dirty_for_io(struct page *page)
 		/*
 		 * We carefully synchronise fault handlers against
 		 * installing a dirty pte and marking the page dirty
-		 * at this point. We do this by having them hold the
-		 * page lock at some point after installing their
-		 * pte, but before marking the page dirty.
-		 * Pages are always locked coming in here, so we get
-		 * the desired exclusion. See mm/memory.c:do_wp_page()
-		 * for more comments.
+		 * at this point.  We do this by having them hold the
+		 * page lock while dirtying the page, and pages are
+		 * always locked coming in here, so we get the desired
+		 * exclusion.
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-- 
2.1.3
