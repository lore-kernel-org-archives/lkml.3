Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3JUVqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:46:42 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46559 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3JUVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:46:39 -0400
Date: Mon, 21 Oct 2013 14:46:34 -0700
From: Ning Qu <quning@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>, Ning Qu <quning@gmail.com>
Subject: [PATCHv2 03/13] mm, thp, tmpfs: support to add huge page into page
 cache for tmpfs
Message-ID: <20131021214634.GD29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For replacing a page inside page cache, we assume the huge page
has been splitted before getting here.

For adding a new page to page cache, huge page support has been added.

Also refactor the shm_add_to_page_cache function.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a857ba8..45fcca2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -277,27 +277,23 @@ static bool shmem_confirm_swap(struct address_space *mapping,
 }
 
 /*
- * Like add_to_page_cache_locked, but error if expected item has gone.
+ * Replace the swap entry with page cache entry
  */
-static int shmem_add_to_page_cache(struct page *page,
+static int shmem_replace_page_page_cache(struct page *page,
 				   struct address_space *mapping,
 				   pgoff_t index, gfp_t gfp, void *expected)
 {
 	int error;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!PageSwapBacked(page));
+	BUG_ON(PageTransHugeCache(page));
 
 	page_cache_get(page);
 	page->mapping = mapping;
 	page->index = index;
 
 	spin_lock_irq(&mapping->tree_lock);
-	if (!expected)
-		error = radix_tree_insert(&mapping->page_tree, index, page);
-	else
-		error = shmem_radix_tree_replace(mapping, index, expected,
-								 page);
+
+	error = shmem_radix_tree_replace(mapping, index, expected, page);
 	if (!error) {
 		mapping->nrpages++;
 		__inc_zone_page_state(page, NR_FILE_PAGES);
@@ -312,6 +308,63 @@ static int shmem_add_to_page_cache(struct page *page,
 }
 
 /*
+ * Insert new page into with page cache
+ */
+static int shmem_insert_page_page_cache(struct page *page,
+				   struct address_space *mapping,
+				   pgoff_t index, gfp_t gfp)
+{
+	int error;
+	int nr;
+
+	if (PageTransHugeCache(page))
+		BUILD_BUG_ON(HPAGE_CACHE_NR > RADIX_TREE_PRELOAD_NR);
+
+	nr = hpagecache_nr_pages(page);
+
+	error = radix_tree_maybe_preload_contig(nr, gfp & ~__GFP_HIGHMEM);
+	if (error)
+		return error;
+
+	spin_lock_irq(&mapping->tree_lock);
+
+	error = __add_to_page_cache_locked(page, mapping, index);
+
+	if (!error)
+		__mod_zone_page_state(page_zone(page), NR_SHMEM, nr);
+
+	radix_tree_preload_end();
+	spin_unlock_irq(&mapping->tree_lock);
+
+	if (error)
+		page_cache_release(page);
+
+	return error;
+}
+
+/*
+ * Like add_to_page_cache_locked, but error if expected item has gone.
+ */
+static int shmem_add_to_page_cache(struct page *page,
+				   struct address_space *mapping,
+				   pgoff_t index, gfp_t gfp, void *expected)
+{
+	int error;
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageSwapBacked(page));
+
+	if (expected) {
+		BUG_ON(PageTransHugeCache(page));
+		error = shmem_replace_page_page_cache(page, mapping, index, gfp,
+							expected);
+	} else
+		error = shmem_insert_page_page_cache(page, mapping, index, gfp);
+
+	return error;
+}
+
+/*
  * Like delete_from_page_cache, but substitutes swap for page.
  */
 static void shmem_delete_from_page_cache(struct page *page, void *radswap)
@@ -319,6 +372,8 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 	struct address_space *mapping = page->mapping;
 	int error;
 
+	BUG_ON(PageTransHugeCache(page));
+
 	spin_lock_irq(&mapping->tree_lock);
 	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
 	page->mapping = NULL;
-- 
1.8.4

