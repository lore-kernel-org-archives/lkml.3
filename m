Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaCRRby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:31:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45317 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbaCRRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:31:12 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] regulator: arizona-ldo1: Add processing of init_data from device tree
Date: Tue, 18 Mar 2014 17:22:32 +0000
Message-Id: <1395163353-1608-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    7 +++
 drivers/regulator/arizona-ldo1.c                  |   46 +++++++++++++++++++-
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 36a0c3d..9d54c70 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,13 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - ldo1 : Initial data for the LDO1 regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
+  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
+    externally supplied. As covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
 Example:
 
 codec: wm5102@1a {
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 1b59060..f936ff3 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
@@ -179,19 +180,56 @@ static const struct regulator_init_data arizona_ldo1_default = {
 };
 
 #ifdef CONFIG_OF
-static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
+				     struct regulator_config *config)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_ldo1 *ldo1 = config->driver_data;
+	struct device_node *init_node, *dcvdd_node;
+	struct regulator_init_data *init_data;
 
 	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
 
+	init_node = of_get_child_by_name(arizona->dev->of_node, "ldo1");
+	dcvdd_node = of_parse_phandle(arizona->dev->of_node, "DCVDD-supply", 0);
+
+	if (init_node) {
+		config->of_node = init_node;
+
+		init_data = of_get_regulator_init_data(arizona->dev, init_node);
+
+		if (init_data) {
+			init_data->consumer_supplies = &ldo1->supply;
+			init_data->num_consumer_supplies = 1;
+
+			if (dcvdd_node && dcvdd_node != init_node)
+				arizona->external_dcvdd = true;
+
+			pdata->ldo1 = init_data;
+		}
+	} else if (dcvdd_node) {
+		arizona->external_dcvdd = true;
+	}
+
+	of_node_put(dcvdd_node);
+
 	return 0;
 }
+
+static void arizona_ldo1_of_put_pdata(struct regulator_config *config)
+{
+	of_node_put(config->of_node);
+}
 #else
-static inline int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+static inline int arizona_ldo1_of_get_pdata(struct arizona *arizona,
+					    struct regulator_config *config)
 {
 	return 0;
 }
+
+static inline void arizona_ldo1_of_put_pdata(struct regulator_config *config)
+{
+}
 #endif
 
 static int arizona_ldo1_probe(struct platform_device *pdev)
@@ -233,7 +271,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	config.driver_data = ldo1;
 	config.regmap = arizona->regmap;
 
-	ret = arizona_ldo1_of_get_pdata(arizona);
+	ret = arizona_ldo1_of_get_pdata(arizona, &config);
 	if (ret < 0)
 		return ret;
 
@@ -259,6 +297,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	arizona_ldo1_of_put_pdata(&config);
+
 	platform_set_drvdata(pdev, ldo1);
 
 	return 0;
-- 
1.7.2.5

