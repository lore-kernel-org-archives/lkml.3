Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbbA2BRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:41 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:42462 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbbA2BRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:38 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH v2] gpio: sysfs: fix gpio device-attribute leak
Date: Wed, 28 Jan 2015 17:05:05 +0100
Message-Id: <1422461105-815-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <20150128012627.464883057@linuxfoundation.org>
References: <20150128012627.464883057@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.

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
---

Backport to v3.10 (and earlier) which lacks device_create_with_groups().

Changes since v1
 - fix mistake in backport, which removed the attributes while holding
   the mutex in gpiod_unexport (reported by Luis Henriques)


 drivers/gpio/gpiolib.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index bc3d59efe80b..4ff40cf14910 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -362,7 +362,7 @@ static ssize_t gpio_value_store(struct device *dev,
 	return status;
 }
 
-static const DEVICE_ATTR(value, 0644,
+static DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
@@ -580,17 +580,17 @@ static ssize_t gpio_active_low_store(struct device *dev,
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
 
 static const struct attribute_group gpio_attr_group = {
-	.attrs = (struct attribute **) gpio_attrs,
+	.attrs = gpio_attrs,
 };
 
 /*
@@ -806,20 +806,24 @@ static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 	if (direction_may_change) {
 		status = device_create_file(dev, &dev_attr_direction);
 		if (status)
-			goto fail_unregister_device;
+			goto fail_remove_attr_group;
 	}
 
 	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
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
+fail_remove_attr_group:
+	sysfs_remove_group(&dev->kobj, &gpio_attr_group);
 fail_unregister_device:
 	device_unregister(dev);
 fail_unlock:
@@ -971,6 +975,9 @@ static void gpiod_unexport(struct gpio_desc *desc)
 	mutex_unlock(&sysfs_lock);
 
 	if (dev) {
+		device_remove_file(dev, &dev_attr_edge);
+		device_remove_file(dev, &dev_attr_direction);
+		sysfs_remove_group(&dev->kobj, &gpio_attr_group);
 		device_unregister(dev);
 		put_device(dev);
 	}
-- 
2.0.5

