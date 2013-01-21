Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3AUME7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:59 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62815 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3AUME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/24] pm2301: LPN mode control support
Date: Mon, 21 Jan 2013 12:03:55 +0000
Message-Id: <1358769840-4763-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

The AC charger plug-in detection while booting causes I2C read
failure if AC charger is not connected. Now the LPN pin is enabled
for every PM2301 register access, which solves the issue.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Vijaya Kumar K-1 <vijay.kilari@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/pm2301_charger.c |   72 ++++++++++++++++++++++++++++++++++++++--
 drivers/power/pm2301_charger.h |    1 +
 include/linux/pm2301_charger.h |    1 +
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index c7d92b3..14e37b2 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/pm2301_charger.h>
+#include <linux/gpio.h>
 
 #include "pm2301_charger.h"
 
@@ -110,9 +111,35 @@ static const struct i2c_device_id pm2xxx_ident[] = {
 	{ }
 };
 
+static void set_lpn_pin(struct pm2xxx_charger *pm2)
+{
+	if (pm2->ac.charger_connected)
+		return;
+	gpio_set_value(pm2->lpn_pin, 1);
+
+	return;
+}
+
+static void clear_lpn_pin(struct pm2xxx_charger *pm2)
+{
+	if (pm2->ac.charger_connected)
+		return;
+	gpio_set_value(pm2->lpn_pin, 0);
+
+	return;
+}
+
 int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 {
 	int ret;
+	/*
+	 * When AC adaptor is unplugged, the host
+	 * must put LPN high to be able to
+	 * communicate by I2C with PM2301
+	 * and receive I2C "acknowledge" from PM2301.
+	 */
+	mutex_lock(&pm2->lock);
+	set_lpn_pin(pm2);
 
 	ret = i2c_smbus_read_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, val);
@@ -120,6 +147,8 @@ int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 		dev_err(pm2->dev, "Error reading register at 0x%x\n", reg);
 	else
 		ret = 0;
+	clear_lpn_pin(pm2);
+	mutex_unlock(&pm2->lock);
 
 	return ret;
 }
@@ -127,6 +156,14 @@ int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 {
 	int ret;
+	/*
+	 * When AC adaptor is unplugged, the host
+	 * must put LPN high to be able to
+	 * communicate by I2C with PM2301
+	 * and receive I2C "acknowledge" from PM2301.
+	 */
+	mutex_lock(&pm2->lock);
+	set_lpn_pin(pm2);
 
 	ret = i2c_smbus_write_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, &val);
@@ -134,6 +171,8 @@ int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 		dev_err(pm2->dev, "Error writing register at 0x%x\n", reg);
 	else
 		ret = 0;
+	clear_lpn_pin(pm2);
+	mutex_unlock(&pm2->lock);
 
 	return ret;
 }
@@ -850,6 +889,14 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 	pm2->bat = pl_data->battery;
 
+	/*get lpn GPIO from platform data*/
+	if (!pm2->pdata->lpn_gpio) {
+		dev_err(pm2->dev, "no lpn gpio data supplied\n");
+		ret = -EINVAL;
+		goto free_device_info;
+	}
+	pm2->lpn_pin = pm2->pdata->lpn_gpio;
+
 	if (!i2c_check_functionality(i2c_client->adapter,
 			I2C_FUNC_SMBUS_BYTE_DATA |
 			I2C_FUNC_SMBUS_READ_WORD_DATA)) {
@@ -929,10 +976,25 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		goto unregister_pm2xxx_charger;
 	}
 
+	/*Initialize lock*/
+	mutex_init(&pm2->lock);
+
 	/*
-	 * I2C Read/Write will fail, if AC adaptor is not connected.
-	 * fix the charger detection mechanism.
+	 * Charger detection mechanism requires pulling up the LPN pin
+	 * while i2c communication if Charger is not connected
+	 * LPN pin of PM2301 is GPIO60 of AB9540
 	 */
+	ret = gpio_request(pm2->lpn_pin, "pm2301_lpm_gpio");
+	if (ret < 0) {
+		dev_err(pm2->dev, "pm2301_lpm_gpio request failed\n");
+		goto unregister_pm2xxx_charger;
+	}
+	ret = gpio_direction_output(pm2->lpn_pin, 0);
+	if (ret < 0) {
+		dev_err(pm2->dev, "pm2301_lpm_gpio direction failed\n");
+		goto free_gpio;
+	}
+
 	ret = pm2xxx_charger_detection(pm2, &val);
 
 	if ((ret == 0) && val) {
@@ -951,7 +1013,8 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 err_deep_debug:
 	/* disable interrupt */
 	free_irq(pm2->pdata->irq_number, pm2);
-
+free_gpio:
+	gpio_free(pm2->lpn_pin);
 unregister_pm2xxx_charger:
 	/* unregister power supply */
 	power_supply_unregister(&pm2->ac_chg.psy);
@@ -987,6 +1050,9 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 
 	power_supply_unregister(&pm2->ac_chg.psy);
 
+	/*Free GPIO60*/
+	gpio_free(pm2->lpn_pin);
+
 	kfree(pm2);
 
 	return 0;
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
index 5ae3573..c28babc 100644
--- a/drivers/power/pm2301_charger.h
+++ b/drivers/power/pm2301_charger.h
@@ -493,6 +493,7 @@ struct pm2xxx_charger {
 	int old_vbat;
 	int failure_case;
 	int failure_input_ovv;
+	unsigned int lpn_pin;
 	struct pm2xxx_interrupts *pm2_int;
 	struct ab8500_gpadc *gpadc;
 	struct regulator *regu;
diff --git a/include/linux/pm2301_charger.h b/include/linux/pm2301_charger.h
index 16bb1d3..fc3f026 100644
--- a/include/linux/pm2301_charger.h
+++ b/include/linux/pm2301_charger.h
@@ -49,6 +49,7 @@ struct pm2xxx_charger_platform_data {
 	int i2c_bus;
 	const char *label;
 	int irq_number;
+	unsigned int lpn_gpio;
 	int irq_type;
 };
 
-- 
1.7.9.5

