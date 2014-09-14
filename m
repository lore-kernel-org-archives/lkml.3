Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaINTWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:22:20 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39188 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaINTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:20:54 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5/5] regulator: fan53555: add support for Silergy SYR82x regulators
Date: Sun, 14 Sep 2014 21:23:05 +0200
Message-Id: <1410722585-13393-6-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410722585-13393-1-git-send-email-heiko@sntech.de>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silergy SYR82x regulators share the exact same functionality and register layout
as the Fairchild FAN53555 regulators. Therefore extend the driver to add
support for them.

Both types use the same vendor id in their ID1 register, so it's not possible
to distinguish them automatically.

Similarly, the types also do not match. Type 8 used by the SYR827 and SYR828
start at 712.5mV and increment in 12.5mv steps, while the FAN53555 type 8
starts at 600mV and increments in 10mV steps.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/regulator/fan53555.txt     |   2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/regulator/fan53555.c                       | 112 +++++++++++++++++----
 3 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/fan53555.txt b/Documentation/devicetree/bindings/regulator/fan53555.txt
index 2484497..b26f278 100644
--- a/Documentation/devicetree/bindings/regulator/fan53555.txt
+++ b/Documentation/devicetree/bindings/regulator/fan53555.txt
@@ -1,7 +1,7 @@
 Binding for Fairchild FAN53555 regulators
 
 Required properties:
-  - compatible: "fairchild,fan53555"
+  - compatible: one of "fairchild,fan53555", "silergy,syr827", "silergy,syr828"
   - reg: I2C address
 
 Optional properties:
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 99da41b..9e34820 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -125,6 +125,7 @@ sil	Silicon Image
 silabs	Silicon Laboratories
 simtek
 sii	Seiko Instruments, Inc.
+silergy	Silergy Corp.
 sirf	SiRF Technology, Inc.
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 0ec1762..89bfd0d 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -19,6 +19,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/of_device.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/regmap.h>
@@ -51,6 +52,11 @@
 
 #define FAN53555_NVOLTAGES	64	/* Numbers of voltages */
 
+enum fan53555_vendor {
+	FAN53555_VENDOR_FAIRCHILD = 0,
+	FAN53555_VENDOR_SILERGY,
+};
+
 /* IC Type */
 enum {
 	FAN53555_CHIP_ID_00 = 0,
@@ -61,7 +67,12 @@ enum {
 	FAN53555_CHIP_ID_05,
 };
 
+enum {
+	SILERGY_SYR82X = 8,
+};
+
 struct fan53555_device_info {
+	enum fan53555_vendor vendor;
 	struct regmap *regmap;
 	struct device *dev;
 	struct regulator_desc desc;
@@ -149,6 +160,47 @@ static struct regulator_ops fan53555_regulator_ops = {
 	.get_mode = fan53555_get_mode,
 };
 
+static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
+{
+	/* Init voltage range and step */
+	switch (di->chip_id) {
+	case FAN53555_CHIP_ID_00:
+	case FAN53555_CHIP_ID_01:
+	case FAN53555_CHIP_ID_03:
+	case FAN53555_CHIP_ID_05:
+		di->vsel_min = 600000;
+		di->vsel_step = 10000;
+		break;
+	case FAN53555_CHIP_ID_04:
+		di->vsel_min = 603000;
+		di->vsel_step = 12826;
+		break;
+	default:
+		dev_err(di->dev,
+			"Chip ID[%d]\n not supported!\n", di->chip_id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fan53555_voltages_setup_silergy(struct fan53555_device_info *di)
+{
+	/* Init voltage range and step */
+	switch (di->chip_id) {
+	case SILERGY_SYR82X:
+		di->vsel_min = 712500;
+		di->vsel_step = 12500;
+		break;
+	default:
+		dev_err(di->dev,
+			"Chip ID[%d]\n not supported!\n", di->chip_id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* For 00,01,03,05 options:
  * VOUT = 0.60V + NSELx * 10mV, from 0.60 to 1.23V.
  * For 04 option:
@@ -158,6 +210,7 @@ static int fan53555_device_setup(struct fan53555_device_info *di,
 				struct fan53555_platform_data *pdata)
 {
 	unsigned int reg, data, mask;
+	int ret = 0;
 
 	/* Setup voltage control register */
 	switch (pdata->sleep_vsel_id) {
@@ -173,24 +226,22 @@ static int fan53555_device_setup(struct fan53555_device_info *di,
 		dev_err(di->dev, "Invalid VSEL ID!\n");
 		return -EINVAL;
 	}
-	/* Init voltage range and step */
-	switch (di->chip_id) {
-	case FAN53555_CHIP_ID_00:
-	case FAN53555_CHIP_ID_01:
-	case FAN53555_CHIP_ID_03:
-	case FAN53555_CHIP_ID_05:
-		di->vsel_min = 600000;
-		di->vsel_step = 10000;
+
+	switch (di->vendor) {
+	case FAN53555_VENDOR_FAIRCHILD:
+		ret = fan53555_voltages_setup_fairchild(di);
 		break;
-	case FAN53555_CHIP_ID_04:
-		di->vsel_min = 603000;
-		di->vsel_step = 12826;
+	case FAN53555_VENDOR_SILERGY:
+		ret = fan53555_voltages_setup_silergy(di);
 		break;
 	default:
 		dev_err(di->dev,
-			"Chip ID[%d]\n not supported!\n", di->chip_id);
+			"vendor %d not supported!\n", di->chip_id);
 		return -EINVAL;
 	}
+	if (ret < 0)
+		return ret;
+
 	/* Init slew rate */
 	if (pdata->slew_rate & 0x7)
 		di->slew_rate = pdata->slew_rate;
@@ -272,6 +323,21 @@ static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
 	return pdata;
 }
 
+static const struct of_device_id fan53555_dt_ids[] = {
+	{
+		.compatible = "fairchild,fan53555",
+		.data = (void *)FAN53555_VENDOR_FAIRCHILD
+	}, {
+		.compatible = "silergy,syr827",
+		.data = (void *)FAN53555_VENDOR_SILERGY,
+	}, {
+		.compatible = "silergy,syr828",
+		.data = (void *)FAN53555_VENDOR_SILERGY,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, fan53555_dt_ids);
+
 static int fan53555_regulator_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -296,6 +362,19 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	if (!di)
 		return -ENOMEM;
 
+	if (client->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_device(of_match_ptr(fan53555_dt_ids),
+					&client->dev);
+		if (!match)
+			return -ENODEV;
+
+		di->vendor = (int) match->data;
+	} else {
+		di->vendor = id->driver_data;
+	}
+
 	di->regmap = devm_regmap_init_i2c(client, &fan53555_regmap_config);
 	if (IS_ERR(di->regmap)) {
 		dev_err(&client->dev, "Failed to allocate regmap!\n");
@@ -341,14 +420,9 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 
 }
 
-static const struct of_device_id fan53555_dt_ids[] = {
-	{ .compatible = "fairchild,fan53555" },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, fan53555_dt_ids);
-
 static const struct i2c_device_id fan53555_id[] = {
-	{"fan53555", -1},
+	{ .name = "fan53555", .driver_data = FAN53555_VENDOR_FAIRCHILD },
+	{ .name = "syr82x", .driver_data = FAN53555_VENDOR_SILERGY },
 	{ },
 };
 
-- 
2.0.1

