Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3BDML6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:11:58 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48166 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3BDL41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:27 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 21/73] regulator: ab8500-ext: Add VextSupply2 regulator
Date: Mon,  4 Feb 2013 11:53:36 +0000
Message-Id: <1359978868-28736-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove suspend-force settings of VextSupply2 and
add VextSupply2 in the external regulator driver.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   63 ++++++++++++++++++++++++-
 drivers/regulator/ab8500-ext.c                |   18 +++++++
 include/linux/regulator/ab8500.h              |    1 +
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 38b70d7..5fd8a59 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -280,12 +280,12 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	INIT_REGULATOR_REGISTER(AB8500_VREFDDR,                0x03, 0x00),
 	/*
 	 * VextSupply1Regu          = force LP
-	 * VextSupply2Regu          = HW control
+	 * VextSupply2Regu          = force OFF
 	 * VextSupply3Regu          = force HP (-> STBB2=LP and TPS=LP)
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1b),
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x13),
 	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
@@ -453,6 +453,11 @@ static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
 	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
 };
 
+/* extended configuration for VextSupply2, only used for HREFP_V20 boards */
+static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 = {
+	.hwreq = true,
+};
+
 /*
  * AB8500 external regulators
  */
@@ -468,6 +473,14 @@ static struct regulator_init_data ab8500_ext_regulators[] = {
 			.always_on = 1,
 		},
 	},
+	/* fixed Vbat supplies VSMPS2_EXT_1V36 and VSMPS5_EXT_1V15 */
+	[AB8500_EXT_SUPPLY2] = {
+		.constraints = {
+			.name = "ab8500-ext-supply2",
+			.min_uV = 1360000,
+			.max_uV = 1360000,
+		},
+	},
 	/* fixed Vbat supplies VSMPS3_EXT_3V4 and VSMPS4_EXT_3V4 */
 	[AB8500_EXT_SUPPLY3] = {
 		.constraints = {
@@ -492,6 +505,24 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
 
+static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
+		if (ab8500_reg_init[i].id == id) {
+			u8 initval = ab8500_reg_init[i].value;
+			initval = (initval & ~mask) | (value & mask);
+			ab8500_reg_init[i].value = initval;
+
+			BUG_ON(mask & ~ab8500_reg_init[i].mask);
+			return;
+		}
+	}
+
+	BUG_ON(1);
+}
+
 void mop500_regulator_init(void)
 {
 	struct regulator_init_data *regulator;
@@ -506,4 +537,32 @@ void mop500_regulator_init(void)
 		regulator->constraints.state_mem.disabled = 1;
 		regulator->constraints.state_standby.disabled = 1;
 	}
+
+	/*
+	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
+	 * all HREFP_V20 boards)
+	 */
+	if (cpu_is_u8500v20()) {
+		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
+		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
+
+		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
+		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
+			0x20, 0x20);
+
+		/* VextSupply2 = force HP at initialization */
+		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
+
+		/* enable VextSupply2 during platform active */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.always_on = 1;
+
+		/* disable VextSupply2 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+
+		/* enable VextSupply2 HW control (used in suspend) */
+		regulator->driver_data = (void *)&ab8500_ext_supply2;
+	}
 }
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index a8fe1cb..3af40fd 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -318,6 +318,24 @@ static struct ab8500_ext_regulator_info
 		.update_val_lp		= 0x03,
 		.update_val_hw		= 0x02,
 	},
+	[AB8500_EXT_SUPPLY2] = {
+		.desc = {
+			.name		= "VEXTSUPPLY2",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1360000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_hp		= 0x04,
+		.update_val_lp		= 0x0c,
+		.update_val_hw		= 0x08,
+	},
 	[AB8500_EXT_SUPPLY3] = {
 		.desc = {
 			.name		= "VEXTSUPPLY3",
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 33308ff..0a58db2 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -161,6 +161,7 @@ struct ab8500_ext_regulator_cfg {
 
 enum ab8500_ext_regulator_id {
 	AB8500_EXT_SUPPLY1,
+	AB8500_EXT_SUPPLY2,
 	AB8500_EXT_SUPPLY3,
 	AB8500_NUM_EXT_REGULATORS,
 };
-- 
1.7.9.5

