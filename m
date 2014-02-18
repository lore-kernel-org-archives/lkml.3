Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaBRXRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:17:31 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52381 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaBRXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:17:23 -0500
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] mfd: add bcm590xx pmu driver
Date: Tue, 18 Feb 2014 18:17:09 -0500
Message-Id: <1392765432-9111-3-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392765432-9111-1-git-send-email-mporter@linaro.org>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the BCM590xx PMU multi-function devices. The driver
initially supports regmap initialization and instantiation of the
voltage regulator device function of the PMU.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/mfd/Kconfig          |  8 +++++
 drivers/mfd/Makefile         |  1 +
 drivers/mfd/bcm590xx.c       | 86 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/bcm590xx.h | 31 ++++++++++++++++
 4 files changed, 126 insertions(+)
 create mode 100644 drivers/mfd/bcm590xx.c
 create mode 100644 include/linux/mfd/bcm590xx.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445..eda60de 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -59,6 +59,14 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config MFD_BCM590XX
+	bool "Broadcom BCM590xx PMUs"
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C=y
+	help
+	  Support for the BCM590xx PMUs from Broadcom
+
 config MFD_CROS_EC
 	tristate "ChromeOS Embedded Controller"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5aea5ef..4c342bf 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
+obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
new file mode 100644
index 0000000..06f6387
--- /dev/null
+++ b/drivers/mfd/bcm590xx.c
@@ -0,0 +1,86 @@
+/*
+ * Broadcom BCM590xx PMU
+ *
+ * Copyright 2014 Linaro Limited
+ * Author: Matt Porter <mporter@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/mfd/bcm590xx.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+static const struct regmap_config bcm590xx_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= BCM590XX_MAX_REGISTER,
+	.cache_type	= REGCACHE_RBTREE,
+};
+
+static int bcm590xx_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct bcm590xx *bcm590xx;
+	int ret = 0;
+
+	bcm590xx = devm_kzalloc(&i2c->dev, sizeof(*bcm590xx), GFP_KERNEL);
+	if (!bcm590xx)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, bcm590xx);
+	bcm590xx->dev = &i2c->dev;
+	bcm590xx->i2c_client = i2c;
+
+	bcm590xx->regmap = devm_regmap_init_i2c(i2c, &bcm590xx_regmap_config);
+	if (IS_ERR(bcm590xx->regmap)) {
+		ret = PTR_ERR(bcm590xx->regmap);
+		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = of_platform_populate(i2c->dev.of_node, NULL, NULL, &i2c->dev);
+	if (ret < 0)
+		dev_err(&i2c->dev, "of_platform_populate() failed: %d\n", ret);
+
+	return ret;
+}
+
+static const struct of_device_id bcm590xx_of_match[] = {
+	{ .compatible = "brcm,bcm59056" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bcm590xx_of_match);
+
+static const struct i2c_device_id bcm590xx_i2c_id[] = {
+	{ "bcm59056" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bcm590xx_i2c_id);
+
+static struct i2c_driver bcm590xx_i2c_driver = {
+	.driver = {
+		   .name = "bcm590xx",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(bcm590xx_of_match),
+	},
+	.probe = bcm590xx_i2c_probe,
+	.id_table = bcm590xx_i2c_id,
+};
+module_i2c_driver(bcm590xx_i2c_driver);
+
+MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
+MODULE_DESCRIPTION("BCM590xx multi-function driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:bcm590xx");
diff --git a/include/linux/mfd/bcm590xx.h b/include/linux/mfd/bcm590xx.h
new file mode 100644
index 0000000..434df2d
--- /dev/null
+++ b/include/linux/mfd/bcm590xx.h
@@ -0,0 +1,31 @@
+/*
+ * Broadcom BCM590xx PMU
+ *
+ * Copyright 2014 Linaro Limited
+ * Author: Matt Porter <mporter@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_BCM590XX_H
+#define __LINUX_MFD_BCM590XX_H
+
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+
+/* max register address */
+#define BCM590XX_MAX_REGISTER	0xe7
+
+struct bcm590xx {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	struct regmap *regmap;
+	unsigned int id;
+};
+
+#endif /*  __LINUX_MFD_BCM590XX_H */
-- 
1.8.4

