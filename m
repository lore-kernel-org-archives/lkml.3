Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303AbaLKWDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:03:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939AbaLKWD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:03:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [patch] blk-mq: fix plugging in blk_sq_make_request
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 11 Dec 2014 17:02:49 -0500
Message-ID: <x49k31xc0ae.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following appears in blk_sq_make_request:

	/*
	 * If we have multiple hardware queues, just go directly to
	 * one of those for sync IO.
	 */

We clearly don't have multiple hardware queues, here!  This comment was
introduced with this commit 07068d5b8e (blk-mq: split make request
handler for multi and single queue):

    We want slightly different behavior from them:
    
    - On single queue devices, we currently use the per-process plug
      for deferred IO and for merging.
    
    - On multi queue devices, we don't use the per-process plug, but
      we want to go straight to hardware for SYNC IO.

The old code had this:

        use_plug = !is_flush_fua && ((q->nr_hw_queues == 1) || !is_sync);

and that was converted to:

	use_plug = !is_flush_fua && !is_sync;

which is not equivalent.  For the single queue case, that second half of
the && expression is always true.  So, what I think was actually inteded
follows (and this more closely matches what is done in blk_queue_bio).

I haven't done any performance testing of this yet.  I'd really just
like to see if I've got the intent right first.  Jens?

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1d016fc..1cd90c0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1208,16 +1208,11 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = rw_is_sync(bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
-	unsigned int use_plug, request_count = 0;
+	struct blk_plug *plug;
+	unsigned int request_count = 0;
 	struct blk_map_ctx data;
 	struct request *rq;
 
-	/*
-	 * If we have multiple hardware queues, just go directly to
-	 * one of those for sync IO.
-	 */
-	use_plug = !is_flush_fua && !is_sync;
-
 	blk_queue_bounce(q, &bio);
 
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
@@ -1225,7 +1220,7 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
-	if (use_plug && !blk_queue_nomerges(q) &&
+	if (!blk_queue_nomerges(q) &&
 	    blk_attempt_plug_merge(q, bio, &request_count))
 		return;
 
@@ -1244,21 +1239,18 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	 * utilize that to temporarily store requests until the task is
 	 * either done or scheduled away.
 	 */
-	if (use_plug) {
-		struct blk_plug *plug = current->plug;
-
-		if (plug) {
-			blk_mq_bio_to_request(rq, bio);
-			if (list_empty(&plug->mq_list))
-				trace_block_plug(q);
-			else if (request_count >= BLK_MAX_REQUEST_COUNT) {
-				blk_flush_plug_list(plug, false);
-				trace_block_plug(q);
-			}
-			list_add_tail(&rq->queuelist, &plug->mq_list);
-			blk_mq_put_ctx(data.ctx);
-			return;
+	plug = current->plug;
+	if (plug) {
+		blk_mq_bio_to_request(rq, bio);
+		if (list_empty(&plug->mq_list))
+			trace_block_plug(q);
+		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
+			blk_flush_plug_list(plug, false);
+			trace_block_plug(q);
 		}
+		list_add_tail(&rq->queuelist, &plug->mq_list);
+		blk_mq_put_ctx(data.ctx);
+		return;
 	}
 
 	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
