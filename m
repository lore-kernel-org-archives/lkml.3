Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbaLJTwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:52:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:61026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbaLJTtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770537"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 03/13] misc: mic: SCIF Hardware Bus
Date: Wed, 10 Dec 2014 11:47:43 -0800
Message-Id: <1eb4600e570f65ac8247b2d7283f7e8ef4a1f8ca.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCIF hardware bus abstracts the low level hardware driver details
like interrupts and mapping remote memory so that the same SCIF driver
can work without any changes with the MIC host or card driver as long
as the hardware bus operations are implemented. The SCIF hardware
device is registered by the host and card drivers on the SCIF hardware
bus resulting in probing the SCIF driver.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/Kconfig        |  17 ++++
 drivers/misc/mic/Makefile       |   2 +-
 drivers/misc/mic/bus/Makefile   |   1 +
 drivers/misc/mic/bus/scif_bus.h | 129 ++++++++++++++++++++++++
 drivers/misc/mic/bus/scif_bus.c | 210 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/mic/bus/scif_bus.h
 create mode 100644 drivers/misc/mic/bus/scif_bus.c

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index cc4eef0..afc9f53 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -15,6 +15,23 @@ config INTEL_MIC_BUS
 	  OS and tools for MIC to use with this driver are available from
 	  <http://software.intel.com/en-us/mic-developer>.
 
+comment "SCIF Bus Driver"
+
+config SCIF_BUS
+	tristate "SCIF Bus Driver"
+	depends on 64BIT && PCI && X86 && X86_DEV_DMA_OPS
+	help
+	  This option is selected by any driver which registers a
+	  device or driver on the SCIF Bus, such as CONFIG_INTEL_MIC_HOST
+	  and CONFIG_INTEL_MIC_CARD.
+
+	  If you are building a host/card kernel with an Intel MIC device
+	  then say M (recommended) or Y, else say N. If unsure say N.
+
+	  More information about the Intel MIC family as well as the Linux
+	  OS and tools for MIC to use with this driver are available from
+	  <http://software.intel.com/en-us/mic-developer>.
+
 comment "Intel MIC Host Driver"
 
 config INTEL_MIC_HOST
diff --git a/drivers/misc/mic/Makefile b/drivers/misc/mic/Makefile
index e9bf148..6bc6083 100644
--- a/drivers/misc/mic/Makefile
+++ b/drivers/misc/mic/Makefile
@@ -4,4 +4,4 @@
 #
 obj-$(CONFIG_INTEL_MIC_HOST) += host/
 obj-$(CONFIG_INTEL_MIC_CARD) += card/
-obj-$(CONFIG_INTEL_MIC_BUS) += bus/
+obj-y += bus/
diff --git a/drivers/misc/mic/bus/Makefile b/drivers/misc/mic/bus/Makefile
index d85c7f2..1ed37e2 100644
--- a/drivers/misc/mic/bus/Makefile
+++ b/drivers/misc/mic/bus/Makefile
@@ -3,3 +3,4 @@
 # Copyright(c) 2014, Intel Corporation.
 #
 obj-$(CONFIG_INTEL_MIC_BUS) += mic_bus.o
+obj-$(CONFIG_SCIF_BUS) += scif_bus.o
diff --git a/drivers/misc/mic/bus/scif_bus.h b/drivers/misc/mic/bus/scif_bus.h
new file mode 100644
index 0000000..335a228
--- /dev/null
+++ b/drivers/misc/mic/bus/scif_bus.h
@@ -0,0 +1,129 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
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
+ * Intel Symmetric Communications Interface Bus driver.
+ */
+#ifndef _SCIF_BUS_H_
+#define _SCIF_BUS_H_
+/*
+ * Everything a scif driver needs to work with any particular scif
+ * hardware abstraction layer.
+ */
+#include <linux/dma-mapping.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_dev.h"
+
+struct scif_hw_dev_id {
+	u32 device;
+	u32 vendor;
+};
+
+#define MIC_SCIF_DEV 1
+#define SCIF_DEV_ANY_ID 0xffffffff
+
+/**
+ * scif_hw_dev - representation of a hardware device abstracted for scif
+ * @hw_ops: the hardware ops supported by this device
+ * @id: the device type identification (used to match it with a driver)
+ * @mmio: MMIO memory window
+ * @aper: Aperture memory window
+ * @dev: underlying device
+ * @dnode - The destination node which this device will communicate with.
+ * @snode - The source node for this device.
+ * @dp - Self device page
+ * @rdp - Remote device page
+ * @dma_ch - Array of DMA channels
+ * @num_dma_ch - Number of DMA channels available
+ */
+struct scif_hw_dev {
+	struct scif_hw_ops *hw_ops;
+	struct scif_hw_dev_id id;
+	struct mic_mw *mmio;
+	struct mic_mw *aper;
+	struct device dev;
+	u8 dnode;
+	u8 snode;
+	void *dp;
+	void __iomem *rdp;
+	struct dma_chan **dma_ch;
+	int num_dma_ch;
+};
+
+/**
+ * scif_driver - operations for a scif I/O driver
+ * @driver: underlying device driver (populate name and owner).
+ * @id_table: the ids serviced by this driver.
+ * @probe: the function to call when a device is found.  Returns 0 or -errno.
+ * @remove: the function to call when a device is removed.
+ */
+struct scif_driver {
+	struct device_driver driver;
+	const struct scif_hw_dev_id *id_table;
+	int (*probe)(struct scif_hw_dev *dev);
+	void (*remove)(struct scif_hw_dev *dev);
+};
+
+/**
+ * scif_hw_ops - Hardware operations for accessing a SCIF device on the SCIF bus.
+ *
+ * @next_db: Obtain the next available doorbell.
+ * @request_irq: Request an interrupt on a particular doorbell.
+ * @free_irq: Free an interrupt requested previously.
+ * @ack_interrupt: acknowledge an interrupt in the ISR.
+ * @send_intr: Send an interrupt to the remote node on a specified doorbell.
+ * @send_p2p_intr: Send an interrupt to the peer node on a specified doorbell
+ * which is specifically targeted for a peer to peer node.
+ * @ioremap: Map a buffer with the specified physical address and length.
+ * @iounmap: Unmap a buffer previously mapped.
+ */
+struct scif_hw_ops {
+	int (*next_db)(struct scif_hw_dev *sdev);
+	struct mic_irq * (*request_irq)(struct scif_hw_dev *sdev,
+					irqreturn_t (*func)(int irq,
+							    void *data),
+					const char *name, void *data,
+					int db);
+	void (*free_irq)(struct scif_hw_dev *sdev,
+			 struct mic_irq *cookie, void *data);
+	void (*ack_interrupt)(struct scif_hw_dev *sdev, int num);
+	void (*send_intr)(struct scif_hw_dev *sdev, int db);
+	void (*send_p2p_intr)(struct scif_hw_dev *sdev, int db,
+			      struct mic_mw *mw);
+	void __iomem * (*ioremap)(struct scif_hw_dev *sdev,
+				  phys_addr_t pa, size_t len);
+	void (*iounmap)(struct scif_hw_dev *sdev, void __iomem *va);
+};
+
+int scif_register_driver(struct scif_driver *driver);
+void scif_unregister_driver(struct scif_driver *driver);
+struct scif_hw_dev *
+scif_register_device(struct device *pdev, int id,
+		     struct dma_map_ops *dma_ops,
+		     struct scif_hw_ops *hw_ops, u8 dnode, u8 snode,
+		     struct mic_mw *mmio, struct mic_mw *aper,
+		     void *dp, void __iomem *rdp,
+		     struct dma_chan **chan, int num_chan);
+void scif_unregister_device(struct scif_hw_dev *sdev);
+
+static inline struct scif_hw_dev *dev_to_scif(struct device *dev)
+{
+	return container_of(dev, struct scif_hw_dev, dev);
+}
+
+static inline struct scif_driver *drv_to_scif(struct device_driver *drv)
+{
+	return container_of(drv, struct scif_driver, driver);
+}
+#endif /* _SCIF_BUS_H */
diff --git a/drivers/misc/mic/bus/scif_bus.c b/drivers/misc/mic/bus/scif_bus.c
new file mode 100644
index 0000000..2da7cee
--- /dev/null
+++ b/drivers/misc/mic/bus/scif_bus.c
@@ -0,0 +1,210 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
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
+ * Intel Symmetric Communications Interface Bus driver.
+ */
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/dma-mapping.h>
+
+#include "scif_bus.h"
+
+static ssize_t device_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct scif_hw_dev *dev = dev_to_scif(d);
+
+	return sprintf(buf, "0x%04x\n", dev->id.device);
+}
+
+static DEVICE_ATTR_RO(device);
+
+static ssize_t vendor_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct scif_hw_dev *dev = dev_to_scif(d);
+
+	return sprintf(buf, "0x%04x\n", dev->id.vendor);
+}
+
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t modalias_show(struct device *d,
+			     struct device_attribute *attr, char *buf)
+{
+	struct scif_hw_dev *dev = dev_to_scif(d);
+
+	return sprintf(buf, "scif:d%08Xv%08X\n",
+		       dev->id.device, dev->id.vendor);
+}
+
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *scif_dev_attrs[] = {
+	&dev_attr_device.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_modalias.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(scif_dev);
+
+static inline int scif_id_match(const struct scif_hw_dev *dev,
+				const struct scif_hw_dev_id *id)
+{
+	if (id->device != dev->id.device && id->device != SCIF_DEV_ANY_ID)
+		return 0;
+
+	return id->vendor == SCIF_DEV_ANY_ID || id->vendor == dev->id.vendor;
+}
+
+/*
+ * This looks through all the IDs a driver claims to support.  If any of them
+ * match, we return 1 and the kernel will call scif_dev_probe().
+ */
+static int scif_dev_match(struct device *dv, struct device_driver *dr)
+{
+	unsigned int i;
+	struct scif_hw_dev *dev = dev_to_scif(dv);
+	const struct scif_hw_dev_id *ids;
+
+	ids = drv_to_scif(dr)->id_table;
+	for (i = 0; ids[i].device; i++)
+		if (scif_id_match(dev, &ids[i]))
+			return 1;
+	return 0;
+}
+
+static int scif_uevent(struct device *dv, struct kobj_uevent_env *env)
+{
+	struct scif_hw_dev *dev = dev_to_scif(dv);
+
+	return add_uevent_var(env, "MODALIAS=scif:d%08Xv%08X",
+			      dev->id.device, dev->id.vendor);
+}
+
+static int scif_dev_probe(struct device *d)
+{
+	struct scif_hw_dev *dev = dev_to_scif(d);
+	struct scif_driver *drv = drv_to_scif(dev->dev.driver);
+
+	return drv->probe(dev);
+}
+
+static int scif_dev_remove(struct device *d)
+{
+	struct scif_hw_dev *dev = dev_to_scif(d);
+	struct scif_driver *drv = drv_to_scif(dev->dev.driver);
+
+	drv->remove(dev);
+	return 0;
+}
+
+static struct bus_type scif_bus = {
+	.name  = "scif_bus",
+	.match = scif_dev_match,
+	.dev_groups = scif_dev_groups,
+	.uevent = scif_uevent,
+	.probe = scif_dev_probe,
+	.remove = scif_dev_remove,
+};
+
+int scif_register_driver(struct scif_driver *driver)
+{
+	driver->driver.bus = &scif_bus;
+	return driver_register(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(scif_register_driver);
+
+void scif_unregister_driver(struct scif_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(scif_unregister_driver);
+
+static void scif_release_dev(struct device *d)
+{
+	struct scif_hw_dev *sdev = dev_to_scif(d);
+
+	kfree(sdev);
+}
+
+struct scif_hw_dev *
+scif_register_device(struct device *pdev, int id, struct dma_map_ops *dma_ops,
+		     struct scif_hw_ops *hw_ops, u8 dnode, u8 snode,
+		     struct mic_mw *mmio, struct mic_mw *aper, void *dp,
+		     void __iomem *rdp, struct dma_chan **chan, int num_chan)
+{
+	int ret;
+	struct scif_hw_dev *sdev;
+
+	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return ERR_PTR(-ENOMEM);
+
+	sdev->dev.parent = pdev;
+	sdev->id.device = id;
+	sdev->id.vendor = SCIF_DEV_ANY_ID;
+	sdev->dev.archdata.dma_ops = dma_ops;
+	sdev->dev.release = scif_release_dev;
+	sdev->hw_ops = hw_ops;
+	sdev->dnode = dnode;
+	sdev->snode = snode;
+	dev_set_drvdata(&sdev->dev, sdev);
+	sdev->dev.bus = &scif_bus;
+	sdev->mmio = mmio;
+	sdev->aper = aper;
+	sdev->dp = dp;
+	sdev->rdp = rdp;
+	sdev->dev.dma_mask = &sdev->dev.coherent_dma_mask;
+	dma_set_mask(&sdev->dev, DMA_BIT_MASK(64));
+	sdev->dma_ch = chan;
+	sdev->num_dma_ch = num_chan;
+	dev_set_name(&sdev->dev, "scif-dev%u", sdev->dnode);
+	/*
+	 * device_register() causes the bus infrastructure to look for a
+	 * matching driver.
+	 */
+	ret = device_register(&sdev->dev);
+	if (ret)
+		goto free_sdev;
+	return sdev;
+free_sdev:
+	kfree(sdev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(scif_register_device);
+
+void scif_unregister_device(struct scif_hw_dev *sdev)
+{
+	device_unregister(&sdev->dev);
+}
+EXPORT_SYMBOL_GPL(scif_unregister_device);
+
+static int __init scif_init(void)
+{
+	return bus_register(&scif_bus);
+}
+
+static void __exit scif_exit(void)
+{
+	bus_unregister(&scif_bus);
+}
+
+core_initcall(scif_init);
+module_exit(scif_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) SCIF Bus driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1

