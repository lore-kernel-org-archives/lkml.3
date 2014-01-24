Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaAXNiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:38:23 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44141 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaAXNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:38:20 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e2-52e26cc942e4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v3 1/2] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
Date: Fri, 24 Jan 2014 14:37:57 +0100
Message-id: <1390570678-30686-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7oncx4FGWy8rW2xccZ6VoupD5+w
	Wcw/co7V4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CxmnN/HZLH2yF12i5N/ehktTnezWlxc
	8YXJgddj56y77B6bVnWyedy5tofNY97JQI++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKeHR7
	NWPBNv2KN3+yGxh/q3UxcnJICJhIXFp0kxnCFpO4cG89WxcjF4eQwFJGiUlzTjNBOH1MEjf2
	tzCCVLEJGEtsXr4ErEpE4CCTxNHvPWAOs8BRRontrS9Yuhg5OIQF/CX2ntYDaWARUJWYdqSF
	BcTmFXCXOPxnEitIiYSAgsScSTYgJqeAh8SVWzIgFUJAFdPeXmeewMi7gJFhFaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZISH7Zwbj4mNUhRgEORiUe3hmBD4OEWBPLiitzDzFKcDArifBu
	DXgUJMSbklhZlVqUH19UmpNafIiRiYNTqoFx6zaRAr86l5xg2xdac85/OFCw5NyHryekXO6e
	CJtgdvPfYuu1V8oFLbS8rnDsjz8W4+e7T2cGuwJ/YKpd3OuC3Z1dOs5Jnl+eXNyc52r/75DD
	nC/zo6rudH6Nml++qqgpKfZ/CpPjhCS7ea1vZjodmf+7vtRkc7o5y78aBpnNk393R6x7mMSt
	xFKckWioxVxUnAgAtCXuaycCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for GPIO control (enable/disable) over Buck9. The Buck9
Converter is used as a supply for eMMC Host Controller.

BUCK9EN GPIO of S5M8767 chip may be used by application processor to
enable or disable the Buck9. This has two benefits:
 - It is faster than toggling it over I2C bus.
 - It allows disabling the regulator during suspend to RAM; The AP will
   enable it during resume; Without the patch the regulator supplying
   eMMC must be defined as fixed-regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/regulator/s5m8767.c         |   87 +++++++++++++++++++++++++++++++++--
 include/linux/mfd/samsung/core.h    |    3 +-
 include/linux/mfd/samsung/s5m8767.h |    7 +++
 3 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d7164bb75d3e..6850a25a41c4 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -11,11 +11,8 @@
  *
  */
 
-#include <linux/bug.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/of_gpio.h>
-#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
@@ -483,6 +480,65 @@ static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(BUCK9),
 };
 
+/*
+ * Enable GPIO control over BUCK9 in regulator_config for that regulator.
+ */
+static void s5m8767_regulator_config_ext_control(struct s5m8767_info *s5m8767,
+		struct sec_regulator_data *rdata,
+		struct regulator_config *config)
+{
+	int i, mode = 0;
+
+	if (rdata->id != S5M8767_BUCK9)
+		return;
+
+	/* Check if opmode for regulator matches S5M8767_ENCTRL_USE_GPIO */
+	for (i = 0; i < s5m8767->num_regulators; i++) {
+		const struct sec_opmode_data *opmode = &s5m8767->opmode[i];
+		if (opmode->id == rdata->id) {
+			mode = s5m8767_opmode_reg[rdata->id][opmode->mode];
+			break;
+		}
+	}
+	if (mode != S5M8767_ENCTRL_USE_GPIO) {
+		dev_warn(s5m8767->dev,
+				"ext-control for %s: mismatched op_mode (%x), ignoring\n",
+				rdata->reg_node->name, mode);
+		return;
+	}
+
+	if (!gpio_is_valid(rdata->ext_control_gpio)) {
+		dev_warn(s5m8767->dev,
+				"ext-control for %s: GPIO not valid, ignoring\n",
+				rdata->reg_node->name);
+		return;
+	}
+
+	config->ena_gpio = rdata->ext_control_gpio;
+	config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+}
+
+/*
+ * Turn on GPIO control over BUCK9.
+ */
+static int s5m8767_enable_ext_control(struct s5m8767_info *s5m8767,
+		struct regulator_dev *rdev)
+{
+	int ret, reg, enable_ctrl;
+
+	if (rdev_get_id(rdev) != S5M8767_BUCK9)
+		return -EINVAL;
+
+	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
+	if (ret)
+		return ret;
+
+	return regmap_update_bits(s5m8767->iodev->regmap_pmic,
+			reg, S5M8767_ENCTRL_MASK,
+			S5M8767_ENCTRL_USE_GPIO << S5M8767_ENCTRL_SHIFT);
+}
+
+
 #ifdef CONFIG_OF
 static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
 			struct sec_platform_data *pdata,
@@ -520,6 +576,16 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
+static void s5m8767_pmic_dt_parse_ext_control_gpio(struct sec_pmic_dev *iodev,
+		struct sec_regulator_data *rdata,
+		struct device_node *reg_np)
+{
+	rdata->ext_control_gpio = of_get_named_gpio(reg_np,
+			"s5m8767,pmic-ext-control-gpios", 0);
+	if (!gpio_is_valid(rdata->ext_control_gpio))
+		rdata->ext_control_gpio = 0;
+}
+
 static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
@@ -574,6 +640,8 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			continue;
 		}
 
+		s5m8767_pmic_dt_parse_ext_control_gpio(iodev, rdata, reg_np);
+
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
 						&pdev->dev, reg_np);
@@ -940,6 +1008,9 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.driver_data = s5m8767;
 		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
+		if (pdata->regulators[i].ext_control_gpio)
+			s5m8767_regulator_config_ext_control(s5m8767,
+					&pdata->regulators[i], &config);
 
 		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
 						  &config);
@@ -949,6 +1020,16 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 					id);
 			return ret;
 		}
+
+		if (pdata->regulators[i].ext_control_gpio) {
+			ret = s5m8767_enable_ext_control(s5m8767, rdev[i]);
+			if (ret < 0) {
+				dev_err(s5m8767->dev,
+						"failed to enable gpio control over %s: %d\n",
+						rdev[i]->desc->name, ret);
+				return ret;
+			}
+		}
 	}
 
 	return 0;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 41c9bde410c5..55510444b9fd 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -119,7 +119,8 @@ struct sec_platform_data {
 struct sec_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
-	struct device_node *reg_node;
+	struct device_node		*reg_node;
+	int				ext_control_gpio;
 };
 
 /*
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
index 2ab0b0f03641..243b58fec33d 100644
--- a/include/linux/mfd/samsung/s5m8767.h
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -183,10 +183,17 @@ enum s5m8767_regulators {
 	S5M8767_REG_MAX,
 };
 
+/* LDO_EN/BUCK_EN field in registers */
 #define S5M8767_ENCTRL_SHIFT		6
 #define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
 
 /*
+ * LDO_EN/BUCK_EN register value for controlling this Buck or LDO
+ * by GPIO (PWREN, BUCKEN).
+ */
+#define S5M8767_ENCTRL_USE_GPIO		0x1
+
+/*
  * Values for BUCK_RAMP field in DVS_RAMP register, matching raw values
  * in mV/us.
  */
-- 
1.7.9.5

