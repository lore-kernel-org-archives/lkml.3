Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3HURva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:51:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:40614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3HURvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="284942818"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 6/7] Intel MIC Card Driver Changes for Virtio Devices.
Date: Wed, 21 Aug 2013 10:50:45 -0700
Message-Id: <8f3578459597e0f63d34722cc2e6d4a7c2f10791.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

This patch introduces the card "Virtio over PCIe" interface for
Intel MIC. It allows virtio drivers on the card to communicate with their
user space backends on the host via a device page. Ring 3 apps on the host
can add, remove and configure virtio devices. A thin MIC specific
virtio_config_ops is implemented which is borrowed heavily from previous
similar implementations in lguest and s390 @
drivers/lguest/lguest_device.c
drivers/s390/kvm/kvm_virtio.c

Co-author: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 drivers/misc/mic/Kconfig           |   1 +
 drivers/misc/mic/card/Makefile     |   1 +
 drivers/misc/mic/card/mic_device.c |   7 +
 drivers/misc/mic/card/mic_virtio.c | 631 +++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/card/mic_virtio.h |  77 +++++
 5 files changed, 717 insertions(+)
 create mode 100644 drivers/misc/mic/card/mic_virtio.c
 create mode 100644 drivers/misc/mic/card/mic_virtio.h

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index 01f1a4a..d453768 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -24,6 +24,7 @@ comment "Intel MIC Card Driver"
 config INTEL_MIC_CARD
 	tristate "Intel MIC Card Driver"
 	depends on 64BIT
+	select VIRTIO
 	default N
 	help
 	  This enables card driver support for the Intel Many Integrated
diff --git a/drivers/misc/mic/card/Makefile b/drivers/misc/mic/card/Makefile
index 6e9675e..69d58be 100644
--- a/drivers/misc/mic/card/Makefile
+++ b/drivers/misc/mic/card/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_INTEL_MIC_CARD) += mic_card.o
 mic_card-y += mic_x100.o
 mic_card-y += mic_device.o
 mic_card-y += mic_debugfs.o
+mic_card-y += mic_virtio.o
diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
index 3c5c302..4125217 100644
--- a/drivers/misc/mic/card/mic_device.c
+++ b/drivers/misc/mic/card/mic_device.c
@@ -32,6 +32,7 @@
 #include <linux/mic_common.h>
 #include "../common/mic_device.h"
 #include "mic_device.h"
+#include "mic_virtio.h"
 
 static struct mic_driver *g_drv;
 static struct mic_irq *shutdown_cookie;
@@ -265,10 +266,15 @@ int __init mic_driver_init(struct mic_driver *mdrv)
 	rc = mic_shutdown_init();
 	if (rc)
 		goto irq_uninit;
+	rc = mic_devices_init(mdrv);
+	if (rc)
+		goto shutdown_uninit;
 	mic_create_card_debug_dir(mdrv);
 	atomic_notifier_chain_register(&panic_notifier_list, &mic_panic);
 done:
 	return rc;
+shutdown_uninit:
+	mic_shutdown_uninit();
 irq_uninit:
 	mic_uninit_irq();
 dp_uninit:
@@ -286,6 +292,7 @@ put:
 void mic_driver_uninit(struct mic_driver *mdrv)
 {
 	mic_delete_card_debug_dir(mdrv);
+	mic_devices_uninit(mdrv);
 	/*
 	 * Inform the host about the shutdown status i.e. poweroff/restart etc.
 	 * The module cannot be unloaded so the only code path to call
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
new file mode 100644
index 0000000..38275c1
--- /dev/null
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -0,0 +1,631 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Adapted from:
+ *
+ * virtio for kvm on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/virtio_config.h>
+
+#include "../common/mic_device.h"
+#include "mic_virtio.h"
+
+#define VIRTIO_SUBCODE_64 0x0D00
+
+#define MIC_MAX_VRINGS                4
+struct mic_vdev {
+	struct virtio_device vdev;
+	struct mic_device_desc __iomem *desc;
+	struct mic_device_ctrl __iomem *dc;
+	struct mic_device *mdev;
+	void __iomem *vr[MIC_MAX_VRINGS];
+	int used_size[MIC_MAX_VRINGS];
+	struct completion reset_done;
+	struct mic_irq *virtio_cookie;
+	int c2h_vdev_db;
+};
+
+static struct mic_irq *virtio_config_cookie;
+#define to_micvdev(vd) container_of(vd, struct mic_vdev, vdev)
+
+/* Helper API to obtain the parent of the virtio device */
+static inline struct device *mic_dev(struct mic_vdev *mvdev)
+{
+	return mvdev->vdev.dev.parent;
+}
+
+/* This gets the device's feature bits. */
+static u32 mic_get_features(struct virtio_device *vdev)
+{
+	unsigned int i, bits;
+	u32 features = 0;
+	struct mic_device_desc __iomem *desc = to_micvdev(vdev)->desc;
+	u8 __iomem *in_features = mic_vq_features(desc);
+	int feature_len = ioread8(&desc->feature_len);
+
+	bits = min_t(unsigned, feature_len,
+		sizeof(vdev->features)) * 8;
+	for (i = 0; i < bits; i++)
+		if (ioread8(&in_features[i / 8]) & (BIT(i % 8)))
+			features |= BIT(i);
+
+	return features;
+}
+
+static void mic_finalize_features(struct virtio_device *vdev)
+{
+	unsigned int i, bits;
+	struct mic_device_desc __iomem *desc = to_micvdev(vdev)->desc;
+	u8 feature_len = ioread8(&desc->feature_len);
+	/* Second half of bitmap is features we accept. */
+	u8 __iomem *out_features =
+		mic_vq_features(desc) + feature_len;
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	memset_io(out_features, 0, feature_len);
+	bits = min_t(unsigned, feature_len,
+		sizeof(vdev->features)) * 8;
+	for (i = 0; i < bits; i++) {
+		if (test_bit(i, vdev->features))
+			iowrite8(ioread8(&out_features[i / 8]) | (1 << (i % 8)),
+				&out_features[i / 8]);
+	}
+}
+
+/*
+ * Reading and writing elements in config space
+ */
+static void mic_get(struct virtio_device *vdev, unsigned int offset,
+		   void *buf, unsigned len)
+{
+	struct mic_device_desc __iomem *desc = to_micvdev(vdev)->desc;
+
+	if (offset + len > ioread8(&desc->config_len))
+		return;
+	memcpy_fromio(buf, mic_vq_configspace(desc) + offset, len);
+}
+
+static void mic_set(struct virtio_device *vdev, unsigned int offset,
+		   const void *buf, unsigned len)
+{
+	struct mic_device_desc __iomem *desc = to_micvdev(vdev)->desc;
+
+	if (offset + len > ioread8(&desc->config_len))
+		return;
+	memcpy_toio(mic_vq_configspace(desc) + offset, buf, len);
+}
+
+/*
+ * The operations to get and set the status word just access the status
+ * field of the device descriptor. set_status also interrupts the host
+ * to tell about status changes.
+ */
+static u8 mic_get_status(struct virtio_device *vdev)
+{
+	return ioread8(&to_micvdev(vdev)->desc->status);
+}
+
+static void mic_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+	if (!status)
+		return;
+	iowrite8(status, &mvdev->desc->status);
+	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
+}
+
+/* Inform host on a virtio device reset and wait for ack from host */
+static void mic_reset_inform_host(struct virtio_device *vdev)
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+	struct mic_device_ctrl __iomem *dc = mvdev->dc;
+	int retry = 100, i;
+
+	iowrite8(0, &dc->host_ack);
+	iowrite8(1, &dc->vdev_reset);
+	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
+
+	/* Wait till host completes all card accesses and acks the reset */
+	for (i = retry; i--;) {
+		if (ioread8(&dc->host_ack))
+			break;
+		msleep(100);
+	};
+
+	dev_dbg(mic_dev(mvdev), "%s: retry: %d\n", __func__, retry);
+
+	/* Reset status to 0 in case we timed out */
+	iowrite8(0, &mvdev->desc->status);
+}
+
+static void mic_reset(struct virtio_device *vdev)
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+
+	dev_dbg(mic_dev(mvdev), "%s: virtio id %d\n",
+		__func__, vdev->id.device);
+
+	mic_reset_inform_host(vdev);
+	complete_all(&mvdev->reset_done);
+}
+
+/*
+ * The virtio_ring code calls this API when it wants to notify the Host.
+ */
+static void mic_notify(struct virtqueue *vq)
+{
+	struct mic_vdev *mvdev = vq->priv;
+
+	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
+}
+
+static void mic_del_vq(struct virtqueue *vq, int n)
+{
+	struct mic_vdev *mvdev = to_micvdev(vq->vdev);
+	struct vring *vr = (struct vring *) (vq + 1);
+
+	free_pages((unsigned long) vr->used,
+		get_order(mvdev->used_size[n]));
+	vring_del_virtqueue(vq);
+	mic_card_unmap(mvdev->mdev, mvdev->vr[n]);
+	mvdev->vr[n] = NULL;
+}
+
+static void mic_del_vqs(struct virtio_device *vdev)
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+	struct virtqueue *vq, *n;
+	int idx = 0;
+
+	dev_dbg(mic_dev(mvdev), "%s\n", __func__);
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		mic_del_vq(vq, idx++);
+}
+
+/*
+ * This routine will assign vring's allocated in host/io memory. Code in
+ * virtio_ring.c however continues to access this io memory as if it were local
+ * memory without io accessors.
+ */
+static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
+				     unsigned index,
+				     void (*callback)(struct virtqueue *vq),
+				     const char *name)
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+	struct mic_vqconfig __iomem *vqconfig;
+	struct mic_vqconfig config;
+	struct virtqueue *vq;
+	void __iomem *va;
+	struct _mic_vring_info __iomem *info;
+	void *used;
+	int vr_size, _vr_size, err, magic;
+	struct vring *vr;
+	u8 type = ioread8(&mvdev->desc->type);
+
+	if (index >= ioread8(&mvdev->desc->num_vq))
+		return ERR_PTR(-ENOENT);
+
+	if (!name)
+		return ERR_PTR(-ENOENT);
+
+	/* First assign the vring's allocated in host memory */
+	vqconfig = mic_vq_config(mvdev->desc) + index;
+	memcpy_fromio(&config, vqconfig, sizeof(config));
+	_vr_size = vring_size(config.num, MIC_VIRTIO_RING_ALIGN);
+	vr_size = PAGE_ALIGN(_vr_size + sizeof(struct _mic_vring_info));
+	va = mic_card_map(mvdev->mdev, config.address, vr_size);
+	if (!va)
+		return ERR_PTR(-ENOMEM);
+	mvdev->vr[index] = va;
+	memset_io(va, 0x0, _vr_size);
+	vq = vring_new_virtqueue(index,
+				config.num, MIC_VIRTIO_RING_ALIGN, vdev,
+				false,
+				va, mic_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto unmap;
+	}
+	info = va + _vr_size;
+	magic = ioread32(&info->magic);
+
+	if (WARN(magic != MIC_MAGIC + type + index, "magic mismatch")) {
+		err = -EIO;
+		goto unmap;
+	}
+
+	/* Allocate and reassign used ring now */
+	mvdev->used_size[index] = PAGE_ALIGN(sizeof(__u16) * 3 +
+			sizeof(struct vring_used_elem) * config.num);
+	used = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(mvdev->used_size[index]));
+	if (!used) {
+		err = -ENOMEM;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, err);
+		goto del_vq;
+	}
+	iowrite64(virt_to_phys(used), &vqconfig->used_address);
+
+	/*
+	 * To reassign the used ring here we are directly accessing
+	 * struct vring_virtqueue which is a private data structure
+	 * in virtio_ring.c. At the minimum, a BUILD_BUG_ON() in
+	 * vring_new_virtqueue() would ensure that
+	 *  (&vq->vring == (struct vring *) (&vq->vq + 1));
+	 */
+	vr = (struct vring *) (vq + 1);
+	vr->used = used;
+
+	vq->priv = mvdev;
+	return vq;
+del_vq:
+	vring_del_virtqueue(vq);
+unmap:
+	mic_card_unmap(mvdev->mdev, mvdev->vr[index]);
+	return ERR_PTR(err);
+}
+
+static int mic_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+			struct virtqueue *vqs[],
+			vq_callback_t *callbacks[],
+			const char *names[])
+{
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+	struct mic_device_ctrl __iomem *dc = mvdev->dc;
+	int i, err, retry = 100;
+
+	/* We must have this many virtqueues. */
+	if (nvqs > ioread8(&mvdev->desc->num_vq))
+		return -ENOENT;
+
+	for (i = 0; i < nvqs; ++i) {
+		dev_dbg(mic_dev(mvdev), "%s: %d: %s\n",
+			__func__, i, names[i]);
+		vqs[i] = mic_find_vq(vdev, i, callbacks[i], names[i]);
+		if (IS_ERR(vqs[i])) {
+			err = PTR_ERR(vqs[i]);
+			goto error;
+		}
+	}
+
+	iowrite8(1, &dc->used_address_updated);
+	/*
+	 * Send an interrupt to the host to inform it that used
+	 * rings have been re-assigned.
+	 */
+	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
+	for (i = retry; i--;) {
+		if (!ioread8(&dc->used_address_updated))
+			break;
+		msleep(100);
+	};
+
+	dev_dbg(mic_dev(mvdev), "%s: retry: %d\n", __func__, retry);
+	if (!retry) {
+		err = -ENODEV;
+		goto error;
+	}
+
+	return 0;
+error:
+	mic_del_vqs(vdev);
+	return err;
+}
+
+/*
+ * The config ops structure as defined by virtio config
+ */
+static struct virtio_config_ops mic_vq_config_ops = {
+	.get_features = mic_get_features,
+	.finalize_features = mic_finalize_features,
+	.get = mic_get,
+	.set = mic_set,
+	.get_status = mic_get_status,
+	.set_status = mic_set_status,
+	.reset = mic_reset,
+	.find_vqs = mic_find_vqs,
+	.del_vqs = mic_del_vqs,
+};
+
+static irqreturn_t
+mic_virtio_intr_handler(int irq, void *data)
+{
+	struct mic_vdev *mvdev = data;
+	struct virtqueue *vq;
+
+	mic_ack_interrupt(mvdev->mdev);
+	list_for_each_entry(vq, &mvdev->vdev.vqs, list)
+		vring_interrupt(0, vq);
+
+	return IRQ_HANDLED;
+}
+
+static void mic_virtio_release_dev(struct device *_d)
+{
+	/*
+	 * No need for a release method similar to virtio PCI.
+	 * Provide an empty one to avoid getting a warning from core.
+	 */
+}
+
+/*
+ * adds a new device and register it with virtio
+ * appropriate drivers are loaded by the device model
+ */
+static int mic_add_device(struct mic_device_desc __iomem *d,
+	unsigned int offset, struct mic_driver *mdrv)
+{
+	struct mic_vdev *mvdev;
+	int ret;
+	int virtio_db;
+	u8 type = ioread8(&d->type);
+
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev) {
+		dev_err(mdrv->dev, "Cannot allocate mic dev %u type %u\n",
+			offset, type);
+		return -ENOMEM;
+	}
+
+	mvdev->mdev = &mdrv->mdev;
+	mvdev->vdev.dev.parent = mdrv->dev;
+	mvdev->vdev.dev.release = mic_virtio_release_dev;
+	mvdev->vdev.id.device = type;
+	mvdev->vdev.config = &mic_vq_config_ops;
+	mvdev->desc = d;
+	mvdev->dc = (void __iomem *)d + mic_aligned_desc_size(d);
+	init_completion(&mvdev->reset_done);
+
+	virtio_db = mic_next_card_db();
+	mvdev->virtio_cookie = mic_request_card_irq(mic_virtio_intr_handler,
+			"virtio intr", mvdev, virtio_db);
+	if (IS_ERR(mvdev->virtio_cookie)) {
+		ret = PTR_ERR(mvdev->virtio_cookie);
+		goto kfree;
+	}
+	iowrite8((u8)virtio_db, &mvdev->dc->h2c_vdev_db);
+	mvdev->c2h_vdev_db = ioread8(&mvdev->dc->c2h_vdev_db);
+
+	ret = register_virtio_device(&mvdev->vdev);
+	if (ret) {
+		dev_err(mic_dev(mvdev),
+			"Failed to register mic device %u type %u\n",
+			offset, type);
+		goto free_irq;
+	}
+	iowrite64((u64)mvdev, &mvdev->dc->vdev);
+	dev_dbg(mic_dev(mvdev), "%s: registered mic device %u type %u mvdev %p\n",
+		__func__, offset, type, mvdev);
+
+	return 0;
+
+free_irq:
+	mic_free_card_irq(mvdev->virtio_cookie, mvdev);
+kfree:
+	kfree(mvdev);
+	return ret;
+}
+
+/*
+ * match for a mic device with a specific desc pointer
+ */
+static int mic_match_desc(struct device *dev, void *data)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	struct mic_vdev *mvdev = to_micvdev(vdev);
+
+	return mvdev->desc == (void __iomem *)data;
+}
+
+static void mic_handle_config_change(struct mic_device_desc __iomem *d,
+	unsigned int offset, struct mic_driver *mdrv)
+{
+	struct mic_device_ctrl __iomem *dc
+		= (void __iomem *)d + mic_aligned_desc_size(d);
+	struct mic_vdev *mvdev = (struct mic_vdev *)ioread64(&dc->vdev);
+	struct virtio_driver *drv;
+
+	if (ioread8(&dc->config_change) != MIC_VIRTIO_PARAM_CONFIG_CHANGED)
+		return;
+
+	dev_dbg(mdrv->dev, "%s %d\n", __func__, __LINE__);
+	drv = container_of(mvdev->vdev.dev.driver,
+				struct virtio_driver, driver);
+	if (drv->config_changed)
+		drv->config_changed(&mvdev->vdev);
+	iowrite8(1, &dc->guest_ack);
+}
+
+/*
+ * removes a virtio device if a hot remove event has been
+ * requested by the host.
+ */
+static int mic_remove_device(struct mic_device_desc __iomem *d,
+	unsigned int offset, struct mic_driver *mdrv)
+{
+	struct mic_device_ctrl __iomem *dc
+		= (void __iomem *)d + mic_aligned_desc_size(d);
+	struct mic_vdev *mvdev = (struct mic_vdev *)ioread64(&dc->vdev);
+	u8 status;
+	int ret = -1;
+
+	if (ioread8(&dc->config_change) == MIC_VIRTIO_PARAM_DEV_REMOVE) {
+		dev_dbg(mdrv->dev,
+			"%s %d config_change %d type %d mvdev %p\n",
+			__func__, __LINE__,
+			ioread8(&dc->config_change), ioread8(&d->type), mvdev);
+
+		status = ioread8(&d->status);
+		INIT_COMPLETION(mvdev->reset_done);
+		unregister_virtio_device(&mvdev->vdev);
+		mic_free_card_irq(mvdev->virtio_cookie, mvdev);
+		if (status & VIRTIO_CONFIG_S_DRIVER_OK)
+			wait_for_completion(&mvdev->reset_done);
+		kfree(mvdev);
+		iowrite8(1, &dc->guest_ack);
+		dev_dbg(mdrv->dev, "%s %d guest_ack %d\n",
+			__func__, __LINE__, ioread8(&dc->guest_ack));
+		ret = 0;
+	}
+
+	return ret;
+}
+
+#define REMOVE_DEVICES true
+
+static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
+{
+	s8 type;
+	unsigned int i;
+	struct mic_device_desc __iomem *d;
+	struct mic_device_ctrl __iomem *dc;
+	struct device *dev;
+	int ret;
+
+	for (i = mic_aligned_size(struct mic_bootparam);
+		i < MIC_DP_SIZE; i += mic_total_desc_size(d)) {
+		d = mdrv->dp + i;
+		dc = (void __iomem *)d + mic_aligned_desc_size(d);
+		/*
+		 * This read barrier is paired with the corresponding write
+		 * barrier on the host which is inserted before adding or
+		 * removing a virtio device descriptor, by updating the type.
+		 */
+		rmb();
+		type = ioread8(&d->type);
+
+		/* end of list */
+		if (type == 0)
+			break;
+
+		if (type == -1)
+			continue;
+
+		/* device already exists */
+		dev = device_find_child(mdrv->dev, d, mic_match_desc);
+		if (dev) {
+			if (remove)
+				iowrite8(MIC_VIRTIO_PARAM_DEV_REMOVE,
+					&dc->config_change);
+			put_device(dev);
+			mic_handle_config_change(d, i, mdrv);
+			ret = mic_remove_device(d, i, mdrv);
+			if (!ret && !remove)
+				iowrite8(-1, &d->type);
+			if (remove) {
+				iowrite8(0, &dc->config_change);
+				iowrite8(0, &dc->guest_ack);
+			}
+			continue;
+		}
+
+		/* new device */
+		dev_dbg(mdrv->dev, "%s %d Adding new virtio device %p\n",
+				__func__, __LINE__, d);
+		if (!remove)
+			mic_add_device(d, i, mdrv);
+	}
+}
+
+/*
+ * mic_hotplug_device tries to find changes in the device page.
+ */
+static void mic_hotplug_devices(struct work_struct *work)
+{
+	struct mic_driver *mdrv = container_of(work,
+		struct mic_driver, hotplug_work);
+
+	mic_scan_devices(mdrv, !REMOVE_DEVICES);
+}
+
+/*
+ * Interrupt handler for hot plug/config changes etc.
+ */
+static irqreturn_t
+mic_extint_handler(int irq, void *data)
+{
+	struct mic_driver *mdrv = (struct mic_driver *)data;
+
+	dev_dbg(mdrv->dev, "%s %d hotplug work\n",
+		__func__, __LINE__);
+	mic_ack_interrupt(&mdrv->mdev);
+	schedule_work(&mdrv->hotplug_work);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Init function for virtio
+ */
+int mic_devices_init(struct mic_driver *mdrv)
+{
+	int rc;
+	struct mic_bootparam __iomem *bootparam;
+	int config_db;
+
+	INIT_WORK(&mdrv->hotplug_work, mic_hotplug_devices);
+	mic_scan_devices(mdrv, !REMOVE_DEVICES);
+
+	config_db = mic_next_card_db();
+	virtio_config_cookie = mic_request_card_irq(mic_extint_handler,
+			"virtio_config_intr", mdrv, config_db);
+	if (IS_ERR(virtio_config_cookie)) {
+		rc = PTR_ERR(virtio_config_cookie);
+		goto exit;
+	}
+
+	bootparam = mdrv->dp;
+	iowrite8(config_db, &bootparam->h2c_config_db);
+	return 0;
+exit:
+	return rc;
+}
+
+/*
+ * Uninit function for virtio
+ */
+void mic_devices_uninit(struct mic_driver *mdrv)
+{
+	struct mic_bootparam __iomem *bootparam = mdrv->dp;
+	iowrite8(-1, &bootparam->h2c_config_db);
+	mic_free_card_irq(virtio_config_cookie, mdrv);
+	flush_work(&mdrv->hotplug_work);
+	mic_scan_devices(mdrv, REMOVE_DEVICES);
+}
diff --git a/drivers/misc/mic/card/mic_virtio.h b/drivers/misc/mic/card/mic_virtio.h
new file mode 100644
index 0000000..2c5c22c
--- /dev/null
+++ b/drivers/misc/mic/card/mic_virtio.h
@@ -0,0 +1,77 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
+ *
+ * Intel MIC Card driver.
+ *
+ */
+#ifndef __MIC_CARD_VIRTIO_H
+#define __MIC_CARD_VIRTIO_H
+
+#include <linux/mic_common.h>
+#include "mic_device.h"
+
+/*
+ * 64 bit I/O access
+ */
+#ifndef ioread64
+#define ioread64 readq
+#endif
+#ifndef iowrite64
+#define iowrite64 writeq
+#endif
+
+static inline unsigned mic_desc_size(struct mic_device_desc __iomem *desc)
+{
+	return mic_aligned_size(*desc)
+		+ ioread8(&desc->num_vq) * mic_aligned_size(struct mic_vqconfig)
+		+ ioread8(&desc->feature_len) * 2
+		+ ioread8(&desc->config_len);
+}
+
+static inline struct mic_vqconfig __iomem *
+mic_vq_config(struct mic_device_desc __iomem *desc)
+{
+	return (struct mic_vqconfig __iomem *)(desc + 1);
+}
+
+static inline __u8 __iomem *
+mic_vq_features(struct mic_device_desc __iomem *desc)
+{
+	return (__u8 __iomem *)(mic_vq_config(desc) + ioread8(&desc->num_vq));
+}
+
+static inline __u8 __iomem *
+mic_vq_configspace(struct mic_device_desc __iomem *desc)
+{
+	return mic_vq_features(desc) + ioread8(&desc->feature_len) * 2;
+}
+static inline unsigned mic_total_desc_size(struct mic_device_desc __iomem *desc)
+{
+	return mic_aligned_desc_size(desc) +
+		mic_aligned_size(struct mic_device_ctrl);
+}
+
+int mic_devices_init(struct mic_driver *mdrv);
+void mic_devices_uninit(struct mic_driver *mdrv);
+
+#endif
-- 
1.8.2.1

