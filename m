Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbaAJCmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:42:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:25486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaAJCkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="464478245"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 1/6] Add bdev_read_page() and bdev_write_page()
Date: Thu,  9 Jan 2014 21:39:46 -0500
Message-Id: <cover.1387748522.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A block device driver may choose to provide a rw_page operation.
These will be called when the filesystem is attempting to do page sized
I/O to page cache pages (ie not for direct I/O).  This does preclude
I/Os that are larger than page size, so this may only be a performance
gain for some devices.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/block_dev.c         | 34 ++++++++++++++++++++++++++
 fs/mpage.c             | 66 ++++++++++++++++++++++++++++++++------------------
 include/linux/blkdev.h |  4 +++
 3 files changed, 80 insertions(+), 24 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1e86823..660557c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -363,6 +363,40 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 }
 EXPORT_SYMBOL(blkdev_fsync);
 
+int bdev_read_page(struct block_device *bdev, sector_t sector,
+			struct page *page)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	if (!ops->rw_page)
+		return -EOPNOTSUPP;
+	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
+}
+EXPORT_SYMBOL_GPL(bdev_read_page);
+
+int bdev_write_page(struct block_device *bdev, sector_t sector,
+			struct page *page, struct writeback_control *wbc)
+{
+	int result;
+	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	if (!ops->rw_page)
+		return -EOPNOTSUPP;
+	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
+	if (result) {
+		if (PageSwapCache(page)) {
+			set_page_dirty(page);
+			ClearPageReclaim(page);
+			end_page_writeback(page);
+		} else {
+			redirty_page_for_writepage(wbc, page);
+			result = 0;
+		}
+	}
+	unlock_page(page);
+	return result;
+}
+EXPORT_SYMBOL_GPL(bdev_write_page);
+
 /*
  * pseudo-fs
  */
diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..b8552ae 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -286,6 +286,11 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 
 alloc_new:
 	if (bio == NULL) {
+		if (first_hole == blocks_per_page) {
+			if (!bdev_read_page(bdev, blocks[0] << (blkbits - 9),
+								page))
+				goto out;
+		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 			  	min_t(int, nr_pages, bio_get_nr_vecs(bdev)),
 				GFP_KERNEL);
@@ -440,6 +445,35 @@ struct mpage_data {
 	unsigned use_writepage;
 };
 
+/*
+ * We have our BIO, so we can now mark the buffers clean.  Make
+ * sure to only clean buffers which we know we'll be writing.
+ */
+static void clean_buffers(struct page *page, unsigned first_unmapped)
+{
+	unsigned buffer_counter = 0;
+	struct buffer_head *bh, *head;
+	if (!page_has_buffers(page))
+		return;
+	head = page_buffers(page);
+	bh = head;
+
+	do {
+		if (buffer_counter++ == first_unmapped)
+			break;
+		clear_buffer_dirty(bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	/*
+	 * we cannot drop the bh if the page is not uptodate or a concurrent
+	 * readpage would fail to serialize with the bh and it would read from
+	 * disk before we reach the platter.
+	 */
+	if (buffer_heads_over_limit && PageUptodate(page))
+		try_to_free_buffers(page);
+}
+
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
@@ -575,6 +609,13 @@ page_is_mapped:
 
 alloc_new:
 	if (bio == NULL) {
+		if (first_unmapped == blocks_per_page) {
+			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
+								page, wbc)) {
+				clean_buffers(page, first_unmapped);
+				goto out;
+			}
+		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
@@ -592,30 +633,7 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	/*
-	 * OK, we have our BIO, so we can now mark the buffers clean.  Make
-	 * sure to only clean buffers which we know we'll be writing.
-	 */
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-		unsigned buffer_counter = 0;
-
-		do {
-			if (buffer_counter++ == first_unmapped)
-				break;
-			clear_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
-
-		/*
-		 * we cannot drop the bh if the page is not uptodate
-		 * or a concurrent readpage would fail to serialize with the bh
-		 * and it would read from disk before we reach the platter.
-		 */
-		if (buffer_heads_over_limit && PageUptodate(page))
-			try_to_free_buffers(page);
-	}
+	clean_buffers(page, first_unmapped);
 
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b135d4..50dc979 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1564,6 +1564,7 @@ static inline bool blk_integrity_is_initialized(struct gendisk *g)
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
+	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*direct_access) (struct block_device *, sector_t,
@@ -1582,6 +1583,9 @@ struct block_device_operations {
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
+extern int bdev_read_page(struct block_device *, sector_t, struct page *);
+extern int bdev_write_page(struct block_device *, sector_t, struct page *,
+						struct writeback_control *);
 #else /* CONFIG_BLOCK */
 /*
  * stubs for when the block layer is configured out
-- 
1.8.5.2

