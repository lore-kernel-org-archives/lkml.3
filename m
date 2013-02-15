Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161443Ab3BOMq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:27 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41390 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161392Ab3BOMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com,
        Mustapha Ben Zoubeir 
	<mustapha.ben.zoubeir-nonst@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/40] pm2301-charger: Resolve I2C detection problem on ab9540
Date: Fri, 15 Feb 2013 12:44:42 +0000
Message-Id: <1360932310-30065-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mustapha Ben Zoubeir <mustapha.ben.zoubeir-nonst@stericsson.com>

Signed-off-by: Mustapha Ben Zoubeir <mustapha.ben.zoubeir-nonst@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
---
 drivers/power/pm2301_charger.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 63f515e..4cb8f7f 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -34,6 +34,8 @@
 
 #define to_pm2xxx_charger_ac_device_info(x) container_of((x), \
 		struct pm2xxx_charger, ac_chg)
+#define SLEEP_MIN		50
+#define SLEEP_MAX		100
 
 static int pm2xxx_interrupt_registers[] = {
 	PM2XXX_REG_INT1,
@@ -113,17 +115,14 @@ static const struct i2c_device_id pm2xxx_ident[] = {
 
 static void set_lpn_pin(struct pm2xxx_charger *pm2)
 {
-	if (pm2->ac.charger_connected)
-		return;
 	gpio_set_value(pm2->lpn_pin, 1);
+	usleep_range(SLEEP_MIN, SLEEP_MAX);
 
 	return;
 }
 
 static void clear_lpn_pin(struct pm2xxx_charger *pm2)
 {
-	if (pm2->ac.charger_connected)
-		return;
 	gpio_set_value(pm2->lpn_pin, 0);
 
 	return;
@@ -139,7 +138,6 @@ static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 	 * and receive I2C "acknowledge" from PM2301.
 	 */
 	mutex_lock(&pm2->lock);
-	set_lpn_pin(pm2);
 
 	ret = i2c_smbus_read_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, val);
@@ -147,7 +145,6 @@ static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 		dev_err(pm2->dev, "Error reading register at 0x%x\n", reg);
 	else
 		ret = 0;
-	clear_lpn_pin(pm2);
 	mutex_unlock(&pm2->lock);
 
 	return ret;
@@ -163,7 +160,6 @@ static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 	 * and receive I2C "acknowledge" from PM2301.
 	 */
 	mutex_lock(&pm2->lock);
-	set_lpn_pin(pm2);
 
 	ret = i2c_smbus_write_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, &val);
@@ -171,7 +167,6 @@ static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 		dev_err(pm2->dev, "Error writing register at 0x%x\n", reg);
 	else
 		ret = 0;
-	clear_lpn_pin(pm2);
 	mutex_unlock(&pm2->lock);
 
 	return ret;
@@ -478,7 +473,6 @@ static int pm2_int_reg5(void *pm2_data, int val)
 	struct pm2xxx_charger *pm2 = pm2_data;
 	int ret = 0;
 
-
 	if (val & (PM2XXX_INT6_ITVPWR2DROP | PM2XXX_INT6_ITVPWR1DROP)) {
 		dev_dbg(pm2->dev, "VMPWR drop to VBAT level\n");
 	}
@@ -899,12 +893,34 @@ static struct pm2xxx_irq pm2xxx_charger_irq[] = {
 
 static int pm2xxx_wall_charger_resume(struct i2c_client *i2c_client)
 {
+	struct pm2xxx_charger *pm2;
+
+	pm2 =  (struct pm2xxx_charger *)i2c_get_clientdata(i2c_client);
+	set_lpn_pin(pm2);
+
+	/* If we still have a HW failure, schedule a new check */
+	if (pm2->flags.ovv)
+		queue_delayed_work(pm2->charger_wq,
+				&pm2->check_hw_failure_work, 0);
+
 	return 0;
 }
 
 static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
 	pm_message_t state)
 {
+	struct pm2xxx_charger *pm2;
+
+	pm2 =  (struct pm2xxx_charger *)i2c_get_clientdata(i2c_client);
+	clear_lpn_pin(pm2);
+
+	/* Cancel any pending HW failure check */
+	if (delayed_work_pending(&pm2->check_hw_failure_work))
+		cancel_delayed_work(&pm2->check_hw_failure_work);
+
+	flush_work(&pm2->ac_work);
+	flush_work(&pm2->check_main_thermal_prot_work);
+
 	return 0;
 }
 
@@ -1056,6 +1072,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		goto free_gpio;
 	}
 
+	set_lpn_pin(pm2);
 	ret = pm2xxx_charger_detection(pm2, &val);
 
 	if ((ret == 0) && val) {
-- 
1.7.10.4

