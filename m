Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaKZBkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:40:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29055 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaKZBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:40:30 -0500
Date: Tue, 25 Nov 2014 17:40:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2] block: fix regression where bio_integrity_process uses
 wrong bio_vec iterator
Message-ID: <20141126014025.GD10050@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
course returns an error.

Therefore, teach bio_integrity_process() to use bio_for_each_segment()
to iterate the bio_vecs, since the per-bio iterator tracks which
bio_vecs are associated with that particular bio.  The integrity
handling code is effectively part of the "driver" (it's not the bio
owner), so it must use the correct iterator function.

v2: Fix a compiler warning about abandoned local variables.  This
patch supersedes "block: bio_integrity_process uses wrong bio_vec
iterator".  Patch applies against 3.18-rc6.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/bio-integrity.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 0984232..5cbd5d9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -216,9 +216,10 @@ static int bio_integrity_process(struct bio *bio,
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_iter iter;
-	struct bio_vec *bv;
+	struct bvec_iter bviter;
+	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	unsigned int i, ret = 0;
+	unsigned int ret = 0;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
 
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
