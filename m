Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3BLMXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:23:52 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:36194 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab3BLMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:23:48 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/9] virtio: add functions for piecewise addition of buffers
Date: Tue, 12 Feb 2013 13:23:27 +0100
Message-Id: <1360671815-2135-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio device drivers translate requests from higher layer in two steps:
a device-specific step in the device driver, and generic preparation
of virtio direct or indirect buffers in virtqueue_add_buf.  Because
virtqueue_add_buf also accepts the outcome of the first step as a single
struct scatterlist, drivers may need to put additional items at the
front or back of the data scatterlists before handing it to virtqueue_add_buf.
Because of this, virtio-scsi has to copy each request into a scatterlist
internal to the driver.  It cannot just use the one that was prepared
by the upper SCSI layers. 

On top of this, virtqueue_add_buf also has the limitation of not
supporting chained scatterlists: the buffers must be provided as an
array of struct scatterlist.  Chained scatterlist, though not supported
on all architectures, would help for virtio-scsi where all additional
items are placed at the front.

This patch adds a different set of APIs for adding a buffer to a virtqueue.
The new API lets you pass the buffers piecewise, wrapping multiple calls
to virtqueue_add_sg between virtqueue_start_buf and virtqueue_end_buf.
virtio-scsi can then call virtqueue_add_sg 3/4 times: for the request
header, for the write buffer (if present), for the response header, and
finally for the read buffer (again if present).  It saves the copying
and the related locking.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/virtio/virtio_ring.c |  211 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |   14 +++
 2 files changed, 225 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..64184e5 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -101,6 +101,10 @@ struct vring_virtqueue
 	/* Last used index we've seen. */
 	u16 last_used_idx;
 
+	/* State between virtqueue_start_buf and virtqueue_end_buf.  */
+	int head;
+	struct vring_desc *indirect_base, *tail;
+
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
 
@@ -394,6 +398,213 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 	vq->vq.num_free++;
 }
 
+/**
+ * virtqueue_start_buf - start building buffer for the other end
+ * @vq: the struct virtqueue we're talking about.
+ * @data: the token identifying the buffer.
+ * @nents: the number of buffers that will be added
+ * @nsg: the number of sg lists that will be added
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted), and that a successful call is
+ * followed by one or more calls to virtqueue_add_sg, and finally a call
+ * to virtqueue_end_buf.
+ *
+ * Returns zero or a negative error (ie. ENOSPC).
+ */
+int virtqueue_start_buf(struct virtqueue *_vq,
+			void *data,
+			unsigned int nents,
+			unsigned int nsg,
+			gfp_t gfp)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct vring_desc *desc = NULL;
+	int head;
+	int ret = -ENOMEM;
+
+	START_USE(vq);
+
+	BUG_ON(data == NULL);
+
+#ifdef DEBUG
+	{
+		ktime_t now = ktime_get();
+
+		/* No kick or get, with .1 second between?  Warn. */
+		if (vq->last_add_time_valid)
+			WARN_ON(ktime_to_ms(ktime_sub(now, vq->last_add_time))
+					    > 100);
+		vq->last_add_time = now;
+		vq->last_add_time_valid = true;
+	}
+#endif
+
+	BUG_ON(nents < nsg);
+	BUG_ON(nsg == 0);
+
+	/*
+	 * If the host supports indirect descriptor tables, and there is
+	 * no space for direct buffers or there are multi-item scatterlists,
+	 * go indirect.
+	 */
+	head = vq->free_head;
+	if (vq->indirect && (nents > nsg || vq->vq.num_free < nents)) {
+		if (vq->vq.num_free == 0)
+			goto no_space;
+
+		desc = kmalloc(nents * sizeof(struct vring_desc), gfp);
+		if (!desc)
+			goto error;
+
+		/* We're about to use a buffer */
+		vq->vq.num_free--;
+
+		/* Use a single buffer which doesn't continue */
+		vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
+		vq->vring.desc[head].addr = virt_to_phys(desc);
+		vq->vring.desc[head].len = nents * sizeof(struct vring_desc);
+
+		/* Update free pointer */
+		vq->free_head = vq->vring.desc[head].next;
+	}
+
+	/* Set token. */
+	vq->data[head] = data;
+
+	pr_debug("Started buffer head %i for %p\n", head, vq);
+
+	vq->indirect_base = desc;
+	vq->tail = NULL;
+	vq->head = head;
+	return 0;
+
+no_space:
+	ret = -ENOSPC;
+error:
+	pr_debug("Can't add buf (%d) - nents = %i, avail = %i\n",
+		 ret, nents, vq->vq.num_free);
+	END_USE(vq);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtqueue_start_buf);
+
+/**
+ * virtqueue_add_sg - add sglist to buffer being built
+ * @_vq: the virtqueue for which the buffer is being built
+ * @sgl: the description of the buffer(s).
+ * @nents: the number of items to process in sgl
+ * @dir: whether the sgl is read or written (DMA_TO_DEVICE/DMA_FROM_DEVICE only)
+ *
+ * Note that, unlike virtqueue_add_buf, this function follows chained
+ * scatterlists, and stops before the @nents-th item if a scatterlist item
+ * has a marker.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ */
+void virtqueue_add_sg(struct virtqueue *_vq,
+		      struct scatterlist sgl[],
+		      unsigned int nents,
+		      enum dma_data_direction dir)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int i, n;
+	struct scatterlist *sg;
+	struct vring_desc *tail;
+	u32 flags;
+
+#ifdef DEBUG
+	BUG_ON(!vq->in_use);
+#endif
+
+	BUG_ON(dir != DMA_FROM_DEVICE && dir != DMA_TO_DEVICE);
+	BUG_ON(nents == 0);
+
+	flags = dir == DMA_FROM_DEVICE ? VRING_DESC_F_WRITE : 0;
+	flags |= VRING_DESC_F_NEXT;
+
+	/*
+	 * If using indirect descriptor tables, fill in the buffers
+	 * at vq->indirect_base.
+	 */
+	if (vq->indirect_base) {
+		i = 0;
+		if (likely(vq->tail))
+			i = vq->tail - vq->indirect_base + 1;
+
+		for_each_sg(sgl, sg, nents, n) {
+			tail = &vq->indirect_base[i];
+			tail->flags = flags;
+			tail->addr = sg_phys(sg);
+			tail->len = sg->length;
+			tail->next = ++i;
+		}
+	} else {
+		BUG_ON(vq->vq.num_free < nents);
+
+		i = vq->free_head;
+		for_each_sg(sgl, sg, nents, n) {
+			tail = &vq->vring.desc[i];
+			tail->flags = flags;
+			tail->addr = sg_phys(sg);
+			tail->len = sg->length;
+			i = tail->next;
+			vq->vq.num_free--;
+		}
+
+		vq->free_head = i;
+	}
+	vq->tail = tail;
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_sg);
+
+/**
+ * virtqueue_end_buf - expose buffer to other end
+ * @_vq: the virtqueue for which the buffer was built
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ */
+void virtqueue_end_buf(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int avail;
+	int head = vq->head;
+	struct vring_desc *tail = vq->tail;
+
+#ifdef DEBUG
+	BUG_ON(!vq->in_use);
+#endif
+	BUG_ON(tail == NULL);
+
+	/* The last one does not have the next flag set.  */
+	tail->flags &= ~VRING_DESC_F_NEXT;
+
+	/*
+	 * Put entry in available array.  Descriptors and available array
+	 * need to be set before we expose the new available array entries.
+	 */
+	avail = vq->vring.avail->idx & (vq->vring.num-1);
+	vq->vring.avail->ring[avail] = head;
+	virtio_wmb(vq);
+
+	vq->vring.avail->idx++;
+	vq->num_added++;
+
+	/*
+	 * This is very unlikely, but theoretically possible.  Kick
+	 * just in case.
+	 */
+	if (unlikely(vq->num_added == (1 << 16) - 1))
+		virtqueue_kick(&vq->vq);
+
+	pr_debug("Added buffer head %i to %p\n", head, vq);
+	END_USE(vq);
+}
+EXPORT_SYMBOL_GPL(virtqueue_end_buf);
+
 static inline bool more_used(const struct vring_virtqueue *vq)
 {
 	return vq->last_used_idx != vq->vring.used->idx;
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index cf8adb1..43d6bc3 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/dma-direction.h>
 #include <linux/gfp.h>
 
 /**
@@ -40,6 +41,19 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_start_buf(struct virtqueue *_vq,
+			void *data,
+			unsigned int nents,
+			unsigned int nsg,
+			gfp_t gfp);
+
+void virtqueue_add_sg(struct virtqueue *_vq,
+		      struct scatterlist sgl[],
+		      unsigned int nents,
+		      enum dma_data_direction dir);
+
+void virtqueue_end_buf(struct virtqueue *_vq);
+
 void virtqueue_kick(struct virtqueue *vq);
 
 bool virtqueue_kick_prepare(struct virtqueue *vq);
-- 
1.7.1


