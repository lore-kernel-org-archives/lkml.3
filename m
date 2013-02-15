Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161682Ab3BOMvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:51:46 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:44405 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161479Ab3BOMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/40] ab8500-chargalg: Use hrtimer
Date: Fri, 15 Feb 2013 12:44:55 +0000
Message-Id: <1360932310-30065-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timers used for charging safety and maintenance must work even when
CPU power has collapsed. By using hrtimers with the realtime clock
the system is able to trigger an alarm that wakes-up the CPU and makes
it possible to handle events.

Allow a little slack time of 5 minutes for the hrtimers to allow CPU
to be woken-up in a more optimal power saving way. A 5 minute delay
to time-out timers relative to hours does not impact on safety.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |   91 ++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 39 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index e23b92a..55c9d2e 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) ST-Ericsson SA 2012
+ * Copyright (c) 2012 Sony Mobile Communications AB
  *
  * Charging algorithm driver for abx500 variants
  *
@@ -8,11 +9,13 @@
  *	Johan Palsson <johan.palsson@stericsson.com>
  *	Karl Komierowski <karl.komierowski@stericsson.com>
  *	Arun R Murthy <arun.murthy@stericsson.com>
+ *	Author: Imre Sunyi <imre.sunyi@sonymobile.com>
  */
 
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -24,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/notifier.h>
@@ -34,6 +38,12 @@
 /* End-of-charge criteria counter */
 #define EOC_COND_CNT			10
 
+/* One hour expressed in seconds */
+#define ONE_HOUR_IN_SECONDS            3600
+
+/* Five minutes expressed in seconds */
+#define FIVE_MINUTES_IN_SECONDS        300
+
 /* Plus margin for the low battery threshold */
 #define BAT_PLUS_MARGIN                (100)
 
@@ -244,8 +254,8 @@ struct abx500_chargalg {
 	struct delayed_work chargalg_periodic_work;
 	struct delayed_work chargalg_wd_work;
 	struct work_struct chargalg_work;
-	struct timer_list safety_timer;
-	struct timer_list maintenance_timer;
+	struct hrtimer safety_timer;
+	struct hrtimer maintenance_timer;
 	struct kobject chargalg_kobject;
 };
 
@@ -260,38 +270,47 @@ static enum power_supply_property abx500_chargalg_props[] = {
 
 /**
  * abx500_chargalg_safety_timer_expired() - Expiration of the safety timer
- * @data:	pointer to the abx500_chargalg structure
+ * @timer:     pointer to the hrtimer structure
  *
  * This function gets called when the safety timer for the charger
  * expires
  */
-static void abx500_chargalg_safety_timer_expired(unsigned long data)
+static enum hrtimer_restart
+abx500_chargalg_safety_timer_expired(struct hrtimer *timer)
 {
-	struct abx500_chargalg *di = (struct abx500_chargalg *) data;
+	struct abx500_chargalg *di = container_of(timer, struct abx500_chargalg,
+						  safety_timer);
 	dev_err(di->dev, "Safety timer expired\n");
 	di->events.safety_timer_expired = true;
 
 	/* Trigger execution of the algorithm instantly */
 	queue_work(di->chargalg_wq, &di->chargalg_work);
+
+	return HRTIMER_NORESTART;
 }
 
 /**
  * abx500_chargalg_maintenance_timer_expired() - Expiration of
  * the maintenance timer
- * @i:		pointer to the abx500_chargalg structure
+ * @timer:     pointer to the timer structure
  *
  * This function gets called when the maintenence timer
  * expires
  */
-static void abx500_chargalg_maintenance_timer_expired(unsigned long data)
+static enum hrtimer_restart
+abx500_chargalg_maintenance_timer_expired(struct hrtimer *timer)
 {
 
-	struct abx500_chargalg *di = (struct abx500_chargalg *) data;
+	struct abx500_chargalg *di = container_of(timer, struct abx500_chargalg,
+						  maintenance_timer);
+
 	dev_dbg(di->dev, "Maintenance timer expired\n");
 	di->events.maintenance_timer_expired = true;
 
 	/* Trigger execution of the algorithm instantly */
 	queue_work(di->chargalg_wq, &di->chargalg_work);
+
+	return HRTIMER_NORESTART;
 }
 
 /**
@@ -391,19 +410,16 @@ static int abx500_chargalg_check_charger_connection(struct abx500_chargalg *di)
  */
 static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
 {
-	unsigned long timer_expiration = 0;
+	/* Charger-dependent expiration time in hours*/
+	int timer_expiration = 0;
 
 	switch (di->chg_info.charger_type) {
 	case AC_CHG:
-		timer_expiration =
-		round_jiffies(jiffies +
-			(di->bm->main_safety_tmr_h * 3600 * HZ));
+		timer_expiration = di->bm->main_safety_tmr_h;
 		break;
 
 	case USB_CHG:
-		timer_expiration =
-		round_jiffies(jiffies +
-			(di->bm->usb_safety_tmr_h * 3600 * HZ));
+		timer_expiration = di->bm->usb_safety_tmr_h;
 		break;
 
 	default:
@@ -412,11 +428,10 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
 	}
 
 	di->events.safety_timer_expired = false;
-	di->safety_timer.expires = timer_expiration;
-	if (!timer_pending(&di->safety_timer))
-		add_timer(&di->safety_timer);
-	else
-		mod_timer(&di->safety_timer, timer_expiration);
+	hrtimer_set_expires_range(&di->safety_timer,
+		ktime_set(timer_expiration * ONE_HOUR_IN_SECONDS, 0),
+		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
+	hrtimer_start_expires(&di->safety_timer, HRTIMER_MODE_REL);
 }
 
 /**
@@ -427,8 +442,8 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
  */
 static void abx500_chargalg_stop_safety_timer(struct abx500_chargalg *di)
 {
-	di->events.safety_timer_expired = false;
-	del_timer(&di->safety_timer);
+	if (hrtimer_try_to_cancel(&di->safety_timer) >= 0)
+		di->events.safety_timer_expired = false;
 }
 
 /**
@@ -443,17 +458,11 @@ static void abx500_chargalg_stop_safety_timer(struct abx500_chargalg *di)
 static void abx500_chargalg_start_maintenance_timer(struct abx500_chargalg *di,
 	int duration)
 {
-	unsigned long timer_expiration;
-
-	/* Convert from hours to jiffies */
-	timer_expiration = round_jiffies(jiffies + (duration * 3600 * HZ));
-
+	hrtimer_set_expires_range(&di->maintenance_timer,
+		ktime_set(duration * ONE_HOUR_IN_SECONDS, 0),
+		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
 	di->events.maintenance_timer_expired = false;
-	di->maintenance_timer.expires = timer_expiration;
-	if (!timer_pending(&di->maintenance_timer))
-		add_timer(&di->maintenance_timer);
-	else
-		mod_timer(&di->maintenance_timer, timer_expiration);
+	hrtimer_start_expires(&di->maintenance_timer, HRTIMER_MODE_REL);
 }
 
 /**
@@ -465,8 +474,8 @@ static void abx500_chargalg_start_maintenance_timer(struct abx500_chargalg *di,
  */
 static void abx500_chargalg_stop_maintenance_timer(struct abx500_chargalg *di)
 {
-	di->events.maintenance_timer_expired = false;
-	del_timer(&di->maintenance_timer);
+	if (hrtimer_try_to_cancel(&di->maintenance_timer) >= 0)
+		di->events.maintenance_timer_expired = false;
 }
 
 /**
@@ -1937,10 +1946,16 @@ static int abx500_chargalg_remove(struct platform_device *pdev)
 	/* sysfs interface to enable/disbale charging from user space */
 	abx500_chargalg_sysfs_exit(di);
 
+	hrtimer_cancel(&di->safety_timer);
+	hrtimer_cancel(&di->maintenance_timer);
+
+	cancel_delayed_work_sync(&di->chargalg_periodic_work);
+	cancel_delayed_work_sync(&di->chargalg_wd_work);
+	cancel_work_sync(&di->chargalg_work);
+
 	/* Delete the work queue */
 	destroy_workqueue(di->chargalg_wq);
 
-	flush_scheduled_work();
 	power_supply_unregister(&di->chargalg_psy);
 	platform_set_drvdata(pdev, NULL);
 
@@ -1994,15 +2009,13 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 		abx500_chargalg_external_power_changed;
 
 	/* Initilialize safety timer */
-	init_timer(&di->safety_timer);
+	hrtimer_init(&di->safety_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	di->safety_timer.function = abx500_chargalg_safety_timer_expired;
-	di->safety_timer.data = (unsigned long) di;
 
 	/* Initilialize maintenance timer */
-	init_timer(&di->maintenance_timer);
+	hrtimer_init(&di->maintenance_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	di->maintenance_timer.function =
 		abx500_chargalg_maintenance_timer_expired;
-	di->maintenance_timer.data = (unsigned long) di;
 
 	/* Create a work queue for the chargalg */
 	di->chargalg_wq =
-- 
1.7.10.4

