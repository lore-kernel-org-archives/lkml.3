Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbbAZSGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:06:23 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54792 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbbAZSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:06:16 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] gpio: sysfs: fix gpio-chip device-attribute leak
Date: Mon, 26 Jan 2015 19:05:59 +0100
Message-Id: <1422295560-6284-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422295560-6284-1-git-send-email-johan@kernel.org>
References: <1422295496-6194-1-git-send-email-johan@kernel.org>
 <1422295560-6284-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 121b6a79955a3a3fd7bbb9b8cb88d5b9dad6283d upstream.

The gpio-chip device attributes were never destroyed when the device was
removed.

Fix by using device_create_with_groups() to create the device attributes
of the chip class device.

Note that this also fixes the attribute-creation race with userspace.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Cc: stable <stable@vger.kernel.org>	# v2.6.27+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[johan: fix leak without device_create_with_groups, which wasn't
introduced until 3.11 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0dee0e0c247a..bc3d59efe80b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -627,7 +627,7 @@ static ssize_t chip_ngpio_show(struct device *dev,
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
-static const struct attribute *gpiochip_attrs[] = {
+static struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
@@ -635,7 +635,7 @@ static const struct attribute *gpiochip_attrs[] = {
 };
 
 static const struct attribute_group gpiochip_attr_group = {
-	.attrs = (struct attribute **) gpiochip_attrs,
+	.attrs = gpiochip_attrs,
 };
 
 /*
@@ -1036,6 +1036,7 @@ static void gpiochip_unexport(struct gpio_chip *chip)
 	mutex_lock(&sysfs_lock);
 	dev = class_find_device(&gpio_class, NULL, chip, match_export);
 	if (dev) {
+		sysfs_remove_group(&dev->kobj, &gpiochip_attr_group);
 		put_device(dev);
 		device_unregister(dev);
 		chip->exported = 0;
-- 
2.0.5

