Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3BDL4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64688 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3BDL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/73] regulator: ab8500-ext: Add HW request support
Date: Mon,  4 Feb 2013 11:53:32 +0000
Message-Id: <1359978868-28736-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Support for HW request is added in the external regulator
driver. A flag in the board configuration can be set to
let HW control the regulator when there is no SW request.
This means that the regulator will be put in high power
mode when there is a SW request and in HW-request mode
otherwise.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias NILSSON <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500-ext.c   |   98 +++++++++++++++++++++++++++-----------
 include/linux/regulator/ab8500.h |    4 ++
 2 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index aa55a05..5cb7d9c 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -29,82 +29,123 @@
  * @dev: device pointer
  * @desc: regulator description
  * @rdev: regulator device
+ * @cfg: regulator configuration (extension of regulator FW configuration)
  * @is_enabled: status of regulator (on/off)
  * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable and set mode of regulator
  * @update_val: bits holding the regulator current mode
- * @update_val_en: bits to set EN pin active (LPn pin deactive)
+ * @update_val_hp: bits to set EN pin active (LPn pin deactive)
  *                 normally this means high power mode
- * @update_val_en_lp: bits to set EN pin active and LPn pin active
- *                    normally this means low power mode
- * @delay: startup delay in ms
+ * @update_val_lp: bits to set EN pin active and LPn pin active
+ *                 normally this means low power mode
+ * @update_val_hw: bits to set regulator pins in HW control
+ *                 SysClkReq pins and logic will choose mode
  */
 struct ab8500_ext_regulator_info {
 	struct device *dev;
 	struct regulator_desc desc;
 	struct regulator_dev *rdev;
+	struct ab8500_ext_regulator_cfg *cfg;
 	bool is_enabled;
 	int fixed_uV;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
 	u8 update_val;
-	u8 update_val_en;
-	u8 update_val_en_lp;
+	u8 update_val_hp;
+	u8 update_val_lp;
+	u8 update_val_hw;
 };
 
-static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
+static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
 {
 	int ret;
-	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
 
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
+	*regval = info->update_val;
+
+	/*
+	 * To satisfy both HW high power request and SW request, the regulator
+	 * must be on in high power.
+	 */
+	if (info->cfg && info->cfg->hwreq)
+		*regval = info->update_val_hp;
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
-		info->update_mask, info->update_val);
+		info->update_mask, *regval);
 	if (ret < 0)
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set enable bits for regulator\n");
 
 	info->is_enabled = true;
 
-	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
-		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, info->update_val);
-
 	return ret;
 }
 
-static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
+static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
 	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
 	}
 
+	ret = enable(info, &regval);
+
+	dev_dbg(rdev_get_dev(rdev), "%s-enable (bank, reg, mask, value):"
+		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	return ret;
+}
+
+static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
+{
+	int ret;
+
+	*regval = 0x0;
+
+	/*
+	 * Set the regulator in HW request mode if configured
+	 */
+	if (info->cfg && info->cfg->hwreq)
+		*regval = info->update_val_hw;
+
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
-		info->update_mask, 0x0);
+		info->update_mask, *regval);
 	if (ret < 0)
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set disable bits for regulator\n");
 
 	info->is_enabled = false;
 
+	return ret;
+}
+
+static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
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
+	ret = disable(info, &regval);
+
 	dev_dbg(rdev_get_dev(rdev), "%s-disable (bank, reg, mask, value):"
 		" 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
 		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, 0x0);
+		info->update_mask, regval);
 
 	return ret;
 }
@@ -133,7 +174,8 @@ static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
 		info->desc.name, info->update_bank, info->update_reg,
 		info->update_mask, regval);
 
-	if (regval & info->update_mask)
+	if (((regval & info->update_mask) == info->update_val_lp) ||
+	    ((regval & info->update_mask) == info->update_val_hp))
 		info->is_enabled = true;
 	else
 		info->is_enabled = false;
@@ -178,7 +220,6 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 	.list_voltage		= ab8500_ext_list_voltage,
 };
 
-
 static struct ab8500_ext_regulator_info
 		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
 	[AB8500_EXT_SUPPLY3] = {
@@ -195,8 +236,9 @@ static struct ab8500_ext_regulator_info
 		.update_reg		= 0x08,
 		.update_mask		= 0x30,
 		.update_val		= 0x10,
-		.update_val_en		= 0x10,
-		.update_val_en_lp	= 0x30,
+		.update_val_hp		= 0x10,
+		.update_val_lp		= 0x30,
+		.update_val_hw		= 0x20,
 	},
 };
 
@@ -236,8 +278,8 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		/* VextSupply3LPn is inverted on AB8500 2.x */
 		info = &ab8500_ext_regulator_info[AB8500_EXT_SUPPLY3];
 		info->update_val = 0x30;
-		info->update_val_en = 0x30;
-		info->update_val_en_lp = 0x10;
+		info->update_val_hp = 0x30;
+		info->update_val_lp = 0x10;
 	}
 
 	/* register all regulators */
@@ -247,6 +289,8 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		/* assign per-regulator data */
 		info = &ab8500_ext_regulator_info[i];
 		info->dev = &pdev->dev;
+		info->cfg = (struct ab8500_ext_regulator_cfg *)
+			pdata->ext_regulator[i].driver_data;
 
 		/* register regulator with framework */
 		info->rdev = regulator_register(&info->desc, &pdev->dev,
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index e9522c9..7436bdb 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -155,6 +155,10 @@ enum ab9540_regulator_reg {
 };
 
 /* AB8500 external regulators */
+struct ab8500_ext_regulator_cfg {
+	bool hwreq; /* requires hw mode or high power mode */
+};
+
 enum ab8500_ext_regulator_id {
 	AB8500_EXT_SUPPLY3,
 	AB8500_NUM_EXT_REGULATORS,
-- 
1.7.9.5

