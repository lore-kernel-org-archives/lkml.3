Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaFJJpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48728 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaFJJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:13 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 6/7] bq27xxx: init the cache first
Date: Tue, 10 Jun 2014 11:44:52 +0200
Message-Id: <1402393493-3559-7-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While registering the power supply the framework starts to query immediately.
This change ensures providing consistent information.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 3f3169e..0a02d86 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -124,6 +124,8 @@ struct bq27x00_device_info {
 	struct bq27x00_access_methods bus;
 
 	struct mutex lock;
+
+	bool dev_accessible; /* true when the device is accessible */
 };
 
 static enum power_supply_property bq27x00_battery_props[] = {
@@ -178,6 +180,19 @@ static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
 	return di->bus.read(di, reg, single);
 }
 
+static void bq27245_init_cache(struct bq27x00_reg_cache *cache)
+{
+	cache->temperature = cache->time_to_empty = cache->time_to_empty_avg =
+		cache->time_to_full = cache->charge_full = cache->cycle_count =
+		cache->capacity = cache->energy = cache->flags =
+		cache->power_avg = cache->health = -ENODATA;
+}
+
+static void bq27xxx_is_awake(struct bq27x00_device_info *di)
+{
+	di->dev_accessible = true;
+}
+
 /*
  * Higher versions of the chip like BQ27425 and BQ27500
  * differ from BQ27000 and BQ27200 in calculation of certain
@@ -748,17 +763,20 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	INIT_DELAYED_WORK(&di->work, bq27x00_battery_poll);
 	mutex_init(&di->lock);
 
+	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	/* expect the chip is accessible for now */
+	bq27xxx_is_awake(di);
+	/* we get queried immediately, so init our cache first */
+	bq27245_init_cache(&di->cache);
+
 	ret = power_supply_register(di->dev, &di->bat);
-	if (ret) {
+	if (ret)
 		dev_err(di->dev, "failed to register battery: %d\n", ret);
-		return ret;
-	}
-
-	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
 	bq27x00_update(di);
 
-	return 0;
+	return ret;
 }
 
 static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
-- 
2.0.0.rc2

