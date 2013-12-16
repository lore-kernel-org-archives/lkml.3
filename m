Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3LPFcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:32:52 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54302 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3LPFcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:32:51 -0500
X-AuditID: 9c93017e-b7c17ae000003961-bd-52ae90817521
From: Chanho Min <chanho.min@lge.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, HyoJun Im <hyojun.im@lge.com>,
        gunho.lee@lge.com, Minchan Kim <minchan@kernel.org>,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH] Squashfs: add asynchronous read support
Date: Mon, 16 Dec 2013 14:30:26 +0900
Message-Id: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes synchronous wait for the up-to-date of buffer in the
file system level. Instead all operations after submit_bh are moved into
the End-of-IO handler and its associated workeque. It decompresses/copies
data into pages and unlock them asynchronously.

This patch enhances the performance of Squashfs in most cases.
Especially, large file reading is improved significantly.

dd read test:

 - ARM cortex-a9 1GHz, 2 cores, eMMC 4.5 HS200 mode.
 - dd if=file1 of=/dev/null bs=64k

Before
 58707718 bytes (56.0MB) copied, 1.393653 seconds, 40.2MB/s

After
 58707718 bytes (56.0MB) copied, 0.942413 seconds, 59.4MB/s

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 fs/squashfs/Kconfig       |    9 ++
 fs/squashfs/block.c       |  262 +++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/file_direct.c |    8 +-
 fs/squashfs/page_actor.c  |    3 +-
 fs/squashfs/page_actor.h  |    3 +-
 fs/squashfs/squashfs.h    |    2 +
 6 files changed, 284 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index b6fa865..284aa5a 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -51,6 +51,15 @@ config SQUASHFS_FILE_DIRECT
 	  it eliminates a memcpy and it also removes the lock contention
 	  on the single buffer.
 
+config SQUASHFS_READ_DATA_ASYNC
+	bool "Read and decompress data asynchronously"
+	depends on  SQUASHFS_FILE_DIRECT
+	help
+	  By default Squashfs read data synchronously by block (default 128k).
+	  This option removes such a synchronous wait in the file system level.
+	  All works after submit IO do at the End-of-IO handler asynchronously.
+	  This enhances the performance of Squashfs in most cases, especially,
+	  large file reading.
 endchoice
 
 choice
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 0cea9b9..1517ca3 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -212,3 +212,265 @@ read_failure:
 	kfree(bh);
 	return -EIO;
 }
+
+#ifdef CONFIG_SQUASHFS_READ_DATA_ASYNC
+
+struct squashfs_end_io_assoc {
+	int offset;
+	int b_count;
+	int compressed;
+	int length;
+	struct squashfs_page_actor *p_actor;
+	struct buffer_head **__bh;
+	struct squashfs_sb_info *msblk;
+	struct work_struct read_work;
+};
+
+static int squashfs_copy_page(struct squashfs_sb_info *msblk,
+	struct buffer_head **bh, int b, int offset, int length,
+	struct squashfs_page_actor *output)
+{
+	/*
+	 * Block is uncompressed.
+	 */
+	int in, pg_offset = 0, avail = 0, bytes, k = 0;
+	void *data = squashfs_first_page(output);
+	for (bytes = length; k < b; k++) {
+		in = min(bytes, msblk->devblksize - offset);
+		bytes -= in;
+		while (in) {
+			if (pg_offset == PAGE_CACHE_SIZE) {
+				data = squashfs_next_page(output);
+				pg_offset = 0;
+			}
+			avail = min_t(int, in, PAGE_CACHE_SIZE -
+					pg_offset);
+			memcpy(data + pg_offset, bh[k]->b_data + offset,
+					avail);
+			in -= avail;
+			pg_offset += avail;
+			offset += avail;
+		}
+		offset = 0;
+		put_bh(bh[k]);
+	}
+	squashfs_finish_page(output);
+	return length;
+}
+
+/*
+ * This is executed in workqueue for squashfs_read_data_async().
+ * - pages come decompressed/copied and unlocked asynchronously.
+ */
+static void squashfs_buffer_read_async(struct squashfs_end_io_assoc *io_assoc)
+{
+	struct squashfs_sb_info *msblk = io_assoc->msblk;
+	struct squashfs_page_actor *actor = io_assoc->p_actor;
+	struct page **page = actor->page;
+	int pages = actor->pages;
+	struct page *target_page = actor->target_page;
+	int i, length, bytes = 0;
+	void *pageaddr;
+
+	if (io_assoc->compressed) {
+		length = squashfs_decompress(msblk, io_assoc->__bh,
+				io_assoc->b_count, io_assoc->offset,
+				io_assoc->length, actor);
+		if (length < 0) {
+			ERROR("squashfs_read_data failed to read block\n");
+			goto read_failure;
+		}
+	} else
+		length = squashfs_copy_page(msblk, io_assoc->__bh,
+				io_assoc->b_count, io_assoc->offset,
+				io_assoc->length, actor);
+
+	/* Last page may have trailing bytes not filled */
+	bytes = length % PAGE_CACHE_SIZE;
+	if (bytes) {
+		pageaddr = kmap_atomic(page[pages - 1]);
+		memset(pageaddr + bytes, 0, PAGE_CACHE_SIZE - bytes);
+		kunmap_atomic(pageaddr);
+	}
+
+	/* Mark pages as uptodate, unlock and release */
+	for (i = 0; i < pages; i++) {
+		flush_dcache_page(page[i]);
+		SetPageUptodate(page[i]);
+		unlock_page(page[i]);
+		if (page[i] != target_page)
+			page_cache_release(page[i]);
+	}
+
+	kfree(io_assoc->__bh);
+	kfree(actor);
+	kfree(page);
+	kfree(io_assoc);
+	return;
+
+read_failure:
+	/* Decompression failed, mark pages as errored.  Target_page is
+	 * dealt with by the caller
+	 */
+	for (i = 0; i < pages; i++) {
+		if (page[i] == NULL || page[i] == target_page)
+			continue;
+		flush_dcache_page(page[i]);
+		SetPageError(page[i]);
+		unlock_page(page[i]);
+		page_cache_release(page[i]);
+	}
+
+	kfree(io_assoc->__bh);
+	kfree(actor);
+	kfree(page);
+	kfree(io_assoc);
+	return;
+}
+
+static void squashfs_async_work(struct work_struct *work)
+{
+	struct squashfs_end_io_assoc *io_assoc =
+		container_of(work, struct squashfs_end_io_assoc, read_work);
+
+	squashfs_buffer_read_async(io_assoc);
+}
+
+/*
+ * squashfs_buffer_end_io: update buffer and check if all buffers of array
+ * are updated then invoke the wq for async read.
+ */
+static void squashfs_buffer_end_io(struct buffer_head *bh, int uptodate)
+{
+	int i;
+	struct squashfs_end_io_assoc *io_assoc = bh->b_private;
+
+	if (uptodate) {
+		set_buffer_uptodate(bh);
+	} else {
+		/* This happens, due to failed READA attempts. */
+		clear_buffer_uptodate(bh);
+	}
+	unlock_buffer(bh);
+	put_bh(bh);
+
+	BUG_ON(!io_assoc);
+
+	/* Check if all buffers are uptodate */
+	for (i = 0; i < io_assoc->b_count; i++)
+		if (!buffer_uptodate(io_assoc->__bh[i]))
+			return;
+
+	schedule_work(&io_assoc->read_work);
+}
+
+/*
+ * squashfs_ll_r_block: low-level access to block devices for squashfs.
+ * @nr: number of &struct buffer_heads in the array
+ * @bhs: array of pointers to &struct buffer_head
+ *
+ * squashfs_ll_r_block sets b_end_io to the squashfs specific completion handler
+ * that marks the buffer up-to-date and invokes workqueue for decompression
+ * and uptodate of pages if needed.
+ */
+static void squashfs_ll_r_block(int nr, struct buffer_head *bhs[])
+{
+	int i, s_nr = 0;
+	struct squashfs_end_io_assoc *io_assoc = NULL;
+
+	for (i = 0; i < nr; i++) {
+		struct buffer_head *bh = bhs[i];
+		io_assoc = bh->b_private;
+		if (!trylock_buffer(bh))
+			continue;
+		if (!buffer_uptodate(bh)) {
+			bh->b_end_io = squashfs_buffer_end_io;
+			get_bh(bh);
+			s_nr++;
+			submit_bh(READ, bh);
+			continue;
+		}
+		unlock_buffer(bh);
+	}
+	/*
+	 * All buffers are uptodate, but no submit_bh is occurred.
+	 * Then try to unlock pages directly.
+	 */
+	if (nr && !s_nr && io_assoc)
+		squashfs_buffer_read_async(io_assoc);
+}
+
+/*
+ * Read and datablock asynchronously. same as squashfs_read_data(),
+ * except it doesn't block until a buffer comes unlocked.
+ * the work after submit IO do at the End-Of-Handle and the associated wq.
+ */
+int squashfs_read_data_async(struct super_block *sb, u64 index, int length,
+		struct squashfs_page_actor *output)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct buffer_head **bh;
+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
+	u64 cur_index = index >> msblk->devblksize_log2;
+	int bytes, compressed, b = 0, k = 0;
+	struct squashfs_end_io_assoc *io_assoc;
+
+	bh = kcalloc(((output->length + msblk->devblksize - 1)
+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
+	if (bh == NULL)
+		return -ENOMEM;
+
+	if (!length)
+		return -EINVAL;
+
+	bytes = -offset;
+
+	compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+	length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+
+	TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+		index, compressed ? "" : "un", length, output->length);
+
+	if (length < 0 || length > output->length ||
+			(index + length) > msblk->bytes_used)
+		goto read_failure;
+
+	io_assoc = kmalloc(sizeof(struct squashfs_end_io_assoc), GFP_KERNEL);
+	if (io_assoc == NULL)
+		return -ENOMEM;
+
+	io_assoc->offset = offset;
+	io_assoc->p_actor = output;
+	io_assoc->compressed = compressed;
+	io_assoc->__bh = bh;
+	io_assoc->length = length;
+	io_assoc->msblk = msblk;
+
+	INIT_WORK(&io_assoc->read_work, squashfs_async_work);
+
+	for (b = 0; bytes < length; b++, cur_index++) {
+		bh[b] = sb_getblk(sb, cur_index);
+		if (bh[b] == NULL)
+			goto block_release;
+		bytes += msblk->devblksize;
+		if (!buffer_locked(bh[b]))
+			bh[b]->b_private = io_assoc;
+	}
+	io_assoc->b_count = b;
+
+	/* make sure io_assoc is updated before submit IO */
+	mb();
+	squashfs_ll_r_block(b, bh);
+	return length;
+
+block_release:
+	for (; k < b; k++)
+		put_bh(bh[k]);
+
+read_failure:
+	ERROR("squashfs_read_data failed to read block 0x%llx\n",
+					(unsigned long long) index);
+	kfree(bh);
+	return -EIO;
+}
+#endif
diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index 62a0de6..610ca17 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -52,7 +52,7 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 	 * Create a "page actor" which will kmap and kunmap the
 	 * page cache pages appropriately within the decompressor
 	 */
-	actor = squashfs_page_actor_init_special(page, pages, 0);
+	actor = squashfs_page_actor_init_special(page, pages, target_page, 0);
 	if (actor == NULL)
 		goto out;
 
@@ -91,6 +91,11 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 	}
 
 	/* Decompress directly into the page cache buffers */
+#ifdef CONFIG_SQUASHFS_READ_DATA_ASYNC
+	squashfs_read_data_async(inode->i_sb, block, bsize, actor);
+
+	return 0;
+#else
 	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
 	if (res < 0)
 		goto mark_errored;
@@ -116,6 +121,7 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 	kfree(page);
 
 	return 0;
+#endif
 
 mark_errored:
 	/* Decompression failed, mark pages as errored.  Target_page is
diff --git a/fs/squashfs/page_actor.c b/fs/squashfs/page_actor.c
index 5a1c11f..2d2d7ac 100644
--- a/fs/squashfs/page_actor.c
+++ b/fs/squashfs/page_actor.c
@@ -81,7 +81,7 @@ static void direct_finish_page(struct squashfs_page_actor *actor)
 }
 
 struct squashfs_page_actor *squashfs_page_actor_init_special(struct page **page,
-	int pages, int length)
+	int pages, struct page *target_page, int length)
 {
 	struct squashfs_page_actor *actor = kmalloc(sizeof(*actor), GFP_KERNEL);
 
@@ -91,6 +91,7 @@ struct squashfs_page_actor *squashfs_page_actor_init_special(struct page **page,
 	actor->length = length ? : pages * PAGE_CACHE_SIZE;
 	actor->page = page;
 	actor->pages = pages;
+	actor->target_page = target_page;
 	actor->next_page = 0;
 	actor->pageaddr = NULL;
 	actor->squashfs_first_page = direct_first_page;
diff --git a/fs/squashfs/page_actor.h b/fs/squashfs/page_actor.h
index 26dd820..b50d982 100644
--- a/fs/squashfs/page_actor.h
+++ b/fs/squashfs/page_actor.h
@@ -58,13 +58,14 @@ struct squashfs_page_actor {
 	void    *(*squashfs_next_page)(struct squashfs_page_actor *);
 	void    (*squashfs_finish_page)(struct squashfs_page_actor *);
 	int	pages;
+	struct page *target_page;
 	int	length;
 	int	next_page;
 };
 
 extern struct squashfs_page_actor *squashfs_page_actor_init(void **, int, int);
 extern struct squashfs_page_actor *squashfs_page_actor_init_special(struct page
-							 **, int, int);
+						 **, int, struct page *, int);
 static inline void *squashfs_first_page(struct squashfs_page_actor *actor)
 {
 	return actor->squashfs_first_page(actor);
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 9e1bb79..39e95af 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -30,6 +30,8 @@
 /* block.c */
 extern int squashfs_read_data(struct super_block *, u64, int, u64 *,
 				struct squashfs_page_actor *);
+extern int squashfs_read_data_async(struct super_block *, u64, int,
+				struct squashfs_page_actor *);
 
 /* cache.c */
 extern struct squashfs_cache *squashfs_cache_init(char *, int, int);
-- 
1.7.9.5

