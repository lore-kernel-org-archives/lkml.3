Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaDNUSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:18:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:38444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbaDNUPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520341970"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 2/8] misc: mic: add a bus driver for virtual MIC devices
Date: Mon, 14 Apr 2014 13:14:59 -0700
Message-Id: <3709ad31630160d33d7c3691922fd7e0ee271941.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This MIC virtual bus driver takes the responsibility of creating all
the virtual devices connected to the PCIe device on the host and the
platform device on the card. The MIC bus hardware operations provide
a way to abstract certain hardware details from the base physical devices.
Examples of devices added on the MIC virtual bus include host DMA and card DMA.
This abstraction enables using a common DMA driver on host and card.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
---
 drivers/misc/mic/Kconfig       |  17 ++++
 drivers/misc/mic/Makefile      |   1 +
 drivers/misc/mic/bus/Makefile  |   5 ++
 drivers/misc/mic/bus/mic_bus.c | 188 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mic_bus.h        | 148 ++++++++++++++++++++++++++++++++
 5 files changed, 359 insertions(+)
 create mode 100644 drivers/misc/mic/bus/Makefile
 create mode 100644 drivers/misc/mic/bus/mic_bus.c
 create mode 100644 include/linux/mic_bus.h

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index e42b331..cfe185f 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -1,3 +1,20 @@
+comment "Intel MIC Bus Driver"
+
+config INTEL_MIC_BUS
+	tristate "Intel MIC Bus Driver"
+	depends on 64BIT && PCI && X86 && X86_DEV_DMA_OPS
+	help
+	  This option is selected by any driver which registers a
+	  device or driver on the MIC Bus, such as CONFIG_INTEL_MIC_HOST,
+	  CONFIG_INTEL_MIC_CARD, CONFIG_INTEL_MIC_X100_DMA etc.
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
index 05b34d6..e9bf148 100644
--- a/drivers/misc/mic/Makefile
+++ b/drivers/misc/mic/Makefile
@@ -4,3 +4,4 @@
 #
 obj-$(CONFIG_INTEL_MIC_HOST) += host/
 obj-$(CONFIG_INTEL_MIC_CARD) += card/
+obj-$(CONFIG_INTEL_MIC_BUS) += bus/
diff --git a/drivers/misc/mic/bus/Makefile b/drivers/misc/mic/bus/Makefile
new file mode 100644
index 0000000..d85c7f2
--- /dev/null
+++ b/drivers/misc/mic/bus/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile - Intel MIC Linux driver.
+# Copyright(c) 2014, Intel Corporation.
+#
+obj-$(CONFIG_INTEL_MIC_BUS) += mic_bus.o
diff --git a/drivers/misc/mic/bus/mic_bus.c b/drivers/misc/mic/bus/mic_bus.c
new file mode 100644
index 0000000..39253b5
--- /dev/null
+++ b/drivers/misc/mic/bus/mic_bus.c
@@ -0,0 +1,188 @@
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
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Bus driver.
+ *
+ * This implementation is very similar to the the virtio bus driver
+ * implementation @ drivers/virtio/virtio.c
+ */
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/mic_bus.h>
+
+/* Unique numbering for mbus devices. */
+static DEFINE_IDA(mbus_index_ida);
+
+static ssize_t device_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct mbus_device *dev = dev_to_mbus(d);
+	return sprintf(buf, "0x%04x\n", dev->id.device);
+}
+static DEVICE_ATTR_RO(device);
+
+static ssize_t vendor_show(struct device *d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct mbus_device *dev = dev_to_mbus(d);
+	return sprintf(buf, "0x%04x\n", dev->id.vendor);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t modalias_show(struct device *d,
+			     struct device_attribute *attr, char *buf)
+{
+	struct mbus_device *dev = dev_to_mbus(d);
+	return sprintf(buf, "mbus:d%08Xv%08X\n",
+		       dev->id.device, dev->id.vendor);
+}
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *mbus_dev_attrs[] = {
+	&dev_attr_device.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_modalias.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(mbus_dev);
+
+static inline int mbus_id_match(const struct mbus_device *dev,
+				  const struct mbus_device_id *id)
+{
+	if (id->device != dev->id.device && id->device != MBUS_DEV_ANY_ID)
+		return 0;
+
+	return id->vendor == MBUS_DEV_ANY_ID || id->vendor == dev->id.vendor;
+}
+
+/*
+ * This looks through all the IDs a driver claims to support.  If any of them
+ * match, we return 1 and the kernel will call mbus_dev_probe().
+ */
+static int mbus_dev_match(struct device *dv, struct device_driver *dr)
+{
+	unsigned int i;
+	struct mbus_device *dev = dev_to_mbus(dv);
+	const struct mbus_device_id *ids;
+
+	ids = drv_to_mbus(dr)->id_table;
+	for (i = 0; ids[i].device; i++)
+		if (mbus_id_match(dev, &ids[i]))
+			return 1;
+	return 0;
+}
+
+static int mbus_uevent(struct device *dv, struct kobj_uevent_env *env)
+{
+	struct mbus_device *dev = dev_to_mbus(dv);
+
+	return add_uevent_var(env, "MODALIAS=mbus:d%08Xv%08X",
+			      dev->id.device, dev->id.vendor);
+}
+
+static int mbus_dev_probe(struct device *d)
+{
+	int err;
+	struct mbus_device *dev = dev_to_mbus(d);
+	struct mbus_driver *drv = drv_to_mbus(dev->dev.driver);
+
+	err = drv->probe(dev);
+	if (!err)
+		if (drv->scan)
+			drv->scan(dev);
+	return err;
+}
+
+static int mbus_dev_remove(struct device *d)
+{
+	struct mbus_device *dev = dev_to_mbus(d);
+	struct mbus_driver *drv = drv_to_mbus(dev->dev.driver);
+
+	drv->remove(dev);
+	return 0;
+}
+
+static struct bus_type mic_bus = {
+	.name  = "mic_bus",
+	.match = mbus_dev_match,
+	.dev_groups = mbus_dev_groups,
+	.uevent = mbus_uevent,
+	.probe = mbus_dev_probe,
+	.remove = mbus_dev_remove,
+};
+
+int register_mbus_driver(struct mbus_driver *driver)
+{
+	driver->driver.bus = &mic_bus;
+	return driver_register(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(register_mbus_driver);
+
+void unregister_mbus_driver(struct mbus_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(unregister_mbus_driver);
+
+int register_mbus_device(struct mbus_device *dev)
+{
+	int err;
+
+	dev->dev.bus = &mic_bus;
+
+	/* Assign a unique device index and hence name. */
+	err = ida_simple_get(&mbus_index_ida, 0, 0, GFP_KERNEL);
+	if (err < 0)
+		return err;
+
+	dev->index = err;
+	dev_set_name(&dev->dev, "mbus-dev%u", dev->index);
+	/*
+	 * device_register() causes the bus infrastructure to look for a
+	 * matching driver.
+	 */
+	err = device_register(&dev->dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(register_mbus_device);
+
+void unregister_mbus_device(struct mbus_device *dev)
+{
+	int index = dev->index; /* save for after device release */
+
+	device_unregister(&dev->dev);
+	ida_simple_remove(&mbus_index_ida, index);
+}
+EXPORT_SYMBOL_GPL(unregister_mbus_device);
+
+static int __init mbus_init(void)
+{
+	return bus_register(&mic_bus);
+}
+
+static void __exit mbus_exit(void)
+{
+	bus_unregister(&mic_bus);
+}
+
+core_initcall(mbus_init);
+module_exit(mbus_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) MIC Bus driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mic_bus.h b/include/linux/mic_bus.h
new file mode 100644
index 0000000..8297573
--- /dev/null
+++ b/include/linux/mic_bus.h
@@ -0,0 +1,148 @@
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
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Bus driver.
+ *
+ * This implementation is very similar to the the virtio bus driver
+ * implementation @ include/linux/virtio.h.
+ */
+#ifndef _MIC_BUS_H_
+#define _MIC_BUS_H_
+/*
+ * Everything a mbus driver needs to work with any particular mbus
+ * implementation.
+ */
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+
+struct mbus_device_id {
+	__u32 device;
+	__u32 vendor;
+};
+
+#define MBUS_DEV_DMA_HOST 2
+#define MBUS_DEV_DMA_MIC 3
+#define MBUS_DEV_ANY_ID 0xffffffff
+
+/**
+ * mbus_device - representation of a device using mbus
+ * @priv: private pointer for the driver's use.
+ * @mmio_va: virtual address of mmio space
+ * @hw_ops: the hardware ops supported by this device.
+ * @id: the device type identification (used to match it with a driver).
+ * @dev: underlying device.
+ * be used to communicate with.
+ * @index: unique position on the mbus bus
+ */
+struct mbus_device {
+	void *priv;
+	void __iomem *mmio_va;
+	struct mbus_hw_ops *hw_ops;
+	struct mbus_device_id id;
+	struct device dev;
+	int index;
+};
+
+/**
+ * mbus_driver - operations for a mbus I/O driver
+ * @driver: underlying device driver (populate name and owner).
+ * @id_table: the ids serviced by this driver.
+ * @probe: the function to call when a device is found.  Returns 0 or -errno.
+ * @remove: the function to call when a device is removed.
+ */
+struct mbus_driver {
+	struct device_driver driver;
+	const struct mbus_device_id *id_table;
+	int (*probe)(struct mbus_device *dev);
+	void (*scan)(struct mbus_device *dev);
+	void (*remove)(struct mbus_device *dev);
+};
+
+/**
+ * struct mic_irq - opaque pointer used as cookie
+ */
+struct mic_irq;
+
+/**
+ * mbus_hw_ops - Hardware operations for accessing a MIC device on the MIC bus.
+ */
+struct mbus_hw_ops {
+	struct mic_irq* (*request_threaded_irq)(struct mbus_device *mbdev,
+			irq_handler_t handler, irq_handler_t thread_fn,
+			const char *name, void *data, int intr_src);
+	void (*free_irq)(struct mbus_device *mbdev,
+			struct mic_irq *cookie, void *data);
+	void (*ack_interrupt)(struct mbus_device *mbdev, int num);
+};
+
+int register_mbus_device(struct mbus_device *dev);
+void unregister_mbus_device(struct mbus_device *dev);
+
+int register_mbus_driver(struct mbus_driver *drv);
+void unregister_mbus_driver(struct mbus_driver *drv);
+
+static inline struct mbus_device *dev_to_mbus(struct device *_dev)
+{
+	return container_of(_dev, struct mbus_device, dev);
+}
+
+static inline struct mbus_driver *drv_to_mbus(struct device_driver *drv)
+{
+	return container_of(drv, struct mbus_driver, driver);
+}
+
+static inline void mbus_release_dev(struct device *d)
+{
+}
+
+static inline int
+mbus_add_device(struct mbus_device *mbdev, struct device *pdev, int id,
+		struct dma_map_ops *dma_ops, struct mbus_hw_ops *hw_ops,
+		void __iomem *mmio_va)
+{
+	int ret;
+
+	mbdev->mmio_va = mmio_va;
+	mbdev->dev.parent = pdev;
+	mbdev->id.device = id;
+	mbdev->id.vendor = MBUS_DEV_ANY_ID;
+	mbdev->dev.archdata.dma_ops = dma_ops;
+	mbdev->dev.dma_mask = &mbdev->dev.coherent_dma_mask;
+	dma_set_mask(&mbdev->dev, DMA_BIT_MASK(64));
+	mbdev->dev.release = mbus_release_dev;
+	mbdev->hw_ops = hw_ops;
+	dev_set_drvdata(&mbdev->dev, mbdev);
+
+	ret = register_mbus_device(mbdev);
+	if (ret) {
+		dev_err(mbdev->dev.parent,
+			"Failed to register mbus device type %u\n", id);
+		return ret;
+	}
+	return 0;
+}
+
+static inline void mbus_remove_device(struct mbus_device *mbdev)
+{
+	unregister_mbus_device(mbdev);
+	memset(mbdev, 0x0, sizeof(*mbdev));
+}
+
+#endif /* _MIC_BUS_H */
-- 
1.8.2.2

