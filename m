Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaBFSG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:06:29 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:6513 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706AbaBFSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:06:22 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1391709809!22887069!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <9c9235270af15eb50bd2d5c20daa7a81858910a4.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:13 +0000
Subject: [PATCH v2 4/8] regulator: da9055: Add DT support
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/regulator/da9055-regulator.c |   69 ++++++++++++++++++++++++++++++++--
 1 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 7f34020..d90f785 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -19,6 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>

 #include <linux/mfd/da9055/core.h>
 #include <linux/mfd/da9055/reg.h>
@@ -446,6 +448,9 @@ static int da9055_gpio_init(struct da9055_regulator *regulator,
 	struct da9055_regulator_info *info = regulator->info;
 	int ret = 0;

+	if (!pdata)
+		return 0;
+
 	if (pdata->gpio_ren && pdata->gpio_ren[id]) {
 		char name[18];
 		int gpio_mux = pdata->gpio_ren[id];
@@ -530,6 +535,59 @@ static inline struct da9055_regulator_info *find_regulator_info(int id)
 	return NULL;
 }

+#ifdef CONFIG_OF
+static struct of_regulator_match da9055_reg_matches[] = {
+	{ .name = "BUCK1", },
+	{ .name = "BUCK2", },
+	{ .name = "LDO1", },
+	{ .name = "LDO2", },
+	{ .name = "LDO3", },
+	{ .name = "LDO4", },
+	{ .name = "LDO5", },
+	{ .name = "LDO6", },
+};
+
+static int da9055_regulator_dt_init(struct platform_device *pdev,
+				    struct da9055_regulator *regulator,
+				    struct regulator_config *config,
+				    int regid)
+{
+	struct device_node *nproot, *np;
+	int ret;
+
+	nproot = of_node_get(pdev->dev.parent->of_node);
+	if (!nproot)
+		return -ENODEV;
+
+	np = of_find_node_by_name(nproot, "regulators");
+	if (!np)
+		return -ENODEV;
+
+	ret = of_regulator_match(&pdev->dev, np, &da9055_reg_matches[regid], 1);
+	of_node_put(nproot);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Error matching regulator: %d\n", ret);
+		return -ENODEV;
+	}
+
+	config->init_data = da9055_reg_matches[regid].init_data;
+	config->of_node = da9055_reg_matches[regid].of_node;
+
+	if (!config->of_node)
+		return -ENODEV;
+
+	return 0;
+}
+#else
+static inline da9055_regulator_dt_init(struct platform_device *pdev,
+				       struct da9055_regulator *regulator,
+				       struct regulator_config *config,
+				       int regid)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_OF */
+
 static int da9055_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_config config = { };
@@ -538,9 +596,6 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	struct da9055_pdata *pdata = dev_get_platdata(da9055->dev);
 	int ret, irq;

-	if (pdata == NULL || pdata->regulators[pdev->id] == NULL)
-		return -ENODEV;
-
 	regulator = devm_kzalloc(&pdev->dev, sizeof(struct da9055_regulator),
 				 GFP_KERNEL);
 	if (!regulator)
@@ -557,8 +612,14 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	config.driver_data = regulator;
 	config.regmap = da9055->regmap;

-	if (pdata && pdata->regulators)
+	if (pdata && pdata->regulators) {
 		config.init_data = pdata->regulators[pdev->id];
+	} else {
+		ret = da9055_regulator_dt_init(pdev, regulator, &config,
+					       pdev->id);
+		if (ret < 0)
+			return ret;
+	}

 	ret = da9055_gpio_init(regulator, &config, pdata, pdev->id);
 	if (ret < 0)
--
1.7.0.4

