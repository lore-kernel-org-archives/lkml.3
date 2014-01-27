Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaA0UQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaA0UQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3.13 07/10] extcon: gpio: Request gpio pin before modifying its state
Date: Mon, 27 Jan 2014 12:17:10 -0800
Message-Id: <20140127201535.871457088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 4288d9b8edcec7289e00eecdad44f14c9ea1ba0e upstream.

Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
introduced a call to gpio_set_debounce() before actually requesting the
respective gpio pin from the gpio subsystem.

The gpio subsystem expects that a gpio pin was requested before modifying its
state. Not doing so results in a warning from gpiolib, and the gpio pin is
auto-requested. This in turn causes the subsequent devm_gpio_request_one()
to fail. So devm_gpio_request_one() must be called prior to calling
gpio_set_debounce().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-gpio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -105,6 +105,12 @@ static int gpio_extcon_probe(struct plat
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
@@ -117,11 +123,6 @@ static int gpio_extcon_probe(struct plat
 	if (ret < 0)
 		return ret;
 
-	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
-				    pdev->name);
-	if (ret < 0)
-		goto err;
-
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);


