Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936546AbaH1KoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:44:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40004 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaH1KoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:44:09 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: devicetree@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, Gyungoh Yoo <jack.yoo@skyworksinc.com>
Subject: [PATCH v2 1/7] Adding Skyworks SKY81452 MFD driver
Date: Thu, 28 Aug 2014 19:43:51 +0900
Message-Id: <1409222631-23293-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Renamed CONFIG_SKY81452 to CONFIG_MFD_SKY81452
Changed the dependency from I2C=y to I2C, for CONFIG_MFD_SKY81452
Added message for exception or errors.

---
 drivers/mfd/Kconfig          |  12 +++++
 drivers/mfd/Makefile         |   1 +
 drivers/mfd/sky81452.c       | 108 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/sky81452.h |  32 +++++++++++++
 4 files changed, 153 insertions(+)
 create mode 100644 drivers/mfd/sky81452.c
 create mode 100644 include/linux/mfd/sky81452.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..6962b4e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -626,6 +626,18 @@ config MFD_SM501_GPIO
 	 lines on the SM501. The platform data is used to supply the
 	 base number for the first GPIO line to register.
 
+config MFD_SKY81452
+	tristate "Skyworks Solutions SKY81452"
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C
+	help
+	  This is the core driver for the Skyworks SKY81452 backlight and
+	  voltage regulator device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called sky81452.
+
 config MFD_SMSC
        bool "SMSC ECE1099 series chips"
        depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f001487..6c2f317 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
 obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
+obj-$(CONFIG_MFD_SKY81452)		+= sky81452.o
 
 intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
 obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
new file mode 100644
index 0000000..c0ca812
--- /dev/null
+++ b/drivers/mfd/sky81452.c
@@ -0,0 +1,108 @@
+/*
+ * sky81452.c	SKY81452 MFD driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sky81452.h>
+
+static const struct regmap_config sky81452_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int sky81452_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	const struct sky81452_platform_data *pdata = dev_get_platdata(dev);
+	struct mfd_cell cells[2];
+	struct regmap *regmap;
+	int ret;
+
+	if (!pdata) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+	}
+
+	regmap = devm_regmap_init_i2c(client, &sky81452_config);
+	if (IS_ERR(regmap)) {
+		dev_err(dev, "failed to initialize I2C:%d", PTR_ERR(regmap));
+		return PTR_ERR(regmap);
+	}
+
+	i2c_set_clientdata(client, regmap);
+
+	cells[0].name = "sky81452-bl";
+	cells[0].platform_data = pdata->bl_pdata;
+	cells[0].pdata_size = sizeof(*pdata->bl_pdata);
+	cells[1].name = "sky81452-regulator";
+	cells[1].platform_data = pdata->regulator_init_data;
+	cells[1].pdata_size = sizeof(*pdata->regulator_init_data);
+
+	ret = mfd_add_devices(dev, -1, cells, ARRAY_SIZE(cells), NULL, 0, NULL);
+	if (IS_ERR_VALUE(ret))
+		dev_err(dev, "failed to add child device:%d", ret);
+
+	return ret;
+}
+
+static int sky81452_remove(struct i2c_client *client)
+{
+	mfd_remove_devices(&client->dev);
+	return 0;
+}
+
+static const struct i2c_device_id sky81452_ids[] = {
+	{ "sky81452" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, sky81452_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id sky81452_of_match[] = {
+	{ .compatible = "skyworks,sky81452", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sky81452_of_match);
+#endif
+
+static struct i2c_driver sky81452_driver = {
+	.driver = {
+		.name = "sky81452",
+		.of_match_table = of_match_ptr(sky81452_of_match),
+	},
+	.probe = sky81452_probe,
+	.remove = sky81452_remove,
+	.id_table = sky81452_ids,
+};
+
+module_i2c_driver(sky81452_driver);
+
+MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
+MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.1");
diff --git a/include/linux/mfd/sky81452.h b/include/linux/mfd/sky81452.h
new file mode 100644
index 0000000..142f762
--- /dev/null
+++ b/include/linux/mfd/sky81452.h
@@ -0,0 +1,32 @@
+/*
+ * sky81452.h	SKY81452 MFD driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _SKY81452_H
+#define _SKY81452_H
+
+#include <linux/sky81452-backlight.h>
+#include <linux/regulator/machine.h>
+
+struct sky81452_platform_data {
+	struct sky81452_bl_platform_data *bl_pdata;
+	struct regulator_init_data *regulator_init_data;
+};
+
+#endif
-- 
1.9.1

