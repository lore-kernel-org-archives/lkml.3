Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3JUVrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:47:43 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50111 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3JUVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:47:39 -0400
Date: Mon, 21 Oct 2013 14:47:35 -0700
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
Subject: [PATCHv2 08/13] mm, thp, tmpfs: handle huge page in shmem_undo_range
 for truncate
Message-ID: <20131021214735.GI29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When comes to truncate file, add support to handle huge page in the
truncate range.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 74 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index af56731..f6829fd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -526,6 +526,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
+	/* Whether we have to do partial truncate */
 	unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
 	unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
 	struct pagevec pvec;
@@ -537,12 +538,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	if (lend == -1)
 		end = -1;	/* unsigned, so actually very big */
 
+	i_split_down_read(inode);
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index < end) {
+		bool thp = false;
+
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
+
 		if (!pvec.nr)
 			break;
 		mem_cgroup_uncharge_start();
@@ -553,6 +558,23 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (index >= end)
 				break;
 
+			thp = PageTransHugeCache(page);
+			if (thp) {
+				/* the range starts in middle of huge page */
+			       if (index < start) {
+					partial_start = true;
+					start = index + HPAGE_CACHE_NR;
+					break;
+			       }
+
+			       /* the range ends on huge page */
+			       if (index == (end & ~HPAGE_CACHE_INDEX_MASK)) {
+					partial_end = true;
+					end = index;
+					break;
+			       }
+			}
+
 			if (radix_tree_exceptional_entry(page)) {
 				if (unfalloc)
 					continue;
@@ -570,26 +592,47 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				}
 			}
 			unlock_page(page);
+			if (thp)
+				break;
 		}
 		shmem_deswap_pagevec(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
-		index++;
+		if (thp)
+			index += HPAGE_CACHE_NR;
+		else
+			index++;
 	}
 
 	if (partial_start) {
 		struct page *page = NULL;
 		gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+		int flags = AOP_FLAG_TRANSHUGE;
 
-		shmem_getpage(inode, start - 1, &page, SGP_READ, gfp, 0, NULL);
+		shmem_getpage(inode, start - 1, &page, SGP_READ, gfp,
+				flags, NULL);
 		if (page) {
-			unsigned int top = PAGE_CACHE_SIZE;
-			if (start > end) {
-				top = partial_end;
-				partial_end = 0;
+			pgoff_t index_mask;
+			loff_t page_cache_mask;
+			unsigned pstart, pend;
+
+			index_mask = 0UL;
+			page_cache_mask = PAGE_CACHE_MASK;
+			if (PageTransHugeCache(page)) {
+				index_mask = HPAGE_CACHE_INDEX_MASK;
+				page_cache_mask = HPAGE_PMD_MASK;
 			}
-			zero_user_segment(page, partial_start, top);
+
+			pstart = lstart & ~page_cache_mask;
+			if ((end & ~index_mask) == page->index) {
+				pend = (lend + 1) & ~page_cache_mask;
+				end = page->index;
+				partial_end = false; /* handled here */
+			} else
+				pend = PAGE_CACHE_SIZE << compound_order(page);
+
+			zero_pagecache_segment(page, pstart, pend);
 			set_page_dirty(page);
 			unlock_page(page);
 			page_cache_release(page);
@@ -598,20 +641,32 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	if (partial_end) {
 		struct page *page = NULL;
 		gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+		int flags = AOP_FLAG_TRANSHUGE;
 
-		shmem_getpage(inode, end, &page, SGP_READ, gfp, 0, NULL);
+		shmem_getpage(inode, end, &page, SGP_READ, gfp,
+				flags, NULL);
 		if (page) {
-			zero_user_segment(page, 0, partial_end);
+			loff_t page_cache_mask;
+			unsigned pend;
+
+			page_cache_mask = PAGE_CACHE_MASK;
+			if (PageTransHugeCache(page))
+				page_cache_mask = HPAGE_PMD_MASK;
+			pend = (lend + 1) & ~page_cache_mask;
+			end = page->index;
+			zero_pagecache_segment(page, 0, pend);
 			set_page_dirty(page);
 			unlock_page(page);
 			page_cache_release(page);
 		}
 	}
 	if (start >= end)
-		return;
+		goto out;
 
 	index = start;
 	for ( ; ; ) {
+		bool thp = false;
+
 		cond_resched();
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
@@ -643,6 +698,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				continue;
 			}
 
+			thp = PageTransHugeCache(page);
 			lock_page(page);
 			if (!unfalloc || !PageUptodate(page)) {
 				if (page->mapping == mapping) {
@@ -651,17 +707,24 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				}
 			}
 			unlock_page(page);
+			if (thp)
+				break;
 		}
 		shmem_deswap_pagevec(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
-		index++;
+		if (thp)
+			index += HPAGE_CACHE_NR;
+		else
+			index++;
 	}
 
 	spin_lock(&info->lock);
 	info->swapped -= nr_swaps_freed;
 	shmem_recalc_inode(inode);
 	spin_unlock(&info->lock);
+out:
+	i_split_up_read(inode);
 }
 
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
-- 
1.8.4

