Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161606Ab3BOMtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:49:17 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:63193 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161539Ab3BOMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:47:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, lme00437 <benoit.gauthier-nonst@stericsson.com>,
        Benoit GAUTHIER <benoit.gauthier-xsig@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/40] pm2301-charger: lpn pin used only in C2C boards
Date: Fri, 15 Feb 2013 12:45:03 +0000
Message-Id: <1360932310-30065-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lme00437 <benoit.gauthier-nonst@stericsson.com>

This patch restricts use of LPN pin to C2C boards to avoid
conflict on HSI for GPIO 60 use.

Signed-off-by: Benoit GAUTHIER <benoit.gauthier-xsig@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mustapha BEN-ZOUBEIR <mustapha.ben.zoubeir-xsig@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Benoit GAUTHIER <benoit.gauthier-xsig@stericsson.com>
---
 drivers/power/pm2301_charger.c |   66 +++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index cb1c953..eed6034 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -113,17 +113,16 @@ static const struct i2c_device_id pm2xxx_ident[] = {
 
 static void set_lpn_pin(struct pm2xxx_charger *pm2)
 {
-	gpio_set_value(pm2->lpn_pin, 1);
-	usleep_range(SLEEP_MIN, SLEEP_MAX);
-
-	return;
+	if (!pm2->ac.charger_connected && gpio_is_valid(pm2->lpn_pin)) {
+		gpio_set_value(pm2->lpn_pin, 1);
+		usleep_range(SLEEP_MIN, SLEEP_MAX);
+	}
 }
 
 static void clear_lpn_pin(struct pm2xxx_charger *pm2)
 {
-	gpio_set_value(pm2->lpn_pin, 0);
-
-	return;
+	if (!pm2->ac.charger_connected && gpio_is_valid(pm2->lpn_pin))
+		gpio_set_value(pm2->lpn_pin, 0);
 }
 
 static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
@@ -1035,14 +1034,6 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 	pm2->bat = pl_data->battery;
 
-	/*get lpn GPIO from platform data*/
-	if (!pm2->pdata->lpn_gpio) {
-		dev_err(pm2->dev, "no lpn gpio data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-	pm2->lpn_pin = pm2->pdata->lpn_gpio;
-
 	if (!i2c_check_functionality(i2c_client->adapter,
 			I2C_FUNC_SMBUS_BYTE_DATA |
 			I2C_FUNC_SMBUS_READ_WORD_DATA)) {
@@ -1146,23 +1137,28 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 	mutex_init(&pm2->lock);
 
-	/*
-	 * Charger detection mechanism requires pulling up the LPN pin
-	 * while i2c communication if Charger is not connected
-	 * LPN pin of PM2301 is GPIO60 of AB9540
-	 */
-	ret = gpio_request(pm2->lpn_pin, "pm2301_lpm_gpio");
-	if (ret < 0) {
-		dev_err(pm2->dev, "pm2301_lpm_gpio request failed\n");
-		goto disable_pm2_irq_wake;
-	}
-	ret = gpio_direction_output(pm2->lpn_pin, 0);
-	if (ret < 0) {
-		dev_err(pm2->dev, "pm2301_lpm_gpio direction failed\n");
-		goto free_gpio;
-	}
+	if (gpio_is_valid(pm2->pdata->lpn_gpio)) {
+		/* get lpn GPIO from platform data */
+		pm2->lpn_pin = pm2->pdata->lpn_gpio;
 
-	set_lpn_pin(pm2);
+		/*
+		 * Charger detection mechanism requires pulling up the LPN pin
+		 * while i2c communication if Charger is not connected
+		 * LPN pin of PM2301 is GPIO60 of AB9540
+		 */
+		ret = gpio_request(pm2->lpn_pin, "pm2301_lpm_gpio");
+
+		if (ret < 0) {
+			dev_err(pm2->dev, "pm2301_lpm_gpio request failed\n");
+			goto disable_pm2_irq_wake;
+		}
+		ret = gpio_direction_output(pm2->lpn_pin, 0);
+		if (ret < 0) {
+			dev_err(pm2->dev, "pm2301_lpm_gpio direction failed\n");
+			goto free_gpio;
+		}
+		set_lpn_pin(pm2);
+	}
 
 	/* read  interrupt registers */
 	for (i = 0; i < PM2XXX_NUM_INT_REG; i++)
@@ -1184,7 +1180,8 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	return 0;
 
 free_gpio:
-	gpio_free(pm2->lpn_pin);
+	if (gpio_is_valid(pm2->lpn_pin))
+		gpio_free(pm2->lpn_pin);
 disable_pm2_irq_wake:
 	disable_irq_wake(gpio_to_irq(pm2->pdata->gpio_irq_number));
 unregister_pm2xxx_interrupt:
@@ -1229,7 +1226,8 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 
 	power_supply_unregister(&pm2->ac_chg.psy);
 
-	gpio_free(pm2->lpn_pin);
+	if (gpio_is_valid(pm2->lpn_pin))
+		gpio_free(pm2->lpn_pin);
 
 	kfree(pm2);
 
@@ -1266,7 +1264,7 @@ static void __exit pm2xxx_charger_exit(void)
 	i2c_del_driver(&pm2xxx_charger_driver);
 }
 
-subsys_initcall_sync(pm2xxx_charger_init);
+device_initcall_sync(pm2xxx_charger_init);
 module_exit(pm2xxx_charger_exit);
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

