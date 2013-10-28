Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3J1TPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:15:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45256 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3J1TOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:11 -0400
Message-Id: <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <cover.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:12:35 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenneth Heitke <kheitke@codeaurora.org>

System Power Management Interface (SPMI) is a specification
developed by the MIPI (Mobile Industry Process Interface) Alliance
optimized for the real time control of Power Management ICs (PMIC).

SPMI is a two-wire serial interface that supports up to 4 master
devices and up to 16 logical slaves.

The framework supports message APIs, multiple busses (1 controller
per bus) and multiple clients/slave devices per controller.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/spmi/Kconfig            |   9 +
 drivers/spmi/Makefile           |   4 +
 drivers/spmi/spmi.c             | 491 ++++++++++++++++++++++++++++++++++++++++
 include/dt-bindings/spmi/spmi.h |  18 ++
 include/linux/mod_devicetable.h |   8 +
 include/linux/spmi.h            | 342 ++++++++++++++++++++++++++++
 8 files changed, 875 insertions(+)
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/dt-bindings/spmi/spmi.h
 create mode 100644 include/linux/spmi.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index aa43b91..2b35420 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/spmi/Kconfig"
+
 source "drivers/hsi/Kconfig"
 
 source "drivers/pps/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..5c250df 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_TARGET_CORE)	+= target/
 obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
+obj-$(CONFIG_SPMI)		+= spmi/
 obj-y				+= hsi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
new file mode 100644
index 0000000..a03835f
--- /dev/null
+++ b/drivers/spmi/Kconfig
@@ -0,0 +1,9 @@
+#
+# SPMI driver configuration
+#
+menuconfig SPMI
+	bool "SPMI support"
+	help
+	  SPMI (System Power Management Interface) is a two-wire
+	  serial interface between baseband and application processors
+	  and Power Management Integrated Circuits (PMIC).
diff --git a/drivers/spmi/Makefile b/drivers/spmi/Makefile
new file mode 100644
index 0000000..1de1acd
--- /dev/null
+++ b/drivers/spmi/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for kernel SPMI framework.
+#
+obj-$(CONFIG_SPMI)	+= spmi.o
diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
new file mode 100644
index 0000000..0780bd4
--- /dev/null
+++ b/drivers/spmi/spmi.c
@@ -0,0 +1,491 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/spmi.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+
+#include <dt-bindings/spmi/spmi.h>
+
+static DEFINE_MUTEX(ctrl_idr_lock);
+static DEFINE_IDR(ctrl_idr);
+
+static void spmi_dev_release(struct device *dev)
+{
+	struct spmi_device *sdev = to_spmi_device(dev);
+	kfree(sdev);
+}
+
+static struct device_type spmi_dev_type = {
+	.release	= spmi_dev_release,
+};
+
+static void spmi_ctrl_release(struct device *dev)
+{
+	struct spmi_controller *ctrl = to_spmi_controller(dev);
+	mutex_lock(&ctrl_idr_lock);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&ctrl_idr_lock);
+	kfree(ctrl);
+}
+
+static struct device_type spmi_ctrl_type = {
+	.release	= spmi_ctrl_release,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int spmi_pm_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_suspend(dev);
+	else
+		return 0;
+}
+
+static int spmi_pm_resume(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_resume(dev);
+	else
+		return 0;
+}
+#else
+#define spmi_pm_suspend		NULL
+#define spmi_pm_resume		NULL
+#endif
+
+static const struct dev_pm_ops spmi_pm_ops = {
+	.suspend	= spmi_pm_suspend,
+	.resume		= spmi_pm_resume,
+	SET_RUNTIME_PM_OPS(
+		pm_generic_suspend,
+		pm_generic_resume,
+		pm_generic_runtime_idle
+	)
+};
+
+static int spmi_device_match(struct device *dev, struct device_driver *drv)
+{
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
+	if (drv->name)
+		return strncmp(dev_name(dev), drv->name,
+			       SPMI_NAME_SIZE) == 0;
+
+	return 0;
+}
+
+int spmi_device_add(struct spmi_device *sdev)
+{
+	struct spmi_controller *ctrl = sdev->ctrl;
+	int err;
+
+	dev_set_name(&sdev->dev, "%d-%02x", ctrl->nr, sdev->usid);
+
+	err = device_add(&sdev->dev);
+	if (err < 0) {
+		dev_err(&sdev->dev, "Can't add %s, status %d\n",
+			dev_name(&sdev->dev), err);
+		goto err_device_add;
+	}
+
+	dev_dbg(&sdev->dev, "device %s registered\n", dev_name(&sdev->dev));
+
+err_device_add:
+	return err;
+}
+EXPORT_SYMBOL_GPL(spmi_device_add);
+
+void spmi_device_remove(struct spmi_device *sdev)
+{
+	device_unregister(&sdev->dev);
+}
+EXPORT_SYMBOL_GPL(spmi_device_remove);
+
+static inline int
+spmi_cmd(struct spmi_controller *ctrl, u8 opcode, u8 sid)
+{
+	if (!ctrl || !ctrl->cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->cmd(ctrl, opcode, sid);
+}
+
+static inline int spmi_read_cmd(struct spmi_controller *ctrl,
+				u8 opcode, u8 sid, u16 addr, u8 bc, u8 *buf)
+{
+	if (!ctrl || !ctrl->read_cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->read_cmd(ctrl, opcode, sid, addr, bc, buf);
+}
+
+static inline int spmi_write_cmd(struct spmi_controller *ctrl,
+				 u8 opcode, u8 sid, u16 addr, u8 bc,
+				 const u8 *buf)
+{
+	if (!ctrl || !ctrl->write_cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->write_cmd(ctrl, opcode, sid, addr, bc, buf);
+}
+
+/*
+ * register read/write: 5-bit address, 1 byte of data
+ * extended register read/write: 8-bit address, up to 16 bytes of data
+ * extended register read/write long: 16-bit address, up to 8 bytes of data
+ */
+
+int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf)
+{
+	/* 5-bit register address */
+	if (addr > 0x1F)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_READ, sdev->usid, addr, 0,
+			     buf);
+}
+EXPORT_SYMBOL_GPL(spmi_register_read);
+
+int spmi_ext_register_read(struct spmi_device *sdev, u8 addr, u8 *buf,
+			   size_t len)
+{
+	/* 8-bit register address, up to 16 bytes */
+	if (len == 0 || len > 16)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_EXT_READ, sdev->usid, addr,
+			     len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_read);
+
+int spmi_ext_register_readl(struct spmi_device *sdev, u16 addr, u8 *buf,
+			    size_t len)
+{
+	/* 16-bit register address, up to 8 bytes */
+	if (len == 0 || len > 8)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_EXT_READL, sdev->usid, addr,
+			     len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_readl);
+
+int spmi_register_write(struct spmi_device *sdev, u8 addr, const u8 *buf)
+{
+	/* 5-bit register address */
+	if (addr > 0x1F)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_WRITE, sdev->usid, addr, 0,
+			      buf);
+}
+EXPORT_SYMBOL_GPL(spmi_register_write);
+
+int spmi_register_zero_write(struct spmi_device *sdev, u8 data)
+{
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_ZERO_WRITE, sdev->usid, 0,
+			      0, &data);
+}
+EXPORT_SYMBOL_GPL(spmi_register_zero_write);
+
+int spmi_ext_register_write(struct spmi_device *sdev, u8 addr, const u8 *buf,
+			    size_t len)
+{
+	/* 8-bit register address, up to 16 bytes */
+	if (len == 0 || len > 16)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_EXT_WRITE, sdev->usid, addr,
+			      len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_write);
+
+int spmi_ext_register_writel(struct spmi_device *sdev, u16 addr, const u8 *buf,
+			     size_t len)
+{
+	/* 4-bit Slave Identifier, 16-bit register address, up to 8 bytes */
+	if (len == 0 || len > 8)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_EXT_WRITEL, sdev->usid,
+			      addr, len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_writel);
+
+int spmi_command_reset(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_RESET, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_reset);
+
+int spmi_command_sleep(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_SLEEP, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_sleep);
+
+int spmi_command_wakeup(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_WAKEUP, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_wakeup);
+
+int spmi_command_shutdown(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_SHUTDOWN, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_shutdown);
+
+static int spmi_drv_probe(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+	int err = 0;
+
+	if (sdrv->probe)
+		err = sdrv->probe(to_spmi_device(dev));
+
+	return err;
+}
+
+static int spmi_drv_remove(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+	int err = 0;
+
+	if (sdrv->remove)
+		err = sdrv->remove(to_spmi_device(dev));
+
+	return err;
+}
+
+static void spmi_drv_shutdown(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+
+	if (sdrv->shutdown)
+		sdrv->shutdown(to_spmi_device(dev));
+}
+
+static struct bus_type spmi_bus_type = {
+	.name		= "spmi",
+	.match		= spmi_device_match,
+	.pm		= &spmi_pm_ops,
+	.probe		= spmi_drv_probe,
+	.remove		= spmi_drv_remove,
+	.shutdown	= spmi_drv_shutdown,
+};
+
+struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl)
+{
+	struct spmi_device *sdev;
+
+	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return NULL;
+
+	sdev->ctrl = ctrl;
+	device_initialize(&sdev->dev);
+	sdev->dev.parent = &ctrl->dev;
+	sdev->dev.bus = &spmi_bus_type;
+	sdev->dev.type = &spmi_dev_type;
+	return sdev;
+}
+EXPORT_SYMBOL_GPL(spmi_device_alloc);
+
+struct spmi_controller *spmi_controller_alloc(struct device *parent,
+					      size_t size)
+{
+	struct spmi_controller *ctrl;
+	int id;
+
+	if (WARN_ON(!parent))
+		return NULL;
+
+	ctrl = kzalloc(sizeof(*ctrl) + size, GFP_KERNEL);
+	if (!ctrl)
+		return NULL;
+
+	device_initialize(&ctrl->dev);
+	ctrl->dev.type = &spmi_ctrl_type;
+	ctrl->dev.bus = &spmi_bus_type;
+	ctrl->dev.parent = parent;
+	ctrl->dev.of_node = parent->of_node;
+	spmi_controller_set_drvdata(ctrl, &ctrl[1]);
+
+	idr_preload(GFP_KERNEL);
+	mutex_lock(&ctrl_idr_lock);
+	id = idr_alloc(&ctrl_idr, ctrl, 0, 0, GFP_NOWAIT);
+	mutex_unlock(&ctrl_idr_lock);
+	idr_preload_end();
+
+	if (id < 0) {
+		dev_err(parent,
+			"unable to allocate SPMI controller identifier.\n");
+		spmi_controller_put(ctrl);
+		return NULL;
+	}
+
+	ctrl->nr = id;
+	dev_set_name(&ctrl->dev, "spmi-%d", id);
+
+	dev_dbg(&ctrl->dev, "allocated controller 0x%p id %d\n", ctrl, id);
+	return ctrl;
+}
+EXPORT_SYMBOL_GPL(spmi_controller_alloc);
+
+static int of_spmi_register_devices(struct spmi_controller *ctrl)
+{
+	struct device_node *node;
+	int err;
+
+	dev_dbg(&ctrl->dev, "of_spmi_register_devices\n");
+
+	if (!ctrl->dev.of_node)
+		return -ENODEV;
+
+	dev_dbg(&ctrl->dev, "looping through children\n");
+
+	for_each_available_child_of_node(ctrl->dev.of_node, node) {
+		struct spmi_device *sdev;
+		u32 reg[2];
+
+		dev_dbg(&ctrl->dev, "adding child %s\n", node->full_name);
+
+		err = of_property_read_u32_array(node, "reg", reg, 2);
+		if (err) {
+			dev_err(&ctrl->dev,
+				"node %s does not have 'reg' property\n",
+				node->full_name);
+			continue;
+		}
+
+		if (reg[1] != SPMI_USID) {
+			dev_err(&ctrl->dev,
+				"node %s contains unsupported 'reg' entry\n",
+				node->full_name);
+			continue;
+		}
+
+		if (reg[0] > 0xF) {
+			dev_err(&ctrl->dev,
+				"invalid usid on node %s\n",
+				node->full_name);
+			continue;
+		}
+
+		dev_dbg(&ctrl->dev, "read usid %02x\n", reg[0]);
+
+		sdev = spmi_device_alloc(ctrl);
+		if (!sdev)
+			continue;
+
+		sdev->dev.of_node = node;
+		sdev->usid = (u8) reg[0];
+
+		err = spmi_device_add(sdev);
+		if (err) {
+			dev_err(&sdev->dev,
+				"failure adding device. status %d\n", err);
+			spmi_device_put(sdev);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+int spmi_controller_add(struct spmi_controller *ctrl)
+{
+	int ret;
+
+	/* Can't register until after driver model init */
+	if (WARN_ON(!spmi_bus_type.p))
+		return -EAGAIN;
+
+	ret = device_add(&ctrl->dev);
+	if (ret)
+		return ret;
+
+	if (IS_ENABLED(CONFIG_OF))
+		of_spmi_register_devices(ctrl);
+
+	dev_dbg(&ctrl->dev, "spmi-%d registered: dev:%p\n",
+		ctrl->nr, &ctrl->dev);
+
+	return 0;
+};
+EXPORT_SYMBOL_GPL(spmi_controller_add);
+
+/* Remove a device associated with a controller */
+static int spmi_ctrl_remove_device(struct device *dev, void *data)
+{
+	struct spmi_device *spmidev = to_spmi_device(dev);
+	if (dev->type == &spmi_dev_type)
+		spmi_device_remove(spmidev);
+	return 0;
+}
+
+/**
+ * spmi_controller_remove: Controller tear-down.
+ * @ctrl: controller to be removed.
+ *
+ * Controller added with the above API is torn down using this API.
+ */
+int spmi_controller_remove(struct spmi_controller *ctrl)
+{
+	int dummy;
+
+	if (!ctrl)
+		return -EINVAL;
+
+	dummy = device_for_each_child(&ctrl->dev, NULL,
+				      spmi_ctrl_remove_device);
+	device_unregister(&ctrl->dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spmi_controller_remove);
+
+int spmi_driver_register(struct spmi_driver *drv)
+{
+	drv->driver.bus = &spmi_bus_type;
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(spmi_driver_register);
+
+static void __exit spmi_exit(void)
+{
+	bus_unregister(&spmi_bus_type);
+}
+module_exit(spmi_exit);
+
+static int __init spmi_init(void)
+{
+	return bus_register(&spmi_bus_type);
+}
+postcore_initcall(spmi_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("SPMI module");
+MODULE_ALIAS("platform:spmi");
diff --git a/include/dt-bindings/spmi/spmi.h b/include/dt-bindings/spmi/spmi.h
new file mode 100644
index 0000000..d11e1e5
--- /dev/null
+++ b/include/dt-bindings/spmi/spmi.h
@@ -0,0 +1,18 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __DT_BINDINGS_SPMI_H
+#define __DT_BINDINGS_SPMI_H
+
+#define SPMI_USID	0
+#define SPMI_GSID	1
+
+#endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..677e474 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -432,6 +432,14 @@ struct spi_device_id {
 	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
+#define SPMI_NAME_SIZE	32
+#define SPMI_MODULE_PREFIX "spmi:"
+
+struct spmi_device_id {
+	char name[SPMI_NAME_SIZE];
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
 /* dmi */
 enum dmi_field {
 	DMI_NONE,
diff --git a/include/linux/spmi.h b/include/linux/spmi.h
new file mode 100644
index 0000000..29cf0c9
--- /dev/null
+++ b/include/linux/spmi.h
@@ -0,0 +1,342 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _LINUX_SPMI_H
+#define _LINUX_SPMI_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+
+/* Maximum slave identifier */
+#define SPMI_MAX_SLAVE_ID		16
+
+/* SPMI Commands */
+#define SPMI_CMD_EXT_WRITE		0x00
+#define SPMI_CMD_RESET			0x10
+#define SPMI_CMD_SLEEP			0x11
+#define SPMI_CMD_SHUTDOWN		0x12
+#define SPMI_CMD_WAKEUP			0x13
+#define SPMI_CMD_AUTHENTICATE		0x14
+#define SPMI_CMD_MSTR_READ		0x15
+#define SPMI_CMD_MSTR_WRITE		0x16
+#define SPMI_CMD_TRANSFER_BUS_OWNERSHIP	0x1A
+#define SPMI_CMD_DDB_MASTER_READ	0x1B
+#define SPMI_CMD_DDB_SLAVE_READ		0x1C
+#define SPMI_CMD_EXT_READ		0x20
+#define SPMI_CMD_EXT_WRITEL		0x30
+#define SPMI_CMD_EXT_READL		0x38
+#define SPMI_CMD_WRITE			0x40
+#define SPMI_CMD_READ			0x60
+#define SPMI_CMD_ZERO_WRITE		0x80
+
+/**
+ * Client/device handle (struct spmi_device):
+ *  This is the client/device handle returned when a SPMI device
+ *  is registered with a controller.
+ *  Pointer to this structure is used by client-driver as a handle.
+ *  @dev: Driver model representation of the device.
+ *  @ctrl: SPMI controller managing the bus hosting this device.
+ *  @usid: Unique Slave IDentifier.
+ */
+struct spmi_device {
+	struct device		dev;
+	struct spmi_controller	*ctrl;
+	u8			usid;
+};
+#define to_spmi_device(d) container_of(d, struct spmi_device, dev)
+
+static inline void *spmi_device_get_drvdata(const struct spmi_device *sdev)
+{
+	return dev_get_drvdata(&sdev->dev);
+}
+
+static inline void spmi_device_set_drvdata(struct spmi_device *sdev, void *data)
+{
+	dev_set_drvdata(&sdev->dev, data);
+}
+
+/**
+ * spmi_controller_alloc: Allocate a new SPMI controller
+ * @ctrl: associated controller
+ *
+ * Caller is responsible for either calling spmi_device_add() to add the
+ * newly allocated controller, or calling spmi_device_put() to discard it.
+ */
+struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl);
+
+static inline void spmi_device_put(struct spmi_device *sdev)
+{
+	if (sdev)
+		put_device(&sdev->dev);
+}
+
+/**
+ * spmi_device_add: add a device previously constructed via spmi_device_alloc()
+ * @sdev: spmi_device to be added
+ */
+int spmi_device_add(struct spmi_device *sdev);
+
+/**
+ * spmi_device_remove: remove a device
+ * @sdev: spmi_device to be removed
+ */
+void spmi_device_remove(struct spmi_device *sdev);
+
+/**
+ * struct spmi_controller: interface to the SPMI master controller
+ * @dev: Driver model representation of the device.
+ * @nr: board-specific number identifier for this controller/bus
+ * @cmd: sends a non-data command sequence on the SPMI bus.
+ * @read_cmd: sends a register read command sequence on the SPMI bus.
+ * @write_cmd: sends a register write command sequence on the SPMI bus.
+ */
+struct spmi_controller {
+	struct device		dev;
+	unsigned int		nr;
+	int	(*cmd)(struct spmi_controller *ctrl, u8 opcode, u8 sid);
+	int	(*read_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			    u8 sid, u16 addr, u8 bc, u8 *buf);
+	int	(*write_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			     u8 sid, u16 addr, u8 bc, const u8 *buf);
+};
+#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
+
+static inline
+void *spmi_controller_get_drvdata(const struct spmi_controller *ctrl)
+{
+	return dev_get_drvdata(&ctrl->dev);
+}
+
+static inline void spmi_controller_set_drvdata(struct spmi_controller *ctrl,
+					       void *data)
+{
+	dev_set_drvdata(&ctrl->dev, data);
+}
+
+/**
+ * spmi_controller_alloc: Allocate a new SPMI controller
+ * @parent: parent device
+ * @size: size of private data
+ *
+ * Caller is responsible for either calling spmi_controller_add() to add the
+ * newly allocated controller, or calling spmi_controller_put() to discard it.
+ */
+struct spmi_controller *spmi_controller_alloc(struct device *parent,
+					      size_t size);
+
+static inline void spmi_controller_put(struct spmi_controller *ctrl)
+{
+	if (ctrl)
+		put_device(&ctrl->dev);
+}
+
+/**
+ * spmi_controller_add: Controller bring-up.
+ * @ctrl: controller to be registered.
+ *
+ * Register a controller previously allocated via spmi_controller_alloc() with
+ * the SPMI core
+ */
+int spmi_controller_add(struct spmi_controller *ctrl);
+
+/**
+ * spmi_controller_remove: Controller tear-down.
+ *
+ * Remove a SPMI controller.
+ */
+int spmi_controller_remove(struct spmi_controller *ctrl);
+
+/**
+ * struct spmi_driver: Manage SPMI generic/slave device driver
+ * @driver: SPMI device drivers should initialize name and owner field of
+ *	    this structure
+ * @probe: binds this driver to a SPMI device.
+ * @remove: unbinds this driver from the SPMI device.
+ * @shutdown: standard shutdown callback used during powerdown/halt.
+ * @suspend: standard suspend callback used during system suspend
+ * @resume: standard resume callback used during system resume
+ */
+struct spmi_driver {
+	struct device_driver driver;
+	int	(*probe)(struct spmi_device *sdev);
+	int	(*remove)(struct spmi_device *sdev);
+	void	(*shutdown)(struct spmi_device *sdev);
+	int	(*suspend)(struct spmi_device *sdev, pm_message_t pmesg);
+	int	(*resume)(struct spmi_device *sdev);
+};
+#define to_spmi_driver(d) container_of(d, struct spmi_driver, driver)
+
+/**
+ * spmi_driver_register: Client driver registration with SPMI framework.
+ * @sdrv: client driver to be associated with client-device.
+ *
+ * This API will register the client driver with the SPMI framework.
+ * It is called from the driver's module-init function.
+ */
+int spmi_driver_register(struct spmi_driver *sdrv);
+
+/**
+ * spmi_driver_unregister - reverse effect of spmi_driver_register
+ * @sdrv: the driver to unregister
+ * Context: can sleep
+ */
+static inline void spmi_driver_unregister(struct spmi_driver *sdrv)
+{
+	if (sdrv)
+		driver_unregister(&sdrv->driver);
+}
+
+#define module_spmi_driver(__spmi_driver) \
+	module_driver(__spmi_driver, spmi_driver_register, \
+			spmi_driver_unregister)
+
+/**
+ * spmi_register_read() - register read
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ *
+ * Reads 1 byte of data from a Slave device register.
+ */
+int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf);
+
+/**
+ * spmi_ext_register_read() - extended register read
+ * @sdev: SPMI device
+ * @addr: slave register address (8-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ * @len: the request number of bytes to read (up to 16 bytes).
+ *
+ * Reads up to 16 bytes of data from the extended register space on a
+ * Slave device.
+ */
+int spmi_ext_register_read(struct spmi_device *sdev, u8 addr, u8 *buf,
+			   size_t len);
+
+/**
+ * spmi_ext_register_readl() - extended register read long
+ * @sdev: SPMI device
+ * @addr: slave register address (16-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ * @len: the request number of bytes to read (up to 8 bytes).
+ *
+ * Reads up to 8 bytes of data from the extended register space on a
+ * Slave device using 16-bit address.
+ */
+int spmi_ext_register_readl(struct spmi_device *sdev, u16 addr, u8 *buf,
+			    size_t len);
+
+/**
+ * spmi_register_write() - register write
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ *
+ * Writes 1 byte of data to a Slave device register.
+ */
+int spmi_register_write(struct spmi_device *sdev, u8 addr, const u8 *buf);
+
+/**
+ * spmi_register_zero_write() - register zero write
+ * @sdev: SPMI device
+ * @data: the data to be written to register 0 (7-bits).
+ *
+ * Writes data to register 0 of the Slave device.
+ */
+int spmi_register_zero_write(struct spmi_device *sdev, u8 data);
+
+/**
+ * spmi_ext_register_write() - extended register write
+ * @sdev: SPMI device
+ * @addr: slave register address (8-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ * @len: the request number of bytes to read (up to 16 bytes).
+ *
+ * Writes up to 16 bytes of data to the extended register space of a
+ * Slave device.
+ */
+int spmi_ext_register_write(struct spmi_device *sdev, u8 addr,
+			    const u8 *buf, size_t len);
+
+/**
+ * spmi_ext_register_writel() - extended register write long
+ * @sdev: SPMI device
+ * @addr: slave register address (16-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ * @len: the request number of bytes to read (up to 8 bytes).
+ *
+ * Writes up to 8 bytes of data to the extended register space of a
+ * Slave device using 16-bit address.
+ */
+int spmi_ext_register_writel(struct spmi_device *sdev, u16 addr,
+			     const u8 *buf, size_t len);
+
+/**
+ * spmi_command_reset() - sends RESET command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Reset command initializes the Slave and forces all registers to
+ * their reset values. The Slave shall enter the STARTUP state after
+ * receiving a Reset command.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+int spmi_command_reset(struct spmi_device *sdev);
+
+/**
+ * spmi_command_sleep() - sends SLEEP command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Sleep command causes the Slave to enter the user defined SLEEP state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+int spmi_command_sleep(struct spmi_device *sdev);
+
+/**
+ * spmi_command_wakeup() - sends WAKEUP command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Wakeup command causes the Slave to move from the SLEEP state to
+ * the ACTIVE state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+int spmi_command_wakeup(struct spmi_device *sdev);
+
+/**
+ * spmi_command_shutdown() - sends SHUTDOWN command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Shutdown command causes the Slave to enter the SHUTDOWN state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+int spmi_command_shutdown(struct spmi_device *sdev);
+
+#endif
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


