Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaIIHks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:40:48 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56880 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaIIHkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:40:45 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Bryan Wu <cooloney@gmail.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/2] leds: trigger: gpio: make ledtrig-gpio useable with GPIO drivers requiring threaded irqs
Date: Tue,  9 Sep 2014 09:40:33 +0200
Message-Id: <1410248433-24005-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to use the LED GPIO trigger with e.g. the PCA953x GPIO
driver, request_irq() fails with -EINVAL, because the GPIO driver
requires a nested interrupt handler.

Use request_any_context_irq() to be able to use any GPIO driver as LED
trigger.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/leds/trigger/ledtrig-gpio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
index c86c418..b4168a7 100644
--- a/drivers/leds/trigger/ledtrig-gpio.c
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -161,10 +161,10 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
 		return n;
 	}
 
-	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
+	ret = request_any_context_irq(gpio_to_irq(gpio), gpio_trig_irq,
 			IRQF_SHARED | IRQF_TRIGGER_RISING
 			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "request_irq failed with error %d\n", ret);
 	} else {
 		if (gpio_data->gpio != 0)
@@ -172,7 +172,7 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
 		gpio_data->gpio = gpio;
 	}
 
-	return ret ? ret : n;
+	return ret < 0 ? ret : n;
 }
 static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
 
-- 
1.7.10.4

