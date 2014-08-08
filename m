Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaHHJIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:08:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39412 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:08:32 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jack.yoo@skyworksinc.com,
        jason@lakedaemon.net, heiko.stuebner@bqreaders.com,
        florian.vaussard@epfl.ch, thierry.reding@gmail.com, andrew@lunn.ch,
        silvio.fricke@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Adding Skyworks SKY81452 MFD driver
Date: Fri,  8 Aug 2014 18:08:19 +0900
Message-Id: <1407488899-31065-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
 Documentation/devicetree/bindings/mfd/sky81452.txt |  24 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/mfd/Kconfig                                |  12 +++
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/sky81452.c                             | 113 +++++++++++++++++++++
 include/linux/mfd/sky81452.h                       |  32 ++++++
 6 files changed, 183 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
 create mode 100644 drivers/mfd/sky81452.c
 create mode 100644 include/linux/mfd/sky81452.h

diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
new file mode 100644
index 0000000..5fb0b4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
@@ -0,0 +1,24 @@
+SKY81452 bindings
+
+Required properties:
+- compatible	: Must be "skyworks,sky81452"
+
+Required child nodes:
+- backlight	: container node for backlight following the binding
+		in video/backlight/sky81452-backlight.txt
+- regulator	: container node for regulators following the binding
+		in regulator/sky81452-regulator.txt
+
+Example:
+
+	sky81452@2C {
+		compatible = "skyworks,sky81452";
+
+		backlight {
+			...
+		};
+
+		regulator {
+			...
+		};
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index d415b38..ce76e10 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -122,6 +122,7 @@ silabs	Silicon Laboratories
 simtek
 sii	Seiko Instruments, Inc.
 sirf	SiRF Technology, Inc.
+skyworks	Skyworks Solutions, Inc.
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 spansion	Spansion Inc.
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..acfb2e5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -626,6 +626,18 @@ config MFD_SM501_GPIO
 	 lines on the SM501. The platform data is used to supply the
 	 base number for the first GPIO line to register.
 
+config SKY81452
+	tristate "Skyworks Solutions SKY81452"
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C=y
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
index f001487..191c656 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
 obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
+obj-$(CONFIG_SKY81452)		+= sky81452.o
 
 intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
 obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
new file mode 100644
index 0000000..566912f
--- /dev/null
+++ b/drivers/mfd/sky81452.c
@@ -0,0 +1,113 @@
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
+static int sky81452_register_devices(struct device *dev,
+		const struct sky81452_platform_data *pdata)
+{
+	struct mfd_cell cells[] = {
+		{
+			.name = "sky81452-bl",
+			.platform_data = pdata->bl_pdata,
+			.pdata_size = sizeof(*pdata->bl_pdata),
+		},
+		{
+			.name = "sky81452-regulator",
+			.platform_data = pdata->regulator_init_data,
+			.pdata_size = sizeof(*pdata->regulator_init_data),
+		},
+	};
+
+	return mfd_add_devices(dev, -1, cells, ARRAY_SIZE(cells),
+			NULL, 0, NULL);
+}
+
+static int sky81452_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	const struct sky81452_platform_data *pdata = dev_get_platdata(dev);
+	struct regmap *map;
+
+	if (!pdata) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+	}
+
+	map = devm_regmap_init_i2c(client, &sky81452_config);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	i2c_set_clientdata(client, map);
+
+	return sky81452_register_devices(dev, pdata);
+}
+
+static int sky81452_remove(struct i2c_client *client)
+{
+	mfd_remove_devices(&client->dev);
+	return 0;
+}
+
+static const struct i2c_device_id sky81452_ids[] = {
+	{ "sky81452", 0 },
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
+MODULE_VERSION("1.0");
diff --git a/include/linux/mfd/sky81452.h b/include/linux/mfd/sky81452.h
new file mode 100644
index 0000000..8d8ed35
--- /dev/null
+++ b/include/linux/mfd/sky81452.h
@@ -0,0 +1,32 @@
+/*
+ * sky81452.h	SKY81452 backlight driver
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
+#include "linux/sky81452-backlight.h"
+#include "linux/regulator/machine.h"
+
+struct sky81452_platform_data {
+	struct sky81452_bl_platform_data *bl_pdata;
+	struct regulator_init_data *regulator_init_data;
+};
+
+#endif
-- 
1.9.1

