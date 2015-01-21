Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbbAUCgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:36:21 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:44500 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062AbbAUCgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:36:17 -0500
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-3.tower-38.messagelabs.com!1421807771!21742479!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201501210235.t0L2ZnI7037875@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Wed, 21 Jan 2015 11:34:07 +0900
Subject: [PATCH V3] regulator: da9211: Add gpio control for enable/disable of
 buck
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for adding gpio control about enable/disable of buck.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20150120.

Changes in V3:
- align with next-20150120.
- remove warn message.

Changes in V2:
- gpio name from gpio to gpios.
- add ena_gpio_initialized.


 .../devicetree/bindings/regulator/da9211.txt       |    7 ++++++-
 drivers/regulator/da9211-regulator.c               |   12 ++++++++++++
 include/linux/regulator/da9211.h                   |    1 +
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/da9211.txt b/Documentation/devicetree/bindings/regulator/da9211.txt
index 240019a..a3b58e8 100644
--- a/Documentation/devicetree/bindings/regulator/da9211.txt
+++ b/Documentation/devicetree/bindings/regulator/da9211.txt
@@ -11,6 +11,7 @@ Required properties:
   BUCKA and BUCKB.
 
 Optional properties:
+- buck-enable-platform-gpios: platform gpio for control of BUCKA/BUCKB.
 - Any optional property defined in regulator.txt
 
 Example 1) DA9211
@@ -27,6 +28,7 @@ Example 1) DA9211
 				regulator-max-microvolt = <1570000>;
 				regulator-min-microamp 	= <2000000>;
 				regulator-max-microamp 	= <5000000>;
+				buck-enable-platform-gpios = <&gpio 27 0>;
 			};
 			BUCKB {
 				regulator-name = "VBUCKB";
@@ -34,11 +36,12 @@ Example 1) DA9211
 				regulator-max-microvolt = <1570000>;
 				regulator-min-microamp 	= <2000000>;
 				regulator-max-microamp 	= <5000000>;
+				buck-enable-platform-gpios = <&gpio 17 0>;
 			};
 		};
 	};
 
-Example 2) DA92113
+Example 2) DA9213
 	pmic: da9213@68 {
 		compatible = "dlg,da9213";
 		reg = <0x68>;
@@ -51,6 +54,7 @@ Example 2) DA92113
 				regulator-max-microvolt = <1570000>;
 				regulator-min-microamp 	= <3000000>;
 				regulator-max-microamp 	= <6000000>;
+				buck-enable-platform-gpios = <&gpio 27 0>;
 			};
 			BUCKB {
 				regulator-name = "VBUCKB";
@@ -58,6 +62,7 @@ Example 2) DA92113
 				regulator-max-microvolt = <1570000>;
 				regulator-min-microamp 	= <3000000>;
 				regulator-max-microamp 	= <6000000>;
+				buck-enable-platform-gpios = <&gpio 17 0>;
 			};
 		};
 	};
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 8e6957c..08fb47f 100644
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
@@ -277,6 +278,9 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 
 		pdata->init_data[n] = da9211_matches[i].init_data;
 		pdata->reg_node[n] = da9211_matches[i].of_node;
+		pdata->gpio_ren[n] =
+			of_get_named_gpio(da9211_matches[i].of_node,
+				"buck-enable-platform-gpios", 0);
 		n++;
 	}
 
@@ -366,6 +370,14 @@ static int da9211_regulator_init(struct da9211 *chip)
 		config.regmap = chip->regmap;
 		config.of_node = chip->pdata->reg_node[i];
 
+		if (gpio_is_valid(chip->pdata->gpio_ren[i])) {
+			config.ena_gpio = chip->pdata->gpio_ren[i];
+			config.ena_gpio_initialized = true;
+		} else {
+			config.ena_gpio = -EINVAL;
+			config.ena_gpio_initialized = false;
+		}
+
 		chip->rdev[i] = devm_regulator_register(chip->dev,
 			&da9211_regulators[i], &config);
 		if (IS_ERR(chip->rdev[i])) {
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
index d1d9d38..5dd65ac 100644
--- a/include/linux/regulator/da9211.h
+++ b/include/linux/regulator/da9211.h
@@ -32,6 +32,7 @@ struct da9211_pdata {
 	 * 2 : 2 phase 2 buck
 	 */
 	int num_buck;
+	int gpio_ren[DA9211_MAX_REGULATORS];
 	struct device_node *reg_node[DA9211_MAX_REGULATORS];
 	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
 };
-- 
end-of-patch for regulator: da9211: Add gpio control for enable/disable of buck V3

