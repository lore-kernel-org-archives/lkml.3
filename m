Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3LAG2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:28:09 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64991 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3LAG2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:28:04 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philip Avinash <avinashphilip@ti.com>,
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY...)
Subject: [PATCH 04/11] mtd: support BB SRAM on ICP DAS LP-8x4x
Date: Sun,  1 Dec 2013 10:26:17 +0400
Message-Id: <1385879185-22455-5-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides an MTD device driver for 512kB of battery backed up SRAM
on ICPDAS LP-8X4X programmable automation controllers.

SRAM chip is connected via FPGA and is not accessible without a driver,
unlike flash memory which is wired to CPU MMU.

This SRAM becomes an excellent persisent storage of volatile process
data like counter values and sensor statuses. Storing those data in
flash or mmc card is not a viable solution.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 arch/arm/configs/lp8x4x_defconfig       |   1 +
 arch/arm/mach-pxa/include/mach/lp8x4x.h |   2 +
 arch/arm/mach-pxa/lp8x4x.c              |  26 ++++
 drivers/mtd/devices/Kconfig             |  13 ++
 drivers/mtd/devices/Makefile            |   1 +
 drivers/mtd/devices/lp8x4x_sram.c       | 229 ++++++++++++++++++++++++++++++++
 6 files changed, 272 insertions(+)
 create mode 100644 drivers/mtd/devices/lp8x4x_sram.c

diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 27831e4..03c85bc 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -874,6 +874,7 @@ CONFIG_MTD_PXA2XX=y
 # Disk-On-Chip Device Drivers
 #
 # CONFIG_MTD_DOCG3 is not set
+CONFIG_MTD_LP8X4X_SRAM=y
 # CONFIG_MTD_NAND is not set
 # CONFIG_MTD_ONENAND is not set
 
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index d8a1376..a49df22 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -49,6 +49,8 @@
 #define LP8X4X_ENFALLINT	LP8X4X_P2V(0x17009018)
 #define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)
 #define LP8X4X_RWRTC		LP8X4X_P2V(0x1700901c)
+#define LP8X4X_SRAMBANK		0x1700901e
+#define LP8X4X_SRAM		0x1700a000
 
 /* board specific IRQs */
 
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
index a31b556..47a8776 100644
--- a/arch/arm/mach-pxa/lp8x4x.c
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -234,6 +234,17 @@ static struct resource lp8x4x_flash_resources[] = {
 		.end	= PXA_CS1_PHYS + SZ_32M - 1,
 		.flags	= IORESOURCE_MEM,
 	},
+	[2] = {
+		.start  = LP8X4X_SRAMBANK,
+		.end    = LP8X4X_SRAMBANK + 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[3] = {
+		.start  = LP8X4X_SRAM,
+		.end    = LP8X4X_SRAM + SZ_4K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+
 };
 
 static struct mtd_partition lp8x4x_flash0_partitions[] = {
@@ -267,6 +278,10 @@ static struct flash_platform_data lp8x4x_flash_data[] = {
 		.parts		= NULL,
 		.nr_parts	= 0,
 		.width		= 2,
+	}, {
+		.parts          = NULL,
+		.nr_parts       = 0,
+		.width          = 1,
 	}
 };
 
@@ -289,6 +304,16 @@ static struct platform_device lp8x4x_flash_device[] = {
 		.resource = &lp8x4x_flash_resources[1],
 		.num_resources = 1,
 	},
+	{
+		.name           = "lp8x4x-sram",
+		.id             = 0,
+		.dev = {
+			.platform_data = &lp8x4x_flash_data[2],
+		},
+		.resource = &lp8x4x_flash_resources[2],
+		.num_resources = 2,
+	},
+
 };
 
 static struct pxafb_mode_info lp8x4x_vga_60_mode = {
@@ -396,6 +421,7 @@ static struct platform_device lp8x4x_ds1302_device[] = {
 static struct platform_device *lp8x4x_devices[] __initdata = {
 	&lp8x4x_flash_device[0],
 	&lp8x4x_flash_device[1],
+	&lp8x4x_flash_device[2],
 	&lp8x4x_dm9000_device[0],
 	&lp8x4x_dm9000_device[1],
 	&lp8x4x_ds1302_device[0],
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 0128138..7da0c21 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -217,4 +217,17 @@ config BCH_CONST_T
 	default 4
 endif
 
+config MTD_LP8X4X_SRAM
+       tristate "SRAM on ICPDAS LP-8X4X"
+       ---help---
+	 This provides an MTD device driver for 512kB of battery backed up SRAM
+	 on ICPDAS LP-8X4X programmable automation controllers.
+
+	 SRAM chip is connected via FPGA and is not accessible without a driver,
+	 unlike flash memory which is wired to CPU MMU.
+
+	 Say N, unless you plan to run this kernel on LP-8X4X.
+
+	 If you say M, the module will be called lp8x4x_sram.
+
 endmenu
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index d83bd73..8c5d9b0 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MTD_NAND_OMAP_BCH)	+= elm.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
 obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
+obj-$(CONFIG_MTD_LP8X4X_SRAM)	+= lp8x4x_sram.o
 
 
 CFLAGS_docg3.o			+= -I$(src)
diff --git a/drivers/mtd/devices/lp8x4x_sram.c b/drivers/mtd/devices/lp8x4x_sram.c
new file mode 100644
index 0000000..8fe625d
--- /dev/null
+++ b/drivers/mtd/devices/lp8x4x_sram.c
@@ -0,0 +1,229 @@
+/*
+ *  linux/drivers/mtd/devices/lp8x4x_sram.c
+ *
+ *  MTD Driver for SRAM on ICPDAS LP-8x4x
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation or any later version.
+ */
+
+#include <linux/string_helpers.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+
+#include <linux/io.h>
+#include <mach/hardware.h>
+
+#include <asm/mach/flash.h>
+
+struct lp8x4x_sram_info {
+	void __iomem	*bank;
+	void __iomem	*virt;
+	struct mutex	lock;
+	unsigned	active_bank;
+	struct mtd_info	mtd;
+};
+
+static int
+lp8x4x_sram_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	struct lp8x4x_sram_info *info = mtd->priv;
+	unsigned bank = instr->addr >> 11;
+	unsigned offset = (instr->addr & 0x7ff) << 1;
+	loff_t i;
+
+	mutex_lock(&info->lock);
+	if (unlikely(bank != info->active_bank)) {
+		info->active_bank = bank;
+		iowrite8(bank, info->bank);
+	}
+	for (i = 0; i < instr->len; i++) {
+		iowrite8(0xff, info->virt + offset);
+		offset += 2;
+		if (unlikely(offset == 0)) {
+			info->active_bank++;
+			iowrite8(info->active_bank, info->bank);
+		}
+	}
+	mutex_unlock(&info->lock);
+	instr->state = MTD_ERASE_DONE;
+	mtd_erase_callback(instr);
+
+	return 0;
+}
+
+static int
+lp8x4x_sram_write(struct mtd_info *mtd, loff_t to, size_t len,
+		size_t *retlen, const u_char *b)
+{
+	struct lp8x4x_sram_info *info = mtd->priv;
+	unsigned bank = to >> 11;
+	unsigned offset = (to & 0x7ff) << 1;
+	loff_t i;
+
+	mutex_lock(&info->lock);
+	if (unlikely(bank != info->active_bank)) {
+		info->active_bank = bank;
+		iowrite8(bank, info->bank);
+	}
+	for (i = 0; i < len; i++) {
+		iowrite8(b[i], info->virt + offset);
+		offset += 2;
+		if (unlikely(offset == 0)) {
+			info->active_bank++;
+			iowrite8(info->active_bank, info->bank);
+		}
+	}
+	mutex_unlock(&info->lock);
+	*retlen = len;
+	return 0;
+}
+
+static int
+lp8x4x_sram_read(struct mtd_info *mtd, loff_t from, size_t len,
+		size_t *retlen, u_char *b)
+{
+	struct lp8x4x_sram_info *info = mtd->priv;
+	unsigned bank = from >> 11;
+	unsigned offset = (from & 0x7ff) << 1;
+	loff_t i;
+
+	mutex_lock(&info->lock);
+	if (unlikely(bank != info->active_bank)) {
+		info->active_bank = bank;
+		iowrite8(bank, info->bank);
+	}
+	for (i = 0; i < len; i++) {
+		b[i] = ioread8(info->virt + offset);
+		offset += 2;
+		if (unlikely(offset == 0)) {
+			info->active_bank++;
+			iowrite8(info->active_bank, info->bank);
+		}
+	}
+	mutex_unlock(&info->lock);
+	*retlen = len;
+	return 0;
+}
+
+static void
+lp8x4x_sram_sync(struct mtd_info *mtd)
+{
+}
+
+static const char const *probes[] = { "RedBoot", "cmdlinepart", NULL };
+
+static int
+lp8x4x_sram_probe(struct platform_device *pdev)
+{
+	struct flash_platform_data *flash = pdev->dev.platform_data;
+	struct lp8x4x_sram_info *info;
+	struct resource *res;
+	char sz_str[16];
+	int err = 0;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto err1;
+	}
+
+	info->bank = ioremap(res->start, resource_size(res));
+	if (!info->bank) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       info->bank);
+		err = -EFAULT;
+		goto err1;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		err = -ENODEV;
+		goto err2;
+	}
+
+	info->virt = ioremap(res->start, resource_size(res));
+	if (!info->virt) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       info->virt);
+		err = -EFAULT;
+		goto err2;
+	}
+
+	info->mtd.priv = info;
+	info->mtd.name = "SRAM";
+	info->mtd.type = MTD_RAM;
+	info->mtd.flags = MTD_CAP_RAM;
+	info->mtd.size = resource_size(res) << 7;
+	info->mtd.erasesize = 512;
+	info->mtd.writesize = 4;
+	info->mtd._erase = lp8x4x_sram_erase;
+	info->mtd._write = lp8x4x_sram_write;
+	info->mtd._read = lp8x4x_sram_read;
+	info->mtd._sync = lp8x4x_sram_sync;
+	info->mtd.owner = THIS_MODULE;
+
+	err = mtd_device_parse_register(&info->mtd, probes, NULL, flash->parts,
+			flash->nr_parts);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to register device\n");
+		goto err3;
+	}
+
+	mutex_init(&info->lock);
+	iowrite8(info->active_bank, info->bank);
+	platform_set_drvdata(pdev, info);
+	string_get_size(info->mtd.size, STRING_UNITS_2, sz_str,
+			sizeof(sz_str));
+	dev_info(&pdev->dev, "using %s SRAM on LP-8X4X as %s\n", sz_str,
+			dev_name(&info->mtd.dev));
+	return 0;
+err3:
+	iounmap(info->virt);
+err2:
+	iounmap(info->bank);
+err1:
+	kfree(info);
+	return err;
+}
+
+static int
+lp8x4x_sram_remove(struct platform_device *dev)
+{
+	struct lp8x4x_sram_info *info = platform_get_drvdata(dev);
+
+	platform_set_drvdata(dev, NULL);
+	mtd_device_unregister(&info->mtd);
+	iounmap(info->virt);
+	iounmap(info->bank);
+	kfree(info);
+	return 0;
+}
+
+static struct platform_driver lp8x4x_sram_driver = {
+	.driver = {
+		.name		= "lp8x4x-sram",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= lp8x4x_sram_probe,
+	.remove		= lp8x4x_sram_remove,
+};
+
+module_platform_driver(lp8x4x_sram_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
+MODULE_DESCRIPTION("MTD driver for SRAM on ICPDAS LP-8x4x");
-- 
1.8.4.2

