Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3IWMGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:06:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:23103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab3IWMGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="405796220"
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
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv6 10/22] thp, mm: rewrite delete_from_page_cache() to support huge pages
Date: Mon, 23 Sep 2013 15:05:38 +0300
Message-Id: <1379937950-8411-11-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with add_to_page_cache_locked() we handle HPAGE_CACHE_NR pages a
time.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d2d6c0ebe9..60478ebeda 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -115,6 +115,7 @@
 void __delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
+	int i, nr;
 
 	trace_mm_filemap_delete_from_page_cache(page);
 	/*
@@ -127,13 +128,20 @@ void __delete_from_page_cache(struct page *page)
 	else
 		cleancache_invalidate_page(mapping, page);
 
-	radix_tree_delete(&mapping->page_tree, page->index);
+	page->mapping = NULL;
+	nr = hpagecache_nr_pages(page);
+	for (i = 0; i < nr; i++)
+		radix_tree_delete(&mapping->page_tree, page->index + i);
+	/* thp */
+	if (nr > 1)
+		__dec_zone_page_state(page, NR_FILE_TRANSPARENT_HUGEPAGES);
+
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
-	mapping->nrpages--;
-	__dec_zone_page_state(page, NR_FILE_PAGES);
+	mapping->nrpages -= nr;
+	__mod_zone_page_state(page_zone(page), NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page))
-		__dec_zone_page_state(page, NR_SHMEM);
+		__mod_zone_page_state(page_zone(page), NR_SHMEM, -nr);
 	BUG_ON(page_mapped(page));
 
 	/*
@@ -144,8 +152,8 @@ void __delete_from_page_cache(struct page *page)
 	 * having removed the page entirely.
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
-		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		mod_zone_page_state(page_zone(page), NR_FILE_DIRTY, -nr);
+		add_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE, -nr);
 	}
 }
 
-- 
1.8.4.rc3

