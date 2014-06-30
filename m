Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaF3J5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:57:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:7162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbaF3J4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:56:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,574,1400050800"; 
   d="scan'208";a="555187605"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Date: Mon, 30 Jun 2014 15:25:54 +0530
Message-Id: <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Product Safety Engineering (PSE) specification for battery charging, the
battery characteristics and thereby the charging rates can vary on different
temperature zones. This patch introduces a PSE compliant charging algorithm with
maintenance charging support. The algorithm can be selected by the power supply
charging driver based on the type of the battery charging profile.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/Kconfig                      |   15 +++
 drivers/power/Makefile                     |    1 +
 drivers/power/charging_algo_pse.c          |  202 ++++++++++++++++++++++++++++
 include/linux/power/power_supply_charger.h |   63 +++++++++
 4 files changed, 281 insertions(+)
 create mode 100644 drivers/power/charging_algo_pse.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index f679f82..54a0321 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -22,6 +22,21 @@ config POWER_SUPPLY_CHARGER
 	  drivers to keep the charging logic outside and the charger driver
 	  just need to abstract the charger hardware.
 
+config POWER_SUPPLY_CHARGING_ALGO_PSE
+	bool "PSE compliant charging algorithm"
+	depends on POWER_SUPPLY_CHARGER
+	help
+	  Say Y here to select Product Safety Engineering (PSE) compliant
+	  charging algorithm. As per PSE standard the battery characteristics
+	  and thereby the charging rates can vary on different temperature
+	  zones. Select this if your charging algorithm need to change the
+	  charging parameters based on the battery temperature and the battery
+	  charging profile follows the struct psy_pse_chrg_prof definition.
+	  This  config will enable PSE compliant charging algorithm with
+	  maintenance charging support. At runtime the algorithm will be
+	  selected by the psy charger driver based on the type of the battery
+	  charging profile.
+
 config PDA_POWER
 	tristate "Generic PDA/phone power driver"
 	depends on !S390
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 405f0f4..77535fd 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
 
 obj-$(CONFIG_POWER_SUPPLY_CHARGER) += power_supply_charger.o
+obj-$(CONFIG_POWER_SUPPLY_CHARGING_ALGO_PSE) += charging_algo_pse.o
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
 obj-$(CONFIG_MAX8925_POWER)	+= max8925_power.o
diff --git a/drivers/power/charging_algo_pse.c b/drivers/power/charging_algo_pse.c
new file mode 100644
index 0000000..6ec4873
--- /dev/null
+++ b/drivers/power/charging_algo_pse.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/thermal.h>
+#include "power_supply.h"
+#include "power_supply_charger.h"
+
+/* 98% of CV is considered as voltage to detect Full */
+#define FULL_CV_MIN 98
+
+/*
+ * Offset to exit from maintenance charging. In maintenance charging
+ * if the volatge is less than the (maintenance_lower_threshold -
+ * MAINT_EXIT_OFFSET) then system can switch to normal charging
+ */
+
+#define MAINT_EXIT_OFFSET 50  /* mV */
+
+static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
+		int temp)
+{
+	int i = 0;
+	int temp_range_cnt;
+
+	temp_range_cnt =  min_t(u16, pse_mod_bprof->temp_mon_ranges,
+					BATT_TEMP_NR_RNG);
+	if ((temp < pse_mod_bprof->temp_low_lim) ||
+		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
+		return -EINVAL;
+
+	for (i = 0; i < temp_range_cnt; ++i)
+		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
+			break;
+	return i-1;
+}
+
+static inline bool is_charge_terminated(long volt, long cur,
+				long iterm, unsigned long cv)
+{
+	return (cur > 0) && (cur <= iterm) &&
+				((volt * 100)  >= (FULL_CV_MIN * cv));
+}
+
+static inline bool is_battery_full(struct psy_batt_context *batt_cxt,
+		struct psy_pse_chrg_prof *pse_mod_bprof, unsigned long cv)
+{
+	int i;
+	struct psy_batt_props batt_props;
+
+	batt_props =  batt_cxt->batt_props;
+
+	/*
+	* Software full detection. Check the battery charge current to detect
+	* battery Full. The voltage also verified to avoid false charge
+	* full detection.
+	*/
+	for (i = (MAX_CUR_VOLT_SAMPLES - 1); i >= 0; --i) {
+
+		if (!(is_charge_terminated(batt_cxt->voltage_now_cache[i],
+				batt_cxt->current_now_cache[i],
+				pse_mod_bprof->chrg_term_mA, cv)))
+			return false;
+	}
+
+	return true;
+}
+
+static int  pse_get_bat_thresholds(struct psy_batt_chrg_prof  bprof,
+			struct psy_batt_thresholds *bat_thresh)
+{
+	struct psy_pse_chrg_prof *pse_mod_bprof =
+			(struct psy_pse_chrg_prof *) bprof.batt_prof;
+
+	if ((bprof.chrg_prof_type != PSY_CHRG_PROF_PSE) || (!pse_mod_bprof))
+		return -EINVAL;
+
+	bat_thresh->iterm = pse_mod_bprof->chrg_term_mA;
+	bat_thresh->temp_min = pse_mod_bprof->temp_low_lim;
+	bat_thresh->temp_max = pse_mod_bprof->temp_mon_range[0].temp_up_lim;
+
+	return 0;
+}
+
+static enum psy_algo_stat pse_get_next_cc_cv(struct psy_batt_context *batt_cxt,
+	struct psy_batt_chrg_prof  bprof, unsigned long *cc, unsigned long *cv)
+{
+	int tzone;
+	struct psy_pse_chrg_prof *pse_mod_bprof;
+	struct psy_batt_props batt_props;
+	enum psy_algo_stat algo_stat;
+	int maint_exit_volt;
+
+	pse_mod_bprof = (struct psy_pse_chrg_prof *) bprof.batt_prof;
+	algo_stat = batt_cxt->algo_stat;
+
+	batt_props = batt_cxt->batt_props;
+
+	*cc = *cv = 0;
+
+	/*
+	* If STATUS is discharging, assume that charger is not connected.
+	* If charger is not connected, no need to take any action.
+	* If charge profile type is not PSY_CHRG_PROF_PSE or the charge profile
+	* is not present, no need to take any action.
+	*/
+
+	if (!pse_mod_bprof)
+		return PSY_ALGO_STAT_NOT_CHARGE;
+
+	tzone = get_tempzone(pse_mod_bprof, batt_props.temperature);
+
+	if (tzone < 0)
+		return PSY_ALGO_STAT_NOT_CHARGE;
+
+	/*
+	* Change the algo status to not charging, if battery is
+	* not really charging or less than maintenance exit threshold.
+	* This way algorithm can switch to normal charging if current
+	* status is full/maintenance.
+	*/
+	maint_exit_volt = pse_mod_bprof->
+				temp_mon_range[tzone].maint_chrg_vol_ll -
+				MAINT_EXIT_OFFSET;
+
+	if ((batt_props.status == POWER_SUPPLY_STATUS_DISCHARGING) ||
+		(batt_props.status == POWER_SUPPLY_STATUS_NOT_CHARGING) ||
+			batt_props.voltage_now < maint_exit_volt) {
+
+		algo_stat = PSY_ALGO_STAT_NOT_CHARGE;
+
+	}
+
+	/* read cc and cv based on temperature and algorithm status */
+	if (algo_stat == PSY_ALGO_STAT_FULL ||
+			algo_stat == PSY_ALGO_STAT_MAINT) {
+
+		/*
+		* if status is full and voltage is lower than maintenance lower
+		* threshold change status to maintenance
+		*/
+
+		if (algo_stat == PSY_ALGO_STAT_FULL &&
+			(batt_props.voltage_now <=
+			pse_mod_bprof->temp_mon_range[tzone].maint_chrg_vol_ll))
+				algo_stat = PSY_ALGO_STAT_MAINT;
+
+		/* Read maintenance CC and CV */
+		if (algo_stat == PSY_ALGO_STAT_MAINT) {
+			*cv = pse_mod_bprof->temp_mon_range
+					[tzone].maint_chrg_vol_ul;
+			*cc = pse_mod_bprof->temp_mon_range
+					[tzone].maint_chrg_cur;
+		}
+	} else {
+		*cv = pse_mod_bprof->temp_mon_range[tzone].full_chrg_vol;
+		*cc = pse_mod_bprof->temp_mon_range[tzone].full_chrg_cur;
+		algo_stat = PSY_ALGO_STAT_CHARGE;
+	}
+
+	if (is_battery_full(batt_cxt, pse_mod_bprof, *cv)) {
+		*cc = *cv = 0;
+		algo_stat = PSY_ALGO_STAT_FULL;
+	}
+
+	return algo_stat;
+}
+
+struct psy_charging_algo pse_algo = {
+	.name = "pse_algo",
+	.chrg_prof_type = PSY_CHRG_PROF_PSE,
+	.get_next_cc_cv = pse_get_next_cc_cv,
+	.get_batt_thresholds = pse_get_bat_thresholds,
+};
+static int __init pse_algo_init(void)
+{
+	power_supply_register_charging_algo(&pse_algo);
+	return 0;
+}
+
+module_init(pse_algo_init);
diff --git a/include/linux/power/power_supply_charger.h b/include/linux/power/power_supply_charger.h
index 2b59817..8f3797d 100644
--- a/include/linux/power/power_supply_charger.h
+++ b/include/linux/power/power_supply_charger.h
@@ -94,8 +94,71 @@ enum battery_events {
 
 enum psy_batt_chrg_prof_type {
 	PSY_CHRG_PROF_NONE = 0,
+	PSY_CHRG_PROF_PSE,
 };
 
+/* Product Safety Engineering (PSE) compliant charging profile */
+
+/**
+ * struct psy_ps_temp_chg_table - charging temperature zones definition
+ * @temp_up_lim: upper temperature limit for each zone in Degree Celsius
+ * @full_chrg_vol: charge voltage till battery full in mV
+ * @full_chrg_cur: charge current till battery full in mA
+ * @maint_chrg_vol_ll: voltage at which maintenance charging should start in mV
+ * @maint_chrg_vol_ul: voltage at which maintenance charging should stop in mV.
+ *	This is the charging voltage in maintenance charging mode
+ * @maint_chrg_cur: charge current in maintenance charging mode
+ *
+ * Charging temperature zone definition to decide the charging parameters on
+ * each zone. An array of the structure is used to define multiple temperature
+ * zones
+ */
+
+struct psy_ps_temp_chg_table {
+	short int temp_up_lim;
+	short int full_chrg_vol;
+	short int full_chrg_cur;
+	short int maint_chrg_vol_ll;
+	short int maint_chrg_vol_ul;
+	short int maint_chrg_cur;
+} __packed;
+
+#define BATTID_STR_LEN		8
+#define BATT_TEMP_NR_RNG	6
+
+/**
+ * struct psy_pse_chrg_prof - PSE charging profile structure
+ * @batt_id: battery identifier
+ * @battery_type: as defined in POWER_SUPPLY_TECHNOLOGY_*
+ * @capacity: battery capacity in mAh
+ * @voltage_max: maximum battery volatge in mV
+ * @chrg_term_ma: charge termination current in mA
+ * @low_batt_mv: Low battery level voltage in mV
+ * @disch_temp_ul: maximum operating temperature when battery is discharging
+ * @disch_temp_ll: lowest operating temperature when battery is discharging
+ * @temp_mon_ranges: number of temperature zones
+ * @psy_ps_temp_chg_table: temperature zone table array
+ * @temp_low_lim: minimum charging temperature
+ *
+ * PSE compliant charging profile which can be stored in battery EEPROM
+ * (if digital battery interface like MIPI BIF/SDQ supported) or in secondary
+ * storage to support analog battery (with BSI sensing support)
+ */
+
+struct psy_pse_chrg_prof {
+	char batt_id[BATTID_STR_LEN];
+	u16 battery_type;
+	u16 capacity;
+	u16 voltage_max;
+	u16 chrg_term_mA;
+	u16 low_batt_mV;
+	s8 disch_temp_ul;
+	s8 disch_temp_ll;
+	u16 temp_mon_ranges;
+	struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
+	s8 temp_low_lim;
+} __packed;
+
 /**
  * struct psy_batt_chrg_prof - power supply charging profile structure
  * @chrg_prof_type: charging profile type
-- 
1.7.9.5

