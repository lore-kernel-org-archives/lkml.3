Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3AUMIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:08:45 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51740 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3AUMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 12/24] ab8500-fg: Add test interface for u9540
Date: Mon, 21 Jan 2013 12:03:48 +0000
Message-Id: <1358769840-4763-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add dedicated test functions for HATS framework. This patch
allows validating fuel gauge HW IP in all possible modes
supported by HW. Services are accessible through DebugFS
interface.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/Kconfig                |   10 +
 drivers/power/Makefile               |    1 +
 drivers/power/ab8500_fg.c            |  271 +++--------
 drivers/power/ab8500_fg.h            |  242 ++++++++++
 drivers/power/ab8500_fg_deepdebug.c  |  823 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500-bm.h |  164 +++++++
 6 files changed, 1297 insertions(+), 214 deletions(-)
 create mode 100644 drivers/power/ab8500_fg.h
 create mode 100644 drivers/power/ab8500_fg_deepdebug.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index b9de00d..16b4869 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -346,6 +346,15 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
+config AB8500_BM_DEEP_DEBUG
+	bool "AB8500 Battery Management Deep Debug"
+	depends on (AB8500_BM && DEEP_DEBUG)
+	default y
+	help
+	  Say Y to include support for Deep Debug interface
+	  for battery management.
+	  If unsure, say N.
+
 config CHARGER_PM2301
 	bool "PM2301 Battery Charger Driver"
 	depends on AB8500_BM
@@ -356,6 +365,7 @@ config CHARGER_PM2301
 config PM2XXX_DEEP_DEBUG
 	bool "PM2XXX Deep Debug"
 	depends on DEEP_DEBUG && CHARGER_PM2301
+	default n
 	help
 	  Deep Debug interface provides an access to all registers.
 	  It allows to read or write directly a register.
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ef1e79c..476668d 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
 obj-$(CONFIG_BATTERY_RX51)	+= rx51_battery.o
 obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
+obj-$(CONFIG_AB8500_BM_DEEP_DEBUG) += ab8500_fg_deepdebug.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index a0cbbd3..238eeee 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -33,25 +33,12 @@
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/kernel.h>
+#include "ab8500_fg.h"
 
-#define MILLI_TO_MICRO			1000
-#define FG_LSB_IN_MA			1627
-#define QLSB_NANO_AMP_HOURS_X10		1129
-#define INS_CURR_TIMEOUT		(3 * HZ)
-
-#define SEC_TO_SAMPLE(S)		(S * 4)
-
-#define NBR_AVG_SAMPLES			20
-
-#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
-
-#define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
-#define BATT_OK_MIN			2360 /* mV */
-#define BATT_OK_INCREMENT		50 /* mV */
-#define BATT_OK_MAX_NR_INCREMENTS	0xE
-
-/* FG constants */
-#define BATT_OVV			0x01
+char *charge_state[] = {
+	"CHARGE_INIT",
+	"CHARGE_READOUT",
+};
 
 #define interpolate(x, x1, y1, x2, y2) \
 	((y1) + ((((y2) - (y1)) * ((x) - (x1))) / ((x2) - (x1))));
@@ -59,186 +46,6 @@
 #define to_ab8500_fg_device_info(x) container_of((x), \
 	struct ab8500_fg, fg_psy);
 
-/**
- * struct ab8500_fg_interrupts - ab8500 fg interupts
- * @name:	name of the interrupt
- * @isr		function pointer to the isr
- */
-struct ab8500_fg_interrupts {
-	char *name;
-	irqreturn_t (*isr)(int irq, void *data);
-};
-
-enum ab8500_fg_discharge_state {
-	AB8500_FG_DISCHARGE_INIT,
-	AB8500_FG_DISCHARGE_INITMEASURING,
-	AB8500_FG_DISCHARGE_INIT_RECOVERY,
-	AB8500_FG_DISCHARGE_RECOVERY,
-	AB8500_FG_DISCHARGE_READOUT_INIT,
-	AB8500_FG_DISCHARGE_READOUT,
-	AB8500_FG_DISCHARGE_WAKEUP,
-};
-
-static char *discharge_state[] = {
-	"DISCHARGE_INIT",
-	"DISCHARGE_INITMEASURING",
-	"DISCHARGE_INIT_RECOVERY",
-	"DISCHARGE_RECOVERY",
-	"DISCHARGE_READOUT_INIT",
-	"DISCHARGE_READOUT",
-	"DISCHARGE_WAKEUP",
-};
-
-enum ab8500_fg_charge_state {
-	AB8500_FG_CHARGE_INIT,
-	AB8500_FG_CHARGE_READOUT,
-};
-
-static char *charge_state[] = {
-	"CHARGE_INIT",
-	"CHARGE_READOUT",
-};
-
-enum ab8500_fg_calibration_state {
-	AB8500_FG_CALIB_INIT,
-	AB8500_FG_CALIB_WAIT,
-	AB8500_FG_CALIB_END,
-};
-
-struct ab8500_fg_avg_cap {
-	int avg;
-	int samples[NBR_AVG_SAMPLES];
-	__kernel_time_t time_stamps[NBR_AVG_SAMPLES];
-	int pos;
-	int nbr_samples;
-	int sum;
-};
-
-struct ab8500_fg_cap_scaling {
-	bool enable;
-	int cap_to_scale[2];
-	int disable_cap_level;
-	int scaled_cap;
-};
-
-struct ab8500_fg_battery_capacity {
-	int max_mah_design;
-	int max_mah;
-	int mah;
-	int permille;
-	int level;
-	int prev_mah;
-	int prev_percent;
-	int prev_level;
-	int user_mah;
-	struct ab8500_fg_cap_scaling cap_scale;
-};
-
-struct ab8500_fg_flags {
-	bool fg_enabled;
-	bool conv_done;
-	bool charging;
-	bool fully_charged;
-	bool force_full;
-	bool low_bat_delay;
-	bool low_bat;
-	bool bat_ovv;
-	bool batt_unknown;
-	bool calibrate;
-	bool user_cap;
-	bool batt_id_received;
-};
-
-struct inst_curr_result_list {
-	struct list_head list;
-	int *result;
-};
-
-/**
- * struct ab8500_fg - ab8500 FG device information
- * @dev:		Pointer to the structure device
- * @node:		a list of AB8500 FGs, hence prepared for reentrance
- * @irq			holds the CCEOC interrupt number
- * @vbat:		Battery voltage in mV
- * @vbat_nom:		Nominal battery voltage in mV
- * @inst_curr:		Instantenous battery current in mA
- * @avg_curr:		Average battery current in mA
- * @bat_temp		battery temperature
- * @fg_samples:		Number of samples used in the FG accumulation
- * @accu_charge:	Accumulated charge from the last conversion
- * @recovery_cnt:	Counter for recovery mode
- * @high_curr_cnt:	Counter for high current mode
- * @init_cnt:		Counter for init mode
- * @low_bat_cnt		Counter for number of consecutive low battery measures
- * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
- * @recovery_needed:	Indicate if recovery is needed
- * @high_curr_mode:	Indicate if we're in high current mode
- * @init_capacity:	Indicate if initial capacity measuring should be done
- * @turn_off_fg:	True if fg was off before current measurement
- * @calib_state		State during offset calibration
- * @discharge_state:	Current discharge state
- * @charge_state:	Current charge state
- * @ab8500_fg_started	Completion struct used for the instant current start
- * @ab8500_fg_complete	Completion struct used for the instant current reading
- * @flags:		Structure for information about events triggered
- * @bat_cap:		Structure for battery capacity specific parameters
- * @avg_cap:		Average capacity filter
- * @parent:		Pointer to the struct ab8500
- * @gpadc:		Pointer to the struct gpadc
- * @bm:           	Platform specific battery management information
- * @fg_psy:		Structure that holds the FG specific battery properties
- * @fg_wq:		Work queue for running the FG algorithm
- * @fg_periodic_work:	Work to run the FG algorithm periodically
- * @fg_low_bat_work:	Work to check low bat condition
- * @fg_reinit_work	Work used to reset and reinitialise the FG algorithm
- * @fg_work:		Work to run the FG algorithm instantly
- * @fg_acc_cur_work:	Work to read the FG accumulator
- * @fg_check_hw_failure_work:	Work for checking HW state
- * @cc_lock:		Mutex for locking the CC
- * @fg_kobject:		Structure of type kobject
- */
-struct ab8500_fg {
-	struct device *dev;
-	struct list_head node;
-	int irq;
-	int vbat;
-	int vbat_nom;
-	int inst_curr;
-	int avg_curr;
-	int bat_temp;
-	int fg_samples;
-	int accu_charge;
-	int recovery_cnt;
-	int high_curr_cnt;
-	int init_cnt;
-	int low_bat_cnt;
-	int nbr_cceoc_irq_cnt;
-	bool recovery_needed;
-	bool high_curr_mode;
-	bool init_capacity;
-	bool turn_off_fg;
-	enum ab8500_fg_calibration_state calib_state;
-	enum ab8500_fg_discharge_state discharge_state;
-	enum ab8500_fg_charge_state charge_state;
-	struct completion ab8500_fg_started;
-	struct completion ab8500_fg_complete;
-	struct ab8500_fg_flags flags;
-	struct ab8500_fg_battery_capacity bat_cap;
-	struct ab8500_fg_avg_cap avg_cap;
-	struct ab8500 *parent;
-	struct ab8500_gpadc *gpadc;
-	struct abx500_bm_data *bm;
-	struct power_supply fg_psy;
-	struct workqueue_struct *fg_wq;
-	struct delayed_work fg_periodic_work;
-	struct delayed_work fg_low_bat_work;
-	struct delayed_work fg_reinit_work;
-	struct work_struct fg_work;
-	struct work_struct fg_acc_cur_work;
-	struct delayed_work fg_check_hw_failure_work;
-	struct mutex cc_lock;
-	struct kobject fg_kobject;
-};
 static LIST_HEAD(ab8500_fg_list);
 
 /**
@@ -470,7 +277,7 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
  * Enable/Disable coulomb counter.
  * On failure returns negative value.
  */
-static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
+int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 {
 	int ret = 0;
 	mutex_lock(&di->cc_lock);
@@ -483,11 +290,13 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 			goto cc_err;
 
 		/* Program the samples */
-		ret = abx500_set_register_interruptible(di->dev,
-			AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU,
-			di->fg_samples);
-		if (ret)
-			goto cc_err;
+		if (!di->test.enable) {
+			ret = abx500_set_register_interruptible(di->dev,
+				AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU,
+				di->fg_samples);
+			if (ret)
+				goto cc_err;
+		}
 
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
@@ -1403,7 +1212,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 	}
 }
 
-static void ab8500_fg_charge_state_to(struct ab8500_fg *di,
+void ab8500_fg_charge_state_to(struct ab8500_fg *di,
 	enum ab8500_fg_charge_state new_state)
 {
 	dev_dbg(di->dev, "Charge state from %d [%s] to %d [%s]\n",
@@ -1991,12 +1800,17 @@ static void ab8500_fg_instant_work(struct work_struct *work)
 static irqreturn_t ab8500_fg_cc_data_end_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
-	if (!di->nbr_cceoc_irq_cnt) {
-		di->nbr_cceoc_irq_cnt++;
-		complete(&di->ab8500_fg_started);
-	} else {
-		di->nbr_cceoc_irq_cnt = 0;
-		complete(&di->ab8500_fg_complete);
+
+	if (di->test.enable)
+		complete(&di->test.cceoc_complete);
+	else {
+		if (!di->nbr_cceoc_irq_cnt) {
+			di->nbr_cceoc_irq_cnt++;
+			complete(&di->ab8500_fg_started);
+		} else {
+			di->nbr_cceoc_irq_cnt = 0;
+			complete(&di->ab8500_fg_complete);
+		}
 	}
 	return IRQ_HANDLED;
 }
@@ -2011,8 +1825,31 @@ static irqreturn_t ab8500_fg_cc_data_end_handler(int irq, void *_di)
 static irqreturn_t ab8500_fg_cc_int_calib_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
-	di->calib_state = AB8500_FG_CALIB_END;
-	queue_delayed_work(di->fg_wq, &di->fg_periodic_work, 0);
+
+	if (di->test.enable) {
+		complete(&di->test.cc_int_calib_complete);
+	} else {
+		di->calib_state = AB8500_FG_CALIB_END;
+		queue_delayed_work(di->fg_wq, &di->fg_periodic_work, 0);
+	}
+	return IRQ_HANDLED;
+}
+
+/**
+ * ab8500_fg_cceoc_handler() - end of conversion isr.
+ * @irq:       interrupt number
+ * @_di:       pointer to the ab8500_fg structure
+ *
+ * Returns IRQ status(IRQ_HANDLED)
+ */
+
+static irqreturn_t ab8500_fg_cceoc_handler(int irq, void *_di)
+{
+	struct ab8500_fg *di = _di;
+
+	if (di->test.enable)
+		complete(&di->test.cceoc_complete);
+
 	return IRQ_HANDLED;
 }
 
@@ -2027,7 +1864,10 @@ static irqreturn_t ab8500_fg_cc_convend_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
 
-	queue_work(di->fg_wq, &di->fg_acc_cur_work);
+	if (di->test.enable)
+		complete(&di->test.nconv_accu_complete);
+	else
+		queue_work(di->fg_wq, &di->fg_acc_cur_work);
 
 	return IRQ_HANDLED;
 }
@@ -2613,6 +2453,7 @@ static struct ab8500_fg_interrupts ab8500_fg_irq[] = {
 	{"LOW_BAT_F", ab8500_fg_lowbatf_handler},
 	{"CC_INT_CALIB", ab8500_fg_cc_int_calib_handler},
 	{"CCEOC", ab8500_fg_cc_data_end_handler},
+	{"CCEOC", ab8500_fg_cceoc_handler},
 };
 
 static char *supply_interface[] = {
@@ -2676,6 +2517,8 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	ab8500_fg_charge_state_to(di, AB8500_FG_CHARGE_INIT);
 	ab8500_fg_discharge_state_to(di, AB8500_FG_DISCHARGE_INIT);
 
+	ab8500_fg_test_init(di);
+
 	/* Create a work queue for running the FG algorithm */
 	di->fg_wq = create_singlethread_workqueue("ab8500_fg_wq");
 	if (di->fg_wq == NULL) {
diff --git a/drivers/power/ab8500_fg.h b/drivers/power/ab8500_fg.h
new file mode 100644
index 0000000..946840b
--- /dev/null
+++ b/drivers/power/ab8500_fg.h
@@ -0,0 +1,242 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ *
+ * Main and Back-up battery management driver.
+ *
+ * Note: Backup battery management is required in case of Li-Ion battery and not
+ * for capacitive battery. HREF boards have capacitive battery and hence backup
+ * battery management is not used and the supported code is available in this
+ * driver.
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Johan Palsson <johan.palsson@stericsson.com>
+ * Author: Karl Komierowski <karl.komierowski@stericsson.com>
+ */
+
+#define MILLI_TO_MICRO			1000
+#define FG_LSB_IN_MA			1627
+#define QLSB_NANO_AMP_HOURS_X10		1129
+#define INS_CURR_TIMEOUT		(3 * HZ)
+
+#define SEC_TO_SAMPLE(S)		(S * 4)
+
+#define NBR_AVG_SAMPLES			20
+
+#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
+
+#define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
+#define BATT_OK_MIN			2360 /* mV */
+#define BATT_OK_INCREMENT		50 /* mV */
+#define BATT_OK_MAX_NR_INCREMENTS	0xE
+
+/* FG constants */
+#define BATT_OVV			0x01
+
+/**
+ * struct ab8500_fg_interrupts - ab8500 fg interupts
+ * @name:	name of the interrupt
+ * @isr		function pointer to the isr
+ */
+struct ab8500_fg_interrupts {
+	char *name;
+	irqreturn_t (*isr)(int irq, void *data);
+};
+
+enum ab8500_fg_discharge_state {
+	AB8500_FG_DISCHARGE_INIT,
+	AB8500_FG_DISCHARGE_INITMEASURING,
+	AB8500_FG_DISCHARGE_INIT_RECOVERY,
+	AB8500_FG_DISCHARGE_RECOVERY,
+	AB8500_FG_DISCHARGE_READOUT_INIT,
+	AB8500_FG_DISCHARGE_READOUT,
+	AB8500_FG_DISCHARGE_WAKEUP,
+};
+
+enum ab8500_fg_charge_state {
+	AB8500_FG_CHARGE_INIT,
+	AB8500_FG_CHARGE_READOUT,
+};
+
+enum ab8500_fg_calibration_state {
+	AB8500_FG_CALIB_INIT,
+	AB8500_FG_CALIB_WAIT,
+	AB8500_FG_CALIB_END,
+};
+
+struct ab8500_fg_avg_cap {
+	int avg;
+	int samples[NBR_AVG_SAMPLES];
+	__kernel_time_t time_stamps[NBR_AVG_SAMPLES];
+	int pos;
+	int nbr_samples;
+	int sum;
+};
+
+struct ab8500_fg_cap_scaling {
+	bool enable;
+	int cap_to_scale[2];
+	int disable_cap_level;
+	int scaled_cap;
+};
+
+struct ab8500_fg_battery_capacity {
+	int max_mah_design;
+	int max_mah;
+	int mah;
+	int permille;
+	int level;
+	int prev_mah;
+	int prev_percent;
+	int prev_level;
+	int user_mah;
+	struct ab8500_fg_cap_scaling cap_scale;
+};
+
+struct ab8500_fg_flags {
+	bool fg_enabled;
+	bool conv_done;
+	bool charging;
+	bool fully_charged;
+	bool force_full;
+	bool low_bat_delay;
+	bool low_bat;
+	bool bat_ovv;
+	bool batt_unknown;
+	bool calibrate;
+	bool user_cap;
+	bool batt_id_received;
+};
+
+struct inst_curr_result_list {
+	struct list_head list;
+	int *result;
+};
+
+/**
+ * struct ab8500_fg_test - ab8500 FG device information in test mode
+ * @enable:			true if fg in test mode else false
+ * @cc_int_offset:		offset for internal calibration
+ * @cc_soft_offset:		offset for software calibration
+ * @cc_sample_conv:		sample read
+ * @cc_sample_conv_calib_uA:	sample converted in uA
+ * @cceoc_complete:		pointer to the struct completion, to indicate
+ *				the completion of internal calibration and
+ *				one sample reading
+ * @nconv_accu_complete:	pointer to the struct completion, to indicate
+ *				the completion of sample to accumulate
+ * @cc_int_calib_complete:	pointer to the struct completion, to indicate
+ *				the completion of internal calibration
+ * @lock:			Mutex for locking the CC
+ */
+struct ab8500_fg_test {
+	bool enable;
+	u8 cc_int_offset;
+	u8 cc_soft_offset;
+	u16 cc_sample_conv;
+	int cc_sample_conv_calib_uA;
+	struct completion cceoc_complete;
+	struct completion nconv_accu_complete;
+	struct completion cc_int_calib_complete;
+	struct mutex lock;
+};
+
+/**
+ * struct ab8500_fg - ab8500 FG device information
+ * @dev:		Pointer to the structure device
+ * @node:		a list of AB8500 FGs, hence prepared for reentrance
+ * @irq			holds the CCEOC interrupt number
+ * @vbat:		Battery voltage in mV
+ * @vbat_nom:		Nominal battery voltage in mV
+ * @inst_curr:		Instantenous battery current in mA
+ * @avg_curr:		Average battery current in mA
+ * @bat_temp		battery temperature
+ * @fg_samples:		Number of samples used in the FG accumulation
+ * @accu_charge:	Accumulated charge from the last conversion
+ * @recovery_cnt:	Counter for recovery mode
+ * @high_curr_cnt:	Counter for high current mode
+ * @init_cnt:		Counter for init mode
+ * @low_bat_cnt		Counter for number of consecutive low battery measures
+ * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
+ * @recovery_needed:	Indicate if recovery is needed
+ * @high_curr_mode:	Indicate if we're in high current mode
+ * @init_capacity:	Indicate if initial capacity measuring should be done
+ * @turn_off_fg:	True if fg was off before current measurement
+ * @calib_state		State during offset calibration
+ * @discharge_state:	Current discharge state
+ * @charge_state:	Current charge state
+ * @ab8500_fg_started	Completion struct used for the instant current start
+ * @ab8500_fg_complete	Completion struct used for the instant current reading
+ * @flags:		Structure for information about events triggered
+ * @bat_cap:		Structure for battery capacity specific parameters
+ * @avg_cap:		Average capacity filter
+ * @parent:		Pointer to the struct ab8500
+ * @gpadc:		Pointer to the struct gpadc
+ * @bm:           	Platform specific battery management information
+ * @fg_psy:		Structure that holds the FG specific battery properties
+ * @fg_wq:		Work queue for running the FG algorithm
+ * @fg_periodic_work:	Work to run the FG algorithm periodically
+ * @fg_low_bat_work:	Work to check low bat condition
+ * @fg_reinit_work	Work used to reset and reinitialise the FG algorithm
+ * @fg_work:		Work to run the FG algorithm instantly
+ * @fg_acc_cur_work:	Work to read the FG accumulator
+ * @fg_check_hw_failure_work:	Work for checking HW state
+ * @cc_lock:		Mutex for locking the CC
+ * @fg_kobject:		Structure of type kobject
+ */
+struct ab8500_fg {
+	struct device *dev;
+	struct list_head node;
+	int irq;
+	int vbat;
+	int vbat_nom;
+	int inst_curr;
+	int avg_curr;
+	int bat_temp;
+	int fg_samples;
+	int accu_charge;
+	int recovery_cnt;
+	int high_curr_cnt;
+	int init_cnt;
+	int low_bat_cnt;
+	int nbr_cceoc_irq_cnt;
+	bool recovery_needed;
+	bool high_curr_mode;
+	bool init_capacity;
+	bool turn_off_fg;
+	enum ab8500_fg_calibration_state calib_state;
+	enum ab8500_fg_discharge_state discharge_state;
+	enum ab8500_fg_charge_state charge_state;
+	struct completion ab8500_fg_started;
+	struct completion ab8500_fg_complete;
+	struct ab8500_fg_flags flags;
+	struct ab8500_fg_battery_capacity bat_cap;
+	struct ab8500_fg_avg_cap avg_cap;
+	struct ab8500 *parent;
+	struct ab8500_gpadc *gpadc;
+	struct abx500_bm_data *bm;
+	struct power_supply fg_psy;
+	struct workqueue_struct *fg_wq;
+	struct delayed_work fg_periodic_work;
+	struct delayed_work fg_low_bat_work;
+	struct delayed_work fg_reinit_work;
+	struct work_struct fg_work;
+	struct work_struct fg_acc_cur_work;
+	struct delayed_work fg_check_hw_failure_work;
+	struct mutex cc_lock;
+	struct kobject fg_kobject;
+};
+
+extern char *discharge_state[];
+extern char *charge_state[];
+
+int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable);
+void ab8500_fg_charge_state_to(struct ab8500_fg *di,
+		enum ab8500_fg_charge_state new_state);
+void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
+		enum ab8500_fg_charge_state new_state);
+/* test initialization */
+#ifdef CONFIG_AB8500_BM_DEEP_DEBUG
+void ab8500_fg_test_init(struct ab8500_fg *di);
+#else
+void ab8500_fg_test_init(struct ab8500_fg *di) {return; }
+#endif
diff --git a/drivers/power/ab8500_fg_deepdebug.c b/drivers/power/ab8500_fg_deepdebug.c
new file mode 100644
index 0000000..8845de6
--- /dev/null
+++ b/drivers/power/ab8500_fg_deepdebug.c
@@ -0,0 +1,823 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ *
+ * Battery Management Deep debug support
+ *
+ * Note: Deep debug features are needed to perform the
+ * HW validation of the platform
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Cedric Madianga <cedric.madianga@stericsson.com>
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/delay.h>
+#include <linux/time.h>
+
+#include "ab8500_fg.h"
+
+/* Exposure to the debugfs interface for test purpose only */
+
+/**
+ * ab8500_fg_test_algorithm_en() - enable or disable gas gauge test mode
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	enable/disable gas gaude test mode
+ *
+ * Return 0 or error code
+ * Only used for test purpose
+ */
+int ab8500_fg_test_algorithm_en(struct ab8500_fg *di, bool enable)
+{
+	int ret = 0;
+
+	if (enable) {
+		/* Set coulomb counter in test mode. */
+		dev_dbg(di->dev, "Try to put gas gauge in test mode\n");
+		cancel_delayed_work_sync(&di->fg_periodic_work);
+		if (di->flags.fg_enabled) {
+			ret = ab8500_fg_coulomb_counter(di, false);
+			if (ret)
+				return ret;
+		}
+		di->test.enable = true;
+		dev_dbg(di->dev, "Gas gauge in test mode\n");
+	} else {
+		/* Set coulomb counter in normal mode. */
+		dev_dbg(di->dev, "Try to put gas gauge in normal mode\n");
+		if (di->flags.fg_enabled) {
+			ret = ab8500_fg_coulomb_counter(di, false);
+			if (ret)
+				return ret;
+		}
+
+		di->init_capacity = true;
+		ab8500_fg_charge_state_to(di, AB8500_FG_CHARGE_INIT);
+		ab8500_fg_discharge_state_to(di, AB8500_FG_DISCHARGE_INIT);
+
+		di->flags.batt_unknown = true;
+		di->flags.batt_id_received = false;
+
+		di->test.enable = false;
+		ab8500_fg_coulomb_counter(di, true);
+
+		di->flags.calibrate = true;
+		di->calib_state = AB8500_FG_CALIB_INIT;
+		dev_dbg(di->dev, "Gas gauge in normal mode\n");
+	}
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_is_test_is_algorithm_en() -
+ * Return 1 if fg algorithm is enable 0 else
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Only used for test purpose
+ */
+bool ab8500_fg_test_is_algorithm_en(struct ab8500_fg *di)
+{
+	return di->test.enable;
+}
+
+/**
+ * ab8500_fg_test_en() - enable coulomb counter
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	enable/disable
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+
+int ab8500_fg_test_en(struct ab8500_fg *di, bool enable)
+{
+	return ab8500_fg_coulomb_counter(di, enable);
+}
+
+/**
+ * ab8500_fg_test_is_en() - Return 1 if fg is enabled 0 else
+ * @di:		pointer to the ab8500_fg structure
+ *
+ *  Only used for test purpose
+ */
+bool ab8500_fg_test_is_en(struct ab8500_fg *di)
+{
+	return di->flags.fg_enabled;
+}
+
+/**
+ * ab8500_fg_test_set_cc_int_n_avg() - set number of conversion to average for
+ * internal calibration
+ * @di:		pointer to the ab8500_fg structure
+ * @val:	number of conversion to average
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_cc_int_n_avg(struct ab8500_fg *di, u8 val)
+{
+	int ret;
+	u8 cc_int_n_avg = 0;
+
+	switch (val) {
+	case 4:
+		cc_int_n_avg = CC_INT_CAL_SAMPLES_4;
+		break;
+	case 8:
+		cc_int_n_avg = CC_INT_CAL_SAMPLES_8;
+		break;
+	case 16:
+		cc_int_n_avg = CC_INT_CAL_SAMPLES_16;
+		break;
+	default:
+		dev_err(di->dev,
+				"incorrect sample values\n"
+				"correct sample values should be 4, 8 or 16\n");
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+			CC_INT_CAL_N_AVG_MASK, cc_int_n_avg);
+	if (ret < 0)
+		dev_err(di->dev,
+				"set number of conversion to average failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_cc_int_n_avg() - get number of conversion to average for
+ * internal calibration
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return number of conversion to average or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_cc_int_n_avg(struct ab8500_fg *di)
+{
+	int ret;
+	u8 val = 0;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_CTRL_REG,  &val);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"get number of conversion to average failed\n");
+		return ret;
+	}
+
+	switch (val & CC_INT_CAL_N_AVG_MASK) {
+	case CC_INT_CAL_SAMPLES_4:
+		ret = 4;
+		break;
+	case CC_INT_CAL_SAMPLES_8:
+		ret = 8;
+		break;
+	case CC_INT_CAL_SAMPLES_16:
+		ret = 16;
+		break;
+	case CC_INT_CAL_N_AVG_MASK:
+		ret = 16;
+		break;
+	default:
+		dev_err(di->dev,
+			"incorrect val read in AB8500_GASG_CC_CTRL_REG");
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_int_calib() - launch internal calibration
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return result of calibration or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_int_calib(struct ab8500_fg *di)
+{
+	int ret;
+	u8 val;
+
+	mutex_lock(&di->test.lock);
+	dev_dbg(di->dev, "Internal calibration ongoing...\n");
+
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		CC_INTAVGOFFSET_ENA, CC_INTAVGOFFSET_ENA);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"enabling offset average computation failed\n");
+		goto err;
+	}
+
+	/* wait for completion of calibration */
+	if (!wait_for_completion_timeout(&di->test.cc_int_calib_complete,
+				5*HZ)) {
+		dev_err(di->dev,
+			"timeout: didn't receive CCIntCalib interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_CNTR_AVGOFF_REG,  &val);
+	if (ret < 0)
+		goto err;
+
+	di->test.cc_int_offset = val;
+	dev_dbg(di->dev, "Internal Calibration done...\n");
+	mutex_unlock(&di->test.lock);
+
+	return di->test.cc_int_offset;
+
+err:
+	mutex_unlock(&di->test.lock);
+	dev_err(di->dev, "Internal calibration failure\n");
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_soft_calib() - launch software calibration
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return result of calibration or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_soft_calib(struct ab8500_fg *di)
+{
+	int ret;
+	u8 low_data, high_data;
+
+	mutex_lock(&di->test.lock);
+	dev_dbg(di->dev, "Software calibration ongoing...\n");
+
+	/* Set ADconverter in calibration mode */
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		CC_CALIB, CC_CALIB);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"set ADconverter in calibration mode failed\n");
+		goto err;
+	}
+
+	/* wait for completion of calibration */
+	if (!wait_for_completion_timeout(&di->test.cceoc_complete, 1*HZ)) {
+		dev_err(di->dev,
+			"timeout: didn't receive CCEOC interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!wait_for_completion_timeout(&di->test.cceoc_complete, 1*HZ)) {
+		dev_err(di->dev,
+			"timeout: didn't receive CCEOC interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Don't set ADConverter in calibration mode */
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		CC_CALIB, 0x00);
+	if (ret < 0) {
+		dev_err(di->dev, "stopping calibration mode failed\n");
+		goto err;
+	}
+
+	/* Transfer sample and accumulator values */
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		READ_REQ, READ_REQ);
+	if (ret < 0) {
+		dev_err(di->dev, "transfer accumulator data failed\n");
+		goto err;
+	}
+
+	/* Retrieve sample conversion */
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_SMPL_CNVL_REG, &low_data);
+	if (ret < 0) {
+		dev_err(di->dev, "read low byte sample conversion failed\n");
+		goto err;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_SMPL_CNVH_REG, &high_data);
+	if (ret < 0) {
+		dev_err(di->dev, "read high byte sample conversion failed\n");
+		goto err;
+	}
+
+	di->test.cc_soft_offset = (high_data << 8) | low_data;
+	dev_dbg(di->dev, "Software Calibration done...\n");
+	mutex_unlock(&di->test.lock);
+
+	return di->test.cc_soft_offset;
+
+err:
+	mutex_unlock(&di->test.lock);
+	dev_err(di->dev, "Software calibration failure\n");
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_set_cc_soft_offset() - set software offset into register
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	manual offset to be stored
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_cc_soft_offset(struct ab8500_fg *di, u8 val)
+{
+	int ret;
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+			AB8500_GASG_CC_OFFSET_REG, val);
+	if (ret < 0)
+		dev_err(di->dev,
+				"set software offset failed\n");
+	else
+		di->test.cc_soft_offset = val;
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_cc_soft_offset() - get software offset into register
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	manual offset to be stored
+ *
+ * Return software offset or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_cc_soft_offset(struct ab8500_fg *di, u8 *val)
+{
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+			AB8500_GASG_CC_OFFSET_REG,  val);
+	if (ret < 0)
+		dev_err(di->dev,
+				"get software offset failed\n");
+	else
+		di->test.cc_soft_offset = *val;
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_set_rst_accu_sample_counter() - set reset accumulator
+ * sample counter bit
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	enable/disable reset acc
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_rst_accu_sample_counter(struct ab8500_fg *di,
+		bool enable)
+{
+	int ret;
+	u8 val = 0;
+
+	if (enable)
+		val = RESET_ACCU;
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+			RESET_ACCU, val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"set accumulator sample counter reset bit failed\n");
+
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_rst_accu_sample_counter() - get reset accumulator
+ * sample counter bit
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return reset accumulator sample counter bit or error code
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_rst_accu_sample_counter(struct ab8500_fg *di)
+{
+	u8 val = 0;
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_CTRL_REG,  &val);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"get accumulator sample counter reset bit failed\n");
+		return ret;
+	}
+
+	if (val & RESET_ACCU)
+		ret = 1;
+	else
+		ret = 0;
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_set_cc_mux_offset() - set coumlomb counter offset
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	enable/disable offset
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_cc_mux_offset(struct ab8500_fg *di, bool enable)
+{
+	int ret;
+	u8 val = 0;
+
+	if (enable)
+		val = CC_MUXOFFSET;
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		CC_MUXOFFSET, val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"set mux offset failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_cc_mux_offset() - get coulomb counter mux offset
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Get mux offset or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_cc_mux_offset(struct ab8500_fg *di)
+{
+	u8 val = 0;
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_CTRL_REG,  &val);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"get mux offset failed\n");
+		return ret;
+	}
+
+	if (val & CC_MUXOFFSET)
+		ret = 1;
+	else
+		ret = 0;
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_read_sample() - read one sample
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return sample or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_read_sample(struct ab8500_fg *di)
+{
+	int ret;
+	u8 low_data, high_data;
+
+	mutex_lock(&di->test.lock);
+	dev_dbg(di->dev, "Sample reading ongoing...\n");
+
+	/* wait for completion of calibration */
+	if (!wait_for_completion_timeout(&di->test.cceoc_complete, 1*HZ)) {
+		dev_err(di->dev,
+			"timeout: didn't receive CCEOC interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!wait_for_completion_timeout(&di->test.cceoc_complete, 1*HZ)) {
+		dev_err(di->dev,
+			"timeout: didn't receive CCEOC interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Transfer sample and accumulator values */
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+		READ_REQ, READ_REQ);
+	if (ret < 0) {
+		dev_err(di->dev, "transfer accumulator data failed\n");
+		goto err;
+	}
+
+	/* Retrieve sample conversion */
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_SMPL_CNVL_REG, &low_data);
+	if (ret < 0) {
+		dev_err(di->dev, "read low byte sample conversion failed\n");
+		goto err;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_SMPL_CNVH_REG, &high_data);
+	if (ret < 0) {
+		dev_err(di->dev, "read high byte sample conversion failed\n");
+		goto err;
+	}
+
+	di->test.cc_sample_conv = (high_data << 8) | low_data;
+
+	dev_dbg(di->dev, "Sample reading done...\n");
+	mutex_unlock(&di->test.lock);
+
+	return di->test.cc_sample_conv;
+
+err:
+	mutex_unlock(&di->test.lock);
+	dev_err(di->dev, "Sample reading failure\n");
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_sample_calibrate() - compute sample calibrated data
+ * @di:		pointer to the ab8500_fg structure
+ * @val:	raw sample
+ *
+ * Return sample calibrated value
+ * Only used for test purpose
+ */
+int ab8500_fg_test_sample_calibrate(struct ab8500_fg *di, int val)
+{
+	int ret;
+
+	ret = ab8500_fg_test_get_cc_mux_offset(di);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		return val - di->test.cc_int_offset;
+	else
+		return val - di->test.cc_soft_offset;
+}
+
+/**
+ * ab8500_fg_test_sample_calibrate_to_uA() -  convert sample calibrated data
+ * to nuAH
+ * @di:		pointer to the ab8500_fg structure
+ * @val:	calibrate sample
+ *
+ * Return sample calibrated value
+ * Only used for test purpose
+ */
+int ab8500_fg_test_sample_calibrate_to_uA(struct ab8500_fg *di, int val)
+{
+	di->test.cc_sample_conv_calib_uA = val * QLSB_NANO_AMP_HOURS_X10;
+	return di->test.cc_sample_conv_calib_uA;
+}
+
+/**
+ * ab8500_fg_test_get_nconv_accu() - get number of conversion accumulated
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return umber of conversion accumulated or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_nconv_accu(struct ab8500_fg *di, u8 *val)
+{
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU, val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"get nb samples to be accumulated failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_nconv_accu_to_uA() - get number of conversion accumulated
+ * in uA
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return umber of conversion accumulated or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_nconv_accu_to_uA(struct ab8500_fg *di, int val)
+{
+	return val * di->test.cc_sample_conv_calib_uA;
+}
+
+/**
+ * ab8500_fg_test_set_rst_nconv_accu() -  allows to reset the 21bits accumulator data
+ * @di:		pointer to the ab8500_fg structure
+ * @enable:	enable/disable to reset the 21bits accumulator data
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_rst_nconv_accu(struct ab8500_fg *di,
+		bool enable)
+{
+	int ret;
+	u8 val = 0;
+
+	if (enable)
+		val = RESET_ACCU;
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU_CTRL,
+		RESET_ACCU, val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"set accumulator reset bit failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_rst_nconv_accu() - get staus of ResetNconvAccu bit
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return accumulator reset bit or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_rst_nconv_accu(struct ab8500_fg *di)
+{
+	u8 val = 0;
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU_CTRL,  &val);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"get accumulator reset bit failedd\n");
+		goto out;
+	}
+
+	if (val & RESET_ACCU)
+		ret = 1;
+	else
+		ret = 0;
+out:
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_set_nconv_accu_nb_sample() - set number of sample conversion
+ * to be accumulated in 21bits accumulator
+ * @di:		pointer to the ab8500_fg structure
+ * @nb_sample:	number of samples
+ *
+ * Return 0 or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_set_nconv_accu_nb_sample(struct ab8500_fg *di, u8 val)
+{
+	int ret;
+
+	ret = abx500_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU, val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"set number of samples to accumulated failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_get_nconv_accu_nb_sample() - get number of sample conversion
+ * to be accumulated in 21bits accumulator
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return number of samples to be accumulated or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_get_nconv_accu_nb_sample(struct ab8500_fg *di, u8 *val)
+{
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU,  val);
+	if (ret < 0)
+		dev_err(di->dev,
+			"get number of samples to accumulated failed\n");
+
+	return ret;
+}
+
+/**
+ * ab8500_fg_test_read_nconv_accu_sample() - read of accumulator after N samples
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Return sample or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_read_nconv_accu_sample(struct ab8500_fg *di)
+{
+	int ret;
+	int nb_sample;
+	u8 low_data, med_data, high_data;
+
+	/* Get nb sample to average */
+	ret = ab8500_fg_test_get_nconv_accu_nb_sample(di, &nb_sample);
+	if (ret < 0)
+		goto out;
+
+	mutex_lock(&di->test.lock);
+	dev_dbg(di->dev, "N Samples reading ongoing...\n");
+
+	/* Launch measure */
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+		AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU_CTRL,
+		RD_NCONV_ACCU_REQ, RD_NCONV_ACCU_REQ);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"launch measure failed\n");
+		goto err;
+	}
+
+	/* wait for completion of measure */
+	if (!wait_for_completion_timeout(&di->test.nconv_accu_complete,
+				nb_sample*(HZ/4))) {
+		dev_err(di->dev,
+			"timeout: didn't receive NCONV_ACCU interrupt\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Retrieve samples */
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU_LOW,  &low_data);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"read low data failed\n");
+		goto err;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU_MED,  &med_data);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"read med data failed\n");
+		goto err;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_GAS_GAUGE,
+		AB8500_GASG_CC_NCOV_ACCU_HIGH, &high_data);
+	if (ret < 0) {
+		dev_err(di->dev,
+			"read high data failed\n");
+		goto err;
+	}
+
+	dev_dbg(di->dev, "N Samples reading done...\n");
+	mutex_unlock(&di->test.lock);
+
+	return (high_data << 16) | (med_data << 8) | low_data;
+
+err:
+	mutex_unlock(&di->test.lock);
+	dev_err(di->dev, "Sample reading failure\n");
+out:
+	return ret;
+
+}
+
+/**
+ * ab8500_fg_test_read_nconv_accu_sample_to_uA - convert accu read in uA
+ * @di:		pointer to the ab8500_fg structure
+ * @val:	accu read
+ *
+ * Return sample or error code on failure
+ * Only used for test purpose
+ */
+int ab8500_fg_test_read_nconv_accu_sample_to_uA(struct ab8500_fg *di, int val)
+{
+	return val * QLSB_NANO_AMP_HOURS_X10;
+}
+
+void __devinit ab8500_fg_test_init(struct ab8500_fg *di)
+{
+	/* Initialize objects need for test purpose. */
+	di->test.enable = false;
+	di->test.cc_int_offset = 0;
+	di->test.cc_soft_offset = 0;
+	di->test.cc_sample_conv = 0;
+	di->test.cc_sample_conv_calib_uA = 0;
+	init_completion(&di->test.cceoc_complete);
+	init_completion(&di->test.nconv_accu_complete);
+	init_completion(&di->test.cc_int_calib_complete);
+	mutex_init(&di->test.lock);
+}
+
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index ec796c7..b800332 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -485,4 +485,168 @@ static inline int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res)
 }
 
 #endif
+
+#ifdef CONFIG_AB8500_BM_DEEP_DEBUG
+int ab8500_fg_test_algorithm_en(struct ab8500_fg *di, bool enable);
+bool ab8500_fg_test_is_algorithm_en(struct ab8500_fg *di);
+int ab8500_fg_test_en(struct ab8500_fg *di, bool enable);
+bool ab8500_fg_test_is_en(struct ab8500_fg *di);
+int ab8500_fg_test_set_cc_int_n_avg(struct ab8500_fg *di, u8 val);
+int ab8500_fg_test_get_cc_int_n_avg(struct ab8500_fg *di);
+int ab8500_fg_test_int_calib(struct ab8500_fg *di);
+int ab8500_fg_test_soft_calib(struct ab8500_fg *di);
+int ab8500_fg_test_set_cc_soft_offset(struct ab8500_fg *di, u8 val);
+int ab8500_fg_test_get_cc_soft_offset(struct ab8500_fg *di, u8 *val);
+int ab8500_fg_test_set_rst_accu_sample_counter(struct ab8500_fg *di,
+		bool enable);
+int ab8500_fg_test_get_rst_accu_sample_counter(struct ab8500_fg *di);
+int ab8500_fg_test_set_cc_mux_offset(struct ab8500_fg *di, bool enable);
+int ab8500_fg_test_get_cc_mux_offset(struct ab8500_fg *di);
+int ab8500_fg_test_read_sample(struct ab8500_fg *di);
+int ab8500_fg_test_sample_calibrate(struct ab8500_fg *di, int val);
+int ab8500_fg_test_sample_calibrate_to_uA(struct ab8500_fg *di, int val);
+int ab8500_fg_test_get_nconv_accu(struct ab8500_fg *di, u8 *val);
+int ab8500_fg_test_get_nconv_accu_to_uA(struct ab8500_fg *di, int val);
+int ab8500_fg_test_set_rst_nconv_accu(struct ab8500_fg *di,
+		bool enable);
+int ab8500_fg_test_get_rst_nconv_accu(struct ab8500_fg *di);
+int ab8500_fg_test_set_nconv_accu_nb_sample(struct ab8500_fg *di, u8 val);
+int ab8500_fg_test_get_nconv_accu_nb_sample(struct ab8500_fg *di, u8 *val);
+int ab8500_fg_test_read_nconv_accu_sample(struct ab8500_fg *di);
+int ab8500_fg_test_read_nconv_accu_sample_to_uA(struct ab8500_fg *di, int val);
+#else
+static inline int ab8500_fg_test_algorithm_en(struct ab8500_fg *di, bool enable)
+{
+	return -ENODEV;
+}
+
+static inline bool ab8500_fg_test_is_algorithm_en(struct ab8500_fg *di)
+{
+	return false;
+}
+
+static inline int ab8500_fg_test_en(struct ab8500_fg *di, bool enable)
+{
+	return -ENODEV;
+}
+
+static inline bool ab8500_fg_test_is_en(struct ab8500_fg *di)
+{
+	return false;
+}
+
+static inline int ab8500_fg_test_set_cc_int_n_avg(struct ab8500_fg *di, u8 val)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_cc_int_n_avg(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_int_calib(struct ab8500_fg *di)
+{
+	return -ENODEV;
+}
+
+static inline int ab8500_fg_test_soft_calib(struct ab8500_fg *di)
+{
+	return -ENODEV;
+}
+
+static inline int ab8500_fg_test_set_cc_soft_offset(struct ab8500_fg *di,
+		u8 val)
+{
+	return 0;
+}
+static inline int ab8500_fg_test_get_cc_soft_offset(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_set_rst_accu_sample_counter(struct ab8500_fg
+		*di, bool enable)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_rst_accu_sample_counter(struct ab8500_fg
+		*di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_set_cc_mux_offset(struct ab8500_fg *di,
+		bool enable)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_cc_mux_offset(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_read_sample(struct ab8500_fg *di)
+{
+	return -ENODEV;
+}
+
+static inline int ab8500_fg_test_sample_calibrate(struct ab8500_fg *di, int val)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_sample_calibrate_to_uA(struct ab8500_fg *di,
+		int val)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_nconv_accu(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_nconv_accu_to_uA(struct ab8500_fg *di,
+		int val)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_set_rst_nconv_accu(struct ab8500_fg *di,
+		bool enable)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_rst_nconv_accu(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_set_nconv_accu_nb_sample(struct ab8500_fg *di,
+		u8 val)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_get_nconv_accu_nb_sample(struct ab8500_fg *di)
+{
+	return 0;
+}
+
+static inline int ab8500_fg_test_read_nconv_accu_sample(struct ab8500_fg *di)
+{
+	return -ENODEV;
+}
+
+static inline int ab8500_fg_test_read_nconv_accu_sample_to_uA(struct ab8500_fg
+		*di, int val)
+{
+	return 0;
+}
+
+#endif
 #endif /* _AB8500_BM_H */
-- 
1.7.9.5

