Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbbAMMAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:00:38 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:53840 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:00:23 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3/3] gpio: sysfs: fix gpio attribute-creation race
Date: Tue, 13 Jan 2015 13:00:06 +0100
Message-Id: <1421150406-20255-4-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421150406-20255-1-git-send-email-johan@kernel.org>
References: <1421150406-20255-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix attribute-creation race with userspace by using the default group
to create also the contingent gpio device attributes.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 61 ++++++++++++++++++++++++++++----------------
 drivers/gpio/gpiolib.h       |  1 +
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index fd4d9423f6e6..f62aa115d79a 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -356,12 +356,44 @@ static ssize_t gpio_active_low_store(struct device *dev,
 static DEVICE_ATTR(active_low, 0644,
 		gpio_active_low_show, gpio_active_low_store);
 
+static umode_t gpio_is_visible(struct kobject *kobj, struct attribute *attr,
+			       int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gpio_desc *desc = dev_get_drvdata(dev);
+	umode_t mode = attr->mode;
+	bool show_direction = test_bit(FLAG_SYSFS_DIR, &desc->flags);
+
+	if (attr == &dev_attr_direction.attr) {
+		if (!show_direction)
+			mode = 0;
+	} else if (attr == &dev_attr_edge.attr) {
+		if (gpiod_to_irq(desc) < 0)
+			mode = 0;
+		if (!show_direction && test_bit(FLAG_IS_OUT, &desc->flags))
+			mode = 0;
+	}
+
+	return mode;
+}
+
 static struct attribute *gpio_attrs[] = {
+	&dev_attr_direction.attr,
+	&dev_attr_edge.attr,
 	&dev_attr_value.attr,
 	&dev_attr_active_low.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(gpio);
+
+static const struct attribute_group gpio_group = {
+	.attrs = gpio_attrs,
+	.is_visible = gpio_is_visible,
+};
+
+static const struct attribute_group *gpio_groups[] = {
+	&gpio_group,
+	NULL
+};
 
 /*
  * /sys/class/gpio/gpiochipN/
@@ -550,8 +582,11 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 		goto fail_unlock;
 	}
 
-	if (!desc->chip->direction_input || !desc->chip->direction_output)
-		direction_may_change = false;
+	if (desc->chip->direction_input && desc->chip->direction_output &&
+			direction_may_change) {
+		set_bit(FLAG_SYSFS_DIR, &desc->flags);
+	}
+
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	offset = gpio_chip_hwgpio(desc);
@@ -567,27 +602,10 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 		goto fail_unlock;
 	}
 
-	if (direction_may_change) {
-		status = device_create_file(dev, &dev_attr_direction);
-		if (status)
-			goto fail_unregister_device;
-	}
-
-	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
-				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
-		status = device_create_file(dev, &dev_attr_edge);
-		if (status)
-			goto fail_remove_attr_direction;
-	}
-
 	set_bit(FLAG_EXPORT, &desc->flags);
 	mutex_unlock(&sysfs_lock);
 	return 0;
 
-fail_remove_attr_direction:
-	device_remove_file(dev, &dev_attr_direction);
-fail_unregister_device:
-	device_unregister(dev);
 fail_unlock:
 	mutex_unlock(&sysfs_lock);
 	gpiod_dbg(desc, "%s: status %d\n", __func__, status);
@@ -711,6 +729,7 @@ void gpiod_unexport(struct gpio_desc *desc)
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
 			gpio_setup_irq(desc, dev, 0);
+			clear_bit(FLAG_SYSFS_DIR, &desc->flags);
 			clear_bit(FLAG_EXPORT, &desc->flags);
 		} else
 			status = -ENODEV;
@@ -719,8 +738,6 @@ void gpiod_unexport(struct gpio_desc *desc)
 	mutex_unlock(&sysfs_lock);
 
 	if (dev) {
-		device_remove_file(dev, &dev_attr_edge);
-		device_remove_file(dev, &dev_attr_direction);
 		device_unregister(dev);
 		put_device(dev);
 	}
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index e3a52113a541..550a5eafbd38 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -77,6 +77,7 @@ struct gpio_desc {
 #define FLAG_OPEN_DRAIN	7	/* Gpio is open drain type */
 #define FLAG_OPEN_SOURCE 8	/* Gpio is open source type */
 #define FLAG_USED_AS_IRQ 9	/* GPIO is connected to an IRQ */
+#define FLAG_SYSFS_DIR	10	/* show sysfs direction attribute */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
-- 
2.0.5

