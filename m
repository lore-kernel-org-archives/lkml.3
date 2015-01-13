Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbbAMMBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:01:23 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:53748 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbAMMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:00:23 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] gpio: sysfs: fix gpio-chip device-attribute leak
Date: Tue, 13 Jan 2015 13:00:04 +0100
Message-Id: <1421150406-20255-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421150406-20255-1-git-send-email-johan@kernel.org>
References: <1421150406-20255-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio-chip device attributes were never destroyed when the device was
removed.

Fix by using device_create_with_groups() to create the device attributes
of the chip class device.

Note that this also fixes the attribute-creation race with userspace.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Cc: stable <stable@vger.kernel.org>	# v2.6.27+
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 2ac1800b58bb..33cf4bd0ed2d 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -400,16 +400,13 @@ static ssize_t chip_ngpio_show(struct device *dev,
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
-static const struct attribute *gpiochip_attrs[] = {
+static struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
 	NULL,
 };
-
-static const struct attribute_group gpiochip_attr_group = {
-	.attrs = (struct attribute **) gpiochip_attrs,
-};
+ATTRIBUTE_GROUPS(gpiochip);
 
 /*
  * /sys/class/gpio/export ... write-only
@@ -750,13 +747,13 @@ int gpiochip_export(struct gpio_chip *chip)
 
 	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
-				"gpiochip%d", chip->base);
-	if (!IS_ERR(dev)) {
-		status = sysfs_create_group(&dev->kobj,
-				&gpiochip_attr_group);
-	} else
+	dev = device_create_with_groups(&gpio_class, chip->dev, MKDEV(0, 0),
+					chip, gpiochip_groups,
+					"gpiochip%d", chip->base);
+	if (IS_ERR(dev))
 		status = PTR_ERR(dev);
+	else
+		status = 0;
 	chip->exported = (status == 0);
 	mutex_unlock(&sysfs_lock);
 
-- 
2.0.5

