Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaAOCmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:20 -0500
Received: from ozlabs.org ([203.10.76.45]:56455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaAOCmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/6] virtio_net: don't crash if virtqueue is broken.
Date: Wed, 15 Jan 2014 13:06:06 +1030
Message-Id: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bad implementation of virtio might cause us to mark the virtqueue
broken: we'll dev_err() in that case, and the device is useless, but
let's not BUG_ON().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/virtio_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5d776447d9c3..0949688ae540 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -904,8 +904,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	sgs[out_num + in_num++] = &stat;
 
 	BUG_ON(out_num + in_num > ARRAY_SIZE(sgs));
-	BUG_ON(virtqueue_add_sgs(vi->cvq, sgs, out_num, in_num, vi, GFP_ATOMIC)
-	       < 0);
+	virtqueue_add_sgs(vi->cvq, sgs, out_num, in_num, vi, GFP_ATOMIC);
 
 	if (unlikely(!virtqueue_kick(vi->cvq)))
 		return status == VIRTIO_NET_OK;
-- 
1.8.3.2

