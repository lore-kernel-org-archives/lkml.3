Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaEZNVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:21:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47409 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaEZNVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:21:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fa-53833fc5f4ee
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] regulator: s2mps11: Refactor setting ramp delay
Date: Mon, 26 May 2014 15:20:21 +0200
Message-id: <1401110423-5647-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
References: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xq7pH7ZuDDd4cVrXYOGM9q8XUh0/Y
	LOYfOcdq8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBYzzu9jslh75C67xck/vYwWF1d8YbJY
	P+M1iwOvx85Zd9k9Nq3qZPO4c20Pm0ffllWMHp83yQWwRnHZpKTmZJalFunbJXBlPNnzjbHg
	UWzF9suHWRsY/3h3MXJySAiYSLy8/ZQZwhaTuHBvPVsXIxeHkMBSRolde7sYIZw+JonpS/+z
	gVSxCRhLbF6+BKxKROAGo8TxaZeB2jk4mAVWMEncdwapERZwkfjS0sYCYrMIqEoc7PzJCGLz
	CrhJvD7ynB1im5zEyWOTWUFsTgF3ieu3j4HVCwHVPLg7mWUCI+8CRoZVjKKppckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGCEB+WUH4+JjVocYBTgYlXh4TwQ1BQuxJpYVV+YeYpTgYFYS4dXibA4W
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDjRebNn2MZ3O7Y4zXW+EP/laHmJo8D+lPCDB7caNLUJ
	x9hutM/btLD2U5/IvdBvGf9yjXkanqvPZyj81Ldmam6tfcexqlJ9A7YWvXmJipcdhWqe8HSb
	Rr2I8tp6/Oa5ZMvv5fc0LqZ921rwa2n43U0Bjw503tSuV2JxWvLS+v2R3bMy0m4VqCuxFGck
	GmoxFxUnAgAnSY1zJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for merging the s2mpa01 regulator driver into s2mps11 by:
1. Adding common id for buck regulators.
2. Splitting shared ramp delay settings to match S2MPA01.
3. Adding a configuration of registers for setting ramp delay for each
   buck regulator.

The functionality of the driver should not change as this patch only
prepares for supporting S2MPA01 device.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c | 210 ++++++++++++++++++++++++++++++--------------
 1 file changed, 144 insertions(+), 66 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 02e2fb2fca66..fa12d75b784f 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -32,13 +32,32 @@
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
 
+/*
+ * Enum used as a common id of buck regulators on S2MPA01 and S2MPS11.
+ */
+enum s2mpx_bucks {
+	S2MPX_BUCK1,
+	S2MPX_BUCK2,
+	S2MPX_BUCK3,
+	S2MPX_BUCK4,
+	S2MPX_BUCK5,
+	S2MPX_BUCK6,
+	S2MPX_BUCK7,
+	S2MPX_BUCK8,
+	S2MPX_BUCK9,
+	S2MPX_BUCK10,
+};
+
 struct s2mps11_info {
+	enum sec_device_type dev_type;
 	unsigned int rdev_num;
 	int ramp_delay2;
-	int ramp_delay34;
+	int ramp_delay3;
+	int ramp_delay4;
 	int ramp_delay5;
 	int ramp_delay16;
-	int ramp_delay7810;
+	int ramp_delay7;
+	int ramp_delay810;
 	int ramp_delay9;
 	/*
 	 * One bit for each S2MPS14 regulator whether the suspend mode
@@ -49,6 +68,47 @@ struct s2mps11_info {
 	int *ext_control_gpio;
 };
 
+/*
+ * Description of ramp delay register for one buck regulator
+ * on S2MPA01 and S2MPS11.
+ */
+struct s2mpx_ramp_reg {
+	unsigned int ramp_shift;
+	unsigned int ramp_reg;
+	unsigned int enable_shift;
+	bool enable_supported;
+};
+
+#define s2mps11_ramp_reg(r_shift) {					\
+	.ramp_shift		= S2MPS11_ ## r_shift ## _RAMP_SHIFT,	\
+	.ramp_reg		= S2MPS11_REG_RAMP_BUCK,		\
+	.enable_shift		= 0,					\
+	.enable_supported	= false,				\
+}
+#define s2mps11_buck2346_ramp_reg(r_shift, r_reg, e_shift) {		\
+	.ramp_shift		= S2MPS11_ ## r_shift ## _RAMP_SHIFT,	\
+	.ramp_reg		= S2MPS11_REG_ ## r_reg,		\
+	.enable_shift		= S2MPS11_ ## e_shift ## _RAMP_EN_SHIFT,\
+	.enable_supported	= true,					\
+}
+
+static const struct s2mpx_ramp_reg s2mps11_ramp_regs[] = {
+	[S2MPX_BUCK1]	= s2mps11_ramp_reg(BUCK16),
+	[S2MPX_BUCK2]	= s2mps11_buck2346_ramp_reg(BUCK2, RAMP, BUCK2),
+	[S2MPX_BUCK3]	= s2mps11_buck2346_ramp_reg(BUCK34, RAMP, BUCK3),
+	[S2MPX_BUCK4]	= s2mps11_buck2346_ramp_reg(BUCK34, RAMP, BUCK4),
+	[S2MPX_BUCK5]	= s2mps11_ramp_reg(BUCK5),
+	[S2MPX_BUCK6]	= s2mps11_buck2346_ramp_reg(BUCK16, RAMP_BUCK, BUCK6),
+	[S2MPX_BUCK7]	= s2mps11_ramp_reg(BUCK7810),
+	[S2MPX_BUCK8]	= s2mps11_ramp_reg(BUCK7810),
+	[S2MPX_BUCK9]	= s2mps11_ramp_reg(BUCK9),
+	[S2MPX_BUCK10]	= s2mps11_ramp_reg(BUCK7810),
+};
+
+static const struct s2mpx_ramp_reg * const s2mpx_ramp_regs[] = {
+	[S2MPS11X] = s2mps11_ramp_regs,
+};
+
 static int get_ramp_delay(int ramp_delay)
 {
 	unsigned char cnt = 0;
@@ -68,6 +128,23 @@ static int get_ramp_delay(int ramp_delay)
 	return cnt;
 }
 
+/*
+ * Maps a buck regulator id to enum s2mpx_bucks.
+ * Valid only for buck regulators on on S2MPS11.
+ *
+ * Returns a value of enum s2mpx_bucks or -EINVAL.
+ */
+static int get_s2mpx_buck_id(enum sec_device_type dev_type,
+		int rdev_id)
+{
+	switch (dev_type) {
+	case S2MPS11X:
+		return rdev_id - S2MPS11_BUCK1;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 				   unsigned int old_selector,
 				   unsigned int new_selector)
@@ -75,29 +152,40 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
 	unsigned int ramp_delay = 0;
 	int old_volt, new_volt;
+	int buck_id = get_s2mpx_buck_id(s2mps11->dev_type, rdev_get_id(rdev));
 
-	switch (rdev_get_id(rdev)) {
-	case S2MPS11_BUCK2:
+	switch (buck_id) {
+	case S2MPX_BUCK2:
 		ramp_delay = s2mps11->ramp_delay2;
 		break;
-	case S2MPS11_BUCK3:
-	case S2MPS11_BUCK4:
-		ramp_delay = s2mps11->ramp_delay34;
+	case S2MPX_BUCK3:
+		ramp_delay = s2mps11->ramp_delay3;
 		break;
-	case S2MPS11_BUCK5:
+	case S2MPX_BUCK4:
+		ramp_delay = s2mps11->ramp_delay4;
+		break;
+	case S2MPX_BUCK5:
 		ramp_delay = s2mps11->ramp_delay5;
 		break;
-	case S2MPS11_BUCK6:
-	case S2MPS11_BUCK1:
+	case S2MPX_BUCK6:
+	case S2MPX_BUCK1:
 		ramp_delay = s2mps11->ramp_delay16;
 		break;
-	case S2MPS11_BUCK7:
-	case S2MPS11_BUCK8:
-	case S2MPS11_BUCK10:
-		ramp_delay = s2mps11->ramp_delay7810;
+	case S2MPX_BUCK7:
+		ramp_delay = s2mps11->ramp_delay7;
 		break;
-	case S2MPS11_BUCK9:
+	case S2MPX_BUCK8:
+	case S2MPX_BUCK10:
+		ramp_delay = s2mps11->ramp_delay810;
+		break;
+	case S2MPX_BUCK9:
 		ramp_delay = s2mps11->ramp_delay9;
+		break;
+	default:
+		dev_err(rdev_get_dev(rdev),
+				"Wrong regulator id %d for set_voltage_time_sel\n",
+				rdev_get_id(rdev));
+		return -EINVAL;
 	}
 
 	if (ramp_delay == 0)
@@ -112,66 +200,55 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
-	unsigned int ramp_val, ramp_shift, ramp_reg = S2MPS11_REG_RAMP_BUCK;
-	unsigned int ramp_enable = 1, enable_shift = 0;
+	const struct s2mpx_ramp_reg *ramp_reg;
+	unsigned int ramp_val;
+	unsigned int ramp_enable = 1;
+	int buck_id;
 	int ret;
 
-	switch (rdev_get_id(rdev)) {
-	case S2MPS11_BUCK1:
+	buck_id = get_s2mpx_buck_id(s2mps11->dev_type, rdev_get_id(rdev));
+
+	switch (buck_id) {
+	case S2MPX_BUCK1:
 		if (ramp_delay > s2mps11->ramp_delay16)
 			s2mps11->ramp_delay16 = ramp_delay;
 		else
 			ramp_delay = s2mps11->ramp_delay16;
-
-		ramp_shift = S2MPS11_BUCK16_RAMP_SHIFT;
 		break;
-	case S2MPS11_BUCK2:
-		enable_shift = S2MPS11_BUCK2_RAMP_EN_SHIFT;
+	case S2MPX_BUCK2:
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
 		}
 
 		s2mps11->ramp_delay2 = ramp_delay;
-		ramp_shift = S2MPS11_BUCK2_RAMP_SHIFT;
-		ramp_reg = S2MPS11_REG_RAMP;
 		break;
-	case S2MPS11_BUCK3:
-		enable_shift = S2MPS11_BUCK3_RAMP_EN_SHIFT;
+	case S2MPX_BUCK3:
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
 		}
 
-		if (ramp_delay > s2mps11->ramp_delay34)
-			s2mps11->ramp_delay34 = ramp_delay;
+		if (ramp_delay > s2mps11->ramp_delay3)
+			s2mps11->ramp_delay3 = ramp_delay;
 		else
-			ramp_delay = s2mps11->ramp_delay34;
-
-		ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
-		ramp_reg = S2MPS11_REG_RAMP;
+			ramp_delay = s2mps11->ramp_delay3;
 		break;
 	case S2MPS11_BUCK4:
-		enable_shift = S2MPS11_BUCK4_RAMP_EN_SHIFT;
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
 		}
 
-		if (ramp_delay > s2mps11->ramp_delay34)
-			s2mps11->ramp_delay34 = ramp_delay;
+		if (ramp_delay > s2mps11->ramp_delay4)
+			s2mps11->ramp_delay4 = ramp_delay;
 		else
-			ramp_delay = s2mps11->ramp_delay34;
-
-		ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
-		ramp_reg = S2MPS11_REG_RAMP;
+			ramp_delay = s2mps11->ramp_delay4;
 		break;
 	case S2MPS11_BUCK5:
 		s2mps11->ramp_delay5 = ramp_delay;
-		ramp_shift = S2MPS11_BUCK5_RAMP_SHIFT;
 		break;
 	case S2MPS11_BUCK6:
-		enable_shift = S2MPS11_BUCK6_RAMP_EN_SHIFT;
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
@@ -181,36 +258,37 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 			s2mps11->ramp_delay16 = ramp_delay;
 		else
 			ramp_delay = s2mps11->ramp_delay16;
-
-		ramp_shift = S2MPS11_BUCK16_RAMP_SHIFT;
 		break;
 	case S2MPS11_BUCK7:
+		if (ramp_delay > s2mps11->ramp_delay7)
+			s2mps11->ramp_delay7 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay7;
+		break;
 	case S2MPS11_BUCK8:
 	case S2MPS11_BUCK10:
-		if (ramp_delay > s2mps11->ramp_delay7810)
-			s2mps11->ramp_delay7810 = ramp_delay;
+		if (ramp_delay > s2mps11->ramp_delay810)
+			s2mps11->ramp_delay810 = ramp_delay;
 		else
-			ramp_delay = s2mps11->ramp_delay7810;
-
-		ramp_shift = S2MPS11_BUCK7810_RAMP_SHIFT;
+			ramp_delay = s2mps11->ramp_delay810;
 		break;
 	case S2MPS11_BUCK9:
 		s2mps11->ramp_delay9 = ramp_delay;
-		ramp_shift = S2MPS11_BUCK9_RAMP_SHIFT;
 		break;
 	default:
 		return 0;
 	}
 
+	ramp_reg = &s2mpx_ramp_regs[s2mps11->dev_type][buck_id];
+
 	if (!ramp_enable)
 		goto ramp_disable;
 
 	/* Ramp delay can be enabled/disabled only for buck[2346] */
-	if ((rdev_get_id(rdev) >= S2MPS11_BUCK2 &&
-			rdev_get_id(rdev) <= S2MPS11_BUCK4) ||
-			rdev_get_id(rdev) == S2MPS11_BUCK6)  {
+	if (ramp_reg->enable_supported) {
 		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-					 1 << enable_shift, 1 << enable_shift);
+					 1 << ramp_reg->enable_shift,
+					 1 << ramp_reg->enable_shift);
 		if (ret) {
 			dev_err(&rdev->dev, "failed to enable ramp rate\n");
 			return ret;
@@ -219,12 +297,13 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 
 	ramp_val = get_ramp_delay(ramp_delay);
 
-	return regmap_update_bits(rdev->regmap, ramp_reg, 0x3 << ramp_shift,
-				  ramp_val << ramp_shift);
+	return regmap_update_bits(rdev->regmap, ramp_reg->ramp_reg,
+				0x3 << ramp_reg->ramp_shift,
+				ramp_val << ramp_reg->ramp_shift);
 
 ramp_disable:
 	return regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-				  1 << enable_shift, 0);
+				  1 << ramp_reg->enable_shift, 0);
 }
 
 static struct regulator_ops s2mps11_ldo_ops = {
@@ -250,7 +329,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.set_ramp_delay		= s2mps11_set_ramp_delay,
 };
 
-#define regulator_desc_s2mps11_ldo1(num)	{		\
+#define regulator_desc_s2mps11_ldo1(num) {		\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS11_LDO##num,		\
 	.ops		= &s2mps11_ldo_ops,		\
@@ -605,8 +684,7 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 }
 
 static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
-		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11,
-		enum sec_device_type dev_type)
+		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11)
 {
 	struct device_node *reg_np;
 
@@ -617,7 +695,7 @@ static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
-	if (dev_type == S2MPS14X)
+	if (s2mps11->dev_type == S2MPS14X)
 		s2mps14_pmic_dt_parse_ext_control_gpio(pdev, rdata, s2mps11);
 
 	of_node_put(reg_np);
@@ -634,15 +712,14 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	struct s2mps11_info *s2mps11;
 	int i, ret = 0;
 	const struct regulator_desc *regulators;
-	enum sec_device_type dev_type;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
-	dev_type = platform_get_device_id(pdev)->driver_data;
-	switch (dev_type) {
+	s2mps11->dev_type = platform_get_device_id(pdev)->driver_data;
+	switch (s2mps11->dev_type) {
 	case S2MPS11X:
 		s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
 		regulators = s2mps11_regulators;
@@ -652,7 +729,8 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		regulators = s2mps14_regulators;
 		break;
 	default:
-		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
+		dev_err(&pdev->dev, "Invalid device type: %u\n",
+				s2mps11->dev_type);
 		return -EINVAL;
 	};
 
@@ -686,7 +764,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
-	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11, dev_type);
+	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11);
 	if (ret)
 		goto out;
 
-- 
1.9.1

