Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3LQTji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:39:38 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:52866 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3LQTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:39:34 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philip Avinash <avinashphilip@ti.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY...)
Subject: [PATCH v3 10/21] mtd: support BB SRAM on ICP DAS LP-8x4x
Date: Tue, 17 Dec 2013 23:37:40 +0400
Message-Id: <1387309071-22382-11-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
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
   v2..v3
   * no changes (except number 08/16 -> 10/21)

   v0..v2
   * use device tree
   * use devm helpers where possible

 arch/arm/boot/dts/pxa27x-lp8x4x.dts |   6 +
 arch/arm/configs/lp8x4x_defconfig   |   1 +
 drivers/mtd/devices/Kconfig         |  14 +++
 drivers/mtd/devices/Makefile        |   1 +
 drivers/mtd/devices/sram_lp8x4x.c   | 227 ++++++++++++++++++++++++++++++++++++
 5 files changed, 249 insertions(+)
 create mode 100644 drivers/mtd/devices/sram_lp8x4x.c

diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index 872c386..07856e0 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -161,6 +161,12 @@
 				reg = <0x901c 0x1>;
 				status = "okay";
 			};
+
+			sram@a000 {
+				compatible = "icpdas,sram-lp8x4x";
+				reg = <0xa000 0x1000
+				       0x901e 0x1>;
+			};
 		};
 	};
 };
diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index d60e37a..17a4e6f 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -57,6 +57,7 @@ CONFIG_MTD_CFI_ADV_OPTIONS=y
 CONFIG_MTD_CFI_GEOMETRY=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_MTD_SRAM_LP8X4X=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=2
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 0128138..95f2075 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -217,4 +217,18 @@ config BCH_CONST_T
 	default 4
 endif
 
+config MTD_SRAM_LP8X4X
+	tristate "SRAM on ICPDAS LP-8X4X"
+	depends on OF && ARCH_PXA
+       ---help---
+	 This provides an MTD device driver for 512kiB of battery backed up SRAM
+	 on ICPDAS LP-8X4X programmable automation controllers.
+
+	 SRAM chip is connected via FPGA and is not accessible without a driver,
+	 unlike flash memory which is wired to CPU MMU.
+
+	 Say N, unless you plan to run this kernel on LP-8X4X.
+
+	 If you say M, the module will be called sram_lp8x4x.
+
 endmenu
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index d83bd73..56a74c9 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MTD_NAND_OMAP_BCH)	+= elm.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
 obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
+obj-$(CONFIG_MTD_SRAM_LP8X4X)	+= sram_lp8x4x.o
 
 
 CFLAGS_docg3.o			+= -I$(src)
diff --git a/drivers/mtd/devices/sram_lp8x4x.c b/drivers/mtd/devices/sram_lp8x4x.c
new file mode 100644
index 0000000..9dc7149
--- /dev/null
+++ b/drivers/mtd/devices/sram_lp8x4x.c
@@ -0,0 +1,227 @@
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
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
+#include <linux/slab.h>
+#include <linux/string_helpers.h>
+#include <linux/types.h>
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
+static struct of_device_id of_flash_match[] = {
+	{
+		.compatible	= "icpdas,sram-lp8x4x",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_flash_match);
+
+static const char * const probe_types[] = {
+	"cmdlinepart", "RedBoot", "ofpart", "ofoldpart", NULL };
+
+static int
+lp8x4x_sram_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct lp8x4x_sram_info *info;
+	struct resource *r1, *r2;
+	char sz_str[16];
+	struct mtd_part_parser_data ppdata;
+	int err = 0;
+
+	match = of_match_device(of_flash_match, &pdev->dev);
+	if (!match)
+		return -EINVAL;
+
+	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!r1 || !r2)
+		return -ENODEV;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->virt =  devm_ioremap_resource(&pdev->dev, r1);
+	if (!info->virt) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       info->virt);
+		return -EFAULT;
+	}
+
+	info->bank = devm_ioremap_resource(&pdev->dev, r2);
+	if (!info->bank) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       info->bank);
+		return -EFAULT;
+	}
+
+	info->mtd.priv = info;
+	info->mtd.name = "SRAM";
+	info->mtd.type = MTD_RAM;
+	info->mtd.flags = MTD_CAP_RAM;
+	info->mtd.size = resource_size(r1) << 7;
+	info->mtd.erasesize = 512;
+	info->mtd.writesize = 4;
+	info->mtd._erase = lp8x4x_sram_erase;
+	info->mtd._write = lp8x4x_sram_write;
+	info->mtd._read = lp8x4x_sram_read;
+	info->mtd._sync = lp8x4x_sram_sync;
+	info->mtd.owner = THIS_MODULE;
+
+	mutex_init(&info->lock);
+	iowrite8(info->active_bank, info->bank);
+	platform_set_drvdata(pdev, info);
+
+	ppdata.of_node = pdev->dev.of_node;
+	err = mtd_device_parse_register(&info->mtd, probe_types, &ppdata,
+			NULL, 0);
+
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to register platform device\n");
+		return err;
+	}
+
+	string_get_size(info->mtd.size, STRING_UNITS_2, sz_str,
+			sizeof(sz_str));
+	dev_info(&pdev->dev, "using %s SRAM on LP-8X4X as %s\n", sz_str,
+			dev_name(&info->mtd.dev));
+	return 0;
+}
+
+static int
+lp8x4x_sram_remove(struct platform_device *dev)
+{
+	struct lp8x4x_sram_info *info = platform_get_drvdata(dev);
+
+	mtd_device_unregister(&info->mtd);
+	platform_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver lp8x4x_sram_driver = {
+	.driver = {
+		.name		= "sram-lp8x4x",
+		.owner		= THIS_MODULE,
+		.of_match_table = of_flash_match,
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

