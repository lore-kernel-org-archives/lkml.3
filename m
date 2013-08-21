Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3HURu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:50:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3HURuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:50:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366351304"
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
Subject: [PATCH v3 2/7] Intel MIC Host Driver Interrupt/SMPT support.
Date: Wed, 21 Aug 2013 10:50:10 -0700
Message-Id: <2479624bf0e3c2363bba68c93219ac19df19b197.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>

This patch enables the following features:
a) MSIx, MSI and legacy interrupt support.
b) System Memory Page Table(SMPT) support. SMPT enables system memory
   access from the card. On X100 devices the host can program 32 SMPT
   registers each capable of accessing 16GB of system memory
   address space from X100 devices. The registers can thereby be used
   to access a cumulative 512GB of system memory address space from
   X100 devices at any point in time.

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
 drivers/misc/mic/host/Makefile     |   1 +
 drivers/misc/mic/host/mic_device.h | 126 ++++++++
 drivers/misc/mic/host/mic_main.c   | 647 ++++++++++++++++++++++++++++++++++++-
 drivers/misc/mic/host/mic_smpt.c   | 440 +++++++++++++++++++++++++
 drivers/misc/mic/host/mic_smpt.h   |  98 ++++++
 drivers/misc/mic/host/mic_x100.c   | 247 ++++++++++++++
 drivers/misc/mic/host/mic_x100.h   |  40 +++
 7 files changed, 1597 insertions(+), 2 deletions(-)
 create mode 100644 drivers/misc/mic/host/mic_smpt.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.h

diff --git a/drivers/misc/mic/host/Makefile b/drivers/misc/mic/host/Makefile
index 93b9d25..3702d2a 100644
--- a/drivers/misc/mic/host/Makefile
+++ b/drivers/misc/mic/host/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_INTEL_MIC_HOST) += mic_host.o
 mic_host-objs := mic_main.o
 mic_host-objs += mic_x100.o
 mic_host-objs += mic_sysfs.o
+mic_host-objs += mic_smpt.o
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 6cd904c..0ccb2da 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -21,9 +21,18 @@
 #ifndef _MIC_DEVICE_H_
 #define _MIC_DEVICE_H_
 
+#include <linux/idr.h>
+
 /* The maximum number of MIC devices supported in a single host system. */
 #define MIC_MAX_NUM_DEVS 256
 
+/*
+ * The minimum number of msix vectors required for normal operation.
+ * 3 for virtio network, console and block devices.
+ * 1 for card shutdown notifications.
+ */
+#define MIC_MIN_MSIX 4
+
 /**
  * enum mic_hw_family - The hardware family to which a device belongs.
  */
@@ -43,6 +52,77 @@ enum mic_stepping {
 };
 
 /**
+ * mic_intr_source - The type of source that will generate
+ * the interrupt.The number of types needs to be in sync with
+ * MIC_NUM_INTR_TYPES
+ *
+ * MIC_INTR_DB: The source is a doorbell
+ * MIC_INTR_DMA: The source is a DMA channel
+ * MIC_INTR_ERR: The source is an error interrupt e.g. SBOX ERR
+ * MIC_NUM_INTR_TYPES: Total number of interrupt sources.
+ */
+enum mic_intr_type {
+	MIC_INTR_DB = 0,
+	MIC_INTR_DMA,
+	MIC_INTR_ERR,
+	MIC_NUM_INTR_TYPES
+};
+
+/**
+ * struct mic_intr_info - Contains h/w specific interrupt sources
+ * information.
+ *
+ * @intr_start_idx: Contains the starting indexes of the
+ * interrupt types.
+ * @intr_len: Contains the length of the interrupt types.
+ */
+struct mic_intr_info {
+	u16 intr_start_idx[MIC_NUM_INTR_TYPES];
+	u16 intr_len[MIC_NUM_INTR_TYPES];
+};
+
+/**
+ * struct mic_irq_info - OS specific irq information
+ *
+ * @next_avail_src: next available doorbell that can be assigned.
+ * @msix_entries: msix entries allocated while setting up MSI-x
+ * @mic_msi_map: The MSI/MSI-x mapping information.
+ * @num_vectors: The number of MSI/MSI-x vectors that have been allocated.
+ * @cb_ida: callback ID allocator to track the callbacks registered.
+ * @mic_intr_lock: spinlock to protect the interrupt callback list.
+ * @cb_list: Array of callback lists one for each source.
+ */
+struct mic_irq_info {
+	int next_avail_src;
+	struct msix_entry *msix_entries;
+	u32 *mic_msi_map;
+	u16 num_vectors;
+	struct ida cb_ida;
+	spinlock_t mic_intr_lock;
+	struct list_head *cb_list;
+};
+
+/**
+ * struct mic_intr_cb - Interrupt callback structure.
+ *
+ * @func: The callback function
+ * @data: Private data of the requester.
+ * @cb_id: The callback id. Identifies this callback.
+ * @list: list head pointing to the next callback structure.
+ */
+struct mic_intr_cb {
+	irqreturn_t (*func) (int irq, void *data);
+	void *data;
+	int cb_id;
+	struct list_head list;
+};
+
+/**
+ * struct mic_irq - opaque pointer used as cookie
+ */
+struct mic_irq;
+
+/**
  * struct mic_device -  MIC device information for each card.
  *
  * @mmio: MMIO bar information.
@@ -53,6 +133,12 @@ enum mic_stepping {
  * @stepping: Stepping ID.
  * @attr_group: Pointer to list of sysfs attribute groups.
  * @sdev: Device for sysfs entries.
+ * @mic_mutex: Mutex for synchronizing access to mic_device.
+ * @intr_ops: HW specific interrupt operations.
+ * @smpt_ops: Hardware specific SMPT operations.
+ * @smpt: MIC SMPT information.
+ * @intr_info: H/W specific interrupt information.
+ * @irq_info: The OS specific irq information
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -63,6 +149,32 @@ struct mic_device {
 	enum mic_stepping stepping;
 	const struct attribute_group **attr_group;
 	struct device *sdev;
+	struct mutex mic_mutex;
+	struct mic_hw_intr_ops *intr_ops;
+	struct mic_smpt_ops *smpt_ops;
+	struct mic_smpt_info *smpt;
+	struct mic_intr_info *intr_info;
+	struct mic_irq_info irq_info;
+};
+
+/**
+ * struct mic_hw_intr_ops: MIC HW specific interrupt operations
+ * @intr_init: Initialize H/W specific interrupt information.
+ * @enable_interrupts: Enable interrupts from the hardware.
+ * @disable_interrupts: Disable interrupts from the hardware.
+ * @program_msi_to_src_map: Update MSI mapping registers with
+ * irq information.
+ * @read_msi_to_src_map: Read MSI mapping registers containing
+ * irq information.
+ */
+struct mic_hw_intr_ops {
+	void (*intr_init)(struct mic_device *mdev);
+	void (*enable_interrupts)(struct mic_device *mdev);
+	void (*disable_interrupts)(struct mic_device *mdev);
+	void (*program_msi_to_src_map) (struct mic_device *mdev,
+			int idx, int intr_src, bool set);
+	u32 (*read_msi_to_src_map) (struct mic_device *mdev,
+			int idx);
 };
 
 /**
@@ -71,12 +183,17 @@ struct mic_device {
  * @mmio_bar: MMIO bar resource number.
  * @read_spad: Read from scratch pad register.
  * @write_spad: Write to scratch pad register.
+ * @send_intr: Send an interrupt for a particular doorbell on the card.
+ * @ack_interrupt: Hardware specific operations to ack the h/w on
+ * receipt of an interrupt.
  */
 struct mic_hw_ops {
 	u8 aper_bar;
 	u8 mmio_bar;
 	u32 (*read_spad)(struct mic_device *mdev, unsigned int idx);
 	void (*write_spad)(struct mic_device *mdev, unsigned int idx, u32 val);
+	void (*send_intr)(struct mic_device *mdev, int doorbell);
+	u32 (*ack_interrupt)(struct mic_device *mdev);
 };
 
 /**
@@ -106,4 +223,13 @@ mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
 }
 
 void mic_sysfs_init(struct mic_device *mdev);
+int mic_next_db(struct mic_device *mdev);
+struct mic_irq *mic_request_irq(struct mic_device *mdev,
+	irqreturn_t (*func)(int irq, void *data),
+	const char *name, void *data, int intr_src,
+	enum mic_intr_type type);
+
+void mic_free_irq(struct mic_device *mdev,
+		struct mic_irq *cookie, void *data);
+void mic_intr_restore(struct mic_device *mdev);
 #endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index 228c96c..3103842 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -23,13 +23,14 @@
  * 2) Enable per vring interrupt support.
  */
 #include <linux/fs.h>
-#include <linux/idr.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
 #include "../common/mic_device.h"
 #include "mic_device.h"
 #include "mic_x100.h"
+#include "mic_smpt.h"
 
 static const char mic_driver_name[] = "mic";
 
@@ -63,6 +64,626 @@ static struct class *g_mic_class;
 /* Base device node number for MIC devices */
 static dev_t g_mic_devno;
 
+/*
+ * mic_invoke_callback - Invoke callback functions registered for
+ * the corresponding source id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The interrupt source id.
+ *
+ * Returns none.
+ */
+static inline void mic_invoke_callback(struct mic_device *mdev, int idx)
+{
+	struct mic_intr_cb *intr_cb;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+
+	spin_lock(&mdev->irq_info.mic_intr_lock);
+	list_for_each_entry(intr_cb, &mdev->irq_info.cb_list[idx], list)
+		if (intr_cb->func)
+			intr_cb->func(pdev->irq, intr_cb->data);
+	spin_unlock(&mdev->irq_info.mic_intr_lock);
+}
+
+/**
+ * mic_interrupt - Generic interrupt handler for
+ * MSI and INTx based interrupts.
+ */
+static irqreturn_t mic_interrupt(int irq, void *dev)
+{
+	struct mic_device *mdev = dev;
+	struct mic_intr_info *info = mdev->intr_info;
+	u32 mask;
+	int i;
+
+	mask = mdev->ops->ack_interrupt(mdev);
+	if (!mask)
+		return IRQ_NONE;
+
+	for (i = info->intr_start_idx[MIC_INTR_DB];
+			i < info->intr_len[MIC_INTR_DB]; i++)
+		if (mask & BIT(i))
+			mic_invoke_callback(mdev, i);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * mic_next_db - Retrieve the next doorbell interrupt source id.
+ * The id is picked sequentially from the available pool of
+ * doorlbell ids.
+ *
+ * @mdev: pointer to the mic_device instance.
+ *
+ * Returns the next doorbell interrupt source.
+ */
+int mic_next_db(struct mic_device *mdev)
+{
+	int next_db;
+
+	next_db = mdev->irq_info.next_avail_src %
+		mdev->intr_info->intr_len[MIC_INTR_DB];
+	mdev->irq_info.next_avail_src++;
+	return next_db;
+}
+
+/* Return the interrupt offset from the index. Index is 0 based. */
+static u16 mic_map_src_to_offset(struct mic_device *mdev,
+		int intr_src, enum mic_intr_type type) {
+
+	if (type >= MIC_NUM_INTR_TYPES)
+		return MIC_NUM_OFFSETS;
+
+	if (intr_src >= mdev->intr_info->intr_len[type])
+		return MIC_NUM_OFFSETS;
+
+	return mdev->intr_info->intr_start_idx[type] + intr_src;
+}
+
+/* Return next available msix_entry. */
+static struct msix_entry *mic_get_available_vector(struct mic_device *mdev)
+{
+	int i;
+	struct mic_irq_info *info = &mdev->irq_info;
+
+	for (i = 0; i < info->num_vectors; i++)
+		if (!info->mic_msi_map[i])
+			return &info->msix_entries[i];
+
+	return NULL;
+}
+
+/**
+ * mic_intr_restore - Restore h/w specific interrupt
+ * registers after a card reset. mic_mutex needs to be
+ * held before calling this function.
+ *
+ */
+void mic_intr_restore(struct mic_device *mdev)
+{
+	int entry, offset;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+
+	if (!pci_dev_msi_enabled(pdev))
+		return;
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	for (entry = 0; entry < mdev->irq_info.num_vectors; entry++) {
+		for (offset = 0; offset < MIC_NUM_OFFSETS; offset++) {
+			if (mdev->irq_info.mic_msi_map[entry] & BIT(offset))
+				mdev->intr_ops->program_msi_to_src_map(mdev,
+					entry, offset, true);
+		}
+	}
+}
+
+/**
+ * mic_register_intr_callback - Register a callback handler for the
+ * given source id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The source id to be registered.
+ * @func: The function to be called when the source id receives
+ * the interrupt.
+ * @data: Private data of the requester.
+ * Return the callback structure that was registered or an
+ * appropriate error on failure.
+ */
+static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
+			u8 idx, irqreturn_t (*func) (int irq, void *dev),
+			void *data)
+{
+	struct mic_intr_cb *intr_cb;
+	unsigned long flags;
+	int rc;
+	intr_cb = kmalloc(sizeof(struct mic_intr_cb), GFP_KERNEL);
+
+	if (!intr_cb)
+		return ERR_PTR(-ENOMEM);
+
+	intr_cb->func = func;
+	intr_cb->data = data;
+	intr_cb->cb_id = ida_simple_get(&mdev->irq_info.cb_ida,
+		0, 0, GFP_KERNEL);
+	if (intr_cb->cb_id < 0) {
+		rc = intr_cb->cb_id;
+		goto ida_fail;
+	}
+
+	spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+	list_add_tail(&intr_cb->list, &mdev->irq_info.cb_list[idx]);
+	spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+
+	return intr_cb;
+ida_fail:
+	kfree(intr_cb);
+	return ERR_PTR(rc);
+}
+
+/**
+ * mic_unregister_intr_callback - Unregister the callback handler
+ * identified by its callback id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The callback structure id to be unregistered.
+ * Return the source id that was unregistered or MIC_NUM_OFFSETS if no
+ * such callback handler was found.
+ */
+static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
+{
+	struct list_head *pos, *tmp;
+	struct mic_intr_cb *intr_cb;
+	unsigned long flags;
+	int i;
+
+	for (i = 0;  i < MIC_NUM_OFFSETS; i++) {
+		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
+			intr_cb = list_entry(pos, struct mic_intr_cb, list);
+			if (intr_cb->cb_id == idx) {
+				list_del(pos);
+				ida_simple_remove(&mdev->irq_info.cb_ida,
+					intr_cb->cb_id);
+				kfree(intr_cb);
+				spin_unlock_irqrestore(
+					&mdev->irq_info.mic_intr_lock, flags);
+				return i;
+			}
+		}
+		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	}
+
+	return MIC_NUM_OFFSETS;
+}
+
+#define COOKIE_ID_SHIFT 16
+#define GET_ENTRY(cookie) ((cookie) & 0xFFFF)
+#define GET_OFFSET(cookie) ((cookie) >> COOKIE_ID_SHIFT)
+#define MK_COOKIE(x, y) ((x) | (y) << COOKIE_ID_SHIFT)
+
+/**
+ * mic_request_irq - request an irq. mic_mutex needs
+ * to be held before calling this function.
+ *
+ * @mdev: pointer to mic_device instance
+ * @func: The callback function that handles the interrupt.
+ * The function needs to call ack_interrupts
+ * (mdev->ops->ack_interrupt(mdev)) when handling the interrupts.
+ * @name: The ASCII name of the callee requesting the irq.
+ * @data: private data that is returned back when calling the
+ * function handler.
+ * @intr_src: The source id of the requester. Its the doorbell id
+ * for Doorbell interrupts and DMA channel id for DMA interrupts.
+ * @type: The type of interrupt. Values defined in mic_intr_type
+ *
+ * returns: The cookie that is transparent to the caller. Passed
+ * back when calling mic_free_irq. An appropriate error code
+ * is returned on failure. Caller needs to use IS_ERR(return_val)
+ * to check for failure and PTR_ERR(return_val) to obtained the
+ * error code.
+ *
+ */
+struct mic_irq *mic_request_irq(struct mic_device *mdev,
+	irqreturn_t (*func)(int irq, void *dev),
+	const char *name, void *data, int intr_src,
+	enum mic_intr_type type) {
+
+	u16 offset;
+	int rc = 0;
+	struct msix_entry *msix = NULL;
+	unsigned long cookie = 0;
+	u16 entry;
+	struct mic_intr_cb *intr_cb;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+
+	if (!mdev) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	offset = mic_map_src_to_offset(mdev, intr_src, type);
+	if (offset >= MIC_NUM_OFFSETS) {
+		dev_err(mdev->sdev->parent,
+				"Error mapping index %d to a valid source id.\n",
+				intr_src);
+		rc = -EINVAL;
+		goto err;
+	}
+
+	if (mdev->irq_info.num_vectors > 1) {
+		msix = mic_get_available_vector(mdev);
+		if (!msix) {
+			dev_err(mdev->sdev->parent,
+			"No MSIx vectors available for use.\n");
+			rc = -ENOSPC;
+			goto err;
+		}
+
+		rc = request_irq(msix->vector, func, 0, name, data);
+		if (rc) {
+			dev_dbg(mdev->sdev->parent,
+				"request irq failed rc = %d\n", rc);
+			goto err;
+		}
+
+		entry = msix->entry;
+		mdev->irq_info.mic_msi_map[entry] |= BIT(offset);
+		mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, offset, true);
+		cookie = MK_COOKIE(entry, offset);
+		dev_dbg(mdev->sdev->parent, "irq: %d assigned for src: %d\n",
+			msix->vector, intr_src);
+	} else {
+		intr_cb = mic_register_intr_callback(mdev,
+				offset, func, data);
+		if (IS_ERR(intr_cb)) {
+			dev_err(mdev->sdev->parent,
+			"No available callback entries for use\n");
+			rc = PTR_ERR(intr_cb);
+			goto err;
+		}
+
+		entry = 0;
+		if (pci_dev_msi_enabled(pdev)) {
+			mdev->irq_info.mic_msi_map[entry] |= (1 << offset);
+			mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, offset, true);
+		}
+		cookie = MK_COOKIE(entry, intr_cb->cb_id);
+		dev_dbg(mdev->sdev->parent, "callback %d registered for src: %d\n",
+			intr_cb->cb_id, intr_src);
+	}
+
+	return (struct mic_irq *)cookie;
+err:
+	return ERR_PTR(rc);
+}
+
+/**
+ * mic_free_irq - free irq. mic_mutex
+ *  needs to be held before calling this function.
+ *
+ * @mdev: pointer to mic_device instance
+ * @cookie: cookie obtained during a successful call to mic_request_irq
+ * @data: private data specified by the calling function during the
+ * mic_request_irq
+ *
+ * returns: none.
+ */
+void mic_free_irq(struct mic_device *mdev,
+		struct mic_irq *cookie, void *data)
+{
+	u32 offset;
+	u32 entry;
+	u8 src_id;
+	unsigned int irq;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+
+	if (!mdev)
+		return;
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+
+	entry = GET_ENTRY((unsigned long)cookie);
+	offset = GET_OFFSET((unsigned long)cookie);
+	if (mdev->irq_info.num_vectors > 1) {
+		if (entry >= mdev->irq_info.num_vectors) {
+			dev_warn(mdev->sdev->parent,
+				"entry %d should be < num_irq %d\n",
+				entry, mdev->irq_info.num_vectors);
+			return;
+		}
+		irq = mdev->irq_info.msix_entries[entry].vector;
+		free_irq(irq, data);
+		mdev->irq_info.mic_msi_map[entry] &= ~(BIT(offset));
+		mdev->intr_ops->program_msi_to_src_map(mdev,
+			entry, offset, false);
+
+		dev_dbg(mdev->sdev->parent, "irq: %d freed\n", irq);
+	} else {
+		irq = pdev->irq;
+		src_id = mic_unregister_intr_callback(mdev, offset);
+		if (src_id >= MIC_NUM_OFFSETS) {
+			dev_warn(mdev->sdev->parent, "Error unregistering callback\n");
+			return;
+		}
+		if (pci_dev_msi_enabled(pdev)) {
+			mdev->irq_info.mic_msi_map[entry] &= ~(BIT(src_id));
+			mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, src_id, false);
+		}
+		dev_dbg(mdev->sdev->parent, "callback %d unregistered for src: %d\n",
+			offset, src_id);
+	}
+}
+
+/**
+ * mic_setup_msix - Initializes MSIx interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_msix(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	int rc, i;
+
+	mdev->irq_info.msix_entries = kmalloc(sizeof(struct msix_entry) *
+			MIC_MIN_MSIX, GFP_KERNEL);
+	if (!mdev->irq_info.msix_entries) {
+		rc = -ENOMEM;
+		goto err_nomem1;
+	}
+
+	for (i = 0; i < MIC_MIN_MSIX; i++)
+		mdev->irq_info.msix_entries[i].entry = i;
+
+	rc = pci_enable_msix(pdev, mdev->irq_info.msix_entries,
+		MIC_MIN_MSIX);
+	if (rc) {
+		dev_dbg(&pdev->dev, "Error enabling MSIx. rc = %d\n", rc);
+		goto err_enable_msix;
+	}
+
+	mdev->irq_info.num_vectors = MIC_MIN_MSIX;
+	mdev->irq_info.mic_msi_map = kzalloc((sizeof(u32) *
+		mdev->irq_info.num_vectors), GFP_KERNEL);
+
+	if (!mdev->irq_info.mic_msi_map) {
+		rc = -ENOMEM;
+		goto err_nomem2;
+	}
+
+	dev_dbg(mdev->sdev->parent,
+		"%d MSIx irqs setup\n", mdev->irq_info.num_vectors);
+	return 0;
+
+err_nomem2:
+	pci_disable_msix(pdev);
+err_enable_msix:
+	kfree(mdev->irq_info.msix_entries);
+err_nomem1:
+	mdev->irq_info.num_vectors = 0;
+	return rc;
+}
+
+/**
+ * mic_setup_callbacks - Initialize data structures needed
+ * to handle callbacks.
+ *
+ * @mdev: pointer to mic_device instance
+ */
+static int mic_setup_callbacks(struct mic_device *mdev)
+{
+	int i;
+
+	mdev->irq_info.cb_list = kmalloc(sizeof(struct list_head) *
+		MIC_NUM_OFFSETS, GFP_KERNEL);
+	if (!mdev->irq_info.cb_list)
+		return -ENOMEM;
+
+	for (i = 0; i < MIC_NUM_OFFSETS; i++)
+		INIT_LIST_HEAD(&mdev->irq_info.cb_list[i]);
+	ida_init(&mdev->irq_info.cb_ida);
+	spin_lock_init(&mdev->irq_info.mic_intr_lock);
+	return 0;
+}
+
+/**
+ * mic_release_callbacks - Uninitialize data structures needed
+ * to handle callbacks.
+ *
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_release_callbacks(struct mic_device *mdev)
+{
+	unsigned long flags;
+	struct list_head *pos, *tmp;
+	struct mic_intr_cb *intr_cb;
+	int i;
+
+	for (i = 0; i < MIC_NUM_OFFSETS; i++) {
+		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+
+		if (list_empty(&mdev->irq_info.cb_list[i])) {
+			spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock,
+				flags);
+			break;
+		}
+
+		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
+			intr_cb = list_entry(pos, struct mic_intr_cb, list);
+			list_del(pos);
+			ida_simple_remove(&mdev->irq_info.cb_ida,
+				intr_cb->cb_id);
+			kfree(intr_cb);
+		}
+		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	}
+	ida_destroy(&mdev->irq_info.cb_ida);
+	kfree(mdev->irq_info.cb_list);
+}
+
+/**
+ * mic_setup_msi - Initializes MSI interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ * @pdev: PCI device structure
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_msi(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	int rc;
+
+	rc = pci_enable_msi(pdev);
+	if (rc) {
+		dev_dbg(&pdev->dev, "Error enabling MSI. rc = %d\n", rc);
+		return rc;
+	}
+
+	mdev->irq_info.num_vectors = 1;
+	mdev->irq_info.mic_msi_map = kzalloc((sizeof(u32) *
+		mdev->irq_info.num_vectors), GFP_KERNEL);
+
+	if (!mdev->irq_info.mic_msi_map) {
+		rc = -ENOMEM;
+		goto err_nomem1;
+	}
+
+	rc = mic_setup_callbacks(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error setting up callbacks\n");
+		goto err_nomem2;
+	}
+
+	rc = request_irq(pdev->irq, mic_interrupt, 0 , "mic-msi", mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error allocating MSI interrupt\n");
+		goto err_irq_req_fail;
+	}
+
+	dev_dbg(&pdev->dev, "%d MSI irqs setup\n", mdev->irq_info.num_vectors);
+	return 0;
+
+err_irq_req_fail:
+	mic_release_callbacks(mdev);
+err_nomem2:
+	kfree(mdev->irq_info.mic_msi_map);
+err_nomem1:
+	pci_disable_msi(pdev);
+	mdev->irq_info.num_vectors = 0;
+	return rc;
+}
+
+/**
+ * mic_setup_intx - Initializes legacy interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ * @pdev: PCI device structure
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_intx(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	int rc;
+
+	pci_msi_off(pdev);
+
+	/* Enable intx */
+	pci_intx(pdev, 1);
+
+	rc = mic_setup_callbacks(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error setting up callbacks\n");
+		goto err_nomem;
+	}
+
+	rc = request_irq(pdev->irq, mic_interrupt,
+		IRQF_SHARED, "mic-intx", mdev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&pdev->dev, "intx irq setup\n");
+
+	return 0;
+err:
+	mic_release_callbacks(mdev);
+err_nomem:
+	return rc;
+
+}
+
+/**
+ * mic_setup_interrupts - Initializes interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ * @pdev: PCI device structure
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_interrupts(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	int rc;
+
+	rc = mic_setup_msix(mdev, pdev);
+	if (!rc)
+		goto done;
+
+	rc = mic_setup_msi(mdev, pdev);
+	if (!rc)
+		goto done;
+
+	rc = mic_setup_intx(mdev, pdev);
+	if (rc) {
+		dev_err(mdev->sdev->parent, "no usable interrupts\n");
+		return rc;
+	}
+done:
+	mdev->intr_ops->enable_interrupts(mdev);
+	return 0;
+}
+
+/**
+ * mic_free_interrupts - Frees interrupts setup by mic_setup_interrupts
+ *
+ * @mdev: pointer to mic_device instance
+ * @pdev: PCI device structure
+ *
+ * returns none.
+ */
+static void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	int i;
+
+	mdev->intr_ops->disable_interrupts(mdev);
+	if (mdev->irq_info.num_vectors > 1) {
+		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
+			if (mdev->irq_info.mic_msi_map[i])
+				dev_warn(&pdev->dev, "irq %d may still be in use.\n",
+					mdev->irq_info.msix_entries[i].vector);
+		}
+		kfree(mdev->irq_info.mic_msi_map);
+		kfree(mdev->irq_info.msix_entries);
+		pci_disable_msix(pdev);
+	} else {
+		if (pci_dev_msi_enabled(pdev)) {
+			free_irq(pdev->irq, mdev);
+			kfree(mdev->irq_info.mic_msi_map);
+			pci_disable_msi(pdev);
+		} else {
+			free_irq(pdev->irq, mdev);
+		}
+		mic_release_callbacks(mdev);
+	}
+}
+
 /**
  * mic_ops_init: Initialize HW specific operation tables.
  *
@@ -75,6 +696,8 @@ static void mic_ops_init(struct mic_device *mdev)
 	switch (mdev->family) {
 	case MIC_FAMILY_X100:
 		mdev->ops = &mic_x100_ops;
+		mdev->intr_ops = &mic_x100_intr_ops;
+		mdev->smpt_ops = &mic_x100_smpt_ops;
 		break;
 	default:
 		break;
@@ -132,6 +755,8 @@ mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
 	mdev->stepping = pdev->revision;
 	mic_ops_init(mdev);
 	mic_sysfs_init(mdev);
+	mutex_init(&mdev->mic_mutex);
+	mdev->irq_info.next_avail_src = 0;
 }
 
 /**
@@ -201,6 +826,18 @@ static int mic_probe(struct pci_dev *pdev,
 		goto unmap_mmio;
 	}
 
+	mdev->intr_ops->intr_init(mdev);
+	rc = mic_setup_interrupts(mdev, pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_setup_interrupts failed %d\n", rc);
+		goto unmap_aper;
+	}
+	rc = mic_smpt_init(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "smpt_init failed %d\n", rc);
+		goto free_interrupts;
+	}
+
 	pci_set_drvdata(pdev, mdev);
 
 	mdev->sdev = device_create_with_groups(g_mic_class, &pdev->dev,
@@ -210,9 +847,13 @@ static int mic_probe(struct pci_dev *pdev,
 		rc = PTR_ERR(mdev->sdev);
 		dev_err(&pdev->dev,
 			"device_create_with_groups failed rc %d\n", rc);
-		goto unmap_aper;
+		goto smpt_uninit;
 	}
 	return 0;
+smpt_uninit:
+	mic_smpt_uninit(mdev);
+free_interrupts:
+	mic_free_interrupts(mdev, pdev);
 unmap_aper:
 	iounmap(mdev->aper.va);
 unmap_mmio:
@@ -246,6 +887,8 @@ static void mic_remove(struct pci_dev *pdev)
 		return;
 
 	device_destroy(g_mic_class, MKDEV(MAJOR(g_mic_devno), mdev->id));
+	mic_smpt_uninit(mdev);
+	mic_free_interrupts(mdev, pdev);
 	iounmap(mdev->mmio.va);
 	iounmap(mdev->aper.va);
 	pci_release_regions(pdev);
diff --git a/drivers/misc/mic/host/mic_smpt.c b/drivers/misc/mic/host/mic_smpt.c
new file mode 100644
index 0000000..043dfd6
--- /dev/null
+++ b/drivers/misc/mic/host/mic_smpt.c
@@ -0,0 +1,440 @@
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
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/pci.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_smpt.h"
+
+static inline u64 mic_system_page_mask(struct mic_device *mdev)
+{
+	return (1ULL << mdev->smpt->info.page_shift) - 1ULL;
+}
+
+static inline u64 mic_sys_addr_to_smpt(struct mic_device *mdev, dma_addr_t pa)
+{
+	return (pa - mdev->smpt->info.base) >> mdev->smpt->info.page_shift;
+}
+
+static inline u64 mic_smpt_to_pa(struct mic_device *mdev, u64 index)
+{
+	return mdev->smpt->info.base + (index * mdev->smpt->info.page_size);
+}
+
+static inline u64 mic_smpt_offset(struct mic_device *mdev, dma_addr_t pa)
+{
+	return pa & mic_system_page_mask(mdev);
+}
+
+static inline u64 mic_smpt_align_low(struct mic_device *mdev, dma_addr_t pa)
+{
+	return ALIGN(pa - mic_system_page_mask(mdev),
+		mdev->smpt->info.page_size);
+}
+
+static inline u64 mic_smpt_align_high(struct mic_device *mdev, dma_addr_t pa)
+{
+	return ALIGN(pa, mdev->smpt->info.page_size);
+}
+
+/* Total Cumulative system memory accessible by MIC across all SMPT entries */
+static inline u64 mic_max_system_memory(struct mic_device *mdev)
+{
+	return mdev->smpt->info.num_reg * mdev->smpt->info.page_size;
+}
+
+/* Maximum system memory address accessible by MIC */
+static inline u64 mic_max_system_addr(struct mic_device *mdev)
+{
+	return mdev->smpt->info.base + mic_max_system_memory(mdev) - 1ULL;
+}
+
+/* Check if the DMA address is a MIC system memory address */
+static inline bool
+mic_is_system_addr(struct mic_device *mdev, dma_addr_t pa)
+{
+	return pa >= mdev->smpt->info.base && pa <= mic_max_system_addr(mdev);
+}
+
+/* Populate an SMPT entry and update the reference counts. */
+static void mic_add_smpt_entry(int spt, s64 *ref, u64 addr,
+		int entries, struct mic_device *mdev)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int i;
+
+	for (i = spt; i < spt + entries; i++,
+		addr += smpt_info->info.page_size) {
+		if (!smpt_info->entry[i].ref_count &&
+			(smpt_info->entry[i].dma_addr != addr)) {
+			mdev->smpt_ops->set(mdev, addr, i);
+			smpt_info->entry[i].dma_addr = addr;
+		}
+		smpt_info->entry[i].ref_count += ref[i - spt];
+	}
+}
+
+/*
+ * Find an available MIC address in MIC SMPT address space
+ * for a given DMA address and size.
+ */
+static dma_addr_t mic_smpt_op(struct mic_device *mdev, u64 dma_addr,
+				int entries, s64 *ref, size_t size)
+{
+	int spt = -1;   /* smpt index */
+	int ee = 0;	/* existing entries */
+	int fe = 0;	/* free entries */
+	int i;
+	unsigned long flags;
+	dma_addr_t mic_addr = 0;
+	dma_addr_t addr = dma_addr;
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+
+	spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+
+	/* find existing entries */
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		if (smpt_info->entry[i].dma_addr == addr) {
+			ee++;
+			addr += smpt_info->info.page_size;
+		} else if (ee) /* cannot find contiguous entries */
+			goto not_found;
+
+		if (ee == entries)
+			goto found;
+	}
+
+	/* find free entry */
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		fe = (smpt_info->entry[i].ref_count == 0) ? fe + 1 : 0;
+		if (fe == entries)
+			goto found;
+	}
+
+not_found:
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	return mic_addr;
+
+found:
+	spt = i - entries + 1;
+	mic_addr = mic_smpt_to_pa(mdev, spt);
+	mic_add_smpt_entry(spt, ref, dma_addr, entries, mdev);
+	smpt_info->map_count++;
+	smpt_info->ref_count += (s64)size;
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	return mic_addr;
+}
+
+/*
+ * Returns number of smpt entries needed for dma_addr to dma_addr + size
+ * also returns the reference count array for each of those entries
+ * and the starting smpt address
+ */
+static int mic_get_smpt_ref_count(s64 *ref, dma_addr_t dma_addr, size_t size,
+				u64 *smpt_start, struct mic_device *mdev)
+{
+	u64 start =  dma_addr;
+	u64 end = dma_addr + size;
+	int i = 0;
+
+	while (start < end) {
+		ref[i++] = min(mic_smpt_align_high(mdev, start + 1),
+			end) - start;
+		start = mic_smpt_align_high(mdev, start + 1);
+	}
+
+	if (smpt_start)
+		*smpt_start = mic_smpt_align_low(mdev, dma_addr);
+
+	return i;
+}
+
+/*
+ * mic_to_dma_addr - Converts a MIC address to a DMA address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_address: MIC address.
+ *
+ * returns a DMA address.
+ */
+static dma_addr_t
+mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int spt;
+	dma_addr_t dma_addr;
+
+	if (!mic_is_system_addr(mdev, mic_addr)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
+	dma_addr = smpt_info->entry[spt].dma_addr +
+		mic_smpt_offset(mdev, mic_addr);
+	return dma_addr;
+}
+
+/**
+ * mic_map - Maps a DMA address to a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @dma_address: DMA address.
+ * @size: Size of the region to be mapped.
+ *
+ * This API converts the DMA address provided to a DMA address understood
+ * by MIC. Callee should check for errors by called mic_map_error(..).
+ *
+ * returns DMA address as required by MIC.
+ */
+dma_addr_t mic_map(struct mic_device *mdev, dma_addr_t dma_addr, size_t size)
+{
+	dma_addr_t mic_addr = 0;
+	int entries;
+	s64 *ref;
+	u64 smpt_start;
+
+	if (!size || size > mic_max_system_memory(mdev))
+		return mic_addr;
+
+	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	if (!ref)
+		return mic_addr;
+
+	/*
+	 * Get number of smpt entries to be mapped, ref count array
+	 * and the starting smpt address to start the search for
+	 * free or existing smpt entries.
+	 */
+	entries = mic_get_smpt_ref_count(ref,
+		dma_addr, size, &smpt_start, mdev);
+
+	/* Set the smpt table appropriately and get 16G aligned mic address */
+	mic_addr = mic_smpt_op(mdev, smpt_start, entries, ref, size);
+
+	kfree(ref);
+
+	/*
+	 * If mic_addr is zero then its an error case
+	 * since mic_addr can never be zero.
+	 * else generate mic_addr by adding the 16G offset in dma_addr
+	 */
+	if (!mic_addr && MIC_FAMILY_X100 == mdev->family) {
+		WARN_ON(1);
+		return mic_addr;
+	} else {
+		return mic_addr + (dma_addr & mic_system_page_mask(mdev));
+	}
+}
+
+/**
+ * mic_unmap - Unmaps a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_addr: MIC physical address.
+ * @size: Size of the region to be unmapped.
+ *
+ * This API unmaps the mappings created by mic_map(..).
+ *
+ * returns None.
+ */
+void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	s64 *ref;
+	int num_smpt;
+	int spt;
+	int i;
+	unsigned long flags;
+
+	if (!size)
+		return;
+
+	if (!mic_is_system_addr(mdev, mic_addr)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
+	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	if (!ref)
+		return;
+
+	/* Get number of smpt entries to be mapped, ref count array */
+	num_smpt = mic_get_smpt_ref_count(ref, mic_addr, size, NULL, mdev);
+
+	spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+	smpt_info->unmap_count++;
+	smpt_info->ref_count -= (s64)size;
+
+	for (i = spt; i < spt + num_smpt; i++) {
+		smpt_info->entry[i].ref_count -= ref[i - spt];
+		WARN_ON(smpt_info->entry[i].ref_count < 0);
+	}
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	kfree(ref);
+}
+
+/**
+ * mic_map_single - Maps a virtual address to a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @va: Kernel direct mapped virtual address.
+ * @size: Size of the region to be mapped.
+ *
+ * This API calls pci_map_single(..) for the direct mapped virtual address
+ * and then converts the DMA address provided to a DMA address understood
+ * by MIC. Callee should check for errors by called mic_map_error(..).
+ *
+ * returns DMA address as required by MIC.
+ */
+dma_addr_t mic_map_single(struct mic_device *mdev, void *va, size_t size)
+{
+	dma_addr_t mic_addr = 0;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+	dma_addr_t dma_addr =
+		pci_map_single(pdev, va, size, PCI_DMA_BIDIRECTIONAL);
+
+	if (!pci_dma_mapping_error(pdev, dma_addr)) {
+		mic_addr = mic_map(mdev, dma_addr, size);
+		if (!mic_addr) {
+			dev_err(mdev->sdev->parent,
+				"mic_map failed dma_addr 0x%llx size 0x%lx\n",
+				dma_addr, size);
+			pci_unmap_single(pdev, dma_addr,
+				size, PCI_DMA_BIDIRECTIONAL);
+		}
+	}
+	return mic_addr;
+}
+
+/**
+ * mic_unmap_single - Unmaps a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_addr: MIC physical address.
+ * @size: Size of the region to be unmapped.
+ *
+ * This API unmaps the mappings created by mic_map_single(..).
+ *
+ * returns None.
+ */
+void
+mic_unmap_single(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
+{
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+		struct pci_dev, dev);
+	dma_addr_t dma_addr = mic_to_dma_addr(mdev, mic_addr);
+	mic_unmap(mdev, mic_addr, size);
+	pci_unmap_single(pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
+}
+
+/**
+ * mic_smpt_init - Initialize MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns 0 for success and -errno for error.
+ */
+int mic_smpt_init(struct mic_device *mdev)
+{
+	int i, err = 0;
+	dma_addr_t dma_addr;
+	struct mic_smpt_info *smpt_info;
+
+	mdev->smpt = kmalloc(sizeof(*mdev->smpt), GFP_KERNEL);
+	if (!mdev->smpt)
+		return -ENOMEM;
+
+	smpt_info = mdev->smpt;
+	mdev->smpt_ops->init(mdev);
+	smpt_info->entry = kmalloc(sizeof(struct mic_smpt)
+			* smpt_info->info.num_reg, GFP_KERNEL);
+	if (!smpt_info->entry) {
+		err = -ENOMEM;
+		goto free_smpt;
+	}
+	spin_lock_init(&smpt_info->smpt_lock);
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		dma_addr = i * smpt_info->info.page_size;
+		smpt_info->entry[i].dma_addr = dma_addr;
+		smpt_info->entry[i].ref_count = 0;
+		mdev->smpt_ops->set(mdev, dma_addr, i);
+	}
+	smpt_info->ref_count = 0;
+	smpt_info->map_count = 0;
+	smpt_info->unmap_count = 0;
+	return 0;
+free_smpt:
+	kfree(smpt_info);
+	return err;
+}
+
+/**
+ * mic_smpt_uninit - UnInitialize MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns None.
+ */
+void mic_smpt_uninit(struct mic_device *mdev)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int i;
+
+	dev_dbg(mdev->sdev->parent,
+		"nodeid %d SMPT ref count %lld map %lld unmap %lld\n",
+		mdev->id, smpt_info->ref_count,
+		smpt_info->map_count, smpt_info->unmap_count);
+
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		dev_dbg(mdev->sdev->parent,
+			"SMPT entry[%d] dma_addr = 0x%llx ref_count = %lld\n",
+			i, smpt_info->entry[i].dma_addr,
+			smpt_info->entry[i].ref_count);
+		WARN_ON(smpt_info->entry[i].ref_count);
+	}
+	kfree(smpt_info->entry);
+	kfree(smpt_info);
+}
+
+/**
+ * mic_smpt_restore - Restore MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * Restore the SMPT registers to values previously stored in the
+ * SW data structures. Some MIC steppings lose register state
+ * across resets and this API should be called for performing
+ * a restore operation if required.
+ *
+ * returns None.
+ */
+void mic_smpt_restore(struct mic_device *mdev)
+{
+	int i;
+	dma_addr_t dma_addr;
+
+	for (i = 0; i < mdev->smpt->info.num_reg; i++) {
+		dma_addr = mdev->smpt->entry[i].dma_addr;
+		mdev->smpt_ops->set(mdev, dma_addr, i);
+	}
+}
diff --git a/drivers/misc/mic/host/mic_smpt.h b/drivers/misc/mic/host/mic_smpt.h
new file mode 100644
index 0000000..51970ab
--- /dev/null
+++ b/drivers/misc/mic/host/mic_smpt.h
@@ -0,0 +1,98 @@
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
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef MIC_SMPT_H
+#define MIC_SMPT_H
+/**
+ * struct mic_smpt_ops - MIC HW specific SMPT operations.
+ * @init: Initialize hardware specific SMPT information in mic_smpt_hw_info.
+ * @set: Set the value for a particular SMPT entry.
+ */
+struct mic_smpt_ops {
+	void (*init)(struct mic_device *mdev);
+	void (*set)(struct mic_device *mdev, dma_addr_t dma_addr, u8 index);
+};
+
+/**
+ * struct mic_smpt - MIC SMPT entry information.
+ * @dma_addr: Base DMA address for this SMPT entry.
+ * @ref_count: Number of active mappings for this SMPT entry in bytes.
+ */
+struct mic_smpt {
+	dma_addr_t dma_addr;
+	s64 ref_count;
+};
+
+/**
+ * struct mic_smpt_hw_info - MIC SMPT hardware specific information.
+ * @num_reg: Number of SMPT registers.
+ * @page_shift: System memory page shift.
+ * @page_size: System memory page size.
+ * @base: System address base.
+ */
+struct mic_smpt_hw_info {
+	u8 num_reg;
+	u8 page_shift;
+	u64 page_size;
+	u64 base;
+};
+
+/**
+ * struct mic_smpt_info - MIC SMPT information.
+ * @entry: Array of SMPT entries.
+ * @smpt_lock: Spin lock protecting access to SMPT data structures.
+ * @info: Hardware specific SMPT information.
+ * @ref_count: Number of active SMPT mappings (for debug).
+ * @map_count: Number of SMPT mappings created (for debug).
+ * @unmap_count: Number of SMPT mappings destroyed (for debug).
+ */
+struct mic_smpt_info {
+	struct mic_smpt *entry;
+	spinlock_t smpt_lock;
+	struct mic_smpt_hw_info info;
+	s64 ref_count;
+	s64 map_count;
+	s64 unmap_count;
+};
+
+dma_addr_t mic_map_single(struct mic_device *mdev, void *va, size_t size);
+void mic_unmap_single(struct mic_device *mdev,
+	dma_addr_t mic_addr, size_t size);
+dma_addr_t mic_map(struct mic_device *mdev,
+	dma_addr_t dma_addr, size_t size);
+void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size);
+
+/**
+ * mic_map_error - Check a MIC address for errors.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns Whether there was an error during mic_map..(..) APIs.
+ */
+static inline bool mic_map_error(dma_addr_t mic_addr)
+{
+	return !mic_addr;
+}
+
+int mic_smpt_init(struct mic_device *mdev);
+void mic_smpt_uninit(struct mic_device *mdev);
+void mic_smpt_restore(struct mic_device *mdev);
+
+#endif
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index da481b1..a7d41fd 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -24,6 +24,7 @@
 #include "../common/mic_device.h"
 #include "mic_device.h"
 #include "mic_x100.h"
+#include "mic_smpt.h"
 
 /**
  * mic_x100_write_spad - write to the scratchpad register
@@ -67,9 +68,255 @@ mic_x100_read_spad(struct mic_device *mdev, unsigned int idx)
 	return val;
 }
 
+/**
+ * mic_x100_enable_interrupts - Enable interrupts.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_enable_interrupts(struct mic_device *mdev)
+{
+	u32 reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sice0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICE0;
+	u32 siac0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SIAC0;
+
+	reg = mic_mmio_read(mw, sice0);
+	reg |= MIC_X100_SBOX_DBR_BITS(0xf) | MIC_X100_SBOX_DMA_BITS(0xff);
+	mic_mmio_write(mw, reg, sice0);
+
+	/*
+	 * Enable auto-clear when enabling interrupts. Applicable only for
+	 * MSI-x. Legacy and MSI mode cannot have auto-clear enabled.
+	 */
+	if (mdev->irq_info.num_vectors > 1) {
+		reg = mic_mmio_read(mw, siac0);
+		reg |= MIC_X100_SBOX_DBR_BITS(0xf) |
+			MIC_X100_SBOX_DMA_BITS(0xff);
+		mic_mmio_write(mw, reg, siac0);
+	}
+}
+
+/**
+ * mic_x100_disable_interrupts - Disable interrupts.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_disable_interrupts(struct mic_device *mdev)
+{
+	u32 reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sice0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICE0;
+	u32 siac0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SIAC0;
+	u32 sicc0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICC0;
+
+	reg = mic_mmio_read(mw, sice0);
+	mic_mmio_write(mw, reg, sicc0);
+
+	if (mdev->irq_info.num_vectors > 1) {
+		reg = mic_mmio_read(mw, siac0);
+		reg &= ~(MIC_X100_SBOX_DBR_BITS(0xf) |
+			MIC_X100_SBOX_DMA_BITS(0xff));
+		mic_mmio_write(mw, reg, siac0);
+	}
+}
+
+/**
+ * mic_x100_send_sbox_intr - Send an MIC_X100_SBOX interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_sbox_intr(struct mic_device *mdev,
+			int doorbell)
+{
+	struct mic_mw *mw = &mdev->mmio;
+	u64 apic_icr_offset = MIC_X100_SBOX_APICICR0 + doorbell * 8;
+	u32 apicicr_low = mic_mmio_read(mw,
+			MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+
+	/* for MIC we need to make sure we "hit" the send_icr bit (13) */
+	apicicr_low = (apicicr_low | (1 << 13));
+
+	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
+	wmb();
+	mic_mmio_write(mw, apicicr_low,
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+}
+
+/**
+ * mic_x100_send_rdmasr_intr - Send an RDMASR interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_rdmasr_intr(struct mic_device *mdev,
+			int doorbell)
+{
+	int rdmasr_offset = MIC_X100_SBOX_RDMASR0 + (doorbell << 2);
+	/* Ensure that the interrupt is ordered w.r.t. previous stores. */
+	wmb();
+	mic_mmio_write(&mdev->mmio, 0,
+		MIC_X100_SBOX_BASE_ADDRESS + rdmasr_offset);
+}
+
+/**
+ * __mic_x100_send_intr - Send interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ * @doorbell: doorbell number.
+ */
+static void mic_x100_send_intr(struct mic_device *mdev, int doorbell)
+{
+	int rdmasr_db;
+	if (doorbell < MIC_X100_NUM_SBOX_IRQ) {
+		mic_x100_send_sbox_intr(mdev, doorbell);
+	} else {
+		rdmasr_db = doorbell - MIC_X100_NUM_SBOX_IRQ +
+			MIC_X100_RDMASR_IRQ_BASE;
+		mic_x100_send_rdmasr_intr(mdev, rdmasr_db);
+	}
+}
+
+/**
+ * mic_ack_interrupt - Device specific interrupt handling.
+ * @mdev: pointer to mic_device instance
+ *
+ * Returns: bitmask of doorbell events triggered.
+ */
+static u32 mic_x100_ack_interrupt(struct mic_device *mdev)
+{
+	u32 reg = 0;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sicr0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICR0;
+
+	/* Clear pending bit array. */
+	if (MIC_A0_STEP == mdev->stepping)
+		mic_mmio_write(mw, 1, MIC_X100_SBOX_BASE_ADDRESS +
+			MIC_X100_SBOX_MSIXPBACR);
+
+	if (mdev->irq_info.num_vectors <= 1) {
+		reg = mic_mmio_read(mw, sicr0);
+
+		if (unlikely(!reg))
+			goto done;
+
+		mic_mmio_write(mw, reg, sicr0);
+	}
+
+	if (mdev->stepping >= MIC_B0_STEP)
+		mdev->intr_ops->enable_interrupts(mdev);
+done:
+	return reg;
+}
+
+/**
+ * mic_x100_hw_intr_init - Initialize h/w specific interrupt
+ * information.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_hw_intr_init(struct mic_device *mdev)
+{
+	mdev->intr_info = (struct mic_intr_info *) mic_x100_intr_init;
+}
+
+/**
+ * mic_x100_read_msi_to_src_map - read from the MSI mapping registers
+ * @mdev: pointer to mic_device instance
+ * @idx: index to the mapping register, 0 based
+ *
+ * This function allows reading of the 32bit MSI mapping register.
+ *
+ * RETURNS: The value in the register.
+ */
+static u32
+mic_x100_read_msi_to_src_map(struct mic_device *mdev, int idx)
+{
+	return mic_mmio_read(&mdev->mmio,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_MXAR0 + idx * 4);
+}
+
+/**
+ * mic_x100_program_msi_to_src_map - program the MSI mapping registers
+ * @mdev: pointer to mic_device instance
+ * @idx: index to the mapping register, 0 based
+ * @offset: The bit offset in the register that needs to be updated.
+ * @set: boolean specifying if the bit in the specified offset needs
+ * to be set or cleared.
+ *
+ * RETURNS: None.
+ */
+static void
+mic_x100_program_msi_to_src_map(struct mic_device *mdev,
+			int idx, int offset, bool set)
+{
+	unsigned long reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 mxar = MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_MXAR0 + idx * 4;
+
+	reg = mic_mmio_read(mw, mxar);
+	if (set)
+		__set_bit(offset, &reg);
+	else
+		__clear_bit(offset, &reg);
+	mic_mmio_write(mw, reg, mxar);
+}
+
+/**
+ * mic_x100_smpt_set - Update an SMPT entry with a DMA address.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: none.
+ */
+static void
+mic_x100_smpt_set(struct mic_device *mdev, dma_addr_t dma_addr, u8 index)
+{
+#define SNOOP_ON	(0 << 0)
+#define SNOOP_OFF	(1 << 0)
+/*
+ * Sbox Smpt Reg Bits:
+ * Bits	31:2	Host address
+ * Bits	1	RSVD
+ * Bits	0	No snoop
+ */
+#define BUILD_SMPT(NO_SNOOP, HOST_ADDR)  \
+	(u32)(((((HOST_ADDR) << 2) & (~0x03)) | ((NO_SNOOP) & (0x01))))
+
+	uint32_t smpt_reg_val = BUILD_SMPT(SNOOP_ON,
+			dma_addr >> mdev->smpt->info.page_shift);
+	mic_mmio_write(&mdev->mmio, smpt_reg_val,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SMPT00 + (4 * index));
+}
+
+/**
+ * mic_x100_smpt_hw_init - Initialize SMPT X100 specific fields.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: none.
+ */
+static void mic_x100_smpt_hw_init(struct mic_device *mdev)
+{
+	struct mic_smpt_hw_info *info = &mdev->smpt->info;
+
+	info->num_reg = 32;
+	info->page_shift = 34;
+	info->page_size = (1ULL << info->page_shift);
+	info->base = 0x8000000000ULL;
+}
+
+struct mic_smpt_ops mic_x100_smpt_ops = {
+	.init = mic_x100_smpt_hw_init,
+	.set = mic_x100_smpt_set,
+};
+
 struct mic_hw_ops mic_x100_ops = {
 	.aper_bar = MIC_X100_APER_BAR,
 	.mmio_bar = MIC_X100_MMIO_BAR,
 	.read_spad = mic_x100_read_spad,
 	.write_spad = mic_x100_write_spad,
+	.send_intr = mic_x100_send_intr,
+	.ack_interrupt = mic_x100_ack_interrupt,
+};
+
+struct mic_hw_intr_ops mic_x100_intr_ops = {
+	.intr_init = mic_x100_hw_intr_init,
+	.enable_interrupts = mic_x100_enable_interrupts,
+	.disable_interrupts = mic_x100_disable_interrupts,
+	.program_msi_to_src_map = mic_x100_program_msi_to_src_map,
+	.read_msi_to_src_map = mic_x100_read_msi_to_src_map,
 };
diff --git a/drivers/misc/mic/host/mic_x100.h b/drivers/misc/mic/host/mic_x100.h
index 1f4e630..fd98b2b 100644
--- a/drivers/misc/mic/host/mic_x100.h
+++ b/drivers/misc/mic/host/mic_x100.h
@@ -42,6 +42,46 @@
 
 #define MIC_X100_SBOX_BASE_ADDRESS 0x00010000
 #define MIC_X100_SBOX_SPAD0 0x0000AB20
+#define MIC_X100_SBOX_SICR0_DBR(x) ((x) & 0xf)
+#define MIC_X100_SBOX_SICR0_DMA(x) (((x) >> 8) & 0xff)
+#define MIC_X100_SBOX_SICE0_DBR(x) ((x) & 0xf)
+#define MIC_X100_SBOX_DBR_BITS(x) ((x) & 0xf)
+#define MIC_X100_SBOX_SICE0_DMA(x) (((x) >> 8) & 0xff)
+#define MIC_X100_SBOX_DMA_BITS(x) (((x) & 0xff) << 8)
+
+#define MIC_X100_SBOX_APICICR0 0x0000A9D0
+#define MIC_X100_SBOX_SICR0 0x00009004
+#define MIC_X100_SBOX_SICE0 0x0000900C
+#define MIC_X100_SBOX_SICC0 0x00009010
+#define MIC_X100_SBOX_SIAC0 0x00009014
+#define MIC_X100_SBOX_MSIXPBACR 0x00009084
+#define MIC_X100_SBOX_MXAR0 0x00009044
+#define MIC_X100_SBOX_SMPT00 0x00003100
+#define MIC_X100_SBOX_RDMASR0 0x0000B180
+
+#define MIC_X100_DOORBELL_IDX_START 0
+#define MIC_X100_NUM_DOORBELL 4
+#define MIC_X100_DMA_IDX_START 8
+#define MIC_X100_NUM_DMA 8
+#define MIC_X100_ERR_IDX_START 30
+#define MIC_X100_NUM_ERR 1
+
+#define MIC_X100_NUM_SBOX_IRQ 8
+#define MIC_X100_NUM_RDMASR_IRQ 8
+#define MIC_X100_RDMASR_IRQ_BASE 17
+#define MIC_NUM_OFFSETS 32
+
+static const u16 mic_x100_intr_init[] = {
+		MIC_X100_DOORBELL_IDX_START,
+		MIC_X100_DMA_IDX_START,
+		MIC_X100_ERR_IDX_START,
+		MIC_X100_NUM_DOORBELL,
+		MIC_X100_NUM_DMA,
+		MIC_X100_NUM_ERR,
+};
+
 extern struct mic_hw_ops mic_x100_ops;
+extern struct mic_smpt_ops mic_x100_smpt_ops;
+extern struct mic_hw_intr_ops mic_x100_intr_ops;
 
 #endif
-- 
1.8.2.1

