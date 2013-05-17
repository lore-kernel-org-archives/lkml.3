Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3EQNoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:44:08 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:40090 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab3EQNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:44:04 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2013 09:44:04 EDT
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@ardb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Date: Fri, 17 May 2013 15:35:43 +0200
Message-Id: <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

Allwinner has electric fuses (efuse) on their line of chips. This driver
reads those fuses and exports them as a sysfs node. Also a symbol is exported
for in-kernel useage.

While initially these fuses are used to somewhat determin the chipID, these
appear to be writeable by the user and thus can be used for other purpouses.
For example storing a 128 bit root key, a unique serial number, which could
then even be used as a MAC address.

Because writing to e-fuses can be potentially dangerous, and are certainly
not as often writable (if at all) as flash memory, these shouldn't be easily
changeable, hence only a read-only mode. An offline tool to write the fuses
is in the works.

Currently supported are the following known chips:
Allwinner sun4i (A10)
Allwinner sun5i (A10s A13)
Allwinner sun6i (A31, A31s)
Allwinner sun7i (A20)

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 drivers/misc/eeprom/Kconfig     |  19 ++++
 drivers/misc/eeprom/Makefile    |   1 +
 drivers/misc/eeprom/sunxi_sid.c | 218 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+)
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 04f2e1f..c9ddda5 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -96,4 +96,23 @@ config EEPROM_DIGSY_MTC_CFG
 
 	  If unsure, say N.
 
+config EEPROM_SUNXI_SID
+	tristate "Allwinner sunxi security ID support"
+	depends on ARCH_SUNXI && SYSFS
+	help
+	  This is a driver for the 'security ID' available on various Allwinner
+	  devices. Currently supported are:
+		sun4i (A10)
+		sun5i (A10s, A12, A13)
+		sun6i (A31)
+		sun7i (A20)
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
index 0000000..953f137
--- /dev/null
+++ b/drivers/misc/eeprom/sunxi_sid.c
@@ -0,0 +1,218 @@
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
+ * This driver exposes the Allwinner security ID, a 128 bit eeprom, in chunks
+ * of 8 bytes.
+ */
+
+#include <linux/compiler.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/stat.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+
+#define DRV_NAME "sunxi-sid"
+#define DRV_VERSION "1.0"
+
+/* Register offsets */
+#define SUNXI_SID_KEY0 0x00
+#define SUNXI_SID_KEY1 0x04
+#define SUNXI_SID_KEY2 0x08
+#define SUNXI_SID_KEY3 0x0c
+
+/* There are 4 32-bit keys */
+#define SUNXI_SID_KEYS 4
+/* and 4 32-bit keys per 32-bit key */
+#define SUNXI_SID_SIZE (SUNXI_SID_KEYS * 4)
+
+#if (SUNXI_SID_SIZE > PAGE_SIZE)
+#error "SUNXI_SID_SIZE is larger then the target's PAGE_SIZE, ENOMEM."
+#endif
+
+static u8 keys_lut[] = {
+	SUNXI_SID_KEY0,
+	SUNXI_SID_KEY1,
+	SUNXI_SID_KEY2,
+	SUNXI_SID_KEY3,
+};
+
+struct sid_priv {
+	void __iomem *sid_base;
+};
+
+struct sid_priv *p;
+
+
+/* We read the entire key, using a look up table. Returned is only the
+ * requested byte. This is of course slower then it could be and uses 4 times
+ * more reads as needed but keeps code a little simpler.
+ */
+u8 sunxi_sid_read_byte(const int key)
+{
+	u32 sid_key;
+	u8 ret;
+
+	ret = 0;
+	if (likely((key <= SUNXI_SID_SIZE))) {
+		sid_key = ioread32(p->sid_base + keys_lut[key >> 2]);
+		switch (key % 4) {
+		case 0:
+			ret = (sid_key >> 24) & 0xff;
+			break;
+		case 1:
+			ret = (sid_key >> 16) & 0xff;
+			break;
+		case 2:
+			ret = (sid_key >> 8) & 0xff;
+			break;
+		case 3:
+			ret = sid_key & 0xff;
+			break;
+		}
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
+	struct device *dev;
+	struct sid_priv *priv;
+	int i;
+
+	ret = -EPERM;
+	dev = kobj_to_dev(kobj);
+	priv = dev_get_drvdata(dev);
+
+	if ((likely(size > 0)) && ((size + pos) <= SUNXI_SID_SIZE)) {
+		for (i = 0; i < size; i++) {
+			buf[i] = sunxi_sid_read_byte(pos + i);
+		}
+		if (i < PAGE_SIZE) {
+			buf[i] = '\0';
+			ret = (ssize_t)size;
+		} else {
+			ret = -ENOMEM;
+		}
+	} else {
+		buf[0] = '\0';
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static struct of_device_id sid_of_match[] = {
+	{
+		.compatible = "allwinner,sun4i-sid",
+	},
+	{/* sentinel */}
+};
+MODULE_DEVICE_TABLE(of, sid_of_match);
+
+static struct bin_attribute sid_bin_attr = {
+	.attr = {
+		.name = "key",
+		.mode = S_IRUGO,
+	},
+	.size = SUNXI_SID_SIZE,
+	.read = sid_read,
+};
+
+static int sid_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sid_priv *priv;
+
+	priv = dev_get_drvdata(dev);
+	device_remove_bin_file(dev, &sid_bin_attr);
+	iounmap(priv->sid_base);
+	devm_kfree(dev, priv);
+	return 0;
+}
+
+static int __init sid_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct device *dev = &pdev->dev;
+	struct sid_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	p = priv;
+
+	dev_set_drvdata(dev, priv);
+
+	if (!priv) {
+		dev_err(dev, "Unable to allocate device private data\n");
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	priv->sid_base = of_iomap(dev->of_node, 0);
+	if (!priv->sid_base) {
+		dev_err(dev, "Unable to map memory region\n");
+		ret = -ENOMEM;
+		goto exit_free;
+	}
+
+	ret = device_create_bin_file(dev, &sid_bin_attr);
+	if (ret) {
+		dev_err(dev, "Unable to create sysfs bin entry\n");
+		goto exit_unmap;
+	}
+
+	dev_info(dev, "Sunxi security ID driver loaded successfully.\n");
+
+	return 0;
+
+
+exit_unmap:
+	iounmap(priv->sid_base);
+exit_free:
+	devm_kfree(dev, priv);
+exit:
+	return ret;
+}
+
+static struct platform_driver sid_driver = {
+	.probe = sid_probe,
+	.remove = sid_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = sid_of_match,
+	},
+};
+module_platform_driver(sid_driver);
+
+
+MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
+MODULE_DESCRIPTION("Allwinner sunxi security id driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
-- 
1.8.1.5

