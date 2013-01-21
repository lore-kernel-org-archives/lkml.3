Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3AUMEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46707 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3AUMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Loic Pallardy <loic.pallardy@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Subject: [PATCH 11/24] pm2301: Update watchdog for pm2xxx support
Date: Mon, 21 Jan 2013 12:03:47 +0000
Message-Id: <1358769840-4763-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@stericsson.com>

AB and PMxxx doesn't have same watchdog refresh period. Add watchdog
to refresh period parameters in x500 charger structure, this should
kick watchdog every 30sec. The AC charging should also kick both
pm2xxx and the AB charger watchdog.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c            |    6 ++++++
 drivers/power/abx500_chargalg.c           |   12 +++++++++++-
 drivers/power/pm2301_charger.c            |    2 ++
 drivers/power/pm2301_charger.h            |    2 +-
 include/linux/mfd/abx500/ux500_chargalg.h |    3 +++
 5 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 4c66172..0483e7c 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -93,6 +93,8 @@
 
 #define CHARGER_STATUS_POLL 10 /* in ms */
 
+#define CHG_WD_INTERVAL			(60 * HZ)
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -2953,7 +2955,9 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->ac_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->ac_chg.enabled = di->pdata->ac_enabled;
+	di->ac_chg.external = false;
 
 	/* USB supply */
 	/* power_supply base class */
@@ -2972,7 +2976,9 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->usb_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->pdata->usb_enabled;
+	di->usb_chg.external = false;
 
 	/* Create a work queue for the charger */
 	di->charger_wq =
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index f59bc02..7defb3e 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -445,8 +445,18 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
 {
 	/* Check if charger exists and kick watchdog if charging */
 	if (di->ac_chg && di->ac_chg->ops.kick_wd &&
-			di->chg_info.online_chg & AC_CHG)
+	    di->chg_info.online_chg & AC_CHG) {
+		/*
+		 * If AB charger watchdog expired, pm2xxx charging
+		 * gets disabled. To be safe, kick both AB charger watchdog
+		 * and pm2xxx watchdog.
+		 */
+		if (di->ac_chg->external &&
+		    di->usb_chg && di->usb_chg->ops.kick_wd)
+			di->usb_chg->ops.kick_wd(di->usb_chg);
+
 		return di->ac_chg->ops.kick_wd(di->ac_chg);
+	}
 	else if (di->usb_chg && di->usb_chg->ops.kick_wd &&
 			di->chg_info.online_chg & USB_CHG)
 		return di->usb_chg->ops.kick_wd(di->usb_chg);
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 16d8cfe..0e41168 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -875,7 +875,9 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		ARRAY_SIZE(pm2xxx_charger_voltage_map) - 1];
 	pm2->ac_chg.max_out_curr = pm2xxx_charger_current_map[
 		ARRAY_SIZE(pm2xxx_charger_current_map) - 1];
+	pm2->ac_chg.wdt_refresh = WD_KICK_INTERVAL;
 	pm2->ac_chg.enabled = true;
+	pm2->ac_chg.external = true;
 
 	/* Create a work queue for the charger */
 	pm2->charger_wq =
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
index 4bace67..5ae3573 100644
--- a/drivers/power/pm2301_charger.h
+++ b/drivers/power/pm2301_charger.h
@@ -32,7 +32,7 @@
 
 /* Watchdog timeout constant */
 #define WD_TIMER			0x30 /* 4min */
-#define WD_KICK_INTERVAL		(60 * HZ)
+#define WD_KICK_INTERVAL		(30 * HZ)
 
 #define PM2XXX_NUM_INT_REG		0x6
 
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index 5b77a61..d43ac0f 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -28,13 +28,16 @@ struct ux500_charger_ops {
  * @max_out_volt	maximum output charger voltage in mV
  * @max_out_curr	maximum output charger current in mA
  * @enabled		indicates if this charger is used or not
+ * @external		external charger unit (pm2xxx)
  */
 struct ux500_charger {
 	struct power_supply psy;
 	struct ux500_charger_ops ops;
 	int max_out_volt;
 	int max_out_curr;
+	int wdt_refresh;
 	bool enabled;
+	bool external;
 };
 
 #endif
-- 
1.7.9.5

