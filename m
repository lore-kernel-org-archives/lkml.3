Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3EVFcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:32:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3EVFcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:32:41 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] virtio_net: enable napi after enabling new queues
Date: Wed, 22 May 2013 13:22:29 +0800
Message-Id: <1369200149-11280-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx
queues which are being used) forgets to enable napi for new enabled queues which
breaks the multiqueue receiving. This patch fixes it.

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2d6abac..9b2f59f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -914,9 +914,11 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 			 queue_pairs);
 		return -EINVAL;
 	} else {
-		for (i = vi->curr_queue_pairs; i < queue_pairs; i++)
+		for (i = vi->curr_queue_pairs; i < queue_pairs; i++) {
 			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
+			virtnet_napi_enable(&vi->rq[i]);
+		}
 		vi->curr_queue_pairs = queue_pairs;
 	}
 
-- 
1.7.1

