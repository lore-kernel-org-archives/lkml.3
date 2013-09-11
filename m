Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3IKCZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:25:19 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46479 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3IKCZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:25:17 -0400
Date: Tue, 10 Sep 2013 19:25:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 3/6] extcon-gpio: Add support for active-low presence
 detect pins
Message-ID: <20130911022513.GA5251@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-4-git-send-email-linux@roeck-us.net>
 <522FD20C.6080404@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522FD20C.6080404@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Document gpio_active_low variable in gpio_extcon_platform_data
    Rewrite active-low logic to be easier to read.

 drivers/extcon/extcon-gpio.c       |    4 ++++
 include/linux/extcon/extcon-gpio.h |    5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 862743b..8491f86 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -34,6 +34,7 @@
 struct gpio_extcon_data {
 	struct extcon_dev edev;
 	unsigned gpio;
+	bool gpio_active_low;
 	const char *state_on;
 	const char *state_off;
 	int irq;
@@ -49,6 +50,8 @@ static void gpio_extcon_work(struct work_struct *work)
 			     work);
 
 	state = gpio_get_value(data->gpio);
+	if (data->gpio_active_low)
+		state = !state;
 	extcon_set_state(&data->edev, state);
 }
 
@@ -96,6 +99,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 
 	extcon_data->edev.name = pdata->name;
 	extcon_data->gpio = pdata->gpio;
+	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
 	if (pdata->state_on && pdata->state_off)
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 2d8307f..51ef15c 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -27,6 +27,10 @@
  * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
  * @name	The name of this GPIO extcon device.
  * @gpio	Corresponding GPIO.
+ * @gpio_active_low:
+ * 		Boolean describing whether gpio active state is 1 or 0
+ * 		If true, low state of gpio means active.
+ * 		If false, high state of gpio means active.
  * @debounce	Debounce time for GPIO IRQ in ms.
  * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
  * @state_on	print_state is overriden with state_on if attached. If Null,
@@ -41,6 +45,7 @@
 struct gpio_extcon_platform_data {
 	const char *name;
 	unsigned gpio;
+	bool gpio_active_low;
 	unsigned long debounce;
 	unsigned long irq_flags;
 
-- 
1.7.9.7

