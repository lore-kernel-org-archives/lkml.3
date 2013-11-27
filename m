Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3K0Aqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:46:33 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33823 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3K0AqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:14 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 19/25] dm: Refactor for new bio cloning/splitting
Date: Tue, 26 Nov 2013 16:45:22 -0800
Message-Id: <1385513128-5035-19-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to convert the dm code to the new bvec_iter primitives which
respect bi_bvec_done; they also allow us to drastically simplify dm's
bio splitting code.

Also, it's no longer necessary to save/restore the bvec array anymore -
driver conversions for immutable bvecs are done, so drivers should never
be modifying it.

Also kill bio_sector_offset(), dm was the only user and it doesn't make
much sense anymore.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-record.h |  25 -------
 drivers/md/dm.c            | 174 ++++++---------------------------------------
 fs/bio.c                   |  72 -------------------
 include/linux/bio.h        |   2 -
 4 files changed, 20 insertions(+), 253 deletions(-)

diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 4f46e8e..dd36461 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -17,49 +17,24 @@
  * original bio state.
  */
 
-struct dm_bio_vec_details {
-#if PAGE_SIZE < 65536
-	__u16 bv_len;
-	__u16 bv_offset;
-#else
-	unsigned bv_len;
-	unsigned bv_offset;
-#endif
-};
-
 struct dm_bio_details {
 	struct block_device *bi_bdev;
 	unsigned long bi_flags;
 	struct bvec_iter bi_iter;
-	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_flags = bio->bi_flags;
 	bd->bi_iter = bio->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
-		bd->bi_io_vec[i].bv_offset = bio->bi_io_vec[i].bv_offset;
-	}
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_flags = bd->bi_flags;
 	bio->bi_iter = bd->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
-		bio->bi_io_vec[i].bv_offset = bd->bi_io_vec[i].bv_offset;
-	}
 }
 
 #endif
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ccd064e..44a2fa6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1155,7 +1155,6 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	sector_t sector_count;
-	unsigned short idx;
 };
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
@@ -1164,68 +1163,24 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
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
 
-	__bio_clone(clone, bio);
-	bio_setup_sector(clone, sector, len);
-	bio_setup_bv(clone, idx, bv_count);
+	__bio_clone_fast(clone, bio);
+
+	if (bio_integrity(bio))
+		bio_integrity_clone(clone, bio, GFP_NOIO);
+
+	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
+	clone->bi_iter.bi_size = to_bytes(len);
 
-	if (idx != bio->bi_iter.bi_idx ||
-	    clone->bi_iter.bi_size < bio->bi_iter.bi_size)
-		trim = 1;
-	clone_bio_integrity(bio, clone, idx, len, 0, trim);
+	if (bio_integrity(bio))
+		bio_integrity_trim(clone, 0, len);
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
@@ -1258,7 +1213,7 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-	 __bio_clone(clone, ci->bio);
+	 __bio_clone_fast(clone, ci->bio);
 	if (len)
 		bio_setup_sector(clone, ci->sector, len);
 
@@ -1287,10 +1242,7 @@ static int __send_empty_flush(struct clone_info *ci)
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
@@ -1304,11 +1256,8 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
 		num_target_bios = ti->num_write_bios(ti, bio);
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
-		tio = alloc_tio(ci, ti, nr_iovecs, target_bio_nr);
-		if (split_bvec)
-			clone_split_bio(tio, bio, sector, idx, offset, len);
-		else
-			clone_bio(tio, bio, sector, idx, bv_count, len);
+		tio = alloc_tio(ci, ti, 0, target_bio_nr);
+		clone_bio(tio, bio, sector, len);
 		__map_bio(tio);
 	}
 }
@@ -1380,68 +1329,13 @@ static int __send_write_same(struct clone_info *ci)
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
@@ -1452,41 +1346,14 @@ static int __split_and_process_non_flush(struct clone_info *ci)
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
@@ -1512,7 +1379,6 @@ static void __split_and_process_bio(struct mapped_device *md,
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_iter.bi_sector;
-	ci.idx = bio->bi_iter.bi_idx;
 
 	start_io_acct(ci.io);
 
diff --git a/fs/bio.c b/fs/bio.c
index 00dc189..6e42b68 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -515,40 +515,6 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 EXPORT_SYMBOL(bio_phys_segments);
 
 /**
- * 	__bio_clone	-	clone a bio
- * 	@bio: destination bio
- * 	@bio_src: bio to clone
- *
- *	Clone a &bio. Caller will own the returned bio, but not
- *	the actual data it points to. Reference count of returned
- * 	bio will be one.
- */
-void __bio_clone(struct bio *bio, struct bio *bio_src)
-{
-	if (bio_is_rw(bio_src)) {
-		struct bio_vec bv;
-		struct bvec_iter iter;
-
-		bio_for_each_segment(bv, bio_src, iter)
-			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-	} else if (bio_has_data(bio_src)) {
-		memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		       bio_src->bi_max_vecs * sizeof(struct bio_vec));
-		bio->bi_vcnt = bio_src->bi_vcnt;
-	}
-
-	/*
-	 * most users will be overriding ->bi_bdev with a new target,
-	 * so we don't set nor calculate new physical/hw segment counts here
-	 */
-	bio->bi_bdev = bio_src->bi_bdev;
-	bio->bi_flags |= 1 << BIO_CLONED;
-	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_iter = bio_src->bi_iter;
-}
-EXPORT_SYMBOL(__bio_clone);
-
-/**
  * 	__bio_clone_fast - clone a bio that shares the original bio's biovec
  * 	@bio: destination bio
  * 	@bio_src: bio to clone
@@ -1921,44 +1887,6 @@ void bio_trim(struct bio *bio, int offset, int size)
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
index 1f83f4a..0c32a45 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -330,7 +330,6 @@ extern void bio_put(struct bio *);
 
 extern void __bio_clone_fast(struct bio *, struct bio *);
 extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
-extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 
 extern struct bio_set *fs_bio_set;
@@ -370,7 +369,6 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.8.4.4

