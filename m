Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaJOQU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:20:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33528 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaJOQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:20:55 -0400
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
Subject: [PATCH 1/9] regulator: max77802: Add .set_suspend_{enable,disable} callbacks
Date: Wed, 15 Oct 2014 18:20:31 +0200
Message-Id: <1413390039-19364-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77802 PMIC has an enable pin (PWRREQ) that can be used to switch
regulators ON and OFF automatically by the Application Processor when
the system is leaving and entering sleep mode.

Only the BUCKs regulators had a .set_suspend_disable function handler
that used the enable pin to turn OFF the regulators during suspend.

But most LDOs also support that functionality (besides 1, 3, 20 and 21)
so rename the function to a more generic name and use the same function
for the LDOs. Also add a .set_suspend_enable handler for all regulators
and use the same function used for the .enable operation.

Finally, don't treat output ON/OFF controlled by PWRREQ as an operating
mode using the ambiguous MAX77802_OPMODE_STANDBY since it's not an opmode.
Instead make it clear that is a control value to switch the regulator OFF
by PWRREQ when the system is entering in a suspend state.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index d89792b..26f6963 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -49,6 +49,8 @@
 #define MAX77802_RAMP_RATE_MASK_4BIT	0xF0
 #define MAX77802_RAMP_RATE_SHIFT_4BIT	4
 
+#define MAX77802_OFF_PWRREQ		0x1
+
 /* MAX77802 has two register formats: 2-bit and 4-bit */
 static const unsigned int ramp_table_77802_2bit[] = {
 	12500,
@@ -83,17 +85,16 @@ static int max77802_get_opmode_shift(int id)
 	return -EINVAL;
 }
 
-/*
- * Some BUCKS supports Normal[ON/OFF] mode during suspend
+/**
+ * max77802_set_suspend_disable - Disable the regulator during system suspend
+ * @rdev: regulator to mark as disabled
  *
- * BUCK 1, 6, 2-4, 5, 7-10 (all)
- *
- * The other mode (0x02) will make PWRREQ switch between normal
- * and low power.
+ * All regulators expect LDO 1, 3, 20 and 21 support OFF by PWRREQ.
+ * Configure the regulator so the PMIC will turn it OFF during system suspend.
  */
-static int max77802_buck_set_suspend_disable(struct regulator_dev *rdev)
+static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 {
-	unsigned int val = MAX77802_OPMODE_STANDBY;
+	unsigned int val = MAX77802_OFF_PWRREQ;
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
@@ -178,6 +179,9 @@ static int max77802_enable(struct regulator_dev *rdev)
 	int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
 
+	if (max77802->opmode[id] == MAX77802_OFF_PWRREQ)
+		max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
+
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  max77802->opmode[id] << shift);
@@ -247,6 +251,8 @@ static struct regulator_ops max77802_ldo_ops_logic1 = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_enable	= max77802_enable,
+	.set_suspend_disable	= max77802_set_suspend_disable,
 	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic1,
 };
 
@@ -276,7 +282,8 @@ static struct regulator_ops max77802_buck_16_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77802_set_ramp_delay_4bit,
-	.set_suspend_disable	= max77802_buck_set_suspend_disable,
+	.set_suspend_enable	= max77802_enable,
+	.set_suspend_disable	= max77802_set_suspend_disable,
 };
 
 /* BUCKs 2-4, 5, 7-10 */
@@ -290,7 +297,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77802_set_ramp_delay_2bit,
-	.set_suspend_disable	= max77802_buck_set_suspend_disable,
+	.set_suspend_enable	= max77802_enable,
+	.set_suspend_disable	= max77802_set_suspend_disable,
 };
 
 /* LDOs 3-7, 9-14, 18-26, 28, 29, 32-34 */
-- 
2.1.0

