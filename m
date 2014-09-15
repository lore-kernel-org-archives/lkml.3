Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbaIOVgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:36:47 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57820 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbaIOVgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:36:44 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Kevin Baradon <kevin.baradon@gmail.com>, Sean Young <sean@mess.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] imon: fix usbdev leaks
Date: Tue, 16 Sep 2014 01:36:15 +0400
Message-Id: <1410816975-5334-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54106920.7000103@ispras.ru>
References: <54106920.7000103@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imon_probe() does three usb_get_dev(), but there is no any
usb_put_dev() in the driver.

The patch adds usb_put_dev() to error paths, to imon_disconnect()
and to imon_probe() as far as usbdev is not saved anywhere.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/rc/imon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7115e68ba697..06ff61ec3e1e 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2181,6 +2181,7 @@ idev_setup_failed:
 	usb_kill_urb(ictx->rx_urb_intf0);
 urb_submit_failed:
 find_endpoint_failed:
+	usb_put_dev(ictx->usbdev_intf0);
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(tx_urb);
 tx_urb_alloc_failed:
@@ -2253,6 +2254,7 @@ urb_submit_failed:
 		input_unregister_device(ictx->touch);
 touch_setup_failed:
 find_endpoint_failed:
+	usb_put_dev(ictx->usbdev_intf1);
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(rx_urb);
 rx_urb_alloc_failed:
@@ -2366,11 +2368,13 @@ static int imon_probe(struct usb_interface *interface,
 		 usbdev->bus->busnum, usbdev->devnum);
 
 	mutex_unlock(&driver_lock);
+	usb_put_dev(usbdev);
 
 	return 0;
 
 fail:
 	mutex_unlock(&driver_lock);
+	usb_put_dev(usbdev);
 	dev_err(dev, "unable to register, err %d\n", ret);
 
 	return ret;
@@ -2410,6 +2414,7 @@ static void imon_disconnect(struct usb_interface *interface)
 	if (ifnum == 0) {
 		ictx->dev_present_intf0 = false;
 		usb_kill_urb(ictx->rx_urb_intf0);
+		usb_put_dev(ictx->usbdev_intf0);
 		input_unregister_device(ictx->idev);
 		rc_unregister_device(ictx->rdev);
 		if (ictx->display_supported) {
@@ -2421,6 +2426,7 @@ static void imon_disconnect(struct usb_interface *interface)
 	} else {
 		ictx->dev_present_intf1 = false;
 		usb_kill_urb(ictx->rx_urb_intf1);
+		usb_put_dev(ictx->usbdev_intf1);
 		if (ictx->display_type == IMON_DISPLAY_TYPE_VGA) {
 			input_unregister_device(ictx->touch);
 			del_timer_sync(&ictx->ttimer);
-- 
1.9.1

