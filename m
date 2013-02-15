Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909Ab3BOMyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:54:12 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39909 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161404Ab3BOMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/40] ab8500-btemp: Filter btemp readings
Date: Fri, 15 Feb 2013 12:44:46 +0000
Message-Id: <1360932310-30065-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Battery tempreature readings sometimes fail and results in
a value far from recent values. This patch adds a software
filter that disposes such readings, by allowing direct
updates on temperature only if two samples result in the
same temperature. Else only allow 1 degree change from previous
reported value in the direction of the new measurement.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/power/ab8500_btemp.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 0768906..fa60e3a 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -76,8 +76,8 @@ struct ab8500_btemp_ranges {
  * @dev:		Pointer to the structure device
  * @node:		List of AB8500 BTEMPs, hence prepared for reentrance
  * @curr_source:	What current source we use, in uA
- * @bat_temp:		Battery temperature in degree Celcius
- * @prev_bat_temp	Last dispatched battery temperature
+ * @bat_temp:		Dispatched battery temperature in degree Celcius
+ * @prev_bat_temp	Last measured battery temperature in degree Celcius
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @fg:			Pointer to the struct fg
@@ -604,6 +604,7 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 static void ab8500_btemp_periodic_work(struct work_struct *work)
 {
 	int interval;
+	int bat_temp;
 	struct ab8500_btemp *di = container_of(work,
 		struct ab8500_btemp, btemp_periodic_work.work);
 
@@ -614,12 +615,26 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 			dev_warn(di->dev, "failed to identify the battery\n");
 	}
 
-	di->bat_temp = ab8500_btemp_measure_temp(di);
-
-	if (di->bat_temp != di->prev_bat_temp) {
-		di->prev_bat_temp = di->bat_temp;
+	bat_temp = ab8500_btemp_measure_temp(di);
+	/*
+	 * Filter battery temperature.
+	 * Allow direct updates on temperature only if two samples result in
+	 * same temperature. Else only allow 1 degree change from previous
+	 * reported value in the direction of the new measurement.
+	 */
+	if (bat_temp == di->prev_bat_temp || !di->initialized) {
+		if (di->bat_temp != di->prev_bat_temp || !di->initialized) {
+			di->bat_temp = bat_temp;
+			power_supply_changed(&di->btemp_psy);
+		}
+	} else if (bat_temp < di->prev_bat_temp) {
+		di->bat_temp--;
+		power_supply_changed(&di->btemp_psy);
+	} else if (bat_temp > di->prev_bat_temp) {
+		di->bat_temp++;
 		power_supply_changed(&di->btemp_psy);
 	}
+	di->prev_bat_temp = bat_temp;
 
 	if (di->events.ac_conn || di->events.usb_conn)
 		interval = di->bm->temp_interval_chg;
-- 
1.7.10.4

