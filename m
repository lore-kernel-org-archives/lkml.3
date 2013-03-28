Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3C1QL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:11:57 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60588 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3C1QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:11:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/33] regulator: ab8500-ext: New driver to control external regulators
Date: Thu, 28 Mar 2013 16:11:01 +0000
Message-Id: <1364487093-19551-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ABx500 is capable of controlling three external regulator supplies.
Most commonly on and off are supported, but if an external regulator
chipset or power supply supports high-power and low-power mode settings,
we can control those too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/Makefile       |    2 +-
 drivers/regulator/ab8500-ext.c   |  394 ++++++++++++++++++++++++++++++++++++++
 drivers/regulator/ab8500.c       |   12 +-
 include/linux/regulator/ab8500.h |   28 +++
 4 files changed, 434 insertions(+), 2 deletions(-)
 create mode 100644 drivers/regulator/ab8500-ext.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 6e82503..47a34ff 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
-obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o ab8500-ext.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
new file mode 100644
index 0000000..95008de
--- /dev/null
+++ b/drivers/regulator/ab8500-ext.c
@@ -0,0 +1,394 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Authors: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
+ *
+ * This file is based on drivers/regulator/ab8500.c
+ *
+ * AB8500 external regulators
+ *
+ * ab8500-ext supports the following regulators:
+ * - VextSupply3
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/regulator/ab8500.h>
+
+/**
+ * struct ab8500_ext_regulator_info - ab8500 regulator information
+ * @dev: device pointer
+ * @desc: regulator description
+ * @rdev: regulator device
+ * @is_enabled: status of regulator (on/off)
+ * @update_bank: bank to control on/off
+ * @update_reg: register to control on/off
+ * @update_mask: mask to enable/disable and set mode of regulator
+ * @update_val: bits holding the regulator current mode
+ * @update_val_en: bits to set EN pin active (LPn pin deactive)
+ *                 normally this means high power mode
+ * @update_val_en_lp: bits to set EN pin active and LPn pin active
+ *                    normally this means low power mode
+ * @delay: startup delay in ms
+ */
+struct ab8500_ext_regulator_info {
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *rdev;
+	bool is_enabled;
+	u8 update_bank;
+	u8 update_reg;
+	u8 update_mask;
+	u8 update_val;
+	u8 update_val_en;
+	u8 update_val_en_lp;
+};
+
+static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
+	if (ret < 0)
+		dev_err(rdev_get_dev(info->rdev),
+			"couldn't set enable bits for regulator\n");
+
+	info->is_enabled = true;
+
+	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, info->update_val);
+
+	return ret;
+}
+
+static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
+	if (ret < 0)
+		dev_err(rdev_get_dev(info->rdev),
+			"couldn't set disable bits for regulator\n");
+
+	info->is_enabled = false;
+
+	dev_dbg(rdev_get_dev(rdev), "%s-disable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
+
+	return ret;
+}
+
+static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	int ret;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	ret = abx500_get_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, &regval);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read 0x%x register\n", info->update_reg);
+		return ret;
+	}
+
+	dev_dbg(rdev_get_dev(rdev), "%s-is_enabled (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	if (regval & info->update_mask)
+		info->is_enabled = true;
+	else
+		info->is_enabled = false;
+
+	return info->is_enabled;
+}
+
+static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
+					 unsigned int mode)
+{
+	int ret = 0;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		info->update_val = info->update_val_hp;
+		break;
+	case REGULATOR_MODE_IDLE:
+		info->update_val = info->update_val_lp;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (info->is_enabled) {
+		u8 regval;
+
+		ret = enable(info, &regval);
+		if (ret < 0)
+			dev_err(rdev_get_dev(rdev),
+				"Could not set regulator mode.\n");
+
+		dev_dbg(rdev_get_dev(rdev),
+			"%s-set_mode (bank, reg, mask, value): "
+			"0x%x, 0x%x, 0x%x, 0x%x\n",
+			info->desc.name, info->update_bank, info->update_reg,
+			info->update_mask, regval);
+	}
+
+	return ret;
+}
+
+static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
+{
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (info->update_val == info->update_val_hp)
+		ret = REGULATOR_MODE_NORMAL;
+	else if (info->update_val == info->update_val_lp)
+		ret = REGULATOR_MODE_IDLE;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
+{
+	struct regulation_constraints *regu_constraints = rdev->constraints;
+
+	if (regu_constraints == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
+		return -EINVAL;
+	}
+	if (regu_constraints->min_uV && regu_constraints->max_uV) {
+		if (regu_constraints->min_uV == regu_constraints->max_uV)
+			return regu_constraints->min_uV;
+	}
+	return -EINVAL;
+}
+
+static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
+				   unsigned selector)
+{
+	struct regulation_constraints *regu_constraints = rdev->constraints;
+
+	if (regu_constraints == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
+		return -EINVAL;
+	}
+	/* return the uV for the fixed regulators */
+	if (regu_constraints->min_uV && regu_constraints->max_uV) {
+		if (regu_constraints->min_uV == regu_constraints->max_uV)
+			return regu_constraints->min_uV;
+	}
+	return -EINVAL;
+}
+
+static struct regulator_ops ab8500_ext_regulator_ops = {
+	.enable			= ab8500_ext_regulator_enable,
+	.disable		= ab8500_ext_regulator_disable,
+	.is_enabled		= ab8500_ext_regulator_is_enabled,
+	.set_mode		= ab8500_ext_regulator_set_mode,
+	.get_mode		= ab8500_ext_regulator_get_mode,
+	.get_voltage		= ab8500_ext_fixed_get_voltage,
+	.list_voltage		= ab8500_ext_list_voltage,
+};
+
+
+static struct ab8500_ext_regulator_info
+		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
+	[AB8500_EXT_SUPPLY1] = {
+		.desc = {
+			.name		= "VEXTSUPPLY1",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_hp		= 0x01,
+		.update_val_lp		= 0x03,
+		.update_val_hw		= 0x02,
+	},
+	[AB8500_EXT_SUPPLY2] = {
+		.desc = {
+			.name		= "VEXTSUPPLY2",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_hp		= 0x04,
+		.update_val_lp		= 0x0c,
+		.update_val_hw		= 0x08,
+	},
+	[AB8500_EXT_SUPPLY3] = {
+		.desc = {
+			.name		= "VEXTSUPPLY3",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x30,
+		.update_val		= 0x10,
+		.update_val_en		= 0x10,
+		.update_val_en_lp	= 0x30,
+	},
+};
+
+int ab8500_ext_regulator_init(struct platform_device *pdev)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *ppdata;
+	struct ab8500_regulator_platform_data *pdata;
+	struct regulator_config config = { };
+	int i, err;
+
+	if (!ab8500) {
+		dev_err(&pdev->dev, "null mfd parent\n");
+		return -EINVAL;
+	}
+	ppdata = dev_get_platdata(ab8500->dev);
+	if (!ppdata) {
+		dev_err(&pdev->dev, "null parent pdata\n");
+		return -EINVAL;
+	}
+
+	pdata = ppdata->regulator;
+	if (!pdata) {
+		dev_err(&pdev->dev, "null pdata\n");
+		return -EINVAL;
+	}
+
+	/* make sure the platform data has the correct size */
+	if (pdata->num_ext_regulator != ARRAY_SIZE(ab8500_ext_regulator_info)) {
+		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
+		return -EINVAL;
+	}
+
+	/* check for AB8500 2.x */
+	if (abx500_get_chip_id(&pdev->dev) < 0x30) {
+		struct ab8500_ext_regulator_info *info;
+
+		/* VextSupply3LPn is inverted on AB8500 2.x */
+		info = &ab8500_ext_regulator_info[AB8500_EXT_SUPPLY3];
+		info->update_val = 0x30;
+		info->update_val_en = 0x30;
+		info->update_val_en_lp = 0x10;
+	}
+
+	/* register all regulators */
+	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
+		struct ab8500_ext_regulator_info *info = NULL;
+
+		/* assign per-regulator data */
+		info = &ab8500_ext_regulator_info[i];
+		info->dev = &pdev->dev;
+
+		config.dev = &pdev->dev;
+		config.init_data = &pdata->ext_regulator[i];
+		config.driver_data = info;
+
+		/* register regulator with framework */
+		info->rdev = regulator_register(&info->desc, &config);
+
+		if (IS_ERR(info->rdev)) {
+			err = PTR_ERR(info->rdev);
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+					info->desc.name);
+			/* when we fail, un-register all earlier regulators */
+			while (--i >= 0) {
+				info = &ab8500_ext_regulator_info[i];
+				regulator_unregister(info->rdev);
+			}
+			return err;
+		}
+
+		dev_dbg(rdev_get_dev(info->rdev),
+			"%s-probed\n", info->desc.name);
+	}
+
+	return 0;
+}
+
+int ab8500_ext_regulator_exit(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
+		struct ab8500_ext_regulator_info *info = NULL;
+		info = &ab8500_ext_regulator_info[i];
+
+		dev_vdbg(rdev_get_dev(info->rdev),
+			"%s-remove\n", info->desc.name);
+
+		regulator_unregister(info->rdev);
+	}
+
+	return 0;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Bengt Jonsson <bengt.g.jonsson@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 external regulator driver");
+MODULE_ALIAS("platform:ab8500-ext-regulator");
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3a18966..4974688 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -947,6 +947,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 	}
 
+	/* register external regulators (before Vaux1, 2 and 3) */
+	err = ab8500_ext_regulator_init(pdev);
+	if (err)
+		return err;
+
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		err = ab8500_regulator_register(pdev, &pdata->regulator[i], i, NULL);
@@ -959,7 +964,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		struct ab8500_regulator_info *info = NULL;
@@ -971,6 +976,11 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 		regulator_unregister(info->regulator);
 	}
 
+	/* remove external regulators (after Vaux1, 2 and 3) */
+	err = ab8500_ext_regulator_exit(pdev);
+	if (err)
+		return err;
+
 	return 0;
 }
 
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 26792ff..4e92e5b 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_MFD_AB8500_REGULATOR_H
 #define __LINUX_MFD_AB8500_REGULATOR_H
 
+#include <linux/platform_device.h>
+
 /* AB8500 regulators */
 enum ab8500_regulator_id {
 	AB8500_LDO_AUX1,
@@ -140,11 +142,37 @@ enum ab9540_regulator_reg {
 	AB9540_NUM_REGULATOR_REGISTERS,
 };
 
+/* AB8500 external regulators */
+enum ab8500_ext_regulator_id {
+	AB8500_EXT_SUPPLY1,
+	AB8500_EXT_SUPPLY2,
+	AB8500_EXT_SUPPLY3,
+	AB8500_NUM_EXT_REGULATORS,
+};
+
+/* AB8500 regulator platform data */
 struct ab8500_regulator_platform_data {
 	int num_reg_init;
 	struct ab8500_regulator_reg_init *reg_init;
 	int num_regulator;
 	struct regulator_init_data *regulator;
+	int num_ext_regulator;
+	struct regulator_init_data *ext_regulator;
 };
 
+/* AB8500 external regulator functions (internal) */
+#ifdef CONFIG_REGULATOR_AB8500_EXT
+int ab8500_ext_regulator_init(struct platform_device *pdev);
+int ab8500_ext_regulator_exit(struct platform_device *pdev);
+#else
+inline int ab8500_ext_regulator_init(struct platform_device *pdev)
+{
+	return 0;
+}
+inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 #endif
-- 
1.7.10.4

