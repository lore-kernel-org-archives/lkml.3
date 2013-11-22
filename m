Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3KVR0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:26:18 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63557 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3KVR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:26:17 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] extcon: gpio: Request gpio pin before modifying its state
Date: Fri, 22 Nov 2013 09:26:01 -0800
Message-Id: <1385141161-7785-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
introduced a call to gpio_set_debounce() before actually requesting the
respective gpio pin from the gpio subsystem.

The gpio subsystem expects that a gpio pin was requested before modifying its
state. Not doing so results in a warning from gpiolib, and the gpio pin is
auto-requested. This in turn causes the subsequent devm_gpio_request_one()
to fail. So devm_gpio_request_one() must be called prior to calling
gpio_set_debounce().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/extcon/extcon-gpio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 7e0dff5..4736a9c 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -105,6 +105,12 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	extcon_data->state_off = pdata->state_off;
 	if (pdata->state_on && pdata->state_off)
 		extcon_data->edev.print_state = extcon_gpio_print_state;
+
+	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
+				    pdev->name);
+	if (ret < 0)
+		return ret;
+
 	if (pdata->debounce) {
 		ret = gpio_set_debounce(extcon_data->gpio,
 					pdata->debounce * 1000);
@@ -117,11 +123,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
-				    pdev->name);
-	if (ret < 0)
-		goto err;
-
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
-- 
1.7.9.7

