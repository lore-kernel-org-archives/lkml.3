Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3AUMGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:06:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41715 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3AUMEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/24] pm2301: Enable vbat low monitoring
Date: Mon, 21 Jan 2013 12:03:54 +0000
Message-Id: <1358769840-4763-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

Enable support for low battery checking.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/pm2301_charger.c |   86 +++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 0e41168..c7d92b3 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -118,6 +118,8 @@ int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 				1, val);
 	if (ret < 0)
 		dev_err(pm2->dev, "Error reading register at 0x%x\n", reg);
+	else
+		ret = 0;
 
 	return ret;
 }
@@ -130,6 +132,8 @@ int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 				1, &val);
 	if (ret < 0)
 		dev_err(pm2->dev, "Error writing register at 0x%x\n", reg);
+	else
+		ret = 0;
 
 	return ret;
 }
@@ -227,7 +231,7 @@ static int pm2xxx_charger_bat_disc_mngt(struct pm2xxx_charger *pm2, int val)
 
 static int pm2xxx_charger_detection(struct pm2xxx_charger *pm2, u8 *val)
 {
-	int ret = 0;
+	int ret;
 
 	ret = pm2xxx_reg_read(pm2, PM2XXX_SRCE_REG_INT2, val);
 
@@ -237,6 +241,7 @@ static int pm2xxx_charger_detection(struct pm2xxx_charger *pm2, u8 *val)
 	}
 
 	*val &= (PM2XXX_INT2_S_ITVPWR1PLUG | PM2XXX_INT2_S_ITVPWR2PLUG);
+
 out:
 	return ret;
 }
@@ -628,7 +633,7 @@ static int pm2xxx_charging_init(struct pm2xxx_charger *pm2)
 
 	/* Disable battery low monitoring */
 	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_LOW_LEV_COMP_REG,
-		PM2XXX_VBAT_LOW_MONITORING_DIS);
+		PM2XXX_VBAT_LOW_MONITORING_ENA);
 
 	/* Disable LED */
 	ret = pm2xxx_reg_write(pm2, PM2XXX_LED_CTRL_REG,
@@ -677,53 +682,51 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
 		}
 
 		ret = pm2xxx_reg_read(pm2, PM2XXX_BATT_CTRL_REG8, &val);
-		if (ret >= 0) {
-			val &= ~PM2XXX_CH_VOLT_MASK;
-			val |= volt_index;
-			ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG8, val);
-
-			if (ret < 0) {
-				dev_err(pm2->dev,
-					"%s write failed\n", __func__);
-				goto error_occured;
-			}
-		else
-			dev_err(pm2->dev, "%s read failed\n", __func__);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx read failed\n", __func__);
+			goto error_occured;
+		}
+		val &= ~PM2XXX_CH_VOLT_MASK;
+		val |= volt_index;
+		ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG8, val);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+			goto error_occured;
 		}
 
 		ret = pm2xxx_reg_read(pm2, PM2XXX_BATT_CTRL_REG6, &val);
-		if (ret >= 0) {
-			val &= ~PM2XXX_DIR_CH_CC_CURRENT_MASK;
-			val |= curr_index;
-			ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG6, val);
-			if (ret < 0) {
-				dev_err(pm2->dev,
-					"%s write failed\n", __func__);
-				goto error_occured;
-			}
-		else
-			dev_err(pm2->dev, "%s read failed\n", __func__);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx read failed\n", __func__);
+			goto error_occured;
+		}
+		val &= ~PM2XXX_DIR_CH_CC_CURRENT_MASK;
+		val |= curr_index;
+		ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG6, val);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+			goto error_occured;
 		}
 
 		if (!pm2->bat->enable_overshoot) {
 			ret = pm2xxx_reg_read(pm2, PM2XXX_LED_CTRL_REG, &val);
-			if (ret >= 0) {
-				val |= PM2XXX_ANTI_OVERSHOOT_EN;
-				ret = pm2xxx_reg_write(pm2, PM2XXX_LED_CTRL_REG,
-							val);
-				if (ret < 0){
-					dev_err(pm2->dev, "%s write failed\n",
-							__func__);
-					goto error_occured;
-				}
+			if (ret < 0) {
+				dev_err(pm2->dev, "%s pm2xxx read failed\n",
+								__func__);
+				goto error_occured;
+			}
+			val |= PM2XXX_ANTI_OVERSHOOT_EN;
+			ret = pm2xxx_reg_write(pm2, PM2XXX_LED_CTRL_REG, val);
+			if (ret < 0) {
+				dev_err(pm2->dev, "%s pm2xxx write failed\n",
+								__func__);
+				goto error_occured;
 			}
-		else
-			dev_err(pm2->dev, "%s read failed\n", __func__);
 		}
 
 		ret = pm2xxx_charging_enable_mngt(pm2);
-		if (ret) {
-			dev_err(pm2->dev, "%s write failed\n", __func__);
+		if (ret < 0) {
+			dev_err(pm2->dev, "Failed to enable"
+						"pm2xxx ac charger\n");
 			goto error_occured;
 		}
 
@@ -739,9 +742,10 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
 		}
 
 		ret = pm2xxx_charging_disable_mngt(pm2);
-		if (ret) {
-			dev_err(pm2->dev, "%s write failed\n", __func__);
-			return ret;
+		if (ret < 0) {
+			dev_err(pm2->dev, "failed to disable"
+						"pm2xxx ac charger\n");
+			goto error_occured;
 		}
 
 		dev_dbg(pm2->dev, "PM2301: " "Disabled AC charging\n");
-- 
1.7.9.5

