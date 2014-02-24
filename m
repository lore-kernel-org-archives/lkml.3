Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaBXRSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:18:42 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:19257 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbaBXRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:18:40 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-7.tower-179.messagelabs.com!1393262317!28266564!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 24 Feb 2014 18:18:38 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v2 1/3] drivers: Introduce MEN Chameleon Bus
Date: Mon, 24 Feb 2014 18:18:32 +0100
Message-ID: <1393262312-19956-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
References: <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
FPGA based devices. It is used to identify MCB based IP-Cores within
an FPGA and provide the necessary framework for instantiating drivers
for these devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 MAINTAINERS                     |   6 +
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/mcb/Kconfig             |  15 ++
 drivers/mcb/Makefile            |   5 +
 drivers/mcb/mcb-core.c          | 414 ++++++++++++++++++++++++++++++++++++++++
 drivers/mcb/mcb-internal.h      | 116 +++++++++++
 drivers/mcb/mcb-parse.c         | 159 +++++++++++++++
 include/linux/mcb.h             | 119 ++++++++++++
 include/linux/mod_devicetable.h |   5 +
 10 files changed, 842 insertions(+)
 create mode 100644 drivers/mcb/Kconfig
 create mode 100644 drivers/mcb/Makefile
 create mode 100644 drivers/mcb/mcb-core.c
 create mode 100644 drivers/mcb/mcb-internal.h
 create mode 100644 drivers/mcb/mcb-parse.c
 create mode 100644 include/linux/mcb.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5aa1c50..68a3cad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5666,6 +5666,12 @@ L:	linux-watchdog@vger.kernel.org
 S:	Supported
 F:	drivers/watchdog/mena21_wdt.c

+MEN CHAMELEON BUS (mcb)
+M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+S:	Supported
+F:	drivers/mcb/
+F:	include/linux/mcb.h
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 L:	linux-metag@vger.kernel.org
diff --git a/drivers/Kconfig b/drivers/Kconfig
index b3138fb..df2ac52 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -170,4 +170,6 @@ source "drivers/phy/Kconfig"

 source "drivers/powercap/Kconfig"

+source "drivers/mcb/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 8e3b8b0..c5bf50c 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -155,3 +155,4 @@ obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
+obj-$(CONFIG_MCB)		+= mcb/
diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
new file mode 100644
index 0000000..44c82d6
--- /dev/null
+++ b/drivers/mcb/Kconfig
@@ -0,0 +1,15 @@
+#
+# MEN Chameleon Bus (MCB) support
+#
+
+menuconfig MCB
+	   tristate "MCB support"
+	   default m
+	   help
+
+	   The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
+	   FPGA based devices. It is used to identify MCB based IP-Cores within
+	   an FPGA and provide the necessary framework for instantiating drivers
+	   for these devices.
+
+	   If build as a module, the module is called mcb.ko
diff --git a/drivers/mcb/Makefile b/drivers/mcb/Makefile
new file mode 100644
index 0000000..2d9a751
--- /dev/null
+++ b/drivers/mcb/Makefile
@@ -0,0 +1,5 @@
+
+obj-$(CONFIG_MCB) += mcb.o
+
+mcb-y += mcb-core.o
+mcb-y += mcb-parse.o
diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
new file mode 100644
index 0000000..bbe1293
--- /dev/null
+++ b/drivers/mcb/mcb-core.c
@@ -0,0 +1,414 @@
+/*
+ * MEN Chameleon Bus.
+ *
+ * Copyright (C) 2013 MEN Mikroelektronik GmbH (www.men.de)
+ * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/idr.h>
+#include <linux/mcb.h>
+
+static DEFINE_IDA(mcb_ida);
+
+static const struct mcb_device_id *mcb_match_id(const struct mcb_device_id *ids,
+						struct mcb_device *dev)
+{
+	if (ids) {
+		while (ids->device) {
+			if (ids->device == dev->id)
+				return ids;
+			ids++;
+		}
+	}
+
+	return NULL;
+}
+
+static int mcb_match(struct device *dev, struct device_driver *drv)
+{
+	struct mcb_driver *mdrv = to_mcb_driver(drv);
+	struct mcb_device *mdev = to_mcb_device(dev);
+	const struct mcb_device_id *found_id;
+
+	found_id = mcb_match_id(mdrv->id_table, mdev);
+	if (found_id)
+		return 1;
+
+	return 0;
+}
+
+static int mcb_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct mcb_device *mdev = to_mcb_device(dev);
+	int ret;
+
+	ret = add_uevent_var(env, "MODALIAS=mcb:16z%03d", mdev->id);
+	if (ret)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int mcb_probe(struct device *dev)
+{
+	struct mcb_driver *mdrv = to_mcb_driver(dev->driver);
+	struct mcb_device *mdev = to_mcb_device(dev);
+	const struct mcb_device_id *found_id;
+
+	found_id = mcb_match_id(mdrv->id_table, mdev);
+	if (!found_id)
+		return -ENODEV;
+
+	return mdrv->probe(mdev, found_id);
+}
+
+static int mcb_remove(struct device *dev)
+{
+	struct mcb_driver *mdrv = to_mcb_driver(dev->driver);
+	struct mcb_device *mdev = to_mcb_device(dev);
+
+	mdrv->remove(mdev);
+
+	put_device(&mdev->dev);
+
+	return 0;
+}
+
+static void mcb_shutdown(struct device *dev)
+{
+	struct mcb_device *mdev = to_mcb_device(dev);
+	struct mcb_driver *mdrv = mdev->driver;
+
+	if (mdrv && mdrv->shutdown)
+		mdrv->shutdown(mdev);
+}
+
+static struct bus_type mcb_bus_type = {
+	.name = "mcb",
+	.match = mcb_match,
+	.uevent = mcb_uevent,
+	.probe = mcb_probe,
+	.remove = mcb_remove,
+	.shutdown = mcb_shutdown,
+};
+
+/**
+ * __mcb_register_driver() - Register a @mcb_driver at the system
+ * @drv: The @mcb_driver
+ * @owner: The @mcb_driver's module
+ * @mod_name: The name of the @mcb_driver's module
+ *
+ * Register a @mcb_driver at the system. Perform some sanity checks, if
+ * the .probe and .remove methods are provided by the driver.
+ */
+int __mcb_register_driver(struct mcb_driver *drv, struct module *owner,
+			const char *mod_name)
+{
+	if (!drv->probe || !drv->remove)
+		return -EINVAL;
+
+	drv->driver.owner = owner;
+	drv->driver.bus = &mcb_bus_type;
+	drv->driver.mod_name = mod_name;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(__mcb_register_driver);
+
+/**
+ * mcb_unregister_driver() - Unregister a @mcb_driver from the system
+ * @drv: The @mcb_driver
+ *
+ * Unregister a @mcb_driver from the system.
+ */
+void mcb_unregister_driver(struct mcb_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(mcb_unregister_driver);
+
+static void mcb_release_dev(struct device *dev)
+{
+	struct mcb_device *mdev = to_mcb_device(dev);
+
+	mcb_bus_put(mdev->bus);
+	kfree(mdev);
+}
+
+/**
+ * mcb_device_register() - Register a mcb_device
+ * @bus: The @mcb_bus of the device
+ * @dev: The @mcb_device
+ *
+ * Register a specific @mcb_device at a @mcb_bus and the system itself.
+ */
+int mcb_device_register(struct mcb_bus *bus, struct mcb_device *dev)
+{
+	int ret;
+	int device_id;
+
+	device_initialize(&dev->dev);
+	dev->dev.bus = &mcb_bus_type;
+	dev->dev.parent = bus->dev.parent;
+	dev->dev.release = mcb_release_dev;
+
+	device_id = dev->id;
+	dev_set_name(&dev->dev, "mcb%d-16z%03d-%d:%d:%d",
+		bus->bus_nr, device_id, dev->inst, dev->group, dev->var);
+
+	ret = device_add(&dev->dev);
+	if (ret < 0) {
+		pr_err("Failed registering device 16z%03d on bus mcb%d (%d)\n",
+			device_id, bus->bus_nr, ret);
+		goto out;
+	}
+
+	return 0;
+
+out:
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mcb_device_register);
+
+/**
+ * mcb_alloc_bus() - Allocate a new @mcb_bus
+ *
+ * Allocate a new @mcb_bus.
+ */
+struct mcb_bus *mcb_alloc_bus(void)
+{
+	struct mcb_bus *bus;
+	int bus_nr;
+
+	bus = kzalloc(sizeof(struct mcb_bus), GFP_KERNEL);
+	if (!bus)
+		return NULL;
+
+	bus_nr = ida_simple_get(&mcb_ida, 0, 0, GFP_KERNEL);
+	if (bus_nr < 0) {
+		kfree(bus);
+		return ERR_PTR(bus_nr);
+	}
+
+	INIT_LIST_HEAD(&bus->children);
+	bus->bus_nr = bus_nr;
+
+	return bus;
+}
+EXPORT_SYMBOL_GPL(mcb_alloc_bus);
+
+static int __mcb_devices_unregister(struct device *dev, void *data)
+{
+	device_unregister(dev);
+	return 0;
+}
+
+static void mcb_devices_unregister(struct mcb_bus *bus)
+{
+	bus_for_each_dev(&mcb_bus_type, NULL, NULL, __mcb_devices_unregister);
+}
+/**
+ * mcb_release_bus() - Free a @mcb_bus
+ * @bus: The @mcb_bus to release
+ *
+ * Release an allocated @mcb_bus from the system.
+ */
+void mcb_release_bus(struct mcb_bus *bus)
+{
+	mcb_devices_unregister(bus);
+
+	ida_simple_remove(&mcb_ida, bus->bus_nr);
+
+	kfree(bus);
+}
+EXPORT_SYMBOL_GPL(mcb_release_bus);
+
+/**
+ * mcb_bus_put() - Increment refcnt
+ * @bus: The @mcb_bus
+ *
+ * Get a @mcb_bus' ref
+ */
+struct mcb_bus *mcb_bus_get(struct mcb_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+
+	return bus;
+}
+EXPORT_SYMBOL_GPL(mcb_bus_get);
+
+/**
+ * mcb_bus_put() - Decrement refcnt
+ * @bus: The @mcb_bus
+ *
+ * Release a @mcb_bus' ref
+ */
+void mcb_bus_put(struct mcb_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL_GPL(mcb_bus_put);
+
+/**
+ * mcb_alloc_dev() - Allocate a device
+ * @bus: The @mcb_bus the device is part of
+ *
+ * Allocate a @mcb_device and add bus.
+ */
+struct mcb_device *mcb_alloc_dev(struct mcb_bus *bus)
+{
+	struct mcb_device *dev;
+
+	dev = kzalloc(sizeof(struct mcb_device), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	INIT_LIST_HEAD(&dev->bus_list);
+	dev->bus = bus;
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(mcb_alloc_dev);
+
+/**
+ * mcb_free_dev() - Free @mcb_device
+ * @dev: The device to free
+ *
+ * Free a @mcb_device
+ */
+void mcb_free_dev(struct mcb_device *dev)
+{
+	kfree(dev);
+}
+EXPORT_SYMBOL_GPL(mcb_free_dev);
+
+static int __mcb_bus_add_devices(struct device *dev, void *data)
+{
+	struct mcb_device *mdev = to_mcb_device(dev);
+	int retval;
+
+	if (mdev->is_added)
+		return 0;
+
+	retval = device_attach(dev);
+	if (retval < 0)
+		dev_err(dev, "Error adding device (%d)\n", retval);
+
+	mdev->is_added = true;
+
+	return 0;
+}
+
+static int __mcb_bus_add_child(struct device *dev, void *data)
+{
+	struct mcb_device *mdev = to_mcb_device(dev);
+	struct mcb_bus *child;
+
+	BUG_ON(!mdev->is_added);
+	child = mdev->subordinate;
+
+	if (child)
+		mcb_bus_add_devices(child);
+
+	return 0;
+}
+
+/**
+ * mcb_bus_add_devices() - Add devices in the bus' internal device list
+ * @bus: The @mcb_bus we add the devices
+ *
+ * Add devices in the bus' internal device list to the system.
+ */
+void mcb_bus_add_devices(const struct mcb_bus *bus)
+{
+	bus_for_each_dev(&mcb_bus_type, NULL, NULL, __mcb_bus_add_devices);
+	bus_for_each_dev(&mcb_bus_type, NULL, NULL, __mcb_bus_add_child);
+
+}
+EXPORT_SYMBOL_GPL(mcb_bus_add_devices);
+
+/**
+ * mcb_request_mem() - Request memory
+ * @dev: The @mcb_device the memory is for
+ * @name: The name for the memory reference.
+ *
+ * Request memory for a @mcb_device. If @name is NULL the driver name will
+ * be used.
+ */
+struct resource *mcb_request_mem(struct mcb_device *dev, const char *name)
+{
+	struct resource *mem;
+	u32 size;
+
+	if (!name)
+		name = dev->dev.driver->name;
+
+	size = resource_size(&dev->mem);
+
+	mem = request_mem_region(dev->mem.start, size, name);
+	if (!mem)
+		return ERR_PTR(-EBUSY);
+
+	return mem;
+}
+EXPORT_SYMBOL_GPL(mcb_request_mem);
+
+/**
+ * mcb_release_mem() - Release memory requested by device
+ * @dev: The @mcb_device that requested the memory
+ *
+ * Release memory that was prior requested via @mcb_request_mem().
+ */
+void mcb_release_mem(struct resource *mem)
+{
+	u32 size;
+
+	size = resource_size(mem);
+	release_mem_region(mem->start, size);
+}
+EXPORT_SYMBOL_GPL(mcb_release_mem);
+
+/**
+ * mcb_get_irq() - Get device's IRQ number
+ * @dev: The @mcb_device the IRQ is for
+ *
+ * Get the IRQ number of a given @mcb_device.
+ */
+int mcb_get_irq(struct mcb_device *dev)
+{
+	struct resource *irq = &dev->irq;
+
+	return irq->start;
+}
+EXPORT_SYMBOL_GPL(mcb_get_irq);
+
+static int mcb_init(void)
+{
+	return bus_register(&mcb_bus_type);
+}
+
+static void mcb_exit(void)
+{
+	bus_unregister(&mcb_bus_type);
+}
+
+/* mcb must be initialized after PCI but before the chameleon drivers.
+ * That means we must use some initcall between subsys_initcall and
+ * device_initcall.
+ */
+fs_initcall(mcb_init);
+module_exit(mcb_exit);
+
+MODULE_DESCRIPTION("MEN Chameleon Bus Driver");
+MODULE_AUTHOR("Johannes Thumshirn <johannes.thumshirn@men.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mcb/mcb-internal.h b/drivers/mcb/mcb-internal.h
new file mode 100644
index 0000000..db22777
--- /dev/null
+++ b/drivers/mcb/mcb-internal.h
@@ -0,0 +1,116 @@
+#ifndef __MCB_INTERNAL
+#define __MCB_INTERNAL
+
+#include <linux/types.h>
+
+#define CHAMELEON_FILENAME_LEN		12
+#define CHAMELEONV2_MAGIC		0xabce
+
+enum chameleon_descriptor_type {
+	CHAMELEON_DTYPE_GENERAL = 0x0,
+	CHAMELEON_DTYPE_BRIDGE = 0x1,
+	CHAMELEON_DTYPE_CPU = 0x2,
+	CHAMELEON_DTYPE_BAR = 0x3,
+	CHAMELEON_DTYPE_END = 0xf,
+};
+
+enum chameleon_bus_type {
+	CHAMELEON_BUS_WISHBONE,
+	CHAMELEON_BUS_AVALON,
+	CHAMELEON_BUS_LPC,
+	CHAMELEON_BUS_ISA,
+};
+
+/**
+ * struct chameleon_fpga_header
+ *
+ * @revision:	Revison of Chameleon table in FPGA
+ * @model:	Chameleon table model ASCII char
+ * @minor:	Revision minor
+ * @bus_type:	Bus type (usually %CHAMELEON_BUS_WISHBONE)
+ * @magic:	Chameleon header magic number (0xabce for version 2)
+ * @reserved:	Reserved
+ * @filename:	Filename of FPGA bitstream
+ */
+struct chameleon_fpga_header {
+	u8 revision;
+	char model;
+	u8 minor;
+	u8 bus_type;
+	u16 magic;
+	u16 reserved;
+	/* This one has no '\0' at the end!!! */
+	char filename[CHAMELEON_FILENAME_LEN];
+} __packed;
+#define HEADER_MAGIC_OFFSET 0x4
+
+/**
+ * struct chameleon_gdd - Chameleon General Device Descriptor
+ *
+ * @irq:	the position in the FPGA's IRQ controller vector
+ * @rev:	the revision of the variant's implementation
+ * @var:	the variant of the IP core
+ * @dev:	the device  the IP core is
+ * @dtype:	device descriptor type
+ * @bar:	BAR offset that must be added to module offset
+ * @inst:	the instance number of the device, 0 is first instance
+ * @group:	the group the device belongs to (0 = no group)
+ * @reserved:	reserved
+ * @offset:	beginning of the address window of desired module
+ * @size:	size of the module's address window
+ */
+struct chameleon_gdd {
+	__le32 reg1;
+	__le32 reg2;
+	__le32 offset;
+	__le32 size;
+
+} __packed;
+
+/* GDD Register 1 fields */
+#define GDD_IRQ(x) ((x) & 0x1f)
+#define GDD_REV(x) (((x) >> 5) & 0x3f)
+#define GDD_VAR(x) (((x) >> 11) & 0x3f)
+#define GDD_DEV(x) (((x) >> 18) & 0x3ff)
+#define GDD_DTY(x) (((x) >> 28) & 0xf)
+
+/* GDD Register 2 fields */
+#define GDD_BAR(x) ((x) & 0x7)
+#define GDD_INS(x) (((x) >> 3) & 0x3f)
+#define GDD_GRP(x) (((x) >> 9) & 0x3f)
+
+/**
+ * struct chameleon_bdd - Chameleon Bridge Device Descriptor
+ *
+ * @irq:	the position in the FPGA's IRQ controller vector
+ * @rev:	the revision of the variant's implementation
+ * @var:	the variant of the IP core
+ * @dev:	the device  the IP core is
+ * @dtype:	device descriptor type
+ * @bar:	BAR offset that must be added to module offset
+ * @inst:	the instance number of the device, 0 is first instance
+ * @dbar:	destination bar from the bus _behind_ the bridge
+ * @chamoff:	offset within the BAR of the source bus
+ * @offset:
+ * @size:
+ */
+struct chameleon_bdd {
+	unsigned int irq:6;
+	unsigned int rev:6;
+	unsigned int var:6;
+	unsigned int dev:10;
+	unsigned int dtype:4;
+	unsigned int bar:3;
+	unsigned int inst:6;
+	unsigned int dbar:3;
+	unsigned int group:6;
+	unsigned int reserved:14;
+	u32 chamoff;
+	u32 offset;
+	u32 size;
+} __packed;
+
+int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
+			  void __iomem *base);
+
+#endif
diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
new file mode 100644
index 0000000..d1278b5
--- /dev/null
+++ b/drivers/mcb/mcb-parse.c
@@ -0,0 +1,159 @@
+#include <linux/types.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/mcb.h>
+
+#include "mcb-internal.h"
+
+struct mcb_parse_priv {
+	phys_addr_t mapbase;
+	void __iomem *base;
+};
+
+#define for_each_chameleon_cell(dtype, p)	\
+	for ((dtype) = get_next_dtype((p));	\
+	     (dtype) != CHAMELEON_DTYPE_END;	\
+	     (dtype) = get_next_dtype((p)))
+
+static inline uint32_t get_next_dtype(void __iomem *p)
+{
+	uint32_t dtype;
+
+	dtype = readl(p);
+	return dtype >> 28;
+}
+
+static int chameleon_parse_bdd(struct mcb_bus *bus,
+			phys_addr_t mapbase,
+			void __iomem *base)
+{
+	return 0;
+}
+
+static int chameleon_parse_gdd(struct mcb_bus *bus,
+			phys_addr_t mapbase,
+			void __iomem *base)
+{
+	struct chameleon_gdd __iomem *gdd =
+		(struct chameleon_gdd __iomem *) base;
+	struct mcb_device *mdev;
+	u32 offset;
+	u32 size;
+	int ret;
+	__le32 reg1;
+	__le32 reg2;
+
+	mdev = mcb_alloc_dev(bus);
+	if (!mdev)
+		return -ENOMEM;
+
+	reg1 = readl(&gdd->reg1);
+	reg2 = readl(&gdd->reg2);
+	offset = readl(&gdd->offset);
+	size = readl(&gdd->size);
+
+	mdev->id = GDD_DEV(reg1);
+	mdev->rev = GDD_REV(reg1);
+	mdev->var = GDD_VAR(reg1);
+	mdev->bar = GDD_BAR(reg1);
+	mdev->group = GDD_GRP(reg2);
+	mdev->inst = GDD_INS(reg2);
+
+	pr_debug("Found a 16z%03d\n", mdev->id);
+
+	mdev->irq.start = GDD_IRQ(reg1);
+	mdev->irq.end = GDD_IRQ(reg1);
+	mdev->irq.flags = IORESOURCE_IRQ;
+
+	mdev->mem.start = mapbase + offset;
+	mdev->mem.end = mdev->mem.start + size - 1;
+	mdev->mem.flags = IORESOURCE_MEM;
+
+	mdev->is_added = false;
+
+	ret = mcb_device_register(bus, mdev);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	mcb_free_dev(mdev);
+
+	return ret;
+}
+
+int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
+			void __iomem *base)
+{
+	char __iomem *p = base;
+	struct chameleon_fpga_header *header;
+	uint32_t dtype;
+	int num_cells = 0;
+	int ret = 0;
+	u32 hsize;
+
+	hsize = sizeof(struct chameleon_fpga_header);
+
+	header = kzalloc(hsize, GFP_KERNEL);
+	if (!header)
+		return -ENOMEM;
+
+	/* Extract header information */
+	memcpy_fromio(header, p, hsize);
+	/* We only support chameleon v2 at the moment */
+	header->magic = le16_to_cpu(header->magic);
+	if (header->magic != CHAMELEONV2_MAGIC) {
+		pr_err("Unsupported chameleon version 0x%x\n",
+				header->magic);
+		kfree(header);
+		return -ENODEV;
+	}
+	p += hsize;
+
+	pr_debug("header->revision = %d\n", header->revision);
+	pr_debug("header->model = 0x%x ('%c')\n", header->model,
+		header->model);
+	pr_debug("header->minor = %d\n", header->minor);
+	pr_debug("header->bus_type = 0x%x\n", header->bus_type);
+
+
+	pr_debug("header->magic = 0x%x\n", header->magic);
+	pr_debug("header->filename = \"%.*s\"\n", CHAMELEON_FILENAME_LEN,
+		header->filename);
+
+	for_each_chameleon_cell(dtype, p) {
+		switch (dtype) {
+		case CHAMELEON_DTYPE_GENERAL:
+			ret = chameleon_parse_gdd(bus, mapbase, p);
+			if (ret < 0)
+				goto out;
+			p += sizeof(struct chameleon_gdd);
+			break;
+		case CHAMELEON_DTYPE_BRIDGE:
+			chameleon_parse_bdd(bus, mapbase, p);
+			p += sizeof(struct chameleon_bdd);
+			break;
+		case CHAMELEON_DTYPE_END:
+			break;
+		default:
+			pr_err("Invalid chameleon descriptor type 0x%x\n",
+				dtype);
+			return -EINVAL;
+		}
+		num_cells++;
+	}
+
+	if (num_cells == 0)
+		num_cells = -EINVAL;
+
+	kfree(header);
+	return num_cells;
+
+out:
+	kfree(header);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(chameleon_parse_cells);
diff --git a/include/linux/mcb.h b/include/linux/mcb.h
new file mode 100644
index 0000000..2db284d
--- /dev/null
+++ b/include/linux/mcb.h
@@ -0,0 +1,119 @@
+/*
+ * MEN Chameleon Bus.
+ *
+ * Copyright (C) 2014 MEN Mikroelektronik GmbH (www.men.de)
+ * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+#ifndef _LINUX_MCB_H
+#define _LINUX_MCB_H
+
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/irqreturn.h>
+
+struct mcb_driver;
+
+/**
+ * struct mcb_bus - MEN Chameleon Bus
+ *
+ * @dev: pointer to carrier device
+ * @children: the child busses
+ * @bus_nr: mcb bus number
+ */
+struct mcb_bus {
+	struct list_head children;
+	struct device dev;
+	int bus_nr;
+};
+#define to_mcb_bus(b) container_of((b), struct mcb_bus, dev)
+
+/**
+ * struct mcb_device - MEN Chameleon Bus device
+ *
+ * @bus_list: internal list handling for bus code
+ * @dev: device in kernel representation
+ * @bus: mcb bus the device is plugged to
+ * @subordinate: subordinate MCBus in case of bridge
+ * @is_added: flag to check if device is added to bus
+ * @driver: associated mcb_driver
+ * @id: mcb device id
+ * @inst: instance in Chameleon table
+ * @group: group in Chameleon table
+ * @var: variant in Chameleon table
+ * @bar: BAR in Chameleon table
+ * @rev: revision in Chameleon table
+ * @irq: IRQ resource
+ * @memory: memory resource
+ */
+struct mcb_device {
+	struct list_head bus_list;
+	struct device dev;
+	struct mcb_bus *bus;
+	struct mcb_bus *subordinate;
+	bool is_added;
+	struct mcb_driver *driver;
+	u16 id;
+	int inst;
+	int group;
+	int var;
+	int bar;
+	int rev;
+	struct resource irq;
+	struct resource mem;
+};
+#define to_mcb_device(x) container_of((x), struct mcb_device, dev)
+
+/**
+ * struct mcb_driver - MEN Chameleon Bus device driver
+ *
+ * @driver: device_driver
+ * @id_table: mcb id table
+ * @probe: probe callback
+ * @remove: remove callback
+ * @shutdown: shutdown callback
+ */
+struct mcb_driver {
+	struct device_driver driver;
+	const struct mcb_device_id *id_table;
+	int (*probe)(struct mcb_device *mdev, const struct mcb_device_id *id);
+	void (*remove)(struct mcb_device *mdev);
+	void (*shutdown)(struct mcb_device *mdev);
+};
+#define to_mcb_driver(x) container_of((x), struct mcb_driver, driver)
+
+static inline void *mcb_get_drvdata(struct mcb_device *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+static inline void mcb_set_drvdata(struct mcb_device *dev, void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+
+extern int __must_check __mcb_register_driver(struct mcb_driver *drv,
+					struct module *owner,
+					const char *mod_name);
+#define mcb_register_driver(driver)		\
+	__mcb_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
+extern void mcb_unregister_driver(struct mcb_driver *driver);
+#define module_mcb_driver(__mcb_driver)		\
+	module_driver(__mcb_driver, mcb_register_driver, mcb_unregister_driver);
+extern void mcb_bus_add_devices(const struct mcb_bus *bus);
+extern int mcb_device_register(struct mcb_bus *bus, struct mcb_device *dev);
+extern struct mcb_bus *mcb_alloc_bus(void);
+extern struct mcb_bus *mcb_bus_get(struct mcb_bus *bus);
+extern void mcb_bus_put(struct mcb_bus *bus);
+extern struct mcb_device *mcb_alloc_dev(struct mcb_bus *bus);
+extern void mcb_free_dev(struct mcb_device *dev);
+extern void mcb_release_bus(struct mcb_bus *bus);
+extern struct resource *mcb_request_mem(struct mcb_device *dev,
+					const char *name);
+extern void mcb_release_mem(struct resource *mem);
+extern int mcb_get_irq(struct mcb_device *dev);
+
+#endif /* _LINUX_MCB_H */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..262cb85 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -599,4 +599,9 @@ struct rio_device_id {
 	__u16 asm_did, asm_vid;
 };

+struct mcb_device_id {
+	__u16 device;
+	kernel_ulong_t driver_data;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
--
1.8.5.3

