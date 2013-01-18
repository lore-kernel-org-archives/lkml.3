Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3ARD6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:58:40 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64121 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARD6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:58:39 -0500
Message-ID: <1358481513.25899.6.camel@phoenix>
Subject: [PATCH 1/2] regulator: wm8994: Convert wm8994_ldo2_ops to use
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 11:58:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/wm8994-regulator.c |   57 ++++++++++++++++------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 6ff8723..fef2692 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -27,7 +27,6 @@
 
 struct wm8994_ldo {
 	struct regulator_dev *regulator;
-	struct wm8994 *wm8994;
 };
 
 #define WM8994_LDO1_MAX_SELECTOR 0x7
@@ -40,39 +39,14 @@ static struct regulator_ops wm8994_ldo1_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };
 
-static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
-				    unsigned int selector)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	if (selector > WM8994_LDO2_MAX_SELECTOR)
-		return -EINVAL;
-
-	switch (ldo->wm8994->type) {
-	case WM8994:
-		return (selector * 100000) + 900000;
-	case WM8958:
-		return (selector * 100000) + 1000000;
-	case WM1811:
-		switch (selector) {
-		case 0:
-			return -EINVAL;
-		default:
-			return (selector * 100000) + 950000;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-}
-
 static struct regulator_ops wm8994_ldo2_ops = {
-	.list_voltage = wm8994_ldo2_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };
 
-static const struct regulator_desc wm8994_ldo_desc[] = {
+static struct regulator_desc wm8994_ldo_desc[] = {
 	{
 		.name = "LDO1",
 		.id = 1,
@@ -116,8 +90,6 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ldo->wm8994 = wm8994;
-
 	config.dev = wm8994->dev;
 	config.driver_data = ldo;
 	config.regmap = wm8994->regmap;
@@ -126,6 +98,29 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 		config.ena_gpio = pdata->ldo[id].enable;
 	}
 
+	/* LDO2, id starts from 0 */
+	if (id == 1) {
+		switch (wm8994->type) {
+		case WM8994:
+			wm8994_ldo_desc[id].min_uV = 900000;
+			wm8994_ldo_desc[id].uV_step = 100000;
+			break;
+		case WM8958:
+			wm8994_ldo_desc[id].min_uV = 1000000;
+			wm8994_ldo_desc[id].uV_step = 100000;
+			break;
+		case WM1811:
+			wm8994_ldo_desc[id].min_uV = 1050000;
+			wm8994_ldo_desc[id].uV_step = 100000;
+			wm8994_ldo_desc[id].linear_min_sel = 1;
+			break;
+		default:
+			dev_err(&pdev->dev, "Unknown wm8994 device type %d\n",
+				wm8994->type);
+			return -EINVAL;
+		}
+	}
+
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
-- 
1.7.9.5



