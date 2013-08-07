Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab3HGV6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:58:11 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64844 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab3HGVz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:26 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Date: Wed,  7 Aug 2013 14:54:25 -0700
Message-Id: <1375912471-5106-17-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
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
 drivers/md/dm.c     | 170 ++++++----------------------------------------------
 fs/bio.c            |  38 ------------
 include/linux/bio.h |   1 -
 3 files changed, 18 insertions(+), 191 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5544af7..696269d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1050,7 +1050,6 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	sector_t sector_count;
-	unsigned short idx;
 };
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
@@ -1059,68 +1058,24 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
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
+	bio_advance(clone, (sector - clone->bi_iter.bi_sector) << 9);
+	bio->bi_iter.bi_size = len << 9;
+
+	if (bio_integrity(bio))
+		bio_integrity_trim(clone, 0, len);
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
@@ -1182,10 +1137,7 @@ static int __send_empty_flush(struct clone_info *ci)
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
@@ -1199,11 +1151,8 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
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
@@ -1275,68 +1224,13 @@ static int __send_write_same(struct clone_info *ci)
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
@@ -1347,41 +1241,14 @@ static int __split_and_process_non_flush(struct clone_info *ci)
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
+	len = min_t(unsigned, max_io_len(ci->sector, ti), bio_sectors(bio));
 
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
@@ -1407,7 +1274,6 @@ static void __split_and_process_bio(struct mapped_device *md,
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_iter.bi_sector;
-	ci.idx = bio->bi_iter.bi_idx;
 
 	start_io_acct(ci.io);
 
diff --git a/fs/bio.c b/fs/bio.c
index 46cf8a6..bb62198 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1809,44 +1809,6 @@ void bio_trim(struct bio *bio, int offset, int size)
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
index 486a997..e9a4fce 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -349,7 +349,6 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.8.4.rc1

