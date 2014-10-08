Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaJHNq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:46:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52442 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbaJHNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:46:25 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 4/5] regulator: max77802: Add regulator operating mode set support
Date: Wed,  8 Oct 2014 15:44:06 +0200
Message-Id: <1412775847-15213-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function handler for the struct regulator_ops .set_mode so an
operating mode (opmode) can be set for regulators.

Regulators opmode are defined using the generic REGULATOR_MODE_*
modes so the driver maps these generic modes to the device-specific
operating modes as stated in the hardware data-sheet.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index d89792b..04ed5cf 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -83,6 +83,34 @@ static int max77802_get_opmode_shift(int id)
 	return -EINVAL;
 }
 
+static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
+	unsigned int val;
+	int id = rdev_get_id(rdev);
+	int shift = max77802_get_opmode_shift(id);
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		val = MAX77802_OPMODE_NORMAL;
+		break;
+	case REGULATOR_MODE_IDLE:
+		val = MAX77802_OPMODE_LP;
+		break;
+	case REGULATOR_MODE_STANDBY:
+		val = MAX77802_OPMODE_STANDBY;
+		break;
+	default:
+		dev_warn(&rdev->dev, "%s: regulator mode: 0x%x not supported\n",
+			 rdev->desc->name, mode);
+		return -EINVAL;
+	}
+
+	max77802->opmode[id] = val;
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask, val << shift);
+}
+
 /*
  * Some BUCKS supports Normal[ON/OFF] mode during suspend
  *
@@ -247,6 +275,7 @@ static struct regulator_ops max77802_ldo_ops_logic1 = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_mode		= max77802_set_mode,
 	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic1,
 };
 
@@ -262,6 +291,7 @@ static struct regulator_ops max77802_ldo_ops_logic2 = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_mode		= max77802_set_mode,
 	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic2,
 };
 
@@ -274,6 +304,7 @@ static struct regulator_ops max77802_buck_16_dvs_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_mode		= max77802_set_mode,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77802_set_ramp_delay_4bit,
 	.set_suspend_disable	= max77802_buck_set_suspend_disable,
@@ -288,6 +319,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_mode		= max77802_set_mode,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77802_set_ramp_delay_2bit,
 	.set_suspend_disable	= max77802_buck_set_suspend_disable,
-- 
2.1.0

