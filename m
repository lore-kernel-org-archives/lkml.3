Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161458Ab3BOMqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:30 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34324 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161397Ab3BOMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:18 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/40] ab8500_charger: Prevent auto drop of VBUS
Date: Fri, 15 Feb 2013 12:44:43 +0000
Message-Id: <1360932310-30065-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not set higher current in stepping functionality if VBUS is dropping.
After VBUS has dropped try to set current once again. If dropping again
then we have found the maximum capability of the charger.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |  169 ++++++++++++++++++++++++++++------------
 1 file changed, 120 insertions(+), 49 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index f1d7123..547f6ea 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -58,6 +58,7 @@
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
 #define AUTO_VBUS_IN_CURR_LIM_SHIFT	4
+#define VBUS_IN_CURR_LIM_RETRY_SET_TIME	30 /* seconds */
 
 #define LED_INDICATOR_PWM_ENA		0x01
 #define LED_INDICATOR_PWM_DIS		0x00
@@ -202,10 +203,15 @@ struct ab8500_charger_usb_state {
 	spinlock_t usb_lock;
 };
 
+struct ab8500_charger_max_usb_in_curr {
+	int usb_type_max;
+	int set_max;
+	int calculated_max;
+};
+
 /**
  * struct ab8500_charger - ab8500 Charger device information
  * @dev:		Pointer to the structure device
- * @max_usb_in_curr:	Max USB charger input current
  * @vbus_detected:	VBUS detected
  * @vbus_detected_start:
  *			VBUS detected during startup
@@ -220,7 +226,6 @@ struct ab8500_charger_usb_state {
  * @autopower		Indicate if we should have automatic pwron after pwrloss
  * @autopower_cfg	platform specific power config support for "pwron after pwrloss"
  * @invalid_charger_detect_state State when forcing AB to use invalid charger
- * @is_usb_host:	Indicate if last detected USB type is host
  * @is_aca_rid:		Incicate if accessory is ACA type
  * @current_stepping_sessions:
  *			Counter for current stepping sessions
@@ -229,6 +234,7 @@ struct ab8500_charger_usb_state {
  * @bm:           	Platform specific battery management information
  * @flags:		Structure for information about events triggered
  * @usb_state:		Structure for usb stack information
+ * @max_usb_in_curr:	Max USB charger input current
  * @ac_chg:		AC charger power supply
  * @usb_chg:		USB charger power supply
  * @ac:			Structure that holds the AC charger properties
@@ -260,7 +266,6 @@ struct ab8500_charger_usb_state {
  */
 struct ab8500_charger {
 	struct device *dev;
-	int max_usb_in_curr;
 	bool vbus_detected;
 	bool vbus_detected_start;
 	bool ac_conn;
@@ -272,7 +277,6 @@ struct ab8500_charger {
 	bool autopower;
 	bool autopower_cfg;
 	int invalid_charger_detect_state;
-	bool is_usb_host;
 	int is_aca_rid;
 	atomic_t current_stepping_sessions;
 	struct ab8500 *parent;
@@ -280,6 +284,7 @@ struct ab8500_charger {
 	struct abx500_bm_data *bm;
 	struct ab8500_charger_event_flags flags;
 	struct ab8500_charger_usb_state usb_state;
+	struct ab8500_charger_max_usb_in_curr max_usb_in_curr;
 	struct ux500_charger ac_chg;
 	struct ux500_charger usb_chg;
 	struct ab8500_charger_info ac;
@@ -421,6 +426,10 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 	if (connected != di->usb.charger_connected) {
 		dev_dbg(di->dev, "USB connected:%i\n", connected);
 		di->usb.charger_connected = connected;
+
+		if (!connected)
+			di->flags.vbus_drop_end = false;
+
 		sysfs_notify(&di->usb_chg.psy.dev->kobj, NULL, "present");
 
 		if (connected) {
@@ -674,23 +683,19 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	case USB_STAT_STD_HOST_C_S:
 		dev_dbg(di->dev, "USB Type - Standard host is "
 			"detected through USB driver\n");
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
-		di->is_usb_host = true;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_HOST_CHG_HS_CHIRP:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
-		di->is_usb_host = true;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_HOST_CHG_HS:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
-		di->is_usb_host = true;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_ACA_RID_C_HS:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P9;
-		di->is_usb_host = false;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P9;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_ACA_RID_A:
@@ -699,8 +704,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		 * can consume (900mA). Closest level is 500mA
 		 */
 		dev_dbg(di->dev, "USB_STAT_ACA_RID_A detected\n");
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
-		di->is_usb_host = false;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		di->is_aca_rid = 1;
 		break;
 	case USB_STAT_ACA_RID_B:
@@ -708,38 +712,35 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		 * Dedicated charger level minus 120mA (20mA for ACA and
 		 * 100mA for potential accessory). Closest level is 1300mA
 		 */
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P3;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P3;
 		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
-				di->max_usb_in_curr);
-		di->is_usb_host = false;
+				di->max_usb_in_curr.usb_type_max);
 		di->is_aca_rid = 1;
 		break;
 	case USB_STAT_HOST_CHG_NM:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
-		di->is_usb_host = true;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_DEDICATED_CHG:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
-		di->is_usb_host = false;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P5;
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_ACA_RID_C_HS_CHIRP:
 	case USB_STAT_ACA_RID_C_NM:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
-		di->is_usb_host = false;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P5;
 		di->is_aca_rid = 1;
 		break;
 	case USB_STAT_NOT_CONFIGURED:
 		if (di->vbus_detected) {
 			di->usb_device_is_unrecognised = true;
 			dev_dbg(di->dev, "USB Type - Legacy charger.\n");
-			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
+			di->max_usb_in_curr.usb_type_max =
+						USB_CH_IP_CUR_LVL_1P5;
 			break;
 		}
 	case USB_STAT_HM_IDGND:
 		dev_err(di->dev, "USB Type - Charging not allowed\n");
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
 		ret = -ENXIO;
 		break;
 	case USB_STAT_RESERVED:
@@ -752,9 +753,11 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		}
 		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			dev_dbg(di->dev, "USB Type - Charging not allowed\n");
-			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
+			di->max_usb_in_curr.usb_type_max =
+						USB_CH_IP_CUR_LVL_0P05;
 			dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
-					link_status, di->max_usb_in_curr);
+				link_status,
+				di->max_usb_in_curr.usb_type_max);
 			ret = -ENXIO;
 			break;
 		}
@@ -763,23 +766,24 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	case USB_STAT_CARKIT_2:
 	case USB_STAT_ACA_DOCK_CHARGER:
 	case USB_STAT_CHARGER_LINE_1:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
-				di->max_usb_in_curr);
+				di->max_usb_in_curr.usb_type_max);
 	case USB_STAT_NOT_VALID_LINK:
 		dev_err(di->dev, "USB Type invalid - try charging anyway\n");
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		break;
 
 	default:
 		dev_err(di->dev, "USB Type - Unknown\n");
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
 		ret = -ENXIO;
 		break;
 	};
 
+	di->max_usb_in_curr.set_max = di->max_usb_in_curr.usb_type_max;
 	dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
-		link_status, di->max_usb_in_curr);
+		link_status, di->max_usb_in_curr.set_max);
 
 	return ret;
 }
@@ -1083,28 +1087,48 @@ static int ab8500_vbus_in_curr_to_regval(int curr)
  */
 static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
 {
+	int ret = 0;
 	switch (di->usb_state.usb_current) {
 	case 100:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P09;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P09;
 		break;
 	case 200:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P19;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P19;
 		break;
 	case 300:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P29;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P29;
 		break;
 	case 400:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P38;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P38;
 		break;
 	case 500:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
 		break;
 	default:
-		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
-		return -1;
+		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
+		ret = -EPERM;
 		break;
 	};
-	return 0;
+	di->max_usb_in_curr.set_max = di->max_usb_in_curr.usb_type_max;
+	return ret;
+}
+
+/**
+ * ab8500_charger_check_continue_stepping() - Check to allow stepping
+ * @di:		pointer to the ab8500_charger structure
+ * @reg:	select what charger register to check
+ *
+ * Check if current stepping should be allowed to continue.
+ * Checks if charger source has not collapsed. If it has, further stepping
+ * is not allowed.
+ */
+static bool ab8500_charger_check_continue_stepping(struct ab8500_charger *di,
+						   int reg)
+{
+	if (reg == AB8500_USBCH_IPT_CRNTLVL_REG)
+		return !di->flags.vbus_drop_end;
+	else
+		return true;
 }
 
 /**
@@ -1225,7 +1249,8 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 				usleep_range(step_udelay, step_udelay * 2);
 		}
 	} else {
-		for (i = prev_curr_index + 1; i <= curr_index; i++) {
+		bool allow = true;
+		for (i = prev_curr_index + 1; i <= curr_index && allow; i++) {
 			dev_dbg(di->dev, "curr change_2 to: %x for 0x%02x\n",
 				(u8)i << shift_value, reg);
 			ret = abx500_set_register_interruptible(di->dev,
@@ -1236,6 +1261,8 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 			}
 			if (i != curr_index)
 				usleep_range(step_udelay, step_udelay * 2);
+
+			allow = ab8500_charger_check_continue_stepping(di, reg);
 		}
 	}
 
@@ -1261,6 +1288,11 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
 
 	/* We should always use to lowest current limit */
 	min_value = min(di->bm->chg_params->usb_curr_max, ich_in);
+	if (di->max_usb_in_curr.set_max > 0)
+		min_value = min(di->max_usb_in_curr.set_max, min_value);
+
+	if (di->usb_state.usb_current >= 0)
+		min_value = min(di->usb_state.usb_current, min_value);
 
 	switch (min_value) {
 	case 100:
@@ -1615,7 +1647,8 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 		di->usb.charger_online = 1;
 
 		/* USBChInputCurr: current that can be drawn from the usb */
-		ret = ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
+		ret = ab8500_charger_set_vbus_in_curr(di,
+					di->max_usb_in_curr.usb_type_max);
 		if (ret) {
 			dev_err(di->dev, "setting USBChInputCurr failed\n");
 			return ret;
@@ -1950,9 +1983,10 @@ static void ab8500_charger_check_vbat_work(struct work_struct *work)
 		di->vbat > VBAT_TRESH_IP_CUR_RED))) {
 
 		dev_dbg(di->dev, "Vbat did cross threshold, curr: %d, new: %d,"
-			" old: %d\n", di->max_usb_in_curr, di->vbat,
-			di->old_vbat);
-		ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
+			" old: %d\n", di->max_usb_in_curr.usb_type_max,
+			di->vbat, di->old_vbat);
+		ab8500_charger_set_vbus_in_curr(di,
+					di->max_usb_in_curr.usb_type_max);
 		power_supply_changed(&di->usb_chg.psy);
 	}
 
@@ -2232,7 +2266,8 @@ static void ab8500_charger_usb_link_attach_work(struct work_struct *work)
 
 	/* Update maximum input current if USB enumeration is not detected */
 	if (!di->usb.charger_online) {
-		ret = ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
+		ret = ab8500_charger_set_vbus_in_curr(di,
+					di->max_usb_in_curr.usb_type_max);
 		if (ret)
 			return;
 	}
@@ -2400,7 +2435,7 @@ static void ab8500_charger_usb_state_changed_work(struct work_struct *work)
 		if (!ab8500_charger_get_usb_cur(di)) {
 			/* Update maximum input current */
 			ret = ab8500_charger_set_vbus_in_curr(di,
-					di->max_usb_in_curr);
+					di->max_usb_in_curr.usb_type_max);
 			if (ret)
 				return;
 
@@ -2618,15 +2653,45 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
 {
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, vbus_drop_end_work.work);
+	int ret;
+	u8 reg_value;
 
 	di->flags.vbus_drop_end = false;
 
 	/* Reset the drop counter */
 	abx500_set_register_interruptible(di->dev,
 				  AB8500_CHARGER, AB8500_CHARGER_CTRL, 0x01);
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+						AB8500_CH_USBCH_STAT2_REG,
+						&reg_value);
+	if (ret < 0) {
+		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
+	} else {
+		int curr = ab8500_charger_vbus_in_curr_map[
+			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT];
+		if (di->max_usb_in_curr.calculated_max != curr) {
+			/* USB source is collapsing */
+			di->max_usb_in_curr.calculated_max = curr;
+			dev_dbg(di->dev,
+				 "VBUS input current limiting to %d mA\n",
+				 di->max_usb_in_curr.calculated_max);
+		} else {
+			/*
+			 * USB source can not give more than this amount.
+			 * Taking more will collapse the source.
+			 */
+			di->max_usb_in_curr.set_max =
+				di->max_usb_in_curr.calculated_max;
+			dev_dbg(di->dev,
+				 "VBUS input current limited to %d mA\n",
+				 di->max_usb_in_curr.set_max);
+			return;
+		}
+	}
 
 	if (di->usb.charger_connected)
-		ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
+		ab8500_charger_set_vbus_in_curr(di,
+					di->max_usb_in_curr.usb_type_max);
 }
 
 /**
@@ -2781,8 +2846,13 @@ static irqreturn_t ab8500_charger_vbuschdropend_handler(int irq, void *_di)
 
 	dev_dbg(di->dev, "VBUS charger drop ended\n");
 	di->flags.vbus_drop_end = true;
+
+	/*
+	 * VBUS might have dropped due to bad connection.
+	 * Schedule a new input limit set to the value SW requests.
+	 */
 	queue_delayed_work(di->charger_wq, &di->vbus_drop_end_work,
-			   round_jiffies(30 * HZ));
+			   round_jiffies(VBUS_IN_CURR_LIM_RETRY_SET_TIME * HZ));
 
 	return IRQ_HANDLED;
 }
@@ -3394,6 +3464,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->bm->usb_enabled;
 	di->usb_chg.external = false;
+	di->usb_state.usb_current = -1;
 
 	/* Create a work queue for the charger */
 	di->charger_wq =
-- 
1.7.10.4

