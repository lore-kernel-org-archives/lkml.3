Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaLUQfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:35:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:52553 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaLUQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:35:28 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/6] f2fs: use f2fs_io_info to clean up messy parameters during IO path
Date: Sun, 21 Dec 2014 08:35:18 -0800
Message-Id: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up parameters on IO paths.
The key idea is to use f2fs_io_info adding a parameter, block address, and then
use this structure as parameters.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 24 ++++++++++---------
 fs/f2fs/data.c       | 66 +++++++++++++++++++++++++++++++---------------------
 fs/f2fs/f2fs.h       | 14 ++++++-----
 fs/f2fs/inline.c     |  7 +++---
 fs/f2fs/node.c       | 14 +++++++----
 fs/f2fs/segment.c    | 28 +++++++++++-----------
 6 files changed, 87 insertions(+), 66 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 825158e..0ac7c39 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -50,6 +50,11 @@ struct page *get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
 	struct page *page;
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = READ_SYNC | REQ_META | REQ_PRIO,
+		.blk_addr = index,
+	};
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
@@ -59,8 +64,7 @@ repeat:
 	if (PageUptodate(page))
 		goto out;
 
-	if (f2fs_submit_page_bio(sbi, page, index,
-				READ_SYNC | REQ_META | REQ_PRIO))
+	if (f2fs_submit_page_bio(sbi, page, &fio))
 		goto repeat;
 
 	lock_page(page);
@@ -112,14 +116,12 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 	block_t prev_blk_addr = 0;
 	struct page *page;
 	block_t blkno = start;
-
 	struct f2fs_io_info fio = {
 		.type = META,
 		.rw = READ_SYNC | REQ_META | REQ_PRIO
 	};
 
 	for (; nrpages-- > 0; blkno++) {
-		block_t blk_addr;
 
 		if (!is_valid_blkaddr(sbi, blkno, type))
 			goto out;
@@ -130,27 +132,27 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 					NAT_BLOCK_OFFSET(NM_I(sbi)->max_nid)))
 				blkno = 0;
 			/* get nat block addr */
-			blk_addr = current_nat_addr(sbi,
+			fio.blk_addr = current_nat_addr(sbi,
 					blkno * NAT_ENTRY_PER_BLOCK);
 			break;
 		case META_SIT:
 			/* get sit block addr */
-			blk_addr = current_sit_addr(sbi,
+			fio.blk_addr = current_sit_addr(sbi,
 					blkno * SIT_ENTRY_PER_BLOCK);
-			if (blkno != start && prev_blk_addr + 1 != blk_addr)
+			if (blkno != start && prev_blk_addr + 1 != fio.blk_addr)
 				goto out;
-			prev_blk_addr = blk_addr;
+			prev_blk_addr = fio.blk_addr;
 			break;
 		case META_SSA:
 		case META_CP:
 		case META_POR:
-			blk_addr = blkno;
+			fio.blk_addr = blkno;
 			break;
 		default:
 			BUG();
 		}
 
-		page = grab_cache_page(META_MAPPING(sbi), blk_addr);
+		page = grab_cache_page(META_MAPPING(sbi), fio.blk_addr);
 		if (!page)
 			continue;
 		if (PageUptodate(page)) {
@@ -158,7 +160,7 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 			continue;
 		}
 
-		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
+		f2fs_submit_page_mbio(sbi, page, &fio);
 		f2fs_put_page(page, 0);
 	}
 out:
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index caa08e4..d86f8b1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -132,14 +132,14 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
  * Return unlocked page.
  */
 int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
-					block_t blk_addr, int rw)
+					struct f2fs_io_info *fio)
 {
 	struct bio *bio;
 
-	trace_f2fs_submit_page_bio(page, blk_addr, rw);
+	trace_f2fs_submit_page_bio(page, fio->blk_addr, fio->rw);
 
 	/* Allocate a new bio */
-	bio = __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
+	bio = __bio_alloc(sbi, fio->blk_addr, 1, is_read_io(fio->rw));
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
@@ -147,12 +147,12 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 		return -EFAULT;
 	}
 
-	submit_bio(rw, bio);
+	submit_bio(fio->rw, bio);
 	return 0;
 }
 
 void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
-			block_t blk_addr, struct f2fs_io_info *fio)
+					struct f2fs_io_info *fio)
 {
 	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
 	struct f2fs_bio_info *io;
@@ -160,21 +160,21 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 
 	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
 
-	verify_block_addr(sbi, blk_addr);
+	verify_block_addr(sbi, fio->blk_addr);
 
 	down_write(&io->io_rwsem);
 
 	if (!is_read)
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
-	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
+	if (io->bio && (io->last_block_in_bio != fio->blk_addr - 1 ||
 						io->fio.rw != fio->rw))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
 		int bio_blocks = MAX_BIO_BLOCKS(sbi);
 
-		io->bio = __bio_alloc(sbi, blk_addr, bio_blocks, is_read);
+		io->bio = __bio_alloc(sbi, fio->blk_addr, bio_blocks, is_read);
 		io->fio = *fio;
 	}
 
@@ -184,10 +184,10 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	io->last_block_in_bio = blk_addr;
+	io->last_block_in_bio = fio->blk_addr;
 
 	up_write(&io->io_rwsem);
-	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, blk_addr);
+	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, fio->blk_addr);
 }
 
 /*
@@ -376,6 +376,10 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 	struct dnode_of_data dn;
 	struct page *page;
 	int err;
+	struct f2fs_io_info fio = {
+		.type = DATA,
+		.rw = sync ? READ_SYNC : READA,
+	};
 
 	page = find_get_page(mapping, index);
 	if (page && PageUptodate(page))
@@ -404,8 +408,8 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 		return page;
 	}
 
-	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page, dn.data_blkaddr,
-					sync ? READ_SYNC : READA);
+	fio.blk_addr = dn.data_blkaddr;
+	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page, &fio);
 	if (err)
 		return ERR_PTR(err);
 
@@ -430,7 +434,10 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	struct dnode_of_data dn;
 	struct page *page;
 	int err;
-
+	struct f2fs_io_info fio = {
+		.type = DATA,
+		.rw = READ_SYNC,
+	};
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
@@ -464,8 +471,8 @@ repeat:
 		return page;
 	}
 
-	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page,
-					dn.data_blkaddr, READ_SYNC);
+	fio.blk_addr = dn.data_blkaddr;
+	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page, &fio);
 	if (err)
 		return ERR_PTR(err);
 
@@ -515,8 +522,12 @@ repeat:
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 	} else {
-		err = f2fs_submit_page_bio(F2FS_I_SB(inode), page,
-						dn.data_blkaddr, READ_SYNC);
+		struct f2fs_io_info fio = {
+			.type = DATA,
+			.rw = READ_SYNC,
+			.blk_addr = dn.data_blkaddr,
+		};
+		err = f2fs_submit_page_bio(F2FS_I_SB(inode), page, &fio);
 		if (err)
 			goto put_err;
 
@@ -745,7 +756,6 @@ static int f2fs_read_data_pages(struct file *file,
 int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 {
 	struct inode *inode = page->mapping->host;
-	block_t old_blkaddr, new_blkaddr;
 	struct dnode_of_data dn;
 	int err = 0;
 
@@ -754,10 +764,10 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 	if (err)
 		return err;
 
-	old_blkaddr = dn.data_blkaddr;
+	fio->blk_addr = dn.data_blkaddr;
 
 	/* This page is already truncated */
-	if (old_blkaddr == NULL_ADDR)
+	if (fio->blk_addr == NULL_ADDR)
 		goto out_writepage;
 
 	set_page_writeback(page);
@@ -766,14 +776,14 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
 	 */
-	if (unlikely(old_blkaddr != NEW_ADDR &&
+	if (unlikely(fio->blk_addr != NEW_ADDR &&
 			!is_cold_data(page) &&
 			need_inplace_update(inode))) {
-		rewrite_data_page(page, old_blkaddr, fio);
+		rewrite_data_page(page, fio);
 		set_inode_flag(F2FS_I(inode), FI_UPDATE_WRITE);
 	} else {
-		write_data_page(page, &dn, &new_blkaddr, fio);
-		update_extent_cache(new_blkaddr, &dn);
+		write_data_page(page, &dn, fio);
+		update_extent_cache(fio->blk_addr, &dn);
 		set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
 	}
 out_writepage:
@@ -1007,8 +1017,12 @@ put_next:
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
-		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
-					   READ_SYNC);
+		struct f2fs_io_info fio = {
+			.type = DATA,
+			.rw = READ_SYNC,
+			.blk_addr = dn.data_blkaddr,
+		};
+		err = f2fs_submit_page_bio(sbi, page, &fio);
 		if (err)
 			goto fail;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a8ccbce..3f07b50 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -491,6 +491,7 @@ enum page_type {
 struct f2fs_io_info {
 	enum page_type type;	/* contains DATA/NODE/META/META_FLUSH */
 	int rw;			/* contains R/RS/W/WS with REQ_META/REQ_PRIO */
+	block_t blk_addr;	/* block address to be written */
 };
 
 #define is_read_io(rw)	(((rw) & 1) == READ)
@@ -1414,10 +1415,10 @@ int f2fs_trim_fs(struct f2fs_sb_info *, struct fstrim_range *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *,
-		struct f2fs_io_info *, unsigned int, block_t, block_t *);
-void write_data_page(struct page *, struct dnode_of_data *, block_t *,
-					struct f2fs_io_info *);
-void rewrite_data_page(struct page *, block_t, struct f2fs_io_info *);
+				unsigned int, struct f2fs_io_info *);
+void write_data_page(struct page *, struct dnode_of_data *,
+			struct f2fs_io_info *);
+void rewrite_data_page(struct page *, struct f2fs_io_info *);
 void recover_data_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void allocate_data_block(struct f2fs_sb_info *, struct page *,
@@ -1464,8 +1465,9 @@ void destroy_checkpoint_caches(void);
  * data.c
  */
 void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, int);
-int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);
-void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *, block_t,
+int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *,
+						struct f2fs_io_info *);
+void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *,
 						struct f2fs_io_info *);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index f2d3c58..0c3f3f9 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -79,7 +79,6 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 {
 	void *src_addr, *dst_addr;
-	block_t new_blk_addr;
 	struct f2fs_io_info fio = {
 		.type = DATA,
 		.rw = WRITE_SYNC | REQ_PRIO,
@@ -115,9 +114,9 @@ no_update:
 
 	/* write data page to try to make data consistent */
 	set_page_writeback(page);
-
-	write_data_page(page, dn, &new_blk_addr, &fio);
-	update_extent_cache(new_blk_addr, dn);
+	fio.blk_addr = dn->data_blkaddr;
+	write_data_page(page, dn, &fio);
+	update_extent_cache(fio.blk_addr, dn);
 	f2fs_wait_on_page_writeback(page, DATA);
 	if (dirty)
 		inode_dec_dirty_pages(dn->inode);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index bcfd67c..adc35c9 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -977,6 +977,10 @@ static int read_node_page(struct page *page, int rw)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	struct node_info ni;
+	struct f2fs_io_info fio = {
+		.type = NODE,
+		.rw = rw,
+	};
 
 	get_node_info(sbi, page->index, &ni);
 
@@ -988,7 +992,8 @@ static int read_node_page(struct page *page, int rw)
 	if (PageUptodate(page))
 		return LOCKED_PAGE;
 
-	return f2fs_submit_page_bio(sbi, page, ni.blk_addr, rw);
+	fio.blk_addr = ni.blk_addr;
+	return f2fs_submit_page_bio(sbi, page, &fio);
 }
 
 /*
@@ -1269,7 +1274,6 @@ static int f2fs_write_node_page(struct page *page,
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	nid_t nid;
-	block_t new_addr;
 	struct node_info ni;
 	struct f2fs_io_info fio = {
 		.type = NODE,
@@ -1304,9 +1308,11 @@ static int f2fs_write_node_page(struct page *page,
 	} else {
 		down_read(&sbi->node_write);
 	}
+
 	set_page_writeback(page);
-	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
-	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
+	fio.blk_addr = ni.blk_addr;
+	write_node_page(sbi, page, nid, &fio);
+	set_node_addr(sbi, &ni, fio.blk_addr, is_fsync_dnode(page));
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
 	up_read(&sbi->node_write);
 	unlock_page(page);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c950c93..c726f86 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1182,39 +1182,39 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 }
 
 static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
-			block_t old_blkaddr, block_t *new_blkaddr,
-			struct f2fs_summary *sum, struct f2fs_io_info *fio)
+			struct f2fs_summary *sum,
+			struct f2fs_io_info *fio)
 {
 	int type = __get_segment_type(page, fio->type);
 
-	allocate_data_block(sbi, page, old_blkaddr, new_blkaddr, sum, type);
+	allocate_data_block(sbi, page, fio->blk_addr, &fio->blk_addr, sum, type);
 
 	/* writeout dirty page into bdev */
-	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, fio);
+	f2fs_submit_page_mbio(sbi, page, fio);
 }
 
 void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 {
 	struct f2fs_io_info fio = {
 		.type = META,
-		.rw = WRITE_SYNC | REQ_META | REQ_PRIO
+		.rw = WRITE_SYNC | REQ_META | REQ_PRIO,
+		.blk_addr = page->index,
 	};
 
 	set_page_writeback(page);
-	f2fs_submit_page_mbio(sbi, page, page->index, &fio);
+	f2fs_submit_page_mbio(sbi, page, &fio);
 }
 
 void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
-		struct f2fs_io_info *fio,
-		unsigned int nid, block_t old_blkaddr, block_t *new_blkaddr)
+			unsigned int nid, struct f2fs_io_info *fio)
 {
 	struct f2fs_summary sum;
 	set_summary(&sum, nid, 0, 0);
-	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, fio);
+	do_write_page(sbi, page, &sum, fio);
 }
 
 void write_data_page(struct page *page, struct dnode_of_data *dn,
-		block_t *new_blkaddr, struct f2fs_io_info *fio)
+				struct f2fs_io_info *fio)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct f2fs_summary sum;
@@ -1223,14 +1223,12 @@ void write_data_page(struct page *page, struct dnode_of_data *dn,
 	f2fs_bug_on(sbi, dn->data_blkaddr == NULL_ADDR);
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
-
-	do_write_page(sbi, page, dn->data_blkaddr, new_blkaddr, &sum, fio);
+	do_write_page(sbi, page, &sum, fio);
 }
 
-void rewrite_data_page(struct page *page, block_t old_blkaddr,
-					struct f2fs_io_info *fio)
+void rewrite_data_page(struct page *page, struct f2fs_io_info *fio)
 {
-	f2fs_submit_page_mbio(F2FS_P_SB(page), page, old_blkaddr, fio);
+	f2fs_submit_page_mbio(F2FS_P_SB(page), page, fio);
 }
 
 void recover_data_page(struct f2fs_sb_info *sbi,
-- 
2.1.1

