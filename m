Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161394Ab3BOMqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:08 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57704 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374Ab3BOMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/40] ab8500-bm: Quick re-attach charging behaviour
Date: Fri, 15 Feb 2013 12:44:38 +0000
Message-Id: <1360932310-30065-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a bug in some AB8500 ASICs charger removal cannot always
be detected if the removal and reinsertion is done to close in time.
This patch detects above described case and handles the situation
so that charging will be kept turned on.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c            |  105 ++++++++++++++++++++++++++++-
 drivers/power/abx500_chargalg.c           |   33 +++++++++
 include/linux/mfd/abx500/ux500_chargalg.h |    1 +
 3 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index dcd3c6f..3eb23cf 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -52,6 +52,7 @@
 #define VBUS_DET_DBNC100		0x02
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
+#define DROP_COUNT_RESET		0x01
 
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
@@ -1678,6 +1679,105 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 }
 
 /**
+ * ab8500_charger_usb_check_enable() - enable usb charging
+ * @charger:	pointer to the ux500_charger structure
+ * @vset:	charging voltage
+ * @iset:	charger output current
+ *
+ * Check if the VBUS charger has been disconnected and reconnected without
+ * AB8500 rising an interrupt. Returns 0 on success.
+ */
+static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
+	int vset, int iset)
+{
+	u8 usbch_ctrl1 = 0;
+	int ret = 0;
+
+	struct ab8500_charger *di = to_ab8500_charger_usb_device_info(charger);
+
+	if (!di->usb.charger_connected)
+		return ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8500_USBCH_CTRL1_REG, &usbch_ctrl1);
+	if (ret < 0) {
+		dev_err(di->dev, "ab8500 read failed %d\n", __LINE__);
+		return ret;
+	}
+	dev_dbg(di->dev, "USB charger ctrl: 0x%02x\n", usbch_ctrl1);
+
+	if (!(usbch_ctrl1 & USB_CH_ENA)) {
+		dev_info(di->dev, "Charging has been disabled abnormally and will be re-enabled\n");
+
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_CHARGER, AB8500_CHARGER_CTRL,
+					DROP_COUNT_RESET, DROP_COUNT_RESET);
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 write failed %d\n", __LINE__);
+			return ret;
+		}
+
+		ret = ab8500_charger_usb_en(&di->usb_chg, true, vset, iset);
+		if (ret < 0) {
+			dev_err(di->dev, "Failed to enable VBUS charger %d\n",
+					__LINE__);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
+ * ab8500_charger_ac_check_enable() - enable usb charging
+ * @charger:	pointer to the ux500_charger structure
+ * @vset:	charging voltage
+ * @iset:	charger output current
+ *
+ * Check if the AC charger has been disconnected and reconnected without
+ * AB8500 rising an interrupt. Returns 0 on success.
+ */
+static int ab8500_charger_ac_check_enable(struct ux500_charger *charger,
+	int vset, int iset)
+{
+	u8 mainch_ctrl1 = 0;
+	int ret = 0;
+
+	struct ab8500_charger *di = to_ab8500_charger_ac_device_info(charger);
+
+	if (!di->ac.charger_connected)
+		return ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8500_MCH_CTRL1, &mainch_ctrl1);
+	if (ret < 0) {
+		dev_err(di->dev, "ab8500 read failed %d\n", __LINE__);
+		return ret;
+	}
+	dev_dbg(di->dev, "AC charger ctrl: 0x%02x\n", mainch_ctrl1);
+
+	if (!(mainch_ctrl1 & MAIN_CH_ENA)) {
+		dev_info(di->dev, "Charging has been disabled abnormally and will be re-enabled\n");
+
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_CHARGER, AB8500_CHARGER_CTRL,
+					DROP_COUNT_RESET, DROP_COUNT_RESET);
+
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 write failed %d\n", __LINE__);
+			return ret;
+		}
+
+		ret = ab8500_charger_ac_en(&di->usb_chg, true, vset, iset);
+		if (ret < 0) {
+			dev_err(di->dev, "failed to enable AC charger %d\n",
+				__LINE__);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
  * ab8500_charger_watchdog_kick() - kick charger watchdog
  * @di:		pointer to the ab8500_charger structure
  *
@@ -1734,8 +1834,7 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
 
 	/* Reset the main and usb drop input current measurement counter */
 	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-				AB8500_CHARGER_CTRL,
-				0x1);
+				AB8500_CHARGER_CTRL, DROP_COUNT_RESET);
 	if (ret) {
 		dev_err(di->dev, "%s write failed\n", __func__);
 		return ret;
@@ -3221,6 +3320,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	/* ux500_charger sub-class */
 	di->ac_chg.ops.enable = &ab8500_charger_ac_en;
+	di->ac_chg.ops.check_enable = &ab8500_charger_ac_check_enable;
 	di->ac_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
 	di->ac_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->ac_chg.max_out_volt = ab8500_charger_voltage_map[
@@ -3242,6 +3342,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	/* ux500_charger sub-class */
 	di->usb_chg.ops.enable = &ab8500_charger_usb_en;
+	di->usb_chg.ops.check_enable = &ab8500_charger_usb_check_enable;
 	di->usb_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
 	di->usb_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->usb_chg.max_out_volt = ab8500_charger_voltage_map[
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 31507bf..8ab65a3 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -305,6 +305,30 @@ static void abx500_chargalg_state_to(struct abx500_chargalg *di,
 	di->charge_state = state;
 }
 
+static int abx500_chargalg_check_charger_enable(struct abx500_chargalg *di)
+{
+	switch (di->charge_state) {
+	case STATE_NORMAL:
+	case STATE_MAINTENANCE_A:
+	case STATE_MAINTENANCE_B:
+		break;
+	default:
+		return 0;
+	}
+
+	if (di->chg_info.charger_type & USB_CHG) {
+		return di->usb_chg->ops.check_enable(di->usb_chg,
+                         di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
+                         di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
+	} else if ((di->chg_info.charger_type & AC_CHG) &&
+		   !(di->ac_chg->external)) {
+		return di->ac_chg->ops.check_enable(di->ac_chg,
+                         di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
+                         di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
+	}
+	return 0;
+}
+
 /**
  * abx500_chargalg_check_charger_connection() - Check charger connection change
  * @di:		pointer to the abx500_chargalg structure
@@ -1219,6 +1243,7 @@ static void abx500_chargalg_external_power_changed(struct power_supply *psy)
 static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 {
 	int charger_status;
+	int ret;
 
 	/* Collect data from all power_supply class devices */
 	class_for_each_device(power_supply_class, NULL,
@@ -1229,6 +1254,14 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	abx500_chargalg_check_charger_voltage(di);
 
 	charger_status = abx500_chargalg_check_charger_connection(di);
+
+	if (is_ab8500(di->parent)) {
+		ret = abx500_chargalg_check_charger_enable(di);
+		if (ret < 0)
+			dev_err(di->dev, "Checking charger is enabled error"
+					": Returned Value %d\n", ret);
+	}
+
 	/*
 	 * First check if we have a charger connected.
 	 * Also we don't allow charging of unknown batteries if configured
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index d43ac0f..110d12f 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -17,6 +17,7 @@ struct ux500_charger;
 
 struct ux500_charger_ops {
 	int (*enable) (struct ux500_charger *, int, int, int);
+	int (*check_enable) (struct ux500_charger *, int, int);
 	int (*kick_wd) (struct ux500_charger *);
 	int (*update_curr) (struct ux500_charger *, int);
 };
-- 
1.7.10.4

