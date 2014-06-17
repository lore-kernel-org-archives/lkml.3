Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967169AbaFQWWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:22:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966603AbaFQVua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 181/212] virtio_blk: fix race between start and stop queue
Date: Tue, 17 Jun 2014 14:44:35 -0700
Message-Id: <1403041506-13646-182-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/virtio_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 704d6c8..9b734f2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -144,11 +144,11 @@ static void virtblk_done(struct virtqueue *vq)
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
@@ -202,8 +202,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
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
1.9.1

