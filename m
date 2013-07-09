Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3GIFMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab3GIFLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:11:54 -0400
Date: Tue, 9 Jul 2013 08:13:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] virtio_net: fix race in RX VQ processing
Message-ID: <1373346713-442-3-git-send-email-mst@redhat.com>
References: <1373346713-442-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373346713-442-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio net called virtqueue_enable_cq on RX path after napi_complete, so
with NAPI_STATE_SCHED clear - outside the implicit napi lock.
This violates the requirement to synchronize virtqueue_enable_cq wrt
virtqueue_add_buf.  In particular, used event can move backwards,
causing us to lose interrupts.
In a debug build, this can trigger panic within START_USE.

Jason Wang reports that he can trigger the races artificially,
by adding udelay() in virtqueue_enable_cb() after virtio_mb().

However, we must call napi_complete to clear NAPI_STATE_SCHED before
polling the virtqueue for used buffers, otherwise napi_schedule_prep in
a callback will fail, causing us to lose RX events.

To fix, call virtqueue_enable_cb_prepare with NAPI_STATE_SCHED
set (under napi lock), later call virtqueue_poll with
NAPI_STATE_SCHED clear (outside the lock).

Reported-by: Jason Wang <jasowang@redhat.com>
Tested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5305bd1..27f79dd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -605,7 +605,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 		container_of(napi, struct receive_queue, napi);
 	struct virtnet_info *vi = rq->vq->vdev->priv;
 	void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -622,8 +622,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(rq->vq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(rq->vq)) &&
+		if (unlikely(virtqueue_poll(rq->vq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(rq->vq);
 			__napi_schedule(napi);
-- 
MST

