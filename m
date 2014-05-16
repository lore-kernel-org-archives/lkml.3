Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaEPPbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:31:53 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63302 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbaEPPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:31:52 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v1] virtio_blk: fix race between start and stop queue
Date: Fri, 16 May 2014 23:31:21 +0800
Message-Id: <1400254281-11294-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there isn't enough vring descriptor for adding to vq,
blk-mq will be put as stopped state until some of pending
descriptors are completed & freed.

Unfortunately, the vq's interrupt may come just before
blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
still be kept as stopped even though lots of descriptors
are completed and freed in the interrupt handler. The worst
case is that all pending descriptors are freed in the
interrupt handler, and the queue is kept as stopped forever.

This patch fixes the problem by starting/stopping blk-mq
with holding vq_lock.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
v1:
	- remove 'queue_stopped' flag

 drivers/block/virtio_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7a51f06..9f340fa 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -147,11 +147,11 @@ static void virtblk_done(struct virtqueue *vq)
 		if (unlikely(virtqueue_is_broken(vq)))
 			break;
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -205,8 +205,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
 	if (err) {
 		virtqueue_kick(vblk->vq);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		blk_mq_stop_hw_queue(hctx);
+		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
-- 
1.7.9.5

