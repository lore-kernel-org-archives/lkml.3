Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3C1QMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:08 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58204 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3C1QMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/33] ARM: ux500: Add regulator platform data for AB8500 external regulators
Date: Thu, 28 Mar 2013 16:11:02 +0000
Message-Id: <1364487093-19551-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass constraint information for recently supported external AB8500
controlled regulators. Also change the start-up initialisation settings
for each of the 3 supported external supplies to low-power, off and
high-power for supply 1, 2 and 3 respectively.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   59 +++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 035b92f..089cf2a 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -259,13 +259,13 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VREFDDR,                0x03, 0x00),
 	/*
-	 * VextSupply1Regu          = HW control
-	 * VextSupply2Regu          = HW control
-	 * VextSupply3Regu          = HW control
+	 * VextSupply1Regu          = force LP
+	 * VextSupply2Regu          = force OFF
+	 * VextSupply3Regu          = force HP (-> STBB2=LP and TPS=LP)
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1a),
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x13),
 	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
@@ -419,9 +419,60 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 };
 
+/* supply for VextSupply3 */
+static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
+	/* SIM supply for 3 V SIM cards */
+	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
+};
+
+/* extended configuration for VextSupply2, only used for HREFP_V20 boards */
+static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 = {
+	.hwreq = true,
+};
+
+/*
+ * AB8500 external regulators
+ */
+static struct regulator_init_data ab8500_ext_regulators[] = {
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
+	/* fixed Vbat supplies VSMPS2_EXT_1V36 and VSMPS5_EXT_1V15 */
+	[AB8500_EXT_SUPPLY2] = {
+		.constraints = {
+			.name = "ab8500-ext-supply2",
+			.min_uV = 1360000,
+			.max_uV = 1360000,
+		},
+	},
+	/* fixed Vbat supplies VSMPS3_EXT_3V4 and VSMPS4_EXT_3V4 */
+	[AB8500_EXT_SUPPLY3] = {
+		.constraints = {
+			.name = "ab8500-ext-supply3",
+			.min_uV = 3400000,
+			.max_uV = 3400000,
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.boot_on = 1,
+		},
+		.num_consumer_supplies =
+			ARRAY_SIZE(ab8500_ext_supply3_consumers),
+		.consumer_supplies = ab8500_ext_supply3_consumers,
+	},
+};
+
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.reg_init               = ab8500_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
 	.regulator              = ab8500_regulators,
 	.num_regulator          = ARRAY_SIZE(ab8500_regulators),
+	.ext_regulator          = ab8500_ext_regulators,
+	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
-- 
1.7.10.4

