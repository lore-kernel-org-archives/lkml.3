Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967057AbaFQWaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:30:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966395AbaFQVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 180/212] virtio_blk: don't crash, report error if virtqueue is broken.
Date: Tue, 17 Jun 2014 14:44:34 -0700
Message-Id: <1403041506-13646-181-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 5261b85e586afe6ebe54e16e0a8acc32fc6d4902 upstream.

A bad implementation of virtio might cause us to mark the virtqueue
broken: we'll dev_err() in that case, and the device is useless, but
let's not BUG_ON().

ENOMEM or ENOSPC implies the ring is full, and we should try again
later (-ENOMEM is documented to happen, but doesn't, as we fall
through to ENOSPC).

EIO means it's broken.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/virtio_blk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a680d4..704d6c8 100644
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
1.9.1

