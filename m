Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaDWOvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:51:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61558 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbaDWOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:51:11 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-61-5357d35be7a2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode for
 MAX77836 LDO-s
Date: Wed, 23 Apr 2014 16:50:39 +0200
Message-id: <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xa7rRl8ODDeasY7U4uFXTYuOM9awW
	Ux8+YbOY9OQ9s8XElZOZLV6/MLQ42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kt1s94
	zeLA6zGh/xOjx85Zd9k9Nq/Q8ti0qpPN4861PWwe804GevRtWcXo8XmTXABHFJdNSmpOZllq
	kb5dAlfG8gfzmQqWKVccO7+DpYHxl2wXIyeHhICJRPu3KewQtpjEhXvr2boYuTiEBJYyStxo
	vMsO4fQxSey/eosVpIpNwFhi8/IlYFUiAt1MEq1rfoJVMQv0MknMuNoKViUsEC3xo30amM0i
	oCrx8cYPZhCbV8Bd4tybGWwQ++QkTh6bDFTDwcEp4CFx+akdSFgIqOTnm4msExh5FzAyrGIU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQICdQvOxgXH7M6xCjAwajEwyuxPCxYiDWxrLgy9xCj
	BAezkgjvkkXhwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYtbSnJFfe3qf03TMl4fW/FNPcNSqW
	K3IUN3YJT9mvF37yJI9vo/bq27E6fg8/vI9Ns+u9vcnvZ/pRyWu/d63U277lR6BiyCN9S75P
	3OHnJY9L+6kpO+40E8+MTeTnKOeZvvLIsUd7H77+tXxXmmV4aOWTnMkaPPznN8b/iLt1+nrW
	zNBPE367K7EUZyQaajEXFScCACJRQV4yAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77836 LDO regulators support low power mode. In this mode the
maximum load current is 5 mA and the quiescent supply current is 1.5 uA.

This patch adds support for mode REGULATOR_MODE_STANDBY (and NORMAL) to
LDO regulators by implementing the set_mode() and get_mode() operations.
However the necessary regulator constraints (valid modes) are not parsed
by of_regulator_match() so the driver adds them manually to the
regulator init_data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max14577.c         | 61 ++++++++++++++++++++++++++++++++++--
 include/linux/mfd/max14577-private.h |  2 ++
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 0ff5a20ac958..b7657d211a5b 100644
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
index 5c842f3b6da5..9b03506b76ff 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -357,6 +357,8 @@ enum max77836_pmic_reg {
 #define MAX77836_CNFG1_LDO_TV_SHIFT		0
 #define MAX77836_CNFG1_LDO_PWRMD_MASK		(0x3 << MAX77836_CNFG1_LDO_PWRMD_SHIFT)
 #define MAX77836_CNFG1_LDO_TV_MASK		(0x3f << MAX77836_CNFG1_LDO_TV_SHIFT)
+/* Value to write to CONFIG1/PWRMD field for enabling low power mode */
+#define MAX77836_CNFG1_LDO_PWRMD_LOW_POWER	BIT(MAX77836_CNFG1_LDO_PWRMD_SHIFT)
 
 /* LDO1/LDO2 CONFIG2 register */
 #define MAX77836_CNFG2_LDO_OVCLMPEN_SHIFT	7
-- 
1.9.1

