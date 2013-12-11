Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab3LKGGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:06:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53977 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3LKGGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:06:35 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-f3-52a800e9934b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Fan Li <fanofcode.li@samsung.com>,
        Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH 1/2] f2fs: refactor bio->rw handling
Date: Wed, 11 Dec 2013 15:05:26 +0900
Message-id: <1386741927-6007-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t8zfd2XDCuCDF7fE7G4tq+RyeLz1kZ2
	i+u7/jJZXFrkbrFn70kWi8u75rA5sHnsXvCZyaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgy
	Gp5fYS24voSxYt/CgAbGR62MXYycHBICJhI7fh5lgrDFJC7cW8/WxcjFISSwjFHiYtcfZpii
	o9MmM0EkFjFKPNt7mx3CaWaSOHf0P9AoDg42AW2JzfsNQBpEBJglFkw9zwhSwyxwm1Hi6+/n
	7CAJYaBJL49NAlvHIqAq8fY4yGoODl4BN4mea+4Qy7Qltj2fCNYrIfCaTeJzyxJ2iHoBiW+T
	D7GA1EsIyEpsOgB1nKTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERKY
	fTsYbx6wPsSYDDRuIrOUaHI+MLDzSuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAOjv8car8lL9W67/WBh+dFrk3JcIGT63mh/7hc/76zu9v6cEMdU
	x1H20OGgoW9zaLFyMus9l0VWHCovw9/07hfzf3ygoXqBoO61S93moQrvkirjBO0OhrxW5sy5
	0+13LvxJl6Ikk8YFk4vZdYFhRUWrEqTl5qapCBXMZgiwt948M+F9ktfLo0osxRmJhlrMRcWJ
	AHhqho5iAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd0XDCuCDN5fUbG4tq+RyeLz1kZ2
	i+u7/jJZXFrkbrFn70kWi8u75rA5sHnsXvCZyaNvyypGj8+b5AKYoxoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMxqeX2EtuL6EsWLfwoAGxketjF2MnBwSAiYSR6dNZoKw
	xSQu3FvP1sXIxSEksIhR4tne2+wQTjOTxLmj/4E6ODjYBLQlNu83AGkQEWCWWDD1PCNIDbPA
	bUaJr7+fs4MkhIGmvjw2CWwqi4CqxNvjR5lAenkF3CR6rrlDLNOW2PZ8IuMERu4FjAyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYLD/pnUDsaVDRaHGAU4GJV4eA8ULQ8SYk0sK67MPcQo
	wcGsJMK70RQoxJuSWFmVWpQfX1Sak1p8iDEZaPlEZinR5HxgTOaVxBsam5gZWRqZWRiZmJuT
	Jqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OE3MR81bwiTml5M6d1s49fWHZ+1bJ7axss
	G0vvK1rZ/NHMY7XW0Zojc/N+WdiJtjsfAx83uV6YVquUflg2wMnVpsosJaNqZcnxGg+3bhbX
	nslFktrztrTILiy/X8ZwtjOgTFTc8/KOzxqB11bNEDl+/3Fr49uyzVXtNVc+tf2ZG7Rfsfre
	NyWW4oxEQy3mouJEAPzADfu/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_io_info to mitigate the complex parameter list.

struct f2fs_io_info {
	enum page_type type;		/* contains DATA/NODE/META/META_FLUSH */
	int rw;				/* contains R/RS/W/WS */
	int rw_flag;			/* contains REQ_META/REQ_PRIO */
}

1. f2fs_write_data_pages
 - DATA
 - WRITE_SYNC is set when wbc->WB_SYNC_ALL.

2. sync_node_pages
 - NODE
 - WRITE_SYNC all the time

3. sync_meta_pages
 - META
 - WRITE_SYNC all the time
 - REQ_META | REQ_PRIO all the time

 ** f2fs_submit_merged_bio() handles META_FLUSH.

4. ra_nat_pages, ra_sit_pages, ra_sum_pages
 - META
 - READ_SYNC

Cc: Fan Li <fanofcode.li@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 11 ++++---
 fs/f2fs/data.c       | 85 ++++++++++++++++++++++++++--------------------------
 fs/f2fs/f2fs.h       | 22 +++++++++-----
 fs/f2fs/gc.c         | 10 ++++---
 fs/f2fs/node.c       | 22 ++++++++++----
 fs/f2fs/segment.c    | 70 ++++++++++++++++++++++++++-----------------
 fs/f2fs/super.c      |  7 ++++-
 7 files changed, 132 insertions(+), 95 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index cf505eb..f8c0749 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -164,8 +164,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 	}
 
 	if (nwritten)
-		f2fs_submit_merged_bio(sbi, type, nr_to_write == LONG_MAX,
-								WRITE);
+		f2fs_submit_merged_bio(sbi, type, WRITE);
 
 	return nwritten;
 }
@@ -598,7 +597,7 @@ retry:
 		 * We should submit bio, since it exists several
 		 * wribacking dentry pages in the freeing inode.
 		 */
-		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 	}
 	goto retry;
 }
@@ -804,9 +803,9 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
 
-	f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
-	f2fs_submit_merged_bio(sbi, NODE, true, WRITE);
-	f2fs_submit_merged_bio(sbi, META, true, WRITE);
+	f2fs_submit_merged_bio(sbi, DATA, WRITE);
+	f2fs_submit_merged_bio(sbi, NODE, WRITE);
+	f2fs_submit_merged_bio(sbi, META, WRITE);
 
 	/*
 	 * update checkpoint pack index
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fb5e5c2..ebc9177 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -93,37 +93,28 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static void __submit_merged_bio(struct f2fs_sb_info *sbi,
-				struct f2fs_bio_info *io,
-				enum page_type type, bool sync, int rw)
+static void __submit_merged_bio(struct f2fs_bio_info *io)
 {
-	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct f2fs_io_info *fio = &io->fio;
+	int rw;
 
 	if (!io->bio)
 		return;
 
-	if (btype == META)
-		rw |= REQ_META;
+	rw = fio->rw | fio->rw_flag;
 
 	if (is_read_io(rw)) {
-		if (sync)
-			rw |= READ_SYNC;
 		submit_bio(rw, io->bio);
-		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
+		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
 		io->bio = NULL;
 		return;
 	}
 
-	if (sync)
-		rw |= WRITE_SYNC;
-	if (type >= META_FLUSH)
-		rw |= WRITE_FLUSH_FUA;
-
 	/*
 	 * META_FLUSH is only from the checkpoint procedure, and we should wait
 	 * this metadata bio for FS consistency.
 	 */
-	if (type == META_FLUSH) {
+	if (fio->type == META_FLUSH) {
 		DECLARE_COMPLETION_ONSTACK(wait);
 		io->bio->bi_private = &wait;
 		submit_bio(rw, io->bio);
@@ -131,12 +122,12 @@ static void __submit_merged_bio(struct f2fs_sb_info *sbi,
 	} else {
 		submit_bio(rw, io->bio);
 	}
-	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
+	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
 	io->bio = NULL;
 }
 
 void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
-				enum page_type type, bool sync, int rw)
+				enum page_type type, int rw)
 {
 	enum page_type btype = PAGE_TYPE_OF_BIO(type);
 	struct f2fs_bio_info *io;
@@ -144,7 +135,13 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
 
 	mutex_lock(&io->io_mutex);
-	__submit_merged_bio(sbi, io, type, sync, rw);
+
+	/* change META to META_FLUSH in the checkpoint procedure */
+	if (type >= META_FLUSH) {
+		io->fio.type = META_FLUSH;
+		io->fio.rw = WRITE_FLUSH_FUA;
+	}
+	__submit_merged_bio(io);
 	mutex_unlock(&io->io_mutex);
 }
 
@@ -178,33 +175,33 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 }
 
 void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
-			block_t blk_addr, enum page_type type, int rw)
+			block_t blk_addr, struct f2fs_io_info *fio)
 {
-	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
 	struct block_device *bdev = sbi->sb->s_bdev;
 	struct f2fs_bio_info *io;
 	int bio_blocks;
 
-	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
+	io = is_read_io(fio->rw) ? &sbi->read_io : &sbi->write_io[btype];
 
 	verify_block_addr(sbi, blk_addr);
 
 	mutex_lock(&io->io_mutex);
 
-	if (!is_read_io(rw))
+	if (!is_read_io(fio->rw))
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
 	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
-						io->rw_flag != rw))
-		__submit_merged_bio(sbi, io, type, false, io->rw_flag);
+						io->fio.rw != fio->rw))
+		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
 		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 		io->bio = __bio_alloc(bdev, bio_blocks);
 		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		io->bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io :
+		io->bio->bi_end_io = is_read_io(fio->rw) ? f2fs_read_end_io :
 							f2fs_write_end_io;
-		io->rw_flag = rw;
+		io->fio = *fio;
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
@@ -214,14 +211,14 @@ alloc_new:
 
 	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
 							PAGE_CACHE_SIZE) {
-		__submit_merged_bio(sbi, io, type, false, rw);
+		__submit_merged_bio(io);
 		goto alloc_new;
 	}
 
 	io->last_block_in_bio = blk_addr;
 
 	mutex_unlock(&io->io_mutex);
-	trace_f2fs_submit_page_mbio(page, rw, type, blk_addr);
+	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, blk_addr);
 }
 
 /*
@@ -643,10 +640,10 @@ static int f2fs_read_data_pages(struct file *file,
 	return mpage_readpages(mapping, pages, nr_pages, get_data_block_ro);
 }
 
-int do_write_data_page(struct page *page, struct writeback_control *wbc)
+int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 {
 	struct inode *inode = page->mapping->host;
-	block_t old_blk_addr, new_blk_addr;
+	block_t old_blkaddr, new_blkaddr;
 	struct dnode_of_data dn;
 	int err = 0;
 
@@ -655,10 +652,10 @@ int do_write_data_page(struct page *page, struct writeback_control *wbc)
 	if (err)
 		return err;
 
-	old_blk_addr = dn.data_blkaddr;
+	old_blkaddr = dn.data_blkaddr;
 
 	/* This page is already truncated */
-	if (old_blk_addr == NULL_ADDR)
+	if (old_blkaddr == NULL_ADDR)
 		goto out_writepage;
 
 	set_page_writeback(page);
@@ -667,15 +664,13 @@ int do_write_data_page(struct page *page, struct writeback_control *wbc)
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
 	 */
-	if (unlikely(old_blk_addr != NEW_ADDR &&
+	if (unlikely(old_blkaddr != NEW_ADDR &&
 			!is_cold_data(page) &&
 			need_inplace_update(inode))) {
-		rewrite_data_page(F2FS_SB(inode->i_sb), page,
-						old_blk_addr, wbc);
+		rewrite_data_page(page, old_blkaddr, fio);
 	} else {
-		write_data_page(inode, page, &dn,
-				old_blk_addr, &new_blk_addr, wbc);
-		update_extent_cache(new_blk_addr, &dn);
+		write_data_page(page, &dn, &new_blkaddr, fio);
+		update_extent_cache(new_blkaddr, &dn);
 	}
 out_writepage:
 	f2fs_put_dnode(&dn);
@@ -693,6 +688,11 @@ static int f2fs_write_data_page(struct page *page,
 	unsigned offset;
 	bool need_balance_fs = false;
 	int err = 0;
+	struct f2fs_io_info fio = {
+		.type = DATA,
+		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC: WRITE,
+		.rw_flag = 0,
+	};
 
 	if (page->index < end_index)
 		goto write;
@@ -721,10 +721,10 @@ write:
 	if (S_ISDIR(inode->i_mode)) {
 		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(inode);
-		err = do_write_data_page(page, wbc);
+		err = do_write_data_page(page, &fio);
 	} else {
 		f2fs_lock_op(sbi);
-		err = do_write_data_page(page, wbc);
+		err = do_write_data_page(page, &fio);
 		f2fs_unlock_op(sbi);
 		need_balance_fs = true;
 	}
@@ -734,7 +734,7 @@ write:
 		goto redirty_out;
 
 	if (wbc->for_reclaim)
-		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 
 	clear_cold_data(page);
 out:
@@ -786,7 +786,8 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	ret = write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
 	if (locked)
 		mutex_unlock(&sbi->writepages);
-	f2fs_submit_merged_bio(sbi, DATA, wbc->sync_mode == WB_SYNC_ALL, WRITE);
+
+	f2fs_submit_merged_bio(sbi, DATA, WRITE);
 
 	remove_dirty_dir_inode(inode);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b1df239..022ce32 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -364,11 +364,18 @@ enum page_type {
 	META_FLUSH,
 };
 
+struct f2fs_io_info {
+	enum page_type type;		/* contains DATA/NODE/META/META_FLUSH */
+	int rw;				/* contains R/RS/W/WS */
+	int rw_flag;			/* contains REQ_META/REQ_PRIO */
+};
+
 #define is_read_io(rw)	(((rw) & 1) == READ)
 struct f2fs_bio_info {
+	struct f2fs_sb_info *sbi;	/* f2fs superblock */
 	struct bio *bio;		/* bios to merge */
 	sector_t last_block_in_bio;	/* last block number */
-	int rw_flag;				/* rw flag for all pages */
+	struct f2fs_io_info fio;	/* store buffered io info. */
 	struct mutex io_mutex;		/* mutex for bio */
 };
 
@@ -1098,10 +1105,9 @@ struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *, unsigned int,
 					block_t, block_t *);
-void write_data_page(struct inode *, struct page *, struct dnode_of_data*,
-			block_t, block_t *, struct writeback_control *);
-void rewrite_data_page(struct f2fs_sb_info *, struct page *, block_t,
-				struct writeback_control *);
+void write_data_page(struct page *, struct dnode_of_data *, block_t *,
+					struct f2fs_io_info *);
+void rewrite_data_page(struct page *, block_t, struct f2fs_io_info *);
 void recover_data_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void rewrite_node_page(struct f2fs_sb_info *, struct page *,
@@ -1142,17 +1148,17 @@ void destroy_checkpoint_caches(void);
 /*
  * data.c
  */
-void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, bool, int);
+void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, int);
 int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);
 void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *, block_t,
-							enum page_type, int);
+						struct f2fs_io_info *);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
-int do_write_data_page(struct page *, struct writeback_control *);
+int do_write_data_page(struct page *, struct f2fs_io_info *);
 
 /*
  * gc.c
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index c68fba5..69c18e3 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -520,8 +520,10 @@ static int check_dnode(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 
 static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 {
-	struct writeback_control wbc = {
-		.sync_mode = 1,
+	struct f2fs_io_info fio = {
+		.type = DATA,
+		.rw = WRITE_SYNC,
+		.rw_flag = 0,
 	};
 
 	if (gc_type == BG_GC) {
@@ -540,7 +542,7 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 			inode_dec_dirty_dents(inode);
 		}
 		set_cold_data(page);
-		do_write_data_page(page, &wbc);
+		do_write_data_page(page, &fio);
 		clear_cold_data(page);
 	}
 out:
@@ -634,7 +636,7 @@ next_iput:
 		goto next_step;
 
 	if (gc_type == FG_GC) {
-		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 
 		/*
 		 * In the case of FG_GC, it'd be better to reclaim this victim
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6c6ef77..3565caf 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -92,6 +92,12 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 	struct page *page;
 	pgoff_t index;
 	int i;
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = READ_SYNC,
+		.rw_flag = REQ_META | REQ_PRIO
+	};
+
 
 	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
 		if (unlikely(nid >= nm_i->max_nid))
@@ -106,11 +112,11 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 			f2fs_put_page(page, 1);
 			continue;
 		}
-		f2fs_submit_page_mbio(sbi, page, index, META, READ);
+		f2fs_submit_page_mbio(sbi, page, index, &fio);
 		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
 	}
-	f2fs_submit_merged_bio(sbi, META, true, READ);
+	f2fs_submit_merged_bio(sbi, META, READ);
 }
 
 static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
@@ -1136,8 +1142,7 @@ continue_unlock:
 	}
 
 	if (wrote)
-		f2fs_submit_merged_bio(sbi, NODE, wbc->sync_mode == WB_SYNC_ALL,
-									WRITE);
+		f2fs_submit_merged_bio(sbi, NODE, WRITE);
 	return nwritten;
 }
 
@@ -1574,6 +1579,11 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 {
 	struct page *page;
 	int page_idx = start;
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = READ_SYNC,
+		.rw_flag = REQ_META | REQ_PRIO
+	};
 
 	for (; page_idx < start + nrpages; page_idx++) {
 		/* alloc temporal page for read node summary info*/
@@ -1594,9 +1604,9 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	}
 
 	list_for_each_entry(page, pages, lru)
-		f2fs_submit_page_mbio(sbi, page, page->index, META, READ);
+		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
 
-	f2fs_submit_merged_bio(sbi, META, true, READ);
+	f2fs_submit_merged_bio(sbi, META, READ);
 	return 0;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e5dc411..0b2e8ce 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -856,15 +856,14 @@ static int __get_segment_type(struct page *page, enum page_type p_type)
 
 static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 			block_t old_blkaddr, block_t *new_blkaddr,
-			struct f2fs_summary *sum, enum page_type p_type,
-			struct writeback_control *wbc)
+			struct f2fs_summary *sum, struct f2fs_io_info *fio)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg;
 	unsigned int old_cursegno;
-	int type, rw = WRITE;
+	int type;
 
-	type = __get_segment_type(page, p_type);
+	type = __get_segment_type(page, fio->type);
 	curseg = CURSEG_I(sbi, type);
 
 	mutex_lock(&curseg->curseg_mutex);
@@ -897,55 +896,60 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 	mutex_unlock(&sit_i->sentry_lock);
 
-	if (p_type == NODE)
+	if (fio->type == NODE)
 		fill_node_footer_blkaddr(page, NEXT_FREE_BLKADDR(sbi, curseg));
 
 	/* writeout dirty page into bdev */
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= WRITE_SYNC;
-	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, p_type, rw);
+	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, fio);
 
 	mutex_unlock(&curseg->curseg_mutex);
 }
 
 void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 {
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = WRITE_SYNC,
+		.rw_flag = REQ_META | REQ_PRIO
+	};
+
 	set_page_writeback(page);
-	f2fs_submit_page_mbio(sbi, page, page->index, META, WRITE);
+	f2fs_submit_page_mbio(sbi, page, page->index, &fio);
 }
 
 void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
 		unsigned int nid, block_t old_blkaddr, block_t *new_blkaddr)
 {
 	struct f2fs_summary sum;
-	struct writeback_control wbc = {
-		.sync_mode = 1,
+	struct f2fs_io_info fio = {
+		.type = NODE,
+		.rw = WRITE_SYNC,
+		.rw_flag = 0
 	};
+
 	set_summary(&sum, nid, 0, 0);
-	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, NODE, &wbc);
+	do_write_page(sbi, page, old_blkaddr, new_blkaddr, &sum, &fio);
 }
 
-void write_data_page(struct inode *inode, struct page *page,
-		struct dnode_of_data *dn, block_t old_blkaddr,
-		block_t *new_blkaddr, struct writeback_control *wbc)
+void write_data_page(struct page *page, struct dnode_of_data *dn,
+		block_t *new_blkaddr, struct f2fs_io_info *fio)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct f2fs_summary sum;
 	struct node_info ni;
 
-	f2fs_bug_on(old_blkaddr == NULL_ADDR);
+	f2fs_bug_on(dn->data_blkaddr == NULL_ADDR);
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 
-	do_write_page(sbi, page, old_blkaddr,
-			new_blkaddr, &sum, DATA, wbc);
+	do_write_page(sbi, page, dn->data_blkaddr, new_blkaddr, &sum, fio);
 }
 
-void rewrite_data_page(struct f2fs_sb_info *sbi, struct page *page,
-			block_t old_blk_addr, struct writeback_control *wbc)
+void rewrite_data_page(struct page *page, block_t old_blkaddr, struct f2fs_io_info *fio)
 {
-	int rw = wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE;
-	f2fs_submit_page_mbio(sbi, page, old_blk_addr, DATA, rw);
+	struct inode *inode = page->mapping->host;
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	f2fs_submit_page_mbio(sbi, page, old_blkaddr, fio);
 }
 
 void recover_data_page(struct f2fs_sb_info *sbi,
@@ -1004,6 +1008,11 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	unsigned int segno, old_cursegno;
 	block_t next_blkaddr = next_blkaddr_of_node(page);
 	unsigned int next_segno = GET_SEGNO(sbi, next_blkaddr);
+	struct f2fs_io_info fio = {
+		.type = NODE,
+		.rw = WRITE_SYNC,
+		.rw_flag = 0
+	};
 
 	curseg = CURSEG_I(sbi, type);
 
@@ -1032,8 +1041,8 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 
 	/* rewrite node page */
 	set_page_writeback(page);
-	f2fs_submit_page_mbio(sbi, page, new_blkaddr, NODE, WRITE_SYNC);
-	f2fs_submit_merged_bio(sbi, NODE, true, WRITE);
+	f2fs_submit_page_mbio(sbi, page, new_blkaddr, &fio);
+	f2fs_submit_merged_bio(sbi, NODE, WRITE);
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
 
 	locate_dirty_segment(sbi, old_cursegno);
@@ -1048,7 +1057,7 @@ void f2fs_wait_on_page_writeback(struct page *page,
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
 	if (PageWriteback(page)) {
-		f2fs_submit_merged_bio(sbi, type, sync, WRITE);
+		f2fs_submit_merged_bio(sbi, type, WRITE);
 		wait_on_page_writeback(page);
 	}
 }
@@ -1580,6 +1589,11 @@ static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
 	block_t blk_addr, prev_blk_addr = 0;
 	int sit_blk_cnt = SIT_BLK_CNT(sbi);
 	int blkno = start;
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = READ_SYNC,
+		.rw_flag = REQ_META | REQ_PRIO
+	};
 
 	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
 
@@ -1600,13 +1614,13 @@ repeat:
 			continue;
 		}
 
-		f2fs_submit_page_mbio(sbi, page, blk_addr, META, READ_SYNC);
+		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
 
 		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
 	}
 
-	f2fs_submit_merged_bio(sbi, META, true, READ);
+	f2fs_submit_merged_bio(sbi, META, READ);
 	return blkno - start;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 68df44a..1674f2f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -885,8 +885,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	spin_lock_init(&sbi->stat_lock);
 
 	mutex_init(&sbi->read_io.io_mutex);
-	for (i = 0; i < NR_PAGE_TYPE; i++)
+	sbi->read_io.sbi = sbi;
+	sbi->read_io.bio = NULL;
+	for (i = 0; i < NR_PAGE_TYPE; i++) {
 		mutex_init(&sbi->write_io[i].io_mutex);
+		sbi->write_io[i].sbi = sbi;
+		sbi->write_io[i].bio = NULL;
+	}
 
 	init_rwsem(&sbi->cp_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
-- 
1.8.4.474.g128a96c

