Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161644Ab3BOMuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:50:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36328 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161511Ab3BOMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:47 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com,
        M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/40] pm2301-charger: Adjust interrupt handler behavior
Date: Fri, 15 Feb 2013 12:44:57 +0000
Message-Id: <1360932310-30065-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>

Signed-off-by: M BenZoubeir <mustapha.ben.zoubeir-xsig@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |   45 +++++++++++++++++++++-------------------
 include/linux/pm2301_charger.h |    2 +-
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 7f82431..98e27a8 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -493,14 +493,16 @@ static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
 	struct pm2xxx_interrupts *interrupt = pm2->pm2_int;
 	int i;
 
-	for (i = 0; i < PM2XXX_NUM_INT_REG; i++) {
-		 pm2xxx_reg_read(pm2,
+	do {
+		for (i = 0; i < PM2XXX_NUM_INT_REG; i++) {
+			pm2xxx_reg_read(pm2,
 				pm2xxx_interrupt_registers[i],
 				&(interrupt->reg[i]));
 
-		if (interrupt->reg[i] > 0)
-			interrupt->handler[i](pm2, interrupt->reg[i]);
-	}
+			if (interrupt->reg[i] > 0)
+				interrupt->handler[i](pm2, interrupt->reg[i]);
+		}
+	} while (gpio_get_value(pm2->pdata->gpio_irq_number) == 0);
 
 	return IRQ_HANDLED;
 }
@@ -951,6 +953,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	struct pm2xxx_charger *pm2;
 	int ret = 0;
 	u8 val;
+	int i;
 
 	pm2 = kzalloc(sizeof(struct pm2xxx_charger), GFP_KERNEL);
 	if (!pm2) {
@@ -1062,24 +1065,25 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	}
 
 	/* Register interrupts */
-	ret = request_threaded_irq(pm2->pdata->irq_number, NULL,
+	ret = request_threaded_irq(gpio_to_irq(pm2->pdata->gpio_irq_number),
+				NULL,
 				pm2xxx_charger_irq[0].isr,
 				pm2->pdata->irq_type,
 				pm2xxx_charger_irq[0].name, pm2);
 
 	if (ret != 0) {
 		dev_err(pm2->dev, "failed to request %s IRQ %d: %d\n",
-		pm2xxx_charger_irq[0].name, pm2->pdata->irq_number, ret);
+		pm2xxx_charger_irq[0].name,
+			gpio_to_irq(pm2->pdata->gpio_irq_number), ret);
 		goto unregister_pm2xxx_charger;
 	}
 	/* pm interrupt can wake up system */
-	ret = enable_irq_wake(pm2->pdata->irq_number);
+	ret = enable_irq_wake(gpio_to_irq(pm2->pdata->gpio_irq_number));
 	if (ret) {
 		dev_err(pm2->dev, "failed to set irq wake\n");
 		goto unregister_pm2xxx_interrupt;
 	}
 
-	/*Initialize lock*/
 	mutex_init(&pm2->lock);
 
 	/*
@@ -1099,16 +1103,16 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	}
 
 	set_lpn_pin(pm2);
+
+	/* read  interrupt registers */
+	for (i = 0; i < PM2XXX_NUM_INT_REG; i++)
+		pm2xxx_reg_read(pm2,
+			pm2xxx_interrupt_registers[i],
+			&val);
+
 	ret = pm2xxx_charger_detection(pm2, &val);
 
 	if ((ret == 0) && val) {
-		/*
-		 * When boot is due to AC charger plug-in,
-		 * read interrupt registers
-		 */
-		pm2xxx_reg_read(pm2, PM2XXX_REG_INT1, &val);
-		pm2xxx_reg_read(pm2, PM2XXX_REG_INT2, &val);
-		pm2xxx_reg_read(pm2, PM2XXX_REG_INT4, &val);
 		pm2->ac.charger_connected = 1;
 		ab8500_override_turn_on_stat(~AB8500_POW_KEY_1_ON,
 					     AB8500_MAIN_CH_DET);
@@ -1122,10 +1126,10 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 free_gpio:
 	gpio_free(pm2->lpn_pin);
 disable_pm2_irq_wake:
-	disable_irq_wake(pm2->pdata->irq_number);
+	disable_irq_wake(gpio_to_irq(pm2->pdata->gpio_irq_number));
 unregister_pm2xxx_interrupt:
 	/* disable interrupt */
-	free_irq(pm2->pdata->irq_number, pm2);
+	free_irq(gpio_to_irq(pm2->pdata->gpio_irq_number), pm2);
 unregister_pm2xxx_charger:
 	/* unregister power supply */
 	power_supply_unregister(&pm2->ac_chg.psy);
@@ -1148,10 +1152,10 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 	pm2xxx_charger_ac_en(&pm2->ac_chg, false, 0, 0);
 
 	/* Disable wake by pm interrupt */
-	disable_irq_wake(pm2->pdata->irq_number);
+	disable_irq_wake(gpio_to_irq(pm2->pdata->gpio_irq_number));
 
 	/* Disable interrupts */
-	free_irq(pm2->pdata->irq_number, pm2);
+	free_irq(gpio_to_irq(pm2->pdata->gpio_irq_number), pm2);
 
 	/* Delete the work queue */
 	destroy_workqueue(pm2->charger_wq);
@@ -1163,7 +1167,6 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 
 	power_supply_unregister(&pm2->ac_chg.psy);
 
-	/*Free GPIO60*/
 	gpio_free(pm2->lpn_pin);
 
 	kfree(pm2);
diff --git a/include/linux/pm2301_charger.h b/include/linux/pm2301_charger.h
index fc3f026..85c16de 100644
--- a/include/linux/pm2301_charger.h
+++ b/include/linux/pm2301_charger.h
@@ -48,7 +48,7 @@ struct pm2xxx_charger_platform_data {
 	size_t num_supplicants;
 	int i2c_bus;
 	const char *label;
-	int irq_number;
+	int gpio_irq_number;
 	unsigned int lpn_gpio;
 	int irq_type;
 };
-- 
1.7.10.4

