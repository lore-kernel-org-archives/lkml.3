Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaJOQVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:21:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33535 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaJOQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:20:56 -0400
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
Subject: [PATCH 2/9] regulator: max77802: Add .{get,set}_mode callbacks
Date: Wed, 15 Oct 2014 18:20:32 +0200
Message-Id: <1413390039-19364-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some max77802 LDOs (1, 3, 20 and 21) support to be configured in Low
Power Mode during system normal operation. Add function handlers for
the .get_mode and .set_mode operations to set the mode on these LDOs.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 26f6963..baf834d 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -51,6 +51,9 @@
 
 #define MAX77802_OFF_PWRREQ		0x1
 
+#define MAX77802_MODE(pval) ((pval == MAX77802_OPMODE_NORMAL) ?	\
+			     REGULATOR_MODE_NORMAL : REGULATOR_MODE_STANDBY)
+
 /* MAX77802 has two register formats: 2-bit and 4-bit */
 static const unsigned int ramp_table_77802_2bit[] = {
 	12500,
@@ -105,6 +108,45 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 }
 
 /*
+ * Some LDOs support Low Power Mode while the system is running.
+ *
+ * LDOs 1, 3, 20, 21.
+ */
+static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	unsigned int val;
+	int shift = max77802_get_opmode_shift(id);
+
+	switch (mode) {
+	case REGULATOR_MODE_IDLE:
+	case REGULATOR_MODE_STANDBY:
+		val = MAX77802_OPMODE_LP;	/* ON in Low Power Mode */
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = MAX77802_OPMODE_NORMAL;	/* ON in Normal Mode */
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
+static unsigned max77802_get_mode(struct regulator_dev *rdev)
+{
+	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+
+	return MAX77802_MODE(max77802->opmode[id]);
+}
+
+/*
  * Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state
  * (Enable Control Logic1 by PWRREQ)
  *
@@ -268,6 +310,8 @@ static struct regulator_ops max77802_ldo_ops_logic2 = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_mode		= max77802_set_mode,
+	.get_mode		= max77802_get_mode,
 	.set_suspend_mode	= max77802_ldo_set_suspend_mode_logic2,
 };
 
-- 
2.1.0

