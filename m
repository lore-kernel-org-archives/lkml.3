Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab3E3TVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:21:18 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34759 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3E3TVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:21:10 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH v2 1/1] gpio: sx150x: convert to use devm_kzalloc()
Date: Tue, 28 May 2013 14:29:44 -0700
Message-Id: <1369776584-15271-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/gpio/gpio-sx150x.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
index 796b6c4..17c67be 100644
--- a/drivers/gpio/gpio-sx150x.c
+++ b/drivers/gpio/gpio-sx150x.c
@@ -591,18 +591,19 @@ static int sx150x_probe(struct i2c_client *client,
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
@@ -617,8 +618,6 @@ static int sx150x_probe(struct i2c_client *client,
 	return 0;
 probe_fail_post_gpiochip_add:
 	WARN_ON(gpiochip_remove(&chip->gpio_chip) < 0);
-probe_fail_pre_gpiochip_add:
-	kfree(chip);
 	return rc;
 }
 
@@ -635,8 +634,6 @@ static int sx150x_remove(struct i2c_client *client)
 	if (chip->irq_summary >= 0)
 		sx150x_remove_irq_chip(chip);
 
-	kfree(chip);
-
 	return 0;
 }
 
-- 
1.7.9.5

