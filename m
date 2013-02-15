Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161417Ab3BOM5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:01 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34764 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161303Ab3BOMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/40] pm2301-charger: Enable SW EOC control on the ab9540
Date: Fri, 15 Feb 2013 12:44:32 +0000
Message-Id: <1360932310-30065-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

End of charging is managed by SW.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/pm2301_charger.c |   48 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ed48d75..62a172e 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -192,11 +192,22 @@ static int pm2xxx_charging_disable_mngt(struct pm2xxx_charger *pm2)
 {
 	int ret;
 
+	/* Disable SW EOC ctrl */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_SW_CTRL_REG, PM2XXX_SWCTRL_HW);
+	if (ret < 0) {
+		dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+		return ret;
+	}
+
 	/* Disable charging */
 	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG2,
 			(PM2XXX_CH_AUTO_RESUME_DIS | PM2XXX_CHARGER_DIS));
+	if (ret < 0) {
+		dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int pm2xxx_charger_batt_therm_mngt(struct pm2xxx_charger *pm2, int val)
@@ -245,13 +256,29 @@ static int pm2xxx_charger_wd_exp_mngt(struct pm2xxx_charger *pm2, int val)
 
 static int pm2xxx_charger_vbat_lsig_mngt(struct pm2xxx_charger *pm2, int val)
 {
+	int ret;
+
 	switch (val) {
 	case PM2XXX_INT1_ITVBATLOWR:
 		dev_dbg(pm2->dev, "VBAT grows above VBAT_LOW level\n");
+		/* Enable SW EOC ctrl */
+		ret = pm2xxx_reg_write(pm2, PM2XXX_SW_CTRL_REG,
+							PM2XXX_SWCTRL_SW);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+			return ret;
+		}
 		break;
 
 	case PM2XXX_INT1_ITVBATLOWF:
 		dev_dbg(pm2->dev, "VBAT drops below VBAT_LOW level\n");
+		/* Disable SW EOC ctrl */
+		ret = pm2xxx_reg_write(pm2, PM2XXX_SW_CTRL_REG,
+							PM2XXX_SWCTRL_HW);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx write failed\n", __func__);
+			return ret;
+		}
 		break;
 
 	default:
@@ -322,16 +349,27 @@ static int pm2_int_reg0(void *pm2_data, int val)
 	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (val & (PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF)) {
-		ret = pm2xxx_charger_vbat_lsig_mngt(pm2, val &
-			(PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF));
+	if (val & PM2XXX_INT1_ITVBATLOWR) {
+		ret = pm2xxx_charger_vbat_lsig_mngt(pm2,
+						PM2XXX_INT1_ITVBATLOWR);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (val & PM2XXX_INT1_ITVBATLOWF) {
+		ret = pm2xxx_charger_vbat_lsig_mngt(pm2,
+						PM2XXX_INT1_ITVBATLOWF);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (val & PM2XXX_INT1_ITVBATDISCONNECT) {
 		ret = pm2xxx_charger_bat_disc_mngt(pm2,
 				PM2XXX_INT1_ITVBATDISCONNECT);
+		if (ret < 0)
+			goto out;
 	}
-
+out:
 	return ret;
 }
 
-- 
1.7.10.4

