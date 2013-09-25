Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3IYUXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:23:02 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62428 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3IYUWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:55 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 2/6] block: Convert various code to bio_for_each_page()
Date: Wed, 25 Sep 2013 13:22:40 -0700
Message-Id: <1380140564-9030-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/btrfs/compression.c |  8 ++++----
 fs/btrfs/disk-io.c     | 11 ++++++-----
 fs/btrfs/extent_io.c   | 48 +++++++++++++++++++++++++-----------------------
 fs/btrfs/file-item.c   | 42 +++++++++++++++++++-----------------------
 fs/btrfs/inode.c       | 35 +++++++++++++++++++----------------
 fs/logfs/dev_bdev.c    | 10 +++++-----
 6 files changed, 78 insertions(+), 76 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b4dc421..51e5cc5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -200,15 +200,15 @@ csum_failed:
 	if (cb->errors) {
 		bio_io_error(cb->orig_bio);
 	} else {
-		int i;
-		struct bio_vec *bvec;
+		struct bio_vec bvec;
+		struct bvec_iter iter;
 
 		/*
 		 * we have verified the checksum already, set page
 		 * checked so the end_io handlers know about it
 		 */
-		bio_for_each_segment_all(bvec, cb->orig_bio, i)
-			SetPageChecked(bvec->bv_page);
+		bio_for_each_page_all(bvec, cb->orig_bio, iter)
+			SetPageChecked(bvec.bv_page);
 
 		bio_endio(cb->orig_bio, 0);
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6f84032..3ad7b5c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -850,13 +850,14 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 
 static int btree_csum_one_bio(struct bio *bio)
 {
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_root *root;
-	int i, ret = 0;
+	int ret = 0;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
-		ret = csum_dirty_buffer(root, bvec->bv_page);
+	bio_for_each_page_all(bvec, bio, iter) {
+		root = BTRFS_I(bvec.bv_page->mapping->host)->root;
+		ret = csum_dirty_buffer(root, bvec.bv_page);
 		if (ret)
 			break;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 27333ca..c4256ef 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2010,7 +2010,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	}
 	bio->bi_bdev = dev->bdev;
 	bio_add_page(bio, page, length, start - page_offset(page));
-	btrfsic_submit_bio(WRITE_SYNC, bio); /* XXX: submit_bio_wait() */
+	btrfsic_submit_bio(WRITE_SYNC, bio);
 	wait_for_completion(&compl);
 
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
@@ -2336,14 +2336,14 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  */
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
-	int i;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+	bio_for_each_page_all(bvec, bio, iter) {
+		struct page *page = bvec.bv_page;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 		/* We always issue full-page reads, but if some block
@@ -2351,14 +2351,14 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
+		if (bvec.bv_offset || bvec.bv_len != PAGE_CACHE_SIZE)
 			printk("%s page write in btrfs with offset %u and length %u\n",
-			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
+			       bvec.bv_offset + bvec.bv_len != PAGE_CACHE_SIZE
 			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
-			       bvec->bv_offset, bvec->bv_len);
+			       bvec.bv_offset, bvec.bv_len);
 
 		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		end = start + bvec.bv_offset + bvec.bv_len - 1;
 
 		if (end_extent_writepage(page, err, start, end))
 			continue;
@@ -2394,7 +2394,8 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
  */
 static void end_bio_extent_readpage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct extent_io_tree *tree;
@@ -2406,13 +2407,12 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	u64 extent_len = 0;
 	int mirror;
 	int ret;
-	int i;
 
 	if (err)
 		uptodate = 0;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+	bio_for_each_page_all(bvec, bio, iter) {
+		struct page *page = bvec.bv_page;
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
@@ -2425,15 +2425,15 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
+		if (bvec.bv_offset || bvec.bv_len != PAGE_CACHE_SIZE)
 			printk("%s page read in btrfs with offset %u and length %u\n",
-			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
+			       bvec.bv_offset + bvec.bv_len != PAGE_CACHE_SIZE
 			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
-			       bvec->bv_offset, bvec->bv_len);
+			       bvec.bv_offset, bvec.bv_len);
 
 		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
-		len = bvec->bv_len;
+		end = start + bvec.bv_offset + bvec.bv_len - 1;
+		len = bvec.bv_len;
 
 		mirror = io_bio->mirror_num;
 		if (likely(uptodate && tree->ops &&
@@ -3397,18 +3397,20 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 
 static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
+	int uptodate = err == 0;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct extent_buffer *eb;
-	int i, done;
+	int done;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+	bio_for_each_page_all(bvec, bio, iter) {
+		struct page *page = bvec.bv_page;
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
 		done = atomic_dec_and_test(&eb->io_pages);
 
-		if (err || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
 			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 			ClearPageUptodate(page);
 			SetPageError(page);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 997f951..ae328fb 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -162,7 +162,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -204,8 +205,6 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (bio->bi_iter.bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
-	WARN_ON(bio->bi_vcnt <= 0);
-
 	/*
 	 * the free space stuff is only read when it hasn't been
 	 * updated in the current transaction.  So, we can safely
@@ -220,9 +219,9 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	if (dio)
 		offset = logical_offset;
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_page_all(bvec, bio, iter) {
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -243,7 +242,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
-						offset + bvec->bv_len - 1,
+						offset + bvec.bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
 					printk(KERN_INFO "btrfs no csum found "
@@ -282,10 +281,10 @@ found:
 		csum += count * csum_size;
 		nblocks -= count;
 		while (count--) {
-			disk_bytenr += bvec->bv_len;
-			offset += bvec->bv_len;
-			bio_index++;
-			bvec++;
+			bvec = bio_iovec_iter(bio, iter);
+			disk_bytenr += bvec.bv_len;
+			offset += bvec.bv_len;
+			bio_advance_iter(bvec.bv_len);
 		}
 	}
 	btrfs_free_path(path);
@@ -436,14 +435,13 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	struct btrfs_ordered_sum *sums;
 	struct btrfs_ordered_extent *ordered;
 	char *data;
-	struct bio_vec *bvec = bio->bi_io_vec;
-	int bio_index = 0;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	int index;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
 
-	WARN_ON(bio->bi_vcnt <= 0);
 	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_iter.bi_size),
 		       GFP_NOFS);
 	if (!sums)
@@ -455,16 +453,16 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	if (contig)
 		offset = file_start;
 	else
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		offset = page_offset(bio_page(bio)) + bio_offset(bio);
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	BUG_ON(!ordered); /* Logic error */
 	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	index = 0;
 
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_page_all(bvec, bio, iter) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 
 		if (offset >= ordered->file_offset + ordered->len ||
 		    offset < ordered->file_offset) {
@@ -489,19 +487,17 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 		data = kmap_atomic(bvec->bv_page);
 		sums->sums[index] = ~(u32)0;
-		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
+		sums->sums[index] = btrfs_csum_data(data + bvec.bv_offset,
 						    sums->sums[index],
-						    bvec->bv_len);
+						    bvec.bv_len);
 		kunmap_atomic(data);
 		btrfs_csum_final(sums->sums[index],
 				 (char *)(sums->sums + index));
 
-		bio_index++;
 		index++;
-		total_bytes += bvec->bv_len;
-		this_sum_bytes += bvec->bv_len;
-		offset += bvec->bv_len;
-		bvec++;
+		total_bytes += bvec.bv_len;
+		this_sum_bytes += bvec.bv_len;
+		offset += bvec.bv_len;
 	}
 	this_sum_bytes = 0;
 	btrfs_add_ordered_sum(inode, ordered, sums);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5978a18..98de70c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6765,31 +6765,30 @@ unlock_err:
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
 	u32 *csums = (u32 *)dip->csum;
 	u64 start;
-	int i;
 
 	start = dip->logical_offset;
-	bio_for_each_segment_all(bvec, bio, i) {
+	bio_for_each_page_all(bvec, bio, iter) {
 		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-			struct page *page = bvec->bv_page;
 			char *kaddr;
 			u32 csum = ~(u32)0;
 			unsigned long flags;
 
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page);
-			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
-					       csum, bvec->bv_len);
+			kaddr = kmap_atomic(bvec.bv_page);
+			csum = btrfs_csum_data(kaddr + bvec.bv_offset,
+					       csum, bvec.bv_len);
 			btrfs_csum_final(csum, (char *)&csum);
 			kunmap_atomic(kaddr);
 			local_irq_restore(flags);
 
-			flush_dcache_page(bvec->bv_page);
+			flush_dcache_page(bvec.bv_page);
 			if (csum != csums[i]) {
 				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
 					  btrfs_ino(inode), start, csum,
@@ -6798,7 +6797,7 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			}
 		}
 
-		start += bvec->bv_len;
+		start += bvec.bv_len;
 	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
@@ -6964,7 +6963,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
-	struct bio_vec *bvec = orig_bio->bi_io_vec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	u64 start_sector = orig_bio->bi_iter.bi_sector;
 	u64 file_offset = dip->logical_offset;
 	u64 submit_len = 0;
@@ -7001,10 +7001,13 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	bio->bi_end_io = btrfs_end_dio_bio;
 	atomic_inc(&dip->pending_bios);
 
-	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (unlikely(map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len)) {
+	iter = orig_bio->bi_iter;
+	while (iter.bi_size) {
+		bvec = bio_iovec_iter(orig_bio, iter);
+
+		if (unlikely(map_length < submit_len + bvec.bv_len ||
+		    bio_add_page(bio, bvec.bv_page, bvec.bv_len,
+				 bvec.bv_offset) < bvec.bv_len)) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -7043,9 +7046,9 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 				goto out_err;
 			}
 		} else {
-			submit_len += bvec->bv_len;
+			submit_len += bvec.bv_len;
 			nr_pages ++;
-			bvec++;
+			bio_advance_iter(orig_bio, &iter, bvec.bv_len);
 		}
 	}
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 685ae02..c3c6361 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -61,17 +61,17 @@ static DECLARE_WAIT_QUEUE_HEAD(wq);
 static void writeseg_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec;
-	int i;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct super_block *sb = bio->bi_private;
 	struct logfs_super *super = logfs_super(sb);
 
 	BUG_ON(!uptodate); /* FIXME: Retry io or write elsewhere */
 	BUG_ON(err);
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		end_page_writeback(bvec->bv_page);
-		page_cache_release(bvec->bv_page);
+	bio_for_each_page_all(bvec, bio, iter) {
+		end_page_writeback(bvec.bv_page);
+		page_cache_release(bvec.bv_page);
 	}
 	bio_put(bio);
 	if (atomic_dec_and_test(&super->s_pending_writes))
-- 
1.8.4.rc3

