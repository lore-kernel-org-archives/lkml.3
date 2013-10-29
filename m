Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3J2US4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:18:56 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46489 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3J2USs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:48 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Date: Tue, 29 Oct 2013 13:18:10 -0700
Message-Id: <1383077896-4132-18-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to convert the dm code to the new bvec_iter primitives which
respect bi_bvec_done; they also allow us to drastically simplify dm's
bio splitting code.

Also kill bio_sector_offset(), dm was the only user and it doesn't make
much sense anymore.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-thin.c |   8 ++-
 drivers/md/dm.c      | 170 ++++++---------------------------------------------
 fs/bio.c             |  38 ------------
 include/linux/bio.h  |   1 -
 4 files changed, 24 insertions(+), 193 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a654024..1abb4a2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -611,8 +611,10 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
-	if (m->bio)
+	if (m->bio) {
 		m->bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&m->bio->bi_remaining);
+	}
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
 	mempool_free(m, m->tc->pool->mapping_pool);
@@ -626,8 +628,10 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	int r;
 
 	bio = m->bio;
-	if (bio)
+	if (bio) {
 		bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&bio->bi_remaining);
+	}
 
 	if (m->err) {
 		cell_error(pool, m->cell);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e749bc4..af20a84 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1119,7 +1119,6 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	sector_t sector_count;
-	unsigned short idx;
 };
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
@@ -1128,68 +1127,24 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
 	bio->bi_iter.bi_size = to_bytes(len);
 }
 
-static void bio_setup_bv(struct bio *bio, unsigned short idx, unsigned short bv_count)
-{
-	bio->bi_iter.bi_idx = idx;
-	bio->bi_vcnt = idx + bv_count;
-	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-}
-
-static void clone_bio_integrity(struct bio *bio, struct bio *clone,
-				unsigned short idx, unsigned len, unsigned offset,
-				unsigned trim)
-{
-	if (!bio_integrity(bio))
-		return;
-
-	bio_integrity_clone(clone, bio, GFP_NOIO);
-
-	if (trim)
-		bio_integrity_trim(clone, bio_sector_offset(bio, idx, offset), len);
-}
-
-/*
- * Creates a little bio that just does part of a bvec.
- */
-static void clone_split_bio(struct dm_target_io *tio, struct bio *bio,
-			    sector_t sector, unsigned short idx,
-			    unsigned offset, unsigned len)
-{
-	struct bio *clone = &tio->clone;
-	struct bio_vec *bv = bio->bi_io_vec + idx;
-
-	*clone->bi_io_vec = *bv;
-
-	bio_setup_sector(clone, sector, len);
-
-	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw;
-	clone->bi_vcnt = 1;
-	clone->bi_io_vec->bv_offset = offset;
-	clone->bi_io_vec->bv_len = clone->bi_iter.bi_size;
-	clone->bi_flags |= 1 << BIO_CLONED;
-
-	clone_bio_integrity(bio, clone, idx, len, offset, 1);
-}
-
 /*
  * Creates a bio that consists of range of complete bvecs.
  */
 static void clone_bio(struct dm_target_io *tio, struct bio *bio,
-		      sector_t sector, unsigned short idx,
-		      unsigned short bv_count, unsigned len)
+		      sector_t sector, unsigned len)
 {
 	struct bio *clone = &tio->clone;
-	unsigned trim = 0;
 
 	__bio_clone(clone, bio);
-	bio_setup_sector(clone, sector, len);
-	bio_setup_bv(clone, idx, bv_count);
 
-	if (idx != bio->bi_iter.bi_idx ||
-	    clone->bi_iter.bi_size < bio->bi_iter.bi_size)
-		trim = 1;
-	clone_bio_integrity(bio, clone, idx, len, 0, trim);
+	if (bio_integrity(bio))
+		bio_integrity_clone(clone, bio, GFP_NOIO);
+
+	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
+	clone->bi_iter.bi_size = to_bytes(len);
+
+	if (bio_integrity(bio))
+		bio_integrity_trim(clone, 0, len);
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
@@ -1251,10 +1206,7 @@ static int __send_empty_flush(struct clone_info *ci)
 }
 
 static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
-				     sector_t sector, int nr_iovecs,
-				     unsigned short idx, unsigned short bv_count,
-				     unsigned offset, unsigned len,
-				     unsigned split_bvec)
+				     sector_t sector, unsigned len)
 {
 	struct bio *bio = ci->bio;
 	struct dm_target_io *tio;
@@ -1268,11 +1220,8 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
 		num_target_bios = ti->num_write_bios(ti, bio);
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
-		tio = alloc_tio(ci, ti, nr_iovecs, target_bio_nr);
-		if (split_bvec)
-			clone_split_bio(tio, bio, sector, idx, offset, len);
-		else
-			clone_bio(tio, bio, sector, idx, bv_count, len);
+		tio = alloc_tio(ci, ti, bio_segments(bio), target_bio_nr);
+		clone_bio(tio, bio, sector, len);
 		__map_bio(tio);
 	}
 }
@@ -1344,68 +1293,13 @@ static int __send_write_same(struct clone_info *ci)
 }
 
 /*
- * Find maximum number of sectors / bvecs we can process with a single bio.
- */
-static sector_t __len_within_target(struct clone_info *ci, sector_t max, int *idx)
-{
-	struct bio *bio = ci->bio;
-	sector_t bv_len, total_len = 0;
-
-	for (*idx = ci->idx; max && (*idx < bio->bi_vcnt); (*idx)++) {
-		bv_len = to_sector(bio->bi_io_vec[*idx].bv_len);
-
-		if (bv_len > max)
-			break;
-
-		max -= bv_len;
-		total_len += bv_len;
-	}
-
-	return total_len;
-}
-
-static int __split_bvec_across_targets(struct clone_info *ci,
-				       struct dm_target *ti, sector_t max)
-{
-	struct bio *bio = ci->bio;
-	struct bio_vec *bv = bio->bi_io_vec + ci->idx;
-	sector_t remaining = to_sector(bv->bv_len);
-	unsigned offset = 0;
-	sector_t len;
-
-	do {
-		if (offset) {
-			ti = dm_table_find_target(ci->map, ci->sector);
-			if (!dm_target_is_valid(ti))
-				return -EIO;
-
-			max = max_io_len(ci->sector, ti);
-		}
-
-		len = min(remaining, max);
-
-		__clone_and_map_data_bio(ci, ti, ci->sector, 1, ci->idx, 0,
-					 bv->bv_offset + offset, len, 1);
-
-		ci->sector += len;
-		ci->sector_count -= len;
-		offset += to_bytes(len);
-	} while (remaining -= len);
-
-	ci->idx++;
-
-	return 0;
-}
-
-/*
  * Select the correct strategy for processing a non-flush bio.
  */
 static int __split_and_process_non_flush(struct clone_info *ci)
 {
 	struct bio *bio = ci->bio;
 	struct dm_target *ti;
-	sector_t len, max;
-	int idx;
+	unsigned len;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD))
 		return __send_discard(ci);
@@ -1416,41 +1310,14 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	max = max_io_len(ci->sector, ti);
-
-	/*
-	 * Optimise for the simple case where we can do all of
-	 * the remaining io with a single clone.
-	 */
-	if (ci->sector_count <= max) {
-		__clone_and_map_data_bio(ci, ti, ci->sector, bio->bi_max_vecs,
-					 ci->idx, bio->bi_vcnt - ci->idx, 0,
-					 ci->sector_count, 0);
-		ci->sector_count = 0;
-		return 0;
-	}
-
-	/*
-	 * There are some bvecs that don't span targets.
-	 * Do as many of these as possible.
-	 */
-	if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <= max) {
-		len = __len_within_target(ci, max, &idx);
-
-		__clone_and_map_data_bio(ci, ti, ci->sector, bio->bi_max_vecs,
-					 ci->idx, idx - ci->idx, 0, len, 0);
+	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
 
-		ci->sector += len;
-		ci->sector_count -= len;
-		ci->idx = idx;
+	__clone_and_map_data_bio(ci, ti, ci->sector, len);
 
-		return 0;
-	}
+	ci->sector += len;
+	ci->sector_count -= len;
 
-	/*
-	 * Handle a bvec that must be split between two or more targets.
-	 */
-	return __split_bvec_across_targets(ci, ti, max);
+	return 0;
 }
 
 /*
@@ -1476,7 +1343,6 @@ static void __split_and_process_bio(struct mapped_device *md,
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_iter.bi_sector;
-	ci.idx = bio->bi_iter.bi_idx;
 
 	start_io_acct(ci.io);
 
diff --git a/fs/bio.c b/fs/bio.c
index ff5195d..54f44a1 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1827,44 +1827,6 @@ void bio_trim(struct bio *bio, int offset, int size)
 }
 EXPORT_SYMBOL_GPL(bio_trim);
 
-/**
- *      bio_sector_offset - Find hardware sector offset in bio
- *      @bio:           bio to inspect
- *      @index:         bio_vec index
- *      @offset:        offset in bv_page
- *
- *      Return the number of hardware sectors between beginning of bio
- *      and an end point indicated by a bio_vec index and an offset
- *      within that vector's page.
- */
-sector_t bio_sector_offset(struct bio *bio, unsigned short index,
-			   unsigned int offset)
-{
-	unsigned int sector_sz;
-	struct bio_vec *bv;
-	sector_t sectors;
-	int i;
-
-	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
-	sectors = 0;
-
-	if (index >= bio->bi_iter.bi_idx)
-		index = bio->bi_vcnt - 1;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		if (i == index) {
-			if (offset > bv->bv_offset)
-				sectors += (offset - bv->bv_offset) / sector_sz;
-			break;
-		}
-
-		sectors += bv->bv_len / sector_sz;
-	}
-
-	return sectors;
-}
-EXPORT_SYMBOL(bio_sector_offset);
-
 /*
  * create memory pools for biovec's in a bio_set.
  * use the global biovec slabs created for general use.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e1f6eda..6aaeeb1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -368,7 +368,6 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.8.4.rc3

