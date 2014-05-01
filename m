Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaEAN5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaEAN5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:57:08 -0400
From: Maurizio Lombardi <mlombard@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        JBottomley@parallels.com, hch@lst.de, linux-scsi@vger.kernel.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org,
        m.lombardi85@gmail.com
Subject: [PATCH V3] bio: modify __bio_add_page() to accept pages that don't start a new segment
Date: Thu,  1 May 2014 15:56:55 +0200
Message-Id: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original behaviour is to refuse to add a new page if the maximum number
of segments has been reached, regardless of the fact the page we are
going to add can be merged into the last segment or not.

Unfortunately, when the system runs under heavy memory fragmentation conditions,
a driver may try to add multiple pages to the last segment.
The original code won't accept them and EBUSY will be reported to
userspace.

This patch modifies the function so it refuses to add a page
only in case the latter starts a new segment and the maximum number
of segments has already been reached.

The bug can be easily reproduced with the st driver:

1) set CONFIG_SCSI_MPT2SAS_MAX_SGE or CONFIG_SCSI_MPT3SAS_MAX_SGE  to 16
2) modprobe st buffer_kbs=1024
3) #dd if=/dev/zero of=/dev/st0 bs=1M count=10
   dd: error writing ‘/dev/st0’: Device or resource busy

Changes in V3:

In case of error, V2 restored the previous number of segments but left
the BIO_SEG_FLAG set.
To avoid problems, after the page is removed from the bio vec,
V3 performs a recount of the segments in the error code path.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 fs/bio.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 6f0362b..9bf512e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -750,29 +750,31 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
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
@@ -789,23 +791,25 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
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
 	bio->bi_iter.bi_size += len;
 	return len;
+
+ failed:
+	bvec->bv_page = NULL;
+	bvec->bv_len = 0;
+	bvec->bv_offset = 0;
+	bio->bi_vcnt--;
+	blk_recount_segments(q, bio);
+	return 0;
 }
 
 /**
-- 
Maurizio Lombardi

