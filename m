Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbaIOUH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:07:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbaIOTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 03/71] media: au0828: Only alt setting logic when needed
Date: Mon, 15 Sep 2014 12:26:01 -0700
Message-Id: <20140915192638.824264570@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 64ea37bbd8a5815522706f0099ad3f11c7537e15 upstream.

It seems that there's a bug at au0828 hardware/firmware
related to alternate setting: when the device is already at
alt 5, a further call causes the URBs to receive -ESHUTDOWN.

I found two different encarnations of this issue:

1) at qv4l2, it fails the second time we try to open the
video screen;
2) at xawtv, when audio underrun occurs, with is very
frequent, at least on my test machine.

The fix is simple: just check if alt=5 before calling
set_usb_interface().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/au0828/au0828-video.c |   34 ++++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -788,11 +788,27 @@ static int au0828_i2s_init(struct au0828
 
 /*
  * Auvitek au0828 analog stream enable
- * Please set interface0 to AS5 before enable the stream
  */
 static int au0828_analog_stream_enable(struct au0828_dev *d)
 {
+	struct usb_interface *iface;
+	int ret;
+
 	dprintk(1, "au0828_analog_stream_enable called\n");
+
+	iface = usb_ifnum_to_if(d->usbdev, 0);
+	if (iface && iface->cur_altsetting->desc.bAlternateSetting != 5) {
+		dprintk(1, "Changing intf#0 to alt 5\n");
+		/* set au0828 interface0 to AS5 here again */
+		ret = usb_set_interface(d->usbdev, 0, 5);
+		if (ret < 0) {
+			printk(KERN_INFO "Au0828 can't set alt setting to 5!\n");
+			return -EBUSY;
+		}
+	}
+
+	/* FIXME: size should be calculated using d->width, d->height */
+
 	au0828_writereg(d, AU0828_SENSORCTRL_VBI_103, 0x00);
 	au0828_writereg(d, 0x106, 0x00);
 	/* set x position */
@@ -1003,15 +1019,6 @@ static int au0828_v4l2_open(struct file
 		return -ERESTARTSYS;
 	}
 	if (dev->users == 0) {
-		/* set au0828 interface0 to AS5 here again */
-		ret = usb_set_interface(dev->usbdev, 0, 5);
-		if (ret < 0) {
-			mutex_unlock(&dev->lock);
-			printk(KERN_INFO "Au0828 can't set alternate to 5!\n");
-			kfree(fh);
-			return -EBUSY;
-		}
-
 		au0828_analog_stream_enable(dev);
 		au0828_analog_stream_reset(dev);
 
@@ -1253,13 +1260,6 @@ static int au0828_set_format(struct au08
 		}
 	}
 
-	/* set au0828 interface0 to AS5 here again */
-	ret = usb_set_interface(dev->usbdev, 0, 5);
-	if (ret < 0) {
-		printk(KERN_INFO "Au0828 can't set alt setting to 5!\n");
-		return -EBUSY;
-	}
-
 	au0828_analog_stream_enable(dev);
 
 	return 0;


