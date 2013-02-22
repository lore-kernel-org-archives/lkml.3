Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3BVJfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:35:13 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:48943 "EHLO mailhub2.si.c-s.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755236Ab3BVJfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:35:07 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 04:35:07 EST
Date: Fri, 22 Feb 2013 10:26:03 +0100
Message-Id: <201302220926.r1M9Q3wV029855@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Patrick Vasseur <patrick.vasseur@c-s.fr>
Subject: [PATCH] Adds support for Open Firmware in MAX730x GPIO Driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the use of the MAX730x Driver on systems using
the Open Firmware platform format

Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur linux-3.7.9/drivers/gpio/gpio-max7301.c linux/drivers/gpio/gpio-max7301.c
--- linux-3.7.9/drivers/gpio/gpio-max7301.c	2013-02-17 19:53:32.000000000 +0100
+++ linux/drivers/gpio/gpio-max7301.c	2013-02-17 12:57:40.000000000 +0100
@@ -56,7 +56,8 @@
 	int ret;
 
 	/* bits_per_word cannot be configured in platform data */
-	spi->bits_per_word = 16;
+	if (spi->dev.platform_data)
+		spi->bits_per_word = 16;
 	ret = spi_setup(spi);
 	if (ret < 0)
 		return ret;
diff -ur linux-3.7.9/drivers/gpio/gpio-max730x.c linux/drivers/gpio/gpio-max730x.c
--- linux-3.7.9/drivers/gpio/gpio-max730x.c	2013-02-17 19:53:32.000000000 +0100
+++ linux/drivers/gpio/gpio-max730x.c	2013-02-22 10:15:46.000000000 +0100
@@ -163,12 +163,13 @@
 int __devinit __max730x_probe(struct max7301 *ts)
 {
 	struct device *dev = ts->dev;
+	struct device_node *np = dev->of_node;
 	struct max7301_platform_data *pdata;
 	int i, ret;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->base) {
-		dev_err(dev, "incorrect or missing platform data\n");
+	if ((!pdata || !pdata->base) && !np) {
+		dev_err(dev, "No platform data nor Device Tree found\n");
 		return -EINVAL;
 	}
 
@@ -178,7 +179,6 @@
 	/* Power up the chip and disable IRQ output */
 	ts->write(dev, 0x04, 0x01);
 
-	ts->input_pullup_active = pdata->input_pullup_active;
 	ts->chip.label = dev->driver->name;
 
 	ts->chip.direction_input = max7301_direction_input;
@@ -186,7 +186,12 @@
 	ts->chip.direction_output = max7301_direction_output;
 	ts->chip.set = max7301_set;
 
-	ts->chip.base = pdata->base;
+	if (pdata) {
+		ts->input_pullup_active = pdata->input_pullup_active;
+		ts->chip.base = pdata->base;
+	} else {
+		ts->chip.base = -1;
+	}
 	ts->chip.ngpio = PIN_NUMBER;
 	ts->chip.can_sleep = 1;
 	ts->chip.dev = dev;
