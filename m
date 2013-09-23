Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3IWMGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:06:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:58723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab3IWMGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="382188990"
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
Subject: [PATCHv6 16/22] thp, mm: handle transhuge pages in do_generic_file_read()
Date: Mon, 23 Sep 2013 15:05:44 +0300
Message-Id: <1379937950-8411-17-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a transhuge page is already in page cache (up to date and not
readahead) we go usual path: read from relevant subpage (head or tail).

If page is not cached (sparse file in ramfs case) and the mapping can
have hugepage we try allocate a new one and read it.

If a page is not up to date or in readahead, we have to move 'page' to
head page of the compound page, since it represents state of whole
transhuge page. We will switch back to relevant subpage when page is
ready to be read ('page_ok' label).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 91 +++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 25 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 38d6856737..9bbc024e4c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1122,6 +1122,27 @@ static void shrink_readahead_size_eio(struct file *filp,
 	ra->ra_pages /= 4;
 }
 
+static unsigned long page_cache_mask(struct page *page)
+{
+	if (PageTransHugeCache(page))
+		return HPAGE_PMD_MASK;
+	else
+		return PAGE_CACHE_MASK;
+}
+
+static unsigned long pos_to_off(struct page *page, loff_t pos)
+{
+	return pos & ~page_cache_mask(page);
+}
+
+static unsigned long pos_to_index(struct page *page, loff_t pos)
+{
+	if (PageTransHugeCache(page))
+		return pos >> HPAGE_PMD_SHIFT;
+	else
+		return pos >> PAGE_CACHE_SHIFT;
+}
+
 /**
  * do_generic_file_read - generic file read routine
  * @filp:	the file to read
@@ -1143,17 +1164,12 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
 	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index;
 	pgoff_t last_index;
-	pgoff_t prev_index;
-	unsigned long offset;      /* offset into pagecache page */
-	unsigned int prev_offset;
 	int error;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
-	prev_index = ra->prev_pos >> PAGE_CACHE_SHIFT;
-	prev_offset = ra->prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
 
+	i_split_down_read(inode);
 	for (;;) {
 		struct page *page;
 		pgoff_t end_index;
@@ -1172,8 +1188,12 @@ find_page:
 					ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
-			if (unlikely(page == NULL))
-				goto no_cached_page;
+			if (unlikely(page == NULL)) {
+				if (mapping_can_have_hugepages(mapping))
+					goto no_cached_page_thp;
+				else
+					goto no_cached_page;
+			}
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
@@ -1190,7 +1210,7 @@ find_page:
 			if (!page->mapping)
 				goto page_not_up_to_date_locked;
 			if (!mapping->a_ops->is_partially_uptodate(page,
-								desc, offset))
+						desc, pos_to_off(page, *ppos)))
 				goto page_not_up_to_date_locked;
 			unlock_page(page);
 		}
@@ -1206,21 +1226,25 @@ page_ok:
 
 		isize = i_size_read(inode);
 		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (PageTransHugeCache(page)) {
+			index &= ~HPAGE_CACHE_INDEX_MASK;
+			end_index &= ~HPAGE_CACHE_INDEX_MASK;
+		}
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
 			goto out;
 		}
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = PAGE_CACHE_SIZE << compound_order(page);
 		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
+			nr = ((isize - 1) & ~page_cache_mask(page)) + 1;
+			if (nr <= pos_to_off(page, *ppos)) {
 				page_cache_release(page);
 				goto out;
 			}
 		}
-		nr = nr - offset;
+		nr = nr - pos_to_off(page, *ppos);
 
 		/* If users can be writing to this page using arbitrary
 		 * virtual addresses, take care about potential aliasing
@@ -1233,9 +1257,10 @@ page_ok:
 		 * When a sequential read accesses a page several times,
 		 * only mark it as accessed the first time.
 		 */
-		if (prev_index != index || offset != prev_offset)
+		if (pos_to_index(page, ra->prev_pos) != index ||
+				pos_to_off(page, *ppos) !=
+				pos_to_off(page, ra->prev_pos))
 			mark_page_accessed(page);
-		prev_index = index;
 
 		/*
 		 * Ok, we have the page, and it's up-to-date, so
@@ -1247,11 +1272,10 @@ page_ok:
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
-		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
-		prev_offset = offset;
+		ret = actor(desc, page, pos_to_off(page, *ppos), nr);
+		ra->prev_pos = *ppos;
+		*ppos += ret;
+		index = *ppos >> PAGE_CACHE_SHIFT;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
@@ -1325,6 +1349,27 @@ readpage_error:
 		page_cache_release(page);
 		goto out;
 
+no_cached_page_thp:
+		page = alloc_pages(mapping_gfp_mask(mapping) | __GFP_COLD,
+				HPAGE_PMD_ORDER);
+		if (!page) {
+			count_vm_event(THP_READ_ALLOC_FAILED);
+			goto no_cached_page;
+		}
+		count_vm_event(THP_READ_ALLOC);
+
+		error = add_to_page_cache_lru(page, mapping,
+				pos_to_index(page, *ppos), GFP_KERNEL);
+		if (!error)
+			goto readpage;
+
+		page_cache_release(page);
+		if (error != -EEXIST && error != -ENOSPC) {
+			desc->error = error;
+			goto out;
+		}
+
+		/* Fallback to small page */
 no_cached_page:
 		/*
 		 * Ok, it wasn't cached, so we need to create a new
@@ -1348,11 +1393,7 @@ no_cached_page:
 	}
 
 out:
-	ra->prev_pos = prev_index;
-	ra->prev_pos <<= PAGE_CACHE_SHIFT;
-	ra->prev_pos |= prev_offset;
-
-	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
+	i_split_up_read(inode);
 	file_accessed(filp);
 }
 
-- 
1.8.4.rc3

