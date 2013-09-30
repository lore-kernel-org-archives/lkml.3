Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3I3N2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:28:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55812 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3I3N1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:27:53 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-89-52497c58bebe
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 14/14] skd: remove skd_bio code
Date: Mon, 30 Sep 2013 15:25:55 +0200
Message-id: <1380547556-17719-15-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t9jAd2IGs8gg7nr5Cx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgyvh1+S1jwfHbjBXbz19kb2Dcs46xi5GTQ0LAROL+yevMELaYxIV769lAbCGB
	RYwSx95ydTFyAdldTBIvdx5gBUmwCVhJTGxfBdYsIiAssb+jlQWkiFmgiVFi45I5YN3CAvoS
	V+bNB7NZBFQl7u5vB2vgFfCU+HnvHNRmeYmn9/vAajiB4v9vH2WE2Owh8e3QZaYJjLwLGBlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH0zPpHYyrGiwOMQpwMCrx8Fos9QgSYk0sK67M
	PcQowcGsJMIrXuYZJMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyW
	iYNTqoGRVyK91yFTb4HAjD+PVbZkqgR8cIr48EOGuTF5l9ndHx+r2ayFIw9ZL7H6cpTJoPfV
	57DIL39e+UcfWPTjbExrwgrfTQLVpXYRx1j++lhrLZ5Re+WwveCTy2dESt6zWU7JWZ3RG52h
	wXPnu/+kNZqVczPE/c4VyVdGJx9+EcrgG9+x42FaaacSS3FGoqEWc1FxIgANgfEjIwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skd_bio feature adds a possibility to use the internal bio list to process
requests instead of using the normal block layer queueing functionality.
Its potential advantages are unclear and if there are any it is better to
identify and fix the block layer code deficiences instead. Moreover it
introduces separate code-paths through the whole driver which are difficult
to test properly and maintain in the long-term. Since it is currently not
used unless explicitly enabled by module parameter just remove it.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 605 ++++++-----------------------------------------
 1 file changed, 76 insertions(+), 529 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 4d8e94c..6214d68 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -368,27 +368,7 @@ struct skd_device {
 
 	u32 timo_slot;
 
-
 	struct work_struct completion_worker;
-
-	struct bio_list bio_queue;
-	int queue_stopped;
-
-	struct list_head flush_list;
-};
-
-#define SKD_FLUSH_JOB   "skd-flush-jobs"
-struct kmem_cache *skd_flush_slab;
-
-/*
- * These commands hold "nonzero size FLUSH bios",
- * which are enqueud in skdev->flush_list during
- * completion of "zero size FLUSH commands".
- * It will be active in biomode.
- */
-struct skd_flush_cmd {
-	void *cmd;
-	struct list_head flist;
 };
 
 #define SKD_WRITEL(DEV, VAL, OFF) skd_reg_write32(DEV, VAL, OFF)
@@ -489,11 +469,6 @@ MODULE_PARM_DESC(skd_dbg_level, "s1120 debug level (0,1,2)");
 module_param(skd_isr_comp_limit, int, 0444);
 MODULE_PARM_DESC(skd_isr_comp_limit, "s1120 isr comp limit (0=none) default=4");
 
-static int skd_bio;
-module_param(skd_bio, int, 0444);
-MODULE_PARM_DESC(skd_bio,
-		 "Register as a bio device instead of block (0, 1) default=0");
-
 /* Major device number dynamically assigned. */
 static u32 skd_major;
 
@@ -535,42 +510,8 @@ static void skd_log_skreq(struct skd_device *skdev,
  * READ/WRITE REQUESTS
  *****************************************************************************
  */
-static void skd_stop_queue(struct skd_device *skdev)
-{
-	if (!skd_bio)
-		blk_stop_queue(skdev->queue);
-	else
-		skdev->queue_stopped = 1;
-}
 
-static void skd_unstop_queue(struct skd_device *skdev)
-{
-	if (!skd_bio)
-		queue_flag_clear(QUEUE_FLAG_STOPPED, skdev->queue);
-	else
-		skdev->queue_stopped = 0;
-}
-
-static void skd_start_queue(struct skd_device *skdev)
-{
-	if (!skd_bio) {
-		blk_start_queue(skdev->queue);
-	} else {
-		pr_err("(%s): Starting queue\n", skd_name(skdev));
-		skdev->queue_stopped = 0;
-		skd_request_fn(skdev->queue);
-	}
-}
-
-static int skd_queue_stopped(struct skd_device *skdev)
-{
-	if (!skd_bio)
-		return blk_queue_stopped(skdev->queue);
-	else
-		return skdev->queue_stopped;
-}
-
-static void skd_fail_all_pending_blk(struct skd_device *skdev)
+static void skd_fail_all_pending(struct skd_device *skdev)
 {
 	struct request_queue *q = skdev->queue;
 	struct request *req;
@@ -584,42 +525,6 @@ static void skd_fail_all_pending_blk(struct skd_device *skdev)
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
-static void skd_fail_all_pending(struct skd_device *skdev)
-{
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
-}
-
 static void
 skd_prep_rw_cdb(struct skd_scsi_request *scsi_req,
 		int data_dir, unsigned lba,
@@ -680,45 +585,9 @@ skd_prep_discard_cdb(struct skd_scsi_request *scsi_req,
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
-}
-
-static int skd_flush_cmd_enqueue(struct skd_device *skdev, void *cmd)
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
-static void *skd_flush_cmd_dequeue(struct skd_device *skdev)
-{
-	void *cmd;
-	struct skd_flush_cmd *item;
-
-	item = list_entry(skdev->flush_list.next, struct skd_flush_cmd, flist);
-	list_del_init(&item->flist);
-	cmd = item->cmd;
-	kmem_cache_free(skd_flush_slab, item);
-	return cmd;
+	req = skreq->req;
+	blk_add_request_payload(req, page, len);
+	req->buffer = buf;
 }
 
 static void skd_request_fn_not_online(struct request_queue *q);
@@ -751,14 +620,14 @@ static void skd_request_fn(struct request_queue *q)
 		return;
 	}
 
-	if (skd_queue_stopped(skdev)) {
+	if (blk_queue_stopped(skdev->queue)) {
 		if (skdev->skmsg_free_list == NULL ||
 		    skdev->skreq_free_list == NULL ||
 		    skdev->in_flight >= skdev->queue_low_water_mark)
 			/* There is still some kind of shortage */
 			return;
 
-		skd_unstop_queue(skdev);
+		queue_flag_clear(QUEUE_FLAG_STOPPED, skdev->queue);
 	}
 
 	/*
@@ -768,61 +637,29 @@ static void skd_request_fn(struct request_queue *q)
 	 *  - There are no more skd_request_context entries
 	 *  - There are no more FIT msg buffers
 	 */
-	for (;; ) {
-
+	for (;;) {
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
-			VPRINTK(skdev,
-				"new req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				req, lba, lba, count, count, data_dir);
-		} else {
-			if (!list_empty(&skdev->flush_list)) {
-				/* Process data part of FLUSH request. */
-				bio = (struct bio *)skd_flush_cmd_dequeue(skdev);
-				flush++;
-				VPRINTK(skdev, "processing FLUSH request with data.\n");
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
 
-			VPRINTK(skdev,
-				"new bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				bio, lba, lba, count, count, data_dir);
+		if (io_flags & REQ_FLUSH)
+			flush++;
 
-			if (io_flags & REQ_FLUSH)
-				flush++;
+		if (io_flags & REQ_FUA)
+			fua++;
 
-			if (io_flags & REQ_FUA)
-				fua++;
-		}
+		VPRINTK(skdev,
+			"new req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
+			req, lba, lba, count, count, data_dir);
 
 		/* At this point we know there is a request
 		 * (from our bio q or req q depending on the way
@@ -859,29 +696,15 @@ static void skd_request_fn(struct request_queue *q)
 		skreq->discard_page = 0;
 
 		/*
-		 * OK to now dequeue request from either bio or q.
+		 * OK to now dequeue request from queue.
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
@@ -955,8 +778,7 @@ static void skd_request_fn(struct request_queue *q)
 		if (fua)
 			scsi_req->cdb[1] |= SKD_FUA_NV;
 
-		if ((!skd_bio && !req->bio) ||
-			(skd_bio && flush == SKD_FLUSH_ZERO_SIZE_FIRST))
+		if (!req->bio)
 			goto skip_sg;
 
 		error = skd_preop_sg_list(skdev, skreq);
@@ -1040,13 +862,12 @@ skip_sg:
 	 * If req is non-NULL it means there is something to do but
 	 * we are out of a resource.
 	 */
-	if (((!skd_bio) && req) ||
-	    ((skd_bio) && bio_list_peek(&skdev->bio_queue)))
-		skd_stop_queue(skdev);
+	if (req)
+		blk_stop_queue(skdev->queue);
 }
 
-static void skd_end_request_blk(struct skd_device *skdev,
-				struct skd_request_context *skreq, int error)
+static void skd_end_request(struct skd_device *skdev,
+			    struct skd_request_context *skreq, int error)
 {
 	struct request *req = skreq->req;
 	unsigned int io_flags = req->cmd_flags;
@@ -1072,8 +893,8 @@ static void skd_end_request_blk(struct skd_device *skdev,
 	__blk_end_request_all(skreq->req, error);
 }
 
-static int skd_preop_sg_list_blk(struct skd_device *skdev,
-				 struct skd_request_context *skreq)
+static int skd_preop_sg_list(struct skd_device *skdev,
+			     struct skd_request_context *skreq)
 {
 	struct request *req = skreq->req;
 	int writing = skreq->sg_data_dir == SKD_DATA_DIR_HOST_TO_CARD;
@@ -1133,8 +954,8 @@ static int skd_preop_sg_list_blk(struct skd_device *skdev,
 	return 0;
 }
 
-static void skd_postop_sg_list_blk(struct skd_device *skdev,
-				   struct skd_request_context *skreq)
+static void skd_postop_sg_list(struct skd_device *skdev,
+			       struct skd_request_context *skreq)
 {
 	int writing = skreq->sg_data_dir == SKD_DATA_DIR_HOST_TO_CARD;
 	int pci_dir = writing ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE;
@@ -1149,182 +970,6 @@ static void skd_postop_sg_list_blk(struct skd_device *skdev,
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
-		VPRINTK(skdev, "biomode: skd_end_request: freeing DISCARD page.\n");
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
-	VPRINTK(skdev, "id=0x%x error=%d\n", skreq->id, error);
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
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
-			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
-		for (i = 0; i < n_sg; i++) {
-			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
-				"addr=0x%llx next=0x%llx\n",
-				i, sgd->byte_count, sgd->control,
-				sgd->host_side_addr, sgd->next_desc_ptr);
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
-static int skd_preop_sg_list(struct skd_device *skdev,
-			     struct skd_request_context *skreq)
-{
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
-}
-
-static void skd_postop_sg_list(struct skd_device *skdev,
-			       struct skd_request_context *skreq)
-{
-	if (!skd_bio)
-		skd_postop_sg_list_blk(skdev, skreq);
-	else
-		skd_postop_sg_list_bio(skdev, skreq);
-}
-
-static void skd_end_request(struct skd_device *skdev,
-			    struct skd_request_context *skreq, int error)
-{
-	if (likely(!skd_bio))
-		skd_end_request_blk(skdev, skreq, error);
-	else
-		skd_end_request_bio(skdev, skreq, error);
-}
-
 static void skd_request_fn_not_online(struct request_queue *q)
 {
 	struct skd_device *skdev = q->queuedata;
@@ -1426,7 +1071,7 @@ static void skd_timer_tick(ulong arg)
 	skdev->timer_countdown = SKD_DRAINING_TIMO;
 	skdev->state = SKD_DRVR_STATE_DRAINING_TIMEOUT;
 	skdev->timo_slot = timo_slot;
-	skd_stop_queue(skdev);
+	blk_stop_queue(skdev->queue);
 
 timer_func_out:
 	mod_timer(&skdev->timer, (jiffies + HZ));
@@ -1482,7 +1127,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 
 		/*start the queue so we can respond with error to requests */
 		/* wakeup anyone waiting for startup complete */
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
 		break;
@@ -1506,7 +1151,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 		if (skdev->timeout_slot[skdev->timo_slot] == 0) {
 			DPRINTK(skdev, "Slot drained, starting queue.\n");
 			skdev->state = SKD_DRVR_STATE_ONLINE;
-			skd_start_queue(skdev);
+			blk_start_queue(skdev->queue);
 			return;
 		}
 		if (skdev->timer_countdown > 0) {
@@ -1556,7 +1201,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 
 		/*start the queue so we can respond with error to requests */
 		/* wakeup anyone waiting for startup complete */
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
 		break;
@@ -2581,10 +2226,6 @@ static void skd_complete_other(struct skd_device *skdev,
 			       volatile struct fit_completion_entry_v1 *skcomp,
 			       volatile struct fit_comp_error_info *skerr);
 
-
-static void skd_requeue_request(struct skd_device *skdev,
-				struct skd_request_context *skreq);
-
 struct sns_info {
 	u8 type;
 	u8 stat;
@@ -2703,7 +2344,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 
 	case SKD_CHECK_STATUS_BUSY_IMMINENT:
 		skd_log_skreq(skdev, skreq, "retry(busy)");
-		skd_requeue_request(skdev, skreq);
+		blk_requeue_request(skdev->queue, skreq->req);
 		pr_info("(%s) drive BUSY imminent\n", skd_name(skdev));
 		skdev->state = SKD_DRVR_STATE_BUSY_IMMINENT;
 		skdev->timer_countdown = SKD_TIMER_MINUTES(20);
@@ -2711,13 +2352,10 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
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
+			blk_requeue_request(skdev->queue, skreq->req);
+			break;
 		}
 	/* fall through to report error */
 
@@ -2728,19 +2366,6 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 	}
 }
 
-static void skd_requeue_request(struct skd_device *skdev,
-				struct skd_request_context *skreq)
-{
-	if (!skd_bio) {
-		blk_requeue_request(skdev->queue, skreq->req);
-	} else {
-		bio_list_add_head(&skdev->bio_queue, skreq->bio);
-		skreq->bio = NULL;
-	}
-}
-
-
-
 /* assume spinlock is already held */
 static void skd_release_skreq(struct skd_device *skdev,
 			      struct skd_request_context *skreq)
@@ -2797,11 +2422,7 @@ static void skd_release_skreq(struct skd_device *skdev,
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
@@ -3118,8 +2739,7 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		if (skreq->n_sg > 0)
 			skd_postop_sg_list(skdev, skreq);
 
-		if (((!skd_bio) && !skreq->req) ||
-		    ((skd_bio) && !skreq->bio)) {
+		if (!skreq->req) {
 			DPRINTK(skdev, "NULL backptr skdreq %p, "
 				"req=0x%x req_id=0x%x\n",
 				skreq, skreq->id, req_id);
@@ -3128,30 +2748,10 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
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
@@ -3508,7 +3108,7 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 		 */
 		skdev->state = SKD_DRVR_STATE_BUSY_SANITIZE;
 		skdev->timer_countdown = SKD_TIMER_SECONDS(3);
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		break;
 	case FIT_SR_DRIVE_BUSY_ERASE:
 		skdev->state = SKD_DRVR_STATE_BUSY_ERASE;
@@ -3542,7 +3142,7 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 	case FIT_SR_DRIVE_FAULT:
 		skd_drive_fault(skdev);
 		skd_recover_requests(skdev, 0);
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		break;
 
 	/* PCIe bus returned all Fs? */
@@ -3551,7 +3151,7 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 		       skd_name(skdev), state, sense);
 		skd_drive_disappeared(skdev);
 		skd_recover_requests(skdev, 0);
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		break;
 	default:
 		/*
@@ -3576,29 +3176,21 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
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
+			    (unsigned long) ++skreq->req->special <
+			    SKD_MAX_RETRIES)
+				blk_requeue_request(skdev->queue,
+						    skreq->req);
+			else
 				skd_end_request(skdev, skreq, -EIO);
 
-			if (!skd_bio)
-				skreq->req = NULL;
-			else
-				skreq->bio = NULL;
+			skreq->req = NULL;
 
 			skreq->state = SKD_REQ_STATE_IDLE;
 			skreq->id += SKD_ID_INCR;
@@ -3872,7 +3464,7 @@ static void skd_start_device(struct skd_device *skdev)
 		skd_drive_fault(skdev);
 		/*start the queue so we can respond with error to requests */
 		VPRINTK(skdev, "starting %s queue\n", skdev->name);
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
 		break;
@@ -3884,7 +3476,7 @@ static void skd_start_device(struct skd_device *skdev)
 		/*start the queue so we can respond with error to requests */
 		VPRINTK(skdev, "starting %s queue to error-out reqs\n",
 			skdev->name);
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
 		break;
@@ -4022,7 +3614,7 @@ static int skd_quiesce_dev(struct skd_device *skdev)
 	case SKD_DRVR_STATE_BUSY:
 	case SKD_DRVR_STATE_BUSY_IMMINENT:
 		VPRINTK(skdev, "stopping %s queue\n", skdev->name);
-		skd_stop_queue(skdev);
+		blk_stop_queue(skdev->queue);
 		break;
 	case SKD_DRVR_STATE_ONLINE:
 	case SKD_DRVR_STATE_STOPPING:
@@ -4086,7 +3678,7 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 		DPRINTK(skdev, "**** device ONLINE...starting block queue\n");
 		VPRINTK(skdev, "starting %s queue\n", skdev->name);
 		pr_info("(%s): STEC s1120 ONLINE\n", skd_name(skdev));
-		skd_start_queue(skdev);
+		blk_start_queue(skdev->queue);
 		skdev->gendisk_on = 1;
 		wake_up_interruptible(&skdev->waitq);
 		break;
@@ -4735,13 +4327,7 @@ static int skd_cons_disk(struct skd_device *skdev)
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
@@ -4751,11 +4337,6 @@ static int skd_cons_disk(struct skd_device *skdev)
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
@@ -4773,7 +4354,7 @@ static int skd_cons_disk(struct skd_device *skdev)
 
 	spin_lock_irqsave(&skdev->lock, flags);
 	VPRINTK(skdev, "stopping %s queue\n", skdev->name);
-	skd_stop_queue(skdev);
+	blk_stop_queue(skdev->queue);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 
 err_out:
@@ -4814,16 +4395,11 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	skdev->sgs_per_request = skd_sgs_per_request;
 	skdev->dbg_level = skd_dbg_level;
 
-	if (skd_bio)
-		bio_list_init(&skdev->bio_queue);
-
-
 	atomic_set(&skdev->device_count, 0);
 
 	spin_lock_init(&skdev->lock);
 
 	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
-	INIT_LIST_HEAD(&skdev->flush_list);
 
 	VPRINTK(skdev, "skcomp\n");
 	rc = skd_cons_skcomp(skdev);
@@ -5183,18 +4759,6 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	if (!skd_flush_slab) {
-		skd_flush_slab = kmem_cache_create(SKD_FLUSH_JOB,
-						  sizeof(struct skd_flush_cmd),
-						  0, 0, NULL);
-		if (!skd_flush_slab) {
-			pr_err("(%s): failed to allocate flush slab\n",
-			       pci_name(pdev));
-			rc = -ENOMEM;
-			goto err_out_regions;
-		}
-	}
-
 	if (!skd_major) {
 		rc = register_blkdev(0, DRV_NAME);
 		if (rc < 0)
@@ -5664,31 +5228,17 @@ static void skd_log_skreq(struct skd_device *skdev,
 	DPRINTK(skdev, "  timo=0x%x sg_dir=%d n_sg=%d\n",
 		skreq->timeout_stamp, skreq->sg_data_dir, skreq->n_sg);
 
-	if (!skd_bio) {
-		if (skreq->req != NULL) {
-			struct request *req = skreq->req;
-			u32 lba = (u32)blk_rq_pos(req);
-			u32 count = blk_rq_sectors(req);
-
-			DPRINTK(skdev,
-				"  req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				req, lba, lba, count, count,
-				(int)rq_data_dir(req));
-		} else
-			DPRINTK(skdev, "  req=NULL\n");
-	} else {
-		if (skreq->bio != NULL) {
-			struct bio *bio = skreq->bio;
-			u32 lba = (u32)bio->bi_sector;
-			u32 count = bio_sectors(bio);
+	if (skreq->req != NULL) {
+		struct request *req = skreq->req;
+		u32 lba = (u32)blk_rq_pos(req);
+		u32 count = blk_rq_sectors(req);
 
-			DPRINTK(skdev,
-				"  bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				bio, lba, lba, count, count,
-				(int)bio_data_dir(bio));
-		} else
-			DPRINTK(skdev, "  req=NULL\n");
-	}
+		DPRINTK(skdev,
+			"  req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
+			req, lba, lba, count, count,
+			(int)rq_data_dir(req));
+	} else
+		DPRINTK(skdev, "  req=NULL\n");
 }
 
 /*
@@ -5760,9 +5310,6 @@ static void __exit skd_exit(void)
 
 	if (skd_major)
 		unregister_blkdev(skd_major, DRV_NAME);
-
-	if (skd_flush_slab)
-		kmem_cache_destroy(skd_flush_slab);
 }
 
 module_init(skd_init);
-- 
1.8.2.3

