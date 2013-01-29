Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3A2JH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:07:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13901 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab3A2JHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:07:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 01:07:23 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/4] regulator: tps65090: add DT support
Date: Tue, 29 Jan 2013 14:35:16 +0530
Message-ID: <1359450318-24912-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
References: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support for TI PMIC tps65090 regulator driver. The DT of this
device have node regulator and all regulator's node of this device is
added under this node.

The device tree binding document has the required information for
adding this device on DTS file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Allocate pdata here.
- Changes to reflect the renames of the property as suggested by Stephen.
- Rebased the changes on 20130128.

 drivers/regulator/tps65090-regulator.c |  106 ++++++++++++++++++++++++++++++--
 1 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 41c3917..8687543 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -19,11 +19,13 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/tps65090.h>
 
 struct tps65090_regulator {
@@ -67,8 +69,8 @@ static struct regulator_desc tps65090_regulator_desc[] = {
 	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_reg_contol_ops),
 	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_reg_contol_ops),
 	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(LDO1,  "vsys_l1", 0,    tps65090_ldo_ops),
-	tps65090_REG_DESC(LDO2,  "vsys_l2", 0,    tps65090_ldo_ops),
+	tps65090_REG_DESC(LDO1,  "vsys-l1", 0,    tps65090_ldo_ops),
+	tps65090_REG_DESC(LDO2,  "vsys-l2", 0,    tps65090_ldo_ops),
 };
 
 static inline bool is_dcdc(int id)
@@ -138,6 +140,92 @@ static void tps65090_configure_regulator_config(
 	}
 }
 
+#ifdef CONFIG_OF
+static struct of_regulator_match tps65090_matches[] = {
+	{ .name = "dcdc1", },
+	{ .name = "dcdc2", },
+	{ .name = "dcdc3", },
+	{ .name = "fet1",  },
+	{ .name = "fet2",  },
+	{ .name = "fet3",  },
+	{ .name = "fet4",  },
+	{ .name = "fet5",  },
+	{ .name = "fet6",  },
+	{ .name = "fet7",  },
+	{ .name = "ldo1",  },
+	{ .name = "ldo2",  },
+};
+
+static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
+		struct platform_device *pdev,
+		struct of_regulator_match **tps65090_reg_matches)
+{
+	struct tps65090_platform_data *tps65090_pdata;
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *regulators;
+	int idx = 0, ret;
+	struct tps65090_regulator_plat_data *reg_pdata;
+
+	tps65090_pdata = devm_kzalloc(&pdev->dev, sizeof(*tps65090_pdata),
+				GFP_KERNEL);
+	if (!tps65090_pdata) {
+		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	reg_pdata = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX *
+				sizeof(*reg_pdata), GFP_KERNEL);
+	if (!reg_pdata) {
+		dev_err(&pdev->dev, "Memory alloc for reg_pdata failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	regulators = of_find_node_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	ret = of_regulator_match(pdev->dev.parent, regulators, tps65090_matches,
+			ARRAY_SIZE(tps65090_matches));
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Error parsing regulator init data: %d\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	*tps65090_reg_matches = tps65090_matches;
+	for (idx = 0; idx < ARRAY_SIZE(tps65090_matches); idx++) {
+		struct regulator_init_data *ri_data;
+		struct tps65090_regulator_plat_data *rpdata;
+
+		rpdata = &reg_pdata[idx];
+		ri_data = tps65090_matches[idx].init_data;
+		if (!ri_data || !tps65090_matches[idx].of_node)
+			continue;
+
+		rpdata->reg_init_data = ri_data;
+		rpdata->enable_ext_control = of_property_read_bool(
+					tps65090_matches[idx].of_node,
+					"ti,enable-ext-control");
+		if (rpdata->enable_ext_control)
+			rpdata->gpio = of_get_named_gpio(np,
+					"dcdc-ext-control-gpios", 0);
+
+		tps65090_pdata->reg_pdata[idx] = rpdata;
+	}
+	return tps65090_pdata;
+}
+#else
+static inline struct tps65090_platform_data *tps65090_parse_dt_reg_data(
+			struct platform_device *pdev,
+			struct of_regulator_match **tps65090_reg_matches)
+{
+	*tps65090_reg_matches = NULL;
+	return NULL;
+}
+#endif
+
 static int tps65090_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
@@ -147,15 +235,19 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 	struct tps65090_regulator_plat_data *tps_pdata;
 	struct tps65090_regulator *pmic;
 	struct tps65090_platform_data *tps65090_pdata;
+	struct of_regulator_match *tps65090_reg_matches = NULL;
 	int num;
 	int ret;
 
 	dev_dbg(&pdev->dev, "Probing regulator\n");
 
 	tps65090_pdata = dev_get_platdata(pdev->dev.parent);
-	if (!tps65090_pdata) {
+	if (!tps65090_pdata && tps65090_mfd->dev->of_node)
+		tps65090_pdata = tps65090_parse_dt_reg_data(pdev,
+					&tps65090_reg_matches);
+	if (IS_ERR_OR_NULL(tps65090_pdata)) {
 		dev_err(&pdev->dev, "Platform data missing\n");
-		return -EINVAL;
+		return tps65090_pdata ? PTR_ERR(tps65090_pdata) : -EINVAL;
 	}
 
 	pmic = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX * sizeof(*pmic),
@@ -192,13 +284,17 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 			}
 		}
 
-		config.dev = &pdev->dev;
+		config.dev = pdev->dev.parent;
 		config.driver_data = ri;
 		config.regmap = tps65090_mfd->rmap;
 		if (tps_pdata)
 			config.init_data = tps_pdata->reg_init_data;
 		else
 			config.init_data = NULL;
+		if (tps65090_reg_matches)
+			config.of_node = tps65090_reg_matches[num].of_node;
+		else
+			config.of_node = NULL;
 
 		rdev = regulator_register(ri->desc, &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.1.1

