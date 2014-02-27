Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaB0VaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:30:04 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:41169 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaB0V37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:29:59 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, sre@ring0.de,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/3] power: twl4030-madc-battery: Convert to iio consumer.
Date: Thu, 27 Feb 2014 22:29:28 +0100
Message-Id: <1393536570-29969-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393536570-29969-1-git-send-email-marek@goldelico.com>
References: <1393536570-29969-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/power/twl4030_madc_battery.c | 74 ++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
index 7ef445a..42685df 100644
--- a/drivers/power/twl4030_madc_battery.c
+++ b/drivers/power/twl4030_madc_battery.c
@@ -19,10 +19,14 @@
 #include <linux/sort.h>
 #include <linux/i2c/twl4030-madc.h>
 #include <linux/power/twl4030_madc_battery.h>
+#include <linux/iio/consumer.h>
 
 struct twl4030_madc_battery {
 	struct power_supply psy;
 	struct twl4030_madc_bat_platform_data *pdata;
+	struct iio_channel *channel_temp;
+	struct iio_channel *channel_ichg;
+	struct iio_channel *channel_vbat;
 };
 
 static enum power_supply_property twl4030_madc_bat_props[] = {
@@ -38,43 +42,35 @@ static enum power_supply_property twl4030_madc_bat_props[] = {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 };
 
-static int madc_read(int index)
+static int madc_read(struct iio_channel *channel)
 {
-	struct twl4030_madc_request req;
-	int val;
-
-	req.channels = index;
-	req.method = TWL4030_MADC_SW2;
-	req.type = TWL4030_MADC_WAIT;
-	req.do_avg = 0;
-	req.raw = false;
-	req.func_cb = NULL;
-
-	val = twl4030_madc_conversion(&req);
-	if (val < 0)
-		return val;
-
-	return req.rbuf[ffs(index) - 1];
+	int val, err;
+	err = iio_read_channel_raw(channel, &val);
+	if (err < 0) {
+		pr_info("Error:%d\n", err);
+		return err;
+	}
+	return val;
 }
 
-static int twl4030_madc_bat_get_charging_status(void)
+static int twl4030_madc_bat_get_charging_status(struct twl4030_madc_battery *bt)
 {
-	return (madc_read(TWL4030_MADC_ICHG) > 0) ? 1 : 0;
+	return (madc_read(bt->channel_ichg) > 0) ? 1 : 0;
 }
 
-static int twl4030_madc_bat_get_voltage(void)
+static int twl4030_madc_bat_get_voltage(struct twl4030_madc_battery *bt)
 {
-	return madc_read(TWL4030_MADC_VBAT);
+	return madc_read(bt->channel_vbat);
 }
 
-static int twl4030_madc_bat_get_current(void)
+static int twl4030_madc_bat_get_current(struct twl4030_madc_battery *bt)
 {
-	return madc_read(TWL4030_MADC_ICHG) * 1000;
+	return madc_read(bt->channel_ichg) * 1000;
 }
 
-static int twl4030_madc_bat_get_temp(void)
+static int twl4030_madc_bat_get_temp(struct twl4030_madc_battery *bt)
 {
-	return madc_read(TWL4030_MADC_BTEMP) * 10;
+	return madc_read(bt->channel_temp) * 10;
 }
 
 static int twl4030_madc_bat_voltscale(struct twl4030_madc_battery *bat,
@@ -84,7 +80,7 @@ static int twl4030_madc_bat_voltscale(struct twl4030_madc_battery *bat,
 	int i, res = 0;
 
 	/* choose charging curve */
-	if (twl4030_madc_bat_get_charging_status())
+	if (twl4030_madc_bat_get_charging_status(bat))
 		calibration = bat->pdata->charging;
 	else
 		calibration = bat->pdata->discharging;
@@ -119,23 +115,23 @@ static int twl4030_madc_bat_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (twl4030_madc_bat_voltscale(bat,
-				twl4030_madc_bat_get_voltage()) > 95)
+				twl4030_madc_bat_get_voltage(bat)) > 95)
 			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else {
-			if (twl4030_madc_bat_get_charging_status())
+			if (twl4030_madc_bat_get_charging_status(bat))
 				val->intval = POWER_SUPPLY_STATUS_CHARGING;
 			else
 				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		}
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = twl4030_madc_bat_get_voltage() * 1000;
+		val->intval = twl4030_madc_bat_get_voltage(bat) * 1000;
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = twl4030_madc_bat_get_current();
+		val->intval = twl4030_madc_bat_get_current(bat);
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		/* assume battery is always present */
@@ -143,23 +139,23 @@ static int twl4030_madc_bat_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW: {
 			int percent = twl4030_madc_bat_voltscale(bat,
-					twl4030_madc_bat_get_voltage());
+					twl4030_madc_bat_get_voltage(bat));
 			val->intval = (percent * bat->pdata->capacity) / 100;
 			break;
 		}
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = twl4030_madc_bat_voltscale(bat,
-					twl4030_madc_bat_get_voltage());
+					twl4030_madc_bat_get_voltage(bat));
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 		val->intval = bat->pdata->capacity;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = twl4030_madc_bat_get_temp();
+		val->intval = twl4030_madc_bat_get_temp(bat);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW: {
 			int percent = twl4030_madc_bat_voltscale(bat,
-					twl4030_madc_bat_get_voltage());
+					twl4030_madc_bat_get_voltage(bat));
 			/* in mAh */
 			int chg = (percent * (bat->pdata->capacity/1000))/100;
 
@@ -205,6 +201,18 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 	twl4030_madc_bat->psy.get_property = twl4030_madc_bat_get_property;
 	twl4030_madc_bat->psy.external_power_changed =
 					twl4030_madc_bat_ext_changed;
+	 
+	twl4030_madc_bat->channel_temp = iio_channel_get(&pdev->dev, "temp");
+	if (IS_ERR(twl4030_madc_bat->channel_temp))
+		return PTR_ERR(twl4030_madc_bat->channel_temp);
+
+	twl4030_madc_bat->channel_ichg  = iio_channel_get(&pdev->dev, "ichg");
+	if (IS_ERR(twl4030_madc_bat->channel_ichg))
+		return PTR_ERR(twl4030_madc_bat->channel_ichg);
+
+	twl4030_madc_bat->channel_vbat = iio_channel_get(&pdev->dev, "vbat");
+	if (IS_ERR(twl4030_madc_bat->channel_vbat))
+		return PTR_ERR(twl4030_madc_bat->channel_vbat);
 
 	/* sort charging and discharging calibration data */
 	sort(pdata->charging, pdata->charging_size,
-- 
1.8.3.2

