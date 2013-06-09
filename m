Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3FICWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:22:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55585 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3FICUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:20:04 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 19/26] block: Kill bio_segments()
Date: Sat,  8 Jun 2013 19:19:01 -0700
Message-Id: <1370744348-15407-20-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we start sharing biovecs, keeping bi_vcnt accurate for splits is
going to be error prone - and unnecessary, if we refactor some code.

So bio_segments() has to go - but most of the existing users just needed
to know if the bio had multiple segments, which is easier - add a
bio_multiple_segments() for them.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/block/ps3disk.c                  |  7 ++---
 drivers/md/bcache/io.c                   | 54 ++++++++++++++------------------
 drivers/message/fusion/mptsas.c          |  8 ++---
 drivers/scsi/libsas/sas_expander.c       |  8 ++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 10 +++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++---
 include/linux/bio.h                      |  3 +-
 7 files changed, 45 insertions(+), 53 deletions(-)

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
index 4224cfd..e3c582d 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -11,40 +11,32 @@
 
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
-
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
-
-			if (q->merge_bvec_fn &&
-			    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
-				break;
-
-			seg++;
-			ret += bv.bv_len >> 9;
-		}
+		return min(bio_sectors(bio), q->limits.max_discard_sectors);
+
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
+
+		if (q->merge_bvec_fn &&
+		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
+			break;
+
+		seg++;
+		ret += bv.bv_len >> 9;
 	}
 
 	ret = min(ret, queue_max_sectors(q));
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
index dd15b2d..3898f51 100644
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
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6767622..aa015ee 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -90,7 +90,8 @@
 #define bio_offset(bio)		bio_offset_iter((bio), (bio)->bi_iter)
 #define bio_iovec(bio)		bio_iovec_iter((bio), (bio)->bi_iter)
 
-#define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
+#define bio_multiple_segments(bio)				\
+	((bio)->bi_iter.bi_size != bio_iovec(bio).bv_len)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
 
-- 
1.8.3.rc1

