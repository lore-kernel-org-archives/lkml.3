Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaGHM2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:28:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43370 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaGHM2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:28:16 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] regulator: s2mpa01: Optimize the regulator description macro
Date: Tue,  8 Jul 2014 17:57:59 +0530
Message-Id: <1404822480-31525-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
References: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the regulator description macro take minimum and
steps voltage as parameter. In this way many repeated macros can be
removed. Now these macros are repeated only if the the LDO/BUCK ctrl
registers have non-linear positions. The good thing is these ctrl registers
are mostly linear so they are not passed as parameters.

This patch reduces the code size and also allow easy addition of more
s2mpxxx PMIC drivers which differs a lot in minimum/step voltages.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/regulator/s2mpa01.c | 136 ++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 99 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index 962c5f1..8073466 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -235,28 +235,14 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.set_ramp_delay		= s2mpa01_set_ramp_delay,
 };
 
-#define regulator_desc_ldo1(num)	{		\
+#define regulator_desc_ldo(num, min, step)	{	\
 	.name		= "LDO"#num,			\
 	.id		= S2MPA01_LDO##num,		\
 	.ops		= &s2mpa01_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_50_MV,			\
-	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
-	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
-	.enable_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
-	.enable_mask	= S2MPA01_ENABLE_MASK		\
-}
-#define regulator_desc_ldo2(num)	{		\
-	.name		= "LDO"#num,			\
-	.id		= S2MPA01_LDO##num,		\
-	.ops		= &s2mpa01_ldo_ops,		\
-	.type		= REGULATOR_VOLTAGE,		\
-	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_25_MV,			\
+	.min_uV		= min,				\
+	.uV_step	= step,				\
 	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
@@ -296,14 +282,14 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.enable_mask	= S2MPA01_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck6_7(num)	{			\
+#define regulator_desc_buck6_10(num, min, step)	{		\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPA01_BUCK##num,			\
 	.ops		= &s2mpa01_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_600_MV,				\
-	.uV_step	= STEP_6_25_MV,				\
+	.min_uV		= min,					\
+	.uV_step	= step,					\
 	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
 	.vsel_reg	= S2MPA01_REG_B6CTRL2 + (num - 6) * 2,	\
@@ -312,91 +298,43 @@ static struct regulator_ops s2mpa01_buck_ops = {
 	.enable_mask	= S2MPA01_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck8	{				\
-	.name		= "BUCK8",				\
-	.id		= S2MPA01_BUCK8,			\
-	.ops		= &s2mpa01_buck_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_800_MV,				\
-	.uV_step	= STEP_12_5_MV,				\
-	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
-	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
-	.vsel_reg	= S2MPA01_REG_B8CTRL2,			\
-	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPA01_REG_B8CTRL1,			\
-	.enable_mask	= S2MPA01_ENABLE_MASK			\
-}
-
-#define regulator_desc_buck9	{				\
-	.name		= "BUCK9",				\
-	.id		= S2MPA01_BUCK9,			\
-	.ops		= &s2mpa01_buck_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_1500_MV,				\
-	.uV_step	= STEP_12_5_MV,				\
-	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
-	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
-	.vsel_reg	= S2MPA01_REG_B9CTRL2,			\
-	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPA01_REG_B9CTRL1,			\
-	.enable_mask	= S2MPA01_ENABLE_MASK			\
-}
-
-#define regulator_desc_buck10	{				\
-	.name		= "BUCK10",				\
-	.id		= S2MPA01_BUCK10,			\
-	.ops		= &s2mpa01_buck_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_1000_MV,				\
-	.uV_step	= STEP_12_5_MV,				\
-	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
-	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
-	.vsel_reg	= S2MPA01_REG_B10CTRL2,			\
-	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPA01_REG_B10CTRL1,			\
-	.enable_mask	= S2MPA01_ENABLE_MASK			\
-}
-
 static struct regulator_desc regulators[] = {
-	regulator_desc_ldo2(1),
-	regulator_desc_ldo1(2),
-	regulator_desc_ldo1(3),
-	regulator_desc_ldo1(4),
-	regulator_desc_ldo1(5),
-	regulator_desc_ldo2(6),
-	regulator_desc_ldo1(7),
-	regulator_desc_ldo1(8),
-	regulator_desc_ldo1(9),
-	regulator_desc_ldo1(10),
-	regulator_desc_ldo2(11),
-	regulator_desc_ldo1(12),
-	regulator_desc_ldo1(13),
-	regulator_desc_ldo1(14),
-	regulator_desc_ldo1(15),
-	regulator_desc_ldo1(16),
-	regulator_desc_ldo1(17),
-	regulator_desc_ldo1(18),
-	regulator_desc_ldo1(19),
-	regulator_desc_ldo1(20),
-	regulator_desc_ldo1(21),
-	regulator_desc_ldo2(22),
-	regulator_desc_ldo2(23),
-	regulator_desc_ldo1(24),
-	regulator_desc_ldo1(25),
-	regulator_desc_ldo1(26),
+	regulator_desc_ldo(1, MIN_800_MV, STEP_25_MV),
+	regulator_desc_ldo(2, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(3, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(4, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(5, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(6, MIN_800_MV, STEP_25_MV),
+	regulator_desc_ldo(7, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(8, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(9, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(10, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(11, MIN_800_MV, STEP_25_MV),
+	regulator_desc_ldo(12, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(13, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(14, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(15, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(16, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(17, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(18, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(19, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(20, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(21, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(22, MIN_800_MV, STEP_25_MV),
+	regulator_desc_ldo(23, MIN_800_MV, STEP_25_MV),
+	regulator_desc_ldo(24, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(25, MIN_800_MV, STEP_50_MV),
+	regulator_desc_ldo(26, MIN_800_MV, STEP_50_MV),
 	regulator_desc_buck1_4(1),
 	regulator_desc_buck1_4(2),
 	regulator_desc_buck1_4(3),
 	regulator_desc_buck1_4(4),
 	regulator_desc_buck5,
-	regulator_desc_buck6_7(6),
-	regulator_desc_buck6_7(7),
-	regulator_desc_buck8,
-	regulator_desc_buck9,
-	regulator_desc_buck10,
+	regulator_desc_buck6_10(6, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_buck6_10(7, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_buck6_10(8, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_buck6_10(9, MIN_1500_MV, STEP_12_5_MV),
+	regulator_desc_buck6_10(10, MIN_1000_MV, STEP_12_5_MV),
 };
 
 static int s2mpa01_pmic_probe(struct platform_device *pdev)
-- 
1.9.1

