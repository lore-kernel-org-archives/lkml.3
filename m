Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbbAMMAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:00:37 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56114 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbAMMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:00:23 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] gpio: sysfs: fix gpio device-attribute leak
Date: Tue, 13 Jan 2015 13:00:05 +0100
Message-Id: <1421150406-20255-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421150406-20255-1-git-send-email-johan@kernel.org>
References: <1421150406-20255-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio device attributes were never destroyed when the gpio was
unexported (or on export failures).

Use device_create_with_groups() to create the default device attributes
of the gpio class device. Note that this also fixes the
attribute-creation race with userspace for these attributes.

Remove contingent attributes in export error path and on unexport.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Cc: stable <stable@vger.kernel.org>	# v2.6.27+
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 33cf4bd0ed2d..fd4d9423f6e6 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -128,7 +128,7 @@ static ssize_t gpio_value_store(struct device *dev,
 	return status;
 }
 
-static const DEVICE_ATTR(value, 0644,
+static DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
@@ -353,18 +353,15 @@ static ssize_t gpio_active_low_store(struct device *dev,
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
-
-static const struct attribute_group gpio_attr_group = {
-	.attrs = (struct attribute **) gpio_attrs,
-};
+ATTRIBUTE_GROUPS(gpio);
 
 /*
  * /sys/class/gpio/gpiochipN/
@@ -561,18 +558,15 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
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
@@ -583,13 +577,15 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
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
@@ -723,6 +719,8 @@ void gpiod_unexport(struct gpio_desc *desc)
 	mutex_unlock(&sysfs_lock);
 
 	if (dev) {
+		device_remove_file(dev, &dev_attr_edge);
+		device_remove_file(dev, &dev_attr_direction);
 		device_unregister(dev);
 		put_device(dev);
 	}
-- 
2.0.5

