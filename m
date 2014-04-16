Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaDPRXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:23:47 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49500 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaDPRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:19:24 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v4 13/21] misc: support for LP-8x4x custom parallel bus
Date: Wed, 16 Apr 2014 21:17:18 +0400
Message-Id: <1397668667-27328-7-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397668667-27328-1-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
 <1397668667-27328-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements probing for the bus and reporting the number
of available expansion slots.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v3..v4
   * move DTS binding to a different patch (8/21)

   v2..v3
   * fixed goto after bus_register
   * number change (11/16 -> 13/21)

   v0..v2
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  16 ++
 Documentation/misc-devices/lp8x4x_bus.txt          |  30 ++++
 arch/arm/configs/lp8x4x_defconfig                  |   1 +
 drivers/misc/Kconfig                               |  13 ++
 drivers/misc/Makefile                              |   1 +
 drivers/misc/lp8x4x_bus.c                          | 167 +++++++++++++++++++++
 6 files changed, 228 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
 create mode 100644 Documentation/misc-devices/lp8x4x_bus.txt
 create mode 100644 drivers/misc/lp8x4x_bus.c

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
new file mode 100644
index 0000000..1c87a29
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -0,0 +1,16 @@
+Custom parallel bus on ICP DAS LP-8x4x industrial computers
+
+See Documentation/misc-devices/lp8x4x_bus.txt for details.
+
+Required properties:
+- compatible : should be "icpdas,backplane-lp8x4x"
+
+- reg: physical base address of the slot count register and the length
+       of the memory mapped region.
+
+Example:
+
+	backplane {
+		compatible = "icpdas,backplane-lp8x4x";
+		reg = <0x17009046 0x2>;
+	};
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
new file mode 100644
index 0000000..f5392b3
--- /dev/null
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -0,0 +1,30 @@
+Kernel driver lpx8x4x_bus
+======================
+
+Supported hardare:
+Custom parallel bus on ICP DAS LP-8x4x industrial computers
+
+Data sheet:
+Not freely available
+
+Author:
+Sergei Ianovich <ynvich@gmail.com>
+
+Description
+-----------
+
+http://www.icpdas.com/root/product/solutions/pac/linpac/lp-8x4x_hardware.html
+
+LP-8x4x is an ARM-based industrial computer with a custom parallel bus to
+connect expansion modules with digital input/output, analog input/output,
+serial, CAN and other types of ports.
+
+The bus is implemented by a FPGA.
+
+SYSFS
+-----
+
+/sys/bus/icpdas/devices/backplane:
+
+slot_count
+	RO - shows total number of expansion slots on the device
diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 9116ce1..c34eb2a 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -62,6 +62,7 @@ CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=2
 CONFIG_EEPROM_AT24=m
+CONFIG_LP8X4X_BUS=m
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 1cb7408..08ffe63 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,19 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config LP8X4X_BUS
+	tristate "ICP DAS LP-8x4x industrial IO bus"
+	depends on OF && ARCH_PXA
+	select SYSFS
+	---help---
+	  This is a driver for ICP DAS LP-8x4x programmable automation
+	  controller. It exposes a custom parallel bus. The bus services
+	  data acquisition and control modules.
+
+	  Say N, unless you plan to run this kernel on a LP-8x4x system.
+
+	  If you say M here, the module will be called lp8x4x_bus.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7eb4b69..2bfe25d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
+obj-$(CONFIG_LP8X4X_BUS)	+= lp8x4x_bus.o
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
new file mode 100644
index 0000000..7aa55cf
--- /dev/null
+++ b/drivers/misc/lp8x4x_bus.c
@@ -0,0 +1,167 @@
+/*
+ *  linux/misc/lp8x4x_bus.c
+ *
+ *  Support for ICP DAS LP-8x4x programmable automation controller bus
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation or any later version.
+ */
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define MODULE_NAME	"lp8x4x-bus"
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
+MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
+
+struct lp8x4x_master {
+	unsigned int		slot_count;
+	void			*count_addr;
+	struct device		dev;
+};
+
+static int lp8x4x_match(struct device *dev, struct device_driver *drv)
+{
+	return 1;
+}
+
+static struct bus_type lp8x4x_bus_type = {
+	.name		= "icpdas",
+	.match		= lp8x4x_match,
+};
+
+static void lp8x4x_master_release(struct device *dev)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+	WARN_ON(!dev);
+
+	kfree(m);
+}
+
+static ssize_t slot_count_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "%u\n", m->slot_count);
+}
+
+static DEVICE_ATTR_RO(slot_count);
+
+static struct attribute *master_dev_attrs[] = {
+	&dev_attr_slot_count.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(master_dev);
+
+
+static void devm_lp8x4x_bus_release(struct device *dev, void *res)
+{
+	struct lp8x4x_master *m = *(struct lp8x4x_master **)res;
+
+	dev_dbg(dev, "releasing devices\n");
+	device_unregister(&m->dev);
+	bus_unregister(&lp8x4x_bus_type);
+}
+
+static int __init lp8x4x_bus_probe(struct platform_device *pdev)
+{
+	struct lp8x4x_master *m, **p;
+	struct resource *res;
+	int err = 0;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	p = devres_alloc(devm_lp8x4x_bus_release, sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		err = -ENOMEM;
+		goto err1;
+	}
+	*p = m;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "could not get slot count address\n");
+		err = -ENODEV;
+		goto err2;
+	}
+
+	m->count_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(m->count_addr)) {
+		dev_err(&pdev->dev, "Failed to ioremap slot count address\n");
+		err = PTR_ERR(m->count_addr);
+		goto err2;
+	}
+
+	m->slot_count = ioread8(m->count_addr);
+	switch (m->slot_count) {
+	case 1:
+	case 4:
+		break;
+	case 7:
+		m->slot_count = 8;
+		break;
+	default:
+		dev_err(&pdev->dev, "unexpected slot number(%u)",
+				m->slot_count);
+		err = -ENODEV;
+		goto err2;
+	};
+
+	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
+
+	err = bus_register(&lp8x4x_bus_type);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register bus type\n");
+		goto err2;
+	}
+
+	m->dev.bus = &lp8x4x_bus_type;
+	dev_set_name(&m->dev, "backplane");
+	m->dev.parent = &pdev->dev;
+	m->dev.release = lp8x4x_master_release;
+	m->dev.groups = master_dev_groups;
+
+	err = device_register(&m->dev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register backplane device\n");
+		goto err3;
+	}
+
+	devres_add(&pdev->dev, p);
+	return 0;
+
+err3:
+	bus_unregister(&lp8x4x_bus_type);
+err2:
+	devres_free(p);
+err1:
+	kfree(m);
+	return err;
+}
+
+static const struct of_device_id lp8x4x_bus_dt_ids[] = {
+	{ .compatible = "icpdas,backplane-lp8x4x" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp8x4x_bus_dt_ids);
+
+static struct platform_driver lp8x4x_bus_driver = {
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = lp8x4x_bus_dt_ids,
+	},
+};
+
+module_platform_driver_probe(lp8x4x_bus_driver, lp8x4x_bus_probe);
-- 
1.8.4.2

