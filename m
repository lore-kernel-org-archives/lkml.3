Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3AUMJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:09:36 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62798 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3AUMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Olivier Clergeaud <olivier.clergeaud@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Subject: [PATCH 08/24] pm2301: Clean-up PM2301 interrupt management
Date: Mon, 21 Jan 2013 12:03:44 +0000
Message-Id: <1358769840-4763-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Clergeaud <olivier.clergeaud@stericsson.com>

Fix the way interrupts are handled within the PM2301 charging driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
---
 drivers/power/pm2301_charger.c |  173 ++++++++++++++++++++++++++++------------
 drivers/power/pm2301_charger.h |   29 ++++++-
 2 files changed, 148 insertions(+), 54 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index c196de7..316d5f0 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -224,7 +224,7 @@ static int pm2xxx_charger_bat_disc_mngt(struct pm2xxx_charger *pm2, int val)
 {
 	dev_dbg(pm2->dev, "battery disconnected\n");
 
-	return (pm2xxx_charging_disable_mngt(pm2));
+	return 0;
 }
 
 static int pm2xxx_charger_detection(struct pm2xxx_charger *pm2, u8 *val)
@@ -275,17 +275,17 @@ static int pm2xxx_charger_itv_pwr_unplug_mngt(struct pm2xxx_charger *pm2,
 	return 0;
 }
 
-static int pm2_int_reg0(struct pm2xxx_charger *pm2)
+static int pm2_int_reg0(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (pm2->pm2_int[0] &
-			(PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF)) {
-		ret = pm2xxx_charger_vbat_lsig_mngt(pm2, pm2->pm2_int[0] &
+	if (val & (PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF)) {
+		ret = pm2xxx_charger_vbat_lsig_mngt(pm2, val &
 			(PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF));
 	}
 
-	if (pm2->pm2_int[0] & PM2XXX_INT1_ITVBATDISCONNECT) {
+	if (val & PM2XXX_INT1_ITVBATDISCONNECT) {
 		ret = pm2xxx_charger_bat_disc_mngt(pm2,
 				PM2XXX_INT1_ITVBATDISCONNECT);
 	}
@@ -293,21 +293,21 @@ static int pm2_int_reg0(struct pm2xxx_charger *pm2)
 	return ret;
 }
 
-static int pm2_int_reg1(struct pm2xxx_charger *pm2)
+static int pm2_int_reg1(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (pm2->pm2_int[1] &
-		(PM2XXX_INT2_ITVPWR1PLUG | PM2XXX_INT2_ITVPWR2PLUG)) {
+	if (val & (PM2XXX_INT2_ITVPWR1PLUG | PM2XXX_INT2_ITVPWR2PLUG)) {
 		dev_dbg(pm2->dev , "Main charger plugged\n");
-		ret = pm2xxx_charger_itv_pwr_plug_mngt(pm2, pm2->pm2_int[1] &
+		ret = pm2xxx_charger_itv_pwr_plug_mngt(pm2, val &
 			(PM2XXX_INT2_ITVPWR1PLUG | PM2XXX_INT2_ITVPWR2PLUG));
 	}
 
-	if (pm2->pm2_int[1] &
+	if (val &
 		(PM2XXX_INT2_ITVPWR1UNPLUG | PM2XXX_INT2_ITVPWR2UNPLUG)) {
 		dev_dbg(pm2->dev , "Main charger unplugged\n");
-		ret = pm2xxx_charger_itv_pwr_unplug_mngt(pm2, pm2->pm2_int[1] &
+		ret = pm2xxx_charger_itv_pwr_unplug_mngt(pm2, val &
 						(PM2XXX_INT2_ITVPWR1UNPLUG |
 						PM2XXX_INT2_ITVPWR2UNPLUG));
 	}
@@ -315,14 +315,15 @@ static int pm2_int_reg1(struct pm2xxx_charger *pm2)
 	return ret;
 }
 
-static int pm2_int_reg2(struct pm2xxx_charger *pm2)
+static int pm2_int_reg2(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (pm2->pm2_int[2] & PM2XXX_INT3_ITAUTOTIMEOUTWD)
-		ret = pm2xxx_charger_wd_exp_mngt(pm2, pm2->pm2_int[2]);
+	if (val & PM2XXX_INT3_ITAUTOTIMEOUTWD)
+		ret = pm2xxx_charger_wd_exp_mngt(pm2, val);
 
-	if (pm2->pm2_int[2] & (PM2XXX_INT3_ITCHPRECHARGEWD |
+	if (val & (PM2XXX_INT3_ITCHPRECHARGEWD |
 				PM2XXX_INT3_ITCHCCWD | PM2XXX_INT3_ITCHCVWD)) {
 		dev_dbg(pm2->dev,
 			"Watchdog occured for precharge, CC and CV charge\n");
@@ -331,64 +332,65 @@ static int pm2_int_reg2(struct pm2xxx_charger *pm2)
 	return ret;
 }
 
-static int pm2_int_reg3(struct pm2xxx_charger *pm2)
+static int pm2_int_reg3(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITCHARGINGON)) {
+	if (val & (PM2XXX_INT4_ITCHARGINGON)) {
 		dev_dbg(pm2->dev ,
 			"chargind operation has started\n");
 	}
 
-	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITVRESUME)) {
+	if (val & (PM2XXX_INT4_ITVRESUME)) {
 		dev_dbg(pm2->dev,
 			"battery discharged down to VResume threshold\n");
 	}
 
-	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITBATTFULL)) {
+	if (val & (PM2XXX_INT4_ITBATTFULL)) {
 		dev_dbg(pm2->dev , "battery fully detected\n");
 	}
 
-	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITCVPHASE)) {
+	if (val & (PM2XXX_INT4_ITCVPHASE)) {
 		dev_dbg(pm2->dev, "CV phase enter with 0.5C charging\n");
 	}
 
-	if (pm2->pm2_int[3] &
-			(PM2XXX_INT4_ITVPWR2OVV | PM2XXX_INT4_ITVPWR1OVV)) {
+	if (val & (PM2XXX_INT4_ITVPWR2OVV | PM2XXX_INT4_ITVPWR1OVV)) {
 		pm2->failure_case = VPWR_OVV;
-		ret = pm2xxx_charger_ovv_mngt(pm2, pm2->pm2_int[3] &
+		ret = pm2xxx_charger_ovv_mngt(pm2, val &
 			(PM2XXX_INT4_ITVPWR2OVV | PM2XXX_INT4_ITVPWR1OVV));
 		dev_dbg(pm2->dev, "VPWR/VSYSTEM overvoltage detected\n");
 	}
 
-	if (pm2->pm2_int[3] & (PM2XXX_INT4_S_ITBATTEMPCOLD |
+	if (val & (PM2XXX_INT4_S_ITBATTEMPCOLD |
 				PM2XXX_INT4_S_ITBATTEMPHOT)) {
-		ret = pm2xxx_charger_batt_therm_mngt(pm2,
-			pm2->pm2_int[3] & (PM2XXX_INT4_S_ITBATTEMPCOLD |
-					PM2XXX_INT4_S_ITBATTEMPHOT));
+		ret = pm2xxx_charger_batt_therm_mngt(pm2, val &
+			(PM2XXX_INT4_S_ITBATTEMPCOLD |
+			PM2XXX_INT4_S_ITBATTEMPHOT));
 		dev_dbg(pm2->dev, "BTEMP is too Low/High\n");
 	}
 
 	return ret;
 }
 
-static int pm2_int_reg4(struct pm2xxx_charger *pm2)
+static int pm2_int_reg4(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-	if (pm2->pm2_int[4] & PM2XXX_INT5_ITVSYSTEMOVV) {
+	if (val & PM2XXX_INT5_ITVSYSTEMOVV) {
 		pm2->failure_case = VSYSTEM_OVV;
-		ret = pm2xxx_charger_ovv_mngt(pm2, pm2->pm2_int[4] &
+		ret = pm2xxx_charger_ovv_mngt(pm2, val &
 						PM2XXX_INT5_ITVSYSTEMOVV);
 		dev_dbg(pm2->dev, "VSYSTEM overvoltage detected\n");
 	}
 
-	if (pm2->pm2_int[4] & (PM2XXX_INT5_ITTHERMALWARNINGFALL |
+	if (val & (PM2XXX_INT5_ITTHERMALWARNINGFALL |
 				PM2XXX_INT5_ITTHERMALWARNINGRISE |
 				PM2XXX_INT5_ITTHERMALSHUTDOWNFALL |
 				PM2XXX_INT5_ITTHERMALSHUTDOWNRISE)) {
 		dev_dbg(pm2->dev, "BTEMP die temperature is too Low/High\n");
-		ret = pm2xxx_charger_die_therm_mngt(pm2, pm2->pm2_int[4] &
+		ret = pm2xxx_charger_die_therm_mngt(pm2, val &
 			(PM2XXX_INT5_ITTHERMALWARNINGFALL |
 			PM2XXX_INT5_ITTHERMALWARNINGRISE |
 			PM2XXX_INT5_ITTHERMALSHUTDOWNFALL |
@@ -398,40 +400,40 @@ static int pm2_int_reg4(struct pm2xxx_charger *pm2)
 	return ret;
 }
 
-static int pm2_int_reg5(struct pm2xxx_charger *pm2)
+static int pm2_int_reg5(void *pm2_data, int val)
 {
+	struct pm2xxx_charger *pm2 = pm2_data;
+	int ret = 0;
+
 
-	if (pm2->pm2_int[5]
-		& (PM2XXX_INT6_ITVPWR2DROP | PM2XXX_INT6_ITVPWR1DROP)) {
+	if (val & (PM2XXX_INT6_ITVPWR2DROP | PM2XXX_INT6_ITVPWR1DROP)) {
 		dev_dbg(pm2->dev, "VMPWR drop to VBAT level\n");
 	}
 
-	if (pm2->pm2_int[5] & (PM2XXX_INT6_ITVPWR2VALIDRISE |
-				PM2XXX_INT6_ITVPWR1VALIDRISE |
-				PM2XXX_INT6_ITVPWR2VALIDFALL |
-				PM2XXX_INT6_ITVPWR1VALIDFALL)) {
+	if (val & (PM2XXX_INT6_ITVPWR2VALIDRISE |
+			PM2XXX_INT6_ITVPWR1VALIDRISE |
+			PM2XXX_INT6_ITVPWR2VALIDFALL |
+			PM2XXX_INT6_ITVPWR1VALIDFALL)) {
 		dev_dbg(pm2->dev, "Falling/Rising edge on WPWR1/2\n");
 	}
 
-	return 0;
+	return ret;
 }
 
 static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
 {
 	struct pm2xxx_charger *pm2 = data;
-	int ret, i;
+	struct pm2xxx_interrupts *interrupt = pm2->pm2_int;
+	int i;
 
-	for (i = 0; i < ARRAY_SIZE(pm2->pm2_int); i++) {
-		ret = pm2xxx_reg_read(pm2, pm2xxx_interrupt_registers[i],
-				&(pm2->pm2_int[i]));
-	}
+	for (i = 0; i < PM2XXX_NUM_INT_REG; i++) {
+		 pm2xxx_reg_read(pm2,
+				pm2xxx_interrupt_registers[i],
+				&(interrupt->reg[i]));
 
-	pm2_int_reg0(pm2);
-	pm2_int_reg1(pm2);
-	pm2_int_reg2(pm2);
-	pm2_int_reg3(pm2);
-	pm2_int_reg4(pm2);
-	pm2_int_reg5(pm2);
+		if (interrupt->reg[i] > 0)
+			interrupt->handler[i](pm2, interrupt->reg[i]);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -538,7 +540,7 @@ static int pm2xxx_charger_update_charger_current(struct ux500_charger *charger,
 	curr_index = pm2xxx_current_to_regval(ich_out);
 	if (curr_index < 0) {
 		dev_err(pm2->dev,
-			"Charger current too high: charging not started\n");
+			"Charger current too high, charging not started\n");
 		return -ENXIO;
 	}
 
@@ -614,6 +616,59 @@ static int pm2xxx_charging_init(struct pm2xxx_charger *pm2)
 	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG4,
 					PM2XXX_CH_WD_PRECH_PHASE_60MIN);
 
+	/* Disable auto timeout */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG5,
+					PM2XXX_CH_WD_AUTO_TIMEOUT_20MIN);
+
+	/*
+     * EOC current level = 100mA
+	 * Precharge current level = 100mA
+	 * CC current level = 1000mA
+	 */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG6,
+		(PM2XXX_DIR_CH_CC_CURRENT_1000MA |
+		PM2XXX_CH_PRECH_CURRENT_100MA |
+		PM2XXX_CH_EOC_CURRENT_100MA));
+
+	/*
+     * recharge threshold = 3.8V
+	 * Precharge to CC threshold = 2.9V
+	 */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG7,
+		(PM2XXX_CH_PRECH_VOL_2_9 | PM2XXX_CH_VRESUME_VOL_3_8));
+
+	/* float voltage charger level = 4.2V */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG8,
+		PM2XXX_CH_VOLT_4_2);
+
+	/* Voltage drop between VBAT and VSYS in HW charging = 300mV */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG9,
+		(PM2XXX_CH_150MV_DROP_300MV | PM2XXX_CHARCHING_INFO_DIS |
+		PM2XXX_CH_CC_REDUCED_CURRENT_IDENT |
+		PM2XXX_CH_CC_MODEDROP_DIS));
+
+	/* Input charger level of over voltage = 10V */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_INP_VOLT_VPWR2,
+					PM2XXX_VPWR2_OVV_10);
+	ret = pm2xxx_reg_write(pm2, PM2XXX_INP_VOLT_VPWR1,
+					PM2XXX_VPWR1_OVV_10);
+
+	/* Input charger drop */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_INP_DROP_VPWR2,
+		(PM2XXX_VPWR2_HW_OPT_DIS | PM2XXX_VPWR2_VALID_DIS |
+		PM2XXX_VPWR2_DROP_DIS));
+	ret = pm2xxx_reg_write(pm2, PM2XXX_INP_DROP_VPWR1,
+		(PM2XXX_VPWR1_HW_OPT_DIS | PM2XXX_VPWR1_VALID_DIS |
+		PM2XXX_VPWR1_DROP_DIS));
+
+	/* Disable battery low monitoring */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_LOW_LEV_COMP_REG,
+		PM2XXX_VBAT_LOW_MONITORING_DIS);
+
+	/* Disable LED */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_LED_CTRL_REG,
+		PM2XXX_LED_SELECT_DIS);
+
 	return ret;
 }
 
@@ -764,6 +819,15 @@ static void pm2xxx_charger_check_main_thermal_prot_work(
 {
 };
 
+static struct pm2xxx_interrupts pm2xxx_int = {
+	.handler[0] = pm2_int_reg0,
+	.handler[1] = pm2_int_reg1,
+	.handler[2] = pm2_int_reg2,
+	.handler[3] = pm2_int_reg3,
+	.handler[4] = pm2_int_reg4,
+	.handler[5] = pm2_int_reg5,
+};
+
 static struct pm2xxx_irq pm2xxx_charger_irq[] = {
 	{"PM2XXX_IRQ_INT", pm2xxx_irq_int},
 };
@@ -797,6 +861,8 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	pm2->dev = &i2c_client->dev;
 	pm2->gpadc = ab8500_gpadc_get();
 
+	pm2->pm2_int = &pm2xxx_int;
+
 	/* get charger spcific platform data */
 	if (!pl_data->wall_charger) {
 		dev_err(pm2->dev, "no charger platform data supplied\n");
@@ -844,6 +910,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		ARRAY_SIZE(pm2xxx_charger_voltage_map) - 1];
 	pm2->ac_chg.max_out_curr = pm2xxx_charger_current_map[
 		ARRAY_SIZE(pm2xxx_charger_current_map) - 1];
+	pm2->ac_chg.enabled = true;
 
 	/* Create a work queue for the charger */
 	pm2->charger_wq =
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
index 27bf931..cc401d7 100644
--- a/drivers/power/pm2301_charger.h
+++ b/drivers/power/pm2301_charger.h
@@ -34,6 +34,8 @@
 #define WD_TIMER			0x30 /* 4min */
 #define WD_KICK_INTERVAL		(60 * HZ)
 
+#define PM2XXX_NUM_INT_REG		0x6
+
 /* Constant voltage/current */
 #define PM2XXX_CONST_CURR		0x0
 #define PM2XXX_CONST_VOLT		0x1
@@ -237,12 +239,32 @@
 #define PM2XXX_VPWR2_OVV_10		0x2
 #define PM2XXX_VPWR2_OVV_NONE		0x3
 
+/* Input charger drop VPWR2 */
+#define PM2XXX_VPWR2_HW_OPT_EN		(0x1<<4)
+#define PM2XXX_VPWR2_HW_OPT_DIS		(0x0<<4)
+
+#define PM2XXX_VPWR2_VALID_EN		(0x1<<3)
+#define PM2XXX_VPWR2_VALID_DIS		(0x0<<3)
+
+#define PM2XXX_VPWR2_DROP_EN		(0x1<<2)
+#define PM2XXX_VPWR2_DROP_DIS		(0x0<<2)
+
 /* Input charger voltage VPWR1 */
 #define PM2XXX_VPWR1_OVV_6_0		0x0
 #define PM2XXX_VPWR1_OVV_6_3		0x1
 #define PM2XXX_VPWR1_OVV_10		0x2
 #define PM2XXX_VPWR1_OVV_NONE		0x3
 
+/* Input charger drop VPWR1 */
+#define PM2XXX_VPWR1_HW_OPT_EN		(0x1<<4)
+#define PM2XXX_VPWR1_HW_OPT_DIS		(0x0<<4)
+
+#define PM2XXX_VPWR1_VALID_EN		(0x1<<3)
+#define PM2XXX_VPWR1_VALID_DIS		(0x0<<3)
+
+#define PM2XXX_VPWR1_DROP_EN		(0x1<<2)
+#define PM2XXX_VPWR1_DROP_DIS		(0x0<<2)
+
 /* Battery low level comparator control register */
 #define PM2XXX_VBAT_LOW_MONITORING_DIS	0x0
 #define PM2XXX_VBAT_LOW_MONITORING_ENA	0x1
@@ -446,6 +468,11 @@ struct pm2xxx_charger_event_flags {
 	bool chgwdexp;
 };
 
+struct pm2xxx_interrupts {
+	u8 reg[PM2XXX_NUM_INT_REG];
+	int (*handler[PM2XXX_NUM_INT_REG])(void *, int);
+};
+
 struct pm2xxx_config {
 	struct i2c_client *pm2xxx_i2c;
 	struct i2c_device_id *pm2xxx_id;
@@ -467,7 +494,7 @@ struct pm2xxx_charger {
 	int old_vbat;
 	int failure_case;
 	int failure_input_ovv;
-	u8 pm2_int[6];
+	struct pm2xxx_interrupts *pm2_int;
 	struct ab8500_gpadc *gpadc;
 	struct regulator *regu;
 	struct pm2xxx_bm_data *bat;
-- 
1.7.9.5

