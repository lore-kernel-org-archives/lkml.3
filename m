Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3LQNXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:23:41 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25084 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3LQNXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:35 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-d0-52b05055fffc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/5] regulator: s5m8767: Do not use sec_reg* regmap helpers
Date: Tue, 17 Dec 2013 14:23:18 +0100
Message-id: <1387286601-21646-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7qhARuCDKYe57JouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLJY2LaExeLyrjlsFmuP
	3GW3WHr9IpPFhOlrWSwOrzjAZLHu5XQWi5N/ehktTnezWlxc8YXJ4tiMJYwOoh5r5q1h9Fjw
	+Qq7x+W+XiaPnbPusnusXP6FzWPTqk42j1erZ7J63Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJ
	Sc3JLEst0rdL4MqYvGQiW8Fqg4qD39eyNjC+UO9i5OSQEDCRWH59JhOELSZx4d56ti5GLg4h
	gaWMEqfePmCFcPqYJKZ2tbCDVLEJGEtsXr6EDcQWEbjGKnHmTGgXIwcHs0CMxIspdiBhYQFv
	iVeHPrCChFkEVCWublYGCfMKuEt8+D+NCSQsIaAgMWeSDUiYU8BD4tPSEywgYSGgku3zqiYw
	8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIPX3YwLj5mdYhRgINRiYd3x/z1QUKs
	iWXFlbmHGCU4mJVEeL95bAgS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJi5O0bvr+u/vKNCqx/K
	KH1N5vo5K33hz0Vm2ufYuG8aqltK/VSezC/wsKwiZkdIz9oM+SvqKj8c/aMM7l3ZuqO+xs+V
	LyhDy3/L3tCN775YcTXN7vIUidJglDK0Cpu5jTvOxl5P71r5uv8b9y5mPe5X+zWR/evzE7s7
	/seu7phsGJjndPS+jxJLcUaioRZzUXEiAJVDKuRlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls to sec_reg* helpers with direct usage of regmap API. The
sec_reg* helpers are error-prone as they mix u8 with unsigned int and
order of some of parameters (val and mask in sec_reg_update()).

Also the helpers do not give any way of useful abstraction as they just
call corresponding regmap function.

This patch replaces:
 - sec_reg_read() with regmap_read(),
 - sec_reg_write() with regmap_write(),
 - sec_reg_update() with regmap_update_bits().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/s5m8767.c |   71 +++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 10b4b6a5b08e..d7164bb75d3e 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -23,6 +23,7 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/regmap.h>
 
 #define S5M8767_OPMODE_NORMAL_MODE 0x1
 
@@ -226,7 +227,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	else if (ret)
 		return ret;
 
-	ret = sec_reg_read(s5m8767->iodev, reg, &val);
+	ret = regmap_read(s5m8767->iodev->regmap_pmic, reg, &val);
 	if (ret)
 		return ret;
 
@@ -243,21 +244,21 @@ static int s5m8767_reg_enable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl,
-			S5M8767_ENCTRL_MASK);
+	return regmap_update_bits(s5m8767->iodev->regmap_pmic, reg,
+			S5M8767_ENCTRL_MASK, enable_ctrl);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int ret, reg;
-	int mask = S5M8767_ENCTRL_MASK, enable_ctrl;
+	int ret, reg, enable_ctrl;
 
 	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret)
 		return ret;
 
-	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
+	return regmap_update_bits(s5m8767->iodev->regmap_pmic, reg,
+			S5M8767_ENCTRL_MASK, ~S5M8767_ENCTRL_MASK);
 }
 
 static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
@@ -749,17 +750,20 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
 						   pdata->buck2_init);
 
-	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
+	regmap_write(s5m8767->iodev->regmap_pmic, S5M8767_REG_BUCK2DVS2,
+			buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
 						   pdata->buck3_init);
 
-	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
+	regmap_write(s5m8767->iodev->regmap_pmic, S5M8767_REG_BUCK3DVS2,
+			buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
 						   pdata->buck4_init);
 
-	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
+	regmap_write(s5m8767->iodev->regmap_pmic, S5M8767_REG_BUCK4DVS2,
+			buck_init);
 
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
@@ -841,43 +845,49 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
 	   pdata->buck4_gpiodvs) {
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
-				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
-				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
-				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_BUCK2CTRL, 1 << 1,
+				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1));
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_BUCK3CTRL, 1 << 1,
+				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1));
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_BUCK4CTRL, 1 << 1,
+				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1));
 	}
 
 	/* Initialize GPIO DVS registers */
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
-			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS1 + i,
-					   s5m8767->buck2_vol[i]);
+			regmap_write(s5m8767->iodev->regmap_pmic,
+					S5M8767_REG_BUCK2DVS1 + i,
+					s5m8767->buck2_vol[i]);
 		}
 
 		if (s5m8767->buck3_gpiodvs) {
-			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS1 + i,
-					   s5m8767->buck3_vol[i]);
+			regmap_write(s5m8767->iodev->regmap_pmic,
+					S5M8767_REG_BUCK3DVS1 + i,
+					s5m8767->buck3_vol[i]);
 		}
 
 		if (s5m8767->buck4_gpiodvs) {
-			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS1 + i,
-					   s5m8767->buck4_vol[i]);
+			regmap_write(s5m8767->iodev->regmap_pmic,
+					S5M8767_REG_BUCK4DVS1 + i,
+					s5m8767->buck4_vol[i]);
 		}
 	}
 
 	if (s5m8767->buck2_ramp)
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_DVSRAMP, 0x08, 0x08);
 
 	if (s5m8767->buck3_ramp)
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_DVSRAMP, 0x04, 0x04);
 
 	if (s5m8767->buck4_ramp)
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+				S5M8767_REG_DVSRAMP, 0x02, 0x02);
 
 	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
 		|| s5m8767->buck4_ramp) {
@@ -901,9 +911,10 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		default:
 			val = S5M8767_DVS_BUCK_RAMP_10;
 		}
-		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					val << S5M8767_DVS_BUCK_RAMP_SHIFT,
-					S5M8767_DVS_BUCK_RAMP_MASK);
+		regmap_update_bits(s5m8767->iodev->regmap_pmic,
+					S5M8767_REG_DVSRAMP,
+					S5M8767_DVS_BUCK_RAMP_MASK,
+					val << S5M8767_DVS_BUCK_RAMP_SHIFT);
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
-- 
1.7.9.5

