Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3KXQtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:49:53 -0500
Received: from ring0.de ([91.143.88.219]:60789 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab3KXQtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:49:47 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH 2/3] bq2415x_charger: add DT support
Date: Sun, 24 Nov 2013 17:49:30 +0100
Message-Id: <1385311771-447-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385311771-447-1-git-send-email-sre@debian.org>
References: <1385311771-447-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds DT support to the bq2415x driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/power/bq2415x_charger.c | 72 +++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index d89583d..76a140c 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -170,6 +170,7 @@ struct bq2415x_device {
 	struct bq2415x_platform_data init_data;
 	struct power_supply charger;
 	struct delayed_work work;
+	struct power_supply *notify_psy;
 	struct notifier_block nb;
 	enum bq2415x_mode reported_mode;/* mode reported by hook function */
 	enum bq2415x_mode mode;		/* current configured mode */
@@ -806,7 +807,7 @@ static int bq2415x_notifier_call(struct notifier_block *nb,
 	if (val != PSY_EVENT_PROP_CHANGED)
 		return NOTIFY_OK;
 
-	if (strcmp(psy->name, bq->init_data.notify_device) != 0)
+	if (psy != bq->notify_psy)
 		return NOTIFY_OK;
 
 	dev_dbg(bq->dev, "notifier call was called\n");
@@ -1538,10 +1539,11 @@ static int bq2415x_probe(struct i2c_client *client,
 	int num;
 	char *name;
 	struct bq2415x_device *bq;
-	struct power_supply *psy;
+	struct device_node *np = client->dev.of_node;
+	struct bq2415x_platform_data *pdata = client->dev.platform_data;
 
-	if (!client->dev.platform_data) {
-		dev_err(&client->dev, "platform data not set\n");
+	if (!np && !pdata) {
+		dev_err(&client->dev, "platform data missing\n");
 		return -ENODEV;
 	}
 
@@ -1566,6 +1568,17 @@ static int bq2415x_probe(struct i2c_client *client,
 		goto error_2;
 	}
 
+	if (np) {
+		bq->notify_psy = power_supply_get_by_phandle(np, "ti,usb-charger-detection");
+
+		if (!bq->notify_psy)
+			return -EPROBE_DEFER;
+	}
+	else if (pdata->notify_device)
+		bq->notify_psy = power_supply_get_by_name(pdata->notify_device);
+	else
+		bq->notify_psy = NULL;
+
 	i2c_set_clientdata(client, bq);
 
 	bq->id = num;
@@ -1577,8 +1590,34 @@ static int bq2415x_probe(struct i2c_client *client,
 	bq->autotimer = 0;
 	bq->automode = 0;
 
-	memcpy(&bq->init_data, client->dev.platform_data,
-			sizeof(bq->init_data));
+	if (np) {
+		ret = of_property_read_u32(np, "ti,current-limit",
+				&bq->init_data.current_limit);
+		if (ret)
+			return ret;
+		ret = of_property_read_u32(np, "ti,weak-battery-voltage",
+				&bq->init_data.weak_battery_voltage);
+		if (ret)
+			return ret;
+		ret = of_property_read_u32(np, "ti,battery-regulation-voltage",
+				&bq->init_data.battery_regulation_voltage);
+		if (ret)
+			return ret;
+		ret = of_property_read_u32(np, "ti,charge-current",
+				&bq->init_data.charge_current);
+		if (ret)
+			return ret;
+		ret = of_property_read_u32(np, "ti,termination-current",
+				&bq->init_data.termination_current);
+		if (ret)
+			return ret;
+		ret = of_property_read_u32(np, "ti,resistor-sense",
+				&bq->init_data.resistor_sense);
+		if (ret)
+			return ret;
+	} else {
+		memcpy(&bq->init_data, pdata, sizeof(bq->init_data));
+	}
 
 	bq2415x_reset_chip(bq);
 
@@ -1600,25 +1639,18 @@ static int bq2415x_probe(struct i2c_client *client,
 		goto error_4;
 	}
 
-	if (bq->init_data.notify_device) {
+	if (bq->notify_psy) {
 		bq->nb.notifier_call = bq2415x_notifier_call;
 		ret = power_supply_reg_notifier(&bq->nb);
 		if (ret) {
 			dev_err(bq->dev, "failed to reg notifier: %d\n", ret);
 			goto error_5;
 		}
-		psy = power_supply_get_by_name(bq->init_data.notify_device);
-		if (psy) {
-			/* Query for initial reported_mode and set it */
-			bq2415x_notifier_call(&bq->nb,
-					PSY_EVENT_PROP_CHANGED, psy);
-			bq2415x_set_mode(bq, bq->reported_mode);
-		} else {
-			dev_info(bq->dev, "notifier power supply device (%s) "
-				"for automode is not registred yet... "
-				"automode will not work without that device\n",
-				bq->init_data.notify_device);
-		}
+
+		/* Query for initial reported_mode and set it */
+		bq2415x_notifier_call(&bq->nb, PSY_EVENT_PROP_CHANGED, bq->notify_psy);
+		bq2415x_set_mode(bq, bq->reported_mode);
+
 		bq->automode = 1;
 		dev_info(bq->dev, "automode enabled\n");
 	} else {
@@ -1653,7 +1685,7 @@ static int bq2415x_remove(struct i2c_client *client)
 {
 	struct bq2415x_device *bq = i2c_get_clientdata(client);
 
-	if (bq->init_data.notify_device)
+	if (bq->notify_psy)
 		power_supply_unreg_notifier(&bq->nb);
 
 	bq2415x_sysfs_exit(bq);
-- 
1.8.4.3

