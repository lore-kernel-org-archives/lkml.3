Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbaFJAgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:36:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934307AbaFJAWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asias He <asias@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 44/88] virtio-blk: Fix hot-unplug race in remove method
Date: Mon,  9 Jun 2014 17:24:54 -0700
Message-Id: <20140610002425.995054794@linuxfoundation.org>
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

commit b79d866c8b7014a51f611a64c40546109beaf24a upstream.

If we reset the virtio-blk device before the requests already dispatched
to the virtio-blk driver from the block layer are finised, we will stuck
in blk_cleanup_queue() and the remove will fail.

blk_cleanup_queue() calls blk_drain_queue() to drain all requests queued
before DEAD marking. However it will never success if the device is
already stopped. We'll have q->in_flight[] > 0, so the drain will not
finish.

How to reproduce the race:
1. hot-plug a virtio-blk device
2. keep reading/writing the device in guest
3. hot-unplug while the device is busy serving I/O

Test:
~1000 rounds of hot-plug/hot-unplug test passed with this patch.

Changes in v3:
- Drop blk_abort_queue and blk_abort_request
- Use __blk_end_request_all to complete request dispatched to driver

Changes in v2:
- Drop req_in_flight
- Use virtqueue_detach_unused_buf to get request dispatched to driver

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -573,6 +573,8 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
+	struct virtblk_req *vbr;
+	unsigned long flags;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -585,6 +587,15 @@ static void __devexit virtblk_remove(str
 	flush_work(&vblk->config_work);
 
 	del_gendisk(vblk->disk);
+
+	/* Abort requests dispatched to driver. */
+	spin_lock_irqsave(&vblk->lock, flags);
+	while ((vbr = virtqueue_detach_unused_buf(vblk->vq))) {
+		__blk_end_request_all(vbr->req, -EIO);
+		mempool_free(vbr, vblk->pool);
+	}
+	spin_unlock_irqrestore(&vblk->lock, flags);
+
 	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);


