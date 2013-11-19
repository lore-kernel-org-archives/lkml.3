Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3KSKWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:22:16 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:44839 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3KSKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:22:10 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Tue, 19 Nov 2013 11:18:04 +0100
Message-Id: <1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removing set_mode_hook function from board data and replacing it with
new string variable of notifier power supply device. After this change it is
possible to add DT support because driver does not need specific board function
anymore. Only static data and name of power supply device is required.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq2415x_charger.c       |   77 +++++++++++++++++++++++++--------
 include/linux/power/bq2415x_charger.h |   48 +++-----------------
 2 files changed, 65 insertions(+), 60 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..d89583d 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1,7 +1,7 @@
 /*
  * bq2415x charger driver
  *
- * Copyright (C) 2011-2012  Pali Rohár <pali.rohar@gmail.com>
+ * Copyright (C) 2011-2013  Pali Rohár <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -170,6 +170,7 @@ struct bq2415x_device {
 	struct bq2415x_platform_data init_data;
 	struct power_supply charger;
 	struct delayed_work work;
+	struct notifier_block nb;
 	enum bq2415x_mode reported_mode;/* mode reported by hook function */
 	enum bq2415x_mode mode;		/* current configured mode */
 	enum bq2415x_chip chip;
@@ -791,24 +792,53 @@ static int bq2415x_set_mode(struct bq2415x_device *bq, enum bq2415x_mode mode)
 
 }
 
-/* hook function called by other driver which set reported mode */
-static void bq2415x_hook_function(enum bq2415x_mode mode, void *data)
+static int bq2415x_notifier_call(struct notifier_block *nb,
+		unsigned long val, void *v)
 {
-	struct bq2415x_device *bq = data;
+	struct bq2415x_device *bq =
+		container_of(nb, struct bq2415x_device, nb);
+	struct power_supply *psy = v;
+	enum bq2415x_mode mode;
+	union power_supply_propval prop;
+	int ret;
+	int mA;
 
-	if (!bq)
-		return;
+	if (val != PSY_EVENT_PROP_CHANGED)
+		return NOTIFY_OK;
+
+	if (strcmp(psy->name, bq->init_data.notify_device) != 0)
+		return NOTIFY_OK;
+
+	dev_dbg(bq->dev, "notifier call was called\n");
+
+	ret = psy->get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX, &prop);
+	if (ret != 0)
+		return NOTIFY_OK;
+
+	mA = prop.intval;
+
+	if (mA == 0)
+		mode = BQ2415X_MODE_OFF;
+	else if (mA < 500)
+		mode = BQ2415X_MODE_NONE;
+	else if (mA < 1800)
+		mode = BQ2415X_MODE_HOST_CHARGER;
+	else
+		mode = BQ2415X_MODE_DEDICATED_CHARGER;
+
+	if (bq->reported_mode == mode)
+		return NOTIFY_OK;
 
-	dev_dbg(bq->dev, "hook function was called\n");
 	bq->reported_mode = mode;
 
 	/* if automode is not enabled do not tell about reported_mode */
 	if (bq->automode < 1)
-		return;
+		return NOTIFY_OK;
 
 	sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
 	bq2415x_set_mode(bq, bq->reported_mode);
 
+	return NOTIFY_OK;
 }
 
 /**** timer functions ****/
@@ -1508,6 +1538,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	int num;
 	char *name;
 	struct bq2415x_device *bq;
+	struct power_supply *psy;
 
 	if (!client->dev.platform_data) {
 		dev_err(&client->dev, "platform data not set\n");
@@ -1569,16 +1600,27 @@ static int bq2415x_probe(struct i2c_client *client,
 		goto error_4;
 	}
 
-	if (bq->init_data.set_mode_hook) {
-		if (bq->init_data.set_mode_hook(
-				bq2415x_hook_function, bq)) {
-			bq->automode = 1;
+	if (bq->init_data.notify_device) {
+		bq->nb.notifier_call = bq2415x_notifier_call;
+		ret = power_supply_reg_notifier(&bq->nb);
+		if (ret) {
+			dev_err(bq->dev, "failed to reg notifier: %d\n", ret);
+			goto error_5;
+		}
+		psy = power_supply_get_by_name(bq->init_data.notify_device);
+		if (psy) {
+			/* Query for initial reported_mode and set it */
+			bq2415x_notifier_call(&bq->nb,
+					PSY_EVENT_PROP_CHANGED, psy);
 			bq2415x_set_mode(bq, bq->reported_mode);
-			dev_info(bq->dev, "automode enabled\n");
 		} else {
-			bq->automode = -1;
-			dev_info(bq->dev, "automode failed\n");
+			dev_info(bq->dev, "notifier power supply device (%s) "
+				"for automode is not registred yet... "
+				"automode will not work without that device\n",
+				bq->init_data.notify_device);
 		}
+		bq->automode = 1;
+		dev_info(bq->dev, "automode enabled\n");
 	} else {
 		bq->automode = -1;
 		dev_info(bq->dev, "automode not supported\n");
@@ -1590,6 +1632,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	dev_info(bq->dev, "driver registered\n");
 	return 0;
 
+error_5:
 error_4:
 	bq2415x_sysfs_exit(bq);
 error_3:
@@ -1610,8 +1653,8 @@ static int bq2415x_remove(struct i2c_client *client)
 {
 	struct bq2415x_device *bq = i2c_get_clientdata(client);
 
-	if (bq->init_data.set_mode_hook)
-		bq->init_data.set_mode_hook(NULL, NULL);
+	if (bq->init_data.notify_device)
+		power_supply_unreg_notifier(&bq->nb);
 
 	bq2415x_sysfs_exit(bq);
 	bq2415x_power_supply_exit(bq);
diff --git a/include/linux/power/bq2415x_charger.h b/include/linux/power/bq2415x_charger.h
index 8dcc0f4..50762af 100644
--- a/include/linux/power/bq2415x_charger.h
+++ b/include/linux/power/bq2415x_charger.h
@@ -1,7 +1,7 @@
 /*
  * bq2415x charger driver
  *
- * Copyright (C) 2011-2012  Pali Rohár <pali.rohar@gmail.com>
+ * Copyright (C) 2011-2013  Pali Rohár <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,46 +31,9 @@
  * termination current. It it is less or equal to zero, configuring charge
  * and termination current will not be possible.
  *
- * Function set_mode_hook is needed for automode (setting correct current
- * limit when charger is connected/disconnected or setting boost mode).
- * When is NULL, automode function is disabled. When is not NULL, it must
- * have this prototype:
- *
- *    int (*set_mode_hook)(
- *      void (*hook)(enum bq2415x_mode mode, void *data),
- *      void *data)
- *
- * hook is hook function (see below) and data is pointer to driver private
- * data
- *
- * bq2415x driver will call it as:
- *
- *    platform_data->set_mode_hook(bq2415x_hook_function, bq2415x_device);
- *
- * Board/platform function set_mode_hook return non zero value when hook
- * function was successful registered. Platform code should call that hook
- * function (which get from pointer, with data) every time when charger
- * was connected/disconnected or require to enable boost mode. bq2415x
- * driver then will set correct current limit, enable/disable charger or
- * boost mode.
- *
- * Hook function has this prototype:
- *
- *    void hook(enum bq2415x_mode mode, void *data);
- *
- * mode is bq2415x mode (charger or boost)
- * data is pointer to driver private data (which get from
- * set_charger_type_hook)
- *
- * When bq driver is being unloaded, it call function:
- *
- *    platform_data->set_mode_hook(NULL, NULL);
- *
- * (hook function and driver private data are NULL)
- *
- * After that board/platform code must not call driver hook function! It
- * is possible that pointer to hook function will not be valid and calling
- * will cause undefined result.
+ * For automode support is needed to provide name of power supply device
+ * in value notify_device. Device driver must immediately report property
+ * POWER_SUPPLY_PROP_CURRENT_MAX when current changed.
  */
 
 /* Supported modes with maximal current limit */
@@ -89,8 +52,7 @@ struct bq2415x_platform_data {
 	int charge_current;		/* mA */
 	int termination_current;	/* mA */
 	int resistor_sense;		/* m ohm */
-	int (*set_mode_hook)(void (*hook)(enum bq2415x_mode mode, void *data),
-			     void *data);
+	const char *notify_device;	/* name */
 };
 
 #endif
-- 
1.7.9.5

