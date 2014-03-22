Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaCVK6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:58:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46139 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCVK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:58:11 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH] media: davinci: vpbe: use v4l2_fh for priority handling
Date: Sat, 22 Mar 2014 16:27:59 +0530
Message-Id: <1395485879-14991-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch migrates the vpbe driver to use v4l2_fh for
priority handling. This also fixes v4l2-compliance test.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   39 +++++--------------------
 include/media/davinci/vpbe_display.h          |    6 ++--
 2 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6567082..a9ad949 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -680,29 +680,6 @@ static int vpbe_try_format(struct vpbe_display *disp_dev,
 	return 0;
 }
 
-static int vpbe_display_g_priority(struct file *file, void *priv,
-				enum v4l2_priority *p)
-{
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-
-	*p = v4l2_prio_max(&layer->prio);
-
-	return 0;
-}
-
-static int vpbe_display_s_priority(struct file *file, void *priv,
-				enum v4l2_priority p)
-{
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	int ret;
-
-	ret = v4l2_prio_change(&layer->prio, &fh->prio, p);
-
-	return ret;
-}
-
 static int vpbe_display_querycap(struct file *file, void  *priv,
 			       struct v4l2_capability *cap)
 {
@@ -1492,6 +1469,7 @@ static int vpbe_display_open(struct file *file)
 {
 	struct vpbe_fh *fh = NULL;
 	struct vpbe_layer *layer = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
 	struct vpbe_display *disp_dev = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_state *osd_device = disp_dev->osd_device;
@@ -1504,6 +1482,7 @@ static int vpbe_display_open(struct file *file)
 			"unable to allocate memory for file handle object\n");
 		return -ENOMEM;
 	}
+	v4l2_fh_init(&fh->fh, vdev);
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 			"vpbe display open plane = %d\n",
 			layer->device_id);
@@ -1532,9 +1511,7 @@ static int vpbe_display_open(struct file *file)
 	layer->usrs++;
 	/* Set io_allowed member to false */
 	fh->io_allowed = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&layer->prio, &fh->prio);
+	v4l2_fh_add(&fh->fh);
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 			"vpbe display device opened successfully\n");
 	return 0;
@@ -1589,8 +1566,9 @@ static int vpbe_display_release(struct file *file)
 		osd_device->ops.release_layer(osd_device,
 				layer->layer_info.id);
 	}
-	/* Close the priority */
-	v4l2_prio_close(&layer->prio, fh->prio);
+
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	mutex_unlock(&layer->opslock);
 
@@ -1618,8 +1596,6 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_cropcap		 = vpbe_display_cropcap,
 	.vidioc_g_crop		 = vpbe_display_g_crop,
 	.vidioc_s_crop		 = vpbe_display_s_crop,
-	.vidioc_g_priority	 = vpbe_display_g_priority,
-	.vidioc_s_priority	 = vpbe_display_s_priority,
 	.vidioc_s_std		 = vpbe_display_s_std,
 	.vidioc_g_std		 = vpbe_display_g_std,
 	.vidioc_enum_output	 = vpbe_display_enum_output,
@@ -1699,8 +1675,6 @@ static int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	vpbe_display_layer->layer_info.id =
 		((i == VPBE_DISPLAY_DEVICE_0) ? WIN_VID0 : WIN_VID1);
 
-	/* Initialize prio member of layer object */
-	v4l2_prio_init(&vpbe_display_layer->prio);
 
 	return 0;
 }
@@ -1727,6 +1701,7 @@ static int register_device(struct vpbe_layer *vpbe_display_layer,
 	vpbe_display_layer->disp_dev = disp_dev;
 	/* set the driver data in platform device */
 	platform_set_drvdata(pdev, disp_dev);
+	set_bit(V4L2_FL_USE_FH_PRIO, &vpbe_display_layer->video_dev.flags);
 	video_set_drvdata(&vpbe_display_layer->video_dev,
 			  vpbe_display_layer);
 
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index 8dffffe..637749a 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -16,6 +16,7 @@
 /* Header files */
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-fh.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpbe_types.h>
 #include <media/davinci/vpbe_osd.h>
@@ -94,8 +95,6 @@ struct vpbe_layer {
 	 * has selected
 	 */
 	enum v4l2_memory memory;
-	/* Used to keep track of state of the priority */
-	struct v4l2_prio_state prio;
 	/* Used to store pixel format */
 	struct v4l2_pix_format pix_fmt;
 	enum v4l2_field buf_field;
@@ -134,14 +133,13 @@ struct vpbe_display {
 
 /* File handle structure */
 struct vpbe_fh {
+	struct v4l2_fh fh;
 	/* vpbe device structure */
 	struct vpbe_display *disp_dev;
 	/* pointer to layer object for opened device */
 	struct vpbe_layer *layer;
 	/* Indicates whether this file handle is doing IO */
 	unsigned char io_allowed;
-	/* Used to keep track priority of this instance */
-	enum v4l2_priority prio;
 };
 
 struct buf_config_params {
-- 
1.7.9.5

