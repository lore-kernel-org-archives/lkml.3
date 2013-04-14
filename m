Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3DNSgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 14:36:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47473 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3DNSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:36:24 -0400
X-Auth-Info: 8aO/ZD8gJNLHHZbTbB1AISdXWrBZhyMwoxJfcQnrdiI=
From: Marek Vasut <marex@denx.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marek Vasut <marex@denx.de>, Linus Walleij <linus.walleij@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2] UCB1400: Pass ucb1400-gpio data through ac97 bus
Date: Sun, 14 Apr 2013 20:35:48 +0200
Message-Id: <1365964548-4193-1-git-send-email-marex@denx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
References: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/gpio/gpio-ucb1400.c |   19 ++++++-------------
 drivers/mfd/ucb1400_core.c  |    5 +++++
 include/linux/ucb1400.h     |   18 ++++++------------
 3 files changed, 17 insertions(+), 25 deletions(-)

v2: Rebase patch from:
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-October/028656.html

NOTE: I didn't even compile-test this, but the fix was plenty straightforward.

diff --git a/drivers/gpio/gpio-ucb1400.c b/drivers/gpio/gpio-ucb1400.c
index 26405ef..6d0feb2 100644
--- a/drivers/gpio/gpio-ucb1400.c
+++ b/drivers/gpio/gpio-ucb1400.c
@@ -12,8 +12,6 @@
 #include <linux/module.h>
 #include <linux/ucb1400.h>
 
-struct ucb1400_gpio_data *ucbdata;
-
 static int ucb1400_gpio_dir_in(struct gpio_chip *gc, unsigned off)
 {
 	struct ucb1400_gpio *gpio;
@@ -50,7 +48,7 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	struct ucb1400_gpio *ucb = dev->dev.platform_data;
 	int err = 0;
 
-	if (!(ucbdata && ucbdata->gpio_offset)) {
+	if (!(ucb && ucb->gpio_offset)) {
 		err = -EINVAL;
 		goto err;
 	}
@@ -58,7 +56,7 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, ucb);
 
 	ucb->gc.label = "ucb1400_gpio";
-	ucb->gc.base = ucbdata->gpio_offset;
+	ucb->gc.base = ucb->gpio_offset;
 	ucb->gc.ngpio = 10;
 	ucb->gc.owner = THIS_MODULE;
 
@@ -72,8 +70,8 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	if (err)
 		goto err;
 
-	if (ucbdata && ucbdata->gpio_setup)
-		err = ucbdata->gpio_setup(&dev->dev, ucb->gc.ngpio);
+	if (ucb && ucb->gpio_setup)
+		err = ucb->gpio_setup(&dev->dev, ucb->gc.ngpio);
 
 err:
 	return err;
@@ -85,8 +83,8 @@ static int ucb1400_gpio_remove(struct platform_device *dev)
 	int err = 0;
 	struct ucb1400_gpio *ucb = platform_get_drvdata(dev);
 
-	if (ucbdata && ucbdata->gpio_teardown) {
-		err = ucbdata->gpio_teardown(&dev->dev, ucb->gc.ngpio);
+	if (ucb && ucb->gpio_teardown) {
+		err = ucb->gpio_teardown(&dev->dev, ucb->gc.ngpio);
 		if (err)
 			return err;
 	}
@@ -103,11 +101,6 @@ static struct platform_driver ucb1400_gpio_driver = {
 	},
 };
 
-void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)
-{
-	ucbdata = data;
-}
-
 module_platform_driver(ucb1400_gpio_driver);
 
 MODULE_DESCRIPTION("Philips UCB1400 GPIO driver");
diff --git a/drivers/mfd/ucb1400_core.c b/drivers/mfd/ucb1400_core.c
index daf6952..e9031fa 100644
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -75,6 +75,11 @@ static int ucb1400_core_probe(struct device *dev)
 
 	/* GPIO */
 	ucb_gpio.ac97 = ac97;
+	if (pdata) {
+		ucb_gpio.gpio_setup = pdata->gpio_setup;
+		ucb_gpio.gpio_teardown = pdata->gpio_teardown;
+		ucb_gpio.gpio_offset = pdata->gpio_offset;
+	}
 	ucb->ucb1400_gpio = platform_device_alloc("ucb1400_gpio", -1);
 	if (!ucb->ucb1400_gpio) {
 		err = -ENOMEM;
diff --git a/include/linux/ucb1400.h b/include/linux/ucb1400.h
index d21b33c..2e9ee4d 100644
--- a/include/linux/ucb1400.h
+++ b/include/linux/ucb1400.h
@@ -83,15 +83,12 @@
 #define UCB_ID			0x7e
 #define UCB_ID_1400             0x4304
 
-struct ucb1400_gpio_data {
-	int gpio_offset;
-	int (*gpio_setup)(struct device *dev, int ngpio);
-	int (*gpio_teardown)(struct device *dev, int ngpio);
-};
-
 struct ucb1400_gpio {
 	struct gpio_chip	gc;
 	struct snd_ac97		*ac97;
+	int			gpio_offset;
+	int			(*gpio_setup)(struct device *dev, int ngpio);
+	int			(*gpio_teardown)(struct device *dev, int ngpio);
 };
 
 struct ucb1400_ts {
@@ -110,6 +107,9 @@ struct ucb1400 {
 
 struct ucb1400_pdata {
 	int	irq;
+	int	gpio_offset;
+	int	(*gpio_setup)(struct device *dev, int ngpio);
+	int	(*gpio_teardown)(struct device *dev, int ngpio);
 };
 
 static inline u16 ucb1400_reg_read(struct snd_ac97 *ac97, u16 reg)
@@ -162,10 +162,4 @@ static inline void ucb1400_adc_disable(struct snd_ac97 *ac97)
 unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
 			      int adcsync);
 
-#ifdef CONFIG_GPIO_UCB1400
-void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data);
-#else
-static inline void ucb1400_gpio_set_data(struct ucb1400_gpio_data *data) {}
-#endif
-
 #endif
-- 
1.7.10.4

