Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaIZJqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbaIZJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/142] media: au0828: Only alt setting logic when needed
Date: Fri, 26 Sep 2014 11:44:05 +0200
Message-Id: <c2c9d04ef4afefa2fa1bd5c9f213bc26987dfe18.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/au0828/au0828-video.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index f6154546b5c0..7ed75efa1c36 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -787,11 +787,27 @@ static int au0828_i2s_init(struct au0828_dev *dev)
 
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
@@ -1002,15 +1018,6 @@ static int au0828_v4l2_open(struct file *filp)
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
 
@@ -1252,13 +1259,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
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
-- 
2.1.0

