Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3BLMYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:24:11 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:48525 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3BLMYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:24:07 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 8/9] virtio: introduce and use virtqueue_add_buf_single
Date: Tue, 12 Feb 2013 13:23:34 +0100
Message-Id: <1360671815-2135-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a single direct buffer is a very common case.  Introduce
an optimized function for that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c |    2 +-
 drivers/char/virtio_console.c       |    4 +-
 drivers/net/virtio_net.c            |    2 +-
 drivers/rpmsg/virtio_rpmsg_bus.c    |    8 +++---
 drivers/scsi/virtio_scsi.c          |    4 +-
 drivers/virtio/virtio_balloon.c     |    6 ++--
 drivers/virtio/virtio_ring.c        |   40 +++++++++++++++++++++++++++++++++++
 include/linux/virtio.h              |    5 ++++
 tools/virtio/virtio_test.c          |    6 ++--
 9 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index b65c103..8b851ed 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -47,7 +47,7 @@ static void register_buffer(u8 *buf, size_t size)
 	sg_init_one(&sg, buf, size);
 
 	/* There should always be room for one buffer. */
-	if (virtqueue_add_buf(vq, &sg, 0, 1, buf, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf_single(vq, &sg, DMA_FROM_DEVICE, buf) < 0)
 		BUG();
 
 	virtqueue_kick(vq);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 684b0d5..62bd945 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -508,7 +508,7 @@ static int add_inbuf(struct virtqueue *vq, struct port_buffer *buf)
 
 	sg_init_one(sg, buf->buf, buf->size);
 
-	ret = virtqueue_add_buf(vq, sg, 0, 1, buf, GFP_ATOMIC);
+	ret = virtqueue_add_buf_single(vq, sg, DMA_FROM_DEVICE, buf);
 	virtqueue_kick(vq);
 	if (!ret)
 		ret = vq->num_free;
@@ -575,7 +575,7 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
-	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) == 0) {
+	if (virtqueue_add_buf_single(vq, sg, DMA_TO_DEVICE, &cpkt) == 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 78b6f51..1a5186d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -509,7 +509,7 @@ static int add_recvbuf_mergeable(struct receive_queue *rq, gfp_t gfp)
 		return -ENOMEM;
 
 	sg_set_page(rq->sg, page, PAGE_SIZE, 0);
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 1, page, gfp);
+	err = virtqueue_add_buf_single(rq->vq, rq->sg, DMA_FROM_DEVICE, page);
 	if (err < 0)
 		give_pages(rq, page);
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f1e3239..3008987 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -763,7 +763,7 @@ int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
 	mutex_lock(&vrp->tx_lock);
 
 	/* add message to the remote processor's virtqueue */
-	err = virtqueue_add_buf(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
+	err = virtqueue_add_buf_single(vrp->svq, &sg, DMA_TO_DEVICE, msg);
 	if (err) {
 		/*
 		 * need to reclaim the buffer here, otherwise it's lost
@@ -845,7 +845,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
 
 	/* add the buffer back to the remote processor's virtqueue */
-	err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
+	err = virtqueue_add_buf_single(vrp->rvq, &sg, DMA_FROM_DEVICE, msg);
 	if (err < 0) {
 		dev_err(dev, "failed to add a virtqueue buffer: %d\n", err);
 		return;
@@ -976,8 +976,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 		sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
 
-		err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, cpu_addr,
-								GFP_KERNEL);
+		err = virtqueue_add_buf_single(vrp->rvq, &sg, DMA_FROM_DEVICE,
+					       cpu_addr);
 		WARN_ON(err); /* sanity check; this can't really happen */
 	}
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 6b752f7..887902e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -220,8 +220,8 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-	err = virtqueue_add_buf(vscsi->event_vq.vq, &sg, 0, 1, event_node,
-				GFP_ATOMIC);
+	err = virtqueue_add_buf_single(vscsi->event_vq.vq, &sg,
+				       DMA_FROM_DEVICE, event_node);
 	if (!err)
 		virtqueue_kick(vscsi->event_vq.vq);
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 797e1c7..c280948 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -108,7 +108,7 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf_single(vq, &sg, DMA_TO_DEVICE, vb) < 0)
 		BUG();
 	virtqueue_kick(vq);
 
@@ -256,7 +256,7 @@ static void stats_handle_request(struct virtio_balloon *vb)
 	if (!virtqueue_get_buf(vq, &len))
 		return;
 	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf_single(vq, &sg, DMA_TO_DEVICE, vb) < 0)
 		BUG();
 	virtqueue_kick(vq);
 }
@@ -341,7 +341,7 @@ static int init_vqs(struct virtio_balloon *vb)
 		 * use it to signal us later.
 		 */
 		sg_init_one(&sg, vb->stats, sizeof vb->stats);
-		if (virtqueue_add_buf(vb->stats_vq, &sg, 1, 0, vb, GFP_KERNEL)
+		if (virtqueue_add_buf_single(vb->stats_vq, &sg, DMA_TO_DEVICE, vb)
 		    < 0)
 			BUG();
 		virtqueue_kick(vb->stats_vq);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 64184e5..b803cf7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -181,6 +181,48 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 }
 
 /**
+ * virtqueue_add_buf_single - expose a single scatterlist entry to other end
+ * @vq: the struct virtqueue we're talking about.
+ * @sg: the description of the buffer.
+ * @dir: whether the buffer will be written or read by the device
+ * @data: the token identifying the buffer.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).  No allocations are performed.
+ *
+ * Returns zero or a negative error (ENOSPC).
+ */
+int virtqueue_add_buf_single(struct virtqueue *_vq,
+			     struct scatterlist *sg,
+			     enum dma_data_direction dir,
+			     void *data)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct vring_desc *tail;
+	int ret;
+
+	/* Always direct, the gfp argument is not used.  */
+	ret = virtqueue_start_buf(_vq, data, 1, 1, GFP_ATOMIC);
+	if (ret < 0)
+		return ret;
+
+	BUG_ON(vq->indirect_base);
+	BUG_ON(dir != DMA_FROM_DEVICE && dir != DMA_TO_DEVICE);
+
+	/* The direct case of virtqueue_add_sg, inlined.  */
+	tail = vq->tail = &vq->vring.desc[vq->free_head];
+	tail->flags = dir == DMA_FROM_DEVICE ? VRING_DESC_F_WRITE : 0;
+	tail->addr = sg_phys(sg);
+	tail->len = sg->length;
+	vq->free_head = tail->next;
+	vq->vq.num_free--;
+
+	virtqueue_end_buf(_vq);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_buf_single);
+
+/**
  * virtqueue_add_buf - expose buffer to other end
  * @vq: the struct virtqueue we're talking about.
  * @sg: the description of the buffer(s).
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 43d6bc3..4245bec 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -41,6 +41,11 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_add_buf_single(struct virtqueue *vq,
+			     struct scatterlist *sg,
+			     enum dma_data_direction dir,
+			     void *data);
+
 int virtqueue_start_buf(struct virtqueue *_vq,
 			void *data,
 			unsigned int nents,
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index fcc9aa2..727b6a1 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -161,9 +161,9 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
 		do {
 			if (started < bufs) {
 				sg_init_one(&sl, dev->buf, dev->buf_size);
-				r = virtqueue_add_buf(vq->vq, &sl, 1, 0,
-						      dev->buf + started,
-						      GFP_ATOMIC);
+				r = virtqueue_add_buf_single(vq->vq, &sl,
+						      DMA_TO_DEVICE,
+						      dev->buf + started);
 				if (likely(r == 0)) {
 					++started;
 					virtqueue_kick(vq->vq);
-- 
1.7.1


