Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbbAVPp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:45:59 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37188 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbAVPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:50 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 4/5] regulators: axp20x: Change dcdc-workmode DT property to boolean flag
Date: Thu, 22 Jan 2015 23:39:06 +0800
Message-Id: <1421941147-9682-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421941147-9682-1-git-send-email-wens@csie.org>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "x-powers,dcdc-workmode" property only has 2 values. A request was
made to change this to a boolean flag named "x-powers,dcdc-workmode-pwm".
Given that this particular binding hasn't been used anywhere, it should
be safe to change.

Previously the absence of the property meant just keeping the PMIC in
whatever state was set by the bootloader. After this change, the absence
means using the "auto" (PWM/PFM hybrid) mode, which is also the hardware's
default.

This patch also makes axp20x_set_dcdc_workmode() ignore attempts to set
the workmode for non-DCDC regulators.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/regulator/axp20x-regulator.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 990ac453abc8..0b099e5ece3f 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -202,19 +202,21 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 	return 0;
 }
 
-static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 workmode)
+static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, bool workmode)
 {
 	unsigned int mask = AXP20X_WORKMODE_DCDC2_MASK;
+	u32 val;
 
+	/* ignore setting workmode for non-dcdc regulators */
 	if ((id != AXP20X_DCDC2) && (id != AXP20X_DCDC3))
-		return -EINVAL;
+		return 0;
 
 	if (id == AXP20X_DCDC3)
 		mask = AXP20X_WORKMODE_DCDC3_MASK;
 
-	workmode <<= ffs(mask) - 1;
+	val = workmode ? mask : 0;
 
-	return regmap_update_bits(rdev->regmap, AXP20X_DCDC_MODE, mask, workmode);
+	return regmap_update_bits(rdev->regmap, AXP20X_DCDC_MODE, mask, val);
 }
 
 static int axp20x_regulator_probe(struct platform_device *pdev)
@@ -225,8 +227,8 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 		.dev = pdev->dev.parent,
 		.regmap = axp20x->regmap,
 	};
-	int ret, i;
-	u32 workmode;
+	int i;
+	bool workmode;
 
 	/* This only sets the dcdc freq. Ignore any errors */
 	axp20x_regulator_parse_dt(pdev);
@@ -241,14 +243,11 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 			return PTR_ERR(rdev);
 		}
 
-		ret = of_property_read_u32(rdev->dev.of_node,
-					   "x-powers,dcdc-workmode",
-					   &workmode);
-		if (!ret) {
-			if (axp20x_set_dcdc_workmode(rdev, i, workmode))
-				dev_err(&pdev->dev, "Failed to set workmode on %s\n",
-					axp20x_regulators[i].name);
-		}
+		workmode = of_property_read_bool(rdev->dev.of_node,
+						 "x-powers,dcdc-workmode-pwm");
+		if (axp20x_set_dcdc_workmode(rdev, i, workmode))
+			dev_err(&pdev->dev, "Failed to set workmode on %s\n",
+				axp20x_regulators[i].name);
 	}
 
 	return 0;
-- 
2.1.4

