Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbaCSK1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:27:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46829 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933682AbaCSK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:27:39 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] regulator: arizona-micsupp: Add processing of init_data from device tree
Date: Wed, 19 Mar 2014 10:18:58 +0000
Message-Id: <1395224338-3709-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++-
 drivers/regulator/arizona-micsupp.c               |   50 +++++++++++++++++++++
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 9d54c70..9c685b2 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -44,9 +44,11 @@ Optional properties:
 
   - ldo1 : Initial data for the LDO1 regulator, as covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
+  - micvdd : Initial data for the MICVDD regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
 
-  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
-    externally supplied. As covered in
+  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
+    they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
 
 Example:
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 6fdd9bf..8b38f6b 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -195,6 +196,49 @@ static const struct regulator_init_data arizona_micsupp_ext_default = {
 	.num_consumer_supplies = 1,
 };
 
+#ifdef CONFIG_OF
+static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
+					struct regulator_config *config)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_micsupp *micsupp = config->driver_data;
+	struct device_node *np;
+	struct regulator_init_data *init_data;
+
+	np = of_get_child_by_name(arizona->dev->of_node, "micvdd");
+
+	if (np) {
+		config->of_node = np;
+
+		init_data = of_get_regulator_init_data(arizona->dev, np);
+
+		if (init_data) {
+			init_data->consumer_supplies = &micsupp->supply;
+			init_data->num_consumer_supplies = 1;
+
+			pdata->micvdd = init_data;
+		}
+	}
+
+	return 0;
+}
+
+static void arizona_micsupp_of_put_pdata(struct regulator_config *config)
+{
+	of_node_put(config->of_node);
+}
+#else
+static inline int arizona_micsupp_of_get_pdata(struct arizona *arizona,
+					       struct regulator_config *config)
+{
+	return 0;
+}
+
+static inline void arizona_micsupp_of_put_pdata(struct regulator_config *config)
+{
+}
+#endif
+
 static int arizona_micsupp_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -234,6 +278,10 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	config.driver_data = micsupp;
 	config.regmap = arizona->regmap;
 
+	ret = arizona_micsupp_of_get_pdata(arizona, &config);
+	if (ret < 0)
+		return ret;
+
 	if (arizona->pdata.micvdd)
 		config.init_data = arizona->pdata.micvdd;
 	else
@@ -253,6 +301,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	arizona_micsupp_of_put_pdata(&config);
+
 	platform_set_drvdata(pdev, micsupp);
 
 	return 0;
-- 
1.7.2.5

