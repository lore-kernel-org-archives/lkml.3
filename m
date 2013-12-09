Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027Ab3LIIK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:10:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59570 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3LIIKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:10:23 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-d0-52a57ae9595a
From: Fan Li <fanofcode.li@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev][PATCH]f2fs: merge pages with the same sync_mode flag
Date: Mon, 09 Dec 2013 16:09:00 +0800
Message-id: <000001cef4b6$185fcd80$491f6880$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac70tOHWUP3f4tzmTl65YSkMSu1MGQ==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd2XVUuDDHZO47G4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PsrmbmgpkeFfdO
	pTYw9lp3MXJySAiYSKyZ+YwdwhaTuHBvPVsXIxeHkMB0RonTDW1sIAkhgR+MEsfPMIHYbALq
	EltmdoPZIgLSErM+zWMBsZkFMiXmvJ7MCmILC3hIrGv7wdzFyMHBIqAqsfpYHEiYV8BS4uTH
	hSwQtqDEj8n3WEBKmIFGTpmSCzFFW+LJuwusEOcoSOw4+5oRYpOexLnH99ggasQlJj14yD6B
	UWAWkkmzECbNQjJpFpKOBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA/iZ9A7GVQ0W
	hxgFOBiVeHhXsC4NEmJNLCuuzD3EKMHBrCTCax4FFOJNSaysSi3Kjy8qzUktPsQozcGiJM57
	sNU6UEggPbEkNTs1tSC1CCbLxMEp1cBY3e7pYfbtvIrXf5eYqIuCzH/1CvbxTZXS5na56GQz
	bdPylacWldW82lN8dfJHrt4VTj83z8tOfSzV7/Iyb3IDV/Vrgesz6+Pk2aSW8q31XvP0kOby
	c0f3cnuyPzDdqhbYubnpC/PRmwc9yj4sXx6rcL7ydWdS8v2gyNnqB/ZfkZF9+LrRcnKtEktx
	RqKhFnNRcSIAJ8/HJFwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously f2fs submits most of write requests using WRITE_SYNC, but f2fs_write_data_pages
submits last write requests by sync_mode flags callers pass.

This causes a performance problem since continuous pages with different sync flags
can't be merged in cfq IO scheduler(thanks yu chao for pointing it out), and synchronous
requests often take more time.

This patch makes the following modifies to DATA writebacks:

1. every page will be written back using the sync mode caller pass.
2. only pages with the same sync mode can be merged in one bio request.

These changes are restricted to DATA pages.Other types of writebacks are modified 
To remain synchronous.

In my test with tiotest, f2fs sequence write performance is improved by about 7%-10% ,
and this patch has no obvious impact on other performance tests.

>From e942aa6336f650542f9e873404ca7c3c5e175a72 Mon Sep 17 00:00:00 2001
From: Fan Li <fanofcode.li@samsung.com>
Date: Mon, 9 Dec 2013 11:25:17 +0800
Subject: [PATCH] merge pages with the same sync_mode flag


Signed-off-by: Fan Li <fanofcode.li@samsung.com>
---
 fs/f2fs/data.c    |   18 ++++++++++--------
 fs/f2fs/f2fs.h    |    8 +++++---
 fs/f2fs/gc.c      |    6 +++++-
 fs/f2fs/segment.c |   27 +++++++++++++++++----------
 4 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4e2fc09..96f0a92 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -194,8 +194,9 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 	if (!is_read_io(rw))
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
-	if (io->bio && io->last_block_in_bio != blk_addr - 1)
-		__submit_merged_bio(sbi, io, type, true, rw);
+	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
+						io->rw_flag != rw))
+		__submit_merged_bio(sbi, io, type, false, io->rw_flag);
 alloc_new:
 	if (io->bio == NULL) {
 		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
@@ -203,6 +204,7 @@ alloc_new:
 		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 		io->bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io :
 							f2fs_write_end_io;
+		io->rw_flag = rw;
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
@@ -212,7 +214,7 @@ alloc_new:
 
 	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
 							PAGE_CACHE_SIZE) {
-		__submit_merged_bio(sbi, io, type, true, rw);
+		__submit_merged_bio(sbi, io, type, false, rw);
 		goto alloc_new;
 	}
 
@@ -642,7 +644,7 @@ static int f2fs_read_data_pages(struct file *file,
 	return mpage_readpages(mapping, pages, nr_pages, get_data_block_ro);
 }
 
-int do_write_data_page(struct page *page)
+int do_write_data_page(struct page *page, struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	block_t old_blk_addr, new_blk_addr;
@@ -670,10 +672,10 @@ int do_write_data_page(struct page *page)
 			!is_cold_data(page) &&
 			need_inplace_update(inode))) {
 		rewrite_data_page(F2FS_SB(inode->i_sb), page,
-						old_blk_addr);
+						old_blk_addr, wbc);
 	} else {
 		write_data_page(inode, page, &dn,
-				old_blk_addr, &new_blk_addr);
+				old_blk_addr, &new_blk_addr, wbc);
 		update_extent_cache(new_blk_addr, &dn);
 	}
 out_writepage:
@@ -720,10 +722,10 @@ write:
 	if (S_ISDIR(inode->i_mode)) {
 		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(inode);
-		err = do_write_data_page(page);
+		err = do_write_data_page(page, wbc);
 	} else {
 		f2fs_lock_op(sbi);
-		err = do_write_data_page(page);
+		err = do_write_data_page(page, wbc);
 		f2fs_unlock_op(sbi);
 		need_balance_fs = true;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 10eca02..783f39d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -368,6 +368,7 @@ enum page_type {
 struct f2fs_bio_info {
 	struct bio *bio;		/* bios to merge */
 	sector_t last_block_in_bio;	/* last block number */
+	int rw_flag;				/* rw flag for all pages */
 	struct mutex io_mutex;		/* mutex for bio */
 };
 
@@ -1098,8 +1099,9 @@ void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *, unsigned int,
 					block_t, block_t *);
 void write_data_page(struct inode *, struct page *, struct dnode_of_data*,
-					block_t, block_t *);
-void rewrite_data_page(struct f2fs_sb_info *, struct page *, block_t);
+			block_t, block_t *, struct writeback_control *);
+void rewrite_data_page(struct f2fs_sb_info *, struct page *, block_t,
+				struct writeback_control *);
 void recover_data_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void rewrite_node_page(struct f2fs_sb_info *, struct page *,
@@ -1150,7 +1152,7 @@ void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
-int do_write_data_page(struct page *);
+int do_write_data_page(struct page *, struct writeback_control *);
 
 /*
  * gc.c
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2886aef..e94c34f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -521,6 +521,10 @@ static int check_dnode(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 
 static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 {
+	struct writeback_control wbc = {
+		.sync_mode = 1,
+	};
+
 	if (gc_type == BG_GC) {
 		if (PageWriteback(page))
 			goto out;
@@ -537,7 +541,7 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 			inode_dec_dirty_dents(inode);
 		}
 		set_cold_data(page);
-		do_write_data_page(page);
+		do_write_data_page(page, &wbc);
 		clear_cold_data(page);
 	}
 out:
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index ca9adf5..e5dc411 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -856,12 +856,13 @@ static int __get_segment_type(struct page *page, enum page_type p_type)
 
 static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 			block_t old_blkaddr, block_t *new_blkaddr,
-			struct f2fs_summary *sum, enum page_type p_type)
+			struct f2fs_summary *sum, enum page_type p_type,
+			struct writeback_control *wbc)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg;
 	unsigned int old_cursegno;
-	int type;
+	int type, rw = WRITE;
 
 	type = __get_segment_type(page, p_type);
 	curseg = CURSEG_I(sbi, type);
@@ -900,7 +901,9 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 		fill_node_footer_blkaddr(page, NEXT_FREE_BLKADDR(sbi, curseg));
 
 	/* writeout dirty page into bdev */
-	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, p_type, WRITE);
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		rw |= WRITE_SYNC;
+	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, p_type, rw);
 
 	mutex_unlock(&curseg->curseg_mutex);
 }
@@ -915,13 +918,16 @@ void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
 		unsigned int nid, block_t old_blkaddr, block_t *new_blkaddr)
 {
 	struct f2fs_summary sum;
+	struct writeback_control wbc = {
+		.sync_mode = 1,
+	};
 	set_summary(&sum, nid, 0, 0);
-	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, NODE);
+	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, NODE, &wbc);
 }
 
 void write_data_page(struct inode *inode, struct page *page,
 		struct dnode_of_data *dn, block_t old_blkaddr,
-		block_t *new_blkaddr)
+		block_t *new_blkaddr, struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_summary sum;
@@ -932,13 +938,14 @@ void write_data_page(struct inode *inode, struct page *page,
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 
 	do_write_page(sbi, page, old_blkaddr,
-			new_blkaddr, &sum, DATA);
+			new_blkaddr, &sum, DATA, wbc);
 }
 
 void rewrite_data_page(struct f2fs_sb_info *sbi, struct page *page,
-					block_t old_blk_addr)
+			block_t old_blk_addr, struct writeback_control *wbc)
 {
-	f2fs_submit_page_mbio(sbi, page, old_blk_addr, DATA, WRITE);
+	int rw = wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE;
+	f2fs_submit_page_mbio(sbi, page, old_blk_addr, DATA, rw);
 }
 
 void recover_data_page(struct f2fs_sb_info *sbi,
@@ -1025,7 +1032,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 
 	/* rewrite node page */
 	set_page_writeback(page);
-	f2fs_submit_page_mbio(sbi, page, new_blkaddr, NODE, WRITE);
+	f2fs_submit_page_mbio(sbi, page, new_blkaddr, NODE, WRITE_SYNC);
 	f2fs_submit_merged_bio(sbi, NODE, true, WRITE);
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
 
@@ -1593,7 +1600,7 @@ repeat:
 			continue;
 		}
 
-		f2fs_submit_page_mbio(sbi, page, blk_addr, META, READ);
+		f2fs_submit_page_mbio(sbi, page, blk_addr, META, READ_SYNC);
 
 		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
-- 
1.7.9.5

