Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab3KMHlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:41:42 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25262 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab3KMHlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:41:13 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-1e-52832d16eab3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] regulator: max14577: Add regulator driver for Maxim 14577
Date: Wed, 13 Nov 2013 08:40:57 +0100
Message-id: <1384328457-5147-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xa7pius1BBlPaLC0ObtW02DhjPavF
	1IdP2Cyuf3nOajH/yDlWi4krJzNbHPizg9Hi9QtDi7NNb9gt7n89ymjx7UoHk8XlXXPYLNYe
	uctucbtxBZvF4RUHmCxOd7M6CHgs+HyF3WNC/ydGj52z7rJ7bF6h5bFpVSebx51re9g85p0M
	9OjbsorR4/MmuQDOKC6blNSczLLUIn27BK6MLZs3sBc8z6w4OiGpgXFbRBcjJ4eEgInE9Y0f
	2SFsMYkL99azdTFycQgJLGWU+H+riwnC6WOSWD+hiRGkik3AWGLz8iVgVSIC+5klJl6/zQzi
	MAscZZR427mLCaRKWMBPYsaka2A2i4CqRMuxhywgNq+Am8SLl/+AujmA9ilIzJlkAxLmFHCX
	WLqwmw3EFgIqmXr+EtsERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC+esOxqXH
	rA4xCnAwKvHwWsQ0BQmxJpYVV+YeYpTgYFYS4T0g3BwkxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gbFDpkqcf0u367x784RYl3rr6MS/VTsR5lLW3vJs4nYpoZWmet9aVjasX236MUf977ddHzan
	HmxS3PDhU7Qvx+QJ3k1ecSqa/zR/ZdZP19zmcmj6m1q/wM8vn756y3l2y1JWtdp/7JtuL3sj
	tWHNy67GriaOc08z+BTOx1cmlrZlzfvcs+nRv51KLMUZiYZazEXFiQDLsdKnRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX14577 chip is a multi-function device which includes MUIC,
charger and voltage regulator. The driver is located in drivers/mfd.

This patch adds regulator driver for MAX14577 chip. There are two
regulators in this chip:
1. Safeout LDO with constant voltage output of 4.9V. It can be only
   enabled or disabled.
2. Current regulator for the charger. It provides current from 90mA up
   to 950mA.
Driver supports Device Tree.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/Kconfig    |    7 +
 drivers/regulator/Makefile   |    1 +
 drivers/regulator/max14577.c |  365 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 373 insertions(+)
 create mode 100644 drivers/regulator/max14577.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ce785f4..11ee053 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -249,6 +249,13 @@ config REGULATOR_LP8788
 	help
 	  This driver supports LP8788 voltage regulator chip.
 
+config REGULATOR_MAX14577
+	tristate "Maxim 14577 regulator"
+	depends on MFD_MAX14577
+	help
+	  This driver controls a Maxim 14577 regulator via I2C bus.
+	  The regulators include safeout LDO and current regulator 'CHARGER'.
+
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 01c597e..654bd43 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-buck.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-ldo.o
 obj-$(CONFIG_REGULATOR_LP8755) += lp8755.o
+obj-$(CONFIG_REGULATOR_MAX14577) += max14577.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
new file mode 100644
index 0000000..e05c445
--- /dev/null
+++ b/drivers/regulator/max14577.c
@@ -0,0 +1,365 @@
+/*
+ * max14577.c - Regulator driver for the Maxim 14577
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/max14577.h>
+#include <linux/mfd/max14577-private.h>
+#include <linux/regulator/of_regulator.h>
+
+struct max14577_regulator {
+	struct device *dev;
+	struct max14577 *max14577;
+	int num_regulators;
+	struct regulator_dev **regulators;
+};
+
+static int max14577_reg_calc_charge_current(struct regmap *rmap)
+{
+	u8 reg_data;
+	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL4, &reg_data);
+
+	if ((reg_data & CHGCTRL4_MBCICHWRCL_MASK) == 0)
+		return MAX14577_REGULATOR_CURRENT_LIMIT_MIN;
+
+	reg_data = ((reg_data & CHGCTRL4_MBCICHWRCH_MASK) >>
+			CHGCTRL4_MBCICHWRCH_SHIFT);
+	return MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
+		reg_data * MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP;
+}
+
+static inline int max14577_reg_set_safeout(struct regmap *rmap, int on)
+{
+	u8 reg_data = (on ? 0x1 << CTRL2_SFOUTORD_SHIFT : 0x0);
+
+	return max14577_update_reg(rmap, MAX14577_REG_CONTROL2,
+			CTRL2_SFOUTORD_MASK, reg_data);
+}
+
+static inline int max14577_reg_set_charging(struct regmap *rmap, int on)
+{
+	u8 reg_data = (on ? 0x1 << CHGCTRL2_MBCHOSTEN_SHIFT : 0x0);
+
+	return max14577_update_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2,
+			CHGCTRL2_MBCHOSTEN_MASK, reg_data);
+}
+
+static int max14577_reg_is_enabled(struct regulator_dev *rdev)
+{
+	int rid = rdev_get_id(rdev);
+	struct regmap *rmap = rdev->regmap;
+	u8 reg_data;
+
+	switch (rid) {
+	case MAX14577_CHARGER:
+		max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL2, &reg_data);
+		if ((reg_data & CHGCTRL2_MBCHOSTEN_MASK) == 0)
+			return 0;
+		max14577_read_reg(rmap, MAX14577_CHG_REG_STATUS3, &reg_data);
+		if ((reg_data & STATUS3_CGMBC_MASK) == 0)
+			return 0;
+		/* MBCHOSTEN and CGMBC are on */
+		return 1;
+	case MAX14577_SAFEOUT:
+		max14577_read_reg(rmap, MAX14577_REG_CONTROL2, &reg_data);
+		return (reg_data & CTRL2_SFOUTORD_MASK) != 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int max14577_reg_enable(struct regulator_dev *rdev)
+{
+	int rid = rdev_get_id(rdev);
+
+	switch (rid) {
+	case MAX14577_CHARGER:
+		return max14577_reg_set_charging(rdev->regmap, 1);
+	case MAX14577_SAFEOUT:
+		return max14577_reg_set_safeout(rdev->regmap, 1);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int max14577_reg_disable(struct regulator_dev *rdev)
+{
+	int rid = rdev_get_id(rdev);
+
+	switch (rid) {
+	case MAX14577_CHARGER:
+		return max14577_reg_set_charging(rdev->regmap, 0);
+	case MAX14577_SAFEOUT:
+		return max14577_reg_set_safeout(rdev->regmap, 0);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
+{
+	if (rdev_get_id(rdev) != MAX14577_CHARGER)
+		return -EINVAL;
+
+	return max14577_reg_calc_charge_current(rdev->regmap);
+}
+
+static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
+		int min_uA, int max_uA)
+{
+	int i, current_bits = 0xf;
+	u8 reg_data;
+	struct max14577_regulator *max14577 = rdev_get_drvdata(rdev);
+
+	if (rdev_get_id(rdev) != MAX14577_CHARGER)
+		return -EINVAL;
+
+	dev_info(max14577->dev, "Requested current <%d, %d>\n", min_uA, max_uA);
+	if (min_uA > MAX14577_REGULATOR_CURRENT_LIMIT_MAX ||
+			max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_MIN)
+		return -EINVAL;
+
+	if (max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START) {
+		/* Less than 200 mA, so set 90mA (turn only Low Bit off) */
+		u8 reg_data = 0x0 << CHGCTRL4_MBCICHWRCL_SHIFT;
+		dev_info(max14577->dev, "Setting current %d uA\n",
+				MAX14577_REGULATOR_CURRENT_LIMIT_MIN);
+		return max14577_update_reg(rdev->regmap,
+				MAX14577_CHG_REG_CHG_CTRL4,
+				CHGCTRL4_MBCICHWRCL_MASK, reg_data);
+	}
+
+	/* max_uA is in range: <LIMIT_HIGH_START, inifinite>, so search for
+	 * valid current starting from LIMIT_MAX. */
+	for (i = MAX14577_REGULATOR_CURRENT_LIMIT_MAX;
+			i >= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START;
+			i -= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP) {
+		if (i <= max_uA)
+			break;
+		current_bits--;
+	}
+	BUG_ON(current_bits < 0); /* Cannot happen */
+	/* Turn Low Bit on (use range 200mA-950 mA) */
+	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
+	/* and set proper High Bits */
+	reg_data |= current_bits << CHGCTRL4_MBCICHWRCH_SHIFT;
+	dev_info(max14577->dev, "Setting current %d uA (REG: 0x%x)\n", i,
+			reg_data);
+
+	return max14577_update_reg(rdev->regmap, MAX14577_CHG_REG_CHG_CTRL4,
+			CHGCTRL4_MBCICHWRCL_MASK | CHGCTRL4_MBCICHWRCH_MASK,
+			reg_data);
+}
+
+static struct regulator_ops max14577_safeout_ops = {
+	.is_enabled		= max14577_reg_is_enabled,
+	.enable			= max14577_reg_enable,
+	.disable		= max14577_reg_disable,
+	.list_voltage		= regulator_list_voltage_linear,
+};
+
+static struct regulator_ops max14577_charger_ops = {
+	.is_enabled		= max14577_reg_is_enabled,
+	.enable			= max14577_reg_enable,
+	.disable		= max14577_reg_disable,
+	.get_current_limit	= max14577_reg_get_current_limit,
+	.set_current_limit	= max14577_reg_set_current_limit,
+};
+
+static struct regulator_desc supported_regulators[] = {
+	{
+		.name = "SAFEOUT",
+		.id = MAX14577_SAFEOUT,
+		.ops = &max14577_safeout_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.n_voltages = 1,
+		.min_uV = MAX14577_REGULATOR_SAFEOUT_VOLTAGE,
+	}, {
+		.name = "CHARGER",
+		.id = MAX14577_CHARGER,
+		.ops = &max14577_charger_ops,
+		.type = REGULATOR_CURRENT,
+		.owner = THIS_MODULE,
+	}
+};
+
+#ifdef CONFIG_OF
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
+					struct max14577_platform_data *pdata)
+{
+	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np;
+	struct max14577_regulator_platform_data *reg_pdata;
+	struct of_regulator_match rmatch;
+	int i, ret, cnt = 0, regulators_size = ARRAY_SIZE(supported_regulators);
+
+	np = of_find_node_by_name(max14577->dev->of_node, "regulators");
+	if (!np)
+		return -EINVAL;
+
+	pdata->num_regulators = of_get_child_count(np);
+	if (pdata->num_regulators == 0)
+		return -ENODEV;
+
+	reg_pdata = devm_kzalloc(&pdev->dev, sizeof(*reg_pdata) *
+			     pdata->num_regulators, GFP_KERNEL);
+	if (!reg_pdata)
+		return -ENOMEM;
+
+	dev_info(&pdev->dev, "Parsing %d regulator(s) from supplied DT\n",
+			pdata->num_regulators);
+	for (i = 0; i < regulators_size; i++) {
+		rmatch.name = supported_regulators[i].name;
+		ret = of_regulator_match(&pdev->dev, np, &rmatch, 1);
+		if (ret != 1)
+			continue;
+		dev_info(&pdev->dev, "Found regulator %d/%s\n",
+				supported_regulators[i].id,
+				supported_regulators[i].name);
+		reg_pdata[cnt].id = supported_regulators[i].id;
+		reg_pdata[cnt].initdata = rmatch.init_data;
+		reg_pdata[cnt].of_node = rmatch.of_node;
+		cnt++;
+	}
+
+	pdata->regulators = reg_pdata;
+	pdata->num_regulators = cnt;
+	dev_info(&pdev->dev, "Found %d supported regulator(s)\n",
+			pdata->num_regulators);
+
+	return 0;
+}
+#else
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
+					struct max14577_platform_data *pdata)
+{
+	return 0;
+}
+#endif
+
+static int max14577_regulator_probe(struct platform_device *pdev)
+{
+	struct max14577_regulator *max14577_reg;
+	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
+	int i, ret, size;
+	struct regulator_config config = {};
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data found.\n");
+		return -ENODEV;
+	}
+
+	if (max14577->dev->of_node) {
+		ret = max14577_regulator_dt_parse_pdata(pdev, pdata);
+		if (ret)
+			return ret;
+	}
+
+	max14577_reg = devm_kzalloc(&pdev->dev,
+			sizeof(struct max14577_regulator), GFP_KERNEL);
+	if (!max14577_reg)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
+	max14577_reg->regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max14577_reg->regulators) {
+		dev_err(&pdev->dev, "Cannot allocate memory for regulators\n");
+		return -ENOMEM;
+	}
+
+	max14577_reg->dev = &pdev->dev;
+	max14577_reg->max14577 = max14577;
+	max14577_reg->num_regulators = pdata->num_regulators;
+
+	config.dev = &pdev->dev;
+	config.regmap = max14577->regmap;
+	config.driver_data = max14577_reg;
+	platform_set_drvdata(pdev, max14577_reg);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		int id = pdata->regulators[i].id;
+
+		config.init_data = pdata->regulators[i].initdata;
+		config.of_node = pdata->regulators[i].of_node;
+
+		max14577_reg->regulators[i] =
+			regulator_register(&supported_regulators[id], &config);
+		if (IS_ERR(max14577_reg->regulators[i])) {
+			ret = PTR_ERR(max14577_reg->regulators[i]);
+			dev_err(&pdev->dev,
+					"Regulator init failed for ID %d with error: %d\n",
+					id, ret);
+			max14577_reg->regulators[i] = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+ err:
+	while (--i >= 0)
+		regulator_unregister(max14577_reg->regulators[i]);
+
+	return ret;
+}
+
+static int max14577_regulator_remove(struct platform_device *pdev)
+{
+	struct max14577_regulator *max14577_reg = platform_get_drvdata(pdev);
+	struct regulator_dev **regulators = max14577_reg->regulators;
+	int i;
+
+	for (i = 0; i < max14577_reg->num_regulators; i++)
+		if (regulators[i])
+			regulator_unregister(regulators[i]);
+
+	return 0;
+}
+
+static struct platform_driver max14577_regulator_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = "max14577-regulator",
+		   },
+	.probe		= max14577_regulator_probe,
+	.remove		= max14577_regulator_remove,
+};
+
+static int __init max14577_regulator_init(void)
+{
+	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
+			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
+	return platform_driver_register(&max14577_regulator_driver);
+}
+subsys_initcall(max14577_regulator_init);
+
+static void __exit max14577_regulator_exit(void)
+{
+	platform_driver_unregister(&max14577_regulator_driver);
+}
+module_exit(max14577_regulator_exit);
+
+MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
+MODULE_DESCRIPTION("MAXIM 14577 regulator driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

