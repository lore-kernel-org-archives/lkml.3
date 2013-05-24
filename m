Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3EXLVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:21:30 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47654 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3EXLV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:21:28 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Nikolay Balandin <nbalandin@dev.rtsoft.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: sx150x: use devm_kzalloc()
Date: Fri, 24 May 2013 15:21:26 +0400
Message-Id: <1369394486-26225-1-git-send-email-nbalandin@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/gpio/gpio-sx150x.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
index 796b6c4..5f7dc82 100644
--- a/drivers/gpio/gpio-sx150x.c
+++ b/drivers/gpio/gpio-sx150x.c
@@ -591,18 +591,19 @@ static int sx150x_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, i2c_funcs))
 		return -ENOSYS;
 
-	chip = kzalloc(sizeof(struct sx150x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+			sizeof(struct sx150x_chip), GFP_KERNEL);
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
 
-- 
1.7.9.5

