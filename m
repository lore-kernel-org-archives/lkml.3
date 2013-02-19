Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3BSIDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:03:47 -0500
Received: from ozlabs.org ([203.10.76.45]:56812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab3BSICt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 14/16] virtio_rpmsg_bus: use simplified virtqueue accessors.
Date: Tue, 19 Feb 2013 18:26:32 +1030
Message-Id: <1361260594-601-15-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never add buffers with input and output parts, so use the new accessors.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f1e3239..d9897d1 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -763,14 +763,14 @@ int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
 	mutex_lock(&vrp->tx_lock);
 
 	/* add message to the remote processor's virtqueue */
-	err = virtqueue_add_buf(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
+	err = virtqueue_add_outbuf(vrp->svq, &sg, 1, msg, GFP_KERNEL);
 	if (err) {
 		/*
 		 * need to reclaim the buffer here, otherwise it's lost
 		 * (memory won't leak, but rpmsg won't use it again for TX).
 		 * this will wait for a buffer management overhaul.
 		 */
-		dev_err(dev, "virtqueue_add_buf failed: %d\n", err);
+		dev_err(dev, "virtqueue_add_outbuf failed: %d\n", err);
 		goto out;
 	}
 
@@ -845,7 +845,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
 
 	/* add the buffer back to the remote processor's virtqueue */
-	err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
+	err = virtqueue_add_inbuf(vrp->rvq, &sg, 1, msg, GFP_KERNEL);
 	if (err < 0) {
 		dev_err(dev, "failed to add a virtqueue buffer: %d\n", err);
 		return;
@@ -976,7 +976,7 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 		sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
 
-		err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, cpu_addr,
+		err = virtqueue_add_inbuf(vrp->rvq, &sg, 1, cpu_addr,
 								GFP_KERNEL);
 		WARN_ON(err); /* sanity check; this can't really happen */
 	}
-- 
1.7.10.4

