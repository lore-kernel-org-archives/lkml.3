Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbaFJAWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933828AbaFJAWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 46/88] virtio-blk: Reset device after blk_cleanup_queue()
Date: Mon,  9 Jun 2014 17:24:56 -0700
Message-Id: <20140610002426.053960938@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 483001c765af6892b3fc3726576cb42f17d1d6b5 upstream.

blk_cleanup_queue() will call blk_drian_queue() to drain all the
requests before queue DEAD marking. If we reset the device before
blk_cleanup_queue() the drain would fail.

1) if the queue is stopped in do_virtblk_request() because device is
full, the q->request_fn() will not be called.

blk_drain_queue() {
   while(true) {
      ...
      if (!list_empty(&q->queue_head))
        __blk_run_queue(q) {
	    if (queue is not stoped)
		q->request_fn()
	}
      ...
   }
}

Do no reset the device before blk_cleanup_queue() gives the chance to
start the queue in interrupt handler blk_done().

2) In commit b79d866c8b7014a51f611a64c40546109beaf24a, We abort requests
dispatched to driver before blk_cleanup_queue(). There is a race if
requests are dispatched to driver after the abort and before the queue
DEAD mark. To fix this, instead of aborting the requests explicitly, we
can just reset the device after after blk_cleanup_queue so that the
device can complete all the requests before queue DEAD marking in the
drain process.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Asias He <asias@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -573,8 +573,6 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
-	struct virtblk_req *vbr;
-	unsigned long flags;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -582,21 +580,13 @@ static void __devexit virtblk_remove(str
 	mutex_unlock(&vblk->config_lock);
 
 	del_gendisk(vblk->disk);
+	blk_cleanup_queue(vblk->disk->queue);
 
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
 	flush_work(&vblk->config_work);
 
-	/* Abort requests dispatched to driver. */
-	spin_lock_irqsave(&vblk->lock, flags);
-	while ((vbr = virtqueue_detach_unused_buf(vblk->vq))) {
-		__blk_end_request_all(vbr->req, -EIO);
-		mempool_free(vbr, vblk->pool);
-	}
-	spin_unlock_irqrestore(&vblk->lock, flags);
-
-	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);


