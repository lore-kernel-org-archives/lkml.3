Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbaCEUws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:52:48 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63090 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbaCEUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:52:43 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: hns@goldelico.com, sre@debian.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
Date: Wed,  5 Mar 2014 21:52:17 +0100
Message-Id: <1394052739-8589-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394052739-8589-1-git-send-email-marek@goldelico.com>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of added iio error handling private data allocation was converted
to managed to simplify code.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/power/twl4030_madc_battery.c | 102 ++++++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 36 deletions(-)

diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
index 7ef445a..0a64105 100644
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
+	err = iio_read_channel_processed(channel, &val);
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
 
@@ -192,8 +188,10 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 {
 	struct twl4030_madc_battery *twl4030_madc_bat;
 	struct twl4030_madc_bat_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
 
-	twl4030_madc_bat = kzalloc(sizeof(*twl4030_madc_bat), GFP_KERNEL);
+	twl4030_madc_bat = devm_kzalloc(&pdev->dev, sizeof(*twl4030_madc_bat),
+				GFP_KERNEL);
 	if (!twl4030_madc_bat)
 		return -ENOMEM;
 
@@ -206,6 +204,24 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 	twl4030_madc_bat->psy.external_power_changed =
 					twl4030_madc_bat_ext_changed;
 
+	twl4030_madc_bat->channel_temp = iio_channel_get(&pdev->dev, "temp");
+	if (IS_ERR(twl4030_madc_bat->channel_temp)) {
+		ret = PTR_ERR(twl4030_madc_bat->channel_temp);
+		goto err;
+	}
+
+	twl4030_madc_bat->channel_ichg  = iio_channel_get(&pdev->dev, "ichg");
+	if (IS_ERR(twl4030_madc_bat->channel_ichg)) {
+		ret = PTR_ERR(twl4030_madc_bat->channel_ichg);
+		goto err_temp;
+	}
+
+	twl4030_madc_bat->channel_vbat = iio_channel_get(&pdev->dev, "vbat");
+	if (IS_ERR(twl4030_madc_bat->channel_vbat)) {
+		ret = PTR_ERR(twl4030_madc_bat->channel_vbat);
+		goto err_ichg;
+	}
+
 	/* sort charging and discharging calibration data */
 	sort(pdata->charging, pdata->charging_size,
 		sizeof(struct twl4030_madc_bat_calibration),
@@ -216,9 +232,20 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 
 	twl4030_madc_bat->pdata = pdata;
 	platform_set_drvdata(pdev, twl4030_madc_bat);
-	power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
+	ret = power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
+	if (ret)
+		goto err_vbat;
 
 	return 0;
+
+err_vbat:
+	iio_channel_release(twl4030_madc_bat->channel_vbat);
+err_ichg:
+	iio_channel_release(twl4030_madc_bat->channel_ichg);
+err_temp:
+	iio_channel_release(twl4030_madc_bat->channel_temp);
+err:
+	return ret;
 }
 
 static int twl4030_madc_battery_remove(struct platform_device *pdev)
@@ -226,7 +253,10 @@ static int twl4030_madc_battery_remove(struct platform_device *pdev)
 	struct twl4030_madc_battery *bat = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&bat->psy);
-	kfree(bat);
+
+	iio_channel_release(bat->channel_vbat);
+	iio_channel_release(bat->channel_ichg);
+	iio_channel_release(bat->channel_temp);
 
 	return 0;
 }
-- 
1.8.3.2

