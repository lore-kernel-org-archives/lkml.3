Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3DMLVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 07:21:15 -0400
Received: from smtp-out-233.synserver.de ([212.40.185.233]:1048 "EHLO
	smtp-out-233.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3DMLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 07:21:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24003
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] pm2301-charger: Fix suspend/resume
Date: Sat, 13 Apr 2013 13:20:07 +0200
Message-Id: <1365852007-23369-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm2301-charger driver implements runtime pm and at the same time uses the
legacy pm callbacks for suspend and resume. This does not work since the I2C
core wont look at the legacy pm callbacks if a driver has the 'pm' field set.
This patch fixes it by moving over to dev_pm_ops for suspend/resume as well.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/pm2301_charger.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 618c46d..f123f3c 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -26,6 +26,7 @@
 #include <linux/pm2301_charger.h>
 #include <linux/gpio.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm.h>
 
 #include "pm2301_charger.h"
 
@@ -906,8 +907,13 @@ static struct pm2xxx_irq pm2xxx_charger_irq[] = {
 	{"PM2XXX_IRQ_INT", pm2xxx_irq_int},
 };
 
-static int pm2xxx_wall_charger_resume(struct i2c_client *i2c_client)
+#ifdef CONFIG_PM
+
+#ifdef CONFIG_PM_SLEEP
+
+static int pm2xxx_wall_charger_resume(struct device *dev)
 {
+	struct i2c_client *i2c_client = to_i2c_client(dev);
 	struct pm2xxx_charger *pm2;
 
 	pm2 =  (struct pm2xxx_charger *)i2c_get_clientdata(i2c_client);
@@ -921,9 +927,9 @@ static int pm2xxx_wall_charger_resume(struct i2c_client *i2c_client)
 	return 0;
 }
 
-static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
-	pm_message_t state)
+static int pm2xxx_wall_charger_suspend(struct device *dev)
 {
+	struct i2c_client *i2c_client = to_i2c_client(dev);
 	struct pm2xxx_charger *pm2;
 
 	pm2 =  (struct pm2xxx_charger *)i2c_get_clientdata(i2c_client);
@@ -939,7 +945,10 @@ static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+
 static int  pm2xxx_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *pm2xxx_i2c_client = to_i2c_client(dev);
@@ -977,9 +986,12 @@ static int  pm2xxx_runtime_resume(struct device *dev)
 	return ret;
 }
 
+#endif
+
 static const struct dev_pm_ops pm2xxx_pm_ops = {
-	.runtime_suspend = pm2xxx_runtime_suspend,
-	.runtime_resume = pm2xxx_runtime_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(pm2xxx_wall_charger_suspend,
+		pm2xxx_wall_charger_resume)
+	SET_RUNTIME_PM_OPS(pm2xxx_runtime_suspend, pm2xxx_runtime_resume, NULL)
 };
 #define  PM2XXX_PM_OPS (&pm2xxx_pm_ops)
 #else
@@ -1234,8 +1246,6 @@ MODULE_DEVICE_TABLE(i2c, pm2xxx_id);
 static struct i2c_driver pm2xxx_charger_driver = {
 	.probe = pm2xxx_wall_charger_probe,
 	.remove = pm2xxx_wall_charger_remove,
-	.suspend = pm2xxx_wall_charger_suspend,
-	.resume = pm2xxx_wall_charger_resume,
 	.driver = {
 		.name = "pm2xxx-wall_charger",
 		.owner = THIS_MODULE,
-- 
1.8.0

