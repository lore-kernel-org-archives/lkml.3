Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161675Ab3BOMum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:50:42 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54859 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161286Ab3BOMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com,
        M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/40] pm2301-charger: Add pm_runtime_resume & pm_runtime_suspend
Date: Fri, 15 Feb 2013 12:44:58 +0000
Message-Id: <1360932310-30065-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>

To optimize the current consumption we use pm_runtime autosuspend
functions which execute the pm_runtime_suspend after a delay of
inactivity on the other hand we use pm_runtime_resume every time
we receive an interruption to wake up the pm2301.

Signed-off-by: M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |   68 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 98e27a8..2cc92ec 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -29,6 +29,7 @@
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/pm2301_charger.h>
 #include <linux/gpio.h>
+#include <linux/pm_runtime.h>
 
 #include "pm2301_charger.h"
 
@@ -36,6 +37,7 @@
 		struct pm2xxx_charger, ac_chg)
 #define SLEEP_MIN		50
 #define SLEEP_MAX		100
+#define PM2XXX_AUTOSUSPEND_DELAY 500
 
 static int pm2xxx_interrupt_registers[] = {
 	PM2XXX_REG_INT1,
@@ -493,6 +495,9 @@ static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
 	struct pm2xxx_interrupts *interrupt = pm2->pm2_int;
 	int i;
 
+	/* wake up the device */
+	pm_runtime_get_sync(pm2->dev);
+
 	do {
 		for (i = 0; i < PM2XXX_NUM_INT_REG; i++) {
 			pm2xxx_reg_read(pm2,
@@ -504,6 +509,9 @@ static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
 		}
 	} while (gpio_get_value(pm2->pdata->gpio_irq_number) == 0);
 
+	pm_runtime_mark_last_busy(pm2->dev);
+	pm_runtime_put_autosuspend(pm2->dev);
+
 	return IRQ_HANDLED;
 }
 
@@ -946,6 +954,53 @@ static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int  pm2xxx_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *pm2xxx_i2c_client = to_i2c_client(dev);
+	struct pm2xxx_charger *pm2;
+	int ret = 0;
+
+	pm2 = (struct pm2xxx_charger *)i2c_get_clientdata(pm2xxx_i2c_client);
+	if (!pm2) {
+		dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");
+		ret = -EINVAL;
+		return ret;
+	}
+
+	clear_lpn_pin(pm2);
+
+	return ret;
+}
+
+static int  pm2xxx_runtime_resume(struct device *dev)
+{
+	struct i2c_client *pm2xxx_i2c_client = to_i2c_client(dev);
+	struct pm2xxx_charger *pm2;
+	int ret = 0;
+
+	pm2 = (struct pm2xxx_charger *)i2c_get_clientdata(pm2xxx_i2c_client);
+	if (!pm2) {
+		dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");
+		ret = -EINVAL;
+		return ret;
+	}
+
+	if (gpio_is_valid(pm2->lpn_pin) && gpio_get_value(pm2->lpn_pin) == 0)
+		set_lpn_pin(pm2);
+
+	return ret;
+}
+
+static const struct dev_pm_ops pm2xxx_pm_ops = {
+	.runtime_suspend = pm2xxx_runtime_suspend,
+	.runtime_resume = pm2xxx_runtime_resume,
+};
+#define  PM2XXX_PM_OPS (&pm2xxx_pm_ops)
+#else
+#define  PM2XXX_PM_OPS  NULL
+#endif
+
 static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		const struct i2c_device_id *id)
 {
@@ -1077,6 +1132,16 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 			gpio_to_irq(pm2->pdata->gpio_irq_number), ret);
 		goto unregister_pm2xxx_charger;
 	}
+
+	ret = pm_runtime_set_active(pm2->dev);
+	if (ret)
+		dev_err(pm2->dev, "set active Error\n");
+
+	pm_runtime_enable(pm2->dev);
+	pm_runtime_set_autosuspend_delay(pm2->dev, PM2XXX_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(pm2->dev);
+	pm_runtime_resume(pm2->dev);
+
 	/* pm interrupt can wake up system */
 	ret = enable_irq_wake(gpio_to_irq(pm2->pdata->gpio_irq_number));
 	if (ret) {
@@ -1148,6 +1213,8 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 {
 	struct pm2xxx_charger *pm2 = i2c_get_clientdata(i2c_client);
 
+	/* Disable pm_runtime */
+	pm_runtime_disable(pm2->dev);
 	/* Disable AC charging */
 	pm2xxx_charger_ac_en(&pm2->ac_chg, false, 0, 0);
 
@@ -1189,6 +1256,7 @@ static struct i2c_driver pm2xxx_charger_driver = {
 	.driver = {
 		.name = "pm2xxx-wall_charger",
 		.owner = THIS_MODULE,
+		.pm = PM2XXX_PM_OPS,
 	},
 	.id_table = pm2xxx_id,
 };
-- 
1.7.10.4

