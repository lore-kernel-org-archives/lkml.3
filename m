Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3K0AxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:53:04 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51876 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3K0Apl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:45:41 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <chris.mason@fusionio.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 02/25] block: Convert various code to bio_for_each_segment()
Date: Tue, 26 Nov 2013 16:45:05 -0800
Message-Id: <1385513128-5035-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With immutable biovecs we don't want code accessing bi_io_vec directly -
the uses this patch changes weren't incorrect since they all own the
bio, but it makes the code harder to audit for no good reason - also,
this will help with multipage bvecs later.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/btrfs/compression.c           | 10 ++++------
 fs/btrfs/disk-io.c               | 11 ++++-------
 fs/btrfs/extent_io.c             | 35 +++++++++++++----------------------
 fs/btrfs/inode.c                 | 15 ++++++---------
 fs/ext4/page-io.c                |  4 ++--
 fs/f2fs/data.c                   | 13 +++++--------
 fs/f2fs/segment.c                | 12 +++++-------
 fs/logfs/dev_bdev.c              | 18 +++++++-----------
 fs/mpage.c                       | 17 ++++++++---------
 fs/nfs/blocklayout/blocklayout.c | 34 +++++++++++++---------------------
 10 files changed, 67 insertions(+), 102 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1499b27..eac6784 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -201,18 +201,16 @@ csum_failed:
 	if (cb->errors) {
 		bio_io_error(cb->orig_bio);
 	} else {
-		int bio_index = 0;
-		struct bio_vec *bvec = cb->orig_bio->bi_io_vec;
+		int i;
+		struct bio_vec *bvec;
 
 		/*
 		 * we have verified the checksum already, set page
 		 * checked so the end_io handlers know about it
 		 */
-		while (bio_index < cb->orig_bio->bi_vcnt) {
+		bio_for_each_segment_all(bvec, cb->orig_bio, i)
 			SetPageChecked(bvec->bv_page);
-			bvec++;
-			bio_index++;
-		}
+
 		bio_endio(cb->orig_bio, 0);
 	}
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..5a10c61 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -842,20 +842,17 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 
 static int btree_csum_one_bio(struct bio *bio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
-	int bio_index = 0;
+	struct bio_vec *bvec;
 	struct btrfs_root *root;
-	int ret = 0;
+	int i, ret = 0;
 
-	WARN_ON(bio->bi_vcnt <= 0);
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
 		ret = csum_dirty_buffer(root, bvec->bv_page);
 		if (ret)
 			break;
-		bio_index++;
-		bvec++;
 	}
+
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ff43802..8b5f9e1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2332,12 +2332,13 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  */
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
+	int i;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
@@ -2355,14 +2356,11 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		start = page_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
 		if (end_extent_writepage(page, err, start, end))
 			continue;
 
 		end_page_writeback(page);
-	} while (bvec >= bio->bi_io_vec);
+	}
 
 	bio_put(bio);
 }
@@ -2392,9 +2390,8 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
  */
 static void end_bio_extent_readpage(struct bio *bio, int err)
 {
+	struct bio_vec *bvec;
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct bio_vec *bvec = bio->bi_io_vec;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct extent_io_tree *tree;
 	u64 offset = 0;
@@ -2405,11 +2402,12 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	u64 extent_len = 0;
 	int mirror;
 	int ret;
+	int i;
 
 	if (err)
 		uptodate = 0;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 
@@ -2433,9 +2431,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
 		len = bvec->bv_len;
 
-		if (++bvec <= bvec_end)
-			prefetchw(&bvec->bv_page->flags);
-
 		mirror = io_bio->mirror_num;
 		if (likely(uptodate && tree->ops &&
 			   tree->ops->readpage_end_io_hook)) {
@@ -2516,7 +2511,7 @@ readpage_ok:
 			extent_start = start;
 			extent_len = end + 1 - start;
 		}
-	} while (bvec <= bvec_end);
+	}
 
 	if (extent_len)
 		endio_readpage_release_extent(tree, extent_start, extent_len,
@@ -2547,7 +2542,6 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 	}
 
 	if (bio) {
-		bio->bi_size = 0;
 		bio->bi_bdev = bdev;
 		bio->bi_sector = first_sector;
 		btrfs_bio = btrfs_io_bio(bio);
@@ -3410,20 +3404,18 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 
 static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 {
-	int uptodate = err == 0;
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
 	struct extent_buffer *eb;
-	int done;
+	int i, done;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		bvec--;
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
 		done = atomic_dec_and_test(&eb->io_pages);
 
-		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+		if (err || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
 			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 			ClearPageUptodate(page);
 			SetPageError(page);
@@ -3435,10 +3427,9 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 			continue;
 
 		end_extent_buffer_writeback(eb);
-	} while (bvec >= bio->bi_io_vec);
+	}
 
 	bio_put(bio);
-
 }
 
 static int write_one_eb(struct extent_buffer *eb,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a7744..d6630dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6779,17 +6779,16 @@ unlock_err:
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
-	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec;
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
 	u32 *csums = (u32 *)dip->csum;
-	int index = 0;
 	u64 start;
+	int i;
 
 	start = dip->logical_offset;
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
 			struct page *page = bvec->bv_page;
 			char *kaddr;
@@ -6805,18 +6804,16 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			local_irq_restore(flags);
 
 			flush_dcache_page(bvec->bv_page);
-			if (csum != csums[index]) {
+			if (csum != csums[i]) {
 				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
 					  btrfs_ino(inode), start, csum,
-					  csums[index]);
+					  csums[i]);
 				err = -EIO;
 			}
 		}
 
 		start += bvec->bv_len;
-		bvec++;
-		index++;
-	} while (bvec <= bvec_end);
+	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d488f80..a31e4da 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -65,9 +65,9 @@ static void ext4_finish_bio(struct bio *bio)
 {
 	int i;
 	int error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct bio_vec *bvec;
 
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		struct bio_vec *bvec = &bio->bi_io_vec[i];
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct buffer_head *bh, *head;
 		unsigned bio_start = bvec->bv_offset;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..a494909 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -351,23 +351,20 @@ repeat:
 
 static void read_end_io(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
+	int i;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (uptodate) {
+		if (!err) {
 			SetPageUptodate(page);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
 		unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
+	}
 	bio_put(bio);
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index fa284d3..a90c6bc 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -575,16 +575,14 @@ static const struct segment_allocation default_salloc_ops = {
 
 static void f2fs_end_io_write(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_private *p = bio->bi_private;
+	struct bio_vec *bvec;
+	int i;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-		if (!uptodate) {
+		if (err) {
 			SetPageError(page);
 			if (page->mapping)
 				set_bit(AS_EIO, &page->mapping->flags);
@@ -593,7 +591,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
 		}
 		end_page_writeback(page);
 		dec_page_count(p->sbi, F2FS_WRITEBACK);
-	} while (bvec >= bio->bi_io_vec);
+	}
 
 	if (p->is_sync)
 		complete(p->wait);
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 0f95f0d..e6df3be 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -56,22 +56,18 @@ static DECLARE_WAIT_QUEUE_HEAD(wq);
 static void writeseg_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
+	int i;
 	struct super_block *sb = bio->bi_private;
 	struct logfs_super *super = logfs_super(sb);
-	struct page *page;
 
 	BUG_ON(!uptodate); /* FIXME: Retry io or write elsewhere */
 	BUG_ON(err);
-	BUG_ON(bio->bi_vcnt == 0);
-	do {
-		page = bvec->bv_page;
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		end_page_writeback(page);
-		page_cache_release(page);
-	} while (bvec >= bio->bi_io_vec);
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		end_page_writeback(bvec->bv_page);
+		page_cache_release(bvec->bv_page);
+	}
 	bio_put(bio);
 	if (atomic_dec_and_test(&super->s_pending_writes))
 		wake_up(&wq);
diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..dd6d587 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -43,16 +43,14 @@
  */
 static void mpage_end_io(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bv;
+	int i;
 
-	do {
-		struct page *page = bvec->bv_page;
+	bio_for_each_segment_all(bv, bio, i) {
+		struct page *page = bv->bv_page;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
 		if (bio_data_dir(bio) == READ) {
-			if (uptodate) {
+			if (!err) {
 				SetPageUptodate(page);
 			} else {
 				ClearPageUptodate(page);
@@ -60,14 +58,15 @@ static void mpage_end_io(struct bio *bio, int err)
 			}
 			unlock_page(page);
 		} else { /* bio_data_dir(bio) == WRITE */
-			if (!uptodate) {
+			if (err) {
 				SetPageError(page);
 				if (page->mapping)
 					set_bit(AS_EIO, &page->mapping->flags);
 			}
 			end_page_writeback(page);
 		}
-	} while (bvec >= bio->bi_io_vec);
+	}
+
 	bio_put(bio);
 }
 
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index e242bbf..da76892 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -201,18 +201,14 @@ static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
 static void bl_end_io_read(struct bio *bio, int err)
 {
 	struct parallel_io *par = bio->bi_private;
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
+	int i;
 
-	do {
-		struct page *page = bvec->bv_page;
+	if (!err)
+		bio_for_each_segment_all(bvec, bio, i)
+			SetPageUptodate(bvec->bv_page);
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-		if (uptodate)
-			SetPageUptodate(page);
-	} while (bvec >= bio->bi_io_vec);
-	if (!uptodate) {
+	if (err) {
 		struct nfs_read_data *rdata = par->data;
 		struct nfs_pgio_header *header = rdata->header;
 
@@ -383,20 +379,16 @@ static void mark_extents_written(struct pnfs_block_layout *bl,
 static void bl_end_io_write_zero(struct bio *bio, int err)
 {
 	struct parallel_io *par = bio->bi_private;
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-
-	do {
-		struct page *page = bvec->bv_page;
+	struct bio_vec *bvec;
+	int i;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
+	bio_for_each_segment_all(bvec, bio, i) {
 		/* This is the zeroing page we added */
-		end_page_writeback(page);
-		page_cache_release(page);
-	} while (bvec >= bio->bi_io_vec);
+		end_page_writeback(bvec->bv_page);
+		page_cache_release(bvec->bv_page);
+	}
 
-	if (unlikely(!uptodate)) {
+	if (unlikely(err)) {
 		struct nfs_write_data *data = par->data;
 		struct nfs_pgio_header *header = data->header;
 
-- 
1.8.4.4

