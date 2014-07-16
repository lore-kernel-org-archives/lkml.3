Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708AbaGPGWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934633AbaGPGWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:22:06 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next V2 2/3] virtio-net: introduce virtnet_receive()
Date: Wed, 16 Jul 2014 14:21:46 +0800
Message-Id: <1405491707-22706-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
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
 drivers/net/virtio_net.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e1e1691..e417d93 100644
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
+	received += virtnet_receive(rq, budget);
+
 	/* Out of packets? */
 	if (received < budget) {
 		r = virtqueue_enable_cb_prepare(rq->vq);
@@ -753,6 +762,7 @@ again:
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(rq->vq);
 			__napi_schedule(napi);
+			budget -= received;
 			goto again;
 		}
 	}
-- 
1.8.3.1

