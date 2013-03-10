Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3CJNci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:32:38 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1041 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3CJNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:32:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5425
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Evgeny Romanov <romanov@neurosoft.ru>
Subject: [PATCH 1/5] power: ds2782_battery: Use dev_pm_ops
Date: Sun, 10 Mar 2013 14:34:05 +0100
Message-Id: <1362922449-27531-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Cc: Evgeny Romanov <romanov@neurosoft.ru>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/ds2782_battery.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index e7301b3..4fdf700 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -332,31 +332,32 @@ static int ds278x_battery_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int ds278x_suspend(struct i2c_client *client,
-		pm_message_t state)
+static int ds278x_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct ds278x_info *info = i2c_get_clientdata(client);
 
 	cancel_delayed_work(&info->bat_work);
 	return 0;
 }
 
-static int ds278x_resume(struct i2c_client *client)
+static int ds278x_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct ds278x_info *info = i2c_get_clientdata(client);
 
 	schedule_delayed_work(&info->bat_work, DS278x_DELAY);
 	return 0;
 }
 
-#else
-
-#define ds278x_suspend NULL
-#define ds278x_resume NULL
+static SIMPLE_DEV_PM_OPS(ds278x_battery_pm_ops, ds278x_suspend, ds278x_resume);
+#define DS278X_BATTERY_PM_OPS (&ds278x_battery_pm_ops)
 
-#endif /* CONFIG_PM */
+#else
+#define DS278X_BATTERY_PM_OPS NULL
+#endif /* CONFIG_PM_SLEEP */
 
 
 enum ds278x_num_id {
@@ -465,11 +466,10 @@ MODULE_DEVICE_TABLE(i2c, ds278x_id);
 static struct i2c_driver ds278x_battery_driver = {
 	.driver 	= {
 		.name	= "ds2782-battery",
+		.pm	= DS278X_BATERY_PM_OPS,
 	},
 	.probe		= ds278x_battery_probe,
 	.remove		= ds278x_battery_remove,
-	.suspend	= ds278x_suspend,
-	.resume		= ds278x_resume,
 	.id_table	= ds278x_id,
 };
 module_i2c_driver(ds278x_battery_driver);
-- 
1.8.0

