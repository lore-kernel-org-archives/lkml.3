Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbbA1B2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbA1B2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 01/32] gpio: sysfs: fix gpio-chip device-attribute leak
Date: Tue, 27 Jan 2015 17:26:31 -0800
Message-Id: <20150128012627.344896738@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 121b6a79955a3a3fd7bbb9b8cb88d5b9dad6283d upstream.

The gpio-chip device attributes were never destroyed when the device was
removed.

Fix by using device_create_with_groups() to create the device attributes
of the chip class device.

Note that this also fixes the attribute-creation race with userspace.

Fixes: d8f388d8dc8d ("gpio: sysfs interface")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



---
 drivers/gpio/gpiolib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -627,7 +627,7 @@ static ssize_t chip_ngpio_show(struct de
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
-static const struct attribute *gpiochip_attrs[] = {
+static struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
@@ -635,7 +635,7 @@ static const struct attribute *gpiochip_
 };
 
 static const struct attribute_group gpiochip_attr_group = {
-	.attrs = (struct attribute **) gpiochip_attrs,
+	.attrs = gpiochip_attrs,
 };
 
 /*
@@ -1036,6 +1036,7 @@ static void gpiochip_unexport(struct gpi
 	mutex_lock(&sysfs_lock);
 	dev = class_find_device(&gpio_class, NULL, chip, match_export);
 	if (dev) {
+		sysfs_remove_group(&dev->kobj, &gpiochip_attr_group);
 		put_device(dev);
 		device_unregister(dev);
 		chip->exported = 0;


