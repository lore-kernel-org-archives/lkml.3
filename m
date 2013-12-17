Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3LQNZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:25:09 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24035 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3LQNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:37 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-12-52b0505624f5
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
Subject: [PATCH 4/5] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
Date: Tue, 17 Dec 2013 14:23:20 +0100
Message-id: <1387286601-21646-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7phARuCDGb9sLJouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLJY2LaExeLyrjlsFmuP
	3GW3WHr9IpPFhOlrWSwOrzjAZLHu5XQWi5N/ehktTnezWlxc8YXJ4tiMJYwOoh5r5q1h9Fjw
	+Qq7x+W+XiaPnbPusnusXP6FzWPTqk42j1erZ7J63Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJ
	Sc3JLEst0rdL4Mq4PzOpYL5VxZQvD1gbGCcYdDFyckgImEh83HybBcIWk7hwbz1bFyMXh5DA
	UkaJ58ems0I4fUwSv3+0s4FUsQkYS2xevgTMFhG4xipx5kxoFyMHB7NAjMSLKXYgYWEBH4nz
	+yaADWURUJX4+LibEcTmFXCXePnrMQtIuYSAgsScSTYgYU4BD4lPS0+AhYWASrbPq5rAyLuA
	kWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkg8fN3BuPSY1SFGAQ5GJR7eA8vWBwmxJpYV
	V+YeYpTgYFYS4f3msSFIiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PkqsYzX3w8s4/eq18fXGve
	kG4U0HRy29n1PKpvt1yrnMxecz7heIDbHqHU4KxYU/fL864H3p69Z7ra7nUXb2xh3fxiZuVM
	XeanQtPC383eGh5lfsW6bfHvjvt6B3umc7x+c6Dn23n+O3kK01fZXGgs3X9E7/ot6/NqoVEX
	dFuLs3TZNy5ZU1qpxFKckWioxVxUnAgA5XQzIWUCAAA=
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
---
 drivers/regulator/s5m8767.c         |  120 ++++++++++++++++++++++++++++++++++-
 include/linux/mfd/samsung/core.h    |    2 +
 include/linux/mfd/samsung/s5m8767.h |    7 ++
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d7164bb75d3e..86fb44c56bac 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -48,6 +48,8 @@ struct s5m8767_info {
 	int buck_gpios[3];
 	int buck_ds[3];
 	int buck_gpioindex;
+	bool buck9_uses_gpio;
+	int buck9_gpio;
 };
 
 struct sec_voltage_desc {
@@ -261,6 +263,43 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 			S5M8767_ENCTRL_MASK, ~S5M8767_ENCTRL_MASK);
 }
 
+static int s5m8767_reg_gpio_is_enabled(struct regulator_dev *rdev)
+{
+	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
+	int val;
+
+	if (!s5m8767->buck9_uses_gpio)
+		return s5m8767_reg_is_enabled(rdev);
+
+	val = gpio_get_value(s5m8767->buck9_gpio);
+
+	return val == 1;
+}
+
+static int s5m8767_reg_gpio_enable(struct regulator_dev *rdev)
+{
+	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
+
+	if (!s5m8767->buck9_uses_gpio)
+		return s5m8767_reg_enable(rdev);
+
+	gpio_set_value(s5m8767->buck9_gpio, 1);
+
+	return 0;
+}
+
+static int s5m8767_reg_gpio_disable(struct regulator_dev *rdev)
+{
+	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
+
+	if (!s5m8767->buck9_uses_gpio)
+		return s5m8767_reg_disable(rdev);
+
+	gpio_set_value(s5m8767->buck9_gpio, 0);
+
+	return 0;
+}
+
 static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
 {
 	int reg;
@@ -427,6 +466,17 @@ static struct regulator_ops s5m8767_buck78_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 };
 
+static struct regulator_ops s5m8767_buck_gpio_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= s5m8767_reg_gpio_is_enabled,
+	.enable			= s5m8767_reg_gpio_enable,
+	.disable		= s5m8767_reg_gpio_disable,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
+};
+
+
 #define s5m8767_regulator_desc(_name) {		\
 	.name		= #_name,		\
 	.id		= S5M8767_##_name,	\
@@ -443,6 +493,14 @@ static struct regulator_ops s5m8767_buck78_ops = {
 	.owner		= THIS_MODULE,		\
 }
 
+#define s5m8767_regulator_gpio_desc(_name) {	\
+	.name		= #_name,		\
+	.id		= S5M8767_##_name,	\
+	.ops		= &s5m8767_buck_gpio_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+
 static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(LDO1),
 	s5m8767_regulator_desc(LDO2),
@@ -480,9 +538,50 @@ static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(BUCK6),
 	s5m8767_regulator_buck78_desc(BUCK7),
 	s5m8767_regulator_buck78_desc(BUCK8),
-	s5m8767_regulator_desc(BUCK9),
+	s5m8767_regulator_gpio_desc(BUCK9),
 };
 
+/*
+ * Initialize BUCK9EN GPIO and BUCK9 control register.
+ * Assuming DT or platform data is already parsed and buck9_uses_gpio is true.
+ */
+static int s5m8767_init_buck9en_gpio(struct s5m8767_info *s5m8767)
+{
+	int i, ret, mode = 0;
+	unsigned int data;
+
+	/* Check if opmode for Buck9 matches pmic-buck9-uses-gpio */
+	for (i = 0; i < s5m8767->num_regulators; i++) {
+		const struct sec_opmode_data *opmode = &s5m8767->opmode[i];
+		if (opmode->id == S5M8767_BUCK9) {
+			mode = s5m8767_opmode_reg[S5M8767_BUCK9][opmode->mode];
+			break;
+		}
+	}
+	if (mode != S5M8767_ENCTRL_USE_GPIO) {
+		dev_err(s5m8767->dev,
+				"Mismatched op_mode (%x) and uses-gpio for Buck9, fallback to normal mode\n",
+				mode);
+		s5m8767->buck9_uses_gpio = false;
+		return 0;
+	}
+
+	if (!gpio_is_valid(s5m8767->buck9_gpio)) {
+		dev_err(s5m8767->dev, "Buck9 GPIO not valid\n");
+		return -EINVAL;
+	}
+
+	ret = devm_gpio_request_one(s5m8767->dev, s5m8767->buck9_gpio,
+			GPIOF_OUT_INIT_HIGH, "S5M8767 BUCK9EN");
+	if (ret)
+		return ret;
+
+	data = S5M8767_ENCTRL_USE_GPIO << S5M8767_ENCTRL_SHIFT;
+
+	return regmap_update_bits(s5m8767->iodev->regmap_pmic,
+			S5M8767_REG_BUCK9CTRL1, S5M8767_ENCTRL_MASK, data);
+}
+
 #ifdef CONFIG_OF
 static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
 			struct sec_platform_data *pdata,
@@ -663,6 +762,17 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			pdata->buck_ramp_delay = 0;
 	}
 
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck9-uses-gpio", NULL)) {
+		int gpio = of_get_named_gpio(pmic_np,
+					"s5m8767,pmic-buck9-gpio", 0);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(iodev->dev, "invalid buck9 gpio: %d\n", gpio);
+			return -EINVAL;
+		}
+		pdata->buck9_uses_gpio = true;
+		pdata->buck9_gpio = gpio;
+	}
+
 	return 0;
 }
 #else
@@ -740,6 +850,8 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	s5m8767->buck_ds[0] = pdata->buck_ds[0];
 	s5m8767->buck_ds[1] = pdata->buck_ds[1];
 	s5m8767->buck_ds[2] = pdata->buck_ds[2];
+	s5m8767->buck9_uses_gpio = pdata->buck9_uses_gpio;
+	s5m8767->buck9_gpio = pdata->buck9_gpio;
 
 	s5m8767->ramp_delay = pdata->buck_ramp_delay;
 	s5m8767->buck2_ramp = pdata->buck2_ramp_enable;
@@ -917,6 +1029,12 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 					val << S5M8767_DVS_BUCK_RAMP_SHIFT);
 	}
 
+	if (s5m8767->buck9_uses_gpio) {
+		ret = s5m8767_init_buck9en_gpio(s5m8767);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 41c9bde410c5..8c52ecea3f11 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -80,6 +80,8 @@ struct sec_platform_data {
 	bool				buck3_gpiodvs;
 	unsigned int			buck4_voltage[8];
 	bool				buck4_gpiodvs;
+	int				buck9_gpio;
+	bool				buck9_uses_gpio;
 
 	int				buck_set1;
 	int				buck_set2;
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
index 2ab0b0f03641..d383c46a9ad8 100644
--- a/include/linux/mfd/samsung/s5m8767.h
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -183,8 +183,15 @@ enum s5m8767_regulators {
 	S5M8767_REG_MAX,
 };
 
+/* LDO_EN/BUCK_EN field in registers */
 #define S5M8767_ENCTRL_SHIFT		6
 #define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
+/*
+ * LDO_EN/BUCK_EN register value for controlling this Buck or LDO
+ * by GPIO (PWREN, BUCKEN).
+ */
+#define S5M8767_ENCTRL_USE_GPIO		0x1
+
 
 /*
  * Values for BUCK_RAMP field in DVS_RAMP register, matching raw values
-- 
1.7.9.5

