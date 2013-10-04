Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3JDNu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3JDNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:22 -0400
Message-Id: <20131004135015.106146266@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 04 Oct 2013 06:49:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] [PATCH 5/5] block: use blk-exec.c infrastructure for blk-mq
References: <20131004134908.231874670@bombadil.infradead.org>
Content-Disposition: inline; filename=0005-block-use-blk-exec.c-infrastructure-for-blk-mq.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to reinvent blk_execute_rq for blk-mq if we can easily
reuse the sync and async versions already present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c           |    7 +++++++
 block/blk-mq.c             |   36 ------------------------------------
 drivers/block/virtio_blk.c |    5 ++++-
 include/linux/blk-mq.h     |    1 -
 4 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 7972da7..47aef02 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/sched/sysctl.h>
 
 #include "blk.h"
@@ -58,6 +59,12 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
+
+	if (q->mq_ops) {
+		blk_mq_insert_request(q, rq, true);
+		return;
+	}
+
 	/*
 	 * need to check this before __blk_run_queue(), because rq can
 	 * be freed before that returns.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 709747f..dece2e2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -958,42 +958,6 @@ run_queue:
 	blk_mq_run_hw_queue(hctx, !is_sync || is_flush_fua);
 }
 
-static void blk_mq_execute_end_io(struct request *rq, int error)
-{
-	struct completion *wait = rq->end_io_data;
-
-	complete(wait);
-}
-
-/*
- * Insert request, pass to device, and wait for it to finish.
- */
-int blk_mq_execute_rq(struct request_queue *q, struct request *rq)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	unsigned long hang_check;
-	int err = 0;
-
-	rq->end_io_data = &wait;
-	rq->end_io = blk_mq_execute_end_io;
-	blk_mq_insert_request(q, rq, true);
-
-	/* Prevent hang_check timer from firing at us during very long I/O */
-	hang_check = sysctl_hung_task_timeout_secs;
-	if (hang_check)
-		while (!wait_for_completion_io_timeout(&wait, hang_check * (HZ/2)));
-	else
-		wait_for_completion_io(&wait);
-
-	if (rq->errors)
-		err = -EIO;
-
-	blk_mq_finish_request(rq, rq->errors);
-
-	return err;
-}
-EXPORT_SYMBOL(blk_mq_execute_rq);
-
 /*
  * Default mapping to a software queue, since we use one per CPU.
  */
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e0b1115..0352df1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -410,6 +410,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	struct virtio_blk *vblk = disk->private_data;
 	struct request *req;
 	struct bio *bio;
+	int err;
 
 	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
 			   GFP_KERNEL);
@@ -423,7 +424,9 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	}
 
 	req->cmd_type = REQ_TYPE_SPECIAL;
-	return blk_mq_execute_rq(vblk->disk->queue, req);
+	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	blk_put_request(req);
+	return err;
 }
 
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2fea261..4fddab2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -121,7 +121,6 @@ void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struc
 void blk_mq_flush_plug(struct request_queue *, bool);
 void blk_mq_insert_request(struct request_queue *, struct request *, bool);
 void blk_mq_insert_requests(struct request_queue *, struct list_head *, bool, bool);
-int blk_mq_execute_rq(struct request_queue *, struct request *);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-- 
1.7.10.4


