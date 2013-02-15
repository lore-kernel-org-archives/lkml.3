Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161504Ab3BOMqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:43 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33491 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161464Ab3BOMqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/40] ab8500-bm: Add support for the new ab8540 platform
Date: Fri, 15 Feb 2013 12:44:52 +0000
Message-Id: <1360932310-30065-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide AB8540 platform specific information required to run the
Battery Management subsystem on AB8540 based devices. For this to
happen we see the introduction of separate platform specific data
structures and a means in which to process them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_bmdata.c        |   91 +++++++++++-
 drivers/power/ab8500_btemp.c         |   42 +++++-
 drivers/power/ab8500_charger.c       |  270 ++++++++++++++--------------------
 include/linux/mfd/abx500.h           |   10 +-
 include/linux/mfd/abx500/ab8500-bm.h |    5 +-
 5 files changed, 248 insertions(+), 170 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 17744d9..e4cf1cb 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -414,13 +414,20 @@ static const struct abx500_fg_parameters fg = {
 	.pcut_debounce_time = 2,
 };
 
-static const struct abx500_maxim_parameters maxi_params = {
+static const struct abx500_maxim_parameters ab8500_maxi_params = {
 	.ena_maxi = true,
 	.chg_curr = 910,
 	.wait_cycles = 10,
 	.charger_curr_step = 100,
 };
 
+static const struct abx500_maxim_parameters abx540_maxi_params = {
+        .ena_maxi = true,
+        .chg_curr = 3000,
+        .wait_cycles = 10,
+        .charger_curr_step = 200,
+};
+
 static const struct abx500_bm_charger_parameters chg = {
 	.usb_volt_max		= 5500,
 	.usb_curr_max		= 1500,
@@ -428,6 +435,46 @@ static const struct abx500_bm_charger_parameters chg = {
 	.ac_curr_max		= 1500,
 };
 
+/*
+ * This array maps the raw hex value to charger output current used by the
+ * AB8500 values
+ */
+static int ab8500_charge_output_curr_map[] = {
+        100,    200,    300,    400,    500,    600,    700,    800,
+        900,    1000,   1100,   1200,   1300,   1400,   1500,   1500,
+};
+
+static int ab8540_charge_output_curr_map[] = {
+        0,      0,      0,      75,     100,    125,    150,    175,
+        200,    225,    250,    275,    300,    325,    350,    375,
+        400,    425,    450,    475,    500,    525,    550,    575,
+        600,    625,    650,    675,    700,    725,    750,    775,
+        800,    825,    850,    875,    900,    925,    950,    975,
+        1000,   1025,   1050,   1075,   1100,   1125,   1150,   1175,
+        1200,   1225,   1250,   1275,   1300,   1325,   1350,   1375,
+        1400,   1425,   1450,   1500,   1600,   1700,   1900,   2000,
+};
+
+/*
+ * This array maps the raw hex value to charger input current used by the
+ * AB8500 values
+ */
+static int ab8500_charge_input_curr_map[] = {
+        50,     98,     193,    290,    380,    450,    500,    600,
+        700,    800,    900,    1000,   1100,   1300,   1400,   1500,
+};
+
+static int ab8540_charge_input_curr_map[] = {
+        25,     50,     75,     100,    125,    150,    175,    200,
+        225,    250,    275,    300,    325,    350,    375,    400,
+        425,    450,    475,    500,    525,    550,    575,    600,
+        625,    650,    675,    700,    725,    750,    775,    800,
+        825,    850,    875,    900,    925,    950,    975,    1000,
+        1025,   1050,   1075,   1100,   1125,   1150,   1175,   1200,
+        1225,   1250,   1275,   1300,   1325,   1350,   1375,   1400,
+        1425,   1450,   1475,   1500,   1500,   1500,   1500,   1500,
+};
+
 struct abx500_bm_data ab8500_bm_data = {
 	.temp_under             = 3,
 	.temp_low               = 8,
@@ -447,15 +494,53 @@ struct abx500_bm_data ab8500_bm_data = {
 	.fg_res                 = 100,
 	.cap_levels             = &cap_levels,
 	.bat_type               = bat_type_thermistor,
-	.n_btypes               = 3,
+	.n_btypes               = ARRAY_SIZE(bat_type_thermistor),
 	.batt_id                = 0,
 	.interval_charging      = 5,
 	.interval_not_charging  = 120,
 	.temp_hysteresis        = 3,
 	.gnd_lift_resistance    = 34,
-	.maxi                   = &maxi_params,
+	.chg_output_curr        = ab8500_charge_output_curr_map,
+	.n_chg_out_curr         = ARRAY_SIZE(ab8500_charge_output_curr_map),
+	.maxi                   = &ab8500_maxi_params,
 	.chg_params             = &chg,
 	.fg_params              = &fg,
+        .chg_input_curr         = ab8500_charge_input_curr_map,
+        .n_chg_in_curr          = ARRAY_SIZE(ab8500_charge_input_curr_map),
+};
+
+struct abx500_bm_data ab8540_bm_data = {
+        .temp_under             = 3,
+        .temp_low               = 8,
+        .temp_high              = 43,
+        .temp_over              = 48,
+        .main_safety_tmr_h      = 4,
+        .temp_interval_chg      = 20,
+        .temp_interval_nochg    = 120,
+        .usb_safety_tmr_h       = 4,
+        .bkup_bat_v             = BUP_VCH_SEL_2P6V,
+        .bkup_bat_i             = BUP_ICH_SEL_150UA,
+        .no_maintenance         = false,
+        .capacity_scaling       = false,
+        .adc_therm              = ABx500_ADC_THERM_BATCTRL,
+        .chg_unknown_bat        = false,
+        .enable_overshoot       = false,
+        .fg_res                 = 100,
+        .cap_levels             = &cap_levels,
+        .bat_type               = bat_type_thermistor,
+        .n_btypes               = ARRAY_SIZE(bat_type_thermistor),
+        .batt_id                = 0,
+        .interval_charging      = 5,
+        .interval_not_charging  = 120,
+        .temp_hysteresis        = 3,
+        .gnd_lift_resistance    = 0,
+        .maxi                   = &abx540_maxi_params,
+        .chg_params             = &chg,
+        .fg_params              = &fg,
+        .chg_output_curr        = ab8540_charge_output_curr_map,
+        .n_chg_out_curr         = ARRAY_SIZE(ab8540_charge_output_curr_map),
+        .chg_input_curr         = ab8540_charge_input_curr_map,
+        .n_chg_in_curr          = ARRAY_SIZE(ab8540_charge_input_curr_map),
 };
 
 int __devinit ab8500_bm_of_probe(struct device *dev,
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 91ad3ed..7336dcf 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -42,6 +42,9 @@
 #define BTEMP_BATCTRL_CURR_SRC_16UA	16
 #define BTEMP_BATCTRL_CURR_SRC_18UA	18
 
+#define BTEMP_BATCTRL_CURR_SRC_60UA	60
+#define BTEMP_BATCTRL_CURR_SRC_120UA	120
+
 #define to_ab8500_btemp_device_info(x) container_of((x), \
 	struct ab8500_btemp, btemp_psy);
 
@@ -216,7 +219,12 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	/* Only do this for batteries with internal NTC */
 	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
 
-		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		if (is_ab8540(di->parent)) {
+			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_60UA)
+				curr = BAT_CTRL_60U_ENA;
+			else
+				curr = BAT_CTRL_120U_ENA;
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_16UA)
 				curr = BAT_CTRL_16U_ENA;
 			else
@@ -257,7 +265,14 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	} else if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
 		dev_dbg(di->dev, "Disable BATCTRL curr source\n");
 
-		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		if (is_ab8540(di->parent)) {
+			/* Write 0 to the curr bits */
+			ret = abx500_mask_and_set_register_interruptible(
+				di->dev,
+				AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+				BAT_CTRL_60U_ENA | BAT_CTRL_120U_ENA,
+				~(BAT_CTRL_60U_ENA | BAT_CTRL_120U_ENA));
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			/* Write 0 to the curr bits */
 			ret = abx500_mask_and_set_register_interruptible(
 				di->dev,
@@ -314,7 +329,13 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	 * if we got an error above
 	 */
 disable_curr_source:
-	if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+	if (is_ab8540(di->parent)) {
+		/* Write 0 to the curr bits */
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+			BAT_CTRL_60U_ENA | BAT_CTRL_120U_ENA,
+			~(BAT_CTRL_60U_ENA | BAT_CTRL_120U_ENA));
+	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 		/* Write 0 to the curr bits */
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
@@ -541,7 +562,9 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 {
 	int res;
 	u8 i;
-	if (is_ab9540(di->parent) || is_ab8505(di->parent))
+	if (is_ab8540(di->parent))
+		di->curr_source = BTEMP_BATCTRL_CURR_SRC_60UA;
+	else if (is_ab9540(di->parent) || is_ab8505(di->parent))
 		di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
 	else
 		di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
@@ -582,9 +605,14 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	 * detected type is Type 1, else we use the 7uA source
 	 */
 	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL &&
-			di->bm->batt_id == 1) {
-		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-			dev_dbg(di->dev, "Set BATCTRL current source to 16uA\n");
+	    di->bm->batt_id == 1) {
+		if (is_ab8540(di->parent)) {
+			dev_dbg(di->dev,
+				"Set BATCTRL current source to 60uA\n");
+			di->curr_source = BTEMP_BATCTRL_CURR_SRC_60UA;
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			dev_dbg(di->dev,
+				"Set BATCTRL current source to 16uA\n");
 			di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
 		} else {
 			dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index f249a65..6089ee7 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -57,7 +57,9 @@
 
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
+#define AB8540_VBUS_IN_CURR_LIM_SHIFT	2
 #define AUTO_VBUS_IN_CURR_LIM_SHIFT	4
+#define AB8540_AUTO_VBUS_IN_CURR_MASK	0x3F
 #define VBUS_IN_CURR_LIM_RETRY_SET_TIME	30 /* seconds */
 
 #define LED_INDICATOR_PWM_ENA		0x01
@@ -82,6 +84,7 @@
 #define AB8500_USB_LINK_STATUS		0x78
 #define AB8505_USB_LINK_STATUS		0xF8
 #define AB8500_STD_HOST_SUSP		0x18
+#define USB_LINK_STATUS_SHIFT		3
 
 /* Watchdog timeout constant */
 #define WD_TIMER			0x30 /* 4min */
@@ -751,8 +754,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 						"VBUS has collapsed\n");
 			ret = -ENXIO;
 			break;
-		}
-		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		} else {
 			dev_dbg(di->dev, "USB Type - Charging not allowed\n");
 			di->max_usb_in_curr.usb_type_max =
 						USB_CH_IP_CUR_LVL_0P05;
@@ -807,30 +809,22 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
 	}
-	if (is_ab8500(di->parent)) {
+	if (is_ab8500(di->parent))
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-				AB8500_USB_LINE_STAT_REG, &val);
-	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-			ret = abx500_get_register_interruptible(di->dev,
-				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
-	} else {
-		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-		return -ENXIO;
-	}
+			AB8500_USB_LINE_STAT_REG, &val);
+	else
+		ret = abx500_get_register_interruptible(di->dev,
+			AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
 	}
 
 	/* get the USB type */
-	if (is_ab8500(di->parent)) {
-		val = (val & AB8500_USB_LINK_STATUS) >> 3;
-	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-			val = (val & AB8505_USB_LINK_STATUS) >> 3;
-	} else {
-		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-		return -ENXIO;
-	}
+	if (is_ab8500(di->parent))
+		val = (val & AB8500_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
+	else
+		val = (val & AB8505_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
 	ret = ab8500_charger_max_usb_curr(di,
 		(enum ab8500_charger_link_status) val);
 
@@ -866,16 +860,12 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 			return ret;
 		}
 
-		if (is_ab8500(di->parent)) {
+		if (is_ab8500(di->parent))
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINE_STAT_REG, &val);
-		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		else
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
-		} else {
-			dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-			return -ENXIO;
-		}
 		if (ret < 0) {
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
@@ -889,14 +879,12 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		 */
 
 		/* get the USB type */
-		if (is_ab8500(di->parent)) {
-			val = (val & AB8500_USB_LINK_STATUS) >> 3;
-		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-				val = (val & AB8505_USB_LINK_STATUS) >> 3;
-		} else {
-			dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-			return -ENXIO;
-		}
+		if (is_ab8500(di->parent))
+			val = (val & AB8500_USB_LINK_STATUS) >>
+							USB_LINK_STATUS_SHIFT;
+		else
+			val = (val & AB8505_USB_LINK_STATUS) >>
+							USB_LINK_STATUS_SHIFT;
 		if (val)
 			break;
 	}
@@ -991,51 +979,6 @@ static int ab8500_charger_voltage_map[] = {
 	4600 ,
 };
 
-/*
- * This array maps the raw hex value to charger current used by the AB8500
- * Values taken from the UM0836
- */
-static int ab8500_charger_current_map[] = {
-	100 ,
-	200 ,
-	300 ,
-	400 ,
-	500 ,
-	600 ,
-	700 ,
-	800 ,
-	900 ,
-	1000 ,
-	1100 ,
-	1200 ,
-	1300 ,
-	1400 ,
-	1500 ,
-};
-
-/*
- * This array maps the raw hex value to VBUS input current used by the AB8500
- * Values taken from the UM0836
- */
-static int ab8500_charger_vbus_in_curr_map[] = {
-	USB_CH_IP_CUR_LVL_0P05,
-	USB_CH_IP_CUR_LVL_0P09,
-	USB_CH_IP_CUR_LVL_0P19,
-	USB_CH_IP_CUR_LVL_0P29,
-	USB_CH_IP_CUR_LVL_0P38,
-	USB_CH_IP_CUR_LVL_0P45,
-	USB_CH_IP_CUR_LVL_0P5,
-	USB_CH_IP_CUR_LVL_0P6,
-	USB_CH_IP_CUR_LVL_0P7,
-	USB_CH_IP_CUR_LVL_0P8,
-	USB_CH_IP_CUR_LVL_0P9,
-	USB_CH_IP_CUR_LVL_1P0,
-	USB_CH_IP_CUR_LVL_1P1,
-	USB_CH_IP_CUR_LVL_1P3,
-	USB_CH_IP_CUR_LVL_1P4,
-	USB_CH_IP_CUR_LVL_1P5,
-};
-
 static int ab8500_voltage_to_regval(int voltage)
 {
 	int i;
@@ -1057,41 +1000,41 @@ static int ab8500_voltage_to_regval(int voltage)
 		return -1;
 }
 
-static int ab8500_current_to_regval(int curr)
+static int ab8500_current_to_regval(struct ab8500_charger *di, int curr)
 {
 	int i;
 
-	if (curr < ab8500_charger_current_map[0])
+	if (curr < di->bm->chg_output_curr[0])
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_current_map); i++) {
-		if (curr < ab8500_charger_current_map[i])
+	for (i = 0; i < di->bm->n_chg_out_curr; i++) {
+		if (curr < di->bm->chg_output_curr[i])
 			return i - 1;
 	}
 
 	/* If not last element, return error */
-	i = ARRAY_SIZE(ab8500_charger_current_map) - 1;
-	if (curr == ab8500_charger_current_map[i])
+	i = di->bm->n_chg_out_curr - 1;
+	if (curr == di->bm->chg_output_curr[i])
 		return i;
 	else
 		return -1;
 }
 
-static int ab8500_vbus_in_curr_to_regval(int curr)
+static int ab8500_vbus_in_curr_to_regval(struct ab8500_charger *di, int curr)
 {
 	int i;
 
-	if (curr < ab8500_charger_vbus_in_curr_map[0])
+	if (curr < di->bm->chg_input_curr[0])
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_vbus_in_curr_map); i++) {
-		if (curr < ab8500_charger_vbus_in_curr_map[i])
+	for (i = 0; i < di->bm->n_chg_in_curr; i++) {
+		if (curr < di->bm->chg_input_curr[i])
 			return i - 1;
 	}
 
 	/* If not last element, return error */
-	i = ARRAY_SIZE(ab8500_charger_vbus_in_curr_map) - 1;
-	if (curr == ab8500_charger_vbus_in_curr_map[i])
+	i = di->bm->n_chg_in_curr - 1;
+	if (curr == di->bm->chg_input_curr[i])
 		return i;
 	else
 		return -1;
@@ -1169,7 +1112,7 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 	int ich, int reg)
 {
 	int ret = 0;
-	int auto_curr_index, curr_index, prev_curr_index, shift_value, i;
+	int curr_index, prev_curr_index, shift_value, i;
 	u8 reg_value;
 	u32 step_udelay;
 	bool no_stepping = false;
@@ -1187,39 +1130,27 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 	case AB8500_MCH_IPT_CURLVL_REG:
 		shift_value = MAIN_CH_INPUT_CURR_SHIFT;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_current_to_regval(ich);
+		curr_index = ab8500_current_to_regval(di, ich);
 		step_udelay = STEP_UDELAY;
 		if (!di->ac.charger_connected)
 			no_stepping = true;
 		break;
 	case AB8500_USBCH_IPT_CRNTLVL_REG:
-		shift_value = VBUS_IN_CURR_LIM_SHIFT;
+		if (is_ab8540(di->parent))
+			shift_value = AB8540_VBUS_IN_CURR_LIM_SHIFT;
+		else
+			shift_value = VBUS_IN_CURR_LIM_SHIFT;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_vbus_in_curr_to_regval(ich);
+		curr_index = ab8500_vbus_in_curr_to_regval(di, ich);
 		step_udelay = STEP_UDELAY * 100;
 
-		ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
-					AB8500_CH_USBCH_STAT2_REG, &reg_value);
-		if (ret < 0) {
-			dev_err(di->dev, "%s read failed\n", __func__);
-			goto exit_set_current;
-		}
-		auto_curr_index =
-			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT;
-
-		dev_dbg(di->dev, "%s Auto VBUS curr is %d mA\n",
-			__func__,
-			ab8500_charger_vbus_in_curr_map[auto_curr_index]);
-
-		prev_curr_index = min(prev_curr_index, auto_curr_index);
-
 		if (!di->usb.charger_connected)
 			no_stepping = true;
 		break;
 	case AB8500_CH_OPT_CRNTLVL_REG:
 		shift_value = 0;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_current_to_regval(ich);
+		curr_index = ab8500_current_to_regval(di, ich);
 		step_udelay = STEP_UDELAY;
 		if (curr_index && (curr_index - prev_curr_index) > 1)
 			step_udelay *= 100;
@@ -1459,8 +1390,8 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 
 		/* Check if the requested voltage or current is valid */
 		volt_index = ab8500_voltage_to_regval(vset);
-		curr_index = ab8500_current_to_regval(iset);
-		input_curr_index = ab8500_current_to_regval(
+		curr_index = ab8500_current_to_regval(di, iset);
+		input_curr_index = ab8500_current_to_regval(di,
 			di->bm->chg_params->ac_curr_max);
 		if (volt_index < 0 || curr_index < 0 || input_curr_index < 0) {
 			dev_err(di->dev,
@@ -1631,7 +1562,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 
 		/* Check if the requested voltage or current is valid */
 		volt_index = ab8500_voltage_to_regval(vset);
-		curr_index = ab8500_current_to_regval(ich_out);
+		curr_index = ab8500_current_to_regval(di, ich_out);
 		if (volt_index < 0 || curr_index < 0) {
 			dev_err(di->dev,
 				"Charger voltage or current too high, "
@@ -2396,18 +2327,21 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	else
 		dev_dbg(di->dev, "Error reading USB link status\n");
 
-	if (is_ab9540(di->parent) || is_ab8505(di->parent))
-		link_status = AB8505_USB_LINK_STATUS;
-	else
+	if (is_ab8500(di->parent))
 		link_status = AB8500_USB_LINK_STATUS;
+	else
+		link_status = AB8505_USB_LINK_STATUS;
 
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & link_status) >> 3) == USB_STAT_NOT_VALID_LINK &&
+		if (((val & link_status) >> USB_LINK_STATUS_SHIFT) ==
+				USB_STAT_NOT_VALID_LINK &&
 				di->invalid_charger_detect_state == 0) {
-			dev_dbg(di->dev, "Invalid charger detected, state= 0\n");
+			dev_dbg(di->dev,
+					"Invalid charger detected, state= 0\n");
 			/*Enable charger*/
 			abx500_mask_and_set_register_interruptible(di->dev,
-					AB8500_CHARGER, AB8500_USBCH_CTRL1_REG, 0x01, 0x01);
+					AB8500_CHARGER, AB8500_USBCH_CTRL1_REG,
+					USB_CH_ENA, USB_CH_ENA);
 			/*Enable charger detection*/
 			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
 					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x01);
@@ -2417,15 +2351,17 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 
 		}
 		if (di->invalid_charger_detect_state == 1) {
-			dev_dbg(di->dev, "Invalid charger detected, state= 1\n");
+			dev_dbg(di->dev,
+					"Invalid charger detected, state= 1\n");
 			/*Stop charger detection*/
 			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
 					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x00);
 			/*Check link status*/
-			ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+			ret = abx500_get_register_interruptible(di->dev,
+					AB8500_USB,
 					AB8500_USB_LINE_STAT_REG, &val);
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-					(val & link_status) >> 3);
+				(val & link_status) >> USB_LINK_STATUS_SHIFT);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
@@ -2741,7 +2677,7 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
 {
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, vbus_drop_end_work.work);
-	int ret;
+	int ret, curr;
 	u8 reg_value;
 
 	di->flags.vbus_drop_end = false;
@@ -2749,32 +2685,41 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
 	/* Reset the drop counter */
 	abx500_set_register_interruptible(di->dev,
 				  AB8500_CHARGER, AB8500_CHARGER_CTRL, 0x01);
-	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
-						AB8500_CH_USBCH_STAT2_REG,
-						&reg_value);
+
+	if (is_ab8540(di->parent))
+		ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8540_CH_USBCH_STAT3_REG, &reg_value);
+	else
+		ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8500_CH_USBCH_STAT2_REG, &reg_value);
 	if (ret < 0) {
-		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
-	} else {
-		int curr = ab8500_charger_vbus_in_curr_map[
+		dev_err(di->dev, "%s read failed\n", __func__);
+		return;
+	}
+
+	if (is_ab8540(di->parent))
+		curr = di->bm->chg_input_curr[
+			reg_value & AB8540_AUTO_VBUS_IN_CURR_MASK];
+	else
+		curr = di->bm->chg_input_curr[
 			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT];
-		if (di->max_usb_in_curr.calculated_max != curr) {
-			/* USB source is collapsing */
-			di->max_usb_in_curr.calculated_max = curr;
-			dev_dbg(di->dev,
-				 "VBUS input current limiting to %d mA\n",
-				 di->max_usb_in_curr.calculated_max);
-		} else {
-			/*
-			 * USB source can not give more than this amount.
-			 * Taking more will collapse the source.
-			 */
-			di->max_usb_in_curr.set_max =
-				di->max_usb_in_curr.calculated_max;
-			dev_dbg(di->dev,
-				 "VBUS input current limited to %d mA\n",
-				 di->max_usb_in_curr.set_max);
-			return;
-		}
+
+	if (di->max_usb_in_curr.calculated_max != curr) {
+		/* USB source is collapsing */
+		di->max_usb_in_curr.calculated_max = curr;
+		dev_dbg(di->dev,
+			 "VBUS input current limiting to %d mA\n",
+			 di->max_usb_in_curr.calculated_max);
+	} else {
+		/*
+		 * USB source can not give more than this amount.
+		 * Taking more will collapse the source.
+		 */
+		di->max_usb_in_curr.set_max =
+			di->max_usb_in_curr.calculated_max;
+		dev_dbg(di->dev,
+			 "VBUS input current limited to %d mA\n",
+			 di->max_usb_in_curr.set_max);
 	}
 
 	if (di->usb.charger_connected)
@@ -3134,9 +3079,14 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 			goto out;
 		}
 
-		ret = abx500_set_register_interruptible(di->dev,
-			AB8500_CHARGER,
-			AB8500_CH_OPT_CRNTLVL_MAX_REG, CH_OP_CUR_LVL_1P6);
+		if (is_ab8540(di->parent))
+			ret = abx500_set_register_interruptible(di->dev,
+				AB8500_CHARGER, AB8500_CH_OPT_CRNTLVL_MAX_REG,
+				CH_OP_CUR_LVL_2P);
+		else
+			ret = abx500_set_register_interruptible(di->dev,
+				AB8500_CHARGER, AB8500_CH_OPT_CRNTLVL_MAX_REG,
+				CH_OP_CUR_LVL_1P6);
 		if (ret) {
 			dev_err(di->dev,
 				"failed to set CH_OPT_CRNTLVL_MAX_REG\n");
@@ -3144,7 +3094,8 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	if (is_ab9540_2p0(di->parent) || is_ab8505_2p0(di->parent))
+	if (is_ab9540_2p0(di->parent) || is_ab9540_3p0(di->parent)
+	 || is_ab8505_2p0(di->parent) || is_ab8540(di->parent))
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER,
 			AB8500_USBCH_CTRL2_REG,
@@ -3250,7 +3201,8 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 			AB8500_RTC_CTRL1_REG,
 			bup_vch_range | vbup33_vrtcn);
 		if (ret) {
-			dev_err(di->dev, "failed to setup backup battery charging\n");
+			dev_err(di->dev,
+				"failed to setup backup battery charging\n");
 			goto out;
 		}
 	}
@@ -3267,14 +3219,16 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 			AB8500_CHARGER, AB8540_USB_PP_MODE_REG,
 			BUS_VSYS_VOL_SELECT_MASK, BUS_VSYS_VOL_SELECT_3P6V);
 		if (ret) {
-			dev_err(di->dev, "failed to setup usb power path vsys voltage\n");
+			dev_err(di->dev,
+				"failed to setup usb power path vsys voltage\n");
 			goto out;
 		}
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER, AB8540_USB_PP_CHR_REG,
 			BUS_PP_PRECHG_CURRENT_MASK, 0);
 		if (ret) {
-			dev_err(di->dev, "failed to setup usb power path prechage current\n");
+			dev_err(di->dev,
+				"failed to setup usb power path prechage current\n");
 			goto out;
 		}
 	}
@@ -3537,8 +3491,8 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->ac_chg.max_out_volt = ab8500_charger_voltage_map[
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
-	di->ac_chg.max_out_curr = ab8500_charger_current_map[
-		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->ac_chg.max_out_curr =
+		di->bm->chg_output_curr[di->bm->n_chg_out_curr - 1];
 	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->ac_chg.enabled = di->bm->ac_enabled;
 	di->ac_chg.external = false;
@@ -3566,8 +3520,8 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.ops.pre_chg_enable = &ab8540_charger_usb_pre_chg_enable;
 	di->usb_chg.max_out_volt = ab8500_charger_voltage_map[
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
-	di->usb_chg.max_out_curr = ab8500_charger_current_map[
-		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->usb_chg.max_out_curr =
+		di->bm->chg_output_curr[di->bm->n_chg_out_curr - 1];
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->bm->usb_enabled;
 	di->usb_chg.external = false;
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 0104df8..c45b2e4 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -246,7 +246,11 @@ struct abx500_bm_charger_parameters {
  * @interval_not_charging charge alg cycle period time when not charging (sec)
  * @temp_hysteresis	temperature hysteresis
  * @gnd_lift_resistance	Battery ground to phone ground resistance (mOhm)
- * @maxi:		maximization parameters
+ * @n_chg_out_curr		number of elements in array chg_output_curr
+ * @n_chg_in_curr		number of elements in array chg_input_curr
+ * @chg_output_curr	charger output current level map
+ * @chg_input_curr		charger input current level map
+ * @maxi		maximization parameters
  * @cap_levels		capacity in percent for the different capacity levels
  * @bat_type		table of supported battery types
  * @chg_params		charger parameters
@@ -281,6 +285,10 @@ struct abx500_bm_data {
 	int interval_not_charging;
 	int temp_hysteresis;
 	int gnd_lift_resistance;
+	int n_chg_out_curr;
+	int n_chg_in_curr;
+	int *chg_output_curr;
+	int *chg_input_curr;
 	const struct abx500_maxim_parameters *maxi;
 	const struct abx500_bm_capacity_levels *cap_levels;
 	struct abx500_battery_type *bat_type;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index cf7bac6..faccdbd 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -33,7 +33,7 @@
 #define AB8500_CH_STATUS2_REG		0x01
 #define AB8500_CH_USBCH_STAT1_REG	0x02
 #define AB8500_CH_USBCH_STAT2_REG	0x03
-#define AB8500_CH_FSM_STAT_REG		0x04
+#define AB8540_CH_USBCH_STAT3_REG	0x04
 #define AB8500_CH_STAT_REG		0x05
 
 /*
@@ -157,6 +157,7 @@
 #define CH_OP_CUR_LVL_1P4		0x0D
 #define CH_OP_CUR_LVL_1P5		0x0E
 #define CH_OP_CUR_LVL_1P6		0x0F
+#define CH_OP_CUR_LVL_2P		0x3F
 
 /* BTEMP High thermal limits */
 #define BTEMP_HIGH_TH_57_0		0x00
@@ -246,6 +247,8 @@ enum bup_vch_sel {
 #define BAT_CTRL_20U_ENA		0x02
 #define BAT_CTRL_18U_ENA		0x01
 #define BAT_CTRL_16U_ENA		0x02
+#define BAT_CTRL_60U_ENA		0x01
+#define BAT_CTRL_120U_ENA		0x02
 #define BAT_CTRL_CMP_ENA		0x04
 #define FORCE_BAT_CTRL_CMP_HIGH		0x08
 #define BAT_CTRL_PULL_UP_ENA		0x10
-- 
1.7.10.4

