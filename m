Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab3CUQFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:05:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56166 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3CUQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/46] regulator: ab8500: Add voltage selection for AUDIO and ANA on AB8505
Date: Thu, 21 Mar 2013 15:59:29 +0000
Message-Id: <1363881583-15234-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   55 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c1e1cf9..84393a6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -162,6 +162,28 @@ static const unsigned int fixed_3300000_voltage[] = {
 	3300000,
 };
 
+static const unsigned int ldo_vana_voltages[] = {
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
+static const unsigned int ldo_vaudio_voltages[] = {
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
 	.set_voltage_time_sel	= ab8500_regulator_set_voltage_time_sel,
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
@@ -841,17 +873,23 @@ static struct ab8500_regulator_info
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
@@ -904,12 +942,12 @@ static struct ab8500_regulator_info
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
@@ -918,6 +956,11 @@ static struct ab8500_regulator_info
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
1.7.10.4

