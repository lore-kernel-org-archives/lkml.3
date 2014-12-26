Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLZCyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 21:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLZCyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 21:54:04 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 1/3] virtio-pci: introduce channels
Date: Fri, 26 Dec 2014 10:53:43 +0800
Message-Id: <1419562425-20614-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce virtio pci channel which are virtqueue groups
that sharing a single MSIX irq. This can be used to reduce the irqs
needed by virtio device.

The channel are in fact a list of virtqueues, and
vp_channel_interrupt() was introduced to traverse the list. The
current strategy was kept but is converted to channel internally:

- per vq vectors was implemented through per vq channel
- sharing interrupts was implemented through a single channel for all
  virtqueues

This is done by letting vp_try_to_find_vqs() to accept the array of
channel names and the channels that each vq belongs to.

Virtio-net will be the first user.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 193 ++++++++++++++++++++++---------------
 drivers/virtio/virtio_pci_common.h |  14 ++-
 2 files changed, 124 insertions(+), 83 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 2ef9529..36db4ac 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -68,6 +68,23 @@ static irqreturn_t vp_vring_interrupt(int irq, void *opaque)
 	return ret;
 }
 
+static irqreturn_t vp_channel_interrupt(int irq, void *opaque)
+{
+	struct virtio_pci_channel *vp_channel = opaque;
+	struct virtio_pci_vq_info *info;
+	irqreturn_t ret = IRQ_NONE;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vp_channel->lock, flags);
+	list_for_each_entry(info, &vp_channel->virtqueues, node) {
+		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&vp_channel->lock, flags);
+
+	return ret;
+}
+
 /* A small wrapper to also acknowledge the interrupt when it's handled.
  * I really need an EIO hook for the vring so I can ack the interrupt once we
  * know that we'll be handling the IRQ but before we invoke the callback since
@@ -104,8 +121,12 @@ static void vp_free_vectors(struct virtio_device *vdev)
 		vp_dev->intx_enabled = 0;
 	}
 
-	for (i = 0; i < vp_dev->msix_used_vectors; ++i)
-		free_irq(vp_dev->msix_entries[i].vector, vp_dev);
+	if (vp_dev->msix_used_vectors)
+		free_irq(vp_dev->msix_entries[0].vector, vp_dev);
+
+	for (i = 1; i < vp_dev->msix_used_vectors; ++i)
+		free_irq(vp_dev->msix_entries[i].vector,
+			 &vp_dev->channels[i - 1]);
 
 	for (i = 0; i < vp_dev->msix_vectors; i++)
 		if (vp_dev->msix_affinity_masks[i])
@@ -119,6 +140,7 @@ static void vp_free_vectors(struct virtio_device *vdev)
 		vp_dev->msix_enabled = 0;
 	}
 
+
 	vp_dev->msix_vectors = 0;
 	vp_dev->msix_used_vectors = 0;
 	kfree(vp_dev->msix_names);
@@ -129,8 +151,7 @@ static void vp_free_vectors(struct virtio_device *vdev)
 	vp_dev->msix_affinity_masks = NULL;
 }
 
-static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
-				   bool per_vq_vectors)
+static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	const char *name = dev_name(&vp_dev->vdev.dev);
@@ -167,8 +188,8 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	vp_dev->msix_enabled = 1;
 
 	/* Set the vector used for configuration */
-	v = vp_dev->msix_used_vectors;
-	snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
+	v = 0;
+	snprintf(vp_dev->msix_names[0], sizeof(*vp_dev->msix_names),
 		 "%s-config", name);
 	err = request_irq(vp_dev->msix_entries[v].vector,
 			  vp_config_changed, 0, vp_dev->msix_names[v],
@@ -184,18 +205,6 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 		goto error;
 	}
 
-	if (!per_vq_vectors) {
-		/* Shared vector for all VQs */
-		v = vp_dev->msix_used_vectors;
-		snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
-			 "%s-virtqueues", name);
-		err = request_irq(vp_dev->msix_entries[v].vector,
-				  vp_vring_interrupt, 0, vp_dev->msix_names[v],
-				  vp_dev);
-		if (err)
-			goto error;
-		++vp_dev->msix_used_vectors;
-	}
 	return 0;
 error:
 	vp_free_vectors(vdev);
@@ -220,6 +229,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 				     u16 msix_vec)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_channel *vp_channel;
 	struct virtio_pci_vq_info *info = kmalloc(sizeof *info, GFP_KERNEL);
 	struct virtqueue *vq;
 	unsigned long flags;
@@ -234,9 +244,16 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 
 	info->vq = vq;
 	if (callback) {
-		spin_lock_irqsave(&vp_dev->lock, flags);
-		list_add(&info->node, &vp_dev->virtqueues);
-		spin_unlock_irqrestore(&vp_dev->lock, flags);
+		if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
+			vp_channel = &vp_dev->channels[msix_vec - 1];
+			spin_lock_irqsave(&vp_channel->lock, flags);
+			list_add(&info->node, &vp_channel->virtqueues);
+			spin_unlock_irqrestore(&vp_channel->lock, flags);
+		} else {
+			spin_lock_irqsave(&vp_dev->lock, flags);
+			list_add(&info->node, &vp_dev->virtqueues);
+			spin_unlock_irqrestore(&vp_dev->lock, flags);
+		}
 	} else {
 		INIT_LIST_HEAD(&info->node);
 	}
@@ -249,15 +266,16 @@ out_info:
 	return vq;
 }
 
-static void vp_del_vq(struct virtqueue *vq)
+static void vp_del_vq(struct virtqueue *vq, struct virtio_pci_channel *channel)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
+	spinlock_t *lock = channel ? &channel->lock : &vp_dev->lock;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vp_dev->lock, flags);
+	spin_lock_irqsave(lock, flags);
 	list_del(&info->node);
-	spin_unlock_irqrestore(&vp_dev->lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 
 	vp_dev->del_vq(info);
 	kfree(info);
@@ -267,94 +285,98 @@ static void vp_del_vq(struct virtqueue *vq)
 void vp_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_vq_info *info, *ninfo;
+	struct virtio_pci_channel *channel;
 	struct virtqueue *vq, *n;
-	struct virtio_pci_vq_info *info;
+	int i;
 
-	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		info = vp_dev->vqs[vq->index];
-		if (vp_dev->per_vq_vectors &&
-			info->msix_vector != VIRTIO_MSI_NO_VECTOR)
-			free_irq(vp_dev->msix_entries[info->msix_vector].vector,
-				 vq);
-		vp_del_vq(vq);
+	if (vp_dev->nchannels) {
+		for (i = 0; i < vp_dev->nchannels; i++) {
+			channel = &vp_dev->channels[i];
+			list_for_each_entry_safe(info, ninfo,
+						 &channel->virtqueues, node) {
+				vp_del_vq(info->vq, channel);
+			}
+		}
+	} else {
+		list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
+			vp_del_vq(vq, NULL);
+		}
 	}
-	vp_dev->per_vq_vectors = false;
-
+	vp_dev->nchannels = 0;
 	vp_free_vectors(vdev);
 	kfree(vp_dev->vqs);
+	kfree(vp_dev->channels);
 }
 
 static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			      struct virtqueue *vqs[],
 			      vq_callback_t *callbacks[],
 			      const char *names[],
-			      bool use_msix,
-			      bool per_vq_vectors)
+			      unsigned *channels,
+			      const char *channel_names[],
+			      unsigned nchannels)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	u16 msix_vec;
-	int i, err, nvectors, allocated_vectors;
+	int i, err = 0;
 
 	vp_dev->vqs = kmalloc(nvqs * sizeof *vp_dev->vqs, GFP_KERNEL);
 	if (!vp_dev->vqs)
 		return -ENOMEM;
 
-	if (!use_msix) {
+	if (nchannels) {
+		vp_dev->channels = kmalloc(nchannels *
+					   sizeof(*vp_dev->channels),
+					   GFP_KERNEL);
+		if (!vp_dev->channels)
+			goto error_find;
+	}
+	vp_dev->nchannels = nchannels;
+
+	for (i = 0; i < nchannels; i++) {
+		spin_lock_init(&vp_dev->channels[i].lock);
+		INIT_LIST_HEAD(&vp_dev->channels[i].virtqueues);
+	}
+
+	if (!nchannels) {
 		/* Old style: one normal interrupt for change and all vqs. */
 		err = vp_request_intx(vdev);
 		if (err)
 			goto error_find;
 	} else {
-		if (per_vq_vectors) {
-			/* Best option: one for change interrupt, one per vq. */
-			nvectors = 1;
-			for (i = 0; i < nvqs; ++i)
-				if (callbacks[i])
-					++nvectors;
-		} else {
-			/* Second best: one for change, shared for all vqs. */
-			nvectors = 2;
-		}
+		err = vp_request_msix_vectors(vdev, nchannels + 1);
+		if (err)
+			goto error_find;
+	}
 
-		err = vp_request_msix_vectors(vdev, nvectors, per_vq_vectors);
+	for (i = 0; i < nchannels; i++) {
+		snprintf(vp_dev->msix_names[i + 1],
+			 sizeof(*vp_dev->msix_names),
+			 "%s-%s",
+			 dev_name(&vp_dev->vdev.dev), channel_names[i]);
+		err = request_irq(vp_dev->msix_entries[i + 1].vector,
+				  vp_channel_interrupt, 0,
+				  vp_dev->msix_names[i + 1],
+				  &vp_dev->channels[i]);
 		if (err)
 			goto error_find;
+		++vp_dev->msix_used_vectors;
 	}
 
-	vp_dev->per_vq_vectors = per_vq_vectors;
-	allocated_vectors = vp_dev->msix_used_vectors;
 	for (i = 0; i < nvqs; ++i) {
 		if (!names[i]) {
 			vqs[i] = NULL;
 			continue;
 		} else if (!callbacks[i] || !vp_dev->msix_enabled)
 			msix_vec = VIRTIO_MSI_NO_VECTOR;
-		else if (vp_dev->per_vq_vectors)
-			msix_vec = allocated_vectors++;
 		else
-			msix_vec = VP_MSIX_VQ_VECTOR;
+			msix_vec = channels[i] + 1;
 		vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i], msix_vec);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto error_find;
 		}
-
-		if (!vp_dev->per_vq_vectors || msix_vec == VIRTIO_MSI_NO_VECTOR)
-			continue;
-
-		/* allocate per-vq irq if available and necessary */
-		snprintf(vp_dev->msix_names[msix_vec],
-			 sizeof *vp_dev->msix_names,
-			 "%s-%s",
-			 dev_name(&vp_dev->vdev.dev), names[i]);
-		err = request_irq(vp_dev->msix_entries[msix_vec].vector,
-				  vring_interrupt, 0,
-				  vp_dev->msix_names[msix_vec],
-				  vqs[i]);
-		if (err) {
-			vp_del_vq(vqs[i]);
-			goto error_find;
-		}
 	}
 	return 0;
 
@@ -369,20 +391,33 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		vq_callback_t *callbacks[],
 		const char *names[])
 {
-	int err;
+	int err, i;
+	unsigned *channels = kmalloc_array(nvqs, sizeof(unsigned), GFP_KERNEL);
+	const char *cnames[] = {"virtqueues"};
+
+	if (!channels)
+		return -ENOMEM;
 
 	/* Try MSI-X with one vector per queue. */
-	err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names, true, true);
+	for (i = 0; i < nvqs; i++)
+		channels[i] = i;
+	err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names, channels,
+				 names, nvqs);
 	if (!err)
-		return 0;
+		goto out;
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
-	err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
-				 true, false);
+	for (i = 0; i < nvqs; i++)
+		channels[i] = 0;
+	err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names, channels,
+				 cnames, 1);
 	if (!err)
-		return 0;
+		goto out;
 	/* Finally fall back to regular interrupts. */
-	return vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
-				  false, false);
+	err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
+				 NULL, NULL, 0);
+out:
+	kfree(channels);
+	return err;
 }
 
 const char *vp_bus_name(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index adddb64..ffe8f7a 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -48,6 +48,11 @@ struct virtio_pci_vq_info {
 	unsigned msix_vector;
 };
 
+struct virtio_pci_channel {
+	spinlock_t lock;
+	struct list_head virtqueues;
+};
+
 /* Our device structure */
 struct virtio_pci_device {
 	struct virtio_device vdev;
@@ -66,6 +71,10 @@ struct virtio_pci_device {
 	/* array of all queues for house-keeping */
 	struct virtio_pci_vq_info **vqs;
 
+	/* array of channels */
+	struct virtio_pci_channel *channels;
+	unsigned nchannels;
+
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
@@ -76,12 +85,9 @@ struct virtio_pci_device {
 	char (*msix_names)[256];
 	/* Number of available vectors */
 	unsigned msix_vectors;
-	/* Vectors allocated, excluding per-vq vectors if any */
+	/* Vectors allocated */
 	unsigned msix_used_vectors;
 
-	/* Whether we have vector per vq */
-	bool per_vq_vectors;
-
 	struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
 				      struct virtio_pci_vq_info *info,
 				      unsigned idx,
-- 
1.8.3.1

