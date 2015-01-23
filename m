Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbbAWPPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:15:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbbAWPNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508861"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] usb: add bus type for USB ULPI
Date: Fri, 23 Jan 2015 17:12:51 +0200
Message-Id: <1422025978-178336-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UTMI+ Low Pin Interface (ULPI) is a commonly used PHY
interface for USB 2.0. The ULPI specification describes a
standard set of registers which the vendors can extend for
their specific needs. ULPI PHYs provide often functions
such as charger detection and ADP sensing and probing.

There are two major issues that the bus type is meant to
tackle:

Firstly, ULPI registers are accessed from the controller.
The bus provides convenient method for the controller
drivers to share that access with the actual PHY drivers.

Secondly, there are already platforms that assume ULPI PHYs
are runtime detected, such as many Intel Baytrail based
platforms. They do not provide any kind of hardware
description for the ULPI PHYs like separate ACPI device
object that could be used to enumerate a device from.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 MAINTAINERS                       |   7 ++
 drivers/usb/common/Makefile       |   3 +-
 drivers/usb/common/ulpi.c         | 253 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/Kconfig          |   8 ++
 include/linux/mod_devicetable.h   |   6 +
 include/linux/ulpi/driver.h       |  62 ++++++++++
 include/linux/ulpi/interface.h    |  23 ++++
 include/linux/ulpi/regs.h         | 130 ++++++++++++++++++++
 include/linux/usb/ulpi.h          | 134 +-------------------
 scripts/mod/devicetable-offsets.c |   4 +
 scripts/mod/file2alias.c          |  13 ++
 11 files changed, 510 insertions(+), 133 deletions(-)
 create mode 100644 drivers/usb/common/ulpi.c
 create mode 100644 include/linux/ulpi/driver.h
 create mode 100644 include/linux/ulpi/interface.h
 create mode 100644 include/linux/ulpi/regs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 761a4a1..7d0c58c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10234,6 +10234,13 @@ S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
 F:	drivers/media/usb/zr364xx/
 
+ULPI BUS
+M:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/usb/common/ulpi.c
+F:	include/linux/ulpi/
+
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
 M:	Richard Weinberger <richard@nod.at>
diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
index ca2f8bd..5791d6c 100644
--- a/drivers/usb/common/Makefile
+++ b/drivers/usb/common/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_USB_COMMON)	  += usb-common.o
 usb-common-y			  += common.o
 usb-common-$(CONFIG_USB_LED_TRIG) += led.o
 
-obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
+obj-$(CONFIG_USB_OTG_FSM)	+= usb-otg-fsm.o
+obj-$(CONFIG_USB_ULPI_BUS)	+= ulpi.o
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
new file mode 100644
index 0000000..3ed66be
--- /dev/null
+++ b/drivers/usb/common/ulpi.c
@@ -0,0 +1,253 @@
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
+#include <linux/ulpi/interface.h>
+#include <linux/ulpi/driver.h>
+#include <linux/ulpi/regs.h>
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
+static int ulpi_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct ulpi *ulpi = to_ulpi_dev(dev);
+
+	if (add_uevent_var(env, "MODALIAS=ulpi:v%04xp%04x",
+			   ulpi->id.vendor, ulpi->id.product))
+		return -ENOMEM;
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
+	.uevent = ulpi_uevent,
+	.probe = ulpi_probe,
+	.remove = ulpi_remove,
+};
+EXPORT_SYMBOL_GPL(ulpi_bus);
+
+/* -------------------------------------------------------------------------- */
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct ulpi *ulpi = to_ulpi_dev(dev);
+
+	return sprintf(buf, "ulpi:v%04xp%04x\n",
+		       ulpi->id.vendor, ulpi->id.product);
+}
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *ulpi_dev_attrs[] = {
+	&dev_attr_modalias.attr,
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
+static void ulpi_dev_release(struct device *dev)
+{
+	kfree(to_ulpi_dev(dev));
+}
+
+struct device_type ulpi_device_type = {
+	.name = "ulpi_device",
+	.groups = ulpi_dev_attr_groups,
+	.release = ulpi_dev_release,
+};
+
+/* -------------------------------------------------------------------------- */
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
+	request_module("ulpi:v%04xp%04x", ulpi->id.vendor, ulpi->id.product);
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
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("USB ULPI PHY bus");
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index cc0ced0..c0fc3b5 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -84,3 +84,11 @@ config USB_OTG_FSM
 	  Implements OTG Finite State Machine as specified in On-The-Go
 	  and Embedded Host Supplement to the USB Revision 2.0 Specification.
 
+config USB_ULPI_BUS
+	bool "USB ULPI PHY interface support"
+	depends on USB || USB_GADGET
+	help
+	  Say yes if you have ULPI PHY attached to your USB controller.
+
+	  If unsure, say N.
+
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 745def8..6581615 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -626,4 +626,10 @@ struct mcb_device_id {
 	kernel_ulong_t driver_data;
 };
 
+struct ulpi_device_id {
+	__u16 vendor;
+	__u16 product;
+	kernel_ulong_t driver_data;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/ulpi/driver.h b/include/linux/ulpi/driver.h
new file mode 100644
index 0000000..a90d216
--- /dev/null
+++ b/include/linux/ulpi/driver.h
@@ -0,0 +1,62 @@
+#ifndef __LINUX_ULPI_DRIVER_H
+#define __LINUX_ULPI_DRIVER_H
+
+#include <linux/mod_devicetable.h>
+
+#include <linux/device.h>
+
+struct ulpi_ops;
+
+/**
+ * struct ulpi - describes ULPI PHY device
+ * @id: vendor and product ids for ULPI device
+ * @ops: I/O access
+ * @dev: device interface
+ */
+struct ulpi {
+	struct ulpi_device_id id;
+	struct ulpi_ops *ops;
+	struct device dev;
+};
+
+#define to_ulpi_dev(d) container_of(d, struct ulpi, dev)
+
+static inline void ulpi_set_drvdata(struct ulpi *ulpi, void *data)
+{
+	dev_set_drvdata(&ulpi->dev, data);
+}
+
+static inline void *ulpi_get_drvdata(struct ulpi *ulpi)
+{
+	return dev_get_drvdata(&ulpi->dev);
+}
+
+/**
+ * struct ulpi_driver - describes a ULPI PHY driver
+ * @id_table: array of device identifiers supported by this driver
+ * @probe: binds this driver to ULPI device
+ * @remove: unbinds this driver from ULPI device
+ * @driver: the name and owner members must be initialized by the drivers
+ */
+struct ulpi_driver {
+	const struct ulpi_device_id *id_table;
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
+#endif /* __LINUX_ULPI_DRIVER_H */
diff --git a/include/linux/ulpi/interface.h b/include/linux/ulpi/interface.h
new file mode 100644
index 0000000..08753f7
--- /dev/null
+++ b/include/linux/ulpi/interface.h
@@ -0,0 +1,23 @@
+#ifndef __LINUX_ULPI_INTERFACE_H
+#define __LINUX_ULPI_INTERFACE_H
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
+#endif /* __LINUX_ULPI_INTERFACE_H */
diff --git a/include/linux/ulpi/regs.h b/include/linux/ulpi/regs.h
new file mode 100644
index 0000000..b5b8b88
--- /dev/null
+++ b/include/linux/ulpi/regs.h
@@ -0,0 +1,130 @@
+#ifndef __LINUX_ULPI_REGS_H
+#define __LINUX_ULPI_REGS_H
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
+#endif /* __LINUX_ULPI_REGS_H */
diff --git a/include/linux/usb/ulpi.h b/include/linux/usb/ulpi.h
index 5c295c2..5f07407 100644
--- a/include/linux/usb/ulpi.h
+++ b/include/linux/usb/ulpi.h
@@ -12,6 +12,8 @@
 #define __LINUX_USB_ULPI_H
 
 #include <linux/usb/otg.h>
+#include <linux/ulpi/regs.h>
+
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -49,138 +51,6 @@
 
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
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index f282516..2b55464 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -186,5 +186,9 @@ int main(void)
 	DEVID_FIELD(rio_device_id, asm_did);
 	DEVID_FIELD(rio_device_id, asm_vid);
 
+	DEVID(ulpi_device_id);
+	DEVID_FIELD(ulpi_device_id, vendor);
+	DEVID_FIELD(ulpi_device_id, product);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index e614ef6..753cb08 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1176,6 +1176,19 @@ static int do_rio_entry(const char *filename,
 }
 ADD_TO_DEVTABLE("rapidio", rio_device_id, do_rio_entry);
 
+/* Looks like: mei:S */
+static int do_ulpi_entry(const char *filename, void *symval,
+			 char *alias)
+{
+	DEF_FIELD(symval, ulpi_device_id, vendor);
+	DEF_FIELD(symval, ulpi_device_id, product);
+
+	sprintf(alias, "ulpi:v%04xp%04x", vendor, product);
+
+	return 1;
+}
+ADD_TO_DEVTABLE("ulpi", ulpi_device_id, do_ulpi_entry);
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
-- 
2.1.4

