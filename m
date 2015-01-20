Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbbATJVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:21:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:54671 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbbATJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:18:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442631486"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] phy: add bus for USB ULPI PHYs
Date: Tue, 20 Jan 2015 11:18:20 +0200
Message-Id: <1421745502-169447-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UTMI+ Low Pin Interface (ULPI) is a commonly used PHY
interface for USB 2.0. It describe a standard set of
registers which the vendors can extend for their specific
needs.

ULPI registers are accessed from the controller. The purpose
of the bus is to provide nice way for the controller drivers
to share that access with the actual PHY drivers.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 MAINTAINERS                        |   7 ++
 drivers/phy/Kconfig                |   2 +
 drivers/phy/Makefile               |   1 +
 drivers/phy/ulpi/Kconfig           |   9 ++
 drivers/phy/ulpi/Makefile          |   2 +
 drivers/phy/ulpi/ulpi.c            | 246 +++++++++++++++++++++++++++++++++++++
 drivers/phy/ulpi/ulpi_phy.h        |  31 +++++
 include/linux/phy/ulpi/driver.h    |  58 +++++++++
 include/linux/phy/ulpi/interface.h |  23 ++++
 include/linux/phy/ulpi/regs.h      | 130 ++++++++++++++++++++
 include/linux/usb/ulpi.h           | 135 +-------------------
 11 files changed, 512 insertions(+), 132 deletions(-)
 create mode 100644 drivers/phy/ulpi/Kconfig
 create mode 100644 drivers/phy/ulpi/Makefile
 create mode 100644 drivers/phy/ulpi/ulpi.c
 create mode 100644 drivers/phy/ulpi/ulpi_phy.h
 create mode 100644 include/linux/phy/ulpi/driver.h
 create mode 100644 include/linux/phy/ulpi/interface.h
 create mode 100644 include/linux/phy/ulpi/regs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ef032a..fce81a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4233,6 +4233,13 @@ S:	Supported
 F:	drivers/phy/
 F:	include/linux/phy/
 
+ULPI PHY BUS
+M:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
+L:	linux-usb@vger.kernel.org
+S:	Supported
+F:	drivers/phy/ulpi/
+F:	include/linux/phy/ulpi/
+
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index ccad880..9bfb556 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -277,4 +277,6 @@ config PHY_STIH41X_USB
 	  Enable this to support the USB transceiver that is part of
 	  STMicroelectronics STiH41x SoC series.
 
+source "drivers/phy/ulpi/Kconfig"
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index aa74f96..8914f3d 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
 obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
 obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
+obj-$(CONFIG_ULPI_PHY)			+= ulpi/
diff --git a/drivers/phy/ulpi/Kconfig b/drivers/phy/ulpi/Kconfig
new file mode 100644
index 0000000..8007df2
--- /dev/null
+++ b/drivers/phy/ulpi/Kconfig
@@ -0,0 +1,9 @@
+
+config ULPI_PHY
+	bool "USB ULPI PHY interface support"
+	depends on USB || USB_GADGET
+	select GENERIC_PHY
+	help
+	  Say yes if you have ULPI PHY attached to your USB controller.
+
+	  If unsure, say N.
diff --git a/drivers/phy/ulpi/Makefile b/drivers/phy/ulpi/Makefile
new file mode 100644
index 0000000..59e61cb
--- /dev/null
+++ b/drivers/phy/ulpi/Makefile
@@ -0,0 +1,2 @@
+ulpiphy-y			:= ulpi.o
+obj-$(CONFIG_ULPI_PHY)		+= ulpiphy.o
diff --git a/drivers/phy/ulpi/ulpi.c b/drivers/phy/ulpi/ulpi.c
new file mode 100644
index 0000000..4a05dd5
--- /dev/null
+++ b/drivers/phy/ulpi/ulpi.c
@@ -0,0 +1,246 @@
+/**
+ * ulpi.c - USB ULPI PHY bus
+ *
+ * Copyright (C) 2015 Intel Corporation
+ *
+ * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/phy/ulpi/interface.h>
+#include <linux/phy/ulpi/driver.h>
+#include <linux/phy/ulpi/regs.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+/* -------------------------------------------------------------------------- */
+
+int ulpi_read(struct ulpi *ulpi, u8 addr)
+{
+	return ulpi->ops->read(ulpi->ops, addr);
+}
+EXPORT_SYMBOL_GPL(ulpi_read);
+
+int ulpi_write(struct ulpi *ulpi, u8 addr, u8 val)
+{
+	return ulpi->ops->write(ulpi->ops, addr, val);
+}
+EXPORT_SYMBOL_GPL(ulpi_write);
+
+/* -------------------------------------------------------------------------- */
+
+static int ulpi_match(struct device *dev, struct device_driver *driver)
+{
+	struct ulpi_driver *drv = to_ulpi_driver(driver);
+	struct ulpi *ulpi = to_ulpi_dev(dev);
+	const struct ulpi_device_id *id;
+
+	for (id = drv->id_table; id->vendor; id++)
+		if (id->vendor == ulpi->id.vendor &&
+		    id->product == ulpi->id.product)
+			return 1;
+
+	return 0;
+}
+
+static int ulpi_probe(struct device *dev)
+{
+	struct ulpi_driver *drv = to_ulpi_driver(dev->driver);
+
+	return drv->probe(to_ulpi_dev(dev));
+}
+
+static int ulpi_remove(struct device *dev)
+{
+	struct ulpi_driver *drv = to_ulpi_driver(dev->driver);
+
+	if (drv->remove)
+		drv->remove(to_ulpi_dev(dev));
+
+	return 0;
+}
+
+struct bus_type ulpi_bus = {
+	.name = "ulpi",
+	.match = ulpi_match,
+	.probe = ulpi_probe,
+	.remove = ulpi_remove,
+};
+
+/**
+ * ulpi_register_driver - register a driver with the ULPI bus
+ * @drv: driver being registered
+ *
+ * Registers a driver with the ULPI bus.
+ */
+int ulpi_register_driver(struct ulpi_driver *drv)
+{
+	if (!drv->probe)
+		return -EINVAL;
+
+	drv->driver.bus = &ulpi_bus;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(ulpi_register_driver);
+
+/**
+ * ulpi_register_driver - unregister a driver with the ULPI bus
+ * @drv: driver to unregister
+ *
+ * Unregisters a driver with the ULPI bus.
+ */
+void ulpi_unregister_driver(struct ulpi_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(ulpi_unregister_driver);
+
+/* -------------------------------------------------------------------------- */
+
+static void ulpi_dev_release(struct device *dev)
+{
+	kfree(to_ulpi_dev(dev));
+}
+
+static ssize_t
+vendor_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ulpi *ulpi = to_ulpi_dev(dev);
+
+	return sprintf(buf, "%04x\n", ulpi->id.vendor);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t
+product_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ulpi *ulpi = to_ulpi_dev(dev);
+
+	return sprintf(buf, "%04x\n", ulpi->id.product);
+}
+static DEVICE_ATTR_RO(product);
+
+static struct attribute *ulpi_dev_attrs[] = {
+	&dev_attr_vendor.attr,
+	&dev_attr_product.attr,
+	NULL
+};
+
+static struct attribute_group ulpi_dev_attr_group = {
+	.attrs = ulpi_dev_attrs,
+};
+
+static const struct attribute_group *ulpi_dev_attr_groups[] = {
+	&ulpi_dev_attr_group,
+	NULL
+};
+
+struct device_type ulpi_device_type = {
+	.name = "ulpi_device",
+	.groups = ulpi_dev_attr_groups,
+	.release = ulpi_dev_release,
+};
+
+/* -------------------------------------------------------------------------- */
+
+static int ulpi_register(struct device *dev, struct ulpi *ulpi)
+{
+	int ret;
+
+	/* Test the interface */
+	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
+	if (ret < 0)
+		return ret;
+
+	ret = ulpi_read(ulpi, ULPI_SCRATCH);
+	if (ret < 0)
+		return ret;
+
+	if (ret != 0xaa)
+		return -ENODEV;
+
+	ulpi->id.vendor = ulpi_read(ulpi, ULPI_VENDOR_ID_LOW);
+	ulpi->id.vendor |= ulpi_read(ulpi, ULPI_VENDOR_ID_HIGH) << 8;
+
+	ulpi->id.product = ulpi_read(ulpi, ULPI_PRODUCT_ID_LOW);
+	ulpi->id.product |= ulpi_read(ulpi, ULPI_PRODUCT_ID_HIGH) << 8;
+
+	ulpi->dev.parent = dev;
+	ulpi->dev.bus = &ulpi_bus;
+	ulpi->dev.type = &ulpi_device_type;
+	dev_set_name(&ulpi->dev, "%s.ulpi", dev_name(dev));
+
+	ret = device_register(&ulpi->dev);
+	if (ret)
+		return ret;
+
+	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
+		ulpi->id.vendor, ulpi->id.product);
+
+	return 0;
+}
+
+/**
+ * ulpi_register_interface - instantiate new ULPI device
+ * @dev: USB controller's device interface
+ * @ops: ULPI register access
+ *
+ * Allocates and registers a ULPI device and an interface for it. Called from
+ * the USB controller that provides the ULPI interface.
+ */
+struct ulpi *ulpi_register_interface(struct device *dev, struct ulpi_ops *ops)
+{
+	struct ulpi *ulpi;
+	int ret;
+
+	ulpi = kzalloc(sizeof(*ulpi), GFP_KERNEL);
+	if (!ulpi)
+		return ERR_PTR(-ENOMEM);
+
+	ulpi->ops = ops;
+	ops->dev = dev;
+
+	ret = ulpi_register(dev, ulpi);
+	if (ret) {
+		kfree(ulpi);
+		return ERR_PTR(ret);
+	}
+
+	return ulpi;
+}
+EXPORT_SYMBOL_GPL(ulpi_register_interface);
+
+/**
+ * ulpi_unregister_interface - unregister ULPI interface
+ * @intrf: struct ulpi_interface
+ *
+ * Unregisters a ULPI device and it's interface that was created with
+ * ulpi_create_interface().
+ */
+void ulpi_unregister_interface(struct ulpi *ulpi)
+{
+	device_unregister(&ulpi->dev);
+}
+EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
+
+/* -------------------------------------------------------------------------- */
+
+static int __init ulpi_init(void)
+{
+	return bus_register(&ulpi_bus);
+}
+module_init(ulpi_init);
+
+static void __exit ulpi_exit(void)
+{
+	bus_unregister(&ulpi_bus);
+}
+module_exit(ulpi_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("USB ULPI PHY bus");
diff --git a/drivers/phy/ulpi/ulpi_phy.h b/drivers/phy/ulpi/ulpi_phy.h
new file mode 100644
index 0000000..ac49fb6
--- /dev/null
+++ b/drivers/phy/ulpi/ulpi_phy.h
@@ -0,0 +1,31 @@
+#include <linux/phy/phy.h>
+
+/**
+ * Helper that registers PHY for a ULPI device and adds a lookup for binding it
+ * and it's controller, which is always the parent.
+ */
+static inline struct phy
+*ulpi_phy_create(struct ulpi *ulpi, struct phy_ops *ops)
+{
+	struct phy *phy;
+	int ret;
+
+	phy = phy_create(&ulpi->dev, NULL, ops);
+	if (IS_ERR(phy))
+		return phy;
+
+	ret = phy_create_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));
+	if (ret) {
+		phy_destroy(phy);
+		return ERR_PTR(ret);
+	}
+
+	return phy;
+}
+
+/* Remove a PHY that was created with ulpi_phy_create() and it's lookup. */
+static inline void ulpi_phy_destroy(struct ulpi *ulpi, struct phy *phy)
+{
+	phy_remove_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));
+	phy_destroy(phy);
+}
diff --git a/include/linux/phy/ulpi/driver.h b/include/linux/phy/ulpi/driver.h
new file mode 100644
index 0000000..639a462
--- /dev/null
+++ b/include/linux/phy/ulpi/driver.h
@@ -0,0 +1,58 @@
+#ifndef __DRIVERS_PHY_ULPI_H
+#define __DRIVERS_PHY_ULPI_H
+
+#include <linux/device.h>
+#include <linux/types.h>
+
+struct ulpi_ops;
+
+struct ulpi_device_id {
+	__u16 vendor;
+	__u16 product;
+};
+
+/**
+ * struct ulpi - describes ULPI PHY device
+ * @id: vendor and product ids for ULPI device
+ * @ops: I/O access
+ * @dev: device interface
+ * @priv: for drivers private use
+ */
+struct ulpi {
+	struct ulpi_device_id id;
+	struct ulpi_ops *ops;
+	struct device dev;
+	void *priv;
+};
+
+#define to_ulpi_dev(d) container_of(d, struct ulpi, dev)
+
+/**
+ * struct ulpi_driver - describes a ULPI PHY driver
+ * @id_table: array of device identifiers supported by this driver
+ * @probe: binds this driver to ULPI device
+ * @remove: unbinds this driver from ULPI device
+ * @driver: the name and owner members must be initialized by the drivers
+ */
+struct ulpi_driver {
+	struct ulpi_device_id *id_table;
+	int (*probe)(struct ulpi *ulpi);
+	void (*remove)(struct ulpi *ulpi);
+	struct device_driver driver;
+};
+
+#define to_ulpi_driver(d) container_of(d, struct ulpi_driver, driver)
+
+int ulpi_register_driver(struct ulpi_driver *drv);
+void ulpi_unregister_driver(struct ulpi_driver *drv);
+
+#define module_ulpi_driver(__ulpi_driver) \
+	module_driver(__ulpi_driver, ulpi_register_driver, \
+		      ulpi_unregister_driver)
+
+int ulpi_read(struct ulpi *ulpi, u8 addr);
+int ulpi_write(struct ulpi *ulpi, u8 addr, u8 val);
+
+extern struct device_type ulpi_device_type;
+
+#endif /* __DRIVERS_PHY_ULPI_H */
diff --git a/include/linux/phy/ulpi/interface.h b/include/linux/phy/ulpi/interface.h
new file mode 100644
index 0000000..51569fe
--- /dev/null
+++ b/include/linux/phy/ulpi/interface.h
@@ -0,0 +1,23 @@
+#ifndef __DRIVERS_PHY_ULPI_INTERFACE_H
+#define __DRIVERS_PHY_ULPI_INTERFACE_H
+
+#include <linux/types.h>
+
+struct ulpi;
+
+/**
+ * struct ulpi_ops - ULPI register access
+ * @dev: the interface provider
+ * @read: read opearation for ULPI register access
+ * @write: write opearation for ULPI register access
+ */
+struct ulpi_ops {
+	struct device *dev;
+	int (*read)(struct ulpi_ops *ops, u8 addr);
+	int (*write)(struct ulpi_ops *ops, u8 addr, u8 val);
+};
+
+struct ulpi *ulpi_register_interface(struct device *, struct ulpi_ops *);
+void ulpi_unregister_interface(struct ulpi *);
+
+#endif /* __DRIVERS_PHY_ULPI_INTERFACE_H */
diff --git a/include/linux/phy/ulpi/regs.h b/include/linux/phy/ulpi/regs.h
new file mode 100644
index 0000000..8407df7
--- /dev/null
+++ b/include/linux/phy/ulpi/regs.h
@@ -0,0 +1,130 @@
+#ifndef __DRIVERS_PHY_ULPI_REGS_H
+#define __DRIVERS_PHY_ULPI_REGS_H
+
+/*
+ * Macros for Set and Clear
+ * See ULPI 1.1 specification to find the registers with Set and Clear offsets
+ */
+#define ULPI_SET(a)				(a + 1)
+#define ULPI_CLR(a)				(a + 2)
+
+/*
+ * Register Map
+ */
+#define ULPI_VENDOR_ID_LOW			0x00
+#define ULPI_VENDOR_ID_HIGH			0x01
+#define ULPI_PRODUCT_ID_LOW			0x02
+#define ULPI_PRODUCT_ID_HIGH			0x03
+#define ULPI_FUNC_CTRL				0x04
+#define ULPI_IFC_CTRL				0x07
+#define ULPI_OTG_CTRL				0x0a
+#define ULPI_USB_INT_EN_RISE			0x0d
+#define ULPI_USB_INT_EN_FALL			0x10
+#define ULPI_USB_INT_STS			0x13
+#define ULPI_USB_INT_LATCH			0x14
+#define ULPI_DEBUG				0x15
+#define ULPI_SCRATCH				0x16
+/* Optional Carkit Registers */
+#define ULPI_CARKIT_CTRL			0x19
+#define ULPI_CARKIT_INT_DELAY			0x1c
+#define ULPI_CARKIT_INT_EN			0x1d
+#define ULPI_CARKIT_INT_STS			0x20
+#define ULPI_CARKIT_INT_LATCH			0x21
+#define ULPI_CARKIT_PLS_CTRL			0x22
+/* Other Optional Registers */
+#define ULPI_TX_POS_WIDTH			0x25
+#define ULPI_TX_NEG_WIDTH			0x26
+#define ULPI_POLARITY_RECOVERY			0x27
+/* Access Extended Register Set */
+#define ULPI_ACCESS_EXTENDED			0x2f
+/* Vendor Specific */
+#define ULPI_VENDOR_SPECIFIC			0x30
+/* Extended Registers */
+#define ULPI_EXT_VENDOR_SPECIFIC		0x80
+
+/*
+ * Register Bits
+ */
+
+/* Function Control */
+#define ULPI_FUNC_CTRL_XCVRSEL			BIT(0)
+#define  ULPI_FUNC_CTRL_XCVRSEL_MASK		0x3
+#define  ULPI_FUNC_CTRL_HIGH_SPEED		0x0
+#define  ULPI_FUNC_CTRL_FULL_SPEED		0x1
+#define  ULPI_FUNC_CTRL_LOW_SPEED		0x2
+#define  ULPI_FUNC_CTRL_FS4LS			0x3
+#define ULPI_FUNC_CTRL_TERMSELECT		BIT(2)
+#define ULPI_FUNC_CTRL_OPMODE			BIT(3)
+#define  ULPI_FUNC_CTRL_OPMODE_MASK		(0x3 << 3)
+#define  ULPI_FUNC_CTRL_OPMODE_NORMAL		(0x0 << 3)
+#define  ULPI_FUNC_CTRL_OPMODE_NONDRIVING	(0x1 << 3)
+#define  ULPI_FUNC_CTRL_OPMODE_DISABLE_NRZI	(0x2 << 3)
+#define  ULPI_FUNC_CTRL_OPMODE_NOSYNC_NOEOP	(0x3 << 3)
+#define ULPI_FUNC_CTRL_RESET			BIT(5)
+#define ULPI_FUNC_CTRL_SUSPENDM			BIT(6)
+
+/* Interface Control */
+#define ULPI_IFC_CTRL_6_PIN_SERIAL_MODE		BIT(0)
+#define ULPI_IFC_CTRL_3_PIN_SERIAL_MODE		BIT(1)
+#define ULPI_IFC_CTRL_CARKITMODE		BIT(2)
+#define ULPI_IFC_CTRL_CLOCKSUSPENDM		BIT(3)
+#define ULPI_IFC_CTRL_AUTORESUME		BIT(4)
+#define ULPI_IFC_CTRL_EXTERNAL_VBUS		BIT(5)
+#define ULPI_IFC_CTRL_PASSTHRU			BIT(6)
+#define ULPI_IFC_CTRL_PROTECT_IFC_DISABLE	BIT(7)
+
+/* OTG Control */
+#define ULPI_OTG_CTRL_ID_PULLUP			BIT(0)
+#define ULPI_OTG_CTRL_DP_PULLDOWN		BIT(1)
+#define ULPI_OTG_CTRL_DM_PULLDOWN		BIT(2)
+#define ULPI_OTG_CTRL_DISCHRGVBUS		BIT(3)
+#define ULPI_OTG_CTRL_CHRGVBUS			BIT(4)
+#define ULPI_OTG_CTRL_DRVVBUS			BIT(5)
+#define ULPI_OTG_CTRL_DRVVBUS_EXT		BIT(6)
+#define ULPI_OTG_CTRL_EXTVBUSIND		BIT(7)
+
+/* USB Interrupt Enable Rising,
+ * USB Interrupt Enable Falling,
+ * USB Interrupt Status and
+ * USB Interrupt Latch
+ */
+#define ULPI_INT_HOST_DISCONNECT		BIT(0)
+#define ULPI_INT_VBUS_VALID			BIT(1)
+#define ULPI_INT_SESS_VALID			BIT(2)
+#define ULPI_INT_SESS_END			BIT(3)
+#define ULPI_INT_IDGRD				BIT(4)
+
+/* Debug */
+#define ULPI_DEBUG_LINESTATE0			BIT(0)
+#define ULPI_DEBUG_LINESTATE1			BIT(1)
+
+/* Carkit Control */
+#define ULPI_CARKIT_CTRL_CARKITPWR		BIT(0)
+#define ULPI_CARKIT_CTRL_IDGNDDRV		BIT(1)
+#define ULPI_CARKIT_CTRL_TXDEN			BIT(2)
+#define ULPI_CARKIT_CTRL_RXDEN			BIT(3)
+#define ULPI_CARKIT_CTRL_SPKLEFTEN		BIT(4)
+#define ULPI_CARKIT_CTRL_SPKRIGHTEN		BIT(5)
+#define ULPI_CARKIT_CTRL_MICEN			BIT(6)
+
+/* Carkit Interrupt Enable */
+#define ULPI_CARKIT_INT_EN_IDFLOAT_RISE		BIT(0)
+#define ULPI_CARKIT_INT_EN_IDFLOAT_FALL		BIT(1)
+#define ULPI_CARKIT_INT_EN_CARINTDET		BIT(2)
+#define ULPI_CARKIT_INT_EN_DP_RISE		BIT(3)
+#define ULPI_CARKIT_INT_EN_DP_FALL		BIT(4)
+
+/* Carkit Interrupt Status and
+ * Carkit Interrupt Latch
+ */
+#define ULPI_CARKIT_INT_IDFLOAT			BIT(0)
+#define ULPI_CARKIT_INT_CARINTDET		BIT(1)
+#define ULPI_CARKIT_INT_DP			BIT(2)
+
+/* Carkit Pulse Control*/
+#define ULPI_CARKIT_PLS_CTRL_TXPLSEN		BIT(0)
+#define ULPI_CARKIT_PLS_CTRL_RXPLSEN		BIT(1)
+#define ULPI_CARKIT_PLS_CTRL_SPKRLEFT_BIASEN	BIT(2)
+#define ULPI_CARKIT_PLS_CTRL_SPKRRIGHT_BIASEN	BIT(3)
+
+#endif /* __DRIVERS_PHY_ULPI_REGS_H */
diff --git a/include/linux/usb/ulpi.h b/include/linux/usb/ulpi.h
index 5c295c2..f5518e4 100644
--- a/include/linux/usb/ulpi.h
+++ b/include/linux/usb/ulpi.h
@@ -12,6 +12,9 @@
 #define __LINUX_USB_ULPI_H
 
 #include <linux/usb/otg.h>
+
+#include "../phy/ulpi/regs.h"
+
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -49,138 +52,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-/*
- * Macros for Set and Clear
- * See ULPI 1.1 specification to find the registers with Set and Clear offsets
- */
-#define ULPI_SET(a)				(a + 1)
-#define ULPI_CLR(a)				(a + 2)
-
-/*-------------------------------------------------------------------------*/
-
-/*
- * Register Map
- */
-#define ULPI_VENDOR_ID_LOW			0x00
-#define ULPI_VENDOR_ID_HIGH			0x01
-#define ULPI_PRODUCT_ID_LOW			0x02
-#define ULPI_PRODUCT_ID_HIGH			0x03
-#define ULPI_FUNC_CTRL				0x04
-#define ULPI_IFC_CTRL				0x07
-#define ULPI_OTG_CTRL				0x0a
-#define ULPI_USB_INT_EN_RISE			0x0d
-#define ULPI_USB_INT_EN_FALL			0x10
-#define ULPI_USB_INT_STS			0x13
-#define ULPI_USB_INT_LATCH			0x14
-#define ULPI_DEBUG				0x15
-#define ULPI_SCRATCH				0x16
-/* Optional Carkit Registers */
-#define ULPI_CARCIT_CTRL			0x19
-#define ULPI_CARCIT_INT_DELAY			0x1c
-#define ULPI_CARCIT_INT_EN			0x1d
-#define ULPI_CARCIT_INT_STS			0x20
-#define ULPI_CARCIT_INT_LATCH			0x21
-#define ULPI_CARCIT_PLS_CTRL			0x22
-/* Other Optional Registers */
-#define ULPI_TX_POS_WIDTH			0x25
-#define ULPI_TX_NEG_WIDTH			0x26
-#define ULPI_POLARITY_RECOVERY			0x27
-/* Access Extended Register Set */
-#define ULPI_ACCESS_EXTENDED			0x2f
-/* Vendor Specific */
-#define ULPI_VENDOR_SPECIFIC			0x30
-/* Extended Registers */
-#define ULPI_EXT_VENDOR_SPECIFIC		0x80
-
-/*-------------------------------------------------------------------------*/
-
-/*
- * Register Bits
- */
-
-/* Function Control */
-#define ULPI_FUNC_CTRL_XCVRSEL			(1 << 0)
-#define  ULPI_FUNC_CTRL_XCVRSEL_MASK		(3 << 0)
-#define  ULPI_FUNC_CTRL_HIGH_SPEED		(0 << 0)
-#define  ULPI_FUNC_CTRL_FULL_SPEED		(1 << 0)
-#define  ULPI_FUNC_CTRL_LOW_SPEED		(2 << 0)
-#define  ULPI_FUNC_CTRL_FS4LS			(3 << 0)
-#define ULPI_FUNC_CTRL_TERMSELECT		(1 << 2)
-#define ULPI_FUNC_CTRL_OPMODE			(1 << 3)
-#define  ULPI_FUNC_CTRL_OPMODE_MASK		(3 << 3)
-#define  ULPI_FUNC_CTRL_OPMODE_NORMAL		(0 << 3)
-#define  ULPI_FUNC_CTRL_OPMODE_NONDRIVING	(1 << 3)
-#define  ULPI_FUNC_CTRL_OPMODE_DISABLE_NRZI	(2 << 3)
-#define  ULPI_FUNC_CTRL_OPMODE_NOSYNC_NOEOP	(3 << 3)
-#define ULPI_FUNC_CTRL_RESET			(1 << 5)
-#define ULPI_FUNC_CTRL_SUSPENDM			(1 << 6)
-
-/* Interface Control */
-#define ULPI_IFC_CTRL_6_PIN_SERIAL_MODE		(1 << 0)
-#define ULPI_IFC_CTRL_3_PIN_SERIAL_MODE		(1 << 1)
-#define ULPI_IFC_CTRL_CARKITMODE		(1 << 2)
-#define ULPI_IFC_CTRL_CLOCKSUSPENDM		(1 << 3)
-#define ULPI_IFC_CTRL_AUTORESUME		(1 << 4)
-#define ULPI_IFC_CTRL_EXTERNAL_VBUS		(1 << 5)
-#define ULPI_IFC_CTRL_PASSTHRU			(1 << 6)
-#define ULPI_IFC_CTRL_PROTECT_IFC_DISABLE	(1 << 7)
-
-/* OTG Control */
-#define ULPI_OTG_CTRL_ID_PULLUP			(1 << 0)
-#define ULPI_OTG_CTRL_DP_PULLDOWN		(1 << 1)
-#define ULPI_OTG_CTRL_DM_PULLDOWN		(1 << 2)
-#define ULPI_OTG_CTRL_DISCHRGVBUS		(1 << 3)
-#define ULPI_OTG_CTRL_CHRGVBUS			(1 << 4)
-#define ULPI_OTG_CTRL_DRVVBUS			(1 << 5)
-#define ULPI_OTG_CTRL_DRVVBUS_EXT		(1 << 6)
-#define ULPI_OTG_CTRL_EXTVBUSIND		(1 << 7)
-
-/* USB Interrupt Enable Rising,
- * USB Interrupt Enable Falling,
- * USB Interrupt Status and
- * USB Interrupt Latch
- */
-#define ULPI_INT_HOST_DISCONNECT		(1 << 0)
-#define ULPI_INT_VBUS_VALID			(1 << 1)
-#define ULPI_INT_SESS_VALID			(1 << 2)
-#define ULPI_INT_SESS_END			(1 << 3)
-#define ULPI_INT_IDGRD				(1 << 4)
-
-/* Debug */
-#define ULPI_DEBUG_LINESTATE0			(1 << 0)
-#define ULPI_DEBUG_LINESTATE1			(1 << 1)
-
-/* Carkit Control */
-#define ULPI_CARKIT_CTRL_CARKITPWR		(1 << 0)
-#define ULPI_CARKIT_CTRL_IDGNDDRV		(1 << 1)
-#define ULPI_CARKIT_CTRL_TXDEN			(1 << 2)
-#define ULPI_CARKIT_CTRL_RXDEN			(1 << 3)
-#define ULPI_CARKIT_CTRL_SPKLEFTEN		(1 << 4)
-#define ULPI_CARKIT_CTRL_SPKRIGHTEN		(1 << 5)
-#define ULPI_CARKIT_CTRL_MICEN			(1 << 6)
-
-/* Carkit Interrupt Enable */
-#define ULPI_CARKIT_INT_EN_IDFLOAT_RISE		(1 << 0)
-#define ULPI_CARKIT_INT_EN_IDFLOAT_FALL		(1 << 1)
-#define ULPI_CARKIT_INT_EN_CARINTDET		(1 << 2)
-#define ULPI_CARKIT_INT_EN_DP_RISE		(1 << 3)
-#define ULPI_CARKIT_INT_EN_DP_FALL		(1 << 4)
-
-/* Carkit Interrupt Status and
- * Carkit Interrupt Latch
- */
-#define ULPI_CARKIT_INT_IDFLOAT			(1 << 0)
-#define ULPI_CARKIT_INT_CARINTDET		(1 << 1)
-#define ULPI_CARKIT_INT_DP			(1 << 2)
-
-/* Carkit Pulse Control*/
-#define ULPI_CARKIT_PLS_CTRL_TXPLSEN		(1 << 0)
-#define ULPI_CARKIT_PLS_CTRL_RXPLSEN		(1 << 1)
-#define ULPI_CARKIT_PLS_CTRL_SPKRLEFT_BIASEN	(1 << 2)
-#define ULPI_CARKIT_PLS_CTRL_SPKRRIGHT_BIASEN	(1 << 3)
-
-/*-------------------------------------------------------------------------*/
-
 #if IS_ENABLED(CONFIG_USB_ULPI)
 struct usb_phy *otg_ulpi_create(struct usb_phy_io_ops *ops,
 					unsigned int flags);
-- 
2.1.4

