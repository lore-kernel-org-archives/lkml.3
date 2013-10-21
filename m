Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3JUVsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:48:11 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45251 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3JUVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:48:07 -0400
Date: Mon, 21 Oct 2013 14:48:03 -0700
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
Subject: [PATCHv2 09/13] mm, thp, tmpfs: huge page support in
 do_shmem_file_read
Message-ID: <20131021214803.GJ29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support huge page in do_shmem_file_read when possible.

Still have room to improve, since we re-search the page in
page cache everytime, but for huge page, we might save some
searches and reuse the huge page for the next read across
page boundary.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f6829fd..1764a29 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1747,13 +1747,25 @@ shmem_write_end(struct file *file, struct address_space *mapping,
 	return copied;
 }
 
+static unsigned long page_cache_to_mask(struct page *page)
+{
+	if (page && PageTransHugeCache(page))
+		return HPAGE_PMD_MASK;
+	else
+		return PAGE_CACHE_MASK;
+}
+
+static unsigned long pos_to_off(struct page *page, loff_t pos)
+{
+	return pos & ~page_cache_to_mask(page);
+}
+
 static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc, read_actor_t actor)
 {
 	struct inode *inode = file_inode(filp);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t index;
-	unsigned long offset;
 	enum sgp_type sgp = SGP_READ;
 
 	/*
@@ -1765,25 +1777,26 @@ static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_
 		sgp = SGP_DIRTY;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
 
+	i_split_down_read(inode);
 	for (;;) {
 		struct page *page = NULL;
 		pgoff_t end_index;
 		unsigned long nr, ret;
 		loff_t i_size = i_size_read(inode);
+		int flags = AOP_FLAG_TRANSHUGE;
 
 		end_index = i_size >> PAGE_CACHE_SHIFT;
 		if (index > end_index)
 			break;
 		if (index == end_index) {
 			nr = i_size & ~PAGE_CACHE_MASK;
-			if (nr <= offset)
+			if (nr <= pos_to_off(page, *ppos))
 				break;
 		}
 
 		desc->error = shmem_getpage(inode, index, &page, sgp, gfp,
-						0, NULL);
+					flags, NULL);
 		if (desc->error) {
 			if (desc->error == -EINVAL)
 				desc->error = 0;
@@ -1796,18 +1809,25 @@ static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_
 		 * We must evaluate after, since reads (unlike writes)
 		 * are called without i_mutex protection against truncate
 		 */
-		nr = PAGE_CACHE_SIZE;
 		i_size = i_size_read(inode);
 		end_index = i_size >> PAGE_CACHE_SHIFT;
+
+		nr = PAGE_CACHE_SIZE;
+		if (page && PageTransHugeCache(page)) {
+			index &= ~HPAGE_CACHE_INDEX_MASK;
+			end_index &= ~HPAGE_CACHE_INDEX_MASK;
+			nr = PAGE_CACHE_SIZE << compound_order(page);
+		}
+
 		if (index == end_index) {
-			nr = i_size & ~PAGE_CACHE_MASK;
-			if (nr <= offset) {
+			nr = ((i_size - 1) & ~page_cache_to_mask(page)) + 1;
+			if (nr <= pos_to_off(page, *ppos)) {
 				if (page)
 					page_cache_release(page);
 				break;
 			}
 		}
-		nr -= offset;
+		nr = nr - pos_to_off(page, *ppos);
 
 		if (page) {
 			/*
@@ -1820,7 +1840,7 @@ static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_
 			/*
 			 * Mark the page accessed if we read the beginning.
 			 */
-			if (!offset)
+			if (!pos_to_off(page, *ppos))
 				mark_page_accessed(page);
 		} else {
 			page = ZERO_PAGE(0);
@@ -1837,10 +1857,9 @@ static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
-		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		ret = actor(desc, page, pos_to_off(page, *ppos), nr);
+		*ppos += ret;
+		index = *ppos >> PAGE_CACHE_SHIFT;
 
 		page_cache_release(page);
 		if (ret != nr || !desc->count)
@@ -1849,7 +1868,7 @@ static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_
 		cond_resched();
 	}
 
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	i_split_up_read(inode);
 	file_accessed(filp);
 }
 
-- 
1.8.4

