Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBKNFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:05:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27147 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaBKNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:19 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ac-52fa1fd15073
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
Subject: [PATCH 11/14] regulator: s2mps11: Add opmode for S2MPS14 regulators
Date: Tue, 11 Feb 2014 14:03:54 +0100
Message-id: <1392123837-5517-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4Fd2L8r+CDF7t0rDYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBYzzu9jslh75C67xeluVouLK74wOfB4
	7Jx1l91j06pONo871/awecw7GejRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGVuW5BYsM6h4
	NOEgawPjP/UuRk4OCQETiRefprND2GISF+6tZ+ti5OIQEljKKDG/8ycbSEJIoI9JYsaVYhCb
	TcBYYvPyJWBFIgKbGSUWf7/KCuIwC2xlkvi8fiMzSJWwgI/EsvcNLCA2i4CqxNfHT8BW8Aq4
	S5yY1gRUwwG0TkFiziQbkDAnULjv0382kLCQgJvE8v7YCYy8CxgZVjGKppYmFxQnpeca6hUn
	5haX5qXrJefnbmKEBOKXHYyLj1kdYhTgYFTi4d2g+DNIiDWxrLgy9xCjBAezkgjvF+FfQUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYm7Taw0xmHFmm79wZ9Hvquv/2n5KT1hZxTp0XuPLphtNt
	XcmGi05UOQQnLJjAJ1Wo+PvcPoZIR5frXX61T07/uWavN8XsJt+OH2d/e/ZvDfwX6cMx/fXc
	KgtJVekjJ+e5TfloOKv4n8HmwrRJZZ+1/rVyb1587npUKzOL2o9pH2/0Cd+bNy2YTYmlOCPR
	UIu5qDgRAHzk+i8iAgAA
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
 drivers/regulator/s2mps11.c         |   98 ++++++++++++++++++++++++++++++++++-
 include/linux/mfd/samsung/s2mps14.h |   17 ++++++
 2 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index c37869fb6c7a..b30fa6cd370d 100644
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
@@ -519,6 +562,54 @@ static const struct regulator_desc s2mps14_regulators[] = {
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
+		struct s2mps11_info *s2mps11, struct of_regulator_match *rdata,
+		const struct regulator_desc *regulators)
+{
+	struct sec_opmode_data *rmode;
+	int i;
+
+	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) * s2mps11->rdev_num,
+			GFP_KERNEL);
+	if (!rmode) {
+		dev_err(&pdev->dev,
+			"could not allocate memory for regulator mode\n");
+		return NULL;
+	}
+
+	for (i = 0; i < s2mps11->rdev_num; i++) {
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
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -581,9 +672,14 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
+	pdata->opmode = s2mps11_pmic_dt_parse_opmode(pdev, s2mps11, rdata,
+				regulators);
+	if (!pdata->opmode)
+		return -ENOMEM;
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
+	s2mps11->opmode = pdata->opmode;
 
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap_pmic;
diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
index c4bfb8edc836..69582ae4c971 100644
--- a/include/linux/mfd/samsung/s2mps14.h
+++ b/include/linux/mfd/samsung/s2mps14.h
@@ -149,4 +149,21 @@ enum s2mps14_regulators {
 #define S2MPS14_LDO_N_VOLTAGES	(S2MPS14_LDO_VSEL_MASK + 1)
 #define S2MPS14_BUCK_N_VOLTAGES (S2MPS14_BUCK_VSEL_MASK + 1)
 
+#define S2MPS14_ENCTRL_SHIFT		6
+#define S2MPS14_ENCTRL_MASK		(0x3 << S2MPS14_ENCTRL_SHIFT)
+
+/*
+ * Values of regulator operation modes match device tree bindings.
+ */
+enum s2mps14_regulator_opmode {
+	S2MPS14_REGULATOR_OPMODE_OFF		= 0,
+	S2MPS14_REGULATOR_OPMODE_ON		= 1,
+	/* Reserved for compatibility with S5M8767 where this
+	 * is a low power mode. */
+	S2MPS14_REGULATOR_OPMODE_RESERVED	= 2,
+	S2MPS14_REGULATOR_OPMODE_SUSPEND	= 3,
+
+	S2MPS14_REGULATOR_OPMODE_MAX,
+};
+
 #endif /*  __LINUX_MFD_S2MPS14_H */
-- 
1.7.9.5

