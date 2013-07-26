Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab3GZVlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:41:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3GZUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/79] virtio_net: fix race in RX VQ processing
Date: Fri, 26 Jul 2013 13:47:09 -0700
Message-Id: <20130726204723.956415614@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit cbdadbbf0c790f79350a8f36029208944c5487d0 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -602,7 +602,7 @@ static int virtnet_poll(struct napi_stru
 		container_of(napi, struct receive_queue, napi);
 	struct virtnet_info *vi = rq->vq->vdev->priv;
 	void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -619,8 +619,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(rq->vq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(rq->vq)) &&
+		if (unlikely(virtqueue_poll(rq->vq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(rq->vq);
 			__napi_schedule(napi);


