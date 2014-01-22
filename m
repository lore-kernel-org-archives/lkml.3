Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaAVQIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:08:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17293 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaAVQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:08:03 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c5-52dfece24135
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 1/2] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
Date: Wed, 22 Jan 2014 17:07:27 +0100
Message-id: <1390406848-20964-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390406848-20964-1-git-send-email-k.kozlowski@samsung.com>
References: <1390406848-20964-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7qP3twPMtj/SNyi4WqIxcYZ61kt
	pj58wmYx/8g5Vov+NwtZLQ782cFoce7VSkaL1y8MLc42vWG3uP/1KKPFtysdTBYL25awWFze
	NYfNYsb5fUwWa4/cZbdYev0ik8WE6WtZLNa9nM5i0br3CLvFyT+9jBanu1ktLq74wuQg5rFm
	3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHq9Wz2T1uHNtD5vHvJOBHn1bVjF6fN4kF8AVxWWT
	kpqTWZZapG+XwJWx9tRcloLtRhVrbnWwNTDO0uxi5OSQEDCRmHHzGSuELSZx4d56ti5GLg4h
	gaWMEr3f17BAOH1MEkd2HWEDqWITMJbYvHwJWJWIwHRWib4/29hBHGaBo4wS21tfsIBUCQv4
	SxyeMRmsg0VAVWLfyjlgNq+Au8Tjvi/MXYwcQPsUJOZMsgEJcwp4SGx5ehusVQio5OncuywT
	GHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJjK87GJceszrEKMDBqMTDG7DrXpAQ
	a2JZcWXuIUYJDmYlEV6W5/eDhHhTEiurUovy44tKc1KLDzEycXBKNTCW7bdtf1G18XTJ1G5z
	8XzdNVc9Z/bLsW7a6HbzyxK2xd8ae9x0I+O/ND4/1LF4kfG6c5sTJeYozr33uvh1c8/3HeZp
	+5fd4uyTe3aI9feUm1MPzunMUOt67CPNKh92r+my0csl6ca7j9/jLTBW6D47PX9ijl31qjxr
	kV6VLkvX2UruvDWP+KOUWIozEg21mIuKEwGhOtEragIAAA==
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
 drivers/regulator/s5m8767.c         |  101 +++++++++++++++++++++++++++++++++--
 include/linux/mfd/samsung/core.h    |    4 +-
 include/linux/mfd/samsung/s5m8767.h |    7 +++
 3 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d7164bb75d3e..95c28b04dcc9 100644
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
@@ -520,6 +576,24 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
+static int s5m8767_pmic_dt_parse_ext_control_gpio(struct sec_pmic_dev *iodev,
+		struct sec_regulator_data *rdata,
+		struct device_node *reg_np)
+{
+	if (of_get_property(reg_np, "s5m8767,pmic-ext-control-enable", NULL)) {
+		int gpio = of_get_named_gpio(reg_np,
+					"s5m8767,pmic-ext-control-gpio", 0);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(iodev->dev, "invalid %s gpio: %d\n",
+					reg_np->name, gpio);
+			return -EINVAL;
+		}
+		rdata->ext_control_enable = true;
+		rdata->ext_control_gpio = gpio;
+	}
+	return 0;
+}
+
 static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
@@ -574,6 +648,14 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			continue;
 		}
 
+		if (s5m8767_pmic_dt_parse_ext_control_gpio(iodev, rdata,
+					reg_np)) {
+			dev_warn(iodev->dev,
+				"wrong configuration for regulator %s, skipping\n",
+				reg_np->name);
+			continue;
+		}
+
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
 						&pdev->dev, reg_np);
@@ -940,6 +1022,9 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.driver_data = s5m8767;
 		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
+		if (pdata->regulators[i].ext_control_enable)
+			s5m8767_regulator_config_ext_control(s5m8767,
+					&pdata->regulators[i], &config);
 
 		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
 						  &config);
@@ -949,6 +1034,16 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 					id);
 			return ret;
 		}
+
+		if (pdata->regulators[i].ext_control_enable) {
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
index 41c9bde410c5..867f2036ce17 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -119,7 +119,9 @@ struct sec_platform_data {
 struct sec_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
-	struct device_node *reg_node;
+	struct device_node		*reg_node;
+	int				ext_control_gpio;
+	bool				ext_control_enable;
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

