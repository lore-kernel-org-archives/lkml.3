Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3IYUY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:24:26 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39311 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3IYUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:58 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 4/6] convert nvme to blk_max_segment()
Date: Wed, 25 Sep 2013 13:22:42 -0700
Message-Id: <1380140564-9030-5-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/block/nvme-core.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ddcb405..e4a9502 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -465,6 +465,7 @@ static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
 static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
 {
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct bio_vec bvec, bvprv;
 	struct bvec_iter iter;
 	struct scatterlist *sg = NULL;
@@ -477,26 +478,26 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 			 (nvmeq->dev->stripe_size - 1));
 
 	sg_init_table(iod->sg, psegs);
-	bio_for_each_segment(bvec, bio, iter) {
-		if (!first && BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
-			sg->length += bvec.bv_len;
-		} else {
-			if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
-				return nvme_split_and_submit(bio, nvmeq,
-							     length);
-
-			sg = sg ? sg + 1 : iod->sg;
-			sg_set_page(sg, bvec.bv_page,
-				    bvec.bv_len, bvec.bv_offset);
-			nsegs++;
-		}
 
-		if (split_len - length < bvec.bv_len)
-			return nvme_split_and_submit(bio, nvmeq, split_len);
+	iter = bio->bi_iter;
+	while (iter.bi_size) {
+		bvec = bio_iovec_iter(bio, iter);
+		bvec.bv_len = blk_max_segment(q, &bvec);
+
+		if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
+			return nvme_split_and_submit(bio, nvmeq, length);
+
+		sg = sg ? sg + 1 : iod->sg;
+		sg_set_page(sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
+		nsegs++;
+
 		length += bvec.bv_len;
 		bvprv = bvec;
 		first = 0;
+
+		bio_advance_iter(bio, &iter, bvec.bv_len);
 	}
+
 	iod->nents = nsegs;
 	sg_mark_end(sg);
 	if (dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir) == 0)
-- 
1.8.4.rc3

