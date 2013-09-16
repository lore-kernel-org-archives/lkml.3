Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3IPHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:09:27 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46749 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IPHIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:08:53 -0400
X-AuditID: 9c93017e-b7b60ae000007051-3a-5236ae817b13
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 5/5] squashfs: support readpages
Date: Mon, 16 Sep 2013 16:08:39 +0900
Message-Id: <1379315319-7752-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379315319-7752-1-git-send-email-minchan@kernel.org>
References: <1379315319-7752-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports squashfs_readpages so it can do readahead pages
without unplugging I/O scheduler. With blktrace, I confirmed following test.

2 compression ratio 1G file(ie, 500M consumed by real storage) sequential read
with fadvise(SEQUENTIAL) hint and tune some knobs for block device and read_ahead_kb.

Old :
 Reads Queued:      524289,   524289KiB  Writes Queued:           0,        0KiB
 Read Dispatches:     4096,   524289KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:     4096,   524289KiB  Writes Completed:        0,        0KiB
 Read Merges:       520193,   520193KiB  Write Merges:            0,        0KiB
 PC Reads Queued:        0,        0KiB  PC Writes Queued:        0,        0KiB
 PC Read Disp.:         10,        0KiB  PC Write Disp.:          0,        0KiB
 PC Reads Req.:          0               PC Writes Req.:          0
 PC Reads Compl.:        0               PC Writes Compl.:        0
 IO unplugs:          4096               Timer unplugs:           0

New :
 Reads Queued:      524289,   524289KiB  Writes Queued:           0,        0KiB
 Read Dispatches:      633,   524289KiB  Write Dispatches:        0,        0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:      633,   524289KiB  Writes Completed:        0,        0KiB
 Read Merges:       523656,   523656KiB  Write Merges:            0,        0KiB
 PC Reads Queued:        0,        0KiB  PC Writes Queued:        0,        0KiB
 PC Read Disp.:          7,        0KiB  PC Write Disp.:          0,        0KiB
 PC Reads Req.:          0               PC Writes Req.:          0
 PC Reads Compl.:        0               PC Writes Compl.:        0
 IO unplugs:            31               Timer unplugs:           0

IOW, lots of I/O were merged before issuing. Of course, I can confirm that with
blktrace.

old:

  8,34   0     1933     0.014381550  4957  Q   R 4197628 + 2 [seqread]
  8,34   0     1934     0.014381629  4957  M   R 4197628 + 2 [seqread]
  8,32   0     1935     0.014381821  4957  A   R 4197630 + 2 <- (8,34) 1278
  8,34   0     1936     0.014381919  4957  Q   R 4197630 + 2 [seqread]
  8,34   0     1937     0.014381998  4957  M   R 4197630 + 2 [seqread]
  8,32   0     1938     0.014382131  4957  A   R 4197632 + 2 <- (8,34) 1280
  8,34   0     1939     0.014382203  4957  Q   R 4197632 + 2 [seqread]
  8,34   0     1940     0.014382281  4957  M   R 4197632 + 2 [seqread]
  8,34   0     1941     0.014382873  4957  I   R 4197378 + 256 [seqread]
  8,34   0        0     0.014383649     0  m   N cfq4957S  / insert_request
  8,34   0        0     0.014384609     0  m   N cfq4957S  / dispatch_insert
  8,34   0        0     0.014385132     0  m   N cfq4957S  / dispatched a request
  8,34   0        0     0.014385460     0  m   N cfq4957S  / activate rq, drv=1
  8,34   0     1942     0.014385581  4957  D   R 4197378 + 256 [seqread]

new:

  8,34   0    98321     0.352583517  5101  M   R 4261888 + 2 [seqread]
  8,34   0    98322     0.353008833  5101  I   R 4230404 + 4096 [seqread]
  8,34   0        0     0.353012357     0  m   N cfq5101SN / insert_request
  8,34   0    98323     0.353013872  5101  I   R 4234500 + 4096 [seqread]
  8,34   0        0     0.353014218     0  m   N cfq5101SN / insert_request
  8,34   0    98324     0.353014553  5101  I   R 4238596 + 4096 [seqread]
  8,34   0        0     0.353014802     0  m   N cfq5101SN / insert_request
  8,34   0    98325     0.353014992  5101  I   R 4242692 + 4096 [seqread]
  8,34   0        0     0.353015315     0  m   N cfq5101SN / insert_request

Voila, it's a result by that.
elapsed time, old : 17.5 sec new : 11.5 sec

A drawback from my mind is magic value 3ms for waiting more I/O so that
it can make delay at least 3ms although the I/O was done earlier.
The reason I selected that value is that it was a vaule kblockd had used
for a long time to plug/unplug for scheduler until we introduced explicit
blk_[start|finish]_plug. If it's really problem, we can add a hook into
plug and flush the I/O if someone is waiting the I/O.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/block.c          |    2 -
 fs/squashfs/file.c           |  462 +++++++++++++++++++++++++++++++++++++++++-
 fs/squashfs/squashfs.h       |    3 +
 fs/squashfs/squashfs_fs_sb.h |    4 +
 fs/squashfs/super.c          |    4 +-
 5 files changed, 465 insertions(+), 10 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index d41bac8..e8bf200 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -76,8 +76,6 @@ static struct buffer_head *get_block_length(struct super_block *sb,
 	return bh;
 }
 
-
-
 int squashfs_decompress_block(struct super_block *sb, int compressed,
 		void **buffer, struct buffer_head **bh, int nr_bh,
 		int offset, int length, int srclength, int pages)
diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 36508c3..53ad207 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -47,6 +47,7 @@
 #include <linux/string.h>
 #include <linux/pagemap.h>
 #include <linux/mutex.h>
+#include <linux/swap.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -454,8 +455,55 @@ error_out:
 	return 0;
 }
 
-static int squashfs_hole_readpage(struct file *file, struct inode *inode,
-				int index, struct page *page)
+static int squashfs_hole_readpages(struct inode *inode, int index,
+				struct list_head *page_list)
+{
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int bytes, i, offset = 0;
+	void *pageaddr;
+	struct page *push_page;
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
+
+		push_page = list_entry(page_list->prev, struct page, lru);
+		list_del(&push_page->lru);
+
+		pageaddr = kmap_atomic(push_page);
+		memset(pageaddr, 0, PAGE_CACHE_SIZE);
+		kunmap_atomic(pageaddr);
+		flush_dcache_page(push_page);
+		SetPageUptodate(push_page);
+
+		lru_cache_add_file(push_page);
+		unlock_page(push_page);
+		page_cache_release(push_page);
+	}
+
+	while (!list_empty(page_list)) {
+		push_page = list_entry(page_list->prev, struct page, lru);
+		list_del(&push_page->lru);
+		page_cache_release(push_page);
+	}
+
+	return 0;
+}
+
+static int squashfs_hole_readpage(struct inode *inode, int index,
+				struct page *page)
 {
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	int bytes, i, offset = 0;
@@ -478,8 +526,8 @@ static int squashfs_hole_readpage(struct file *file, struct inode *inode,
 			bytes -= PAGE_CACHE_SIZE, offset += PAGE_CACHE_SIZE) {
 		struct page *push_page;
 
-		push_page = (page && i == page->index) ? page :
-			grab_cache_page_nowait(page->mapping, i);
+		push_page = (i == page->index) ? page :
+			grab_cache_page_nowait(inode->i_mapping, i);
 
 		if (!push_page)
 			continue;
@@ -494,7 +542,7 @@ static int squashfs_hole_readpage(struct file *file, struct inode *inode,
 		SetPageUptodate(push_page);
 skip_page:
 		unlock_page(push_page);
-		if (page && i == page->index)
+		if (i == page->index)
 			continue;
 		page_cache_release(push_page);
 	}
@@ -533,7 +581,7 @@ static int squashfs_regular_readpage(struct file *file, struct page *page)
 		goto error_out;
 
 	if (bsize == 0)
-		return squashfs_hole_readpage(file, inode, index, page);
+		return squashfs_hole_readpage(inode, index, page);
 
 	/*
 	 * Read and decompress data block
@@ -660,6 +708,406 @@ out:
 	return 0;
 }
 
+static int squashfs_ra_readblock(struct inode *inode, int index,
+			struct buffer_head **bh, int *nr_bh,
+			int *block_size, u64 *block)
+{
+	int bsize;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int ret, b;
+
+	/*
+	 * Reading a datablock from disk.  Need to read block list
+	 * to get location and block size.
+	 */
+	*block_size = read_blocklist(inode, index, block);
+	if (*block_size < 0)
+		return 1;
+
+	if (*block_size == 0)
+		return 0;
+
+	bsize = SQUASHFS_COMPRESSED_SIZE_BLOCK(*block_size);
+	ret = squashfs_read_submit(inode->i_sb, *block, bsize,
+				msblk->block_size, bh, &b);
+	if (ret < 0)
+		return ret;
+
+	*nr_bh = b;
+	return 0;
+}
+
+struct squashfs_ra_private {
+	struct buffer_head **bh;
+	int nr_bh;
+	int block_size;
+	u64 block;
+	void **buffer;
+	struct page **page_array;
+};
+
+/* Caller should free buffer head */
+static int squashfs_ra_read_submit(struct inode *inode, int bindex,
+			struct squashfs_ra_private *ra_priv)
+{
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int ret;
+	struct buffer_head **bh;
+	int nr_bh = -1, bsize;
+	u64 block;
+	bh = kcalloc(((msblk->block_size + msblk->devblksize - 1)
+				>> msblk->devblksize_log2) + 1,
+				sizeof(*bh), GFP_KERNEL);
+	if (!bh)
+		return -ENOMEM;
+
+	ra_priv->bh = bh;
+	ret = squashfs_ra_readblock(inode, bindex, bh, &nr_bh,
+					&bsize, &block);
+	if (ret != 0)
+		goto release_bh;
+
+	ra_priv->nr_bh = nr_bh;
+	ra_priv->block_size = bsize;
+	ra_priv->block = block;
+
+	return 0;
+
+release_bh:
+	kfree(ra_priv->bh);
+	return ret;
+}
+
+static int squashfs_ra_decompress(struct inode *inode, int bindex,
+			struct squashfs_ra_private *ra_priv, gfp_t gfp_mask,
+			struct list_head *page_list)
+{
+	int j;
+	int ret = -ENOMEM;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	int pages_per_block;
+
+	void **buffer;
+	struct buffer_head **bh;
+	int block_size, nr_bh;
+	u64 block;
+	struct page **page_array, *page;
+
+	int compressed, offset, length;
+
+	pages_per_block = msblk->block_size >> PAGE_CACHE_SHIFT;
+	pages_per_block = pages_per_block ? pages_per_block : 1;
+
+	bh = ra_priv->bh;
+	block_size = ra_priv->block_size;
+	nr_bh = ra_priv->nr_bh;
+	block = ra_priv->block;
+
+	if (block_size == 0)
+		return squashfs_hole_readpages(inode, bindex, page_list);
+
+	buffer = kcalloc(1 << (msblk->block_log - PAGE_CACHE_SHIFT),
+					sizeof(void *), GFP_KERNEL);
+	if (!buffer)
+		goto out;
+	ra_priv->buffer = buffer;
+
+	page_array = kcalloc(1 << (msblk->block_log - PAGE_CACHE_SHIFT),
+					sizeof(struct page *), GFP_KERNEL);
+	if (!page_array)
+		goto release_buffer;
+	ra_priv->page_array = page_array;
+
+	/* alloc buffer pages */
+	for (j = 0; j < pages_per_block; j++) {
+		page = list_entry(page_list->prev, struct page, lru);
+		list_del(&page->lru);
+		buffer[j] = kmap(page);
+		page_array[j] = page;
+	}
+
+	compressed = SQUASHFS_COMPRESSED_BLOCK(block_size);
+	length = SQUASHFS_COMPRESSED_SIZE_BLOCK(block_size);
+
+	offset = block & ((1 << msblk->devblksize_log2) - 1);
+	length = squashfs_decompress_block(inode->i_sb, compressed, buffer,
+				bh, nr_bh, offset, length, msblk->block_size,
+				pages_per_block);
+
+	for (j = 0; j < pages_per_block; j++) {
+		page = page_array[j];
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+		lru_cache_add_file(page);
+		unlock_page(page);
+	}
+
+	ret = 0;
+
+release_buffer:
+	if (ra_priv->buffer) {
+		for (j = 0; j < pages_per_block; j++) {
+			if (!ra_priv->buffer[j])
+				break;
+			kunmap(ra_priv->page_array[j]);
+			page_cache_release(ra_priv->page_array[j]);
+		}
+		kfree(ra_priv->page_array);
+	}
+
+	kfree(ra_priv->buffer);
+out:
+	return ret;
+}
+
+/*
+ * Fill hole pages between page_index and last_page_index
+ * Return 0 if function is successful, otherwise, return 1
+ * All pages are locked and added into page cache so that caller should
+ * add them into LRU and unlock.
+ */
+int hole_plugging(struct squashfs_sb_info *msblk, struct list_head *page_list,
+				int start_bindex, int last_bindex,
+				struct address_space *mapping)
+{
+	struct page *page, *hole_page;
+	int page_index, last_page_index;
+	gfp_t gfp_mask = mapping_gfp_mask(mapping);
+
+	page_index = start_bindex << (msblk->block_log - PAGE_CACHE_SHIFT);
+	last_page_index = ((last_bindex + 1) <<
+			(msblk->block_log - PAGE_CACHE_SHIFT));
+
+	/* Fill hole pages in start block */
+	list_for_each_entry_reverse(page, page_list, lru) {
+		if (page_index == page->index) {
+			if (add_to_page_cache(page, mapping, page->index,
+				gfp_mask))
+				goto rollback;
+			page_index++;
+			continue;
+		}
+
+		while (page_index != page->index) {
+			hole_page = page_cache_alloc_readahead(mapping);
+			if (!hole_page)
+				goto rollback;
+
+			hole_page->index = page_index;
+			if (add_to_page_cache(hole_page, mapping,
+				hole_page->index, gfp_mask))
+				goto rollback;
+
+			list_add(&hole_page->lru, &page->lru);
+			page_index++;
+		}
+
+		page_index++;
+	}
+
+	/* Fill hole pages in last block */
+	while (page_index < last_page_index) {
+		page = page_cache_alloc_readahead(mapping);
+		if (!page) {
+			page = list_entry(page_list->prev, struct page, lru);
+			goto rollback;
+		}
+
+		page->index = page_index;
+		if (add_to_page_cache(page, mapping, page->index,
+					gfp_mask))
+			goto rollback;
+
+		list_add(&page->lru, page_list);
+		page_index++;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_reverse(hole_page, page_list, lru) {
+		if (hole_page == page)
+			break;
+		delete_from_page_cache(hole_page);
+		unlock_page(hole_page);
+	}
+	return 1;
+}
+
+struct decomp_work {
+	struct inode *inode;
+	int bindex;
+	struct list_head list;
+	struct list_head pages;
+	struct squashfs_ra_private *ra_priv;
+	gfp_t gfp_mask;
+};
+
+void squashfs_decomp_work(struct work_struct *work)
+{
+	struct inode *inode;
+	struct list_head *pages;
+	struct squashfs_ra_private *ra_priv;
+	struct decomp_work *decomp_work;
+	gfp_t gfp_mask;
+	int bindex;
+	struct squashfs_sb_info *msblk =
+		container_of(work, struct squashfs_sb_info, delay_work.work);
+
+	for (;;) {
+		decomp_work = NULL;
+		spin_lock(&msblk->decomp_lock);
+		if (!list_empty(&msblk->decomp_list)) {
+			decomp_work = list_entry(msblk->decomp_list.prev,
+					struct decomp_work, list);
+			list_del(&decomp_work->list);
+		}
+		spin_unlock(&msblk->decomp_lock);
+		if (!decomp_work)
+			return;
+
+		inode = decomp_work->inode;
+		bindex = decomp_work->bindex;
+		ra_priv = decomp_work->ra_priv;
+		gfp_mask = decomp_work->gfp_mask;
+		pages = &decomp_work->pages;
+
+		if (squashfs_ra_decompress(inode, bindex, ra_priv,
+						gfp_mask, pages)) {
+			struct page *page, *tmp;
+			list_for_each_entry_safe_reverse(page, tmp,
+							pages, lru) {
+				list_del(&page->lru);
+				delete_from_page_cache(page);
+				unlock_page(page);
+				page_cache_release(page);
+			}
+		}
+
+		kfree(ra_priv->bh);
+		kfree(ra_priv);
+		kfree(decomp_work);
+	}
+}
+
+static int move_pages(struct list_head *page_list, struct list_head *pages,
+				int nr)
+{
+	int moved_pages = 0;
+	struct page *page, *tmp_page;
+	list_for_each_entry_safe_reverse(page, tmp_page,
+						page_list, lru) {
+		list_move(&page->lru, pages);
+		moved_pages++;
+		if (moved_pages == nr)
+			break;
+	}
+
+	return moved_pages;
+}
+
+static int squashfs_readpages(struct file *file, struct address_space *mapping,
+		struct list_head *page_list, unsigned nr_pages)
+{
+	struct inode *inode = mapping->host;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	struct page *hpage, *tpage;
+	struct decomp_work **work;
+	int start_bindex, last_bindex;
+	struct squashfs_ra_private **ra_priv;
+	int pages_per_block, i, ret = -ENOMEM;
+	gfp_t gfp_mask;
+	int nr_blocks;
+
+	gfp_mask = mapping_gfp_mask(mapping);
+
+	hpage = list_entry(page_list->prev, struct page, lru);
+	tpage = list_entry(page_list->next, struct page, lru);
+
+	start_bindex = hpage->index >> (msblk->block_log - PAGE_CACHE_SHIFT);
+	last_bindex = tpage->index >> (msblk->block_log - PAGE_CACHE_SHIFT);
+
+	if (last_bindex >= (i_size_read(inode) >> msblk->block_log))
+		return 0;
+
+	/* fill with pages for readahead  */
+	if (hole_plugging(msblk, page_list, start_bindex,
+					last_bindex, mapping)) {
+		ret = 0;
+		goto out;
+	}
+
+	nr_blocks = last_bindex - start_bindex + 1;
+	ra_priv = kcalloc(nr_blocks, sizeof(*ra_priv), GFP_KERNEL);
+	if (!ra_priv)
+		goto out;
+
+	for (i = 0; i < nr_blocks; i++) {
+		ra_priv[i] = kmalloc(sizeof(**ra_priv),	GFP_KERNEL);
+		if (ra_priv[i] == NULL)
+			goto release_ra_priv;
+	}
+
+	work = kcalloc(nr_blocks, sizeof(*work), GFP_KERNEL);
+	if (!work)
+		goto release_ra_priv;
+
+	for (i = 0; i < nr_blocks; i++) {
+		work[i] = kmalloc(sizeof(**work), GFP_KERNEL);
+		if (!work[i])
+			goto release_work;
+	}
+
+	for (i = 0; i < nr_blocks; i++) {
+		ret = squashfs_ra_read_submit(inode, start_bindex + i ,
+							ra_priv[i]);
+		if (ret)
+			goto release_ra_priv;
+	}
+
+	ret = 0;
+
+	queue_delayed_work(system_unbound_wq, &msblk->delay_work,
+		msecs_to_jiffies(3));
+
+	pages_per_block = msblk->block_size >> PAGE_CACHE_SHIFT;
+	pages_per_block = pages_per_block ? pages_per_block : 1;
+
+	for (i = 0; i < nr_blocks; i++) {
+		struct decomp_work *decomp_work = work[i];
+
+		INIT_LIST_HEAD(&decomp_work->pages);
+		decomp_work->bindex = start_bindex + i;
+		decomp_work->ra_priv = ra_priv[i];
+		decomp_work->gfp_mask = gfp_mask;
+		decomp_work->inode = inode;
+
+		move_pages(page_list, &decomp_work->pages,
+			pages_per_block);
+
+		spin_lock(&msblk->decomp_lock);
+		list_add(&decomp_work->list, &msblk->decomp_list);
+		spin_unlock(&msblk->decomp_lock);
+	}
+
+	kfree(ra_priv);
+	kfree(work);
+
+	return ret;
+
+release_work:
+	for (i = 0; i < nr_blocks; i++)
+		kfree(work[i]);
+	kfree(work);
+release_ra_priv:
+	for (i = 0; i < nr_blocks; i++)
+		kfree(ra_priv[i]);
+	kfree(ra_priv);
+out:
+	return ret;
+}
+
 const struct address_space_operations squashfs_aops = {
-	.readpage = squashfs_readpage
+	.readpage = squashfs_readpage,
+	.readpages = squashfs_readpages,
 };
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 4bb1f90..2de96a7 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -34,6 +34,8 @@ extern int squashfs_read_metablock(struct super_block *, void **, u64, int,
 				u64 *, int, int);
 extern int squashfs_read_submit(struct super_block *, u64, int, int,
 				struct buffer_head **, int *);
+extern int squashfs_decompress_block(struct super_block *, int, void **,
+			struct buffer_head **, int, int, int, int, int);
 
 /* cache.c */
 extern struct squashfs_cache *squashfs_cache_init(char *, int, int);
@@ -89,6 +91,7 @@ extern const struct export_operations squashfs_export_ops;
 
 /* file.c */
 extern const struct address_space_operations squashfs_aops;
+extern void squashfs_decomp_work(struct work_struct *work);
 
 /* inode.c */
 extern const struct inode_operations squashfs_inode_ops;
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 0a209e6..bdcc0f2 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -79,5 +79,9 @@ struct squashfs_sb_info {
 	wait_queue_head_t			decomp_wait_queue;
 	int					nr_avail_decomp;
 	unsigned short				flags;
+
+	struct delayed_work			delay_work;
+	spinlock_t				decomp_lock;
+	struct list_head			decomp_list;
 };
 #endif
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 70aa9c4..78d12d6 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -73,7 +73,6 @@ static const struct squashfs_decompressor *supported_squashfs_filesystem(short
 	return decompressor;
 }
 
-
 static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct squashfs_sb_info *msblk;
@@ -98,6 +97,9 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
+	spin_lock_init(&msblk->decomp_lock);
+	INIT_DELAYED_WORK(&msblk->delay_work, squashfs_decomp_work);
+	INIT_LIST_HEAD(&msblk->decomp_list);
 	INIT_LIST_HEAD(&msblk->strm_list);
 	mutex_init(&msblk->comp_strm_mutex);
 	init_waitqueue_head(&msblk->decomp_wait_queue);
-- 
1.7.9.5

