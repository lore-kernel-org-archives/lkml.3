Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaLHNIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaLHNG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:26 -0500
Date: Mon, 8 Dec 2014 15:06:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 3/9] virtio_pci: free up vq->priv
Message-ID: <1418043812-25753-4-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to go from vq to vq info on
data path, so using direct vq->priv pointer for that
seems like a waste.

Let's build an array of vq infos, then we can use vq->index
for that lookup.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 56 +++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 6f3db1f..6a7b8bf 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -31,6 +31,23 @@ MODULE_DESCRIPTION("virtio-pci");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1");
 
+struct virtio_pci_vq_info {
+	/* the actual virtqueue */
+	struct virtqueue *vq;
+
+	/* the number of entries in the queue */
+	int num;
+
+	/* the virtual address of the ring queue */
+	void *queue;
+
+	/* the list node for the virtqueues list */
+	struct list_head node;
+
+	/* MSI-X vector (or none) */
+	unsigned msix_vector;
+};
+
 /* Our device structure */
 struct virtio_pci_device {
 	struct virtio_device vdev;
@@ -46,6 +63,9 @@ struct virtio_pci_device {
 	spinlock_t lock;
 	struct list_head virtqueues;
 
+	/* array of all queues for house-keeping */
+	struct virtio_pci_vq_info **vqs;
+
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
@@ -71,23 +91,6 @@ enum {
 	VP_MSIX_VQ_VECTOR = 1,
 };
 
-struct virtio_pci_vq_info {
-	/* the actual virtqueue */
-	struct virtqueue *vq;
-
-	/* the number of entries in the queue */
-	int num;
-
-	/* the virtual address of the ring queue */
-	void *queue;
-
-	/* the list node for the virtqueues list */
-	struct list_head node;
-
-	/* MSI-X vector (or none) */
-	unsigned msix_vector;
-};
-
 /* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
 static const struct pci_device_id virtio_pci_id_table[] = {
 	{ PCI_DEVICE(0x1af4, PCI_ANY_ID) },
@@ -434,7 +437,6 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		goto out_activate_queue;
 	}
 
-	vq->priv = info;
 	info->vq = vq;
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
@@ -454,6 +456,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		INIT_LIST_HEAD(&info->node);
 	}
 
+	vp_dev->vqs[index] = info;
 	return vq;
 
 out_assign:
@@ -469,7 +472,7 @@ out_info:
 static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
 	unsigned long flags, size;
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
@@ -503,7 +506,7 @@ static void vp_del_vqs(struct virtio_device *vdev)
 	struct virtio_pci_vq_info *info;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		info = vq->priv;
+		info = vp_dev->vqs[vq->index];
 		if (vp_dev->per_vq_vectors &&
 			info->msix_vector != VIRTIO_MSI_NO_VECTOR)
 			free_irq(vp_dev->msix_entries[info->msix_vector].vector,
@@ -513,6 +516,7 @@ static void vp_del_vqs(struct virtio_device *vdev)
 	vp_dev->per_vq_vectors = false;
 
 	vp_free_vectors(vdev);
+	kfree(vp_dev->vqs);
 }
 
 static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
@@ -526,11 +530,15 @@ static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	u16 msix_vec;
 	int i, err, nvectors, allocated_vectors;
 
+	vp_dev->vqs = kmalloc(nvqs * sizeof *vp_dev->vqs, GFP_KERNEL);
+	if (!vp_dev->vqs)
+		return -ENOMEM;
+
 	if (!use_msix) {
 		/* Old style: one normal interrupt for change and all vqs. */
 		err = vp_request_intx(vdev);
 		if (err)
-			goto error_request;
+			goto error_find;
 	} else {
 		if (per_vq_vectors) {
 			/* Best option: one for change interrupt, one per vq. */
@@ -545,7 +553,7 @@ static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 
 		err = vp_request_msix_vectors(vdev, nvectors, per_vq_vectors);
 		if (err)
-			goto error_request;
+			goto error_find;
 	}
 
 	vp_dev->per_vq_vectors = per_vq_vectors;
@@ -587,8 +595,6 @@ static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 
 error_find:
 	vp_del_vqs(vdev);
-
-error_request:
 	return err;
 }
 
@@ -630,7 +636,7 @@ static int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
 {
 	struct virtio_device *vdev = vq->vdev;
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
 	struct cpumask *mask;
 	unsigned int irq;
 
-- 
MST

