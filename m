Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbbAPWzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:55:39 -0500
Received: from mail.ispras.ru ([83.149.199.45]:34802 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbAPWzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:55:37 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Antti Palosaari <crope@iki.fi>,
        Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] cx231xx: fix usbdev leak on failure paths in cx231xx_usb_probe()
Date: Sat, 17 Jan 2015 01:55:26 +0300
Message-Id: <1421448926-8595-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b7085c086475 ("cx231xx: convert from pr_foo to dev_foo")
moves usb_get_dev(interface_to_usbdev(interface)) to the beginning
of cx231xx_usb_probe() to use udev->dev in dev_err(),
but it does not make sure usbdev is put on all failure paths.

Later dev_err(udev->dev) was replaced by dev_err(d).
So the patch moves usb_get_dev() below (before the first use)
and fixes another failure path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index ae05d591f228..33c2fa2e7596 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1403,7 +1403,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
-	udev = usb_get_dev(interface_to_usbdev(interface));
 
 	/*
 	 * Interface number 0 - IR interface (handled by mceusb driver)
@@ -1424,11 +1423,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		}
 	} while (test_and_set_bit(nr, &cx231xx_devused));
 
+	udev = usb_get_dev(interface_to_usbdev(interface));
+
 	/* allocate memory for our device state and initialize it */
 	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		clear_bit(nr, &cx231xx_devused);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_if;
 	}
 
 	snprintf(dev->name, 29, "cx231xx #%d", nr);
-- 
1.9.1

