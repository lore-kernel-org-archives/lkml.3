Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbbAOBl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:41:58 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:28037 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbbAOBl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:41:57 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 20:41:56 EST
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-4.tower-180.messagelabs.com!1421285717!41073714!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201501150135.t0F1Z6UD032294@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Thu, 15 Jan 2015 10:29:08 +0900
Subject: [PATCH V1] regulator: da9211: fix unmatched of_node and add gpio
 control
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for fixing unmatched of_node and adding gpio control.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20150113.

Changes in V1:
- fix unmatched of_node.
- add gpio control for buck eanble/disable.

 .../devicetree/bindings/regulator/da9211.txt       |   24 +++++++++-
 drivers/regulator/da9211-regulator.c               |   49 ++++++++++++++++++--
 drivers/regulator/da9211-regulator.h               |    1 +
 include/linux/regulator/da9211.h                   |    9 ++++
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/da9211.txt b/Documentation/devicetree/bindings/regulator/da9211.txt
index 240019a..b53a246 100644
--- a/Documentation/devicetree/bindings/regulator/da9211.txt
+++ b/Documentation/devicetree/bindings/regulator/da9211.txt
@@ -11,6 +11,12 @@ Required properties:
   BUCKA and BUCKB.
 
 Optional properties:
+- bucka-uses-gpio: BUCKA can be controlled by gpio.
+- bucka-enable-platform-gpio: platform gpio for control of BUCKA.
+- bucka-enable-init-state: initial state of gpio for BUCKA
+- buckb-uses-gpio: BUCKB can be controlled by gpio.
+- buckb-enable-platform-gpio: platform gpio for control of BUCKB.
+- buckb-enable-init-state: initial state of gpio for BUCKB
 - Any optional property defined in regulator.txt
 
 Example 1) DA9211
@@ -20,6 +26,14 @@ Example 1) DA9211
 		reg = <0x68>;
 		interrupts = <3 27>;
 
+		bucka-uses-gpio;
+		bucka-enable-platform-gpio = <&gpio 27 0>;
+		bucka-enable-init-state = <0>;
+
+		buckb-uses-gpio;
+		buckb-enable-platform-gpio = <&gpio 17 0>;
+		buckb-enable-init-state = <0>;
+
 		regulators {
 			BUCKA {
 				regulator-name = "VBUCKA";
@@ -38,12 +52,20 @@ Example 1) DA9211
 		};
 	};
 
-Example 2) DA92113
+Example 2) DA9213
 	pmic: da9213@68 {
 		compatible = "dlg,da9213";
 		reg = <0x68>;
 		interrupts = <3 27>;
 
+		bucka-uses-gpio;
+		bucka-enable-platform-gpio = <&gpio 27 0>;
+		bucka-enable-init-state = <0>;
+
+		buckb-uses-gpio;
+		buckb-enable-platform-gpio = <&gpio 17 0>;
+		buckb-enable-init-state = <0>;
+
 		regulators {
 			BUCKA {
 				regulator-name = "VBUCKA";
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index c78d210..2d9a38a 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/regmap.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/da9211.h>
 #include "da9211-regulator.h"
@@ -248,7 +249,7 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 {
 	struct da9211_pdata *pdata;
 	struct device_node *node;
-	int i, num, n;
+	int i, num, n, gpio;
 
 	node = of_get_child_by_name(dev->of_node, "regulators");
 	if (!node) {
@@ -276,10 +277,42 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 			continue;
 
 		pdata->init_data[n] = da9211_matches[i].init_data;
-
+		pdata->reg_node[n] = da9211_matches[i].of_node;
 		n++;
 	}
 
+	if (of_get_property(dev->of_node, "bucka-uses-gpio", NULL)) {
+		gpio = of_get_named_gpio(dev->of_node,
+					"bucka-enable-platform-gpio", 0);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(dev, "invalid gpio: %d\n", gpio);
+			return ERR_PTR(-EINVAL);
+		}
+		pdata->buck_data[0].gpio_ren = gpio;
+
+		if (of_property_read_u32(dev->of_node,
+				"bucka-enable-init-state",
+				&pdata->buck_data[0].ena_init_state)) {
+			pdata->buck_data[0].ena_init_state = 0;
+		}
+	}
+
+	if (of_get_property(dev->of_node, "buckb-uses-gpio", NULL)) {
+		gpio = of_get_named_gpio(dev->of_node,
+					"buckb-enable-platform-gpio", 0);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(dev, "invalid gpio: %d\n", gpio);
+			return ERR_PTR(-EINVAL);
+		}
+		pdata->buck_data[1].gpio_ren = gpio;
+
+		if (of_property_read_u32(dev->of_node,
+				"buckb-enable-init-state",
+				&pdata->buck_data[1].ena_init_state)) {
+			pdata->buck_data[1].ena_init_state = 0;
+		}
+	}
+
 	return pdata;
 }
 #else
@@ -364,7 +397,17 @@ static int da9211_regulator_init(struct da9211 *chip)
 		config.dev = chip->dev;
 		config.driver_data = chip;
 		config.regmap = chip->regmap;
-		config.of_node = chip->dev->of_node;
+		config.of_node = chip->pdata->reg_node[i];
+
+		if (chip->pdata->buck_data[i].gpio_ren) {
+			config.ena_gpio = chip->pdata->buck_data[i].gpio_ren;
+
+			if (chip->pdata->buck_data[i].ena_init_state == 0)
+				config.ena_gpio_flags = GPIOF_OUT_INIT_LOW;
+			else
+				config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+				config.ena_gpio_invert = 0;
+		}
 
 		chip->rdev[i] = devm_regulator_register(chip->dev,
 			&da9211_regulators[i], &config);
diff --git a/drivers/regulator/da9211-regulator.h b/drivers/regulator/da9211-regulator.h
index 93fa9df..2a88190 100644
--- a/drivers/regulator/da9211-regulator.h
+++ b/drivers/regulator/da9211-regulator.h
@@ -182,6 +182,7 @@
 #define	DA9211_BUCKA_GPI_GPIO3		0x06
 #define	DA9211_BUCKA_PD_DIS			0x08
 #define	DA9211_VBUCKA_SEL			0x10
+#define	DA9211_VBUCKA_SEL_MASK		0x10
 #define	DA9211_VBUCKA_SEL_A			0x00
 #define	DA9211_VBUCKA_SEL_B			0x10
 #define	DA9211_VBUCKA_GPI_SHIFT		5
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
index 5479394..8748423 100644
--- a/include/linux/regulator/da9211.h
+++ b/include/linux/regulator/da9211.h
@@ -25,6 +25,13 @@ enum da9211_chip_id {
 	DA9213,
 };
 
+struct da9211_buck_data {
+	/* gpio of platform for buck eanble/disable */
+	int gpio_ren;
+	/* init state of gpio_ren */
+	int ena_init_state;
+};
+
 struct da9211_pdata {
 	/*
 	 * Number of buck
@@ -32,6 +39,8 @@ struct da9211_pdata {
 	 * 2 : 2 phase 2 buck
 	 */
 	int num_buck;
+	struct da9211_buck_data buck_data[DA9211_MAX_REGULATORS];
+	struct device_node *reg_node[DA9211_MAX_REGULATORS];
 	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
 };
 #endif
-- 
end-of-patch for regulator: da9211: fix unmatched of_node and add gpio control V1

