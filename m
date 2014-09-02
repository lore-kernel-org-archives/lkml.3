Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaIBPDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:03:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64469 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIBPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:03:41 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] blk-merge: fix blk_recount_segments
Date: Tue,  2 Sep 2014 23:02:59 +0800
Message-Id: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QUEUE_FLAG_NO_SG_MERGE is set at default for blk-mq devices,
so bio->bi_phys_segment computed may be bigger than
queue_max_segments(q) for blk-mq devices, then drivers will
fail to handle the case, for example, BUG_ON() in
virtio_queue_rq() can be triggerd for virtio-blk:

	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1359146

This patch fixes the issue by ignoring the QUEUE_FLAG_NO_SG_MERGE
flag if the computed bio->bi_phys_segment is bigger than
queue_max_segments(q), and the regression is caused by commit
05f1dd53152173(block: add queue flag for disabling SG merging).

Reported-by: Kick In <pierre-andre.morey@canonical.com>
Tested-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-merge.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5453583..7788179 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -10,10 +10,11 @@
 #include "blk.h"
 
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
-					     struct bio *bio)
+					     struct bio *bio,
+					     bool no_sg_merge)
 {
 	struct bio_vec bv, bvprv = { NULL };
-	int cluster, high, highprv = 1, no_sg_merge;
+	int cluster, high, highprv = 1;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
@@ -35,7 +36,6 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	cluster = blk_queue_cluster(q);
 	seg_size = 0;
 	nr_phys_segs = 0;
-	no_sg_merge = test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 	high = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, iter) {
@@ -88,18 +88,23 @@ new_segment:
 
 void blk_recalc_rq_segments(struct request *rq)
 {
-	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
+	bool no_sg_merge = !!test_bit(QUEUE_FLAG_NO_SG_MERGE,
+			&rq->q->queue_flags);
+
+	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio,
+			no_sg_merge);
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
-	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags))
+	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
+			bio->bi_vcnt < queue_max_segments(q))
 		bio->bi_phys_segments = bio->bi_vcnt;
 	else {
 		struct bio *nxt = bio->bi_next;
 
 		bio->bi_next = NULL;
-		bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio);
+		bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, false);
 		bio->bi_next = nxt;
 	}
 
-- 
1.7.9.5

