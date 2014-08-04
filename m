Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaHDV77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaHDV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:59:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [patch|rfc] block: fix BLK_MQ_F_SG_MERGE support
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Aug 2014 17:59:54 -0400
Message-ID: <x494mxroqzp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

With device mapper targets on top of a device that does not have
BLK_MQ_F_SG_MERGE (the default), we can end up sending down more segments
than a driver is prepared to handle.  I ran into this with virtio_blk,
triggerring this BUG_ON:

        BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);

The queue's max is set here:
        blk_queue_max_segments(q, vblk->sg_elems-2);

Basically, what happens is that a bio is built up for the dm device
(which does not have the BLK_MQ_F_SG_MERGE flag set) using
bio_add_page.  That path will call into __blk_recalc_rq_segments, so
what you end up with is bi_phys_segments being much smaller than
bi_vcnt.

And then you clone the bio.  When the cloned bio is submitted, it will
end up in blk_recount_segments, here:

        if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags))
                bio->bi_phys_segments = bio->bi_vcnt;

and now we've set bio->bi_phys_segments to a number that is beyond what
was registered as queue_max_segments by the driver.

I'm not sure how you want to address this.  The attached patch works,
but it doesn't feel right to me.  Probably the right thing to do is not
do the merging for the upper level device, but we don't have a mechanism
for propagating queue flags up the stack as yet.

Note that I ran into this when backporting the virtio_blk driver.  I
could not reproduce this problem with an upstream kernel, but from the
looks of the code, it's possible to hit it.

Also note that setting BLK_MQ_F_SG_MERGE for the virtio blk device works
around the problem, as you'd expect.

Cheers,
Jeff

p.s. no S-O-B as I don't think this is the right fix

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b3bf0df..af2f472 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -93,7 +93,8 @@ void blk_recalc_rq_segments(struct request *rq)
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
-	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags))
+	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
+	    !bio_flagged(bio, BIO_CLONED))
 		bio->bi_phys_segments = bio->bi_vcnt;
 	else {
 		struct bio *nxt = bio->bi_next;
