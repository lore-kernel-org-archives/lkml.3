Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3KAWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3KAWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 26/54] virtio-net: refill only when device is up during setting queues
Date: Fri,  1 Nov 2013 15:03:54 -0700
Message-Id: <20131101220214.274029278@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 35ed159bfd96a7547ec277ed8b550c7cbd9841b6 ]

We used to schedule the refill work unconditionally after changing the
number of queues. This may lead an issue if the device is not
up. Since we only try to cancel the work in ndo_stop(), this may cause
the refill work still work after removing the device. Fix this by only
schedule the work when device is up.

The bug were introduce by commit 9b9cd8024a2882e896c65222aa421d461354e3f2.
(virtio-net: fix the race between channels setting and refill)

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -916,7 +916,9 @@ static int virtnet_set_queues(struct vir
 		return -EINVAL;
 	} else {
 		vi->curr_queue_pairs = queue_pairs;
-		schedule_delayed_work(&vi->refill, 0);
+		/* virtnet_open() will refill when device is going to up. */
+		if (dev->flags & IFF_UP)
+			schedule_delayed_work(&vi->refill, 0);
 	}
 
 	return 0;
@@ -1714,7 +1716,9 @@ static int virtnet_restore(struct virtio
 	vi->config_enable = true;
 	mutex_unlock(&vi->config_lock);
 
+	rtnl_lock();
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
+	rtnl_unlock();
 
 	return 0;
 }


