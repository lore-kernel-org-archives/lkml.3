Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3IYHhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:37:21 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63938 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3IYHhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:16 -0400
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 15:37:15 +0800
Message-ID: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
Subject: [PATCH] mfd: twl6040: drop devm_free_irq of devm_ allocated irq
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The devm_request_irq function allocates irq that is released
when a driver detaches. Thus, there is no reason to explicitly
call devm_free_irq in probe or remove functions.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/twl6040.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index daf6694..7361dbe 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -619,7 +619,7 @@ static int twl6040_probe(struct i2c_client *client,
 					"twl6040_irq_th", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
-		goto thirq_err;
+		goto readyirq_err;
 	}
 
 	/* dual-access registers controlled by I2C only */
@@ -659,14 +659,10 @@ static int twl6040_probe(struct i2c_client *client,
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
 			      NULL, 0, NULL);
 	if (ret)
-		goto mfd_err;
+		goto readyirq_err;
 
 	return 0;
 
-mfd_err:
-	devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
-thirq_err:
-	devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
 readyirq_err:
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 gpio_err:
@@ -684,8 +680,6 @@ static int twl6040_remove(struct i2c_client *client)
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
 
-	devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
-	devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 
 	mfd_remove_devices(&client->dev);

