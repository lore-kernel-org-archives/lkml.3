Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbbAZSF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:05:56 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44314 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAZSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:05:27 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] gpio: sysfs: fix gpio device-attribute leak
Date: Mon, 26 Jan 2015 19:04:56 +0100
Message-Id: <1422295496-6194-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422295496-6194-1-git-send-email-johan@kernel.org>
References: <1422295496-6194-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.

The gpio device attributes were never destroyed when the gpio was
unexported (or on export failures).

Use device_create_with_groups() to create the default device attributes
of the gpio class device. Note that this also fixes the
attribute-creation race with userspace for these attributes.

Remove contingent attributes in export error path and on unexport.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Cc: stable <stable@vger.kernel.org> # v2.6.27+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index dd4d6ffacc30..8380709b66d2 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -362,7 +362,7 @@ static ssize_t gpio_value_store(struct device *dev,
 	return status;
 }
 
-static const DEVICE_ATTR(value, 0644,
+static DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
@@ -580,18 +580,16 @@ static ssize_t gpio_active_low_store(struct device *dev,
 	return status ? : size;
 }
 
-static const DEVICE_ATTR(active_low, 0644,
+static DEVICE_ATTR(active_low, 0644,
 		gpio_active_low_show, gpio_active_low_store);
 
-static const struct attribute *gpio_attrs[] = {
+static struct attribute *gpio_attrs[] = {
 	&dev_attr_value.attr,
 	&dev_attr_active_low.attr,
 	NULL,
 };
 
-static const struct attribute_group gpio_attr_group = {
-	.attrs = (struct attribute **) gpio_attrs,
-};
+ATTRIBUTE_GROUPS(gpio);
 
 /*
  * /sys/class/gpio/gpiochipN/
@@ -788,18 +786,15 @@ static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 	if (desc->chip->names && desc->chip->names[offset])
 		ioname = desc->chip->names[offset];
 
-	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-			    desc, ioname ? ioname : "gpio%u",
-			    desc_to_gpio(desc));
+	dev = device_create_with_groups(&gpio_class, desc->chip->dev,
+					MKDEV(0, 0), desc, gpio_groups,
+					ioname ? ioname : "gpio%u",
+					desc_to_gpio(desc));
 	if (IS_ERR(dev)) {
 		status = PTR_ERR(dev);
 		goto fail_unlock;
 	}
 
-	status = sysfs_create_group(&dev->kobj, &gpio_attr_group);
-	if (status)
-		goto fail_unregister_device;
-
 	if (direction_may_change) {
 		status = device_create_file(dev, &dev_attr_direction);
 		if (status)
@@ -810,13 +805,15 @@ static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
 		status = device_create_file(dev, &dev_attr_edge);
 		if (status)
-			goto fail_unregister_device;
+			goto fail_remove_attr_direction;
 	}
 
 	set_bit(FLAG_EXPORT, &desc->flags);
 	mutex_unlock(&sysfs_lock);
 	return 0;
 
+fail_remove_attr_direction:
+	device_remove_file(dev, &dev_attr_direction);
 fail_unregister_device:
 	device_unregister(dev);
 fail_unlock:
@@ -959,6 +956,8 @@ static void gpiod_unexport(struct gpio_desc *desc)
 
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
+			device_remove_file(dev, &dev_attr_edge);
+			device_remove_file(dev, &dev_attr_direction);
 			gpio_setup_irq(desc, dev, 0);
 			clear_bit(FLAG_EXPORT, &desc->flags);
 		} else
-- 
2.0.5

