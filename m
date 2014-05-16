Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbaEPNmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:11 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55031 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaEPNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:04 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 36/49] media: davinci: vpif_capture: use vb2_ioctl_* helpers
Date: Fri, 16 May 2014 19:03:42 +0530
Message-Id: <1400247235-31434-39-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |  240 +++----------------------
 1 file changed, 22 insertions(+), 218 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 6ad9e09..75015f4 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -208,6 +208,12 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		}
 	}
 
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
+		vpif_dbg(1, debug, "stream on failed in subdev\n");
+		goto err;
+	}
+
 	/* Call vpif_set_params function to set the parameters and addresses */
 	ret = vpif_set_video_params(vpif, ch->channel_id);
 
@@ -275,6 +281,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
+	int ret;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
@@ -290,6 +297,10 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	}
 	common->started = 0;
 
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		vpif_dbg(1, debug, "stream off failed in subdev\n");
+
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
@@ -751,218 +762,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 }
 
 /**
- * vpif_reqbufs() - request buffer handler
- * @file: file ptr
- * @priv: file handle
- * @reqbuf: request buffer structure ptr
- */
-static int vpif_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbuf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common;
-	u8 index = 0;
-
-	vpif_dbg(2, debug, "vpif_reqbufs\n");
-
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != reqbuf->type || !vpif_dev)
-		return -EINVAL;
-
-	index = VPIF_VIDEO_INDEX;
-
-	common = &ch->common[index];
-
-	if (0 != common->io_usrs)
-		return -EBUSY;
-
-	/* Increment io usrs member of channel object to 1 */
-	common->io_usrs = 1;
-	/* Store type of memory requested in channel object */
-	common->memory = reqbuf->memory;
-
-	/* Allocate buffers */
-	return vb2_reqbufs(&common->buffer_queue, reqbuf);
-}
-
-/**
- * vpif_querybuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *buf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_querybuf\n");
-
-	if (common->fmt.type != buf->type)
-		return -EINVAL;
-
-	if (common->memory != V4L2_MEMORY_MMAP) {
-		vpif_dbg(1, debug, "Invalid memory\n");
-		return -EINVAL;
-	}
-
-	return vb2_querybuf(&common->buffer_queue, buf);
-}
-
-/**
- * vpif_qbuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct v4l2_buffer tbuf = *buf;
-
-	vpif_dbg(2, debug, "vpif_qbuf\n");
-
-	if (common->fmt.type != tbuf.type) {
-		vpif_err("invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	return vb2_qbuf(&common->buffer_queue, buf);
-}
-
-/**
- * vpif_dqbuf() - query buffer handler
- * @file: file ptr
- * @priv: file handle
- * @buf: v4l2 buffer structure ptr
- */
-static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_dqbuf\n");
-
-	return vb2_dqbuf(&common->buffer_queue, buf,
-			 (file->f_flags & O_NONBLOCK));
-}
-
-/**
- * vpif_streamon() - streamon handler
- * @file: file ptr
- * @priv: file handle
- * @buftype: v4l2 buffer type
- */
-static int vpif_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
-	struct vpif_params *vpif;
-	int ret = 0;
-
-	vpif_dbg(2, debug, "vpif_streamon\n");
-
-	vpif = &ch->vpifparams;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		vpif_dbg(1, debug, "buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	/* If Streaming is already started, return error */
-	if (common->started) {
-		vpif_dbg(1, debug, "channel->started\n");
-		return -EBUSY;
-	}
-
-	if ((ch->channel_id == VPIF_CHANNEL0_VIDEO &&
-	    oth_ch->common[VPIF_VIDEO_INDEX].started &&
-	    vpif->std_info.ycmux_mode == 0) ||
-	   ((ch->channel_id == VPIF_CHANNEL1_VIDEO) &&
-	    (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
-		vpif_dbg(1, debug, "other channel is being used\n");
-		return -EBUSY;
-	}
-
-	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
-	if (ret)
-		return ret;
-
-	/* Enable streamon on the sub device */
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
-
-	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
-		vpif_dbg(1, debug, "stream on failed in subdev\n");
-		return ret;
-	}
-
-	/* Call vb2_streamon to start streaming in videobuf2 */
-	ret = vb2_streamon(&common->buffer_queue, buftype);
-	if (ret) {
-		vpif_dbg(1, debug, "vb2_streamon\n");
-		return ret;
-	}
-
-	return ret;
-}
-
-/**
- * vpif_streamoff() - streamoff handler
- * @file: file ptr
- * @priv: file handle
- * @buftype: v4l2 buffer type
- */
-static int vpif_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret;
-
-	vpif_dbg(2, debug, "vpif_streamoff\n");
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		vpif_dbg(1, debug, "buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	/* If streaming is not started, return error */
-	if (!common->started) {
-		vpif_dbg(1, debug, "channel->started\n");
-		return -EINVAL;
-	}
-
-	/* disable channel */
-	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
-		enable_channel0(0);
-		channel0_intr_enable(0);
-	} else {
-		enable_channel1(0);
-		channel1_intr_enable(0);
-	}
-
-	common->started = 0;
-
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
-
-	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		vpif_dbg(1, debug, "stream off failed in subdev\n");
-
-	return vb2_streamoff(&common->buffer_queue, buftype);
-}
-
-/**
  * vpif_input_to_subdev() - Maps input to sub device
  * @vpif_cfg - global config ptr
  * @chan_cfg - channel config ptr
@@ -1531,15 +1330,20 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_enum_input		= vpif_enum_input,
 	.vidioc_s_input			= vpif_s_input,
 	.vidioc_g_input			= vpif_g_input,
-	.vidioc_reqbufs         	= vpif_reqbufs,
-	.vidioc_querybuf        	= vpif_querybuf,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
 	.vidioc_querystd		= vpif_querystd,
 	.vidioc_s_std           	= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
-	.vidioc_qbuf            	= vpif_qbuf,
-	.vidioc_dqbuf           	= vpif_dqbuf,
-	.vidioc_streamon        	= vpif_streamon,
-	.vidioc_streamoff       	= vpif_streamoff,
+
 	.vidioc_cropcap         	= vpif_cropcap,
 	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
 	.vidioc_query_dv_timings        = vpif_query_dv_timings,
-- 
1.7.9.5

