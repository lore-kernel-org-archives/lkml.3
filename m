Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaBDMT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:19:29 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:47735 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaBDMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:19:23 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] mfd: add bcm59056 pmu driver
Date: Tue,  4 Feb 2014 07:19:09 -0500
Message-Id: <1391516352-32359-4-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391516352-32359-1-git-send-email-mporter@linaro.org>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the BCM59056 PMU multi-function device. The driver
initially supports regmap initialization and instantiation of the
voltage regulator device function of the PMU.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/mfd/Kconfig          |   8 +++
 drivers/mfd/Makefile         |   1 +
 drivers/mfd/bcm59056.c       | 119 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/bcm59056.h |  35 +++++++++++++
 4 files changed, 163 insertions(+)
 create mode 100644 drivers/mfd/bcm59056.c
 create mode 100644 include/linux/mfd/bcm59056.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445..36e96c2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -59,6 +59,14 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config MFD_BCM59056
+	bool "Broadcom BCM59056 PMU"
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C=y
+	help
+	  Support for the BCM59056 PMU from Broadcom
+
 config MFD_CROS_EC
 	tristate "ChromeOS Embedded Controller"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5aea5ef..8d7e110 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
+obj-$(CONFIG_MFD_BCM59056)	+= bcm59056.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
diff --git a/drivers/mfd/bcm59056.c b/drivers/mfd/bcm59056.c
new file mode 100644
index 0000000..f193bfb
--- /dev/null
+++ b/drivers/mfd/bcm59056.c
@@ -0,0 +1,119 @@
+/*
+ * Broadcom BCM59056 PMU
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
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/mfd/bcm59056.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+static struct mfd_cell bcm59056s[] = {
+	{
+		.name = "bcm59056-pmu",
+	},
+};
+
+static const struct regmap_config bcm59056_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= BCM59056_MAX_REGISTER - 1,
+	.cache_type	= REGCACHE_RBTREE,
+};
+
+static int bcm59056_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct bcm59056 *bcm59056;
+	int chip_id = id->driver_data;
+	int ret = 0;
+
+	bcm59056 = devm_kzalloc(&i2c->dev, sizeof(*bcm59056), GFP_KERNEL);
+	if (!bcm59056)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, bcm59056);
+	bcm59056->dev = &i2c->dev;
+	bcm59056->i2c_client = i2c;
+	bcm59056->id = chip_id;
+
+	bcm59056->regmap = devm_regmap_init_i2c(i2c, &bcm59056_regmap_config);
+	if (IS_ERR(bcm59056->regmap)) {
+		ret = PTR_ERR(bcm59056->regmap);
+		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = mfd_add_devices(bcm59056->dev, -1,
+			      bcm59056s, ARRAY_SIZE(bcm59056s),
+			      NULL, 0, NULL);
+	if (ret < 0)
+		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
+
+	return ret;
+}
+
+static int bcm59056_i2c_remove(struct i2c_client *i2c)
+{
+	struct bcm59056 *bcm59056 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(bcm59056->dev);
+
+	return 0;
+}
+
+static const struct of_device_id bcm59056_of_match[] = {
+	{ .compatible = "brcm,bcm59056", .data = (void *)BCM59056 },
+	{ }
+};
+
+static const struct i2c_device_id bcm59056_i2c_id[] = {
+	{ "bcm59056", BCM59056 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bcm59056_i2c_id);
+
+static struct i2c_driver bcm59056_i2c_driver = {
+	.driver = {
+		   .name = "bcm59056",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(bcm59056_of_match),
+	},
+	.probe = bcm59056_i2c_probe,
+	.remove = bcm59056_i2c_remove,
+	.id_table = bcm59056_i2c_id,
+};
+
+static int __init bcm59056_init(void)
+{
+	return i2c_add_driver(&bcm59056_i2c_driver);
+}
+subsys_initcall(bcm59056_init);
+
+static void __exit bcm59056_exit(void)
+{
+	i2c_del_driver(&bcm59056_i2c_driver);
+}
+module_exit(bcm59056_exit);
+
+MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
+MODULE_DESCRIPTION("BCM59056 multi-function driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:bcm59056");
diff --git a/include/linux/mfd/bcm59056.h b/include/linux/mfd/bcm59056.h
new file mode 100644
index 0000000..967395d
--- /dev/null
+++ b/include/linux/mfd/bcm59056.h
@@ -0,0 +1,35 @@
+/*
+ * Broadcom BCM59056 PMU
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
+#ifndef __LINUX_MFD_BCM59056_H
+#define __LINUX_MFD_BCM59056_H
+
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+
+/* chip id */
+#define BCM59056		0
+
+/* max register address */
+#define BCM59056_MAX_REGISTER	0xe8
+
+/* bcm59056 chip access */
+struct bcm59056 {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	struct regmap *regmap;
+	unsigned int id;
+};
+
+#endif /*  __LINUX_MFD_BCM59056_H */
-- 
1.8.4

