Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3LAG2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:28:42 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36825 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3LAG2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:28:38 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 06/11] misc: support for LP-8x4x custom parallel bus
Date: Sun,  1 Dec 2013 10:26:19 +0400
Message-Id: <1385879185-22455-7-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements probing for the bus and reporting the number
of available expansion slots.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 Documentation/misc-devices/lp8x4x_bus.txt |  30 ++++++
 arch/arm/configs/lp8x4x_defconfig         |   1 +
 arch/arm/mach-pxa/include/mach/lp8x4x.h   |   1 +
 arch/arm/mach-pxa/lp8x4x.c                |  18 ++++
 drivers/misc/Kconfig                      |  12 +++
 drivers/misc/Makefile                     |   1 +
 drivers/misc/lp8x4x_bus.c                 | 165 ++++++++++++++++++++++++++++++
 7 files changed, 228 insertions(+)
 create mode 100644 Documentation/misc-devices/lp8x4x_bus.txt
 create mode 100644 drivers/misc/lp8x4x_bus.c

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
index d297a67..5f2b842 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -921,6 +921,7 @@ CONFIG_BLK_DEV_LOOP_MIN_COUNT=2
 # CONFIG_BMP085_I2C is not set
 # CONFIG_USB_SWITCH_FSA9480 is not set
 # CONFIG_SRAM is not set
+CONFIG_LP8X4X_BUS=m
 # CONFIG_C2PORT is not set
 
 #
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index 4d5474e..5d289bf 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -53,6 +53,7 @@
 #define LP8X4X_TTYS0_QUIRK	0x17009030
 #define LP8X4X_TTYS1_QUIRK	0x17009032
 #define LP8X4X_TTYS2_QUIRK	0x17009034
+#define LP8X4X_MOD_NUM		0x17009046
 #define LP8X4X_TTYS0_IOMEM	0x17009050
 #define LP8X4X_TTYS1_IOMEM	0x17009060
 #define LP8X4X_TTYS2_IOMEM	0x17009070
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
index 47a8776..38482d3 100644
--- a/arch/arm/mach-pxa/lp8x4x.c
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -418,6 +418,23 @@ static struct platform_device lp8x4x_ds1302_device[] = {
 	},
 };
 
+static struct resource lp8x4x_bus_resources[] = {
+	[0] = {
+		.start  = LP8X4X_MOD_NUM,
+		.end    = LP8X4X_MOD_NUM,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device lp8x4x_bus_device[] = {
+	{
+		.name           = "lp8x4x-bus",
+		.id             = 0,
+		.resource = &lp8x4x_bus_resources[0],
+		.num_resources = 1,
+	},
+};
+
 static struct platform_device *lp8x4x_devices[] __initdata = {
 	&lp8x4x_flash_device[0],
 	&lp8x4x_flash_device[1],
@@ -425,6 +442,7 @@ static struct platform_device *lp8x4x_devices[] __initdata = {
 	&lp8x4x_dm9000_device[0],
 	&lp8x4x_dm9000_device[1],
 	&lp8x4x_ds1302_device[0],
+	&lp8x4x_bus_device[0],
 };
 
 static struct pxaohci_platform_data lp8x4x_ohci_platform_data = {
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..85676c4 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,18 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config LP8X4X_BUS
+	tristate "ICP DAS LP-8x4x industrial IO bus"
+	depends on MACH_LP8X4X && SYSFS
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
index f45473e..7578cff 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
+obj-$(CONFIG_LP8X4X_BUS)	+= lp8x4x_bus.o
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
new file mode 100644
index 0000000..9cd840e
--- /dev/null
+++ b/drivers/misc/lp8x4x_bus.c
@@ -0,0 +1,165 @@
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+
+#include <mach/mfp-pxa27x.h>
+#include <mach/lp8x4x.h>
+#include <asm/system_info.h>
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
+	BUG_ON(!dev);
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
+	void *mem = m->count_addr;
+
+	dev_info(dev, "releasing devices\n");
+	device_unregister(&m->dev);
+	bus_unregister(&lp8x4x_bus_type);
+	iounmap(mem);
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
+	if (!m) {
+		err = -ENOMEM;
+		goto err1;
+	}
+	*p = m;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto err2;
+	}
+
+	m->count_addr = ioremap(res->start, resource_size(res));
+	if (!m->count_addr) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       m->count_addr);
+		err = -EFAULT;
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
+		dev_info(&pdev->dev, "unexpected slot number(%u)",
+				m->slot_count);
+		goto err3;
+	};
+
+	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
+
+	err = bus_register(&lp8x4x_bus_type);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register bus type\n");
+		goto err3;
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
+		goto err4;
+	}
+
+	devres_add(&pdev->dev, p);
+	return 0;
+
+err4:
+	bus_unregister(&lp8x4x_bus_type);
+err3:
+	iounmap(m->count_addr);
+err2:
+	devres_free(p);
+err1:
+	kfree(m);
+	return err;
+}
+
+static struct platform_driver lp8x4x_bus_driver = {
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver_probe(lp8x4x_bus_driver, lp8x4x_bus_probe);
-- 
1.8.4.2

