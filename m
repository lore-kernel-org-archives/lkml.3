Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3BDL43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:29 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49166 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3BDL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:26 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 20/73] regulator: ab8500-ext: Add VextSupply1 regulator
Date: Mon,  4 Feb 2013 11:53:35 +0000
Message-Id: <1359978868-28736-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove suspend-force settings of VextSupply1 and add VextSupply1
in the external regulator driver.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   32 +++++++++++++++++++++++--
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 ++
 drivers/regulator/ab8500-ext.c                |   18 ++++++++++++++
 include/linux/regulator/ab8500.h              |    1 +
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 72fb449..38b70d7 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
+#include <mach/id.h> /* to identify older boards for fixes */
 #include "board-mop500-regulators.h"
 
 static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
@@ -278,13 +279,13 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VREFDDR,                0x03, 0x00),
 	/*
-	 * VextSupply1Regu          = HW control
+	 * VextSupply1Regu          = force LP
 	 * VextSupply2Regu          = HW control
 	 * VextSupply3Regu          = force HP (-> STBB2=LP and TPS=LP)
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1a),
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1b),
 	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
@@ -456,6 +457,17 @@ static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
  * AB8500 external regulators
  */
 static struct regulator_init_data ab8500_ext_regulators[] = {
+	/* fixed Vbat supplies VSMPS1_EXT_1V8 */
+	[AB8500_EXT_SUPPLY1] = {
+		.constraints = {
+			.name = "ab8500-ext-supply1",
+			.min_uV = 1800000,
+			.max_uV = 1800000,
+			.initial_mode = REGULATOR_MODE_IDLE,
+			.boot_on = 1,
+			.always_on = 1,
+		},
+	},
 	/* fixed Vbat supplies VSMPS3_EXT_3V4 and VSMPS4_EXT_3V4 */
 	[AB8500_EXT_SUPPLY3] = {
 		.constraints = {
@@ -479,3 +491,19 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.ext_regulator          = ab8500_ext_regulators,
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
+
+void mop500_regulator_init(void)
+{
+	struct regulator_init_data *regulator;
+
+	/*
+	 * Handle VextSupply1 on older boards than HREFP_V22_V1x
+	 * (turn off in suspend)
+	 */
+	if (cpu_is_u8500v20() || cpu_is_u8500v21()) {
+		/* disable VextSupply1 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY1];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+	}
+}
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9ca4869..3d4c412 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -18,4 +18,6 @@ extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
+void mop500_regulator_init(void);
+
 #endif
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 2bf940d..a8fe1cb 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -300,6 +300,24 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 
 static struct ab8500_ext_regulator_info
 		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
+	[AB8500_EXT_SUPPLY1] = {
+		.desc = {
+			.name		= "VEXTSUPPLY1",
+			.ops		= &ab8500_ext_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_EXT_SUPPLY1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1800000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x08,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_hp		= 0x01,
+		.update_val_lp		= 0x03,
+		.update_val_hw		= 0x02,
+	},
 	[AB8500_EXT_SUPPLY3] = {
 		.desc = {
 			.name		= "VEXTSUPPLY3",
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7436bdb..33308ff 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -160,6 +160,7 @@ struct ab8500_ext_regulator_cfg {
 };
 
 enum ab8500_ext_regulator_id {
+	AB8500_EXT_SUPPLY1,
 	AB8500_EXT_SUPPLY3,
 	AB8500_NUM_EXT_REGULATORS,
 };
-- 
1.7.9.5

