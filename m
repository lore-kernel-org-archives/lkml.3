Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaJEQGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaJEQDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:48 -0400
Date: Sun, 5 Oct 2014 19:07:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 09/16] virtio-net: drop config_mutex
Message-ID: <1412525038-15871-10-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config_mutex served two purposes: prevent multiple concurrent config
change handlers, and synchronize access to config_enable flag.

Since commit dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1
    workqueue: make all workqueues non-reentrant
all workqueues are non-reentrant, and config_enable
is now gone.

Get rid of the unnecessary lock.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fa17afa..d80fef4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -132,9 +132,6 @@ struct virtnet_info {
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
-	/* Lock for config space updates */
-	struct mutex config_lock;
-
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
@@ -1404,7 +1401,6 @@ static void virtnet_config_changed_work(struct work_struct *work)
 		container_of(work, struct virtnet_info, config_work);
 	u16 v;
 
-	mutex_lock(&vi->config_lock);
 	if (virtio_cread_feature(vi->vdev, VIRTIO_NET_F_STATUS,
 				 struct virtio_net_config, status, &v) < 0)
 		goto done;
@@ -1430,7 +1426,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
 		netif_tx_stop_all_queues(vi->dev);
 	}
 done:
-	mutex_unlock(&vi->config_lock);
+	return;
 }
 
 static void virtnet_config_changed(struct virtio_device *vdev)
@@ -1751,7 +1747,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 		u64_stats_init(&virtnet_stats->rx_syncp);
 	}
 
-	mutex_init(&vi->config_lock);
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
-- 
MST

