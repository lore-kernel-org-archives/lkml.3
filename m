Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaDMXAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:00:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:18564 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaDMXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="519861697"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v3 1/7] Remove block_write_full_page_endio()
Date: Sun, 13 Apr 2014 18:59:50 -0400
Message-Id: <fc2d8862f100c1a27188c97a39e1049ddeafd3e3.1397429628.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last in-tree caller of block_write_full_page_endio() was
removed in January 2013.  It's time to remove the EXPORT_SYMBOL,
which leaves block_write_full_page() as the only caller of
block_write_full_page_endio(), so inline block_write_full_page_endio()
into block_write_full_page().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/buffer.c                 | 21 +++++----------------
 fs/ext4/page-io.c           |  2 +-
 fs/ocfs2/file.c             |  2 +-
 include/linux/buffer_head.h |  2 --
 4 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..7b5bb90 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2879,10 +2879,9 @@ EXPORT_SYMBOL(block_truncate_page);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
- * this form passes in the end_io handler used to finish the IO.
  */
-int block_write_full_page_endio(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc, bh_end_io_t *handler)
+int block_write_full_page(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc)
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
@@ -2892,7 +2891,7 @@ int block_write_full_page_endio(struct page *page, get_block_t *get_block,
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
 		return __block_write_full_page(inode, page, get_block, wbc,
-					       handler);
+					       end_buffer_async_write);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_CACHE_SIZE-1);
@@ -2915,18 +2914,8 @@ int block_write_full_page_endio(struct page *page, get_block_t *get_block,
 	 * writes to that region are not written out to the file."
 	 */
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-	return __block_write_full_page(inode, page, get_block, wbc, handler);
-}
-EXPORT_SYMBOL(block_write_full_page_endio);
-
-/*
- * The generic ->writepage function for buffer-backed address_spaces
- */
-int block_write_full_page(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc)
-{
-	return block_write_full_page_endio(page, get_block, wbc,
-					   end_buffer_async_write);
+	return __block_write_full_page(inode, page, get_block, wbc,
+							end_buffer_async_write);
 }
 EXPORT_SYMBOL(block_write_full_page);
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index ab95508..11c2ba5 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -428,7 +428,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		block_start = bh_offset(bh);
 		if (block_start >= len) {
 			/*
-			 * Comments copied from block_write_full_page_endio:
+			 * Comments copied from block_write_full_page:
 			 *
 			 * The page straddles i_size.  It must be zeroed out on
 			 * each and every writepage invocation because it may
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8970dcf..8eb6e57 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -828,7 +828,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 		/*
 		 * fs-writeback will release the dirty pages without page lock
 		 * whose offset are over inode size, the release happens at
-		 * block_write_full_page_endio().
+		 * block_write_full_page().
 		 */
 		i_size_write(inode, abs_to);
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c40302f..e05c7ec 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,8 +207,6 @@ void block_invalidatepage(struct page *page, unsigned int offset,
 			  unsigned int length);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
-int block_write_full_page_endio(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc, bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, unsigned long from,
 				unsigned long count);
-- 
1.9.1

