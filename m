Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3H3E37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:29:59 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63509 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab3H3E35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:29:57 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/6] extcon-gpio: Add support for active-low presence detect pins
Date: Thu, 29 Aug 2013 21:29:35 -0700
Message-Id: <1377836978-24082-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/extcon/extcon-gpio.c       |    4 +++-
 include/linux/extcon/extcon-gpio.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 973600e..d4e3c89 100644
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
@@ -48,7 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
 		container_of(to_delayed_work(work), struct gpio_extcon_data,
 			     work);
 
-	state = gpio_get_value(data->gpio);
+	state = gpio_get_value(data->gpio) ^ data->gpio_active_low;
 	extcon_set_state(&data->edev, state);
 }
 
@@ -96,6 +97,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 
 	extcon_data->edev.name = pdata->name;
 	extcon_data->gpio = pdata->gpio;
+	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
 	if (pdata->state_on && pdata->state_off)
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 2d8307f..1613899 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -41,6 +41,7 @@
 struct gpio_extcon_platform_data {
 	const char *name;
 	unsigned gpio;
+	bool gpio_active_low;
 	unsigned long debounce;
 	unsigned long irq_flags;
 
-- 
1.7.9.7

