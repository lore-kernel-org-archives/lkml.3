Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaAOCm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:28 -0500
Received: from ozlabs.org ([203.10.76.45]:46279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaAOCmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/6] virtio-rng: don't crash if virtqueue is broken.
Date: Wed, 15 Jan 2014 13:06:09 +1030
Message-Id: <1389753371-26469-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bad implementation of virtio might cause us to mark the virtqueue
broken: we'll dev_err() in that case, and the device is useless, but
let's not BUG().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/virtio-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index c12398d1517c..2ce0e225e58c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -47,8 +47,7 @@ static void register_buffer(u8 *buf, size_t size)
 	sg_init_one(&sg, buf, size);
 
 	/* There should always be room for one buffer. */
-	if (virtqueue_add_inbuf(vq, &sg, 1, buf, GFP_KERNEL) < 0)
-		BUG();
+	virtqueue_add_inbuf(vq, &sg, 1, buf, GFP_KERNEL);
 
 	virtqueue_kick(vq);
 }
-- 
1.8.3.2

