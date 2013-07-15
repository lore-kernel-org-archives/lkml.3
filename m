Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3GOKrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:47:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:11439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab3GOKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="370365364"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 4/8] mm: cleanup add_to_page_cache_locked()
Date: Mon, 15 Jul 2013 13:47:50 +0300
Message-Id: <1373885274-25249-5-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373885274-25249-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1373885274-25249-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The patch makes add_to_page_cache_locked() cleaner:
 - unindent most code of the function by inverting one condition;
 - streamline code no-error path;
 - move insert error path outside normal code path;
 - call radix_tree_preload_end() earlier;

No functional changes.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 mm/filemap.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f6fe61f..f7c4ed5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -467,32 +467,34 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
-		goto out;
+		return error;
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
-	if (error == 0) {
-		page_cache_get(page);
-		page->mapping = mapping;
-		page->index = offset;
-
-		spin_lock_irq(&mapping->tree_lock);
-		error = radix_tree_insert(&mapping->page_tree, offset, page);
-		if (likely(!error)) {
-			mapping->nrpages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			spin_unlock_irq(&mapping->tree_lock);
-			trace_mm_filemap_add_to_page_cache(page);
-		} else {
-			page->mapping = NULL;
-			/* Leave page->index set: truncation relies upon it */
-			spin_unlock_irq(&mapping->tree_lock);
-			mem_cgroup_uncharge_cache_page(page);
-			page_cache_release(page);
-		}
-		radix_tree_preload_end();
-	} else
+	if (error) {
 		mem_cgroup_uncharge_cache_page(page);
-out:
+		return error;
+	}
+
+	page_cache_get(page);
+	page->mapping = mapping;
+	page->index = offset;
+
+	spin_lock_irq(&mapping->tree_lock);
+	error = radix_tree_insert(&mapping->page_tree, offset, page);
+	radix_tree_preload_end();
+	if (unlikely(!error))
+		goto err_insert;
+	mapping->nrpages++;
+	__inc_zone_page_state(page, NR_FILE_PAGES);
+	spin_unlock_irq(&mapping->tree_lock);
+	trace_mm_filemap_add_to_page_cache(page);
+	return 0;
+err_insert:
+	page->mapping = NULL;
+	/* Leave page->index set: truncation relies upon it */
+	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
+	page_cache_release(page);
 	return error;
 }
 EXPORT_SYMBOL(add_to_page_cache_locked);
-- 
1.8.3.2

