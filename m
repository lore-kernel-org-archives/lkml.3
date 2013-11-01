Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3KAQ2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:28:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3KAQ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:28:52 -0400
Date: Fri, 1 Nov 2013 12:28:23 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
Message-ID: <20131101162823.GB23501@redhat.com>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <20131101154338.GA23501@redhat.com>
 <20131101155027.GA5665@infradead.org>
 <5273D0B1.2030006@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5273D0B1.2030006@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01 2013 at 12:02pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/01/2013 09:50 AM, Christoph Hellwig wrote:
> > On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
> >> All the bi_sector ones are low hanging fruit, but the conversion for
> >> skd_preop_sg_list_bio()'s bio_vec code is more involved.
> >>
> >> Kent, any chance you could crank through it?
> >>
> >> If not I can come back to trying to fix this later.. but I'm working
> >> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
> >> 'for-next'.
> > 
> > The right thing for 3.13 is to rip out the bio base code path, and
> > for 3.14 to convert it to blk-mq.
> 
> It is. I will kill it.

I just cranked through it.. hope this helps (think I got everything but
may have missed something):


From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] skd: remove all the bio-based code

We'll want to convert this driver to blk-mq in the near-term.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/skd_main.c |  515 ++++++----------------------------------------
 1 files changed, 62 insertions(+), 453 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1a8717f..d259b1a 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -214,8 +214,6 @@ struct skd_request_context {
 	u32 fitmsg_id;
 
 	struct request *req;
-	struct bio *bio;
-	unsigned long start_time;
 	u8 flush_cmd;
 	u8 discard_page;
 
@@ -357,9 +355,6 @@ struct skd_device {
 
 	struct work_struct completion_worker;
 
-	struct bio_list bio_queue;
-	int queue_stopped;
-
 	struct list_head flush_list;
 };
 
@@ -470,11 +465,6 @@ MODULE_PARM_DESC(skd_dbg_level, "s1120 debug level (0,1,2)");
 module_param(skd_isr_comp_limit, int, 0444);
 MODULE_PARM_DESC(skd_isr_comp_limit, "s1120 isr comp limit (0=none) default=4");
 
-static int skd_bio;
-module_param(skd_bio, int, 0444);
-MODULE_PARM_DESC(skd_bio,
-		 "Register as a bio device instead of block (0, 1) default=0");
-
 /* Major device number dynamically assigned. */
 static u32 skd_major;
 
@@ -512,11 +502,6 @@ static void skd_log_skmsg(struct skd_device *skdev,
 static void skd_log_skreq(struct skd_device *skdev,
 			  struct skd_request_context *skreq, const char *event);
 
-/* FLUSH FUA flag handling. */
-static int skd_flush_cmd_enqueue(struct skd_device *, void *);
-static void *skd_flush_cmd_dequeue(struct skd_device *);
-
-
 /*
  *****************************************************************************
  * READ/WRITE REQUESTS
@@ -524,37 +509,22 @@ static void *skd_flush_cmd_dequeue(struct skd_device *);
  */
 static void skd_stop_queue(struct skd_device *skdev)
 {
-	if (!skd_bio)
-		blk_stop_queue(skdev->queue);
-	else
-		skdev->queue_stopped = 1;
+	blk_stop_queue(skdev->queue);
 }
 
 static void skd_unstop_queue(struct skd_device *skdev)
 {
-	if (!skd_bio)
-		queue_flag_clear(QUEUE_FLAG_STOPPED, skdev->queue);
-	else
-		skdev->queue_stopped = 0;
+	queue_flag_clear(QUEUE_FLAG_STOPPED, skdev->queue);
 }
 
 static void skd_start_queue(struct skd_device *skdev)
 {
-	if (!skd_bio) {
-		blk_start_queue(skdev->queue);
-	} else {
-		pr_err("(%s): Starting queue\n", skd_name(skdev));
-		skdev->queue_stopped = 0;
-		skd_request_fn(skdev->queue);
-	}
+	blk_start_queue(skdev->queue);
 }
 
 static int skd_queue_stopped(struct skd_device *skdev)
 {
-	if (!skd_bio)
-		return blk_queue_stopped(skdev->queue);
-	else
-		return skdev->queue_stopped;
+	return blk_queue_stopped(skdev->queue);
 }
 
 static void skd_fail_all_pending_blk(struct skd_device *skdev)
@@ -571,40 +541,9 @@ static void skd_fail_all_pending_blk(struct skd_device *skdev)
 	}
 }
 
-static void skd_fail_all_pending_bio(struct skd_device *skdev)
-{
-	struct bio *bio;
-	int error = -EIO;
-
-	for (;; ) {
-		bio = bio_list_pop(&skdev->bio_queue);
-
-		if (bio == NULL)
-			break;
-
-		bio_endio(bio, error);
-	}
-}
-
 static void skd_fail_all_pending(struct skd_device *skdev)
 {
-	if (!skd_bio)
-		skd_fail_all_pending_blk(skdev);
-	else
-		skd_fail_all_pending_bio(skdev);
-}
-
-static void skd_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct skd_device *skdev = q->queuedata;
-	unsigned long flags;
-
-	spin_lock_irqsave(&skdev->lock, flags);
-
-	bio_list_add(&skdev->bio_queue, bio);
-	skd_request_fn(skdev->queue);
-
-	spin_unlock_irqrestore(&skdev->lock, flags);
+	skd_fail_all_pending_blk(skdev);
 }
 
 static void
@@ -667,18 +606,9 @@ skd_prep_discard_cdb(struct skd_scsi_request *scsi_req,
 	put_unaligned_be64(lba, &buf[8]);
 	put_unaligned_be32(count, &buf[16]);
 
-	if (!skd_bio) {
-		req = skreq->req;
-		blk_add_request_payload(req, page, len);
-		req->buffer = buf;
-	} else {
-		skreq->bio->bi_io_vec->bv_page = page;
-		skreq->bio->bi_io_vec->bv_offset = 0;
-		skreq->bio->bi_io_vec->bv_len = len;
-
-		skreq->bio->bi_vcnt = 1;
-		skreq->bio->bi_phys_segments = 1;
-	}
+	req = skreq->req;
+	blk_add_request_payload(req, page, len);
+	req->buffer = buf;
 }
 
 static void skd_request_fn_not_online(struct request_queue *q);
@@ -690,7 +620,6 @@ static void skd_request_fn(struct request_queue *q)
 	struct fit_msg_hdr *fmh = NULL;
 	struct skd_request_context *skreq;
 	struct request *req = NULL;
-	struct bio *bio = NULL;
 	struct skd_scsi_request *scsi_req;
 	struct page *page;
 	unsigned long io_flags;
@@ -732,60 +661,27 @@ static void skd_request_fn(struct request_queue *q)
 
 		flush = fua = 0;
 
-		if (!skd_bio) {
-			req = blk_peek_request(q);
-
-			/* Are there any native requests to start? */
-			if (req == NULL)
-				break;
-
-			lba = (u32)blk_rq_pos(req);
-			count = blk_rq_sectors(req);
-			data_dir = rq_data_dir(req);
-			io_flags = req->cmd_flags;
-
-			if (io_flags & REQ_FLUSH)
-				flush++;
-
-			if (io_flags & REQ_FUA)
-				fua++;
-
-			pr_debug("%s:%s:%d new req=%p lba=%u(0x%x) "
-				 "count=%u(0x%x) dir=%d\n",
-				 skdev->name, __func__, __LINE__,
-				 req, lba, lba, count, count, data_dir);
-		} else {
-			if (!list_empty(&skdev->flush_list)) {
-				/* Process data part of FLUSH request. */
-				bio = (struct bio *)skd_flush_cmd_dequeue(skdev);
-				flush++;
-				pr_debug("%s:%s:%d processing FLUSH request with data.\n",
-					 skdev->name, __func__, __LINE__);
-			} else {
-				/* peek at our bio queue */
-				bio = bio_list_peek(&skdev->bio_queue);
-			}
+		req = blk_peek_request(q);
 
-			/* Are there any native requests to start? */
-			if (bio == NULL)
-				break;
+		/* Are there any native requests to start? */
+		if (req == NULL)
+			break;
 
-			lba = (u32)bio->bi_sector;
-			count = bio_sectors(bio);
-			data_dir = bio_data_dir(bio);
-			io_flags = bio->bi_rw;
+		lba = (u32)blk_rq_pos(req);
+		count = blk_rq_sectors(req);
+		data_dir = rq_data_dir(req);
+		io_flags = req->cmd_flags;
 
-			pr_debug("%s:%s:%d new bio=%p lba=%u(0x%x) "
-				 "count=%u(0x%x) dir=%d\n",
-				 skdev->name, __func__, __LINE__,
-				 bio, lba, lba, count, count, data_dir);
+		if (io_flags & REQ_FLUSH)
+			flush++;
 
-			if (io_flags & REQ_FLUSH)
-				flush++;
+		if (io_flags & REQ_FUA)
+			fua++;
 
-			if (io_flags & REQ_FUA)
-				fua++;
-		}
+		pr_debug("%s:%s:%d new req=%p lba=%u(0x%x) "
+			 "count=%u(0x%x) dir=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 req, lba, lba, count, count, data_dir);
 
 		/* At this point we know there is a request
 		 * (from our bio q or req q depending on the way
@@ -825,29 +721,15 @@ static void skd_request_fn(struct request_queue *q)
 		skreq->discard_page = 0;
 
 		/*
-		 * OK to now dequeue request from either bio or q.
+		 * OK to now dequeue request from q.
 		 *
 		 * At this point we are comitted to either start or reject
 		 * the native request. Note that skd_request_context is
 		 * available but is still at the head of the free list.
 		 */
-		if (!skd_bio) {
-			blk_start_request(req);
-			skreq->req = req;
-			skreq->fitmsg_id = 0;
-		} else {
-			if (unlikely(flush == SKD_FLUSH_DATA_SECOND)) {
-				skreq->bio = bio;
-			} else {
-				skreq->bio = bio_list_pop(&skdev->bio_queue);
-				SKD_ASSERT(skreq->bio == bio);
-				skreq->start_time = jiffies;
-				part_inc_in_flight(&skdev->disk->part0,
-						   bio_data_dir(bio));
-			}
-
-			skreq->fitmsg_id = 0;
-		}
+		blk_start_request(req);
+		skreq->req = req;
+		skreq->fitmsg_id = 0;
 
 		/* Either a FIT msg is in progress or we have to start one. */
 		if (skmsg == NULL) {
@@ -923,8 +805,7 @@ static void skd_request_fn(struct request_queue *q)
 		if (fua)
 			scsi_req->cdb[1] |= SKD_FUA_NV;
 
-		if ((!skd_bio && !req->bio) ||
-			(skd_bio && flush == SKD_FLUSH_ZERO_SIZE_FIRST))
+		if (!req->bio)
 			goto skip_sg;
 
 		error = skd_preop_sg_list(skdev, skreq);
@@ -1011,8 +892,7 @@ skip_sg:
 	 * If req is non-NULL it means there is something to do but
 	 * we are out of a resource.
 	 */
-	if (((!skd_bio) && req) ||
-	    ((skd_bio) && bio_list_peek(&skdev->bio_queue)))
+	if (req)
 		skd_stop_queue(skdev);
 }
 
@@ -1124,184 +1004,22 @@ static void skd_postop_sg_list_blk(struct skd_device *skdev,
 	pci_unmap_sg(skdev->pdev, &skreq->sg[0], skreq->n_sg, pci_dir);
 }
 
-static void skd_end_request_bio(struct skd_device *skdev,
-				struct skd_request_context *skreq, int error)
-{
-	struct bio *bio = skreq->bio;
-	int rw = bio_data_dir(bio);
-	unsigned long io_flags = bio->bi_rw;
-
-	if ((io_flags & REQ_DISCARD) &&
-		(skreq->discard_page == 1)) {
-		pr_debug("%s:%s:%d biomode: skd_end_request: freeing DISCARD page.\n",
-			 skdev->name, __func__, __LINE__);
-		free_page((unsigned long)page_address(bio->bi_io_vec->bv_page));
-	}
-
-	if (unlikely(error)) {
-		u32 lba = (u32)skreq->bio->bi_sector;
-		u32 count = bio_sectors(skreq->bio);
-		char *cmd = (rw == WRITE) ? "write" : "read";
-		pr_err("(%s): Error cmd=%s sect=%u count=%u id=0x%x\n",
-		       skd_name(skdev), cmd, lba, count, skreq->id);
-	}
-	{
-		int cpu = part_stat_lock();
-
-		if (likely(!error)) {
-			part_stat_inc(cpu, &skdev->disk->part0, ios[rw]);
-			part_stat_add(cpu, &skdev->disk->part0, sectors[rw],
-				      bio_sectors(bio));
-		}
-		part_stat_add(cpu, &skdev->disk->part0, ticks[rw],
-			      jiffies - skreq->start_time);
-		part_dec_in_flight(&skdev->disk->part0, rw);
-		part_stat_unlock();
-	}
-
-	pr_debug("%s:%s:%d id=0x%x error=%d\n",
-		 skdev->name, __func__, __LINE__, skreq->id, error);
-
-	bio_endio(skreq->bio, error);
-}
-
-static int skd_preop_sg_list_bio(struct skd_device *skdev,
-				 struct skd_request_context *skreq)
-{
-	struct bio *bio = skreq->bio;
-	int writing = skreq->sg_data_dir == SKD_DATA_DIR_HOST_TO_CARD;
-	int pci_dir = writing ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE;
-	int n_sg;
-	int i;
-	struct bio_vec *vec;
-	struct fit_sg_descriptor *sgd;
-	u64 dma_addr;
-	u32 count;
-	int errs = 0;
-	unsigned int io_flags = 0;
-	io_flags |= bio->bi_rw;
-
-	skreq->sg_byte_count = 0;
-	n_sg = skreq->n_sg = skreq->bio->bi_vcnt;
-
-	if (n_sg <= 0)
-		return -EINVAL;
-
-	if (n_sg > skdev->sgs_per_request) {
-		pr_err("(%s): sg overflow n=%d\n",
-		       skd_name(skdev), n_sg);
-		skreq->n_sg = 0;
-		return -EIO;
-	}
-
-	for (i = 0; i < skreq->n_sg; i++) {
-		vec = bio_iovec_idx(bio, i);
-		dma_addr = pci_map_page(skdev->pdev,
-					vec->bv_page,
-					vec->bv_offset, vec->bv_len, pci_dir);
-		count = vec->bv_len;
-
-		if (count == 0 || count > 64u * 1024u || (count & 3) != 0
-		    || (dma_addr & 3) != 0) {
-			pr_err(
-			       "(%s): Bad sg ix=%d count=%d addr=0x%llx\n",
-			       skd_name(skdev), i, count, dma_addr);
-			errs++;
-		}
-
-		sgd = &skreq->sksg_list[i];
-
-		sgd->control = FIT_SGD_CONTROL_NOT_LAST;
-		sgd->byte_count = vec->bv_len;
-		skreq->sg_byte_count += vec->bv_len;
-		sgd->host_side_addr = dma_addr;
-		sgd->dev_side_addr = 0; /* not used */
-	}
-
-	skreq->sksg_list[n_sg - 1].next_desc_ptr = 0LL;
-	skreq->sksg_list[n_sg - 1].control = FIT_SGD_CONTROL_LAST;
-
-
-	 if (!(io_flags & REQ_DISCARD)) {
-		count = bio_sectors(bio) << 9u;
-		if (count != skreq->sg_byte_count) {
-			pr_err("(%s): mismatch count sg=%d req=%d\n",
-			       skd_name(skdev), skreq->sg_byte_count, count);
-			errs++;
-		}
-	}
-
-	if (unlikely(skdev->dbg_level > 1)) {
-		pr_debug("%s:%s:%d skreq=%x sksg_list=%p sksg_dma=%llx\n",
-			 skdev->name, __func__, __LINE__,
-			 skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
-		for (i = 0; i < n_sg; i++) {
-			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			pr_debug("%s:%s:%d   sg[%d] count=%u ctrl=0x%x "
-				 "addr=0x%llx next=0x%llx\n",
-				 skdev->name, __func__, __LINE__,
-				 i, sgd->byte_count, sgd->control,
-				 sgd->host_side_addr, sgd->next_desc_ptr);
-		}
-	}
-
-	if (errs != 0) {
-		skd_postop_sg_list(skdev, skreq);
-		skreq->n_sg = 0;
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static int skd_preop_sg_list(struct skd_device *skdev,
 			     struct skd_request_context *skreq)
 {
-	if (!skd_bio)
-		return skd_preop_sg_list_blk(skdev, skreq);
-	else
-		return skd_preop_sg_list_bio(skdev, skreq);
-}
-
-static void skd_postop_sg_list_bio(struct skd_device *skdev,
-				   struct skd_request_context *skreq)
-{
-	int writing = skreq->sg_data_dir == SKD_DATA_DIR_HOST_TO_CARD;
-	int pci_dir = writing ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE;
-	int i;
-	struct fit_sg_descriptor *sgd;
-
-	/*
-	 * restore the next ptr for next IO request so we
-	 * don't have to set it every time.
-	 */
-	skreq->sksg_list[skreq->n_sg - 1].next_desc_ptr =
-		skreq->sksg_dma_address +
-		((skreq->n_sg) * sizeof(struct fit_sg_descriptor));
-
-	for (i = 0; i < skreq->n_sg; i++) {
-		sgd = &skreq->sksg_list[i];
-		pci_unmap_page(skdev->pdev, sgd->host_side_addr,
-			       sgd->byte_count, pci_dir);
-	}
+	return skd_preop_sg_list_blk(skdev, skreq);
 }
 
 static void skd_postop_sg_list(struct skd_device *skdev,
 			       struct skd_request_context *skreq)
 {
-	if (!skd_bio)
-		skd_postop_sg_list_blk(skdev, skreq);
-	else
-		skd_postop_sg_list_bio(skdev, skreq);
+	skd_postop_sg_list_blk(skdev, skreq);
 }
 
 static void skd_end_request(struct skd_device *skdev,
 			    struct skd_request_context *skreq, int error)
 {
-	if (likely(!skd_bio))
-		skd_end_request_blk(skdev, skreq, error);
-	else
-		skd_end_request_bio(skdev, skreq, error);
+	skd_end_request_blk(skdev, skreq, error);
 }
 
 static void skd_request_fn_not_online(struct request_queue *q)
@@ -2754,13 +2472,10 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 		break;
 
 	case SKD_CHECK_STATUS_REQUEUE_REQUEST:
-		if (!skd_bio) {
-			if ((unsigned long) ++skreq->req->special <
-			    SKD_MAX_RETRIES) {
-				skd_log_skreq(skdev, skreq, "retry");
-				skd_requeue_request(skdev, skreq);
-				break;
-			}
+		if ((unsigned long) ++skreq->req->special < SKD_MAX_RETRIES) {
+			skd_log_skreq(skdev, skreq, "retry");
+			skd_requeue_request(skdev, skreq);
+			break;
 		}
 	/* fall through to report error */
 
@@ -2774,16 +2489,9 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 static void skd_requeue_request(struct skd_device *skdev,
 				struct skd_request_context *skreq)
 {
-	if (!skd_bio) {
-		blk_requeue_request(skdev->queue, skreq->req);
-	} else {
-		bio_list_add_head(&skdev->bio_queue, skreq->bio);
-		skreq->bio = NULL;
-	}
+	blk_requeue_request(skdev->queue, skreq->req);
 }
 
-
-
 /* assume spinlock is already held */
 static void skd_release_skreq(struct skd_device *skdev,
 			      struct skd_request_context *skreq)
@@ -2840,11 +2548,7 @@ static void skd_release_skreq(struct skd_device *skdev,
 	/*
 	 * Reset backpointer
 	 */
-	if (likely(!skd_bio))
-		skreq->req = NULL;
-	else
-		skreq->bio = NULL;
-
+	skreq->req = NULL;
 
 	/*
 	 * Reclaim the skd_request_context
@@ -3084,8 +2788,6 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 	u32 cmp_bytes = 0;
 	int rc = 0;
 	int processed = 0;
-	int ret;
-
 
 	for (;; ) {
 		SKD_ASSERT(skdev->skcomp_ix < SKD_N_COMPLETION_ENTRY);
@@ -3180,8 +2882,7 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		if (skreq->n_sg > 0)
 			skd_postop_sg_list(skdev, skreq);
 
-		if (((!skd_bio) && !skreq->req) ||
-		    ((skd_bio) && !skreq->bio)) {
+		if (!skreq->req) {
 			pr_debug("%s:%s:%d NULL backptr skdreq %p, "
 				 "req=0x%x req_id=0x%x\n",
 				 skdev->name, __func__, __LINE__,
@@ -3191,30 +2892,10 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 			 * Capture the outcome and post it back to the
 			 * native request.
 			 */
-			if (likely(cmp_status == SAM_STAT_GOOD)) {
-				if (unlikely(skreq->flush_cmd)) {
-					if (skd_bio) {
-						/* if empty size bio, we are all done */
-						if (bio_sectors(skreq->bio) == 0) {
-							skd_end_request(skdev, skreq, 0);
-						} else {
-							ret = skd_flush_cmd_enqueue(skdev, (void *)skreq->bio);
-							if (ret != 0) {
-								pr_err("Failed to enqueue flush bio with Data. Err=%d.\n", ret);
-								skd_end_request(skdev, skreq, ret);
-							} else {
-								((*enqueued)++);
-							}
-						}
-					} else {
-						skd_end_request(skdev, skreq, 0);
-					}
-				} else {
-					skd_end_request(skdev, skreq, 0);
-				}
-			} else {
+			if (likely(cmp_status == SAM_STAT_GOOD))
+				skd_end_request(skdev, skreq, 0);
+			else
 				skd_resolve_req_exception(skdev, skreq);
-			}
 		}
 
 		/*
@@ -3645,34 +3326,22 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
 			skd_log_skreq(skdev, skreq, "recover");
 
 			SKD_ASSERT((skreq->id & SKD_ID_INCR) != 0);
-			if (!skd_bio)
-				SKD_ASSERT(skreq->req != NULL);
-			else
-				SKD_ASSERT(skreq->bio != NULL);
+			SKD_ASSERT(skreq->req != NULL);
 
 			/* Release DMA resources for the request. */
 			if (skreq->n_sg > 0)
 				skd_postop_sg_list(skdev, skreq);
 
-			if (!skd_bio) {
-				if (requeue &&
-				    (unsigned long) ++skreq->req->special <
-				    SKD_MAX_RETRIES)
-					skd_requeue_request(skdev, skreq);
-				else
-				skd_end_request(skdev, skreq, -EIO);
-			} else
+			if (requeue &&
+			    (unsigned long) ++skreq->req->special < SKD_MAX_RETRIES)			    
+				skd_requeue_request(skdev, skreq);
+			else
 				skd_end_request(skdev, skreq, -EIO);
 
-			if (!skd_bio)
-				skreq->req = NULL;
-			else
-				skreq->bio = NULL;
+			skreq->req = NULL;
 
 			skreq->state = SKD_REQ_STATE_IDLE;
 			skreq->id += SKD_ID_INCR;
-
-
 		}
 		if (i > 0)
 			skreq[-1].next = skreq;
@@ -4580,10 +4249,6 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	skdev->sgs_per_request = skd_sgs_per_request;
 	skdev->dbg_level = skd_dbg_level;
 
-	if (skd_bio)
-		bio_list_init(&skdev->bio_queue);
-
-
 	atomic_set(&skdev->device_count, 0);
 
 	spin_lock_init(&skdev->lock);
@@ -4941,13 +4606,7 @@ static int skd_cons_disk(struct skd_device *skdev)
 	disk->fops = &skd_blockdev_ops;
 	disk->private_data = skdev;
 
-	if (!skd_bio) {
-		q = blk_init_queue(skd_request_fn, &skdev->lock);
-	} else {
-		q = blk_alloc_queue(GFP_KERNEL);
-		q->queue_flags = QUEUE_FLAG_IO_STAT | QUEUE_FLAG_STACKABLE;
-	}
-
+	q = blk_init_queue(skd_request_fn, &skdev->lock);
 	if (!q) {
 		rc = -ENOMEM;
 		goto err_out;
@@ -4957,11 +4616,6 @@ static int skd_cons_disk(struct skd_device *skdev)
 	disk->queue = q;
 	q->queuedata = skdev;
 
-	if (skd_bio) {
-		q->queue_lock = &skdev->lock;
-		blk_queue_make_request(q, skd_make_request);
-	}
-
 	blk_queue_flush(q, REQ_FLUSH | REQ_FUA);
 	blk_queue_max_segments(q, skdev->sgs_per_request);
 	blk_queue_max_hw_sectors(q, SKD_N_MAX_SECTORS);
@@ -5794,35 +5448,19 @@ static void skd_log_skreq(struct skd_device *skdev,
 		 skdev->name, __func__, __LINE__,
 		 skreq->timeout_stamp, skreq->sg_data_dir, skreq->n_sg);
 
-	if (!skd_bio) {
-		if (skreq->req != NULL) {
-			struct request *req = skreq->req;
-			u32 lba = (u32)blk_rq_pos(req);
-			u32 count = blk_rq_sectors(req);
-
-			pr_debug("%s:%s:%d "
-				 "req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				 skdev->name, __func__, __LINE__,
-				 req, lba, lba, count, count,
-				 (int)rq_data_dir(req));
-		} else
-			pr_debug("%s:%s:%d req=NULL\n",
-				 skdev->name, __func__, __LINE__);
-	} else {
-		if (skreq->bio != NULL) {
-			struct bio *bio = skreq->bio;
-			u32 lba = (u32)bio->bi_sector;
-			u32 count = bio_sectors(bio);
+	if (skreq->req != NULL) {
+		struct request *req = skreq->req;
+		u32 lba = (u32)blk_rq_pos(req);
+		u32 count = blk_rq_sectors(req);
 
-			pr_debug("%s:%s:%d "
-				 "bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				 skdev->name, __func__, __LINE__,
-				 bio, lba, lba, count, count,
-				 (int)bio_data_dir(bio));
-		} else
-			pr_debug("%s:%s:%d req=NULL\n",
-				 skdev->name, __func__, __LINE__);
-	}
+		pr_debug("%s:%s:%d "
+			 "req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 req, lba, lba, count, count,
+			 (int)rq_data_dir(req));
+	} else
+		pr_debug("%s:%s:%d req=NULL\n",
+			 skdev->name, __func__, __LINE__);
 }
 
 /*
@@ -5918,34 +5556,5 @@ static void __exit skd_exit(void)
 	kmem_cache_destroy(skd_flush_slab);
 }
 
-static int
-skd_flush_cmd_enqueue(struct skd_device *skdev, void *cmd)
-{
-	struct skd_flush_cmd *item;
-
-	item = kmem_cache_zalloc(skd_flush_slab, GFP_ATOMIC);
-	if (!item) {
-		pr_err("skd_flush_cmd_enqueue: Failed to allocated item.\n");
-		return -ENOMEM;
-	}
-
-	item->cmd = cmd;
-	list_add_tail(&item->flist, &skdev->flush_list);
-	return 0;
-}
-
-static void *
-skd_flush_cmd_dequeue(struct skd_device *skdev)
-{
-	void *cmd;
-	struct skd_flush_cmd *item;
-
-	item = list_entry(skdev->flush_list.next, struct skd_flush_cmd, flist);
-	list_del_init(&item->flist);
-	cmd = item->cmd;
-	kmem_cache_free(skd_flush_slab, item);
-	return cmd;
-}
-
 module_init(skd_init);
 module_exit(skd_exit);
