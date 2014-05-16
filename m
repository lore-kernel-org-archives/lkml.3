Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaEPNmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:04 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44122 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaEPNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:59 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 35/49] media: davinci: vpif_capture: use v4l2_fh_open and vb2_fop_release
Date: Fri, 16 May 2014 19:03:41 +0530
Message-Id: <1400247235-31434-38-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to use v4l2_fh_open() and vb2_fop_release,
which allows to drop driver specific struct vpif_fh, as this is handeled
by core. This patch also drops vpif_g/s_priority as this handeled
by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |  296 ++++---------------------
 drivers/media/platform/davinci/vpif_capture.h |   14 --
 2 files changed, 48 insertions(+), 262 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a50e392..6ad9e09 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -751,98 +751,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 }
 
 /**
- * vpif_open : vpif open handler
- * @filep: file ptr
- *
- * It creates object of file handle structure and stores it in private_data
- * member of filepointer
- */
-static int vpif_open(struct file *filep)
-{
-	struct video_device *vdev = video_devdata(filep);
-	struct common_obj *common;
-	struct video_obj *vid_ch;
-	struct channel_obj *ch;
-	struct vpif_fh *fh;
-
-	vpif_dbg(2, debug, "vpif_open\n");
-
-	ch = video_get_drvdata(vdev);
-
-	vid_ch = &ch->video;
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	/* Allocate memory for the file handle object */
-	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
-	if (NULL == fh) {
-		vpif_err("unable to allocate memory for file handle object\n");
-		return -ENOMEM;
-	}
-
-	if (mutex_lock_interruptible(&common->lock)) {
-		kfree(fh);
-		return -ERESTARTSYS;
-	}
-	/* store pointer to fh in private_data member of filep */
-	filep->private_data = fh;
-	fh->channel = ch;
-	fh->initialized = 0;
-	/* If decoder is not initialized. initialize it */
-	if (!ch->initialized) {
-		fh->initialized = 1;
-		ch->initialized = 1;
-		memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
-	}
-	/* Increment channel usrs counter */
-	ch->usrs++;
-	/* Set io_allowed member to false */
-	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&ch->prio, &fh->prio);
-	mutex_unlock(&common->lock);
-	return 0;
-}
-
-/**
- * vpif_release : function to clean up file close
- * @filep: file pointer
- *
- * This function deletes buffer queue, frees the buffers and the vpif file
- * handle
- */
-static int vpif_release(struct file *filep)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	vpif_dbg(2, debug, "vpif_release\n");
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-
-	mutex_lock(&common->lock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX])
-		/* Reset io_usrs member of channel object */
-		common->io_usrs = 0;
-
-	/* Decrement channel usrs counter */
-	ch->usrs--;
-
-	/* Close the priority */
-	v4l2_prio_close(&ch->prio, fh->prio);
-
-	if (fh->initialized)
-		ch->initialized = 0;
-
-	mutex_unlock(&common->lock);
-	filep->private_data = NULL;
-	kfree(fh);
-	return 0;
-}
-
-/**
  * vpif_reqbufs() - request buffer handler
  * @file: file ptr
  * @priv: file handle
@@ -851,25 +759,13 @@ static int vpif_release(struct file *filep)
 static int vpif_reqbufs(struct file *file, void *priv,
 			struct v4l2_requestbuffers *reqbuf)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common;
 	u8 index = 0;
 
 	vpif_dbg(2, debug, "vpif_reqbufs\n");
 
-	/**
-	 * This file handle has not initialized the channel,
-	 * It is not allowed to do settings
-	 */
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != reqbuf->type || !vpif_dev)
 		return -EINVAL;
 
@@ -880,8 +776,6 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	if (0 != common->io_usrs)
 		return -EBUSY;
 
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed[index] = 1;
 	/* Increment io usrs member of channel object to 1 */
 	common->io_usrs = 1;
 	/* Store type of memory requested in channel object */
@@ -900,8 +794,8 @@ static int vpif_reqbufs(struct file *file, void *priv,
 static int vpif_querybuf(struct file *file, void *priv,
 				struct v4l2_buffer *buf)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	vpif_dbg(2, debug, "vpif_querybuf\n");
@@ -926,8 +820,8 @@ static int vpif_querybuf(struct file *file, void *priv,
 static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
 
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_buffer tbuf = *buf;
 
@@ -938,11 +832,6 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return -EINVAL;
 	}
 
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh io not allowed\n");
-		return -EACCES;
-	}
-
 	return vb2_qbuf(&common->buffer_queue, buf);
 }
 
@@ -954,8 +843,8 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
  */
 static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	vpif_dbg(2, debug, "vpif_dqbuf\n");
@@ -973,9 +862,8 @@ static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 static int vpif_streamon(struct file *file, void *priv,
 				enum v4l2_buf_type buftype)
 {
-
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
 	struct vpif_params *vpif;
@@ -990,12 +878,6 @@ static int vpif_streamon(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* If file handle is not allowed IO, return error */
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_dbg(1, debug, "io not allowed\n");
-		return -EACCES;
-	}
-
 	/* If Streaming is already started, return error */
 	if (common->started) {
 		vpif_dbg(1, debug, "channel->started\n");
@@ -1043,8 +925,8 @@ static int vpif_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buftype)
 {
 
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret;
 
@@ -1055,12 +937,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* If io is allowed for this file handle, return error */
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_dbg(1, debug, "io not allowed\n");
-		return -EACCES;
-	}
-
 	/* If streaming is not started, return error */
 	if (!common->started) {
 		vpif_dbg(1, debug, "channel->started\n");
@@ -1189,8 +1065,8 @@ static int vpif_set_input(
  */
 static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	int ret = 0;
 
 	vpif_dbg(2, debug, "vpif_querystd\n");
@@ -1216,8 +1092,8 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
  */
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	vpif_dbg(2, debug, "vpif_g_std\n");
 
@@ -1233,8 +1109,8 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
  */
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
@@ -1245,20 +1121,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 		return -EBUSY;
 	}
 
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
-
-	fh->initialized = 1;
-
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = std_id;
 	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
@@ -1292,9 +1154,9 @@ static int vpif_enum_input(struct file *file, void *priv,
 {
 
 	struct vpif_capture_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_capture_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
@@ -1316,8 +1178,8 @@ static int vpif_enum_input(struct file *file, void *priv,
  */
 static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*index = ch->input_idx;
 	return 0;
@@ -1332,11 +1194,10 @@ static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
 static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
-	struct vpif_capture_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret;
+	struct vpif_capture_chan_config *chan_cfg;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
@@ -1348,19 +1209,6 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 		return -EBUSY;
 	}
 
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
-
-	fh->initialized = 1;
 	return vpif_set_input(config, ch, index);
 }
 
@@ -1373,8 +1221,8 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	if (fmt->index != 0) {
 		vpif_dbg(1, debug, "Invalid format index\n");
@@ -1403,8 +1251,8 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
 	return vpif_check_format(ch, pixfmt, 1);
@@ -1420,8 +1268,8 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Check the validity of the buffer type */
@@ -1442,8 +1290,8 @@ static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_pix_format *pixfmt;
 	int ret = 0;
@@ -1456,20 +1304,6 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EBUSY;
 	}
 
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
-	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	ret = v4l2_prio_check(&ch->prio, fh->prio);
-	if (0 != ret)
-		return ret;
-
-	fh->initialized = 1;
-
 	pixfmt = &fmt->fmt.pix;
 	/* Check for valid field format */
 	ret = vpif_check_format(ch, pixfmt, 0);
@@ -1503,37 +1337,6 @@ static int vpif_querycap(struct file *file, void  *priv,
 }
 
 /**
- * vpif_g_priority() - get priority handler
- * @file: file ptr
- * @priv: file handle
- * @prio: ptr to v4l2_priority structure
- */
-static int vpif_g_priority(struct file *file, void *priv,
-			   enum v4l2_priority *prio)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*prio = v4l2_prio_max(&ch->prio);
-
-	return 0;
-}
-
-/**
- * vpif_s_priority() - set priority handler
- * @file: file ptr
- * @priv: file handle
- * @prio: ptr to v4l2_priority structure
- */
-static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_prio_change(&ch->prio, &fh->prio, p);
-}
-
-/**
  * vpif_cropcap() - cropcap handler
  * @file: file ptr
  * @priv: file handle
@@ -1542,8 +1345,8 @@ static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
 static int vpif_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != crop->type)
@@ -1567,8 +1370,8 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
@@ -1587,8 +1390,8 @@ static int
 vpif_query_dv_timings(struct file *file, void *priv,
 		      struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
@@ -1606,8 +1409,8 @@ vpif_query_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
@@ -1694,8 +1497,8 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
 
 	*timings = vid_ch->dv_timings;
@@ -1721,8 +1524,6 @@ static int vpif_log_status(struct file *filep, void *priv)
 /* vpif capture ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_querycap        	= vpif_querycap,
-	.vidioc_g_priority		= vpif_g_priority,
-	.vidioc_s_priority		= vpif_s_priority,
 	.vidioc_enum_fmt_vid_cap	= vpif_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap  		= vpif_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= vpif_s_fmt_vid_cap,
@@ -1750,8 +1551,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 /* vpif file operations */
 static struct v4l2_file_operations vpif_fops = {
 	.owner = THIS_MODULE,
-	.open = vpif_open,
-	.release = vpif_release,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
 	.unlocked_ioctl = video_ioctl2,
 	.mmap = vb2_fop_mmap,
 	.poll = vb2_fop_poll
@@ -1851,10 +1652,6 @@ static int vpif_probe_complete(void)
 		common = &(ch->common[VPIF_VIDEO_INDEX]);
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
-		ch->video_dev->lock = &common->lock;
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
-		video_set_drvdata(ch->video_dev, ch);
 
 		/* select input 0 */
 		err = vpif_set_input(vpif_obj.config, ch, 0);
@@ -1890,6 +1687,9 @@ static int vpif_probe_complete(void)
 
 		vdev = ch->video_dev;
 		vdev->queue = q;
+		vdev->lock = &common->lock;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		video_set_drvdata(ch->video_dev, ch);
 		err = video_register_device(vdev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
 		if (err)
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 5a29d9a..f600819 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -104,8 +104,6 @@ struct common_obj {
 struct channel_obj {
 	/* Identifies video device for this channel */
 	struct video_device *video_dev;
-	/* Used to keep track of state of the priority */
-	struct v4l2_prio_state prio;
 	/* number of open instances of the channel */
 	int usrs;
 	/* Indicates id of the field which is being displayed */
@@ -126,18 +124,6 @@ struct channel_obj {
 	struct video_obj video;
 };
 
-/* File handle structure */
-struct vpif_fh {
-	/* pointer to channel object for opened device */
-	struct channel_obj *channel;
-	/* Indicates whether this file handle is doing IO */
-	u8 io_allowed[VPIF_NUMBER_OF_OBJECTS];
-	/* Used to keep track priority of this instance */
-	enum v4l2_priority prio;
-	/* Used to indicate channel is initialize or not */
-	u8 initialized;
-};
-
 struct vpif_device {
 	struct v4l2_device v4l2_dev;
 	struct channel_obj *dev[VPIF_CAPTURE_NUM_CHANNELS];
-- 
1.7.9.5

