Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3JODTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab3JODTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:19:19 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH net V2 2/2] virtio-net: refill only when device is up during setting queues
Date: Tue, 15 Oct 2013 11:18:59 +0800
Message-Id: <1381807139-3450-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
References: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to schedule the refill work unconditionally after changing the
number of queues. This may lead an issue if the device is not
up. Since we only try to cancel the work in ndo_stop(), this may cause
the refill work still work after removing the device. Fix this by only
schedule the work when device is up.

The bug were introduce by commit 9b9cd8024a2882e896c65222aa421d461354e3f2.
(virtio-net: fix the race between channels setting and refill)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from v1: add missing rtnl_lock() in virtnet_restore().
The patch were need for 3.10 and above.
---
 drivers/net/virtio_net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c4bc1cc..9fbdfcd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -938,7 +938,9 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 		return -EINVAL;
 	} else {
 		vi->curr_queue_pairs = queue_pairs;
-		schedule_delayed_work(&vi->refill, 0);
+		/* virtnet_open() will refill when device is going to up. */
+		if (dev->flags & IFF_UP)
+			schedule_delayed_work(&vi->refill, 0);
 	}
 
 	return 0;
@@ -1741,7 +1743,9 @@ static int virtnet_restore(struct virtio_device *vdev)
 	vi->config_enable = true;
 	mutex_unlock(&vi->config_lock);
 
+	rtnl_lock();
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
+	rtnl_unlock();
 
 	return 0;
 }
-- 
1.8.1.2

