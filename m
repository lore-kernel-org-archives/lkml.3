Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657AbaGPGWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934631AbaGPGWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:22:03 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next V2 1/3] virtio-net: introduce helpers to enable and disable all NAPIs
Date: Wed, 16 Jul 2014 14:21:45 +0800
Message-Id: <1405491707-22706-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces helpers to disable and enable NAPI for all rx
queues. This will be used by rx busy polling support.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7d9f84a..e1e1691 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -760,6 +760,22 @@ again:
 	return received;
 }
 
+static void virtnet_napi_enable_all(struct virtnet_info *vi)
+{
+	int i;
+
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		virtnet_napi_enable(&vi->rq[i]);
+}
+
+static void virtnet_napi_disable_all(struct virtnet_info *vi)
+{
+	int i;
+
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		napi_disable(&vi->rq[i].napi);
+}
+
 static int virtnet_open(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -770,9 +786,10 @@ static int virtnet_open(struct net_device *dev)
 			/* Make sure we have some buffers: if oom use wq. */
 			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
-		virtnet_napi_enable(&vi->rq[i]);
 	}
 
+	virtnet_napi_enable_all(vi);
+
 	return 0;
 }
 
@@ -1076,13 +1093,11 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 static int virtnet_close(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	int i;
 
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
-	for (i = 0; i < vi->max_queue_pairs; i++)
-		napi_disable(&vi->rq[i].napi);
+	virtnet_napi_disable_all(vi);
 
 	return 0;
 }
@@ -1853,11 +1868,11 @@ static int virtnet_freeze(struct virtio_device *vdev)
 	netif_device_detach(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
 
-	if (netif_running(vi->dev))
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
+	if (netif_running(vi->dev)) {
+		virtnet_napi_disable_all(vi);
+		for (i = 0; i < vi->max_queue_pairs; i++)
 			netif_napi_del(&vi->rq[i].napi);
-		}
+	}
 
 	remove_vq_common(vi);
 
@@ -1880,8 +1895,7 @@ static int virtnet_restore(struct virtio_device *vdev)
 			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
 
-		for (i = 0; i < vi->max_queue_pairs; i++)
-			virtnet_napi_enable(&vi->rq[i]);
+		virtnet_napi_enable_all(vi);
 	}
 
 	netif_device_attach(vi->dev);
-- 
1.8.3.1

