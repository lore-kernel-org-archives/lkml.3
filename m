Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3J2UYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:24:37 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50626 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3J2US0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:26 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 02/23] block: Consolidate duplicated bio_trim() implementations
Date: Tue, 29 Oct 2013 13:17:55 -0700
Message-Id: <1383077896-4132-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone cut and pasted md's md_trim_bio() into xen-blkfront.c. Come on,
we should know better than this.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/block/xen-blkfront.c | 53 +-------------------------------------------
 drivers/md/md.c              | 40 ---------------------------------
 drivers/md/md.h              |  1 -
 drivers/md/raid1.c           | 10 ++++-----
 drivers/md/raid10.c          | 18 +++++++--------
 fs/bio.c                     | 46 ++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h          |  1 +
 7 files changed, 61 insertions(+), 108 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a4660bb..8d53ed2 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1336,57 +1336,6 @@ static int blkfront_probe(struct xenbus_device *dev,
 	return 0;
 }
 
-/*
- * This is a clone of md_trim_bio, used to split a bio into smaller ones
- */
-static void trim_bio(struct bio *bio, int offset, int size)
-{
-	/* 'bio' is a cloned bio which we need to trim to match
-	 * the given offset and size.
-	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
-	 */
-	int i;
-	struct bio_vec *bvec;
-	int sofar = 0;
-
-	size <<= 9;
-	if (offset == 0 && size == bio->bi_size)
-		return;
-
-	bio->bi_sector += offset;
-	bio->bi_size = size;
-	offset <<= 9;
-	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
-
-	while (bio->bi_idx < bio->bi_vcnt &&
-	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
-		/* remove this whole bio_vec */
-		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
-		bio->bi_idx++;
-	}
-	if (bio->bi_idx < bio->bi_vcnt) {
-		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
-		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
-	}
-	/* avoid any complications with bi_idx being non-zero*/
-	if (bio->bi_idx) {
-		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
-		bio->bi_vcnt -= bio->bi_idx;
-		bio->bi_idx = 0;
-	}
-	/* Make sure vcnt and last bv are not too big */
-	bio_for_each_segment(bvec, bio, i) {
-		if (sofar + bvec->bv_len > size)
-			bvec->bv_len = size - sofar;
-		if (bvec->bv_len == 0) {
-			bio->bi_vcnt = i;
-			break;
-		}
-		sofar += bvec->bv_len;
-	}
-}
-
 static void split_bio_end(struct bio *bio, int error)
 {
 	struct split_bio *split_bio = bio->bi_private;
@@ -1522,7 +1471,7 @@ static int blkif_recover(struct blkfront_info *info)
 					   (unsigned int)(bio->bi_size >> 9) - offset);
 				cloned_bio = bio_clone(bio, GFP_NOIO);
 				BUG_ON(cloned_bio == NULL);
-				trim_bio(cloned_bio, offset, size);
+				bio_trim(cloned_bio, offset, size);
 				cloned_bio->bi_private = split_bio;
 				cloned_bio->bi_end_io = split_bio_end;
 				submit_bio(cloned_bio->bi_rw, cloned_bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf4d7e..251dca6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -183,46 +183,6 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
-void md_trim_bio(struct bio *bio, int offset, int size)
-{
-	/* 'bio' is a cloned bio which we need to trim to match
-	 * the given offset and size.
-	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
-	 */
-	int i;
-	struct bio_vec *bvec;
-	int sofar = 0;
-
-	size <<= 9;
-	if (offset == 0 && size == bio->bi_size)
-		return;
-
-	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
-
-	bio_advance(bio, offset << 9);
-
-	bio->bi_size = size;
-
-	/* avoid any complications with bi_idx being non-zero*/
-	if (bio->bi_idx) {
-		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
-		bio->bi_vcnt -= bio->bi_idx;
-		bio->bi_idx = 0;
-	}
-	/* Make sure vcnt and last bv are not too big */
-	bio_for_each_segment(bvec, bio, i) {
-		if (sofar + bvec->bv_len > size)
-			bvec->bv_len = size - sofar;
-		if (bvec->bv_len == 0) {
-			bio->bi_vcnt = i;
-			break;
-		}
-		sofar += bvec->bv_len;
-	}
-}
-EXPORT_SYMBOL_GPL(md_trim_bio);
-
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 608050c..c96456c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -617,7 +617,6 @@ extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 				   struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
-extern void md_trim_bio(struct bio *bio, int offset, int size);
 
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 static inline int mddev_check_plugged(struct mddev *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d60412c..fc817ff 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1097,8 +1097,8 @@ read_again:
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(read_bio, r1_bio->sector - bio->bi_sector,
-			    max_sectors);
+		bio_trim(read_bio, r1_bio->sector - bio->bi_sector,
+			 max_sectors);
 
 		r1_bio->bios[rdisk] = read_bio;
 
@@ -1266,7 +1266,7 @@ read_again:
 			continue;
 
 		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r1_bio->sector - bio->bi_sector, max_sectors);
+		bio_trim(mbio, r1_bio->sector - bio->bi_sector, max_sectors);
 
 		if (first_clone) {
 			/* do behind I/O ?
@@ -2125,7 +2125,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		wbio->bi_sector = r1_bio->sector;
 		wbio->bi_size = r1_bio->sectors << 9;
 
-		md_trim_bio(wbio, sector - r1_bio->sector, sectors);
+		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
 		if (submit_bio_wait(WRITE, wbio) == 0)
@@ -2240,7 +2240,7 @@ read_more:
 		}
 		r1_bio->read_disk = disk;
 		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
-		md_trim_bio(bio, r1_bio->sector - bio->bi_sector, max_sectors);
+		bio_trim(bio, r1_bio->sector - bio->bi_sector, max_sectors);
 		r1_bio->bios[r1_bio->read_disk] = bio;
 		rdev = conf->mirrors[disk].rdev;
 		printk_ratelimited(KERN_ERR
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df7b0a0..a582235 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1302,8 +1302,8 @@ read_again:
 		slot = r10_bio->read_slot;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(read_bio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
+		bio_trim(read_bio, r10_bio->sector - bio->bi_sector,
+			 max_sectors);
 
 		r10_bio->devs[slot].bio = read_bio;
 		r10_bio->devs[slot].rdev = rdev;
@@ -1510,8 +1510,8 @@ retry_write:
 		if (r10_bio->devs[i].bio) {
 			struct md_rdev *rdev = conf->mirrors[d].rdev;
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-				    max_sectors);
+			bio_trim(mbio, r10_bio->sector - bio->bi_sector,
+				 max_sectors);
 			r10_bio->devs[i].bio = mbio;
 
 			mbio->bi_sector	= (r10_bio->devs[i].addr+
@@ -1553,8 +1553,8 @@ retry_write:
 				rdev = conf->mirrors[d].rdev;
 			}
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-				    max_sectors);
+			bio_trim(mbio, r10_bio->sector - bio->bi_sector,
+				 max_sectors);
 			r10_bio->devs[i].repl_bio = mbio;
 
 			mbio->bi_sector	= (r10_bio->devs[i].addr +
@@ -2613,7 +2613,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
 		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(wbio, sector - bio->bi_sector, sectors);
+		bio_trim(wbio, sector - bio->bi_sector, sectors);
 		wbio->bi_sector = (r10_bio->devs[i].addr+
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
@@ -2686,9 +2686,7 @@ read_more:
 		(unsigned long long)r10_bio->sector);
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
-	md_trim_bio(bio,
-		    r10_bio->sector - bio->bi_sector,
-		    max_sectors);
+	bio_trim(bio, r10_bio->sector - bio->bi_sector, max_sectors);
 	r10_bio->devs[slot].bio = bio;
 	r10_bio->devs[slot].rdev = rdev;
 	bio->bi_sector = r10_bio->devs[slot].addr
diff --git a/fs/bio.c b/fs/bio.c
index ea5035d..2bdb4e2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1805,6 +1805,52 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 EXPORT_SYMBOL(bio_split);
 
 /**
+ * bio_trim - trim a bio
+ * @bio:	bio to trim
+ * @offset:	number of sectors to trim from the front of @bio
+ * @size:	size we want to trim @bio to, in sectors
+ */
+void bio_trim(struct bio *bio, int offset, int size)
+{
+	/* 'bio' is a cloned bio which we need to trim to match
+	 * the given offset and size.
+	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
+	 */
+	int i;
+	struct bio_vec *bvec;
+	int sofar = 0;
+
+	size <<= 9;
+	if (offset == 0 && size == bio->bi_size)
+		return;
+
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
+	bio_advance(bio, offset << 9);
+
+	bio->bi_size = size;
+
+	/* avoid any complications with bi_idx being non-zero*/
+	if (bio->bi_idx) {
+		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
+			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
+		bio->bi_vcnt -= bio->bi_idx;
+		bio->bi_idx = 0;
+	}
+	/* Make sure vcnt and last bv are not too big */
+	bio_for_each_segment(bvec, bio, i) {
+		if (sofar + bvec->bv_len > size)
+			bvec->bv_len = size - sofar;
+		if (bvec->bv_len == 0) {
+			bio->bi_vcnt = i;
+			break;
+		}
+		sofar += bvec->bv_len;
+	}
+}
+EXPORT_SYMBOL_GPL(bio_trim);
+
+/**
  *      bio_sector_offset - Find hardware sector offset in bio
  *      @bio:           bio to inspect
  *      @index:         bio_vec index
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec48bac..162036a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -218,6 +218,7 @@ struct bio_pair {
 };
 extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
+extern void bio_trim(struct bio *bio, int offset, int size);
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
-- 
1.8.4.rc3

