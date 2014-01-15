Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaAOCmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:22 -0500
Received: from ozlabs.org ([203.10.76.45]:55927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbaAOCmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/6] virtio_blk: don't crash, report error if virtqueue is broken.
Date: Wed, 15 Jan 2014 13:06:07 +1030
Message-Id: <1389753371-26469-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bad implementation of virtio might cause us to mark the virtqueue
broken: we'll dev_err() in that case, and the device is useless, but
let's not BUG_ON().

ENOMEM or ENOSPC implies the ring is full, and we should try again
later (-ENOMEM is documented to happen, but doesn't, as we fall
through to ENOSPC).

EIO means it's broken.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a680d4de7f1..704d6c814c17 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -158,6 +158,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	unsigned long flags;
 	unsigned int num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
+	int err;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
@@ -198,11 +199,16 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	}
 
 	spin_lock_irqsave(&vblk->vq_lock, flags);
-	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
+	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
+	if (err) {
 		virtqueue_kick(vblk->vq);
 		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		blk_mq_stop_hw_queue(hctx);
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		/* Out of mem doesn't actually happen, since we fall back
+		 * to direct descriptors */
+		if (err == -ENOMEM || err == -ENOSPC)
+			return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
 	if (last)
-- 
1.8.3.2

