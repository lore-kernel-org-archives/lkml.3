Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594Ab3CNRzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:55:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:49929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934537Ab3CNRtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="302267346"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 16/30] thp: handle file pages in split_huge_page()
Date: Thu, 14 Mar 2013 19:50:21 +0200
Message-Id: <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The base scheme is the same as for anonymous pages, but we walk by
mapping->i_mmap rather then anon_vma->rb_root.

__split_huge_page_refcount() has been tunned a bit: we need to transfer
PG_swapbacked to tail pages.

Splitting mapped pages haven't tested at all, since we cannot mmap()
file-backed huge pages yet.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2f7f5aa..eb777d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1613,7 +1613,8 @@ static void __split_huge_page_refcount(struct page *page)
 				     ((1L << PG_referenced) |
 				      (1L << PG_swapbacked) |
 				      (1L << PG_mlocked) |
-				      (1L << PG_uptodate)));
+				      (1L << PG_uptodate) |
+				      (1L << PG_swapbacked)));
 		page_tail->flags |= (1L << PG_dirty);
 
 		/* clear PageTail before overwriting first_page */
@@ -1641,10 +1642,8 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->index = page->index + i;
 		page_nid_xchg_last(page_tail, page_nid_last(page));
 
-		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
 		BUG_ON(!PageDirty(page_tail));
-		BUG_ON(!PageSwapBacked(page_tail));
 
 		lru_add_page_tail(page, page_tail, lruvec);
 	}
@@ -1752,7 +1751,7 @@ static int __split_huge_page_map(struct page *page,
 }
 
 /* must be called with anon_vma->root->rwsem held */
-static void __split_huge_page(struct page *page,
+static void __split_anon_huge_page(struct page *page,
 			      struct anon_vma *anon_vma)
 {
 	int mapcount, mapcount2;
@@ -1799,14 +1798,11 @@ static void __split_huge_page(struct page *page,
 	BUG_ON(mapcount != mapcount2);
 }
 
-int split_huge_page(struct page *page)
+static int split_anon_huge_page(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	int ret = 1;
 
-	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
-	BUG_ON(!PageAnon(page));
-
 	/*
 	 * The caller does not necessarily hold an mmap_sem that would prevent
 	 * the anon_vma disappearing so we first we take a reference to it
@@ -1824,7 +1820,7 @@ int split_huge_page(struct page *page)
 		goto out_unlock;
 
 	BUG_ON(!PageSwapBacked(page));
-	__split_huge_page(page, anon_vma);
+	__split_anon_huge_page(page, anon_vma);
 	count_vm_event(THP_SPLIT);
 
 	BUG_ON(PageCompound(page));
@@ -1835,6 +1831,55 @@ out:
 	return ret;
 }
 
+static int split_file_huge_page(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	struct vm_area_struct *vma;
+	int mapcount, mapcount2;
+
+	BUG_ON(!PageHead(page));
+	BUG_ON(PageTail(page));
+
+	mutex_lock(&mapping->i_mmap_mutex);
+	mapcount = 0;
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long addr = vma_address(page, vma);
+		mapcount += __split_huge_page_splitting(page, vma, addr);
+	}
+
+	if (mapcount != page_mapcount(page))
+		printk(KERN_ERR "mapcount %d page_mapcount %d\n",
+		       mapcount, page_mapcount(page));
+	BUG_ON(mapcount != page_mapcount(page));
+
+	__split_huge_page_refcount(page);
+
+	mapcount2 = 0;
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long addr = vma_address(page, vma);
+		mapcount2 += __split_huge_page_map(page, vma, addr);
+	}
+
+	if (mapcount != mapcount2)
+		printk(KERN_ERR "mapcount %d mapcount2 %d page_mapcount %d\n",
+		       mapcount, mapcount2, page_mapcount(page));
+	BUG_ON(mapcount != mapcount2);
+	count_vm_event(THP_SPLIT);
+	mutex_unlock(&mapping->i_mmap_mutex);
+	return 0;
+}
+
+int split_huge_page(struct page *page)
+{
+	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
+
+	if (PageAnon(page))
+		return split_anon_huge_page(page);
+	else
+		return split_file_huge_page(page);
+}
+
 #define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
-- 
1.7.10.4

