Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3BFK7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:59:33 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:51581 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab3BFKzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/49] regulator: ab8500: Add voltage selection for AUDIO and ANA on AB8505
Date: Wed,  6 Feb 2013 10:53:59 +0000
Message-Id: <1360148051-7560-38-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   55 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 20c3270..9643bcc 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -162,6 +162,28 @@ static const int fixed_3300000_voltage[] = {
 	3300000,
 };
 
+static const int ldo_vana_voltages[] = {
+	1050000,
+	1075000,
+	1100000,
+	1125000,
+	1150000,
+	1175000,
+	1200000,
+	1225000,
+};
+
+static const int ldo_vaudio_voltages[] = {
+	2000000,
+	2100000,
+	2200000,
+	2300000,
+	2400000,
+	2500000,
+	2600000,
+	2600000,	/* Duplicated in Vaudio and IsoUicc Control register. */
+};
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -413,6 +435,16 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
 
+static struct regulator_ops ab8500_regulator_volt_ops = {
+	.enable		= ab8500_regulator_enable,
+	.disable	= ab8500_regulator_disable,
+	.is_enabled	= ab8500_regulator_is_enabled,
+	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
+	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
+	.list_voltage	= regulator_list_voltage_table,
+	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
+};
+
 static struct regulator_ops ab8500_regulator_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
@@ -840,17 +872,23 @@ static struct ab8500_regulator_info
 	[AB8505_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_AUDIO,
 			.owner		= THIS_MODULE,
-			.n_voltages	= 1,
-			.volt_table	= fixed_2000000_voltage,
+			.n_voltages	= ARRAY_SIZE(ldo_vaudio_voltages),
+			.volt_table	= ldo_vaudio_voltages,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
 		.update_val		= 0x02,
+		.voltage_bank		= 0x01,
+		.voltage_reg		= 0x57,
+		.voltage_mask		= 0x7,
+		.voltage_shift		= 4,
+		.voltages		= ldo_vaudio_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaudio_voltages),
 	},
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
@@ -903,12 +941,12 @@ static struct ab8500_regulator_info
 	[AB8505_LDO_ANA] = {
 		.desc = {
 			.name		= "LDO-ANA",
-			.ops		= &ab8500_regulator_mode_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_ANA,
 			.owner		= THIS_MODULE,
-			.n_voltages	= 1,
-			.volt_table	= fixed_1200000_voltage,
+			.n_voltages	= ARRAY_SIZE(ldo_vana_voltages),
+			.volt_table	= ldo_vana_voltages,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -917,6 +955,11 @@ static struct ab8500_regulator_info
 		.update_val		= 0x04,
 		.update_val_idle	= 0x0c,
 		.update_val_normal	= 0x04,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x29,
+		.voltage_mask		= 0x7,
+		.voltages		= ldo_vana_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vana_voltages),
 	},
 };
 
-- 
1.7.9.5

