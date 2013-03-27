Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3C0Rmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:42:47 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:53591 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3C0Rkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:53 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 17/22] dm: Refactor for new bio cloning/splitting
Date: Wed, 27 Mar 2013 10:39:47 -0700
Message-Id: <1364405992-28424-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to convert the dm code to the new bvec_iter primitives which
respect bi_bvec_done; they also allow us to drastically simplify dm's
bio splitting code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm.c | 170 ++++++--------------------------------------------------
 1 file changed, 18 insertions(+), 152 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 01a2451..d7ec2e6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1014,7 +1014,6 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	sector_t sector_count;
-	unsigned short idx;
 };
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
@@ -1023,68 +1022,24 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
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
@@ -1146,10 +1101,7 @@ static int __send_empty_flush(struct clone_info *ci)
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
@@ -1163,11 +1115,8 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
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
@@ -1239,68 +1188,13 @@ static int __send_write_same(struct clone_info *ci)
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
@@ -1311,41 +1205,14 @@ static int __split_and_process_non_flush(struct clone_info *ci)
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
@@ -1370,7 +1237,6 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_iter.bi_sector;
-	ci.idx = bio->bi_iter.bi_idx;
 
 	start_io_acct(ci.io);
 
-- 
1.8.1.3

