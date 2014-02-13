Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaBMJO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54737 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaBMJOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:41 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-9f-52fc8cf39b48
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14 regulators
Date: Thu, 13 Feb 2014 10:14:04 +0100
Message-id: <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7qfe/4EGbxs0bbYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBYzzu9jslh75C67xeluVouLK74wOfB4
	7Jx1l91j06pONo871/awecw7GejRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGdv+HGIpaDKo
	6HvcwdrAeF69i5GTQ0LARGL5qkXsELaYxIV769m6GLk4hASWMkos+DCTBcLpY5L40j6LBaSK
	TcBYYvPyJWBVIgKbGSUWf7/KCuIwC2xlkvi8fiMzSJWwgL/Epd6JQHM5OFgEVCUWXFQCCfMK
	eEgs3zmVESQsIaAgMWeSDUiYEyj878dvsE4hAXeJnsWz2Ccw8i5gZFjFKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERKMX3YwLj5mdYhRgINRiYfXYtnvICHWxLLiytxDjBIczEoivDISf4KE
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MDaUnJ/FIFt8rOXTjb47WqaLP3fvXlL/LM9dvO5pEU/M
	Ij5x41bTLQ4Cs7iVjeb/yfpqcK9iQp5e2Db2uNkqFVq/X003KEiMZFzuN1fNMyOOb2L0t32N
	snMl7jnfOvO8qmex4Q5hG8F5XEcVF1WZ/jxY9HLZNL6wu3u3/b/1nHNh04Xj7FdslJRYijMS
	DbWYi4oTAUFkhMgkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S2MPS11/S2MPS14 regulators support different modes of operation:
 - Always off;
 - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
 - Always on;
This is very similar to S5M8767 regulator driver which also supports
opmodes (although S5M8767 have also low-power mode).

This patch adds parsing the operation mode from DTS by reading a
"op_mode" property from regulator child node.

The op_mode is then used for enabling the S2MPS14 regulators.
On S2MPS11 the DTS "op_mode" property is parsed but not used for
enabling, as this was not tested.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/s2mps11.c         |   97 ++++++++++++++++++++++++++++++++++-
 include/linux/mfd/samsung/s2mps14.h |   19 +++++++
 2 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index f56ac6f776ae..4a203ef9a605 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -34,6 +34,7 @@
 struct s2mps11_info {
 	struct regulator_dev **rdev;
 	unsigned int rdev_num;
+	struct sec_opmode_data *opmode;
 
 	int ramp_delay2;
 	int ramp_delay34;
@@ -43,6 +44,48 @@ struct s2mps11_info {
 	int ramp_delay9;
 };
 
+/* LDO_EN/BUCK_EN register values for enabling/disabling regulator */
+static unsigned int s2mps14_opmode_reg[4] = {
+	[S2MPS14_REGULATOR_OPMODE_OFF]		= 0x0,
+	[S2MPS14_REGULATOR_OPMODE_ON]		= 0x3,
+	[S2MPS14_REGULATOR_OPMODE_RESERVED]	= 0x2,
+	[S2MPS14_REGULATOR_OPMODE_SUSPEND]	= 0x1,
+};
+
+static int s2mps14_get_opmode(struct regulator_dev *rdev)
+{
+	int i, reg_id = rdev_get_id(rdev);
+	int mode = -EINVAL;
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+
+	for (i = 0; i < s2mps11->rdev_num; i++) {
+		if (s2mps11->opmode[i].id == reg_id) {
+			mode = s2mps11->opmode[i].mode;
+			break;
+		}
+	}
+
+	if (mode == -EINVAL) {
+		dev_warn(rdev_get_dev(rdev),
+				"No op_mode in the driver for regulator %s\n",
+				rdev->desc->name);
+		return mode;
+	}
+
+	return s2mps14_opmode_reg[mode] << S2MPS14_ENCTRL_SHIFT;
+}
+
+static int s2mps14_reg_enable(struct regulator_dev *rdev)
+{
+	int enable_ctrl = s2mps14_get_opmode(rdev);
+
+	if (enable_ctrl < 0)
+		return enable_ctrl;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+			S2MPS14_ENCTRL_MASK, enable_ctrl);
+}
+
 static int get_ramp_delay(int ramp_delay)
 {
 	unsigned char cnt = 0;
@@ -405,7 +448,7 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= regulator_is_enabled_regmap,
-	.enable			= regulator_enable_regmap,
+	.enable			= s2mps14_reg_enable,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
@@ -520,6 +563,53 @@ static const struct regulator_desc s2mps14_regulators[] __initconst = {
 	regulator_desc_s2mps14_buck1235(5),
 };
 
+static inline void s2mps11_dt_read_opmode(struct platform_device *pdev,
+		struct device_node *np, unsigned int *mode)
+{
+	if (of_property_read_u32(np, "op_mode",	mode)) {
+		dev_warn(&pdev->dev, "no op_mode property property at %s\n",
+				np->full_name);
+		*mode = S2MPS14_REGULATOR_OPMODE_ON;
+	} else if (*mode >= S2MPS14_REGULATOR_OPMODE_MAX ||
+			*mode == S2MPS14_REGULATOR_OPMODE_RESERVED) {
+		dev_warn(&pdev->dev, "wrong op_mode value at %s\n",
+				np->full_name);
+		*mode = S2MPS14_REGULATOR_OPMODE_ON;
+	}
+	/* else: 'mode' was read from DTS and it is valid */
+}
+
+/*
+ * Returns allocated array with opmodes for regulators. The opmodes are read
+ * from DTS.
+ */
+static struct sec_opmode_data *
+s2mps11_pmic_dt_parse_opmode(struct platform_device *pdev,
+		unsigned int rdev_num, struct of_regulator_match *rdata,
+		const struct regulator_desc *regulators)
+{
+	struct sec_opmode_data *rmode;
+	int i;
+
+	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode)*rdev_num, GFP_KERNEL);
+	if (!rmode) {
+		dev_err(&pdev->dev,
+			"could not allocate memory for regulator mode\n");
+		return NULL;
+	}
+
+	for (i = 0; i < rdev_num; i++) {
+		/*
+		 * The index of rdata and regulators is the same, but this
+		 * may not be equal to ID of regulator.
+		 */
+		rmode[i].id = regulators[i].id;
+		s2mps11_dt_read_opmode(pdev, rdata[i].of_node, &rmode[i].mode);
+	}
+
+	return rmode;
+}
+
 /*
  * Allocates memory under 'regulators' pointer and copies there array
  * of regulator_desc for given device.
@@ -609,9 +699,14 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, rdev_num);
+	pdata->opmode = s2mps11_pmic_dt_parse_opmode(pdev, rdev_num, rdata,
+				regulators);
+	if (!pdata->opmode)
+		return -ENOMEM;
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
+	s2mps11->opmode = pdata->opmode;
 	s2mps11->rdev_num = rdev_num;
 
 	config.dev = &pdev->dev;
diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
index ec1e0857ddde..2d36f75a6301 100644
--- a/include/linux/mfd/samsung/s2mps14.h
+++ b/include/linux/mfd/samsung/s2mps14.h
@@ -149,4 +149,23 @@ enum s2mps14_regulators {
 #define S2MPS14_LDO_N_VOLTAGES		(S2MPS14_LDO_VSEL_MASK + 1)
 #define S2MPS14_BUCK_N_VOLTAGES		(S2MPS14_BUCK_VSEL_MASK + 1)
 
+#define S2MPS14_ENCTRL_SHIFT		6
+#define S2MPS14_ENCTRL_MASK		(0x3 << S2MPS14_ENCTRL_SHIFT)
+
+/*
+ * Values of regulator operation modes match device tree bindings.
+ */
+enum s2mps14_regulator_opmode {
+	S2MPS14_REGULATOR_OPMODE_OFF		= 0,
+	S2MPS14_REGULATOR_OPMODE_ON		= 1,
+	/*
+	 * Reserved for compatibility with S5M8767 where this
+	 * is a low power mode.
+	 */
+	S2MPS14_REGULATOR_OPMODE_RESERVED	= 2,
+	S2MPS14_REGULATOR_OPMODE_SUSPEND	= 3,
+
+	S2MPS14_REGULATOR_OPMODE_MAX,
+};
+
 #endif /*  __LINUX_MFD_S2MPS14_H */
-- 
1.7.9.5

