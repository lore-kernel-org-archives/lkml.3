Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaGHM2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:28:21 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35766 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaGHM2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:28:19 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] regulator: s2mps11: Optimize the regulator description macro
Date: Tue,  8 Jul 2014 17:58:00 +0530
Message-Id: <1404822480-31525-3-git-send-email-amit.daniel@samsung.com>
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
 drivers/regulator/s2mps11.c | 261 +++++++++++++++-----------------------------
 1 file changed, 86 insertions(+), 175 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 2098c3e..ea94f47 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -250,28 +250,14 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.set_ramp_delay		= s2mps11_set_ramp_delay,
 };
 
-#define regulator_desc_s2mps11_ldo1(num)	{	\
+#define regulator_desc_s2mps11_ldo(num, min, step) {	\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS11_LDO##num,		\
 	.ops		= &s2mps11_ldo_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_50_MV,			\
-	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
-	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
-	.enable_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
-	.enable_mask	= S2MPS11_ENABLE_MASK		\
-}
-#define regulator_desc_s2mps11_ldo2(num) {		\
-	.name		= "LDO"#num,			\
-	.id		= S2MPS11_LDO##num,		\
-	.ops		= &s2mps11_ldo_ops,		\
-	.type		= REGULATOR_VOLTAGE,		\
-	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_25_MV,			\
+	.min_uV		= min,				\
+	.uV_step	= step,				\
 	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
@@ -311,14 +297,14 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_s2mps11_buck6_8(num) {			\
+#define regulator_desc_s2mps11_buck6_10(num, min, step) {	\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS11_BUCK##num,			\
 	.ops		= &s2mps11_buck_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_600_MV,				\
-	.uV_step	= STEP_6_25_MV,				\
+	.min_uV		= min,					\
+	.uV_step	= step,					\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B6CTRL2 + (num - 6) * 2,	\
@@ -327,87 +313,55 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_s2mps11_buck9 {				\
-	.name		= "BUCK9",				\
-	.id		= S2MPS11_BUCK9,			\
-	.ops		= &s2mps11_buck_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_3000_MV,				\
-	.uV_step	= STEP_25_MV,				\
-	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
-	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
-	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPS11_REG_B9CTRL1,			\
-	.enable_mask	= S2MPS11_ENABLE_MASK			\
-}
-
-#define regulator_desc_s2mps11_buck10 {				\
-	.name		= "BUCK10",				\
-	.id		= S2MPS11_BUCK10,			\
-	.ops		= &s2mps11_buck_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_750_MV,				\
-	.uV_step	= STEP_12_5_MV,				\
-	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
-	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
-	.vsel_reg	= S2MPS11_REG_B10CTRL2,			\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPS11_REG_B10CTRL1,			\
-	.enable_mask	= S2MPS11_ENABLE_MASK			\
-}
-
 static const struct regulator_desc s2mps11_regulators[] = {
-	regulator_desc_s2mps11_ldo2(1),
-	regulator_desc_s2mps11_ldo1(2),
-	regulator_desc_s2mps11_ldo1(3),
-	regulator_desc_s2mps11_ldo1(4),
-	regulator_desc_s2mps11_ldo1(5),
-	regulator_desc_s2mps11_ldo2(6),
-	regulator_desc_s2mps11_ldo1(7),
-	regulator_desc_s2mps11_ldo1(8),
-	regulator_desc_s2mps11_ldo1(9),
-	regulator_desc_s2mps11_ldo1(10),
-	regulator_desc_s2mps11_ldo2(11),
-	regulator_desc_s2mps11_ldo1(12),
-	regulator_desc_s2mps11_ldo1(13),
-	regulator_desc_s2mps11_ldo1(14),
-	regulator_desc_s2mps11_ldo1(15),
-	regulator_desc_s2mps11_ldo1(16),
-	regulator_desc_s2mps11_ldo1(17),
-	regulator_desc_s2mps11_ldo1(18),
-	regulator_desc_s2mps11_ldo1(19),
-	regulator_desc_s2mps11_ldo1(20),
-	regulator_desc_s2mps11_ldo1(21),
-	regulator_desc_s2mps11_ldo2(22),
-	regulator_desc_s2mps11_ldo2(23),
-	regulator_desc_s2mps11_ldo1(24),
-	regulator_desc_s2mps11_ldo1(25),
-	regulator_desc_s2mps11_ldo1(26),
-	regulator_desc_s2mps11_ldo2(27),
-	regulator_desc_s2mps11_ldo1(28),
-	regulator_desc_s2mps11_ldo1(29),
-	regulator_desc_s2mps11_ldo1(30),
-	regulator_desc_s2mps11_ldo1(31),
-	regulator_desc_s2mps11_ldo1(32),
-	regulator_desc_s2mps11_ldo1(33),
-	regulator_desc_s2mps11_ldo1(34),
-	regulator_desc_s2mps11_ldo1(35),
-	regulator_desc_s2mps11_ldo1(36),
-	regulator_desc_s2mps11_ldo1(37),
-	regulator_desc_s2mps11_ldo1(38),
+	regulator_desc_s2mps11_ldo(1, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(2, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(3, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(4, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(5, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(6, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(7, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(8, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(9, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(10, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(11, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(12, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(13, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(14, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(15, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(16, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(17, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(18, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(19, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(20, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(21, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(22, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(23, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(24, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(25, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(26, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(27, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps11_ldo(28, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(29, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(30, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(31, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(32, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(33, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(34, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(35, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(36, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(37, MIN_800_MV, STEP_50_MV),
+	regulator_desc_s2mps11_ldo(38, MIN_800_MV, STEP_50_MV),
 	regulator_desc_s2mps11_buck1_4(1),
 	regulator_desc_s2mps11_buck1_4(2),
 	regulator_desc_s2mps11_buck1_4(3),
 	regulator_desc_s2mps11_buck1_4(4),
 	regulator_desc_s2mps11_buck5,
-	regulator_desc_s2mps11_buck6_8(6),
-	regulator_desc_s2mps11_buck6_8(7),
-	regulator_desc_s2mps11_buck6_8(8),
-	regulator_desc_s2mps11_buck9,
-	regulator_desc_s2mps11_buck10,
+	regulator_desc_s2mps11_buck6_10(6, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps11_buck6_10(7, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps11_buck6_10(8, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps11_buck6_10(9, MIN_3000_MV, STEP_25_MV),
+	regulator_desc_s2mps11_buck6_10(10, MIN_750_MV, STEP_12_5_MV),
 };
 
 static int s2mps14_regulator_enable(struct regulator_dev *rdev)
@@ -467,56 +421,29 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.set_suspend_disable	= s2mps14_regulator_set_suspend_disable,
 };
 
-#define regulator_desc_s2mps14_ldo1(num) {		\
-	.name		= "LDO"#num,			\
-	.id		= S2MPS14_LDO##num,		\
-	.ops		= &s2mps14_reg_ops,		\
-	.type		= REGULATOR_VOLTAGE,		\
-	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_25_MV,			\
-	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
-	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
-	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
-	.enable_mask	= S2MPS14_ENABLE_MASK		\
-}
-#define regulator_desc_s2mps14_ldo2(num) {		\
-	.name		= "LDO"#num,			\
-	.id		= S2MPS14_LDO##num,		\
-	.ops		= &s2mps14_reg_ops,		\
-	.type		= REGULATOR_VOLTAGE,		\
-	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_1800_MV,			\
-	.uV_step	= STEP_25_MV,			\
-	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
-	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
-	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
-	.enable_mask	= S2MPS14_ENABLE_MASK		\
-}
-#define regulator_desc_s2mps14_ldo3(num) {		\
+#define regulator_desc_s2mps14_ldo(num, min, step) {	\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS14_LDO##num,		\
 	.ops		= &s2mps14_reg_ops,		\
 	.type		= REGULATOR_VOLTAGE,		\
 	.owner		= THIS_MODULE,			\
-	.min_uV		= MIN_800_MV,			\
-	.uV_step	= STEP_12_5_MV,			\
+	.min_uV		= min,				\
+	.uV_step	= step,				\
 	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
 	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
 	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
 	.enable_mask	= S2MPS14_ENABLE_MASK		\
 }
-#define regulator_desc_s2mps14_buck1235(num) {			\
+
+#define regulator_desc_s2mps14_buck(num, min, step) {		\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS14_BUCK##num,			\
 	.ops		= &s2mps14_reg_ops,			\
 	.type		= REGULATOR_VOLTAGE,			\
 	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_600_MV,				\
-	.uV_step	= STEP_6_25_MV,				\
+	.min_uV		= min,					\
+	.uV_step	= step,					\
 	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
 	.linear_min_sel = S2MPS14_BUCK1235_START_SEL,		\
 	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
@@ -525,54 +452,38 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.enable_reg	= S2MPS14_REG_B1CTRL1 + (num - 1) * 2,	\
 	.enable_mask	= S2MPS14_ENABLE_MASK			\
 }
-#define regulator_desc_s2mps14_buck4(num) {			\
-	.name		= "BUCK"#num,				\
-	.id		= S2MPS14_BUCK##num,			\
-	.ops		= &s2mps14_reg_ops,			\
-	.type		= REGULATOR_VOLTAGE,			\
-	.owner		= THIS_MODULE,				\
-	.min_uV		= MIN_1400_MV,				\
-	.uV_step	= STEP_12_5_MV,				\
-	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
-	.linear_min_sel = S2MPS14_BUCK4_START_SEL,		\
-	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
-	.vsel_reg	= S2MPS14_REG_B1CTRL2 + (num - 1) * 2,	\
-	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPS14_REG_B1CTRL1 + (num - 1) * 2,	\
-	.enable_mask	= S2MPS14_ENABLE_MASK			\
-}
 
 static const struct regulator_desc s2mps14_regulators[] = {
-	regulator_desc_s2mps14_ldo3(1),
-	regulator_desc_s2mps14_ldo3(2),
-	regulator_desc_s2mps14_ldo1(3),
-	regulator_desc_s2mps14_ldo1(4),
-	regulator_desc_s2mps14_ldo3(5),
-	regulator_desc_s2mps14_ldo3(6),
-	regulator_desc_s2mps14_ldo1(7),
-	regulator_desc_s2mps14_ldo2(8),
-	regulator_desc_s2mps14_ldo3(9),
-	regulator_desc_s2mps14_ldo3(10),
-	regulator_desc_s2mps14_ldo1(11),
-	regulator_desc_s2mps14_ldo2(12),
-	regulator_desc_s2mps14_ldo2(13),
-	regulator_desc_s2mps14_ldo2(14),
-	regulator_desc_s2mps14_ldo2(15),
-	regulator_desc_s2mps14_ldo2(16),
-	regulator_desc_s2mps14_ldo2(17),
-	regulator_desc_s2mps14_ldo2(18),
-	regulator_desc_s2mps14_ldo1(19),
-	regulator_desc_s2mps14_ldo1(20),
-	regulator_desc_s2mps14_ldo1(21),
-	regulator_desc_s2mps14_ldo3(22),
-	regulator_desc_s2mps14_ldo1(23),
-	regulator_desc_s2mps14_ldo2(24),
-	regulator_desc_s2mps14_ldo2(25),
-	regulator_desc_s2mps14_buck1235(1),
-	regulator_desc_s2mps14_buck1235(2),
-	regulator_desc_s2mps14_buck1235(3),
-	regulator_desc_s2mps14_buck4(4),
-	regulator_desc_s2mps14_buck1235(5),
+	regulator_desc_s2mps14_ldo(1, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(2, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(3, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(4, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(5, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(6, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(7, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(8, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(9, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(10, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(11, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(12, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(13, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(14, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(15, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(16, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(17, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(18, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(19, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(20, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(21, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(22, MIN_800_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_ldo(23, MIN_800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(24, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_ldo(25, MIN_1800_MV, STEP_25_MV),
+	regulator_desc_s2mps14_buck(1, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps14_buck(2, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps14_buck(3, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps14_buck(4, MIN_1400_MV, STEP_12_5_MV),
+	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV),
 };
 
 static int s2mps14_pmic_enable_ext_control(struct s2mps11_info *s2mps11,
-- 
1.9.1

