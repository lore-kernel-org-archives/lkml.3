Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaLHNGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbaLHNGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:41 -0500
Date: Mon, 8 Dec 2014 15:06:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 8/9] virtio_pci: split out legacy device support
Message-ID: <1418043812-25753-9-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move everything dealing with legacy devices out to virtio_pci_legacy.c.
Expose common code APIs in virtio_pci.h

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.h        | 133 ++++++++++++
 drivers/virtio/virtio_pci.c        | 420 ++-----------------------------------
 drivers/virtio/virtio_pci_legacy.c | 323 ++++++++++++++++++++++++++++
 drivers/virtio/Makefile            |   2 +-
 4 files changed, 469 insertions(+), 409 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci.h
 create mode 100644 drivers/virtio/virtio_pci_legacy.c

diff --git a/drivers/virtio/virtio_pci.h b/drivers/virtio/virtio_pci.h
new file mode 100644
index 0000000..a3b1259
--- /dev/null
+++ b/drivers/virtio/virtio_pci.h
@@ -0,0 +1,133 @@
+#ifndef _DRIVERS_VIRTIO_VIRTIO_PCI_H
+#define _DRIVERS_VIRTIO_VIRTIO_PCI_H
+/*
+ * Virtio PCI driver
+ *
+ * This module allows virtio devices to be used over a virtual PCI device.
+ * This can be used with QEMU based VMMs like KVM or Xen.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors:
+ *  Anthony Liguori  <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#define VIRTIO_PCI_NO_LEGACY
+#include <linux/virtio_pci.h>
+#include <linux/highmem.h>
+#include <linux/spinlock.h>
+
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
+/* Our device structure */
+struct virtio_pci_device {
+	struct virtio_device vdev;
+	struct pci_dev *pci_dev;
+
+	/* the IO mapping for the PCI config space */
+	void __iomem *ioaddr;
+
+	/* the IO mapping for ISR operation */
+	void __iomem *isr;
+
+	/* a list of queues so we can dispatch IRQs */
+	spinlock_t lock;
+	struct list_head virtqueues;
+
+	/* array of all queues for house-keeping */
+	struct virtio_pci_vq_info **vqs;
+
+	/* MSI-X support */
+	int msix_enabled;
+	int intx_enabled;
+	struct msix_entry *msix_entries;
+	cpumask_var_t *msix_affinity_masks;
+	/* Name strings for interrupts. This size should be enough,
+	 * and I'm too lazy to allocate each name separately. */
+	char (*msix_names)[256];
+	/* Number of available vectors */
+	unsigned msix_vectors;
+	/* Vectors allocated, excluding per-vq vectors if any */
+	unsigned msix_used_vectors;
+
+	/* Whether we have vector per vq */
+	bool per_vq_vectors;
+
+	struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
+				      struct virtio_pci_vq_info *info,
+				      unsigned idx,
+				      void (*callback)(struct virtqueue *vq),
+				      const char *name,
+				      u16 msix_vec);
+	void (*del_vq)(struct virtio_pci_vq_info *info);
+
+	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
+};
+
+/* Constants for MSI-X */
+/* Use first vector for configuration changes, second and the rest for
+ * virtqueues Thus, we need at least 2 vectors for MSI. */
+enum {
+	VP_MSIX_CONFIG_VECTOR = 0,
+	VP_MSIX_VQ_VECTOR = 1,
+};
+
+/* Convert a generic virtio device to our structure */
+static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
+{
+	return container_of(vdev, struct virtio_pci_device, vdev);
+}
+
+/* wait for pending irq handlers */
+void vp_synchronize_vectors(struct virtio_device *vdev);
+/* the notify function used when creating a virt queue */
+bool vp_notify(struct virtqueue *vq);
+/* the config->del_vqs() implementation */
+void vp_del_vqs(struct virtio_device *vdev);
+/* the config->find_vqs() implementation */
+int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+		       struct virtqueue *vqs[],
+		       vq_callback_t *callbacks[],
+		       const char *names[]);
+const char *vp_bus_name(struct virtio_device *vdev);
+
+/* Setup the affinity for a virtqueue:
+ * - force the affinity for per vq vector
+ * - OR over all affinities for shared MSI
+ * - ignore the affinity request if we're using INTX
+ */
+int vp_set_vq_affinity(struct virtqueue *vq, int cpu);
+void virtio_pci_release_dev(struct device *);
+
+#ifdef CONFIG_PM_SLEEP
+extern const struct dev_pm_ops virtio_pci_pm_ops;
+#endif
+
+#endif
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c8ca3f7..6c7e186 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -14,179 +14,10 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/list.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/virtio.h>
-#include <linux/virtio_config.h>
-#include <linux/virtio_ring.h>
-#include <linux/virtio_pci.h>
-#include <linux/highmem.h>
-#include <linux/spinlock.h>
-
-MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
-MODULE_DESCRIPTION("virtio-pci");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1");
-
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
-/* Our device structure */
-struct virtio_pci_device {
-	struct virtio_device vdev;
-	struct pci_dev *pci_dev;
-
-	/* the IO mapping for the PCI config space */
-	void __iomem *ioaddr;
-
-	/* the IO mapping for ISR operation */
-	void __iomem *isr;
-
-	/* a list of queues so we can dispatch IRQs */
-	spinlock_t lock;
-	struct list_head virtqueues;
-
-	/* array of all queues for house-keeping */
-	struct virtio_pci_vq_info **vqs;
-
-	/* MSI-X support */
-	int msix_enabled;
-	int intx_enabled;
-	struct msix_entry *msix_entries;
-	cpumask_var_t *msix_affinity_masks;
-	/* Name strings for interrupts. This size should be enough,
-	 * and I'm too lazy to allocate each name separately. */
-	char (*msix_names)[256];
-	/* Number of available vectors */
-	unsigned msix_vectors;
-	/* Vectors allocated, excluding per-vq vectors if any */
-	unsigned msix_used_vectors;
-
-	/* Whether we have vector per vq */
-	bool per_vq_vectors;
-
-	struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
-				      struct virtio_pci_vq_info *info,
-				      unsigned idx,
-				      void (*callback)(struct virtqueue *vq),
-				      const char *name,
-				      u16 msix_vec);
-	void (*del_vq)(struct virtio_pci_vq_info *info);
-	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
-};
-
-/* Constants for MSI-X */
-/* Use first vector for configuration changes, second and the rest for
- * virtqueues Thus, we need at least 2 vectors for MSI. */
-enum {
-	VP_MSIX_CONFIG_VECTOR = 0,
-	VP_MSIX_VQ_VECTOR = 1,
-};
-
-/* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
-static const struct pci_device_id virtio_pci_id_table[] = {
-	{ PCI_DEVICE(0x1af4, PCI_ANY_ID) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
-
-/* Convert a generic virtio device to our structure */
-static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
-{
-	return container_of(vdev, struct virtio_pci_device, vdev);
-}
-
-/* virtio config->get_features() implementation */
-static u64 vp_get_features(struct virtio_device *vdev)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-
-	/* When someone needs more than 32 feature bits, we'll need to
-	 * steal a bit to indicate that the rest are somewhere else. */
-	return ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
-}
-
-/* virtio config->finalize_features() implementation */
-static int vp_finalize_features(struct virtio_device *vdev)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-
-	/* Give virtio_ring a chance to accept features. */
-	vring_transport_features(vdev);
-
-	/* Make sure we don't have any features > 32 bits! */
-	BUG_ON((u32)vdev->features != vdev->features);
-
-	/* We only support 32 feature bits. */
-	iowrite32(vdev->features, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
-
-	return 0;
-}
-
-/* virtio config->get() implementation */
-static void vp_get(struct virtio_device *vdev, unsigned offset,
-		   void *buf, unsigned len)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void __iomem *ioaddr = vp_dev->ioaddr +
-				VIRTIO_PCI_CONFIG(vp_dev) + offset;
-	u8 *ptr = buf;
-	int i;
-
-	for (i = 0; i < len; i++)
-		ptr[i] = ioread8(ioaddr + i);
-}
-
-/* the config->set() implementation.  it's symmetric to the config->get()
- * implementation */
-static void vp_set(struct virtio_device *vdev, unsigned offset,
-		   const void *buf, unsigned len)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void __iomem *ioaddr = vp_dev->ioaddr +
-				VIRTIO_PCI_CONFIG(vp_dev) + offset;
-	const u8 *ptr = buf;
-	int i;
-
-	for (i = 0; i < len; i++)
-		iowrite8(ptr[i], ioaddr + i);
-}
-
-/* config->{get,set}_status() implementations */
-static u8 vp_get_status(struct virtio_device *vdev)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	return ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
-}
-
-static void vp_set_status(struct virtio_device *vdev, u8 status)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	/* We should never be setting status to 0. */
-	BUG_ON(status == 0);
-	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
-}
+#include "virtio_pci.h"
 
 /* wait for pending irq handlers */
-static void vp_synchronize_vectors(struct virtio_device *vdev)
+void vp_synchronize_vectors(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i;
@@ -198,20 +29,8 @@ static void vp_synchronize_vectors(struct virtio_device *vdev)
 		synchronize_irq(vp_dev->msix_entries[i].vector);
 }
 
-static void vp_reset(struct virtio_device *vdev)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	/* 0 status means a reset. */
-	iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
-	/* Flush out the status write, and flush in device writes,
-	 * including MSi-X interrupts, if any. */
-	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
-	/* Flush pending VQ/configuration callbacks. */
-	vp_synchronize_vectors(vdev);
-}
-
 /* the notify function used when creating a virt queue */
-static bool vp_notify(struct virtqueue *vq)
+bool vp_notify(struct virtqueue *vq)
 {
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
@@ -272,15 +91,6 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 	return vp_vring_interrupt(irq, opaque);
 }
 
-u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
-{
-	/* Setup the vector used for configuration events */
-	iowrite16(vector, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
-	/* Verify we had enough resources to assign the vector */
-	/* Will also flush the write out to device */
-	return ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
-}
-
 static void vp_free_vectors(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -401,68 +211,6 @@ static int vp_request_intx(struct virtio_device *vdev)
 	return err;
 }
 
-static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
-				  struct virtio_pci_vq_info *info,
-				  unsigned index,
-				  void (*callback)(struct virtqueue *vq),
-				  const char *name,
-				  u16 msix_vec)
-{
-	struct virtqueue *vq;
-	unsigned long size;
-	u16 num;
-	int err;
-
-	/* Select the queue we're interested in */
-	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
-
-	/* Check if queue is either not available or already active. */
-	num = ioread16(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NUM);
-	if (!num || ioread32(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN))
-		return ERR_PTR(-ENOENT);
-
-	info->num = num;
-	info->msix_vector = msix_vec;
-
-	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
-	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
-	if (info->queue == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	/* activate the queue */
-	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
-
-	/* create the vring */
-	vq = vring_new_virtqueue(index, info->num,
-				 VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
-				 true, info->queue, vp_notify, callback, name);
-	if (!vq) {
-		err = -ENOMEM;
-		goto out_activate_queue;
-	}
-
-	vq->priv = (void __force *)vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY;
-
-	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
-		iowrite16(msix_vec, vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
-		msix_vec = ioread16(vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
-		if (msix_vec == VIRTIO_MSI_NO_VECTOR) {
-			err = -EBUSY;
-			goto out_assign;
-		}
-	}
-
-	return vq;
-
-out_assign:
-	vring_del_virtqueue(vq);
-out_activate_queue:
-	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
-	free_pages_exact(info->queue, size);
-	return ERR_PTR(err);
-}
-
 static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 				     void (*callback)(struct virtqueue *vq),
 				     const char *name,
@@ -498,30 +246,6 @@ out_info:
 	return vq;
 }
 
-static void del_vq(struct virtio_pci_vq_info *info)
-{
-	struct virtqueue *vq = info->vq;
-	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	unsigned long size;
-
-	iowrite16(vq->index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
-
-	if (vp_dev->msix_enabled) {
-		iowrite16(VIRTIO_MSI_NO_VECTOR,
-			  vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
-		/* Flush the write out to device */
-		ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
-	}
-
-	vring_del_virtqueue(vq);
-
-	/* Select and deactivate the queue */
-	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
-
-	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
-	free_pages_exact(info->queue, size);
-}
-
 static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
@@ -537,7 +261,7 @@ static void vp_del_vq(struct virtqueue *vq)
 }
 
 /* the config->del_vqs() implementation */
-static void vp_del_vqs(struct virtio_device *vdev)
+void vp_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtqueue *vq, *n;
@@ -637,10 +361,10 @@ error_find:
 }
 
 /* the config->find_vqs() implementation */
-static int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
-		       struct virtqueue *vqs[],
-		       vq_callback_t *callbacks[],
-		       const char *names[])
+int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+		struct virtqueue *vqs[],
+		vq_callback_t *callbacks[],
+		const char *names[])
 {
 	int err;
 
@@ -658,7 +382,7 @@ static int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 				  false, false);
 }
 
-static const char *vp_bus_name(struct virtio_device *vdev)
+const char *vp_bus_name(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
@@ -670,7 +394,7 @@ static const char *vp_bus_name(struct virtio_device *vdev)
  * - OR over all affinities for shared MSI
  * - ignore the affinity request if we're using INTX
  */
-static int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
+int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
 {
 	struct virtio_device *vdev = vq->vdev;
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -694,21 +418,7 @@ static int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
 	return 0;
 }
 
-static const struct virtio_config_ops virtio_pci_config_ops = {
-	.get		= vp_get,
-	.set		= vp_set,
-	.get_status	= vp_get_status,
-	.set_status	= vp_set_status,
-	.reset		= vp_reset,
-	.find_vqs	= vp_find_vqs,
-	.del_vqs	= vp_del_vqs,
-	.get_features	= vp_get_features,
-	.finalize_features = vp_finalize_features,
-	.bus_name	= vp_bus_name,
-	.set_vq_affinity = vp_set_vq_affinity,
-};
-
-static void virtio_pci_release_dev(struct device *_d)
+void virtio_pci_release_dev(struct device *_d)
 {
 	/*
 	 * No need for a release method as we allocate/free
@@ -717,100 +427,6 @@ static void virtio_pci_release_dev(struct device *_d)
 	 */
 }
 
-/* the PCI probing function */
-static int virtio_pci_probe(struct pci_dev *pci_dev,
-			    const struct pci_device_id *id)
-{
-	struct virtio_pci_device *vp_dev;
-	int err;
-
-	/* We only own devices >= 0x1000 and <= 0x103f: leave the rest. */
-	if (pci_dev->device < 0x1000 || pci_dev->device > 0x103f)
-		return -ENODEV;
-
-	if (pci_dev->revision != VIRTIO_PCI_ABI_VERSION) {
-		printk(KERN_ERR "virtio_pci: expected ABI version %d, got %d\n",
-		       VIRTIO_PCI_ABI_VERSION, pci_dev->revision);
-		return -ENODEV;
-	}
-
-	/* allocate our structure and fill it out */
-	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
-	if (vp_dev == NULL)
-		return -ENOMEM;
-
-	vp_dev->vdev.dev.parent = &pci_dev->dev;
-	vp_dev->vdev.dev.release = virtio_pci_release_dev;
-	vp_dev->vdev.config = &virtio_pci_config_ops;
-	vp_dev->pci_dev = pci_dev;
-	INIT_LIST_HEAD(&vp_dev->virtqueues);
-	spin_lock_init(&vp_dev->lock);
-
-	/* Disable MSI/MSIX to bring device to a known good state. */
-	pci_msi_off(pci_dev);
-
-	/* enable the device */
-	err = pci_enable_device(pci_dev);
-	if (err)
-		goto out;
-
-	err = pci_request_regions(pci_dev, "virtio-pci");
-	if (err)
-		goto out_enable_device;
-
-	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
-	if (vp_dev->ioaddr == NULL) {
-		err = -ENOMEM;
-		goto out_req_regions;
-	}
-
-	vp_dev->isr = vp_dev->ioaddr + VIRTIO_PCI_ISR;
-
-	pci_set_drvdata(pci_dev, vp_dev);
-	pci_set_master(pci_dev);
-
-	/* we use the subsystem vendor/device id as the virtio vendor/device
-	 * id.  this allows us to use the same PCI vendor/device id for all
-	 * virtio devices and to identify the particular virtio driver by
-	 * the subsystem ids */
-	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
-	vp_dev->vdev.id.device = pci_dev->subsystem_device;
-
-	vp_dev->config_vector = vp_config_vector;
-	vp_dev->setup_vq = setup_vq;
-	vp_dev->del_vq = del_vq;
-
-	/* finally register the virtio device */
-	err = register_virtio_device(&vp_dev->vdev);
-	if (err)
-		goto out_set_drvdata;
-
-	return 0;
-
-out_set_drvdata:
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-out_req_regions:
-	pci_release_regions(pci_dev);
-out_enable_device:
-	pci_disable_device(pci_dev);
-out:
-	kfree(vp_dev);
-	return err;
-}
-
-static void virtio_pci_remove(struct pci_dev *pci_dev)
-{
-	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
-
-	unregister_virtio_device(&vp_dev->vdev);
-
-	vp_del_vqs(&vp_dev->vdev);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-	kfree(vp_dev);
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int virtio_pci_freeze(struct device *dev)
 {
@@ -839,19 +455,7 @@ static int virtio_pci_restore(struct device *dev)
 	return virtio_device_restore(&vp_dev->vdev);
 }
 
-static const struct dev_pm_ops virtio_pci_pm_ops = {
+const struct dev_pm_ops virtio_pci_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(virtio_pci_freeze, virtio_pci_restore)
 };
 #endif
-
-static struct pci_driver virtio_pci_driver = {
-	.name		= "virtio-pci",
-	.id_table	= virtio_pci_id_table,
-	.probe		= virtio_pci_probe,
-	.remove		= virtio_pci_remove,
-#ifdef CONFIG_PM_SLEEP
-	.driver.pm	= &virtio_pci_pm_ops,
-#endif
-};
-
-module_pci_driver(virtio_pci_driver);
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
new file mode 100644
index 0000000..9fdec9a
--- /dev/null
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -0,0 +1,323 @@
+/*
+ * Virtio PCI driver
+ *
+ * This module allows virtio devices to be used over a virtual PCI device.
+ * This can be used with QEMU based VMMs like KVM or Xen.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors:
+ *  Anthony Liguori  <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include "virtio_pci.h"
+
+/* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
+static const struct pci_device_id virtio_pci_id_table[] = {
+	{ PCI_DEVICE(0x1af4, PCI_ANY_ID) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
+
+/* virtio config->get_features() implementation */
+static u64 vp_get_features(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	/* When someone needs more than 32 feature bits, we'll need to
+	 * steal a bit to indicate that the rest are somewhere else. */
+	return ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
+}
+
+/* virtio config->finalize_features() implementation */
+static int vp_finalize_features(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
+	/* We only support 32 feature bits. */
+	iowrite32(vdev->features, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
+
+	return 0;
+}
+
+/* virtio config->get() implementation */
+static void vp_get(struct virtio_device *vdev, unsigned offset,
+		   void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	void __iomem *ioaddr = vp_dev->ioaddr +
+				VIRTIO_PCI_CONFIG(vp_dev) + offset;
+	u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		ptr[i] = ioread8(ioaddr + i);
+}
+
+/* the config->set() implementation.  it's symmetric to the config->get()
+ * implementation */
+static void vp_set(struct virtio_device *vdev, unsigned offset,
+		   const void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	void __iomem *ioaddr = vp_dev->ioaddr +
+				VIRTIO_PCI_CONFIG(vp_dev) + offset;
+	const u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		iowrite8(ptr[i], ioaddr + i);
+}
+
+/* config->{get,set}_status() implementations */
+static u8 vp_get_status(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	return ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+}
+
+static void vp_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	/* We should never be setting status to 0. */
+	BUG_ON(status == 0);
+	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+}
+
+static void vp_reset(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	/* 0 status means a reset. */
+	iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	/* Flush out the status write, and flush in device writes,
+	 * including MSi-X interrupts, if any. */
+	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	/* Flush pending VQ/configuration callbacks. */
+	vp_synchronize_vectors(vdev);
+}
+
+u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
+{
+	/* Setup the vector used for configuration events */
+	iowrite16(vector, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+	/* Verify we had enough resources to assign the vector */
+	/* Will also flush the write out to device */
+	return ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
+}
+
+static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
+				  struct virtio_pci_vq_info *info,
+				  unsigned index,
+				  void (*callback)(struct virtqueue *vq),
+				  const char *name,
+				  u16 msix_vec)
+{
+	struct virtqueue *vq;
+	unsigned long size;
+	u16 num;
+	int err;
+
+	/* Select the queue we're interested in */
+	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+
+	/* Check if queue is either not available or already active. */
+	num = ioread16(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NUM);
+	if (!num || ioread32(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN))
+		return ERR_PTR(-ENOENT);
+
+	info->num = num;
+	info->msix_vector = msix_vec;
+
+	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
+	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
+	if (info->queue == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* activate the queue */
+	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+
+	/* create the vring */
+	vq = vring_new_virtqueue(index, info->num,
+				 VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
+				 true, info->queue, vp_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto out_activate_queue;
+	}
+
+	vq->priv = (void __force *)vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY;
+
+	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
+		iowrite16(msix_vec, vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
+		msix_vec = ioread16(vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
+		if (msix_vec == VIRTIO_MSI_NO_VECTOR) {
+			err = -EBUSY;
+			goto out_assign;
+		}
+	}
+
+	return vq;
+
+out_assign:
+	vring_del_virtqueue(vq);
+out_activate_queue:
+	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+	free_pages_exact(info->queue, size);
+	return ERR_PTR(err);
+}
+
+static void del_vq(struct virtio_pci_vq_info *info)
+{
+	struct virtqueue *vq = info->vq;
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	unsigned long size;
+
+	iowrite16(vq->index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+
+	if (vp_dev->msix_enabled) {
+		iowrite16(VIRTIO_MSI_NO_VECTOR,
+			  vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
+		/* Flush the write out to device */
+		ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
+	}
+
+	vring_del_virtqueue(vq);
+
+	/* Select and deactivate the queue */
+	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+
+	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
+	free_pages_exact(info->queue, size);
+}
+
+static const struct virtio_config_ops virtio_pci_config_ops = {
+	.get		= vp_get,
+	.set		= vp_set,
+	.get_status	= vp_get_status,
+	.set_status	= vp_set_status,
+	.reset		= vp_reset,
+	.find_vqs	= vp_find_vqs,
+	.del_vqs	= vp_del_vqs,
+	.get_features	= vp_get_features,
+	.finalize_features = vp_finalize_features,
+	.bus_name	= vp_bus_name,
+	.set_vq_affinity = vp_set_vq_affinity,
+};
+
+/* the PCI probing function */
+static int virtio_pci_probe(struct pci_dev *pci_dev,
+			    const struct pci_device_id *id)
+{
+	struct virtio_pci_device *vp_dev;
+	int err;
+
+	/* We only own devices >= 0x1000 and <= 0x103f: leave the rest. */
+	if (pci_dev->device < 0x1000 || pci_dev->device > 0x103f)
+		return -ENODEV;
+
+	if (pci_dev->revision != VIRTIO_PCI_ABI_VERSION) {
+		printk(KERN_ERR "virtio_pci: expected ABI version %d, got %d\n",
+		       VIRTIO_PCI_ABI_VERSION, pci_dev->revision);
+		return -ENODEV;
+	}
+
+	/* allocate our structure and fill it out */
+	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
+	if (vp_dev == NULL)
+		return -ENOMEM;
+
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
+	vp_dev->vdev.config = &virtio_pci_config_ops;
+	vp_dev->pci_dev = pci_dev;
+	INIT_LIST_HEAD(&vp_dev->virtqueues);
+	spin_lock_init(&vp_dev->lock);
+
+	/* Disable MSI/MSIX to bring device to a known good state. */
+	pci_msi_off(pci_dev);
+
+	/* enable the device */
+	err = pci_enable_device(pci_dev);
+	if (err)
+		goto out;
+
+	err = pci_request_regions(pci_dev, "virtio-pci");
+	if (err)
+		goto out_enable_device;
+
+	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
+	if (vp_dev->ioaddr == NULL) {
+		err = -ENOMEM;
+		goto out_req_regions;
+	}
+
+	vp_dev->isr = vp_dev->ioaddr + VIRTIO_PCI_ISR;
+
+	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
+
+	/* we use the subsystem vendor/device id as the virtio vendor/device
+	 * id.  this allows us to use the same PCI vendor/device id for all
+	 * virtio devices and to identify the particular virtio driver by
+	 * the subsystem ids */
+	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
+	vp_dev->vdev.id.device = pci_dev->subsystem_device;
+
+	vp_dev->config_vector = vp_config_vector;
+	vp_dev->setup_vq = setup_vq;
+	vp_dev->del_vq = del_vq;
+
+	/* finally register the virtio device */
+	err = register_virtio_device(&vp_dev->vdev);
+	if (err)
+		goto out_set_drvdata;
+
+	return 0;
+
+out_set_drvdata:
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+out_req_regions:
+	pci_release_regions(pci_dev);
+out_enable_device:
+	pci_disable_device(pci_dev);
+out:
+	kfree(vp_dev);
+	return err;
+}
+
+static void virtio_pci_remove(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+
+	unregister_virtio_device(&vp_dev->vdev);
+
+	vp_del_vqs(&vp_dev->vdev);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
+static struct pci_driver virtio_pci_driver = {
+	.name		= "virtio-pci",
+	.id_table	= virtio_pci_id_table,
+	.probe		= virtio_pci_probe,
+	.remove		= virtio_pci_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver.pm	= &virtio_pci_pm_ops,
+#endif
+};
+
+module_pci_driver(virtio_pci_driver);
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 9076635..92a3839 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
-obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
+obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
-- 
MST

