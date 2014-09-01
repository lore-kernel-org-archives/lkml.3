Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaIALIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbaIALII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:08:08 -0400
From: Maurizio Lombardi <mlombard@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jet.chen@intel.com,
        akpm@linux-foundation.org, thenzl@redhat.com
Subject: [PATCH V4] bio: modify __bio_add_page() to accept pages that don't start a new segment
Date: Mon,  1 Sep 2014 13:08:00 +0200
Message-Id: <1409569680-15139-1-git-send-email-mlombard@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original behaviour is to refuse to add a new page if the maximum
number of segments has been reached, regardless of the fact the page we
are going to add can be merged into the last segment or not.

Unfortunately, when the system runs under heavy memory fragmentation
conditions, a driver may try to add multiple pages to the last segment.
The original code won't accept them and EBUSY will be reported to
userspace.

This patch modifies the function so it refuses to add a page only in case
the latter starts a new segment and the maximum number of segments has
already been reached.

The bug can be easily reproduced with the st driver:

1) set CONFIG_SCSI_MPT2SAS_MAX_SGE or CONFIG_SCSI_MPT3SAS_MAX_SGE  to 16
2) modprobe st buffer_kbs=1024
3) #dd if=/dev/zero of=/dev/st0 bs=1M count=10
   dd: error writing `/dev/st0': Device or resource busy

V2: restore the correct number of segments in case of failure.

V3: In case of error, V2 restored the previous number of segments but left
    the BIO_SEG_VALID flag set.
    To avoid problems, after the page is removed from the bio vec,
    V3 performs a recount of the segments in the error code path.

[ming.lei@canonical.com: update bi_iter.bi_size before recounting segments]

V4: merge_bvec_fn() must be called with the old bi_iter.bi_size value.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/bio.c | 54 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3e6331d..535b16d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -745,6 +745,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 				}
 			}
 
+			bio->bi_iter.bi_size += len;
 			goto done;
 		}
 
@@ -761,29 +762,32 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		return 0;
 
 	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
+	 * setup the new entry, we might clear it again later if we
+	 * cannot add the page
+	 */
+	bvec = &bio->bi_io_vec[bio->bi_vcnt];
+	bvec->bv_page = page;
+	bvec->bv_len = len;
+	bvec->bv_offset = offset;
+	bio->bi_vcnt++;
+	bio->bi_phys_segments++;
+	bio->bi_iter.bi_size += len;
+
+	/*
+	 * Perform a recount if the number of segments is greater
+	 * than queue_max_segments(q).
 	 */
 
-	while (bio->bi_phys_segments >= queue_max_segments(q)) {
+	while (bio->bi_phys_segments > queue_max_segments(q)) {
 
 		if (retried_segments)
-			return 0;
+			goto failed;
 
 		retried_segments = 1;
 		blk_recount_segments(q, bio);
 	}
 
 	/*
-	 * setup the new entry, we might clear it again later if we
-	 * cannot add the page
-	 */
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
-
-	/*
 	 * if queue has other restrictions (eg varying max sector size
 	 * depending on offset), it can specify a merge_bvec_fn in the
 	 * queue to get further control
@@ -792,7 +796,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		struct bvec_merge_data bvm = {
 			.bi_bdev = bio->bi_bdev,
 			.bi_sector = bio->bi_iter.bi_sector,
-			.bi_size = bio->bi_iter.bi_size,
+			.bi_size = bio->bi_iter.bi_size - len,
 			.bi_rw = bio->bi_rw,
 		};
 
@@ -800,23 +804,25 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		 * merge_bvec_fn() returns number of bytes it can accept
 		 * at this offset
 		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
+		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len)
+			goto failed;
 	}
 
 	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
+	if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-	bio->bi_vcnt++;
-	bio->bi_phys_segments++;
  done:
-	bio->bi_iter.bi_size += len;
 	return len;
+
+ failed:
+	bvec->bv_page = NULL;
+	bvec->bv_len = 0;
+	bvec->bv_offset = 0;
+	bio->bi_vcnt--;
+	bio->bi_iter.bi_size -= len;
+	blk_recount_segments(q, bio);
+	return 0;
 }
 
 /**
-- 
Maurizio Lombardi

