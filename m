Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161438Ab3BOMzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:55:03 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61975 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161366Ab3BOMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/40] pm2301-charger: Support for over voltage protection on the ab9540
Date: Fri, 15 Feb 2013 12:44:39 +0000
Message-Id: <1360932310-30065-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

Added support for main charger over voltage protection.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
---
 drivers/power/pm2301_charger.c |   50 +++++++++++++++++++++++++++++-----------
 drivers/power/pm2301_charger.h |    1 +
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 62a172e..2b7c93d 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -227,21 +227,14 @@ int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
 
 static int pm2xxx_charger_ovv_mngt(struct pm2xxx_charger *pm2, int val)
 {
-	int ret = 0;
+	dev_err(pm2->dev, "Overvoltage detected\n");
+	pm2->flags.ovv = true;
+	power_supply_changed(&pm2->ac_chg.psy);
 
-	pm2->failure_input_ovv++;
-	if (pm2->failure_input_ovv < 4) {
-		ret = pm2xxx_charging_enable_mngt(pm2);
-		goto out;
-	} else {
-		pm2->failure_input_ovv = 0;
-		dev_err(pm2->dev, "Overvoltage detected\n");
-		pm2->flags.ovv = true;
-		power_supply_changed(&pm2->ac_chg.psy);
-	}
+	/* Schedule a new HW failure check */
+	queue_delayed_work(pm2->charger_wq, &pm2->check_hw_failure_work, 0);
 
-out:
-	return ret;
+	return 0;
 }
 
 static int pm2xxx_charger_wd_exp_mngt(struct pm2xxx_charger *pm2, int val)
@@ -630,6 +623,8 @@ static int pm2xxx_charger_ac_get_property(struct power_supply *psy,
 			val->intval = POWER_SUPPLY_HEALTH_DEAD;
 		else if (pm2->flags.main_thermal_prot)
 			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else if (pm2->flags.ovv)
+			val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		else
 			val->intval = POWER_SUPPLY_HEALTH_GOOD;
 		break;
@@ -860,6 +855,30 @@ static void pm2xxx_charger_ac_work(struct work_struct *work)
 	sysfs_notify(&pm2->ac_chg.psy.dev->kobj, NULL, "present");
 };
 
+static void pm2xxx_charger_check_hw_failure_work(struct work_struct *work)
+{
+	u8 reg_value;
+
+	struct pm2xxx_charger *pm2 = container_of(work,
+		struct pm2xxx_charger, check_hw_failure_work.work);
+
+	if (pm2->flags.ovv) {
+		pm2xxx_reg_read(pm2, PM2XXX_SRCE_REG_INT4, &reg_value);
+
+		if (!(reg_value & (PM2XXX_INT4_S_ITVPWR1OVV |
+					PM2XXX_INT4_S_ITVPWR2OVV))) {
+			pm2->flags.ovv = false;
+			power_supply_changed(&pm2->ac_chg.psy);
+		}
+	}
+
+	/* If we still have a failure, schedule a new check */
+	if (pm2->flags.ovv) {
+		queue_delayed_work(pm2->charger_wq,
+			&pm2->check_hw_failure_work, round_jiffies(HZ));
+	}
+}
+
 static void pm2xxx_charger_check_main_thermal_prot_work(
 	struct work_struct *work)
 {
@@ -983,6 +1002,10 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	INIT_WORK(&pm2->check_main_thermal_prot_work,
 		pm2xxx_charger_check_main_thermal_prot_work);
 
+	/* Init work for HW failure check */
+	INIT_DEFERRABLE_WORK(&pm2->check_hw_failure_work,
+		pm2xxx_charger_check_hw_failure_work);
+
 	/*
 	 * VDD ADC supply needs to be enabled from this driver when there
 	 * is a charger connected to avoid erroneous BTEMP_HIGH/LOW
@@ -1123,4 +1146,3 @@ MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Rajkumar kasirajan, Olivier Launay");
 MODULE_ALIAS("platform:pm2xxx-charger");
 MODULE_DESCRIPTION("PM2xxx charger management driver");
-
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
index e6319cd..fad1f38 100644
--- a/drivers/power/pm2301_charger.h
+++ b/drivers/power/pm2301_charger.h
@@ -506,6 +506,7 @@ struct pm2xxx_charger {
 	struct delayed_work check_vbat_work;
 	struct work_struct ac_work;
 	struct work_struct check_main_thermal_prot_work;
+	struct delayed_work check_hw_failure_work;
 	struct ux500_charger ac_chg;
 	struct pm2xxx_charger_event_flags flags;
 };
-- 
1.7.10.4

