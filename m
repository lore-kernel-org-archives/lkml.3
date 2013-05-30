Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab3E3K5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:57:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46112 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473Ab3E3K5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:57:07 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <ian@slimlogic.co.uk>
CC: <kishon@ti.com>, <balbi@ti.com>
Subject: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
Date: Thu, 30 May 2013 16:26:33 +0530
Message-ID: <1369911393-25747-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMPS10 supports different modes such as BOOST mode, BYPASS mode and
SWITCH. Inorder to configure SMPS10 in these modes,
added palmas_set_mode_smps10() and palmas_get_mode_smps10() for the
consumers of SMPS10 to configure it accordingly.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Only compile tested. Just sent a patch to get some comments
/ideas on how to handle such one off regulators.
to handle
 drivers/regulator/palmas-regulator.c |   46 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h           |    1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 87d4f13..d8d37f2 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -355,6 +355,50 @@ static unsigned int palmas_get_mode_smps(struct regulator_dev *dev)
 	return 0;
 }
 
+static int palmas_set_mode_smps10(struct regulator_dev *dev, unsigned int mode)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+	reg &= ~PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK;
+
+	if (mode == REGULATOR_MODE_NORMAL)
+		reg |= SMPS10_BOOST_EN;
+
+	if (mode == REGULATOR_MODE_FAST)
+		reg |= SMPS10_SWITCH_EN;
+
+	if (mode == REGULATOR_MODE_IDLE)
+		reg |= SMPS10_BYPASS_EN;
+
+	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+	return 0;
+}
+
+static unsigned int palmas_get_mode_smps10(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+	int ret = 0;
+
+	reg = pmic->current_reg_mode[id] &
+		PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK;
+
+	if (reg == SMPS10_BOOST_EN)
+		ret |= REGULATOR_MODE_NORMAL;
+
+	if (reg == SMPS10_SWITCH_EN)
+		ret |= REGULATOR_MODE_FAST;
+
+	if (reg == SMPS10_BYPASS_EN)
+		ret |= REGULATOR_MODE_IDLE;
+
+	return ret;
+}
+
 static int palmas_list_voltage_smps(struct regulator_dev *dev,
 					unsigned selector)
 {
@@ -483,6 +527,8 @@ static struct regulator_ops palmas_ops_smps10 = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
+	.set_mode		= palmas_set_mode_smps10,
+	.get_mode		= palmas_get_mode_smps10,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear,
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 8f21daf..4ad2b65 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -846,6 +846,7 @@ enum usb_irq_events {
 #define PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK			0xf0
 #define PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT			4
 #define PALMAS_SMPS10_CTRL_MODE_ACTIVE_MASK			0x0f
+#define PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK		0x07
 #define PALMAS_SMPS10_CTRL_MODE_ACTIVE_SHIFT			0
 
 /* Bit definitions for SMPS10_STATUS */
-- 
1.7.10.4

