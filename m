Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaIJBSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:18:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61093 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaIJBSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:18:53 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v10 3/3] regulator: RK808: Remove pdata from the regulator
Date: Wed, 10 Sep 2014 09:18:06 +0800
Message-Id: <1410311886-4579-4-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
References: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

Tested-by: Heiko Stuebner <heiko@sntech.de>
---

Changes in v10: None
Changes in v9:
Adviced by Doug
- add reg_np

Changes in v8:
Adviced by Doug
- remove rk808_regulator_dts() function
- remove the check about "client->dev.of_node"

Changes in v7:
- remove pdata struct from header file, add rk808_regulator struct

Changes in v6:
- remove the redundant code

Changes in v5:
- re-edit base on Mark's branch

Changes in v4:
- use &client->dev replace rk808->dev

Changes in v3: None
Changes in v2:
Adviced by Mark Browm:
- change of_find_node_by_name to find_child_by_name
- use RK808_NUM_REGULATORS as the name of the constant
- create a pdata when missing platform data
- use the rk808_reg name to supply_regulator name
- replace regulator_register with devm_regulator_register
- some other problem with coding style

 drivers/regulator/rk808-regulator.c |   89 +++++++----------------------------
 1 file changed, 17 insertions(+), 72 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index e372008..d91f2b6 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -14,24 +14,16 @@
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
- *
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
-#include <linux/err.h>
-#include <linux/platform_device.h>
 #include <linux/mfd/rk808.h>
-#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/regmap.h>
-#include <linux/slab.h>
-/*
- * Field Definitions.
- */
+
+/* Field Definitions */
 #define RK808_BUCK_VSEL_MASK	0x3f
 #define RK808_BUCK4_VSEL_MASK	0xf
 #define RK808_LDO_VSEL_MASK	0x1f
@@ -50,10 +42,6 @@ static const int buck_contr_base_addr[] = {
 	RK808_BUCK4_CONFIG_REG,
 };
 
-#define rk808_BUCK_SET_VOL_REG(x) (buck_set_vol_base_addr[x])
-#define rk808_BUCK_CONTR_REG(x) (buck_contr_base_addr[x])
-#define rk808_LDO_SET_VOL_REG(x) (ldo_set_vol_base_addr[x])
-
 static const int ldo_set_vol_base_addr[] = {
 	RK808_LDO1_ON_VSEL_REG,
 	RK808_LDO2_ON_VSEL_REG,
@@ -65,9 +53,7 @@ static const int ldo_set_vol_base_addr[] = {
 	RK808_LDO8_ON_VSEL_REG,
 };
 
-/*
- * rk808 voltage number
- */
+/* rk808 voltage number */
 static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
 };
@@ -308,77 +294,35 @@ static struct of_regulator_match rk808_reg_matches[] = {
 	[RK808_ID_SWITCH2]	= { .name = "SWITCH_REG2" },
 };
 
-static int rk808_regulator_dts(struct i2c_client *client,
-			       struct rk808_board *pdata)
-{
-	struct device_node *np, *reg_np;
-	int i, ret;
-
-	np = client->dev.of_node;
-	if (!np) {
-		dev_err(&client->dev, "could not find pmic sub-node\n");
-		return -ENXIO;
-	}
-
-	reg_np = of_get_child_by_name(np, "regulators");
-	if (!reg_np)
-		return -ENXIO;
-
-	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
-				 RK808_NUM_REGULATORS);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"failed to parse regulator data: %d\n", ret);
-		return ret;
-	}
-
-	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
-		if (!rk808_reg_matches[i].init_data ||
-		    !rk808_reg_matches[i].of_node)
-			continue;
-
-		pdata->rk808_init_data[i] = rk808_reg_matches[i].init_data;
-		pdata->of_node[i] = rk808_reg_matches[i].of_node;
-	}
-
-	return 0;
-}
-
 static int rk808_regulator_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
 	struct i2c_client *client = rk808->i2c;
-	struct rk808_board *pdata = dev_get_platdata(&client->dev);
+	struct device_node *reg_np;
 	struct regulator_config config = {};
 	struct regulator_dev *rk808_rdev;
-	struct regulator_init_data *reg_data;
-	int i = 0;
-	int ret = 0;
+	int ret, i;
 
-	if (!pdata) {
-		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-	}
+	reg_np = of_get_child_by_name(client->dev.of_node, "regulators");
+	if (!reg_np)
+		return -ENXIO;
 
-	ret = rk808_regulator_dts(client, pdata);
-	if (ret)
+	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
+				 RK808_NUM_REGULATORS);
+	if (ret < 0)
 		return ret;
 
 	/* Instantiate the regulators */
 	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
-		reg_data = pdata->rk808_init_data[i];
-		if (!reg_data)
+		if (!rk808_reg_matches[i].init_data ||
+		    !rk808_reg_matches[i].of_node)
 			continue;
 
 		config.dev = &client->dev;
 		config.driver_data = rk808;
 		config.regmap = rk808->regmap;
-
-		if (client->dev.of_node)
-			config.of_node = pdata->of_node[i];
-
-		config.init_data = reg_data;
+		config.of_node = rk808_reg_matches[i].of_node;
+		config.init_data = rk808_reg_matches[i].init_data;
 
 		rk808_rdev = devm_regulator_register(&pdev->dev,
 						     &rk808_reg[i], &config);
@@ -388,6 +332,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 			return PTR_ERR(rk808_rdev);
 		}
 	}
+
 	return 0;
 }
 
@@ -403,6 +348,6 @@ module_platform_driver(rk808_regulator_driver);
 
 MODULE_DESCRIPTION("regulator driver for the rk808 series PMICs");
 MODULE_AUTHOR("Chris Zhong<zyw@rock-chips.com>");
-MODULE_AUTHOR("Zhang Qing<zhanqging@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing<zhangqing@rock-chips.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:rk808-regulator");
-- 
1.7.9.5

