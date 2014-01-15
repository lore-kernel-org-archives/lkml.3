Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaAOWgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:36:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaAOVy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 163/166] virtio-net: fix refill races during restore
Date: Wed, 15 Jan 2014 13:52:57 -0800
Message-Id: <1389822780-4729-164-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 6cd4ce0099da7702f885b6fa9ebb49e3831d90b4 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/virtio_net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8f009899..4380036 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1723,16 +1723,17 @@ static int virtnet_restore(struct virtio_device *vdev)
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
 
-	for (i = 0; i < vi->max_queue_pairs; i++)
-		if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
-			schedule_delayed_work(&vi->refill, 0);
-
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = true;
 	mutex_unlock(&vi->config_lock);
-- 
1.8.3.2

