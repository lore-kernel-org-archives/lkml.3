Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaAVJ2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:28:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:13950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaAVJ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:27:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="468912117"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Date: Wed, 22 Jan 2014 22:49:53 +0530
Message-Id: <1390411194-21410-4-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
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
 drivers/power/Kconfig                      |   12 ++
 drivers/power/Makefile                     |    1 +
 drivers/power/charging_algo_pse.c          |  198 ++++++++++++++++++++++++++++
 include/linux/power/power_supply_charger.h |   44 +++++++
 4 files changed, 255 insertions(+)
 create mode 100644 drivers/power/charging_algo_pse.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7bfad7a..655457b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -22,6 +22,18 @@ config POWER_SUPPLY_CHARGER
 	  drivers to keep the charging logic outside and the charger driver
 	  just need to abstract the charger hardware
 
+config POWER_SUPPLY_CHARGING_ALGO_PSE
+	bool "PSE compliant charging algorithm"
+	help
+	  Say Y here to select PSE compliant charging algorithm. As per PSE
+	  standard the battery characteristics and thereby the charging rates
+	  can vary on different temperature zones. This config will enable PSE
+	  compliant charging algorithm with maintenance charging support. The
+	  algorithm can be selected by the charging framework based on the type
+	  of the battery charging profile.
+
+	depends on POWER_SUPPLY_CHARGER
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
index 0000000..41c24c3
--- /dev/null
+++ b/drivers/power/charging_algo_pse.c
@@ -0,0 +1,198 @@
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
+/* Offset to exit from maintenance charging. In maintenance charging
+*  if the volatge is less than the (maintenance_lower_threshold -
+*  MAINT_EXIT_OFFSET) then system can switch to normal charging
+*/
+#define MAINT_EXIT_OFFSET 50  /* mv */
+
+static int get_tempzone(struct psy_ps_pse_mod_prof *pse_mod_bprof,
+		int temp)
+{
+
+	int i = 0;
+	int temp_range_cnt = min_t(u16, pse_mod_bprof->temp_mon_ranges,
+					BATT_TEMP_NR_RNG);
+
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
+static inline bool __is_battery_full
+	(long volt, long cur, long iterm, unsigned long cv)
+{
+	pr_devel("%s:current=%ld pse_mod_bprof->chrg_term_ma =%ld voltage_now=%ld full_cond=%ld",
+			__func__, cur, iterm, volt * 100, (FULL_CV_MIN * cv));
+
+	return (cur > 0) && (cur <= iterm) &&
+	((volt * 100)  >= (FULL_CV_MIN * cv));
+
+}
+
+static inline bool is_battery_full(struct psy_batt_props bat_prop,
+		struct psy_ps_pse_mod_prof *pse_mod_bprof, unsigned long cv)
+{
+
+	int i;
+	/* Software full detection. Check the battery charge current to detect
+	*  battery Full. The voltage also verified to avoid false charge
+	*  full detection.
+	*/
+	pr_devel("%s:current=%ld pse_mod_bprof->chrg_term_ma =%d bat_prop.voltage_now=%ld full_cond=%ld",
+		__func__, bat_prop.current_now, (pse_mod_bprof->chrg_term_ma),
+		bat_prop.voltage_now * 100, (FULL_CV_MIN * cv));
+
+	for (i = (MAX_CUR_VOLT_SAMPLES - 1); i >= 0; --i) {
+
+		if (!(__is_battery_full(bat_prop.voltage_now_cache[i],
+				bat_prop.current_now_cache[i],
+				pse_mod_bprof->chrg_term_ma, cv)))
+			return false;
+	}
+
+	return true;
+}
+
+static int  pse_get_bat_thresholds(struct psy_ps_batt_chg_prof  bprof,
+			struct psy_batt_thresholds *bat_thresh)
+{
+	struct psy_ps_pse_mod_prof *pse_mod_bprof =
+			(struct psy_ps_pse_mod_prof *) bprof.batt_prof;
+
+	if ((bprof.chrg_prof_type != PSY_CHRG_PROF_PSE) || (!pse_mod_bprof))
+		return -EINVAL;
+
+	bat_thresh->iterm = pse_mod_bprof->chrg_term_ma;
+	bat_thresh->temp_min = pse_mod_bprof->temp_low_lim;
+	bat_thresh->temp_max = pse_mod_bprof->temp_mon_range[0].temp_up_lim;
+
+	return 0;
+}
+
+static enum psy_algo_stat pse_get_next_cc_cv(struct psy_batt_props bat_prop,
+	struct psy_ps_batt_chg_prof  bprof,
+			unsigned long *cc, unsigned long *cv)
+{
+	int tzone;
+	struct psy_ps_pse_mod_prof *pse_mod_bprof =
+			(struct psy_ps_pse_mod_prof *) bprof.batt_prof;
+	enum psy_algo_stat algo_stat = bat_prop.algo_stat;
+	int maint_exit_volt;
+
+	*cc = *cv = 0;
+
+	/* If STATUS is discharging, assume that charger is not connected.
+	*  If charger is not connected, no need to take any action.
+	*  If charge profile type is not PSY_CHRG_PROF_PSE or the charge profile
+	*  is not present, no need to take any action.
+	*/
+
+	pr_devel("%s:battery status = %ld algo_status=%d\n",
+			__func__, bat_prop.status, algo_stat);
+
+	if ((bprof.chrg_prof_type != PSY_CHRG_PROF_PSE) || (!pse_mod_bprof))
+		return PSY_ALGO_STAT_NOT_CHARGE;
+
+	tzone = get_tempzone(pse_mod_bprof, bat_prop.temperature);
+
+	if (tzone < 0)
+		return PSY_ALGO_STAT_NOT_CHARGE;
+
+	/* Change the algo status to not charging, if battery is
+	*  not really charging or less than maintenance exit threshold.
+	*  This way algorithm can switch to normal
+	*  charging if current status is full/maintenace
+	*/
+	maint_exit_volt = pse_mod_bprof->
+			temp_mon_range[tzone].maint_chrg_vol_ll -
+				MAINT_EXIT_OFFSET;
+
+	if ((bat_prop.status == POWER_SUPPLY_STATUS_DISCHARGING) ||
+		(bat_prop.status == POWER_SUPPLY_STATUS_NOT_CHARGING) ||
+			bat_prop.voltage_now < maint_exit_volt) {
+
+		algo_stat = PSY_ALGO_STAT_NOT_CHARGE;
+
+	}
+
+	/* read cc and cv based on temperature and algorithm status*/
+	if (algo_stat == PSY_ALGO_STAT_FULL ||
+			algo_stat == PSY_ALGO_STAT_MAINT) {
+
+		/* if status is full and voltage is lower than maintenance lower
+		*  threshold change status to maintenenance
+		*/
+
+		if (algo_stat == PSY_ALGO_STAT_FULL && (bat_prop.voltage_now <=
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
+	if (is_battery_full(bat_prop, pse_mod_bprof, *cv)) {
+		*cc = *cv = 0;
+		algo_stat = PSY_ALGO_STAT_FULL;
+	}
+
+	return algo_stat;
+}
+
+static int __init pse_algo_init(void)
+{
+	struct psy_charging_algo pse_algo;
+	pse_algo.chrg_prof_type = PSY_CHRG_PROF_PSE;
+	pse_algo.name = "pse_algo";
+	pse_algo.get_next_cc_cv = pse_get_next_cc_cv;
+	pse_algo.get_batt_thresholds = pse_get_bat_thresholds;
+	power_supply_register_charging_algo(&pse_algo);
+	return 0;
+}
+
+module_init(pse_algo_init);
diff --git a/include/linux/power/power_supply_charger.h b/include/linux/power/power_supply_charger.h
index e871898..712a65b 100644
--- a/include/linux/power/power_supply_charger.h
+++ b/include/linux/power/power_supply_charger.h
@@ -78,8 +78,52 @@ enum {
 
 enum psy_batt_chrg_prof_type {
 	PSY_CHRG_PROF_NONE = 0,
+	PSY_CHRG_PROF_PSE,
 };
 
+/* PSE Modified Algo Structure */
+/* Parameters defining the charging range */
+struct psy_ps_temp_chg_table {
+	/* upper temperature limit for each zone */
+	short int temp_up_lim;
+	/* charge current and voltage */
+	short int full_chrg_vol;
+	short int full_chrg_cur;
+	/* maintenance thresholds */
+	/* maintenance lower threshold. Once battery hits full, charging
+	*  charging will be resumed when battery voltage <= this voltage
+	*/
+	short int maint_chrg_vol_ll;
+	/* Charge current and voltage in maintenance mode */
+	short int maint_chrg_vol_ul;
+	short int maint_chrg_cur;
+} __packed;
+
+
+#define BATTID_STR_LEN		8
+#define BATT_TEMP_NR_RNG	6
+/* Charging Profile */
+struct psy_ps_pse_mod_prof {
+	/* battery id */
+	char batt_id[BATTID_STR_LEN];
+	/* type of battery */
+	u16 battery_type;
+	u16 capacity;
+	u16 voltage_max;
+	/* charge termination current */
+	u16 chrg_term_ma;
+	/* Low battery level voltage */
+	u16 low_batt_mv;
+	/* upper and lower temperature limits on discharging */
+	u8 disch_tmp_ul;
+	u8 disch_tmp_ll;
+	/* number of temperature monitoring ranges */
+	u16 temp_mon_ranges;
+	struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
+	/* Lowest temperature supported */
+	short int temp_low_lim;
+} __packed;
+
 /* charging profile structure definition */
 struct psy_ps_batt_chg_prof {
 	enum psy_batt_chrg_prof_type chrg_prof_type;
-- 
1.7.9.5

