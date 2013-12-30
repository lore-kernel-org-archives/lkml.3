Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3L3DfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:35:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3L3DfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:35:05 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] virtio-net: fix refill races during restore
Date: Mon, 30 Dec 2013 11:34:40 +0800
Message-Id: <1388374480-3872-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During restoring, try_fill_recv() was called with neither napi lock nor napi
disabled. This can lead two try_fill_recv() was called in the same time. Fix
this by refilling before trying to enable napi.

Fixes 0741bcb5584f9e2390ae6261573c4de8314999f2
(virtio: net: Add freeze, restore handlers to support S4).

Cc: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d208f86..5d77644 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1797,16 +1797,17 @@ static int virtnet_restore(struct virtio_device *vdev)
 	if (err)
 		return err;
 
-	if (netif_running(vi->dev))
+	if (netif_running(vi->dev)) {
+		for (i = 0; i < vi->curr_queue_pairs; i++)
+			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
+				schedule_delayed_work(&vi->refill, 0);
+
 		for (i = 0; i < vi->max_queue_pairs; i++)
 			virtnet_napi_enable(&vi->rq[i]);
+	}
 
 	netif_device_attach(vi->dev);
 
-	for (i = 0; i < vi->curr_queue_pairs; i++)
-		if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
-			schedule_delayed_work(&vi->refill, 0);
-
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = true;
 	mutex_unlock(&vi->config_lock);
-- 
1.8.3.2

