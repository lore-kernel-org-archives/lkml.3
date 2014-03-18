Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaCRK6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:58:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbaCRK6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:58:01 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] regulator: arizona-micsupp: Add processing of init_data from device tree
Date: Tue, 18 Mar 2014 10:49:14 +0000
Message-Id: <1395139757-6907-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++-
 drivers/regulator/arizona-micsupp.c               |   47 +++++++++++++++++++--
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index d78f1aa..88c1c0f 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -44,9 +44,11 @@ Optional properties:
 
   - wlf,ldo1 : Initial data for the LDO1 regulator, as covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
+  - wlf,micvdd : Initial data for the MICVDD regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
 
-  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
-    externally supplied. As covered in
+  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
+    they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
 
 Example:
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 034ece7..1d5bd8d 100644
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
@@ -195,6 +196,44 @@ static const struct regulator_init_data arizona_micsupp_ext_default = {
 	.num_consumer_supplies = 1,
 };
 
+#ifdef CONFIG_OF
+static int arizona_micsupp_get_pdata(struct arizona *arizona,
+				     struct regulator_config *config)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_micsupp *micsupp = config->driver_data;
+	struct device_node *np_init, *np_micvdd;
+
+	np_init = of_get_child_by_name(arizona->dev->of_node, "wlf,micvdd");
+	np_micvdd = of_parse_phandle(arizona->dev->of_node, "MICVDD-supply", 0);
+
+	if (np_init) {
+		config->of_node = np_init;
+
+		pdata->micvdd = of_get_regulator_init_data(arizona->dev,
+							   np_init);
+
+		if (!np_micvdd) {
+			pdata->micvdd->consumer_supplies = &micsupp->supply;
+			pdata->micvdd->num_consumer_supplies = 1;
+		}
+
+		config->init_data = pdata->micvdd;
+	}
+
+	return 0;
+}
+#else
+static inline int arizona_micsupp_get_pdata(struct arizona *arizona,
+					    struct regulator_config *config)
+{
+	if (arizona->pdata.micvdd)
+		config->init_data = arizona->pdata.micvdd;
+
+	return 0;
+}
+#endif
+
 static int arizona_micsupp_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -235,11 +274,11 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	config.dev = arizona->dev;
 	config.driver_data = micsupp;
 	config.regmap = arizona->regmap;
+	config.init_data = &micsupp->init_data;
 
-	if (arizona->pdata.micvdd)
-		config.init_data = arizona->pdata.micvdd;
-	else
-		config.init_data = &micsupp->init_data;
+	ret = arizona_micsupp_get_pdata(arizona, &config);
+	if (ret < 0)
+		return ret;
 
 	/* Default to regulated mode until the API supports bypass */
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_CHARGE_PUMP_1,
-- 
1.7.2.5

