Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161473Ab3BOMqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:33 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39247 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161441Ab3BOMq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:27 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/40] ab8500-bm: Add usb power path support
Date: Fri, 15 Feb 2013 12:44:50 +0000
Message-Id: <1360932310-30065-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AB8540 supports power path function in USB charging mode for fast
power up with dead and weak battery, and it could extend
the battery age.

When USB charging starts, if the Vbattrue is below than SW cut off
voltage, power path and pre-charge should be enabled. If Vbattrue
is higher than SW cut off voltage, power path and pre-charge should
be disabled. This is to make sure full current to battery charge.
At the end of charge, power path should be enable again to reduce
charging the battery again.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c            |   81 +++++++++++++++++++++++++++++
 drivers/power/abx500_chargalg.c           |   62 ++++++++++++++++++++++
 include/linux/mfd/abx500.h                |    1 +
 include/linux/mfd/abx500/ab8500-bm.h      |   12 +++++
 include/linux/mfd/abx500/ux500_chargalg.h |    4 ++
 5 files changed, 160 insertions(+)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 6fea4fd..f249a65 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1925,6 +1925,67 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
 	return ret;
 }
 
+/**
+ * ab8540_charger_power_path_enable() - enable usb power path mode
+ * @charger:	pointer to the ux500_charger structure
+ * @enable:	enable/disable flag
+ *
+ * Enable or disable the power path for usb mode
+ * Returns error code in case of failure else 0(on success)
+ */
+static int ab8540_charger_power_path_enable(struct ux500_charger *charger,
+		bool enable)
+{
+	int ret;
+	struct ab8500_charger *di;
+
+	if (charger->psy.type == POWER_SUPPLY_TYPE_USB)
+		di = to_ab8500_charger_usb_device_info(charger);
+	else
+		return -ENXIO;
+
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+				AB8500_CHARGER, AB8540_USB_PP_MODE_REG,
+				BUS_POWER_PATH_MODE_ENA, enable);
+	if (ret) {
+		dev_err(di->dev, "%s write failed\n", __func__);
+		return ret;
+	}
+
+	return ret;
+}
+
+
+/**
+ * ab8540_charger_usb_pre_chg_enable() - enable usb pre change
+ * @charger:	pointer to the ux500_charger structure
+ * @enable:	enable/disable flag
+ *
+ * Enable or disable the pre-chage for usb mode
+ * Returns error code in case of failure else 0(on success)
+ */
+static int ab8540_charger_usb_pre_chg_enable(struct ux500_charger *charger,
+		bool enable)
+{
+	int ret;
+	struct ab8500_charger *di;
+
+	if (charger->psy.type == POWER_SUPPLY_TYPE_USB)
+		di = to_ab8500_charger_usb_device_info(charger);
+	else
+		return -ENXIO;
+
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+				AB8500_CHARGER, AB8540_USB_PP_CHR_REG,
+				BUS_POWER_PATH_PRECHG_ENA, enable);
+	if (ret) {
+		dev_err(di->dev, "%s write failed\n", __func__);
+		return ret;
+	}
+
+	return ret;
+}
+
 static int ab8500_charger_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
@@ -3201,6 +3262,23 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 	if (ret < 0)
 		dev_err(di->dev, "%s mask and set failed\n", __func__);
 
+	if (is_ab8540(di->parent)) {
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER, AB8540_USB_PP_MODE_REG,
+			BUS_VSYS_VOL_SELECT_MASK, BUS_VSYS_VOL_SELECT_3P6V);
+		if (ret) {
+			dev_err(di->dev, "failed to setup usb power path vsys voltage\n");
+			goto out;
+		}
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER, AB8540_USB_PP_CHR_REG,
+			BUS_PP_PRECHG_CURRENT_MASK, 0);
+		if (ret) {
+			dev_err(di->dev, "failed to setup usb power path prechage current\n");
+			goto out;
+		}
+	}
+
 out:
 	return ret;
 }
@@ -3484,6 +3562,8 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.ops.check_enable = &ab8500_charger_usb_check_enable;
 	di->usb_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
 	di->usb_chg.ops.update_curr = &ab8500_charger_update_charger_current;
+	di->usb_chg.ops.pp_enable = &ab8540_charger_power_path_enable;
+	di->usb_chg.ops.pre_chg_enable = &ab8540_charger_usb_pre_chg_enable;
 	di->usb_chg.max_out_volt = ab8500_charger_voltage_map[
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->usb_chg.max_out_curr = ab8500_charger_current_map[
@@ -3491,6 +3571,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->bm->usb_enabled;
 	di->usb_chg.external = false;
+	di->usb_chg.power_path = di->bm->usb_power_path;
 	di->usb_state.usb_current = -1;
 
 	/* Create a work queue for the charger */
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index a876976..a9b8efd 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -34,6 +34,9 @@
 /* End-of-charge criteria counter */
 #define EOC_COND_CNT			10
 
+/* Plus margin for the low battery threshold */
+#define BAT_PLUS_MARGIN                (100)
+
 #define to_abx500_chargalg_device_info(x) container_of((x), \
 	struct abx500_chargalg, chargalg_psy);
 
@@ -83,6 +86,7 @@ enum abx500_chargalg_states {
 	STATE_HW_TEMP_PROTECT_INIT,
 	STATE_HW_TEMP_PROTECT,
 	STATE_NORMAL_INIT,
+	STATE_USB_PP_PRE_CHARGE,
 	STATE_NORMAL,
 	STATE_WAIT_FOR_RECHARGE_INIT,
 	STATE_WAIT_FOR_RECHARGE,
@@ -114,6 +118,7 @@ static const char *states[] = {
 	"HW_TEMP_PROTECT_INIT",
 	"HW_TEMP_PROTECT",
 	"NORMAL_INIT",
+	"USB_PP_PRE_CHARGE",
 	"NORMAL",
 	"WAIT_FOR_RECHARGE_INIT",
 	"WAIT_FOR_RECHARGE",
@@ -560,6 +565,37 @@ static int abx500_chargalg_usb_en(struct abx500_chargalg *di, int enable,
 	return di->usb_chg->ops.enable(di->usb_chg, enable, vset, iset);
 }
 
+ /**
+ * ab8540_chargalg_usb_pp_en() - Enable/ disable USB power path
+ * @di:                pointer to the abx500_chargalg structure
+ * @enable:    power path enable/disable
+ *
+ * The USB power path will be enable/ disable
+ */
+static int ab8540_chargalg_usb_pp_en(struct abx500_chargalg *di, bool enable)
+{
+	if (!di->usb_chg || !di->usb_chg->ops.pp_enable)
+		return -ENXIO;
+
+	return di->usb_chg->ops.pp_enable(di->usb_chg, enable);
+}
+
+/**
+ * ab8540_chargalg_usb_pre_chg_en() - Enable/ disable USB pre-charge
+ * @di:                pointer to the abx500_chargalg structure
+ * @enable:    USB pre-charge enable/disable
+ *
+ * The USB USB pre-charge will be enable/ disable
+ */
+static int ab8540_chargalg_usb_pre_chg_en(struct abx500_chargalg *di,
+					  bool enable)
+{
+	if (!di->usb_chg || !di->usb_chg->ops.pre_chg_enable)
+		return -ENXIO;
+
+	return di->usb_chg->ops.pre_chg_enable(di->usb_chg, enable);
+}
+
 /**
  * abx500_chargalg_update_chg_curr() - Update charger current
  * @di:		pointer to the abx500_chargalg structure
@@ -765,6 +801,9 @@ static void abx500_chargalg_end_of_charge(struct abx500_chargalg *di)
 		di->batt_data.avg_curr > 0) {
 		if (++di->eoc_cnt >= EOC_COND_CNT) {
 			di->eoc_cnt = 0;
+			if ((di->chg_info.charger_type & USB_CHG) &&
+			   (di->usb_chg->power_path))
+				ab8540_chargalg_usb_pp_en(di, true);
 			di->charge_status = POWER_SUPPLY_STATUS_FULL;
 			di->maintenance_chg = true;
 			dev_dbg(di->dev, "EOC reached!\n");
@@ -1465,6 +1504,22 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 		break;
 
 	case STATE_NORMAL_INIT:
+		if ((di->chg_info.charger_type & USB_CHG) &&
+				di->usb_chg->power_path) {
+			if (di->batt_data.volt >
+			    (di->bm->fg_params->lowbat_threshold +
+			     BAT_PLUS_MARGIN)) {
+				ab8540_chargalg_usb_pre_chg_en(di, false);
+				ab8540_chargalg_usb_pp_en(di, false);
+			} else {
+				ab8540_chargalg_usb_pp_en(di, true);
+				ab8540_chargalg_usb_pre_chg_en(di, true);
+				abx500_chargalg_state_to(di,
+					STATE_USB_PP_PRE_CHARGE);
+				break;
+			}
+		}
+
 		abx500_chargalg_start_charging(di,
 			di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
 			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
@@ -1479,6 +1534,13 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 
 		break;
 
+	case STATE_USB_PP_PRE_CHARGE:
+		if (di->batt_data.volt >
+			(di->bm->fg_params->lowbat_threshold +
+			BAT_PLUS_MARGIN))
+			abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
+		break;
+
 	case STATE_NORMAL:
 		handle_maxim_chg_curr(di);
 		if (di->charge_status == POWER_SUPPLY_STATUS_FULL &&
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 21b3f67..0104df8 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -267,6 +267,7 @@ struct abx500_bm_data {
 	bool autopower_cfg;
 	bool ac_enabled;
 	bool usb_enabled;
+	bool usb_power_path;
 	bool no_maintenance;
 	bool capacity_scaling;
 	bool chg_unknown_bat;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 95bdef7..cf7bac6 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -69,6 +69,8 @@
 #define AB8500_USBCH_CTRL1_REG		0xC0
 #define AB8500_USBCH_CTRL2_REG		0xC1
 #define AB8500_USBCH_IPT_CRNTLVL_REG	0xC2
+#define AB8540_USB_PP_MODE_REG		0xC5
+#define AB8540_USB_PP_CHR_REG		0xC6
 
 /*
  * Gas Gauge register offsets
@@ -259,6 +261,16 @@ enum bup_vch_sel {
 #define AB8505_RTC_PCUT_RESTART_REG	0x16
 #define AB8505_RTC_PCUT_DEBOUNCE_REG	0x17
 
+/* USB Power Path constants for ab8540 */
+#define BUS_VSYS_VOL_SELECT_MASK		0x06
+#define BUS_VSYS_VOL_SELECT_3P6V		0x00
+#define BUS_VSYS_VOL_SELECT_3P325V		0x02
+#define BUS_VSYS_VOL_SELECT_3P9V		0x04
+#define BUS_VSYS_VOL_SELECT_4P3V		0x06
+#define BUS_POWER_PATH_MODE_ENA			0x01
+#define BUS_PP_PRECHG_CURRENT_MASK		0x0E
+#define BUS_POWER_PATH_PRECHG_ENA		0x01
+
 /**
  * struct res_to_temp - defines one point in a temp to res curve. To
  * be used in battery packs that combines the identification resistor with a
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index fa831f1..234c991 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -20,6 +20,8 @@ struct ux500_charger_ops {
 	int (*check_enable) (struct ux500_charger *, int, int);
 	int (*kick_wd) (struct ux500_charger *);
 	int (*update_curr) (struct ux500_charger *, int);
+	int (*pp_enable) (struct ux500_charger *, bool);
+	int (*pre_chg_enable) (struct ux500_charger *, bool);
 };
 
 /**
@@ -30,6 +32,7 @@ struct ux500_charger_ops {
  * @max_out_curr	maximum output charger current in mA
  * @enabled		indicates if this charger is used or not
  * @external		external charger unit (pm2xxx)
+ * @power_path		USB power path support
  */
 struct ux500_charger {
 	struct power_supply psy;
@@ -39,6 +42,7 @@ struct ux500_charger {
 	int wdt_refresh;
 	bool enabled;
 	bool external;
+	bool power_path;
 };
 
 extern struct blocking_notifier_head charger_notifier_list;
-- 
1.7.10.4

