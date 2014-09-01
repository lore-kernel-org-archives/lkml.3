Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaIAJri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:47:38 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:39056 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752726AbaIAJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:47:37 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <f6daa0779c7efdac93e86d23147474ee>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v7 5/5] regulator: RK808: Remove pdata from the regulator
Date: Mon,  1 Sep 2014 17:47:15 +0800
Message-Id: <1409564835-18522-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

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

 drivers/regulator/rk808-regulator.c |   52 ++++++++++++++---------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 0d11df1..4d543a9 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -3,9 +3,6 @@
  *
  * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
  *
- * Author: Chris Zhong <zyw@rock-chips.com>
- * Author: Zhang Qing <zhangqing@rock-chips.com>
- *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
@@ -14,28 +11,25 @@
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
 
+struct rk808_regulator {
+	struct regulator_init_data *rk808_init_data[RK808_NUM_REGULATORS];
+	struct device_node *of_node[RK808_NUM_REGULATORS];
+};
+
 static const int buck_set_vol_base_addr[] = {
 	RK808_BUCK1_ON_VSEL_REG,
 	RK808_BUCK2_ON_VSEL_REG,
@@ -50,10 +44,6 @@ static const int buck_contr_base_addr[] = {
 	RK808_BUCK4_CONFIG_REG,
 };
 
-#define rk808_BUCK_SET_VOL_REG(x) (buck_set_vol_base_addr[x])
-#define rk808_BUCK_CONTR_REG(x) (buck_contr_base_addr[x])
-#define rk808_LDO_SET_VOL_REG(x) (ldo_set_vol_base_addr[x])
-
 static const int ldo_set_vol_base_addr[] = {
 	RK808_LDO1_ON_VSEL_REG,
 	RK808_LDO2_ON_VSEL_REG,
@@ -65,9 +55,7 @@ static const int ldo_set_vol_base_addr[] = {
 	RK808_LDO8_ON_VSEL_REG,
 };
 
-/*
- * rk808 voltage number
- */
+/* rk808 voltage number */
 static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
 };
@@ -295,7 +283,7 @@ static struct of_regulator_match rk808_reg_matches[] = {
 };
 
 static int rk808_regulator_dts(struct i2c_client *client,
-			       struct rk808_board *pdata)
+			       struct rk808_regulator *rk808_regulator)
 {
 	struct device_node *np, *reg_np;
 	int i, ret;
@@ -323,8 +311,9 @@ static int rk808_regulator_dts(struct i2c_client *client,
 		    !rk808_reg_matches[i].of_node)
 			continue;
 
-		pdata->rk808_init_data[i] = rk808_reg_matches[i].init_data;
-		pdata->of_node[i] = rk808_reg_matches[i].of_node;
+		rk808_regulator->rk808_init_data[i] =
+				rk808_reg_matches[i].init_data;
+		rk808_regulator->of_node[i] = rk808_reg_matches[i].of_node;
 	}
 
 	return 0;
@@ -334,26 +323,25 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
 	struct i2c_client *client = rk808->i2c;
-	struct rk808_board *pdata = dev_get_platdata(&client->dev);
+	struct rk808_regulator *rk808_regulator;
 	struct regulator_config config = {};
 	struct regulator_dev *rk808_rdev;
 	struct regulator_init_data *reg_data;
 	int i = 0;
 	int ret = 0;
 
-	if (!pdata) {
-		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-	}
+	rk808_regulator = devm_kzalloc(&pdev->dev, sizeof(*rk808_regulator),
+				       GFP_KERNEL);
+	if (!rk808_regulator)
+		return -ENOMEM;
 
-	ret = rk808_regulator_dts(client, pdata);
+	ret = rk808_regulator_dts(client, rk808_regulator);
 	if (ret)
 		return ret;
 
 	/* Instantiate the regulators */
 	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
-		reg_data = pdata->rk808_init_data[i];
+		reg_data = rk808_regulator->rk808_init_data[i];
 		if (!reg_data)
 			continue;
 
@@ -362,7 +350,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		config.regmap = rk808->regmap;
 
 		if (client->dev.of_node)
-			config.of_node = pdata->of_node[i];
+			config.of_node = rk808_regulator->of_node[i];
 
 		reg_data->supply_regulator = rk808_reg[i].name;
 		config.init_data = reg_data;
-- 
1.7.9.5

