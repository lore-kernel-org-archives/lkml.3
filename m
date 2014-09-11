Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaIKKn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:43:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42379 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaIKKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:43:56 -0400
Date: Thu, 11 Sep 2014 12:43:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, matti.vaittinen@nsn.com,
        robh+dt@kernel.org, akpm@linux-foundation.org,
        ijc+devicetree@hellion.org.uk, a.zummo@towertech.it,
        linux@roeck-us.net
Cc: rtc-linux@googlegroups.com
Subject: rtc: bq32000: add trickle charger option, with device tree binding
Message-ID: <20140911104355.GA16588@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BQ32000 devices have "trickle chargers".  Introduce a code to enable
the charger, based on device tree.

Without charger, RTC does not keep time after power off.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index c74bf0d..4c24fb0 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -2,10 +2,14 @@
  * Driver for TI BQ32000 RTC.
  *
  * Copyright (C) 2009 Semihalf.
+ * Copyright (C) 2014 Pavel Machek <pavel@denx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * You can get hardware description at
+ * http://www.ti.com/lit/ds/symlink/bq32000.pdf
  */
 
 #include <linux/module.h>
@@ -27,6 +31,10 @@
 #define BQ32K_CENT		0x40	/* Century flag */
 #define BQ32K_CENT_EN		0x80	/* Century flag enable bit */
 
+#define BQ32K_CALIBRATION	0x07	/* CAL_CFG1, calibration and control */
+#define BQ32K_TCH2		0x08	/* Trickle charge enable */
+#define BQ32K_CFG2		0x09	/* Trickle charger control */
+
 struct bq32k_regs {
 	uint8_t		seconds;
 	uint8_t		minutes;
@@ -122,6 +130,59 @@ static const struct rtc_class_ops bq32k_rtc_ops = {
 	.set_time	= bq32k_rtc_set_time,
 };
 
+static int trickle_charger_of_init(struct device *dev, struct device_node *node)
+{
+	int plen = 0;
+	const uint32_t *setup;
+	const uint32_t *reg;
+	int error;
+	u32 ohms = 0;
+
+	if (of_property_read_u32(node, "trickle-resistor-ohms" , &ohms))
+		return 0;
+
+	switch (ohms) {
+	case 180+940:
+		/*
+		 * TCHE[3:0] == 0x05, TCH2 == 1, TCFE == 0 (charging
+		 * over diode and 940ohm resistor)
+		 */
+
+		if (of_property_read_bool(node, "trickle-diode-disable")) {
+			dev_err(dev, "diode and resistor mismatch\n");
+			return -EINVAL;
+		}
+		reg = 0x05;
+		break;
+
+	case 180+20000:
+		/* diode disabled */
+
+		if (!of_property_read_bool(node, "trickle-diode-disable")) {
+			dev_err(dev, "bq32k: diode and resistor mismatch\n");
+			return -EINVAL;
+		}
+		reg = 0x25;
+		break;
+
+	default:
+		dev_err(dev, "invalid resistor value (%d)\n", *setup);
+		return -EINVAL;
+	}
+
+	error = bq32k_write(dev, &reg, BQ32K_CFG2, 1);
+	if (error)
+		return error;
+
+	reg = 0x20;
+	error = bq32k_write(dev, &reg, BQ32K_TCH2, 1);
+	if (error)
+		return error;
+
+	dev_info(dev, "Enabled trickle RTC battery charge.\n");
+	return 0;
+}
+
 static int bq32k_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -153,6 +214,10 @@ static int bq32k_probe(struct i2c_client *client,
 	if (error)
 		return error;
 
+	if (client && client->dev.of_node) {
+		trickle_charger_of_init(dev, client->dev.of_node);
+	}
+
 	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
