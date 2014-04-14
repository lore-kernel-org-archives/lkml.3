Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaDNIKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:10:16 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49818 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaDNIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:09:33 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c7-534b97b59447
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/4] regulator: s2mps11: Add external GPIO control for S2MPS14
Date: Mon, 14 Apr 2014 10:09:07 +0200
Message-id: <1397462949-22379-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7pbp3sHG7xZzW2xccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1eLiii9MFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	06pONo871/awecw7GejRt2UVo8fnTXIBnFFcNimpOZllqUX6dglcGV823GEpmKhb8bPTuYFx
	qWoXIyeHhICJxOnvv5kgbDGJC/fWs4HYQgJLGSWW7uHvYuQCsvuYJJaef8sMkmATMJbYvHwJ
	G0hCROAGs8TEZbvAupkFnjNKPP0eDmILC/hJLFmzlwXEZhFQlXiz8DuYzSvgLjF5TTcjxDYF
	iWVf1gIN5eDgFPCQeHMTarG7xNffs5gmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7
	iRES4l92MC4+ZnWIUYCDUYmHN2G7Z7AQa2JZcWXuIUYJDmYlEd5tGV7BQrwpiZVVqUX58UWl
	OanFhxiZODilGhh9pp3fIHCYiTtU8xpLWuy0z+vMwjn3Rr474uO6quPnzWjxkwrbv9UvSf49
	p7blpI77H6bgV2EhHgmqse/nv1ZgmzFn8cG1D27+elQYbHbg6OOw0vbJP352/JU6t09pZ8Hk
	S8zL7Vf5n30h7dr68+PPiloWPc81t0ObqzSFLf/YTHpZdEQxa8E9JZbijERDLeai4kQALAF5
	jE8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for external control over GPIO for LDO10, LDO11 and LDO12
S2MPS14 regulators. External control can be turned on by writing 0x0 to
control register which in case of other regulators is used for disabling
them. These LDO10-LDO12 regulators can be disabled only by I2C GPIO or
PWREN pin so the patch actually allows proper way of disabling them.

Additionally the GPIO control has two benefits:
 - It is faster than toggling it over I2C bus.
 - It allows disabling the regulator during suspend to RAM; The AP will
   enable it during resume.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c         | 67 +++++++++++++++++++++++++++++++++++--
 include/linux/mfd/samsung/s2mps14.h |  2 ++
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 3aba0331fb5d..6dad0aa74a47 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -27,6 +27,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/of_gpio.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
@@ -44,6 +45,8 @@ struct s2mps11_info {
 	 * was enabled.
 	 */
 	unsigned int s2mps14_suspend_state:30;
+	/* Array of size rdev_num with GPIO-s for external sleep control */
+	int *ext_control_gpio;
 };
 
 static int get_ramp_delay(int ramp_delay)
@@ -409,6 +412,8 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
 
 	if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
 		val = S2MPS14_ENABLE_SUSPEND;
+	else if (s2mps11->ext_control_gpio[rdev_get_id(rdev)])
+		val = S2MPS14_ENABLE_EXT_CONTROL;
 	else
 		val = rdev->desc->enable_mask;
 
@@ -565,9 +570,41 @@ static const struct regulator_desc s2mps14_regulators[] = {
 	regulator_desc_s2mps14_buck1235(5),
 };
 
-static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
+static int s2mps14_pmic_enable_ext_control(struct s2mps11_info *s2mps11,
+		struct regulator_dev *rdev)
+{
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+			rdev->desc->enable_mask, S2MPS14_ENABLE_EXT_CONTROL);
+}
+
+static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11)
 {
+	int *gpio = s2mps11->ext_control_gpio;
+	unsigned int i;
+	unsigned int valid_regulators[3] = { S2MPS14_LDO10, S2MPS14_LDO11,
+		S2MPS14_LDO12 };
+
+	for (i = 0; i < ARRAY_SIZE(valid_regulators); i++) {
+		unsigned int reg = valid_regulators[i];
+
+		if (!rdata[reg].init_data || !rdata[reg].of_node)
+			continue;
+
+		gpio[reg] = of_get_named_gpio(rdata[reg].of_node,
+				"samsung,ext-control-gpios", 0);
+		if (!gpio_is_valid(gpio[reg]))
+			gpio[reg] = 0;
+		else
+			dev_dbg(&pdev->dev, "Using GPIO %d for ext-control over %d/%s\n",
+					gpio[reg], reg, rdata[reg].name);
+	}
+}
+
+static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
+		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11,
+		enum sec_device_type dev_type)
+{
 	struct device_node *reg_np;
 
 	reg_np = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
@@ -577,6 +614,9 @@ static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
+	if (dev_type == S2MPS14X)
+		s2mps14_pmic_dt_parse_ext_control_gpio(pdev, rdata, s2mps11);
+
 	of_node_put(reg_np);
 
 	return 0;
@@ -613,6 +653,12 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		return -EINVAL;
 	};
 
+	s2mps11->ext_control_gpio = devm_kzalloc(&pdev->dev,
+			sizeof(*s2mps11->ext_control_gpio) * s2mps11->rdev_num,
+			GFP_KERNEL);
+	if (!s2mps11->ext_control_gpio)
+		return -ENOMEM;
+
 	if (!iodev->dev->of_node) {
 		if (iodev->pdata) {
 			pdata = iodev->pdata;
@@ -631,7 +677,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
-	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11);
+	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11, dev_type);
 	if (ret)
 		goto out;
 
@@ -652,6 +698,12 @@ common_reg:
 			config.of_node = rdata[i].of_node;
 		}
 
+		if (s2mps11->ext_control_gpio[i]) {
+			config.ena_gpio = s2mps11->ext_control_gpio[i];
+			config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+		} else
+			config.ena_gpio = config.ena_gpio_flags = 0;
+
 		regulator = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(regulator)) {
@@ -660,6 +712,17 @@ common_reg:
 				i);
 			goto out;
 		}
+
+		if (s2mps11->ext_control_gpio[i]) {
+			ret = s2mps14_pmic_enable_ext_control(s2mps11,
+					regulator);
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+						"failed to enable GPIO control over %s: %d\n",
+						regulator->desc->name, ret);
+				goto out;
+			}
+		}
 	}
 
 out:
diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
index 4b449b8ac548..900cd7a04314 100644
--- a/include/linux/mfd/samsung/s2mps14.h
+++ b/include/linux/mfd/samsung/s2mps14.h
@@ -148,6 +148,8 @@ enum s2mps14_regulators {
 #define S2MPS14_ENABLE_SHIFT		6
 /* On/Off controlled by PWREN */
 #define S2MPS14_ENABLE_SUSPEND		(0x01 << S2MPS14_ENABLE_SHIFT)
+/* On/Off controlled by LDO10EN or EMMCEN */
+#define S2MPS14_ENABLE_EXT_CONTROL	(0x00 << S2MPS14_ENABLE_SHIFT)
 #define S2MPS14_LDO_N_VOLTAGES		(S2MPS14_LDO_VSEL_MASK + 1)
 #define S2MPS14_BUCK_N_VOLTAGES		(S2MPS14_BUCK_VSEL_MASK + 1)
 
-- 
1.8.3.2

