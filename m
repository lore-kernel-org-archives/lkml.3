Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaJEQDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaJEQDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:46 -0400
Date: Sun, 5 Oct 2014 19:07:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 08/16] virtio_net: drop config_enable
Message-ID: <1412525038-15871-9-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that virtio core ensures config changes don't arrive during probing,
drop config_enable flag in virtio net.
On removal, flush is now sufficient to guarantee that no change work is
queued.

This help simplify the driver, and will allow setting DRIVER_OK earlier
without losing config change notifications.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 59caa06..fa17afa 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -123,9 +123,6 @@ struct virtnet_info {
 	/* Host can handle any s/g split between our header and packet data */
 	bool any_header_sg;
 
-	/* enable config space updates */
-	bool config_enable;
-
 	/* Active statistics */
 	struct virtnet_stats __percpu *stats;
 
@@ -1408,9 +1405,6 @@ static void virtnet_config_changed_work(struct work_struct *work)
 	u16 v;
 
 	mutex_lock(&vi->config_lock);
-	if (!vi->config_enable)
-		goto done;
-
 	if (virtio_cread_feature(vi->vdev, VIRTIO_NET_F_STATUS,
 				 struct virtio_net_config, status, &v) < 0)
 		goto done;
@@ -1758,7 +1752,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 	}
 
 	mutex_init(&vi->config_lock);
-	vi->config_enable = true;
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
@@ -1876,16 +1869,12 @@ static void virtnet_remove(struct virtio_device *vdev)
 	unregister_hotcpu_notifier(&vi->nb);
 
 	/* Prevent config work handler from accessing the device. */
-	mutex_lock(&vi->config_lock);
-	vi->config_enable = false;
-	mutex_unlock(&vi->config_lock);
+	flush_work(&vi->config_work);
 
 	unregister_netdev(vi->dev);
 
 	remove_vq_common(vi);
 
-	flush_work(&vi->config_work);
-
 	free_percpu(vi->stats);
 	free_netdev(vi->dev);
 }
@@ -1899,9 +1888,7 @@ static int virtnet_freeze(struct virtio_device *vdev)
 	unregister_hotcpu_notifier(&vi->nb);
 
 	/* Prevent config work handler from accessing the device */
-	mutex_lock(&vi->config_lock);
-	vi->config_enable = false;
-	mutex_unlock(&vi->config_lock);
+	flush_work(&vi->config_work);
 
 	netif_device_detach(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
@@ -1916,8 +1903,6 @@ static int virtnet_freeze(struct virtio_device *vdev)
 
 	remove_vq_common(vi);
 
-	flush_work(&vi->config_work);
-
 	return 0;
 }
 
@@ -1941,10 +1926,6 @@ static int virtnet_restore(struct virtio_device *vdev)
 
 	netif_device_attach(vi->dev);
 
-	mutex_lock(&vi->config_lock);
-	vi->config_enable = true;
-	mutex_unlock(&vi->config_lock);
-
 	rtnl_lock();
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 	rtnl_unlock();
-- 
MST

