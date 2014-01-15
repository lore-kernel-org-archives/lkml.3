Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaAOCmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:25 -0500
Received: from ozlabs.org ([203.10.76.45]:42102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaAOCmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/6] virtio_balloon: don't crash if virtqueue is broken.
Date: Wed, 15 Jan 2014 13:06:08 +1030
Message-Id: <1389753371-26469-3-git-send-email-rusty@rustcorp.com.au>
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
 drivers/virtio/virtio_balloon.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5c4a95b516cf..fc1fb27dca49 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -108,8 +108,7 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL) < 0)
-		BUG();
+	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
@@ -258,8 +257,7 @@ static void stats_handle_request(struct virtio_balloon *vb)
 	if (!virtqueue_get_buf(vq, &len))
 		return;
 	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
-	if (virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL) < 0)
-		BUG();
+	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
 	virtqueue_kick(vq);
 }
 
@@ -338,7 +336,7 @@ static int init_vqs(struct virtio_balloon *vb)
 
 		/*
 		 * Prime this virtqueue with one buffer so the hypervisor can
-		 * use it to signal us later.
+		 * use it to signal us later (it can't be broken yet!).
 		 */
 		sg_init_one(&sg, vb->stats, sizeof vb->stats);
 		if (virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL)
-- 
1.8.3.2

