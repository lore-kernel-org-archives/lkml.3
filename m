Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaKUUjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:39:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21381 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaKUUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:39:42 -0500
Date: Fri, 21 Nov 2014 12:39:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: bio_integrity_process uses wrong bio_vec iterator
Message-ID: <20141121203938.GD10047@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio integrity handling is broken on a system with LVM layered atop a
DIF/DIX SCSI drive because device mapper clones the bio, modifies the
clone, and sends the clone to the lower layers for processing.
However, the clone bio has bi_vcnt == 0, which means that when the sd
driver calls bio_integrity_process to attach DIX data, the
for_each_segment_all() call (which uses bi_vcnt) returns immediately
and random garbage is sent to the disk on a disk write.  The disk of
course returns error when it's fed garbage for checksums.

Therefore, teach bio_integrity_process() to use bio_for_each_segment()
to iterate the bio_vecs, since the per-bio iterator tracks which
bio_vecs are associated with that particular bio.  The integrity
handling code is effectively part of the "driver" (it's not the bio
owner), so it must use the correct iterator function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/bio-integrity.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 0984232..e1a320d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -216,7 +216,8 @@ static int bio_integrity_process(struct bio *bio,
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_iter iter;
-	struct bio_vec *bv;
+	struct bvec_iter bviter;
+	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	unsigned int i, ret = 0;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
@@ -227,11 +228,11 @@ static int bio_integrity_process(struct bio *bio,
 	iter.seed = bip_get_seed(bip);
 	iter.prot_buf = prot_buf;
 
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
+	bio_for_each_segment(bv, bio, bviter) {
+		void *kaddr = kmap_atomic(bv.bv_page);
 
-		iter.data_buf = kaddr + bv->bv_offset;
-		iter.data_size = bv->bv_len;
+		iter.data_buf = kaddr + bv.bv_offset;
+		iter.data_size = bv.bv_len;
 
 		ret = proc_fn(&iter);
 		if (ret) {
