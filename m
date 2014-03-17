Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaCQNhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:37:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaCQNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:36 -0400
Message-Id: <20140317133135.683222398@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 29/39] block: remove unprep_rq_fn
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0029-block-remove-unprep_rq_fn.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that scsi doesn't use it anymore there's no user left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |   11 ++---------
 block/blk-settings.c   |   17 -----------------
 include/linux/blkdev.h |    3 ---
 3 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 47af781..d58f984 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -722,7 +722,6 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
-	q->unprep_rq_fn		= NULL;
 	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
@@ -2486,18 +2485,12 @@ static bool blk_update_bidi_request(struct request *rq, int error,
  * @req:	the request
  *
  * This function makes a request ready for complete resubmission (or
- * completion).  It happens only after all error handling is complete,
- * so represents the appropriate moment to deallocate any resources
- * that were allocated to the request in the prep_rq_fn.  The queue
- * lock is held when calling this.
+ * completion).  It happens only after all error handling is complete.
+ * The queue lock is held when calling this.
  */
 void blk_unprep_request(struct request *req)
 {
-	struct request_queue *q = req->q;
-
 	req->cmd_flags &= ~REQ_DONTPREP;
-	if (q->unprep_rq_fn)
-		q->unprep_rq_fn(q, req);
 }
 EXPORT_SYMBOL_GPL(blk_unprep_request);
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5d21239..47a266c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -37,23 +37,6 @@ void blk_queue_prep_rq(struct request_queue *q, prep_rq_fn *pfn)
 EXPORT_SYMBOL(blk_queue_prep_rq);
 
 /**
- * blk_queue_unprep_rq - set an unprepare_request function for queue
- * @q:		queue
- * @ufn:	unprepare_request function
- *
- * It's possible for a queue to register an unprepare_request callback
- * which is invoked before the request is finally completed. The goal
- * of the function is to deallocate any data that was allocated in the
- * prepare_request callback.
- *
- */
-void blk_queue_unprep_rq(struct request_queue *q, unprep_rq_fn *ufn)
-{
-	q->unprep_rq_fn = ufn;
-}
-EXPORT_SYMBOL(blk_queue_unprep_rq);
-
-/**
  * blk_queue_merge_bvec - set a merge_bvec function for queue
  * @q:		queue
  * @mbfn:	merge_bvec_fn
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4afa4f8..fc010ff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -223,7 +223,6 @@ struct blk_queue_ctx;
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
-typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 
 struct bio_vec;
 struct bvec_merge_data {
@@ -312,7 +311,6 @@ struct request_queue {
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
-	unprep_rq_fn		*unprep_rq_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
@@ -985,7 +983,6 @@ extern int blk_queue_dma_drain(struct request_queue *q,
 extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
-extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
-- 
1.7.10.4


