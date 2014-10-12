Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaJLUlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:13 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42636 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaJLUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:04 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 08/15] media: davinci: vpbe: use vb2_ioctl_* helpers
Date: Sun, 12 Oct 2014 21:40:38 +0100
Message-Id: <1413146445-7304-9-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for using vb2_ioctl_* helpers.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 178 ++------------------------
 1 file changed, 14 insertions(+), 164 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 970242c..76450aa 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -281,8 +281,11 @@ static void vpbe_buffer_queue(struct vb2_buffer *vb)
 static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
+	struct osd_state *osd_device = layer->disp_dev->osd_device;
 	int ret;
 
+	 osd_device->ops.disable_layer(osd_device, layer->layer_info.id);
+
 	/* Get the next frame from the buffer queue */
 	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
 				struct vpbe_disp_buffer, list);
@@ -320,12 +323,15 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void vpbe_stop_streaming(struct vb2_queue *vq)
 {
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
+	struct osd_state *osd_device = layer->disp_dev->osd_device;
 	struct vpbe_display *disp = layer->disp_dev;
 	unsigned long flags;
 
 	if (!vb2_is_streaming(vq))
 		return;
 
+	osd_device->ops.disable_layer(osd_device, layer->layer_info.id);
+
 	/* release all active buffers */
 	spin_lock_irqsave(&disp->dma_queue_lock, flags);
 	if (layer->cur_frm == layer->next_frm) {
@@ -1144,164 +1150,6 @@ vpbe_display_g_dv_timings(struct file *file, void *priv,
 	return 0;
 }
 
-static int vpbe_display_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buf_type)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-	struct osd_state *osd_device = layer->disp_dev->osd_device;
-	int ret;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-			"VIDIOC_STREAMOFF,layer id = %d\n",
-			layer->device_id);
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != buf_type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	/* If streaming is not started, return error */
-	if (!layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "streaming not started in layer"
-			" id = %d\n", layer->device_id);
-		return -EINVAL;
-	}
-
-	osd_device->ops.disable_layer(osd_device,
-			layer->layer_info.id);
-	layer->started = 0;
-	ret = vb2_streamoff(&layer->buffer_queue, buf_type);
-
-	return ret;
-}
-
-static int vpbe_display_streamon(struct file *file, void *priv,
-			 enum v4l2_buf_type buf_type)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_display *disp_dev = layer->disp_dev;
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-	struct osd_state *osd_device = disp_dev->osd_device;
-	int ret;
-
-	osd_device->ops.disable_layer(osd_device,
-			layer->layer_info.id);
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_STREAMON, layerid=%d\n",
-						layer->device_id);
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != buf_type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	/* If Streaming is already started, return error */
-	if (layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "layer is already streaming\n");
-		return -EBUSY;
-	}
-
-	/*
-	 * Call vb2_streamon to start streaming
-	 * in videobuf
-	 */
-	ret = vb2_streamon(&layer->buffer_queue, buf_type);
-	if (ret) {
-		v4l2_err(&vpbe_dev->v4l2_dev,
-		"error in vb2_streamon\n");
-		return ret;
-	}
-	return ret;
-}
-
-static int vpbe_display_dqbuf(struct file *file, void *priv,
-		      struct v4l2_buffer *buf)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-	int ret;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-		"VIDIOC_DQBUF, layer id = %d\n",
-		layer->device_id);
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != buf->type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-	if (file->f_flags & O_NONBLOCK)
-		/* Call videobuf_dqbuf for non blocking mode */
-		ret = vb2_dqbuf(&layer->buffer_queue, buf, 1);
-	else
-		/* Call videobuf_dqbuf for blocking mode */
-		ret = vb2_dqbuf(&layer->buffer_queue, buf, 0);
-
-	return ret;
-}
-
-static int vpbe_display_qbuf(struct file *file, void *priv,
-		     struct v4l2_buffer *p)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-		"VIDIOC_QBUF, layer id = %d\n",
-		layer->device_id);
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != p->type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	return vb2_qbuf(&layer->buffer_queue, p);
-}
-
-static int vpbe_display_querybuf(struct file *file, void *priv,
-			 struct v4l2_buffer *buf)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-		"VIDIOC_QUERYBUF, layer id = %d\n",
-		layer->device_id);
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != buf->type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-	/* Call vb2_querybuf to get information */
-	return vb2_querybuf(&layer->buffer_queue, buf);
-}
-
-static int vpbe_display_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *req_buf)
-{
-	struct vpbe_layer *layer = video_drvdata(file);
-	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_reqbufs\n");
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != req_buf->type) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	/* If io users of the layer is not zero, return error */
-	if (0 != layer->io_usrs) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "not IO user\n");
-		return -EBUSY;
-	}
-	/* Increment io usrs member of layer object to 1 */
-	layer->io_usrs = 1;
-	/* Store type of memory requested in layer object */
-	layer->memory = req_buf->memory;
-	/* Allocate buffers */
-	return vb2_reqbufs(&layer->buffer_queue, req_buf);
-}
-
 /*
  * vpbe_display_open()
  * It creates object of file handle structure and stores it in private_data
@@ -1405,12 +1253,14 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_enum_fmt_vid_out = vpbe_display_enum_fmt,
 	.vidioc_s_fmt_vid_out    = vpbe_display_s_fmt,
 	.vidioc_try_fmt_vid_out  = vpbe_display_try_fmt,
-	.vidioc_reqbufs		 = vpbe_display_reqbufs,
-	.vidioc_querybuf	 = vpbe_display_querybuf,
-	.vidioc_qbuf		 = vpbe_display_qbuf,
-	.vidioc_dqbuf		 = vpbe_display_dqbuf,
-	.vidioc_streamon	 = vpbe_display_streamon,
-	.vidioc_streamoff	 = vpbe_display_streamoff,
+
+	.vidioc_reqbufs		 = vb2_ioctl_reqbufs,
+	.vidioc_querybuf	 = vb2_ioctl_querybuf,
+	.vidioc_qbuf		 = vb2_ioctl_qbuf,
+	.vidioc_dqbuf		 = vb2_ioctl_dqbuf,
+	.vidioc_streamon	 = vb2_ioctl_streamon,
+	.vidioc_streamoff	 = vb2_ioctl_streamoff,
+
 	.vidioc_cropcap		 = vpbe_display_cropcap,
 	.vidioc_g_crop		 = vpbe_display_g_crop,
 	.vidioc_s_crop		 = vpbe_display_s_crop,
-- 
1.9.1

