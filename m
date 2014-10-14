Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaJNO7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:59:30 -0400
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:37644 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932498AbaJNO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:59:28 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] media: au0828-video changes to use media token api
Date: Tue, 14 Oct 2014 08:58:39 -0600
Message-Id: <297d2639063811813ba259d873ee722441d0fa41.1413246372.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828-video driver uses vb1 api and needs changes to vb1
v4l2 interfaces that change the tuner status. In addition
to that this driver initializes the tuner from a some ioctls
that are query (read) tuner status. These ioctls are changed
to hold the tuner and audio tokens to avoid disrupting digital
stream if active. Further more, release v4l2_file_operations
powers down the tuner. The following changes are made:

read, poll v4l2_file_operations:
- hold tuner and audio tokens
- return leaving tuner and audio tokens locked

vb1 streamon:
- hold tuner and audio tokens
- return leaving tuner and audio tokens locked

release v4l2_file_operations:
- hold tuner and audio tokens before power down
  Don't call s_power when tuner is busy

Note that media_get_tuner_tkn() will do a get on audio token
and return with both tuner and audio tokens locked. When tuner
token released using media_put_tuner_tkn() , audio token is
released. Initialize dev_parent field struct video_device to
enable media tuner token lookup from v4l2-core.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c |   42 ++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..931e736 100644
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
 
+		ret = media_get_tuner_tkn(&dev->usbdev->dev);
+		if (ret) {
+			dev_info(&dev->usbdev->dev,
+					"%s: Tuner is busy\n", __func__);
+			/* don't touch tuner - avoid putting to sleep step */
+			goto skip_s_power;
+		}
+		dev_info(&dev->usbdev->dev, "%s: Putting tuner to sleep\n",
+					__func__);
 		/* Save some power by putting tuner to sleep */
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
-		dev->std_set_in_tuner_core = 0;
+		media_put_tuner_tkn(&dev->usbdev->dev);
 
+skip_s_power:
+		dev->std_set_in_tuner_core = 0;
 		/* When close the device, set the usb intf0 into alt0 to free
 		   USB bandwidth */
 		ret = usb_set_interface(dev->usbdev, 0, 0);
@@ -1136,6 +1148,12 @@ static ssize_t au0828_v4l2_read(struct file *filp, char __user *buf,
 	if (rc < 0)
 		return rc;
 
+	/* don't put the tuner token - this case is same as STREAMON */
+	rc = media_get_tuner_tkn(&dev->usbdev->dev);
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
+	res = media_get_tuner_tkn(&dev->usbdev->dev);
+	if (res) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
 	res = v4l2_ctrl_poll(filp, wait);
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
@@ -1548,10 +1572,17 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
+	int ret;
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	ret = media_get_tuner_tkn(&dev->usbdev->dev);
+	if (ret) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
+
 	strcpy(t->name, "Auvitek tuner");
 
 	au0828_init_tuner(dev);
@@ -1682,6 +1713,12 @@ static int vidioc_streamon(struct file *file, void *priv,
 	dprintk(1, "vidioc_streamon fh=%p t=%d fh->res=%d dev->res=%d\n",
 		fh, type, fh->resources, dev->resources);
 
+	rc = media_get_tuner_tkn(&dev->usbdev->dev);
+	if (rc) {
+		dev_info(&dev->usbdev->dev, "%s: Tuner is busy\n", __func__);
+		return -EBUSY;
+	}
+
 	if (unlikely(!res_get(fh, get_ressource(fh))))
 		return -EBUSY;
 
@@ -2083,12 +2120,15 @@ int au0828_analog_register(struct au0828_dev *dev,
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

