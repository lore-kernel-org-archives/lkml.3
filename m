Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3BCDPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:15:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3BCDPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:15:41 -0500
Date: Sat, 2 Feb 2013 19:11:53 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Evgeny Romanov <romanov@neurosoft.ru>
Cc: linux-kernel@vger.kernel.org, Ryan Mallon <ryan@bluewatersys.com>
Subject: [PATCH] ds2782_battery: Add power_supply_changed() calls for proper
 uevent support
Message-ID: <20130203031153.GA28178@lizard.sbx00618.mountca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Romanov <romanov@neurosoft.ru>

This patch affects on Android battery indicator. Battery driver should
send uevent message when battery status changes in order to get Android
battery level dynamically updated. Delayed work was added to periodically
check battery status and capacity.

Signed-off-by: Evgeny Romanov <romanov@neurosoft.ru>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---

Sending it to the community on Evgeny's behalf.

 drivers/power/ds2782_battery.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 2fa9b6b..e7301b3 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -7,6 +7,8 @@
  *
  * DS2786 added by Yulia Vilensky <vilensky@compulab.co.il>
  *
+ * UEvent sending added by Evgeny Romanov <romanov@neurosoft.ru>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -19,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/swab.h>
 #include <linux/i2c.h>
+#include <linux/delay.h>
 #include <linux/idr.h>
 #include <linux/power_supply.h>
 #include <linux/slab.h>
@@ -40,6 +43,8 @@
 
 #define DS2786_CURRENT_UNITS	25
 
+#define DS278x_DELAY		1000
+
 struct ds278x_info;
 
 struct ds278x_battery_ops {
@@ -54,8 +59,11 @@ struct ds278x_info {
 	struct i2c_client	*client;
 	struct power_supply	battery;
 	struct ds278x_battery_ops  *ops;
+	struct delayed_work	bat_work;
 	int			id;
 	int                     rsns;
+	int			capacity;
+	int			status;		/* State Of Charge */
 };
 
 static DEFINE_IDR(battery_id);
@@ -220,6 +228,8 @@ static int ds278x_get_status(struct ds278x_info *info, int *status)
 	if (err)
 		return err;
 
+	info->capacity = capacity;
+
 	if (capacity == 100)
 		*status = POWER_SUPPLY_STATUS_FULL;
 	else if (current_uA == 0)
@@ -267,6 +277,27 @@ static int ds278x_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
+static void ds278x_bat_update(struct ds278x_info *info)
+{
+	int old_status = info->status;
+	int old_capacity = info->capacity;
+
+	ds278x_get_status(info, &info->status);
+
+	if ((old_status != info->status) || (old_capacity != info->capacity))
+		power_supply_changed(&info->battery);
+}
+
+static void ds278x_bat_work(struct work_struct *work)
+{
+	struct ds278x_info *info;
+
+	info = container_of(work, struct ds278x_info, bat_work.work);
+	ds278x_bat_update(info);
+
+	schedule_delayed_work(&info->bat_work, DS278x_DELAY);
+}
+
 static enum power_supply_property ds278x_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_CAPACITY,
@@ -295,10 +326,39 @@ static int ds278x_battery_remove(struct i2c_client *client)
 	idr_remove(&battery_id, info->id);
 	mutex_unlock(&battery_lock);
 
+	cancel_delayed_work(&info->bat_work);
+
 	kfree(info);
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int ds278x_suspend(struct i2c_client *client,
+		pm_message_t state)
+{
+	struct ds278x_info *info = i2c_get_clientdata(client);
+
+	cancel_delayed_work(&info->bat_work);
+	return 0;
+}
+
+static int ds278x_resume(struct i2c_client *client)
+{
+	struct ds278x_info *info = i2c_get_clientdata(client);
+
+	schedule_delayed_work(&info->bat_work, DS278x_DELAY);
+	return 0;
+}
+
+#else
+
+#define ds278x_suspend NULL
+#define ds278x_resume NULL
+
+#endif /* CONFIG_PM */
+
+
 enum ds278x_num_id {
 	DS2782 = 0,
 	DS2786,
@@ -368,10 +428,17 @@ static int ds278x_battery_probe(struct i2c_client *client,
 	info->ops  = &ds278x_ops[id->driver_data];
 	ds278x_power_supply_init(&info->battery);
 
+	info->capacity = 100;
+	info->status = POWER_SUPPLY_STATUS_FULL;
+
+	INIT_DELAYED_WORK(&info->bat_work, ds278x_bat_work);
+
 	ret = power_supply_register(&client->dev, &info->battery);
 	if (ret) {
 		dev_err(&client->dev, "failed to register battery\n");
 		goto fail_register;
+	} else {
+		schedule_delayed_work(&info->bat_work, DS278x_DELAY);
 	}
 
 	return 0;
@@ -401,6 +468,8 @@ static struct i2c_driver ds278x_battery_driver = {
 	},
 	.probe		= ds278x_battery_probe,
 	.remove		= ds278x_battery_remove,
+	.suspend	= ds278x_suspend,
+	.resume		= ds278x_resume,
 	.id_table	= ds278x_id,
 };
 module_i2c_driver(ds278x_battery_driver);
-- 
1.8.1.1
