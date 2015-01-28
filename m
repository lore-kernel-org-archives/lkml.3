Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbbA2KUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:20:40 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756803AbbA2JAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:55 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/176] gpio: sysfs: fix gpio-chip device-attribute leak
Date: Wed, 28 Jan 2015 15:29:29 +0100
Message-Id: <475d5e6757dbc30fab3b0ed54aa5ae0a7afac194.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 121b6a79955a3a3fd7bbb9b8cb88d5b9dad6283d upstream.

The gpio-chip device attributes were never destroyed when the device was
removed.

Fix by using device_create_with_groups() to create the device attributes
of the chip class device.

Note that this also fixes the attribute-creation race with userspace.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpio/gpiolib.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index aed1a6216b6b..b5d0fff2cd5a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -627,16 +627,13 @@ static ssize_t chip_ngpio_show(struct device *dev,
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
@@ -1001,13 +998,13 @@ static int gpiochip_export(struct gpio_chip *chip)
 
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
2.2.2

