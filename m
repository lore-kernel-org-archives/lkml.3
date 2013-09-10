Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3IJQXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:23:22 -0400
Received: from mail.tpi.com ([74.45.170.26]:58065 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3IJQXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:23:21 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.12-rc1] USB: input: cm109.c: Convert high volume dev_err() to dev_err_ratelimited()
Date: Tue, 10 Sep 2013 10:23:13 -0600
Message-Id: <1378830193-48384-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1222850

This input device can get into a state that produces a high
volume of device status errors. Attempt to throttle these
error messages such that the kernel log is not flooded.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/input/misc/cm109.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 082684e..8ec72bc 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -351,7 +351,8 @@ static void cm109_urb_irq_callback(struct urb *urb)
 	if (status) {
 		if (status == -ESHUTDOWN)
 			return;
-		dev_err(&dev->intf->dev, "%s: urb status %d\n", __func__, status);
+		dev_err_ratelimited(&dev->intf->dev, "%s: urb status %d\n",
+			__func__, status);
 	}
 
 	/* Special keys */
@@ -419,7 +420,8 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 	     dev->ctl_data->byte[3]);
 
 	if (status)
-		dev_err(&dev->intf->dev, "%s: urb status %d\n", __func__, status);
+		dev_err_ratelimited(&dev->intf->dev, "%s: urb status %d\n",
+			__func__, status);
 
 	spin_lock(&dev->ctl_submit_lock);
 
@@ -436,7 +438,7 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 			dev->irq_urb_pending = 1;
 			error = usb_submit_urb(dev->urb_irq, GFP_ATOMIC);
 			if (error)
-				dev_err(&dev->intf->dev,
+				dev_err_ratelimited(&dev->intf->dev,
 					"%s: usb_submit_urb (urb_irq) failed %d\n",
 					__func__, error);
 		}
@@ -480,7 +482,7 @@ static void cm109_toggle_buzzer_sync(struct cm109_dev *dev, int on)
 				dev->ctl_data,
 				USB_PKT_LEN, USB_CTRL_SET_TIMEOUT);
 	if (error < 0 && error != -EINTR)
-		dev_err(&dev->intf->dev, "%s: usb_control_msg() failed %d\n",
+		dev_err_ratelimited(&dev->intf->dev, "%s: usb_control_msg() failed %d\n",
 			__func__, error);
 }
 
@@ -542,8 +544,9 @@ static int cm109_input_open(struct input_dev *idev)
 
 	error = usb_submit_urb(dev->urb_ctl, GFP_KERNEL);
 	if (error)
-		dev_err(&dev->intf->dev, "%s: usb_submit_urb (urb_ctl) failed %d\n",
-			__func__, error);
+		dev_err_ratelimited(&dev->intf->dev,
+			"%s: usb_submit_urb (urb_ctl) failed %d\n", __func__,
+			error);
 	else
 		dev->open = 1;
 
@@ -716,7 +719,7 @@ static int cm109_usb_probe(struct usb_interface *intf,
 	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
 	ret = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
 	if (ret != USB_PKT_LEN)
-		dev_err(&intf->dev, "invalid payload size %d, expected %d\n",
+		dev_err_ratelimited(&intf->dev, "invalid payload size %d, expected %d\n",
 			ret, USB_PKT_LEN);
 
 	/* initialise irq urb */
-- 
1.7.9.5

