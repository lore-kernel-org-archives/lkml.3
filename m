Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3EIRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:09:57 -0400
Received: from nm2-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.66]:42213
	"EHLO nm2-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab3EIRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:09:49 -0400
X-Yahoo-Newman-Id: 747347.32620.bm@smtp104.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OXjcI0wVM1mmlK.S4MNVjoENy4K43TS.rkpSUGkDDZ_8QlR
 VZBg1Lo49Y7t3X2Y1j547R6qNBmb.Mxq.Z78Fe4D9Ew649Xr.EyUN_0CR1CE
 gQd10oUg9YNaiHBxeE9fr0UPFEo3mLSWXDrq57y1.2vFnqzvrbmrmMkJXJk0
 un0KEWwKHtPGJiCGxfTS1qFgJ.ENSKiugknBfxLee7l.hHs56z9rtvu6CCPY
 DW.VZfAxe1CYhC8GrES4vPpPlHvSHyfBppl.BUjNfyGVuC03q1zO6oXNH7bz
 kD_rWdnmEteiexj.rIDnZ9ALB984HBf9yQt4mC8oPZyguNZb8sh9.O1OYxUi
 ytMCL5QTKsMUzpArlkLkmTUJ3vACk261iukMxfu.SyKvUi0LJz.Eyh8IurhG
 mfGn_aqwTAF3Ilo3Tz9hqFUuTWnlNBzqFOfoXss_fE9y2_C88ocu0dw1lbP9
 0BIfZ7t1Vn9SbPtxWHL.FnJ.rTRbPRiCuzUyEwH13pSYx7Q9Z9aGGTg--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.ne1.yahoo.com with SMTP; 09 May 2013 17:09:48 +0000 UTC
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/3] hwmon: (max6639) Convert to use __pm instead of #ifdef CONFIG_PM_SLEEP
Date: Thu,  9 May 2013 10:09:51 -0700
Message-Id: <1368119391-13837-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
References: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drops #ifdef from code, and ensures that conditional code still compiles
if power management is disabled. Resulting code is dropped from object file.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max6639.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index 3e7b426..6080913 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -591,8 +591,7 @@ static int max6639_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int max6639_suspend(struct device *dev)
+static int __pm max6639_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int data = i2c_smbus_read_byte_data(client, MAX6639_REG_GCONFIG);
@@ -603,7 +602,7 @@ static int max6639_suspend(struct device *dev)
 			MAX6639_REG_GCONFIG, data | MAX6639_GCONFIG_STANDBY);
 }
 
-static int max6639_resume(struct device *dev)
+static int __pm max6639_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int data = i2c_smbus_read_byte_data(client, MAX6639_REG_GCONFIG);
@@ -613,7 +612,6 @@ static int max6639_resume(struct device *dev)
 	return i2c_smbus_write_byte_data(client,
 			MAX6639_REG_GCONFIG, data & ~MAX6639_GCONFIG_STANDBY);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id max6639_id[] = {
 	{"max6639", 0},
@@ -622,15 +620,16 @@ static const struct i2c_device_id max6639_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, max6639_id);
 
-static const struct dev_pm_ops max6639_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(max6639_suspend, max6639_resume)
+static const struct dev_pm_ops __pm max6639_pm_ops = {
+	.suspend = max6639_suspend,
+	.resume = max6639_resume,
 };
 
 static struct i2c_driver max6639_driver = {
 	.class = I2C_CLASS_HWMON,
 	.driver = {
 		   .name = "max6639",
-		   .pm = &max6639_pm_ops,
+		   .pm = pm_ops_ptr(&max6639_pm_ops),
 		   },
 	.probe = max6639_probe,
 	.remove = max6639_remove,
-- 
1.7.9.7

