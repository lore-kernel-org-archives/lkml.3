Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3E3Tzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:55:48 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:49502 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab3E3Tzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:55:42 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH v3 1/1] gpio: sx150x: convert to use devm_* functions
Date: Tue, 28 May 2013 15:02:50 -0700
Message-Id: <1369778570-23613-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Use devm_* functions to make cleanup paths simpler.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/gpio/gpio-sx150x.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
index 796b6c4..f371732 100644
--- a/drivers/gpio/gpio-sx150x.c
+++ b/drivers/gpio/gpio-sx150x.c
@@ -548,7 +548,8 @@ static int sx150x_install_irq_chip(struct sx150x_chip *chip,
 #endif
 	}
 
-	err = request_threaded_irq(irq_summary,
+	err = devm_request_threaded_irq(&chip->client->dev,
+				irq_summary,
 				NULL,
 				sx150x_irq_thread_fn,
 				IRQF_SHARED | IRQF_TRIGGER_FALLING,
@@ -567,8 +568,6 @@ static void sx150x_remove_irq_chip(struct sx150x_chip *chip)
 	unsigned n;
 	unsigned irq;
 
-	free_irq(chip->irq_summary, chip);
-
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = chip->irq_base + n;
 		irq_set_chip_and_handler(irq, NULL, NULL);
@@ -591,18 +590,19 @@ static int sx150x_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, i2c_funcs))
 		return -ENOSYS;
 
-	chip = kzalloc(sizeof(struct sx150x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+		sizeof(struct sx150x_chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
 	sx150x_init_chip(chip, client, id->driver_data, pdata);
 	rc = sx150x_init_hw(chip, pdata);
 	if (rc < 0)
-		goto probe_fail_pre_gpiochip_add;
+		return rc;
 
 	rc = gpiochip_add(&chip->gpio_chip);
-	if (rc < 0)
-		goto probe_fail_pre_gpiochip_add;
+	if (rc)
+		return rc;
 
 	if (pdata->irq_summary >= 0) {
 		rc = sx150x_install_irq_chip(chip,
@@ -617,8 +617,6 @@ static int sx150x_probe(struct i2c_client *client,
 	return 0;
 probe_fail_post_gpiochip_add:
 	WARN_ON(gpiochip_remove(&chip->gpio_chip) < 0);
-probe_fail_pre_gpiochip_add:
-	kfree(chip);
 	return rc;
 }
 
@@ -635,8 +633,6 @@ static int sx150x_remove(struct i2c_client *client)
 	if (chip->irq_summary >= 0)
 		sx150x_remove_irq_chip(chip);
 
-	kfree(chip);
-
 	return 0;
 }
 
-- 
1.7.9.5

