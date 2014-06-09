Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbaFIXKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:10:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbaFIWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 31/78] virtio_blk: fix race between start and stop queue
Date: Mon,  9 Jun 2014 15:48:11 -0700
Message-Id: <20140609224814.341955807@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit aa0818c6ee8d8e4772725a43550823347bc1ad30 upstream.

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
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/block/virtio_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -144,11 +144,11 @@ static void virtblk_done(struct virtqueu
 		if (unlikely(virtqueue_is_broken(vq)))
 			break;
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -200,8 +200,8 @@ static int virtio_queue_rq(struct blk_mq
 	spin_lock_irqsave(&vblk->vq_lock, flags);
 	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
 		virtqueue_kick(vblk->vq);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		blk_mq_stop_hw_queue(hctx);
+		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		return BLK_MQ_RQ_QUEUE_BUSY;
 	}
 


