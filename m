Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3BDMAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:00:30 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35457 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3BDL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Zhenhua HUANG <zhenhua.huang@stericsson.com>
Subject: [PATCH 64/73] regulator: ab8500: Update vdmic, vamic[1|2] parameters for AB8540
Date: Mon,  4 Feb 2013 11:54:19 +0000
Message-Id: <1359978868-28736-65-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add voltage setting for vdmic; add LP mode setting for vamic1,2.

Signed-off-by: Zhenhua HUANG <zhenhua.huang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Alexandre TORGUE <alexandre.torgue@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |   45 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5a69884..f31669e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -214,9 +214,18 @@ static const int ldo_vaudio_voltages[] = {
 	2600000,	/* Duplicated in Vaudio and IsoUicc Control register. */
 };
 
+static const int ldo_vdmic_voltages[] = {
+	1800000,
+	1900000,
+	2000000,
+	2850000,
+};
+
 static DEFINE_MUTEX(shared_mode_mutex);
 static struct ab8500_shared_mode ldo_anamic1_shared;
 static struct ab8500_shared_mode ldo_anamic2_shared;
+static struct ab8500_shared_mode ab8540_ldo_anamic1_shared;
+static struct ab8500_shared_mode ab8540_ldo_anamic2_shared;
 
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
@@ -1131,7 +1140,7 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
 		},
-		.shared_mode = &ldo_anamic1_shared,
+		.shared_mode		= &ldo_anamic1_shared,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -1612,44 +1621,62 @@ static struct ab8500_regulator_info
 	[AB8540_LDO_ANAMIC1] = {
 		.desc = {
 			.name		= "LDO-ANAMIC1",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_anamic_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
+		.shared_mode		= &ab8540_ldo_anamic1_shared,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
 		.update_val		= 0x08,
+		.mode_bank		= 0x03,
+		.mode_reg		= 0x83,
+		.mode_mask		= 0x20,
+		.mode_val_idle		= 0x20,
+		.mode_val_normal	= 0x00,
 	},
 	[AB8540_LDO_ANAMIC2] = {
 		.desc = {
 			.name		= "LDO-ANAMIC2",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_anamic_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
+		.shared_mode		= &ab8540_ldo_anamic2_shared,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
 		.update_val		= 0x10,
+		.mode_bank		= 0x03,
+		.mode_reg		= 0x83,
+		.mode_mask		= 0x20,
+		.mode_val_idle		= 0x20,
+		.mode_val_normal	= 0x00,
 	},
 	[AB8540_LDO_DMIC] = {
 		.desc = {
 			.name		= "LDO-DMIC",
-			.ops		= &ab8500_regulator_ops,
+			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
-			.n_voltages	= 1,
+			.n_voltages	= ARRAY_SIZE(ldo_vdmic_voltages),
 		},
+		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
 		.update_val		= 0x04,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x83,
+		.voltage_mask		= 0xc0,
+		.voltages		= ldo_vdmic_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vdmic_voltages),
 	},
 
 	/*
@@ -1703,6 +1730,14 @@ static struct ab8500_shared_mode ldo_anamic2_shared = {
 	.shared_regulator = &ab8505_regulator_info[AB8505_LDO_ANAMIC1],
 };
 
+static struct ab8500_shared_mode ab8540_ldo_anamic1_shared = {
+	.shared_regulator = &ab8540_regulator_info[AB8540_LDO_ANAMIC2],
+};
+
+static struct ab8500_shared_mode ab8540_ldo_anamic2_shared = {
+	.shared_regulator = &ab8540_regulator_info[AB8540_LDO_ANAMIC1],
+};
+
 struct ab8500_reg_init {
 	u8 bank;
 	u8 addr;
-- 
1.7.9.5

