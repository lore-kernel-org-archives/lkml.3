Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaIVPIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:08:13 -0400
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:43075 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbaIVPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:16 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.co, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 5/5] media: au0828-core changes to create and destroy media token res
Date: Mon, 22 Sep 2014 09:00:49 -0600
Message-Id: <80d31dd3dbe205c9a462aa6dcae2c25de332259a.1411397045.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed au0828-core to create media token resource in its
usb_probe() and destroy it from usb_disconnect() interfaces.
It creates the resource on the main struct device which is
the parent device for the interface usb device. This is the
main struct device that is common for all the drivers that
control the media device, including the non-media sound
drivers.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bc06480..189e435 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -26,6 +26,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/media_tknres.h>
 
 /*
  * 1 = General debug messages
@@ -127,6 +128,17 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	return status;
 }
 
+/* interfaces to create and destroy media tknres */
+static int au0828_create_media_tknres(struct au0828_dev *dev)
+{
+	return media_tknres_create(&dev->usbdev->dev);
+}
+
+static int au0828_destroy_media_tknres(struct au0828_dev *dev)
+{
+	return media_tknres_destroy(&dev->usbdev->dev);
+}
+
 static void au0828_usb_release(struct au0828_dev *dev)
 {
 	/* I2C */
@@ -157,6 +169,8 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
 
+	au0828_destroy_media_tknres(dev);
+
 	usb_set_intfdata(interface, NULL);
 	mutex_lock(&dev->mutex);
 	dev->usbdev = NULL;
@@ -215,6 +229,13 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	dev->usbdev = usbdev;
 	dev->boardnr = id->driver_info;
 
+	/* create media token resource */
+	if (au0828_create_media_tknres(dev)) {
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return -ENOMEM;
+	}
+
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	dev->v4l2_dev.release = au0828_usb_v4l2_release;
 
@@ -223,6 +244,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() v4l2_device_register failed\n",
 		       __func__);
+		au0828_destroy_media_tknres(dev);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
@@ -232,6 +254,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() v4l2_ctrl_handler_init failed\n",
 		       __func__);
+		au0828_destroy_media_tknres(dev);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
-- 
1.7.10.4

