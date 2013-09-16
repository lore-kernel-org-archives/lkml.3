Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3IPHJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:09:30 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56087 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IPHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:08:51 -0400
X-AuditID: 9c93017e-b7b60ae000007051-36-5236ae812142
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 2/5] squashfs: clean up squashfs_readpage
Date: Mon, 16 Sep 2013 16:08:36 +0900
Message-Id: <1379315319-7752-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379315319-7752-1-git-send-email-minchan@kernel.org>
References: <1379315319-7752-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now squashfs_readpage handles regular data, fragmented data and
hole pags so it's rather complex. This patch cleans it up
so it makes simple for review and upcoming readahread support.
It shouldn't change any old behavior.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/file.c |  237 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 184 insertions(+), 53 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 8ca62c2..d4d472f 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -370,88 +370,189 @@ static int read_blocklist(struct inode *inode, int index, u64 *block)
 	return le32_to_cpu(size);
 }
 
+static int squashfs_fragment_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int bytes, i, offset = 0;
+	struct squashfs_cache_entry *buffer = NULL;
+	void *pageaddr;
 
-static int squashfs_readpage(struct file *file, struct page *page)
+	int mask = (1 << (msblk->block_log - PAGE_CACHE_SHIFT)) - 1;
+	int start_index = page->index & ~mask;
+
+	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
+				page->index, squashfs_i(inode)->start);
+
+	/*
+	 * Datablock is stored inside a fragment (tail-end packed
+	 * block).
+	 */
+	buffer = squashfs_get_fragment(inode->i_sb,
+			squashfs_i(inode)->fragment_block,
+			squashfs_i(inode)->fragment_size);
+
+	if (buffer->error) {
+		ERROR("Unable to read page, block %llx, size %x\n",
+			squashfs_i(inode)->fragment_block,
+			squashfs_i(inode)->fragment_size);
+		squashfs_cache_put(buffer);
+		goto error_out;
+	}
+
+	bytes = i_size_read(inode) & (msblk->block_size - 1);
+	offset = squashfs_i(inode)->fragment_offset;
+
+	/*
+	 * Loop copying datablock into pages.  As the datablock likely covers
+	 * many PAGE_CACHE_SIZE pages (default block size is 128 KiB) explicitly
+	 * grab the pages from the page cache, except for the page that we've
+	 * been called to fill.
+	 */
+	for (i = start_index; bytes > 0; i++,
+			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
+		struct page *push_page;
+		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);
+
+		TRACE("bytes %d, i %d, available_bytes %d\n", bytes, i, avail);
+
+		push_page = (i == page->index) ? page :
+			grab_cache_page_nowait(page->mapping, i);
+
+		if (!push_page)
+			continue;
+
+		if (PageUptodate(push_page))
+			goto skip_page;
+
+		pageaddr = kmap_atomic(push_page);
+		squashfs_copy_data(pageaddr, buffer, offset, avail);
+		memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
+		kunmap_atomic(pageaddr);
+		flush_dcache_page(push_page);
+		SetPageUptodate(push_page);
+skip_page:
+		unlock_page(push_page);
+		if (i != page->index)
+			page_cache_release(push_page);
+	}
+
+	squashfs_cache_put(buffer);
+
+	return 0;
+
+error_out:
+	SetPageError(page);
+	pageaddr = kmap_atomic(page);
+	memset(pageaddr, 0, PAGE_CACHE_SIZE);
+	kunmap_atomic(pageaddr);
+	flush_dcache_page(page);
+	if (!PageError(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+
+	return 0;
+}
+
+static int squashfs_hole_readpage(struct file *file, struct inode *inode,
+				int index, struct page *page)
+{
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int bytes, i, offset = 0;
+	void *pageaddr;
+
+	int start_index = index << (msblk->block_log - PAGE_CACHE_SHIFT);
+	int file_end = i_size_read(inode) >> msblk->block_log;
+
+	bytes = index == file_end ?
+		(i_size_read(inode) & (msblk->block_size - 1)) :
+		 msblk->block_size;
+
+	/*
+	 * Loop copying datablock into pages.  As the datablock likely covers
+	 * many PAGE_CACHE_SIZE pages (default block size is 128 KiB) explicitly
+	 * grab the pages from the page cache, except for the page that we've
+	 * been called to fill.
+	 */
+	for (i = start_index; bytes > 0; i++,
+			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
+		struct page *push_page;
+
+		push_page = (page && i == page->index) ? page :
+			grab_cache_page_nowait(page->mapping, i);
+
+		if (!push_page)
+			continue;
+
+		if (PageUptodate(push_page))
+			goto skip_page;
+
+		pageaddr = kmap_atomic(push_page);
+		memset(pageaddr, 0, PAGE_CACHE_SIZE);
+		kunmap_atomic(pageaddr);
+		flush_dcache_page(push_page);
+		SetPageUptodate(push_page);
+skip_page:
+		unlock_page(push_page);
+		if (page && i == page->index)
+			continue;
+		page_cache_release(push_page);
+	}
+
+	return 0;
+}
+
+static int squashfs_regular_readpage(struct file *file, struct page *page)
 {
+	u64 block = 0;
+	int bsize;
 	struct inode *inode = page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int bytes, i, offset = 0, sparse = 0;
+	int bytes, i, offset = 0;
 	struct squashfs_cache_entry *buffer = NULL;
 	void *pageaddr;
 
 	int mask = (1 << (msblk->block_log - PAGE_CACHE_SHIFT)) - 1;
 	int index = page->index >> (msblk->block_log - PAGE_CACHE_SHIFT);
 	int start_index = page->index & ~mask;
-	int end_index = start_index | mask;
-	int file_end = i_size_read(inode) >> msblk->block_log;
 
 	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
 				page->index, squashfs_i(inode)->start);
 
-	if (page->index >= ((i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-					PAGE_CACHE_SHIFT))
-		goto out;
-
-	if (index < file_end || squashfs_i(inode)->fragment_block ==
-					SQUASHFS_INVALID_BLK) {
-		/*
-		 * Reading a datablock from disk.  Need to read block list
-		 * to get location and block size.
-		 */
-		u64 block = 0;
-		int bsize = read_blocklist(inode, index, &block);
-		if (bsize < 0)
-			goto error_out;
+	/*
+	 * Reading a datablock from disk.  Need to read block list
+	 * to get location and block size.
+	 */
+	bsize = read_blocklist(inode, index, &block);
+	if (bsize < 0)
+		goto error_out;
 
-		if (bsize == 0) { /* hole */
-			bytes = index == file_end ?
-				(i_size_read(inode) & (msblk->block_size - 1)) :
-				 msblk->block_size;
-			sparse = 1;
-		} else {
-			/*
-			 * Read and decompress datablock.
-			 */
-			buffer = squashfs_get_datablock(inode->i_sb,
-								block, bsize);
-			if (buffer->error) {
-				ERROR("Unable to read page, block %llx, size %x"
-					"\n", block, bsize);
-				squashfs_cache_put(buffer);
-				goto error_out;
-			}
-			bytes = buffer->length;
-		}
+	if (bsize == 0) { /* hole */
+		return squashfs_hole_readpage(file, inode, index, page);
 	} else {
 		/*
-		 * Datablock is stored inside a fragment (tail-end packed
-		 * block).
+		 * Read and decompress datablock.
 		 */
-		buffer = squashfs_get_fragment(inode->i_sb,
-				squashfs_i(inode)->fragment_block,
-				squashfs_i(inode)->fragment_size);
-
+		buffer = squashfs_get_datablock(inode->i_sb,
+							block, bsize);
 		if (buffer->error) {
 			ERROR("Unable to read page, block %llx, size %x\n",
-				squashfs_i(inode)->fragment_block,
-				squashfs_i(inode)->fragment_size);
+				block, bsize);
 			squashfs_cache_put(buffer);
 			goto error_out;
 		}
-		bytes = i_size_read(inode) & (msblk->block_size - 1);
-		offset = squashfs_i(inode)->fragment_offset;
+		bytes = buffer->length;
 	}
-
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
 	 * many PAGE_CACHE_SIZE pages (default block size is 128 KiB) explicitly
 	 * grab the pages from the page cache, except for the page that we've
 	 * been called to fill.
 	 */
-	for (i = start_index; i <= end_index && bytes > 0; i++,
+	for (i = start_index; bytes > 0; i++,
 			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
 		struct page *push_page;
-		int avail = sparse ? 0 : min_t(int, bytes, PAGE_CACHE_SIZE);
+		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);
 
 		TRACE("bytes %d, i %d, available_bytes %d\n", bytes, i, avail);
 
@@ -476,14 +577,12 @@ skip_page:
 			page_cache_release(push_page);
 	}
 
-	if (!sparse)
-		squashfs_cache_put(buffer);
+	squashfs_cache_put(buffer);
 
 	return 0;
 
 error_out:
 	SetPageError(page);
-out:
 	pageaddr = kmap_atomic(page);
 	memset(pageaddr, 0, PAGE_CACHE_SIZE);
 	kunmap_atomic(pageaddr);
@@ -495,6 +594,38 @@ out:
 	return 0;
 }
 
+static int squashfs_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	void *pageaddr;
+
+	int index = page->index >> (msblk->block_log - PAGE_CACHE_SHIFT);
+	int file_end = i_size_read(inode) >> msblk->block_log;
+
+	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
+				page->index, squashfs_i(inode)->start);
+
+	if (page->index >= ((i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+					PAGE_CACHE_SHIFT))
+		goto out;
+
+	if (index < file_end || squashfs_i(inode)->fragment_block ==
+					SQUASHFS_INVALID_BLK)
+		return squashfs_regular_readpage(file, page);
+	else
+		return squashfs_fragment_readpage(file, page);
+out:
+	pageaddr = kmap_atomic(page);
+	memset(pageaddr, 0, PAGE_CACHE_SIZE);
+	kunmap_atomic(pageaddr);
+	flush_dcache_page(page);
+	if (!PageError(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+
+	return 0;
+}
 
 const struct address_space_operations squashfs_aops = {
 	.readpage = squashfs_readpage
-- 
1.7.9.5

