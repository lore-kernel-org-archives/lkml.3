Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBXKMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:12:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaBXKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:25 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-76-530b1accc046
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 16/16] regulator: max14577: Implement SUSPEND mode for
 MAX77836 LDO-s
Date: Mon, 24 Feb 2014 11:10:41 +0100
Message-id: <1393236641-14977-17-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xy7pnpLiDDRZNE7fYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJbnO5mtVg/
	4zWLA6/Hzll32T02r9Dy2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgEcUVw2Kak5mWWp
	Rfp2CVwZd3d/YSq4r1Txv72JqYFxp2wXIyeHhICJxMK2jYwQtpjEhXvr2boYuTiEBJYySuy4
	vYAZwuljklh5YhszSBWbgLHE5uVLwKpEBLYwSfR++MII4jALPGeU+LhoJjtIlbBAlMT8aZfB
	bBYBVYl9jftYQWxeAQ+JNZPWA03iANqnIDFnkg1ImBMofLflAViJkIC7xLd511kmMPIuYGRY
	xSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESqF92MC4+ZnWIUYCDUYmHV6KaK1iINbGsuDL3
	EKMEB7OSCK8ZL3ewEG9KYmVValF+fFFpTmrxIUYmDk6pBsaWz++mfrs6JXI9n5PHdec9x7pX
	ecWrzzW8WGKgr3vpR1jumocbqnkTZrEIfNy0OP7YSve4Qq6dSmYSBtPXxghszV7Wt1HLMblk
	wlT5hCk97Nur3ETe317xLH1/3TN/9UK9hWmKf39Mvnx1qazeu2t+ugZCXWuTYs/XR7/Lrv4y
	sz9pmz7j9zYlluKMREMt5qLiRACw3l/4MgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77836 LDO regulators support low power mode. In this mode the
maximum load current is 5 mA and the quiescent supply current is 1.5 uA.

This patch adds support for mode REGULATOR_MODE_STANDBY (and NORMAL) to
LDO regulators by implementing the set_mode() and get_mode() operations.
However the necessary regulator constraints (valid modes) are not parsed
by of_regulator_match() so the driver adds them manually.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max14577.c         |   61 ++++++++++++++++++++++++++++++++--
 include/linux/mfd/max14577-private.h |    2 ++
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 6547cb3146e3..79981af198bf 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -18,9 +18,10 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
-#include <linux/regulator/of_regulator.h>
 
 static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 {
@@ -85,6 +86,45 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 			reg_data);
 }
 
+static unsigned int max77836_reg_ldo_get_mode(struct regulator_dev *rdev)
+{
+	u8 reg_data;
+	int err;
+
+	err = max14577_read_reg(rdev->regmap, rdev->desc->enable_reg,
+			&reg_data);
+	if (err) {
+		dev_err(rdev_get_dev(rdev),
+				"Error reading control register for %d: %d\n",
+				rdev_get_id(rdev), err);
+		return REGULATOR_MODE_NORMAL;
+	}
+
+	reg_data &= rdev->desc->enable_mask;
+
+	if (reg_data == MAX77836_CNFG1_LDO_PWRMD_LOW_POWER)
+		return REGULATOR_MODE_STANDBY;
+
+	return REGULATOR_MODE_NORMAL;
+}
+
+static int max77836_reg_ldo_set_mode(struct regulator_dev *rdev,
+		unsigned int mode)
+{
+	switch (mode) {
+	case REGULATOR_MODE_STANDBY:
+		return max14577_update_reg(rdev->regmap,
+				rdev->desc->enable_reg, rdev->desc->enable_mask,
+				MAX77836_CNFG1_LDO_PWRMD_LOW_POWER);
+
+	case REGULATOR_MODE_NORMAL:
+		return regulator_enable_regmap(rdev);
+
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct regulator_ops max14577_safeout_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
@@ -131,7 +171,8 @@ static struct regulator_ops max77836_ldo_ops = {
 	.map_voltage		= regulator_map_voltage_linear,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	/* TODO: add .set_suspend_mode */
+	.get_mode		= max77836_reg_ldo_get_mode,
+	.set_mode		= max77836_reg_ldo_set_mode,
 };
 
 static const struct regulator_desc max77836_supported_regulators[] = {
@@ -198,6 +239,19 @@ static struct of_regulator_match max77836_regulator_matches[] = {
 	{ .name = "LDO2", },
 };
 
+static void
+max77836_regulator_init_constraints(struct of_regulator_match *matches)
+{
+	int i;
+	struct regulation_constraints *c;
+
+	for (i = MAX77836_LDO1; i <= MAX77836_LDO2; i++) {
+		c = &matches[i].init_data->constraints;
+		c->valid_modes_mask = REGULATOR_MODE_NORMAL
+			| REGULATOR_MODE_STANDBY;
+	}
+}
+
 static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
 		enum maxim_device_type dev_type)
 {
@@ -232,6 +286,9 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
 
 	of_node_put(np);
 
+	if (dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+		max77836_regulator_init_constraints(regulator_matches);
+
 	return ret;
 }
 
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 33700662fbb4..5eb164d91625 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -333,6 +333,8 @@ enum max77836_pmic_reg {
 #define MAX77836_CNFG1_LDO_TV_SHIFT		0
 #define MAX77836_CNFG1_LDO_PWRMD_MASK		(0x3 << MAX77836_CNFG1_LDO_PWRMD_SHIFT)
 #define MAX77836_CNFG1_LDO_TV_MASK		(0x3f << MAX77836_CNFG1_LDO_TV_SHIFT)
+/* Value to write to CONFIG1/PWRMD field for enabling low power mode */
+#define MAX77836_CNFG1_LDO_PWRMD_LOW_POWER	BIT(MAX77836_CNFG1_LDO_PWRMD_SHIFT)
 
 /* LDO1/LDO2 CONFIG2 register */
 #define MAX77836_CNFG2_LDO_OVCLMPEN_SHIFT	7
-- 
1.7.9.5

