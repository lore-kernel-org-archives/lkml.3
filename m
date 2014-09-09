Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaIIESS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:18:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50101 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaIIERT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:17:19 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/5] extcon: gpio: Convert the driver to use gpio desc API's
Date: Tue, 9 Sep 2014 09:44:35 +0530
Message-ID: <1410236078-11713-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use gpiod_* API's.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/extcon/extcon-gpio.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 72f19a3..25269f6 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -33,8 +33,7 @@
 
 struct gpio_extcon_data {
 	struct extcon_dev *edev;
-	unsigned gpio;
-	bool gpio_active_low;
+	struct gpio_desc *gpiod;
 	const char *state_on;
 	const char *state_off;
 	int irq;
@@ -50,9 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
 		container_of(to_delayed_work(work), struct gpio_extcon_data,
 			     work);
 
-	state = gpio_get_value(data->gpio);
-	if (data->gpio_active_low)
-		state = !state;
+	state = gpiod_get_value(data->gpiod);
 	extcon_set_state(data->edev, state);
 }
 
@@ -106,22 +103,21 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	}
 	extcon_data->edev->name = pdata->name;
 
-	extcon_data->gpio = pdata->gpio;
-	extcon_data->gpio_active_low = pdata->gpio_active_low;
+	extcon_data->gpiod = gpio_to_desc(pdata->gpio);
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
 	extcon_data->check_on_resume = pdata->check_on_resume;
 	if (pdata->state_on && pdata->state_off)
 		extcon_data->edev->print_state = extcon_gpio_print_state;
 
-	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
+	ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
 				    pdev->name);
 	if (ret < 0)
 		return ret;
 
 	if (pdata->debounce) {
-		ret = gpio_set_debounce(extcon_data->gpio,
-					pdata->debounce * 1000);
+		ret = gpiod_set_debounce(extcon_data->gpiod,
+					 pdata->debounce * 1000);
 		if (ret < 0)
 			extcon_data->debounce_jiffies =
 				msecs_to_jiffies(pdata->debounce);
@@ -133,7 +129,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
-	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
+	extcon_data->irq = gpiod_to_irq(extcon_data->gpiod);
 	if (extcon_data->irq < 0)
 		return extcon_data->irq;
 
-- 
1.8.3.1

