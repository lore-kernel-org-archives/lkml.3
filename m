Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaJLUlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51816 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaJLUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:04 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 07/15] media: davinci: vpbe: use fh handling provided by v4l
Date: Sun, 12 Oct 2014 21:40:37 +0100
Message-Id: <1413146445-7304-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch converts the driver to use fh handling provided by the
v4l core instead of driver doing it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 189 +++++++++-----------------
 include/media/davinci/vpbe_display.h          |  11 --
 2 files changed, 65 insertions(+), 135 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index fc3bdb6..970242c 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -628,8 +628,8 @@ static int vpbe_try_format(struct vpbe_display *disp_dev,
 static int vpbe_display_querycap(struct file *file, void  *priv,
 			       struct v4l2_capability *cap)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	cap->version = VPBE_DISPLAY_VERSION_CODE;
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
@@ -646,9 +646,8 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 static int vpbe_display_s_crop(struct file *file, void *priv,
 			     const struct v4l2_crop *crop)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_display *disp_dev = fh->disp_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_display *disp_dev = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_layer_config *cfg = &layer->layer_info.config;
 	struct osd_state *osd_device = disp_dev->osd_device;
@@ -715,11 +714,10 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
 static int vpbe_display_g_crop(struct file *file, void *priv,
 			     struct v4l2_crop *crop)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_layer *layer = video_drvdata(file);
 	struct osd_layer_config *cfg = &layer->layer_info.config;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	struct osd_state *osd_device = fh->disp_dev->osd_device;
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
+	struct osd_state *osd_device = layer->disp_dev->osd_device;
 	struct v4l2_rect *rect = &crop->c;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -743,8 +741,8 @@ static int vpbe_display_g_crop(struct file *file, void *priv,
 static int vpbe_display_cropcap(struct file *file, void *priv,
 			      struct v4l2_cropcap *cropcap)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_CROPCAP ioctl\n");
 
@@ -761,9 +759,8 @@ static int vpbe_display_cropcap(struct file *file, void *priv,
 static int vpbe_display_g_fmt(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 			"VIDIOC_G_FMT, layer id = %d\n",
@@ -783,9 +780,8 @@ static int vpbe_display_g_fmt(struct file *file, void *priv,
 static int vpbe_display_enum_fmt(struct file *file, void  *priv,
 				   struct v4l2_fmtdesc *fmt)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	unsigned int index = 0;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -815,9 +811,8 @@ static int vpbe_display_enum_fmt(struct file *file, void  *priv,
 static int vpbe_display_s_fmt(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_display *disp_dev = fh->disp_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_display *disp_dev = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_layer_config *cfg  = &layer->layer_info.config;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
@@ -904,9 +899,9 @@ static int vpbe_display_s_fmt(struct file *file, void *priv,
 static int vpbe_display_try_fmt(struct file *file, void *priv,
 				  struct v4l2_format *fmt)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_display *disp_dev = fh->disp_dev;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_display *disp_dev = layer->disp_dev;
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_TRY_FMT\n");
@@ -930,9 +925,8 @@ static int vpbe_display_try_fmt(struct file *file, void *priv,
 static int vpbe_display_s_std(struct file *file, void *priv,
 				v4l2_std_id std_id)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_STD\n");
@@ -965,8 +959,8 @@ static int vpbe_display_s_std(struct file *file, void *priv,
 static int vpbe_display_g_std(struct file *file, void *priv,
 				v4l2_std_id *std_id)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_G_STD\n");
 
@@ -988,8 +982,8 @@ static int vpbe_display_g_std(struct file *file, void *priv,
 static int vpbe_display_enum_output(struct file *file, void *priv,
 				    struct v4l2_output *output)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_ENUM_OUTPUT\n");
@@ -1016,9 +1010,8 @@ static int vpbe_display_enum_output(struct file *file, void *priv,
 static int vpbe_display_s_output(struct file *file, void *priv,
 				unsigned int i)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_S_OUTPUT\n");
@@ -1047,8 +1040,8 @@ static int vpbe_display_s_output(struct file *file, void *priv,
 static int vpbe_display_g_output(struct file *file, void *priv,
 				unsigned int *i)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_G_OUTPUT\n");
 	/* Get the standard from the current encoder */
@@ -1067,8 +1060,8 @@ static int
 vpbe_display_enum_dv_timings(struct file *file, void *priv,
 			struct v4l2_enum_dv_timings *timings)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_ENUM_DV_TIMINGS\n");
@@ -1097,9 +1090,8 @@ static int
 vpbe_display_s_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_DV_TIMINGS\n");
@@ -1135,8 +1127,8 @@ static int
 vpbe_display_g_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *dv_timings)
 {
-	struct vpbe_fh *fh = priv;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_G_DV_TIMINGS\n");
 
@@ -1155,10 +1147,9 @@ vpbe_display_g_dv_timings(struct file *file, void *priv,
 static int vpbe_display_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buf_type)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	struct osd_state *osd_device = fh->disp_dev->osd_device;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
+	struct osd_state *osd_device = layer->disp_dev->osd_device;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -1170,12 +1161,6 @@ static int vpbe_display_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* If io is allowed for this file handle, return error */
-	if (!fh->io_allowed) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "No io_allowed\n");
-		return -EACCES;
-	}
-
 	/* If streaming is not started, return error */
 	if (!layer->started) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "streaming not started in layer"
@@ -1194,10 +1179,9 @@ static int vpbe_display_streamoff(struct file *file, void *priv,
 static int vpbe_display_streamon(struct file *file, void *priv,
 			 enum v4l2_buf_type buf_type)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_display *disp_dev = fh->disp_dev;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_display *disp_dev = layer->disp_dev;
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	struct osd_state *osd_device = disp_dev->osd_device;
 	int ret;
 
@@ -1212,11 +1196,6 @@ static int vpbe_display_streamon(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* If file handle is not allowed IO, return error */
-	if (!fh->io_allowed) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "No io_allowed\n");
-		return -EACCES;
-	}
 	/* If Streaming is already started, return error */
 	if (layer->started) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "layer is already streaming\n");
@@ -1239,9 +1218,8 @@ static int vpbe_display_streamon(struct file *file, void *priv,
 static int vpbe_display_dqbuf(struct file *file, void *priv,
 		      struct v4l2_buffer *buf)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -1252,11 +1230,6 @@ static int vpbe_display_dqbuf(struct file *file, void *priv,
 		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
 		return -EINVAL;
 	}
-	/* If this file handle is not allowed to do IO, return error */
-	if (!fh->io_allowed) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "No io_allowed\n");
-		return -EACCES;
-	}
 	if (file->f_flags & O_NONBLOCK)
 		/* Call videobuf_dqbuf for non blocking mode */
 		ret = vb2_dqbuf(&layer->buffer_queue, buf, 1);
@@ -1270,9 +1243,8 @@ static int vpbe_display_dqbuf(struct file *file, void *priv,
 static int vpbe_display_qbuf(struct file *file, void *priv,
 		     struct v4l2_buffer *p)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 		"VIDIOC_QBUF, layer id = %d\n",
@@ -1283,21 +1255,14 @@ static int vpbe_display_qbuf(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* If this file handle is not allowed to do IO, return error */
-	if (!fh->io_allowed) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "No io_allowed\n");
-		return -EACCES;
-	}
-
 	return vb2_qbuf(&layer->buffer_queue, p);
 }
 
 static int vpbe_display_querybuf(struct file *file, void *priv,
 			 struct v4l2_buffer *buf)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 		"VIDIOC_QUERYBUF, layer id = %d\n",
@@ -1314,9 +1279,8 @@ static int vpbe_display_querybuf(struct file *file, void *priv,
 static int vpbe_display_reqbufs(struct file *file, void *priv,
 			struct v4l2_requestbuffers *req_buf)
 {
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = video_drvdata(file);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_reqbufs\n");
 
@@ -1330,8 +1294,6 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 		v4l2_err(&vpbe_dev->v4l2_dev, "not IO user\n");
 		return -EBUSY;
 	}
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed = 1;
 	/* Increment io usrs member of layer object to 1 */
 	layer->io_usrs = 1;
 	/* Store type of memory requested in layer object */
@@ -1347,30 +1309,22 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
  */
 static int vpbe_display_open(struct file *file)
 {
-	struct vpbe_fh *fh = NULL;
 	struct vpbe_layer *layer = video_drvdata(file);
-	struct video_device *vdev = video_devdata(file);
 	struct vpbe_display *disp_dev = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_state *osd_device = disp_dev->osd_device;
 	int err;
 
-	/* Allocate memory for the file handle object */
-	fh = kmalloc(sizeof(struct vpbe_fh), GFP_KERNEL);
-	if (fh == NULL) {
-		v4l2_err(&vpbe_dev->v4l2_dev,
-			"unable to allocate memory for file handle object\n");
-		return -ENOMEM;
+	/* creating context for file descriptor */
+	err = v4l2_fh_open(file);
+	if (err) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "v4l2_fh_open failed\n");
+		return err;
 	}
-	v4l2_fh_init(&fh->fh, vdev);
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-			"vpbe display open plane = %d\n",
-			layer->device_id);
 
-	/* store pointer to fh in private_data member of filep */
-	file->private_data = fh;
-	fh->layer = layer;
-	fh->disp_dev = disp_dev;
+	/* leaving if layer is already initialized */
+	if (!v4l2_fh_is_singular_file(file))
+		return err;
 
 	if (!layer->usrs) {
 		if (mutex_lock_interruptible(&layer->opslock))
@@ -1383,15 +1337,12 @@ static int vpbe_display_open(struct file *file)
 			/* Couldn't get layer */
 			v4l2_err(&vpbe_dev->v4l2_dev,
 				"Display Manager failed to allocate layer\n");
-			kfree(fh);
+			v4l2_fh_release(file);
 			return -EINVAL;
 		}
 	}
 	/* Increment layer usrs counter */
 	layer->usrs++;
-	/* Set io_allowed member to false */
-	fh->io_allowed = 0;
-	v4l2_fh_add(&fh->fh);
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 			"vpbe display device opened successfully\n");
 	return 0;
@@ -1404,26 +1355,21 @@ static int vpbe_display_open(struct file *file)
  */
 static int vpbe_display_release(struct file *file)
 {
-	/* Get the layer object and file handle object */
-	struct vpbe_fh *fh = file->private_data;
-	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_layer *layer = video_drvdata(file);
 	struct osd_layer_config *cfg  = &layer->layer_info.config;
-	struct vpbe_display *disp_dev = fh->disp_dev;
+	struct vpbe_display *disp_dev = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_state *osd_device = disp_dev->osd_device;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_release\n");
 
 	mutex_lock(&layer->opslock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed) {
-		/* Reset io_usrs member of layer object */
-		layer->io_usrs = 0;
+	/* Reset io_usrs member of layer object */
+	layer->io_usrs = 0;
 
-		osd_device->ops.disable_layer(osd_device,
-				layer->layer_info.id);
-		layer->started = 0;
-	}
+	osd_device->ops.disable_layer(osd_device,
+			layer->layer_info.id);
+	layer->started = 0;
 
 	/* Decrement layer usrs counter */
 	layer->usrs--;
@@ -1444,14 +1390,9 @@ static int vpbe_display_release(struct file *file)
 				layer->layer_info.id);
 	}
 
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-	file->private_data = NULL;
+	_vb2_fop_release(file, NULL);
 	mutex_unlock(&layer->opslock);
 
-	/* Free memory allocated to file handle object */
-	kfree(fh);
-
 	disp_dev->cbcr_ofst = 0;
 
 	return 0;
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index 637749a..06ea815 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -131,17 +131,6 @@ struct vpbe_display {
 	struct osd_state *osd_device;
 };
 
-/* File handle structure */
-struct vpbe_fh {
-	struct v4l2_fh fh;
-	/* vpbe device structure */
-	struct vpbe_display *disp_dev;
-	/* pointer to layer object for opened device */
-	struct vpbe_layer *layer;
-	/* Indicates whether this file handle is doing IO */
-	unsigned char io_allowed;
-};
-
 struct buf_config_params {
 	unsigned char min_numbuffers;
 	unsigned char numbuffers[VPBE_DISPLAY_MAX_DEVICES];
-- 
1.9.1

