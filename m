Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3BSIFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:05:23 -0500
Received: from ozlabs.org ([203.10.76.45]:48451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab3BSICs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 08/16] virtio_ring: virtqueue_add_outbuf / virtqueue_add_inbuf.
Date: Tue, 19 Feb 2013 18:26:26 +1030
Message-Id: <1361260594-601-9-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are specialized versions of virtqueue_add_buf(), which cover
over 50% of cases and are far clearer.

In particular, the scatterlists passed to these functions don't have
to be clean (ie. we ignore end markers).

FIXME: I'm not sure about the unclean sglist bit.  I had a more
ambitious one which conditionally ignored end markers in the iterator,
but it was ugly and I suspect this is just as fast.  Maybe we should
just fix all the drivers?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c |   58 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |   10 ++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c537385..fb282b5 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -345,6 +345,64 @@ int virtqueue_add_sgs(struct virtqueue *_vq,
 EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
 
 /**
+ * virtqueue_add_outbuf - expose output buffers to other end
+ * @vq: the struct virtqueue we're talking about.
+ * @sgs: array of scatterlists (need not be terminated!)
+ * @num: the number of scatterlists readable by other side
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ */
+int virtqueue_add_outbuf(struct virtqueue *vq,
+			 struct scatterlist sg[], unsigned int num,
+			 void *data,
+			 gfp_t gfp)
+{
+	unsigned int i;
+
+	/* We're about to iterate, so this is pretty cheap. */
+	for (i = 0; i < num - 1; i++)
+		sg_unmark_end(sg + i);
+	sg_mark_end(sg + i);
+
+	return virtqueue_add(vq, &sg, num, 1, 0, data, gfp);
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_outbuf);
+
+/**
+ * virtqueue_add_inbuf - expose input buffers to other end
+ * @vq: the struct virtqueue we're talking about.
+ * @sgs: array of scatterlists (need not be terminated!)
+ * @num: the number of scatterlists writable by other side
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ */
+int virtqueue_add_inbuf(struct virtqueue *vq,
+			struct scatterlist sg[], unsigned int num,
+			void *data,
+			gfp_t gfp)
+{
+	unsigned int i;
+
+	/* We're about to iterate, so this is pretty cheap. */
+	for (i = 0; i < num - 1; i++)
+		sg_unmark_end(sg + i);
+	sg_mark_end(sg + i);
+
+	return virtqueue_add(vq, &sg, num, 0, 1, data, gfp);
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
+
+/**
  * virtqueue_kick_prepare - first half of split virtqueue_kick call.
  * @vq: the struct virtqueue
  *
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 6eff15b..b442500 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -40,6 +40,16 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_add_outbuf(struct virtqueue *vq,
+			 struct scatterlist sg[], unsigned int num,
+			 void *data,
+			 gfp_t gfp);
+
+int virtqueue_add_inbuf(struct virtqueue *vq,
+			struct scatterlist sg[], unsigned int num,
+			void *data,
+			gfp_t gfp);
+
 int virtqueue_add_sgs(struct virtqueue *vq,
 		      struct scatterlist *sgs[],
 		      unsigned int out_sgs,
-- 
1.7.10.4

