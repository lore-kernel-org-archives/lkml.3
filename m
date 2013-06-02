Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3FBPBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 11:01:01 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:37190 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3FBPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 11:00:26 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Date: Sun,  2 Jun 2013 16:58:49 +0200
Message-Id: <1370185130-15332-2-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

Allwinner has electric fuses (efuse) on their line of chips. This driver
reads those fuses, seeds the kernel entropy and exports them as a sysfs node.

These fuses are most likly to be programmed at the factory, encoding
things like Chip ID, some sort of serial number etc and appear to be
reasonable unique.
While in theory, these should be writeable by the user, it will probably
be inconvinient to do so. Allwinner recommends that a certain input pin,
labeled 'efuse_vddq', be connected to GND. From the name however it is
highly likly that this name is the programming voltage, required to
write these fuses.
Even so, they can still be used to generate a board-unique mac from, board
unique RSA key and seed the kernel RNG.

Currently supported are the following known chips:
Allwinner sun4i (A10)
Allwinner sun5i (A13)

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 drivers/misc/eeprom/Kconfig     |  17 ++++
 drivers/misc/eeprom/Makefile    |   1 +
 drivers/misc/eeprom/sunxi_sid.c | 172 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 04f2e1f..c7bc6ed 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -96,4 +96,21 @@ config EEPROM_DIGSY_MTC_CFG
 
 	  If unsure, say N.
 
+config EEPROM_SUNXI_SID
+	tristate "Allwinner sunxi security ID support"
+	depends on ARCH_SUNXI && SYSFS
+	help
+	  This is a driver for the 'security ID' available on various Allwinner
+	  devices. Currently supported are:
+		sun4i (A10)
+		sun5i (A13)
+
+	  Due to the potential risks involved with changing e-fuses,
+	  this driver is read-only
+
+	  For more information visit http://linux-sunxi.org/SID
+
+	  This driver can also be built as a module. If so, the module
+	  will be called sunxi_sid.
+
 endmenu
diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
index fc1e81d..9507aec 100644
--- a/drivers/misc/eeprom/Makefile
+++ b/drivers/misc/eeprom/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
+obj-$(CONFIG_EEPROM_SUNXI_SID)	+= sunxi_sid.o
 obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
new file mode 100644
index 0000000..4ec86d5
--- /dev/null
+++ b/drivers/misc/eeprom/sunxi_sid.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright (c) 2013 Oliver Schinagl
+ * http://www.linux-sunxi.org
+ *
+ * Oliver Schinagl <oliver@schinagl.nl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * This driver exposes the Allwinner security ID, a 128 bit eeprom, in byte
+ * sized chunks.
+ */
+
+#include <asm/io.h>
+#include <linux/compiler.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/stat.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#define DRV_NAME "sunxi-sid"
+#define DRV_VERSION "1.0"
+
+/* There are 4 32-bit keys */
+#define SID_KEYS 4
+/* and 4 byte sized keys per 32-bit key */
+#define SID_SIZE (SID_KEYS * 4)
+
+static void __iomem *p_sid_reg_base;
+
+/* We read the entire key, but only return the requested byte. This is of
+ * course slower then it could be and uses 4 times more reads as needed but
+ * keeps code a simpler.
+ */
+u8 sunxi_sid_read_byte(const int offset)
+{
+	u32 sid_key;
+	u8 ret;
+
+	ret = 0;
+
+	if (likely((SID_SIZE))) {
+		sid_key = ioread32be(p_sid_reg_base + round_down(offset, 4));
+		sid_key >>= (offset % 4) * 8;
+		ret = sid_key & 0xff;
+	}
+
+	return ret;
+}
+
+static ssize_t sid_read(struct file *fd, struct kobject *kobj,
+			struct bin_attribute *attr, char *buf,
+			loff_t pos, size_t size)
+{
+	ssize_t ret;
+	int i;
+
+	ret = -EPERM;
+
+	if ((likely(size > 0)) && ((size + pos) <= SID_SIZE)) {
+		for (i = 0; i < size; i++)
+			buf[i] = sunxi_sid_read_byte(pos + i);
+		ret = (ssize_t)size;
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static const struct of_device_id sunxi_sid_of_match[] = {
+	{
+		.compatible = "allwinner,sun4i-sid",
+	},
+	{/* sentinel */}
+};
+MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
+
+static const struct bin_attribute sid_bin_attr = {
+	.attr = {
+		.name = "eeprom",
+		.mode = S_IRUGO,
+	},
+	.size = SID_SIZE,
+	.read = sid_read,
+};
+
+static int sunxi_sid_remove(struct platform_device *pdev)
+{
+	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
+	dev_info(&pdev->dev, "Sunxi SID driver unloaded successfully.\n");
+
+	return 0;
+}
+
+static int __init sunxi_sid_probe(struct platform_device *pdev)
+{
+	int entropy[SID_SIZE], i, ret;
+	struct device *dev;
+	struct resource *res;
+	void __iomem *sid_reg_base;
+
+	dev = &pdev->dev;
+	if (unlikely(!pdev->dev.of_node)) {
+		dev_err(dev, "No devicetree data available\n");
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(sid_reg_base)) {
+		dev_err(dev, "Unable to obtain resource\n");
+		ret = PTR_ERR(sid_reg_base);
+		goto exit;
+	}
+	platform_set_drvdata(pdev, sid_reg_base);
+	p_sid_reg_base = sid_reg_base;
+
+	ret = device_create_bin_file(dev, &sid_bin_attr);
+	if (unlikely(ret)) {
+		dev_err(dev, "Unable to create sysfs bin entry\n");
+		goto exit;
+	}
+
+	for (i = 0; i < SID_SIZE; i++)
+		entropy[i] = sunxi_sid_read_byte(i);
+	add_device_randomness(entropy, SID_SIZE);
+
+	dev_info(dev, "Sunxi SID driver loaded successfully.\n");
+
+	return 0;
+
+
+exit:
+	return ret;
+}
+
+static struct platform_driver sunxi_sid_driver = {
+	.probe = sunxi_sid_probe,
+	.remove = sunxi_sid_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = sunxi_sid_of_match,
+	},
+};
+module_platform_driver(sunxi_sid_driver);
+
+
+MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
+MODULE_DESCRIPTION("Allwinner sunxi security id driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
-- 
1.8.1.5

