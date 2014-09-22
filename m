Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaIVPHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:07:18 -0400
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:38444 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbaIVPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:14 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.co, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 3/5] media: au0828-video changes to use media tuner token api
Date: Mon, 22 Sep 2014 09:00:47 -0600
Message-Id: <e1ed3e8cd42001e7d1e2b61b90815170c9b49b67.1411397045.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828-video driver uses vb1 api and needs changes to vb1
v4l2 interfaces that change the tuner status. In addition
to that this driver initializes the tuner from a some ioctls
that are query (read) tuner status. These ioctls are changed
to hold the tuner token to avoid disrupting digital stream
if active. Further more, release v4l2_file_operations powers
down the tuner. The following changes are made:

read, poll v4l2_file_operations:
- hold tuner in shared analog mode
- return leaving tuner in shared mode

vb1 streamon:
- hold tuner in shared analog mode
- return leaving tuner in shared mode

release v4l2_file_operations:
- hold tuner in exclusive analog mode to power down.
  Don't call s_power when tuner is busy.

Initialize dev_parent field struct video_device to enable
media tuner token lookup from v4l2-core.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c |   43 ++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..52a3644 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/media_tknres.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -1085,10 +1086,21 @@ static int au0828_v4l2_close(struct file *filp)
 
 		au0828_uninit_isoc(dev);
 
+		ret = media_get_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
+		if (ret) {
+			dev_info(&dev->usbdev->dev,
+					"%s: Tuner is busy\n", __func__);
+			/* don't touch tuner and usb device interface */
+			goto skip_s_power;
+		}
+		dev_info(&dev->usbdev->dev, "%s: Putting tuner to sleep\n",
+					__func__);
 		/* Save some power by putting tuner to sleep */
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
-		dev->std_set_in_tuner_core = 0;
+		media_put_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
 
+skip_s_power:
+		dev->std_set_in_tuner_core = 0;
 		/* When close the device, set the usb intf0 into alt0 to free
 		   USB bandwidth */
 		ret = usb_set_interface(dev->usbdev, 0, 0);
@@ -1136,6 +1148,12 @@ static ssize_t au0828_v4l2_read(struct file *filp, char __user *buf,
 	if (rc < 0)
 		return rc;
 
+	/* don't put the tuner token - this case is same as STREAMON */
+	rc = media_get_shared_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
+	if (rc) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
 	au0828_init_tuner(dev);
@@ -1177,6 +1195,12 @@ static unsigned int au0828_v4l2_poll(struct file *filp, poll_table *wait)
 	if (check_dev(dev) < 0)
 		return POLLERR;
 
+	/* don't put the tuner token - this case is same as STREAMON */
+	res = media_get_shared_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
+	if (res) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
 	res = v4l2_ctrl_poll(filp, wait);
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
@@ -1548,16 +1572,24 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
+	int ret;
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	ret = media_get_shared_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
+	if (ret) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
+
 	strcpy(t->name, "Auvitek tuner");
 
 	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 	i2c_gate_ctrl(dev, 0);
+	media_put_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
 	return 0;
 }
 
@@ -1682,6 +1714,12 @@ static int vidioc_streamon(struct file *file, void *priv,
 	dprintk(1, "vidioc_streamon fh=%p t=%d fh->res=%d dev->res=%d\n",
 		fh, type, fh->resources, dev->resources);
 
+	rc = media_get_shared_tuner_tkn(&dev->usbdev->dev, MEDIA_MODE_ANALOG);
+	if (rc) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
+
 	if (unlikely(!res_get(fh, get_ressource(fh))))
 		return -EBUSY;
 
@@ -2083,12 +2121,15 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->vdev->v4l2_dev = &dev->v4l2_dev;
 	dev->vdev->lock = &dev->lock;
 	strcpy(dev->vdev->name, "au0828a video");
+	/* there is no way to deduce parent from v4l2_dev */
+	dev->vdev->dev_parent = &dev->usbdev->dev;
 
 	/* Setup the VBI device */
 	*dev->vbi_dev = au0828_video_template;
 	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
 	dev->vbi_dev->lock = &dev->lock;
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
+	dev->vbi_dev->dev_parent = &dev->usbdev->dev;
 
 	/* Register the v4l2 device */
 	video_set_drvdata(dev->vdev, dev);
-- 
1.7.10.4

