Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3BSIDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:03:50 -0500
Received: from ozlabs.org ([203.10.76.45]:52148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab3BSICt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 12/16] virtio_console: use simplified virtqueue accessors.
Date: Tue, 19 Feb 2013 18:26:30 +1030
Message-Id: <1361260594-601-13-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never add buffers with input and output parts, so use the new accessors.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/virtio_console.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e905d5f..6d59f16 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -502,7 +502,7 @@ static int add_inbuf(struct virtqueue *vq, struct port_buffer *buf)
 
 	sg_init_one(sg, buf->buf, buf->size);
 
-	ret = virtqueue_add_buf(vq, sg, 0, 1, buf, GFP_ATOMIC);
+	ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
 	virtqueue_kick(vq);
 	if (!ret)
 		ret = vq->num_free;
@@ -569,7 +569,7 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
-	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) == 0) {
+	if (virtqueue_add_outbuf(vq, sg, 1, &cpkt, GFP_ATOMIC) == 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
@@ -618,7 +618,7 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
 
 	reclaim_consumed_buffers(port);
 
-	err = virtqueue_add_buf(out_vq, sg, nents, 0, data, GFP_ATOMIC);
+	err = virtqueue_add_outbuf(out_vq, sg, nents, data, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
-- 
1.7.10.4

