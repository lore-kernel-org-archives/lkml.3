Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936023Ab3BOMyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:54:13 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:36776 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161402Ab3BOMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/40] pm2301-charger: Wake system when ext charger is plugged-in
Date: Fri, 15 Feb 2013 12:44:45 +0000
Message-Id: <1360932310-30065-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

When in suspend state, upon plug-in of external AC charger the
device needs to wake-up and charging operation started.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ec51026..7f82431 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1072,6 +1072,12 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		pm2xxx_charger_irq[0].name, pm2->pdata->irq_number, ret);
 		goto unregister_pm2xxx_charger;
 	}
+	/* pm interrupt can wake up system */
+	ret = enable_irq_wake(pm2->pdata->irq_number);
+	if (ret) {
+		dev_err(pm2->dev, "failed to set irq wake\n");
+		goto unregister_pm2xxx_interrupt;
+	}
 
 	/*Initialize lock*/
 	mutex_init(&pm2->lock);
@@ -1084,7 +1090,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	ret = gpio_request(pm2->lpn_pin, "pm2301_lpm_gpio");
 	if (ret < 0) {
 		dev_err(pm2->dev, "pm2301_lpm_gpio request failed\n");
-		goto unregister_pm2xxx_charger;
+		goto disable_pm2_irq_wake;
 	}
 	ret = gpio_direction_output(pm2->lpn_pin, 0);
 	if (ret < 0) {
@@ -1115,6 +1121,11 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 free_gpio:
 	gpio_free(pm2->lpn_pin);
+disable_pm2_irq_wake:
+	disable_irq_wake(pm2->pdata->irq_number);
+unregister_pm2xxx_interrupt:
+	/* disable interrupt */
+	free_irq(pm2->pdata->irq_number, pm2);
 unregister_pm2xxx_charger:
 	/* unregister power supply */
 	power_supply_unregister(&pm2->ac_chg.psy);
@@ -1125,6 +1136,7 @@ free_charger_wq:
 	destroy_workqueue(pm2->charger_wq);
 free_device_info:
 	kfree(pm2);
+
 	return ret;
 }
 
@@ -1135,6 +1147,9 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 	/* Disable AC charging */
 	pm2xxx_charger_ac_en(&pm2->ac_chg, false, 0, 0);
 
+	/* Disable wake by pm interrupt */
+	disable_irq_wake(pm2->pdata->irq_number);
+
 	/* Disable interrupts */
 	free_irq(pm2->pdata->irq_number, pm2);
 
-- 
1.7.10.4

