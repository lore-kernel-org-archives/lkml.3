Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab3HGWAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:00:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36138 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679Ab3HGVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:18 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 11/22] block: Kill bio_segments()/bi_vcnt usage
Date: Wed,  7 Aug 2013 14:54:20 -0700
Message-Id: <1375912471-5106-12-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we start sharing biovecs, keeping bi_vcnt accurate for splits is
going to be error prone - and unnecessary, if we refactor some code.

So bio_segments() has to go - but most of the existing users just needed
to know if the bio had multiple segments, which is easier - add a
bio_multiple_segments() for them.

(Two of the current uses of bio_segments() are going to go away in a
couple patches, but the current implementation of bio_segments() is
unsafe as soon as we start doing driver conversions for immutable
biovecs - so implement a dumb version for bisectability, it'll go away
in a couple patches)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/block/ps3disk.c                  |  7 ++---
 drivers/md/bcache/io.c                   | 53 ++++++++++++++------------------
 drivers/md/raid0.c                       |  2 +-
 drivers/md/raid10.c                      |  2 +-
 drivers/message/fusion/mptsas.c          |  8 ++---
 drivers/scsi/libsas/sas_expander.c       |  8 ++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 10 +++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++---
 fs/bio.c                                 |  2 +-
 include/linux/bio.h                      | 43 +++++++++++++++++---------
 10 files changed, 75 insertions(+), 68 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 464be78..8d1a19c 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -101,10 +101,9 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 
 	rq_for_each_segment(bvec, req, iter) {
 		unsigned long flags;
-		dev_dbg(&dev->sbd.core,
-			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
-			__func__, __LINE__, i, bio_segments(iter.bio),
-			bio_sectors(iter.bio), iter.bio->bi_iter.bi_sector);
+		dev_dbg(&dev->sbd.core, "%s:%u: bio %u: %u sectors from %lu\n",
+			__func__, __LINE__, i, bio_sectors(iter.bio),
+			iter.bio->bi_iter.bi_sector);
 
 		size = bvec->bv_len;
 		buf = bvec_kmap_irq(bvec, &flags);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 9b5b6a4..6e04f3b 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -24,7 +24,8 @@ static void bch_generic_make_request_hack(struct bio *bio)
 	if (bio->bi_iter.bi_idx) {
 		struct bio_vec bv;
 		struct bvec_iter iter;
-		struct bio *clone = bio_alloc(GFP_NOIO, bio_segments(bio));
+		unsigned segs = bio_segments(bio);
+		struct bio *clone = bio_alloc(GFP_NOIO, segs);
 
 		bio_for_each_segment(bv, bio, iter)
 			clone->bi_io_vec[clone->bi_vcnt++] = bv;
@@ -32,7 +33,7 @@ static void bch_generic_make_request_hack(struct bio *bio)
 		clone->bi_iter.bi_sector = bio->bi_iter.bi_sector;
 		clone->bi_bdev		= bio->bi_bdev;
 		clone->bi_rw		= bio->bi_rw;
-		clone->bi_vcnt		= bio_segments(bio);
+		clone->bi_vcnt		= segs;
 		clone->bi_iter.bi_size	= bio->bi_iter.bi_size;
 
 		clone->bi_private	= bio;
@@ -133,40 +134,32 @@ out:
 
 static unsigned bch_bio_max_sectors(struct bio *bio)
 {
-	unsigned ret = bio_sectors(bio);
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	unsigned max_segments = min_t(unsigned, BIO_MAX_PAGES,
-				      queue_max_segments(q));
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	unsigned ret = 0, seg = 0;
 
 	if (bio->bi_rw & REQ_DISCARD)
-		return min(ret, q->limits.max_discard_sectors);
-
-	if (bio_segments(bio) > max_segments ||
-	    q->merge_bvec_fn) {
-		struct bio_vec bv;
-		struct bvec_iter iter;
-		unsigned seg = 0;
-
-		ret = 0;
+		return min(bio_sectors(bio), q->limits.max_discard_sectors);
 
-		bio_for_each_segment(bv, bio, iter) {
-			struct bvec_merge_data bvm = {
-				.bi_bdev	= bio->bi_bdev,
-				.bi_sector	= bio->bi_iter.bi_sector,
-				.bi_size	= ret << 9,
-				.bi_rw		= bio->bi_rw,
-			};
-
-			if (seg == max_segments)
-				break;
+	bio_for_each_segment(bv, bio, iter) {
+		struct bvec_merge_data bvm = {
+			.bi_bdev	= bio->bi_bdev,
+			.bi_sector	= bio->bi_iter.bi_sector,
+			.bi_size	= ret << 9,
+			.bi_rw		= bio->bi_rw,
+		};
+
+		if (seg == min_t(unsigned, BIO_MAX_PAGES,
+				 queue_max_segments(q)))
+			break;
 
-			if (q->merge_bvec_fn &&
-			    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
-				break;
+		if (q->merge_bvec_fn &&
+		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
+			break;
 
-			seg++;
-			ret += bv.bv_len >> 9;
-		}
+		seg++;
+		ret += bv.bv_len >> 9;
 	}
 
 	ret = min(ret, queue_max_sectors(q));
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e38d1d3..8ee1a6c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -528,7 +528,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		sector_t sector = bio->bi_iter.bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio_segments(bio) > 1)
+		if (bio_multiple_segments(bio))
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fca8887..2303f59 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1188,7 +1188,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio_segments(bio) > 1)
+		if (bio_multiple_segments(bio))
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dd239bd..00d339c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2235,10 +2235,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
-		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __func__, bio_segments(req->bio), blk_rq_bytes(req),
-		    bio_segments(rsp->bio), blk_rq_bytes(rsp));
+	if (bio_multiple_segments(req->bio) ||
+	    bio_multiple_segments(rsp->bio)) {
+		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u, rsp %u\n",
+		    ioc->name, __func__, blk_rq_bytes(req), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 446b851..0cac7d8 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2163,10 +2163,10 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
-		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __func__, bio_segments(req->bio), blk_rq_bytes(req),
-		       bio_segments(rsp->bio), blk_rq_bytes(rsp));
+	if (bio_multiple_segments(req->bio) ||
+	    bio_multiple_segments(rsp->bio)) {
+		printk("%s: multiple segments req %u, rsp %u\n",
+		       __func__, blk_rq_bytes(req), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 2c2e01e..d2224b5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1940,7 +1940,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	ioc->transport_cmds.status = MPT2_CMD_PENDING;
 
 	/* Check if the request is split across multiple segments */
-	if (bio_segments(req->bio) > 1) {
+	if (bio_multiple_segments(req->bio)) {
 		u32 offset = 0;
 
 		/* Allocate memory and copy the request */
@@ -1972,7 +1972,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	/* Check if the response needs to be populated across
 	 * multiple segments */
-	if (bio_segments(rsp->bio) > 1) {
+	if (bio_multiple_segments(rsp->bio)) {
 		pci_addr_in = pci_alloc_consistent(ioc->pdev, blk_rq_bytes(rsp),
 		    &pci_dma_in);
 		if (!pci_addr_in) {
@@ -2039,7 +2039,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (bio_segments(req->bio) > 1) {
+	if (bio_multiple_segments(req->bio)) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(req) - 4), pci_dma_out);
 	} else {
@@ -2055,7 +2055,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
 	    MPI2_SGE_FLAGS_END_OF_LIST);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (bio_segments(rsp->bio) > 1) {
+	if (bio_multiple_segments(rsp->bio)) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(rsp) + 4), pci_dma_in);
 	} else {
@@ -2100,7 +2100,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
 		/* check if the resp needs to be copied from the allocated
 		 * pci mem */
-		if (bio_segments(rsp->bio) > 1) {
+		if (bio_multiple_segments(rsp->bio)) {
 			u32 offset = 0;
 			u32 bytes_to_copy =
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index f279f46..55aa597 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1923,7 +1923,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	ioc->transport_cmds.status = MPT3_CMD_PENDING;
 
 	/* Check if the request is split across multiple segments */
-	if (req->bio->bi_vcnt > 1) {
+	if (bio_multiple_segments(req->bio)) {
 		u32 offset = 0;
 
 		/* Allocate memory and copy the request */
@@ -1955,7 +1955,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	/* Check if the response needs to be populated across
 	 * multiple segments */
-	if (rsp->bio->bi_vcnt > 1) {
+	if (bio_multiple_segments(rsp->bio)) {
 		pci_addr_in = pci_alloc_consistent(ioc->pdev, blk_rq_bytes(rsp),
 		    &pci_dma_in);
 		if (!pci_addr_in) {
@@ -2016,7 +2016,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	mpi_request->RequestDataLength = cpu_to_le16(blk_rq_bytes(req) - 4);
 	psge = &mpi_request->SGL;
 
-	if (req->bio->bi_vcnt > 1)
+	if (bio_multiple_segments(req->bio))
 		ioc->build_sg(ioc, psge, pci_dma_out, (blk_rq_bytes(req) - 4),
 		    pci_dma_in, (blk_rq_bytes(rsp) + 4));
 	else
@@ -2061,7 +2061,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		/* check if the resp needs to be copied from the allocated
 		 * pci mem */
-		if (rsp->bio->bi_vcnt > 1) {
+		if (bio_multiple_segments(rsp->bio)) {
 			u32 offset = 0;
 			u32 bytes_to_copy =
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
diff --git a/fs/bio.c b/fs/bio.c
index eab8487..46cf8a6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1723,7 +1723,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_iter.bi_sector + first_sectors);
 
-	BUG_ON(bio_segments(bi) > 1);
+	BUG_ON(bio_multiple_segments(bi));
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
 	bp->bio1 = *bi;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 57a6f40..9736683 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -97,13 +97,27 @@
 #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
 #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
-#define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
+#define bio_multiple_segments(bio)				\
+	((bio)->bi_iter.bi_size != bio_iovec(bio).bv_len)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
 
+/*
+ * Check whether this bio carries any data or not. A NULL bio is allowed.
+ */
+static inline bool bio_has_data(struct bio *bio)
+{
+	if (bio &&
+	    bio->bi_iter.bi_size &&
+	    !(bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK))
+		return true;
+
+	return false;
+}
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-	if (bio->bi_vcnt)
+	if (bio_has_data(bio))
 		return bio_iovec(bio).bv_len;
 	else /* dataless requests such as discard */
 		return bio->bi_iter.bi_size;
@@ -111,7 +125,7 @@ static inline unsigned int bio_cur_bytes(struct bio *bio)
 
 static inline void *bio_data(struct bio *bio)
 {
-	if (bio->bi_vcnt)
+	if (bio_has_data(bio))
 		return page_address(bio_page(bio)) + bio_offset(bio);
 
 	return NULL;
@@ -221,6 +235,18 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
+static inline unsigned bio_segments(struct bio *bio)
+{
+	unsigned segs = 0;
+	struct bio_vec bv;
+	struct bvec_iter iter;
+
+	bio_for_each_segment(bv, bio, iter)
+		segs++;
+
+	return segs;
+}
+
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:
@@ -434,17 +460,6 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 	__bio_kmap_irq((bio), (bio)->bi_iter.bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
-/*
- * Check whether this bio carries any data or not. A NULL bio is allowed.
- */
-static inline bool bio_has_data(struct bio *bio)
-{
-	if (bio && bio->bi_vcnt)
-		return true;
-
-	return false;
-}
-
 static inline bool bio_is_rw(struct bio *bio)
 {
 	if (!bio_has_data(bio))
-- 
1.8.4.rc1

