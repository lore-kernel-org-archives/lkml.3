Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3IPHJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:09:31 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46749 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3IPHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:08:51 -0400
X-AuditID: 9c93017e-b7b60ae000007051-37-5236ae81cd60
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 3/5] squashfs: remove cache for normal data page
Date: Mon, 16 Sep 2013 16:08:37 +0900
Message-Id: <1379315319-7752-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379315319-7752-1-git-send-email-minchan@kernel.org>
References: <1379315319-7752-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sqsuashfs have used cache for normal data pages but it's pointless
because MM already has cache layer and squashfs adds extra pages
into MM's page cache when it reads a page from compressed block.

This patch removes cache usage for normal data pages so it could
remove unnecessary one copy(ie, from cache to page cache) and
decouple normal data page path from squashfs cache layer.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/file.c |  117 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 42 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index d4d472f..36508c3 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -505,11 +505,14 @@ skip_page:
 static int squashfs_regular_readpage(struct file *file, struct page *page)
 {
 	u64 block = 0;
-	int bsize;
-	struct inode *inode = page->mapping->host;
+	int bsize, i, data_len, pages, nr_pages = 0;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int bytes, i, offset = 0;
-	struct squashfs_cache_entry *buffer = NULL;
+	gfp_t gfp_mask;
+	struct page *push_page;
+	struct page **page_array;
+	void **buffer = NULL;
 	void *pageaddr;
 
 	int mask = (1 << (msblk->block_log - PAGE_CACHE_SHIFT)) - 1;
@@ -519,6 +522,8 @@ static int squashfs_regular_readpage(struct file *file, struct page *page)
 	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
 				page->index, squashfs_i(inode)->start);
 
+	pages = msblk->block_size >> PAGE_CACHE_SHIFT;
+	pages = pages ? pages : 1;
 	/*
 	 * Reading a datablock from disk.  Need to read block list
 	 * to get location and block size.
@@ -527,60 +532,88 @@ static int squashfs_regular_readpage(struct file *file, struct page *page)
 	if (bsize < 0)
 		goto error_out;
 
-	if (bsize == 0) { /* hole */
+	if (bsize == 0)
 		return squashfs_hole_readpage(file, inode, index, page);
-	} else {
-		/*
-		 * Read and decompress datablock.
-		 */
-		buffer = squashfs_get_datablock(inode->i_sb,
-							block, bsize);
-		if (buffer->error) {
-			ERROR("Unable to read page, block %llx, size %x\n",
-				block, bsize);
-			squashfs_cache_put(buffer);
-			goto error_out;
-		}
-		bytes = buffer->length;
-	}
+
 	/*
-	 * Loop copying datablock into pages.  As the datablock likely covers
-	 * many PAGE_CACHE_SIZE pages (default block size is 128 KiB) explicitly
-	 * grab the pages from the page cache, except for the page that we've
-	 * been called to fill.
+	 * Read and decompress data block
 	 */
-	for (i = start_index; bytes > 0; i++,
-			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
-		struct page *push_page;
-		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);
+	gfp_mask = mapping_gfp_mask(mapping);
+	buffer = kcalloc(1 << (msblk->block_log - PAGE_CACHE_SHIFT),
+				sizeof(void *), GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
-		TRACE("bytes %d, i %d, available_bytes %d\n", bytes, i, avail);
+	page_array = kcalloc(1 << (msblk->block_log - PAGE_CACHE_SHIFT),
+				sizeof(struct page *), GFP_KERNEL);
 
-		push_page = (i == page->index) ? page :
-			grab_cache_page_nowait(page->mapping, i);
+	if (!page_array)
+		goto release_buffer;
 
+	/* alloc buffer pages */
+	for (i = 0; i < pages; i++) {
+		if (page->index == start_index + i)
+			push_page = page;
+		else
+			push_page = __page_cache_alloc(gfp_mask);
 		if (!push_page)
-			continue;
+			goto release_page_array;
+		nr_pages++;
+		buffer[i] = kmap(push_page);
+		page_array[i] = push_page;
+	}
 
-		if (PageUptodate(push_page))
-			goto skip_page;
+	data_len = squashfs_read_datablock(inode->i_sb, buffer,
+			block, bsize, msblk->block_size, pages);
 
-		pageaddr = kmap_atomic(push_page);
-		squashfs_copy_data(pageaddr, buffer, offset, avail);
-		memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
-		kunmap_atomic(pageaddr);
+	if (data_len < 0) {
+		ERROR("Unable to read page, block %llx, size %x\n",
+			block, bsize);
+		for (i = 0; i < nr_pages; i++) {
+			kunmap(page_array[i]);
+			page_cache_release(page_array[i]);
+		}
+		kfree(buffer);
+		kfree(page_array);
+		goto error_out;
+	}
+
+	for (i = 0; i < pages; i++) {
+		push_page = page_array[i];
 		flush_dcache_page(push_page);
 		SetPageUptodate(push_page);
-skip_page:
-		unlock_page(push_page);
-		if (i != page->index)
+		kunmap(page_array[i]);
+		if (page->index == start_index + i) {
+			unlock_page(push_page);
+			continue;
+		}
+
+		if (add_to_page_cache_lru(push_page, mapping,
+			start_index + i, gfp_mask)) {
 			page_cache_release(push_page);
-	}
+			continue;
+		}
 
-	squashfs_cache_put(buffer);
+		unlock_page(push_page);
+		page_cache_release(push_page);
+	}
 
+	kfree(page_array);
+	kfree(buffer);
 	return 0;
 
+release_page_array:
+	for (i = 0; i < nr_pages; i++) {
+		kunmap(page_array[i]);
+		page_cache_release(page_array[i]);
+	}
+
+	kfree(page_array);
+
+release_buffer:
+	kfree(buffer);
+	return -ENOMEM;
+
 error_out:
 	SetPageError(page);
 	pageaddr = kmap_atomic(page);
-- 
1.7.9.5

