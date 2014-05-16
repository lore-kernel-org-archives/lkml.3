Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaEPNiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45945 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbaEPNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:44 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 11/49] media: davinci: vpif_display: use vb2_ioctl_* helpers
Date: Fri, 16 May 2014 19:03:16 +0530
Message-Id: <1400247235-31434-13-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |  180 ++-----------------------
 1 file changed, 10 insertions(+), 170 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5fc1256..8bd3794 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -745,75 +745,6 @@ static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
-static int vpif_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbuf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common;
-	enum v4l2_field field;
-	u8 index = 0;
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != reqbuf->type)
-		return -EINVAL;
-
-	index = VPIF_VIDEO_INDEX;
-
-	common = &ch->common[index];
-
-	if (common->fmt.type != reqbuf->type || !vpif_dev)
-		return -EINVAL;
-	if (0 != common->io_usrs)
-		return -EBUSY;
-
-	if (reqbuf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (common->fmt.fmt.pix.field == V4L2_FIELD_ANY)
-			field = V4L2_FIELD_INTERLACED;
-		else
-			field = common->fmt.fmt.pix.field;
-	} else {
-		field = V4L2_VBI_INTERLACED;
-	}
-	/* Increment io usrs member of channel object to 1 */
-	common->io_usrs = 1;
-	/* Store type of memory requested in channel object */
-	common->memory = reqbuf->memory;
-	/* Allocate buffers */
-	return vb2_reqbufs(&common->buffer_queue, reqbuf);
-}
-
-static int vpif_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *tbuf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	if (common->fmt.type != tbuf->type)
-		return -EINVAL;
-
-	return vb2_querybuf(&common->buffer_queue, tbuf);
-}
-
-static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = NULL;
-
-	if (!buf || !priv)
-		return -EINVAL;
-
-	if (!ch)
-		return -EINVAL;
-
-	common = &(ch->common[VPIF_VIDEO_INDEX]);
-	if (common->fmt.type != buf->type)
-		return -EINVAL;
-
-	return vb2_qbuf(&common->buffer_queue, buf);
-}
-
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -870,101 +801,6 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
-static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	return vb2_dqbuf(&common->buffer_queue, p,
-					(file->f_flags & O_NONBLOCK));
-}
-
-static int vpif_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
-	int ret = 0;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	/* If Streaming is already started, return error */
-	if (common->started) {
-		vpif_err("channel->started\n");
-		return -EBUSY;
-	}
-
-	if ((ch->channel_id == VPIF_CHANNEL2_VIDEO
-		&& oth_ch->common[VPIF_VIDEO_INDEX].started &&
-		ch->vpifparams.std_info.ycmux_mode == 0)
-		|| ((ch->channel_id == VPIF_CHANNEL3_VIDEO)
-		&& (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
-		vpif_err("other channel is using\n");
-		return -EBUSY;
-	}
-
-	ret = vpif_check_format(ch, &common->fmt.fmt.pix);
-	if (ret < 0)
-		return ret;
-
-	/* Call vb2_streamon to start streaming in videobuf2 */
-	ret = vb2_streamon(&common->buffer_queue, buftype);
-	if (ret < 0) {
-		vpif_err("vb2_streamon\n");
-		return ret;
-	}
-
-	return ret;
-}
-
-static int vpif_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_display_config *vpif_config_data =
-					vpif_dev->platform_data;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	if (!common->started) {
-		vpif_err("channel->started\n");
-		return -EINVAL;
-	}
-
-	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		/* disable channel */
-		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
-				channel2_clipping_enable(0);
-			enable_channel2(0);
-			channel2_intr_enable(0);
-		}
-		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-					(2 == common->started)) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
-				channel3_clipping_enable(0);
-			enable_channel3(0);
-			channel3_intr_enable(0);
-		}
-	}
-
-	common->started = 0;
-	return vb2_streamoff(&common->buffer_queue, buftype);
-}
-
 static int vpif_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
@@ -1261,12 +1097,16 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_g_fmt_vid_out  		= vpif_g_fmt_vid_out,
 	.vidioc_s_fmt_vid_out   	= vpif_s_fmt_vid_out,
 	.vidioc_try_fmt_vid_out 	= vpif_try_fmt_vid_out,
-	.vidioc_reqbufs         	= vpif_reqbufs,
-	.vidioc_querybuf        	= vpif_querybuf,
-	.vidioc_qbuf            	= vpif_qbuf,
-	.vidioc_dqbuf           	= vpif_dqbuf,
-	.vidioc_streamon        	= vpif_streamon,
-	.vidioc_streamoff       	= vpif_streamoff,
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
 	.vidioc_s_std           	= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
 	.vidioc_enum_output		= vpif_enum_output,
-- 
1.7.9.5

