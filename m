Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaGWIeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:34:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbaGWIeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:34:14 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 1/2] virtio-net: introduce virtnet_receive()
Date: Wed, 23 Jul 2014 16:33:54 +0800
Message-Id: <1406104435-24077-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1406104435-24077-1-git-send-email-jasowang@redhat.com>
References: <1406104435-24077-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common receive logic to a new helper virtnet_receive(). It will
also be used by rx busy polling method.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7d9f84a..b647d0d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -725,15 +725,12 @@ static void refill_work(struct work_struct *work)
 	}
 }
 
-static int virtnet_poll(struct napi_struct *napi, int budget)
+static int virtnet_receive(struct receive_queue *rq, int budget)
 {
-	struct receive_queue *rq =
-		container_of(napi, struct receive_queue, napi);
 	struct virtnet_info *vi = rq->vq->vdev->priv;
+	unsigned int len, received = 0;
 	void *buf;
-	unsigned int r, len, received = 0;
 
-again:
 	while (received < budget &&
 	       (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
 		receive_buf(rq, buf, len);
@@ -745,6 +742,18 @@ again:
 			schedule_delayed_work(&vi->refill, 0);
 	}
 
+	return received;
+}
+
+static int virtnet_poll(struct napi_struct *napi, int budget)
+{
+	struct receive_queue *rq =
+		container_of(napi, struct receive_queue, napi);
+	unsigned int r, received = 0;
+
+again:
+	received += virtnet_receive(rq, budget - received);
+
 	/* Out of packets? */
 	if (received < budget) {
 		r = virtqueue_enable_cb_prepare(rq->vq);
-- 
1.8.3.1

