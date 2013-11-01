Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3KAWEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:04:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab3KAWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 3.10 25/54] virtio-net: fix the race between channels setting and refill
Date: Fri,  1 Nov 2013 15:03:53 -0700
Message-Id: <20131101220214.144682621@linuxfoundation.org>
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

[ Upstream commit 9b9cd8024a2882e896c65222aa421d461354e3f2 ]

Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx queues
which are being used) tries to refill on demand when changing the number of
channels by call try_refill_recv() directly, this may race:

- the refill work who may do the refill in the same time
- the try_refill_recv() called in bh since napi was not disabled

Which may led guest complain during setting channels:

virtio_net virtio0: input.1:id 0 is not a head!

Solve this issue by scheduling a refill work which can guarantee the
serialization of refill.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -902,7 +902,6 @@ static int virtnet_set_queues(struct vir
 	struct scatterlist sg;
 	struct virtio_net_ctrl_mq s;
 	struct net_device *dev = vi->dev;
-	int i;
 
 	if (!vi->has_cvq || !virtio_has_feature(vi->vdev, VIRTIO_NET_F_MQ))
 		return 0;
@@ -916,10 +915,8 @@ static int virtnet_set_queues(struct vir
 			 queue_pairs);
 		return -EINVAL;
 	} else {
-		for (i = vi->curr_queue_pairs; i < queue_pairs; i++)
-			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
 		vi->curr_queue_pairs = queue_pairs;
+		schedule_delayed_work(&vi->refill, 0);
 	}
 
 	return 0;


