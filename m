Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaIHWK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:10:56 -0400
Received: from mail.ispras.ru ([83.149.199.45]:37284 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbaIHWKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:10:54 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sean Young <sean@mess.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] mceusb: fix usbdev leak
Date: Tue,  9 Sep 2014 02:10:43 +0400
Message-Id: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mceusb_init_rc_dev() does usb_get_dev(), but there is no any
usb_put_dev() in the driver.

The patch tries to straighten logic. It moves usb_get_dev()
directly to mceusb_dev_probe() and adds usb_put_dev() to an error path
and to mceusb_dev_disconnect().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/rc/mceusb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 45b0894288e5..23e532da0cf7 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1198,10 +1198,9 @@ static void mceusb_flash_led(struct mceusb_dev *ir)
 	mce_async_out(ir, FLASH_LED, sizeof(FLASH_LED));
 }
 
-static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir,
-					 struct usb_interface *intf)
+static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 {
-	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
+	struct usb_device *udev = ir->usbdev;
 	struct device *dev = ir->dev;
 	struct rc_dev *rc;
 	int ret;
@@ -1341,7 +1340,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	if (!ir->urb_in)
 		goto urb_in_alloc_fail;
 
-	ir->usbdev = dev;
+	ir->usbdev = usb_get_dev(dev);
 	ir->dev = &intf->dev;
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
@@ -1362,7 +1361,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	ir->rc = mceusb_init_rc_dev(ir, intf);
+	ir->rc = mceusb_init_rc_dev(ir);
 	if (!ir->rc)
 		goto rc_dev_fail;
 
@@ -1408,6 +1407,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	/* Error-handling path */
 rc_dev_fail:
+	usb_put_dev(ir->usbdev);
 	usb_free_urb(ir->urb_in);
 urb_in_alloc_fail:
 	usb_free_coherent(dev, maxp, ir->buf_in, ir->dma_in);
@@ -1435,6 +1435,7 @@ static void mceusb_dev_disconnect(struct usb_interface *intf)
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
+	usb_put_dev(dev);
 
 	kfree(ir);
 }
-- 
1.9.1

