Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672Ab3HIOgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:36:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:12490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030622Ab3HIOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="383838662"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ning Qu <quning@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <520170CA.4040409@sr71.net>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
 <520170CA.4040409@sr71.net>
Subject: Re: [PATCH 19/23] truncate: support huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130809143900.59722E0090@blue.fi.intel.com>
Date: Fri,  9 Aug 2013 17:39:00 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 08/03/2013 07:17 PM, Kirill A. Shutemov wrote:
> > If a huge page is only partly in the range we zero out the part,
> > exactly like we do for partial small pages.
> 
> What's the logic behind this behaviour?  Seems like the kind of place
> that we would really want to be splitting pages.

split_huge_page() now truncates the file, so we need to break
truncate<->split interdependency at some point.

> Like I said before, I somehow like to rewrite your code. :)

Makes sense. Please, take a look on patch below.

>From 631ad747933acbaa3284fae6e24ff1ae870a8f8f Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 2 Aug 2013 12:57:08 +0300
Subject: [PATCH] truncate: support huge pages

truncate_inode_pages_range() drops whole huge page at once if it's fully
inside the range.

If a huge page is only partly in the range we zero out the part,
exactly like we do for partial small pages.

In some cases it worth to split the huge page instead, if we need to
truncate it partly and free some memory. But split_huge_page() now
truncates the file, so we need to break truncate<->split interdependency
at some point.

invalidate_mapping_pages() just skips huge pages if they are not fully
in the range.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 include/linux/pagemap.h |  9 +++++
 mm/truncate.c           | 98 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 83 insertions(+), 24 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index eb484f2..418be14 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -599,4 +599,13 @@ static inline void clear_pagecache_page(struct page *page)
 		clear_highpage(page);
 }
 
+static inline void zero_pagecache_segment(struct page *page,
+		unsigned start, unsigned len)
+{
+	if (PageTransHugeCache(page))
+		zero_huge_user_segment(page, start, len);
+	else
+		zero_user_segment(page, start, len);
+}
+
 #endif /* _LINUX_PAGEMAP_H */
diff --git a/mm/truncate.c b/mm/truncate.c
index 353b683..bc4f8d6 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -205,8 +205,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 {
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
-	unsigned int	partial_start;	/* inclusive */
-	unsigned int	partial_end;	/* exclusive */
+	bool		partial_thp_start = false, partial_thp_end = false;
 	struct pagevec	pvec;
 	pgoff_t		index;
 	int		i;
@@ -215,15 +214,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	if (mapping->nrpages == 0)
 		return;
 
-	/* Offsets within partial pages */
-	partial_start = lstart & (PAGE_CACHE_SIZE - 1);
-	partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
-
 	/*
 	 * 'start' and 'end' always covers the range of pages to be fully
-	 * truncated. Partial pages are covered with 'partial_start' at the
-	 * start of the range and 'partial_end' at the end of the range.
-	 * Note that 'end' is exclusive while 'lend' is inclusive.
+	 * truncated. Note that 'end' is exclusive while 'lend' is inclusive.
 	 */
 	start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (lend == -1)
@@ -249,6 +242,23 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			if (index >= end)
 				break;
 
+			if (PageTransTailCache(page)) {
+				/* part of already handled huge page */
+				if (!page->mapping)
+					continue;
+				/* the range starts in middle of huge page */
+				partial_thp_start = true;
+				start = index & ~HPAGE_CACHE_INDEX_MASK;
+				continue;
+			}
+			/* the range ends on huge page */
+			if (PageTransHugeCache(page) && index ==
+					(end & ~HPAGE_CACHE_INDEX_MASK)) {
+				partial_thp_end = true;
+				end = index;
+				break;
+			}
+
 			if (!trylock_page(page))
 				continue;
 			WARN_ON(page->index != index);
@@ -265,34 +275,64 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		index++;
 	}
 
-	if (partial_start) {
-		struct page *page = find_lock_page(mapping, start - 1);
+	if (partial_thp_start || lstart & ~PAGE_CACHE_MASK) {
+		pgoff_t off;
+		struct page *page;
+		pgoff_t index_mask = 0UL;
+		loff_t page_cache_mask = PAGE_CACHE_MASK;
+retry_partial_start:
+		if (partial_thp_start) {
+			index_mask = HPAGE_CACHE_INDEX_MASK;
+			page_cache_mask = HPAGE_PMD_MASK;
+		}
+
+		off = (start - 1) & ~index_mask;
+		page = find_get_page(mapping, off);
 		if (page) {
-			unsigned int top = PAGE_CACHE_SIZE;
-			if (start > end) {
-				/* Truncation within a single page */
-				top = partial_end;
-				partial_end = 0;
+			unsigned pstart, pend;
+
+			/* the last tail page */
+			if (PageTransTailCache(page)) {
+				partial_thp_start = true;
+				page_cache_release(page);
+				goto retry_partial_start;
 			}
+
+			pstart = lstart & ~page_cache_mask;
+			if ((end & ~index_mask) == off)
+				pend = (lend - 1) & ~PAGE_CACHE_MASK;
+			else
+				pend = PAGE_CACHE_SIZE;
+
+			lock_page(page);
 			wait_on_page_writeback(page);
-			zero_user_segment(page, partial_start, top);
+			zero_pagecache_segment(page, pstart, pend);
 			cleancache_invalidate_page(mapping, page);
 			if (page_has_private(page))
-				do_invalidatepage(page, partial_start,
-						  top - partial_start);
+				do_invalidatepage(page, pstart,
+						pend - pstart);
 			unlock_page(page);
 			page_cache_release(page);
 		}
 	}
-	if (partial_end) {
-		struct page *page = find_lock_page(mapping, end);
+	if (partial_thp_end || (lend + 1) & ~PAGE_CACHE_MASK) {
+		struct page *page;
+		pgoff_t index_mask = 0UL;
+		loff_t page_cache_mask = PAGE_CACHE_MASK;
+
+		if (partial_thp_end) {
+			index_mask = HPAGE_CACHE_INDEX_MASK;
+			page_cache_mask = HPAGE_PMD_MASK;
+		}
+
+		page = find_lock_page(mapping, end & ~index_mask);
 		if (page) {
+			unsigned pend = (lend - 1) & ~page_cache_mask;
 			wait_on_page_writeback(page);
-			zero_user_segment(page, 0, partial_end);
+			zero_pagecache_segment(page, 0, pend);
 			cleancache_invalidate_page(mapping, page);
 			if (page_has_private(page))
-				do_invalidatepage(page, 0,
-						  partial_end);
+				do_invalidatepage(page, 0, pend);
 			unlock_page(page);
 			page_cache_release(page);
 		}
@@ -327,6 +367,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			if (index >= end)
 				break;
 
+			if (PageTransTailCache(page))
+				continue;
+
 			lock_page(page);
 			WARN_ON(page->index != index);
 			wait_on_page_writeback(page);
@@ -401,6 +444,13 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 			if (index > end)
 				break;
 
+			/* skip huge page if it's not fully in the range */
+			if (PageTransHugeCache(page) &&
+					index + HPAGE_CACHE_NR - 1 > end)
+				continue;
+			if (PageTransTailCache(page))
+				continue;
+
 			if (!trylock_page(page))
 				continue;
 			WARN_ON(page->index != index);
-- 
 Kirill A. Shutemov
