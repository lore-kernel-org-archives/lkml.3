Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbaEPNid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44160 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaEPNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:29 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 10/49] media: davinci: vpif_display: use v4l2_fh_open and vb2_fop_release
Date: Fri, 16 May 2014 19:03:15 +0530
Message-Id: <1400247235-31434-12-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_display.c |  228 +++++--------------------
 drivers/media/platform/davinci/vpif_display.h |   15 --
 2 files changed, 43 insertions(+), 200 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index cea526b..5fc1256 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -645,85 +645,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 	}
 }
 
-/*
- * vpif_open: It creates object of file handle structure and stores it in
- * private_data member of filepointer
- */
-static int vpif_open(struct file *filep)
-{
-	struct video_device *vdev = video_devdata(filep);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_fh *fh;
-
-	/* Allocate memory for the file handle object */
-	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
-	if (fh == NULL) {
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
-	if (!ch->initialized) {
-		fh->initialized = 1;
-		ch->initialized = 1;
-		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
-	}
-
-	/* Increment channel usrs counter */
-	atomic_inc(&ch->usrs);
-	/* Set io_allowed[VPIF_VIDEO_INDEX] member to false */
-	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&ch->prio, &fh->prio);
-	mutex_unlock(&common->lock);
-
-	return 0;
-}
-
-/*
- * vpif_release: This function deletes buffer queue, frees the buffers and
- * the vpif file handle
- */
-static int vpif_release(struct file *filep)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	mutex_lock(&common->lock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		/* Reset io_usrs member of channel object */
-		common->io_usrs = 0;
-		common->numbuffers =
-		    config_params.numbuffers[ch->channel_id];
-	}
-
-	/* Decrement channel usrs counter */
-	atomic_dec(&ch->usrs);
-	/* If this file handle has initialize encoder device, reset it */
-	if (fh->initialized)
-		ch->initialized = 0;
-
-	/* Close the priority */
-	v4l2_prio_close(&ch->prio, fh->prio);
-	filep->private_data = NULL;
-	fh->initialized = 0;
-	mutex_unlock(&common->lock);
-	kfree(fh);
-
-	return 0;
-}
-
 /* functions implementing ioctls */
 /**
  * vpif_querycap() - QUERYCAP handler
@@ -765,8 +686,8 @@ static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
 static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Check the validity of the buffer type */
@@ -782,26 +703,12 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct v4l2_pix_format *pixfmt;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct v4l2_pix_format *pixfmt;
 	int ret = 0;
 
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-
-		/* Check for the priority */
-		ret = v4l2_prio_check(&ch->prio, fh->prio);
-		if (0 != ret)
-			return ret;
-		fh->initialized = 1;
-	}
-
 	if (common->started) {
 		vpif_dbg(1, debug, "Streaming in progress\n");
 		return -EBUSY;
@@ -823,8 +730,8 @@ static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 	int ret = 0;
@@ -841,22 +748,12 @@ static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 static int vpif_reqbufs(struct file *file, void *priv,
 			struct v4l2_requestbuffers *reqbuf)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common;
 	enum v4l2_field field;
 	u8 index = 0;
 
-	/* This file handle has not initialized the channel,
-	   It is not allowed to do settings */
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_err("Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != reqbuf->type)
 		return -EINVAL;
 
@@ -877,8 +774,6 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	} else {
 		field = V4L2_VBI_INTERLACED;
 	}
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed[index] = 1;
 	/* Increment io usrs member of channel object to 1 */
 	common->io_usrs = 1;
 	/* Store type of memory requested in channel object */
@@ -890,8 +785,8 @@ static int vpif_reqbufs(struct file *file, void *priv,
 static int vpif_querybuf(struct file *file, void *priv,
 				struct v4l2_buffer *tbuf)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	if (common->fmt.type != tbuf->type)
@@ -902,15 +797,13 @@ static int vpif_querybuf(struct file *file, void *priv,
 
 static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct vpif_fh *fh = NULL;
-	struct channel_obj *ch = NULL;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = NULL;
 
 	if (!buf || !priv)
 		return -EINVAL;
 
-	fh = priv;
-	ch = fh->channel;
 	if (!ch)
 		return -EINVAL;
 
@@ -918,18 +811,13 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	if (common->fmt.type != buf->type)
 		return -EINVAL;
 
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
 	return vb2_qbuf(&common->buffer_queue, buf);
 }
 
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
@@ -975,8 +863,8 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*std = ch->video.stdid;
 	return 0;
@@ -984,8 +872,8 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 
 static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	return vb2_dqbuf(&common->buffer_queue, p,
@@ -995,8 +883,8 @@ static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 static int vpif_streamon(struct file *file, void *priv,
 				enum v4l2_buf_type buftype)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
 	int ret = 0;
@@ -1006,11 +894,6 @@ static int vpif_streamon(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
 	/* If Streaming is already started, return error */
 	if (common->started) {
 		vpif_err("channel->started\n");
@@ -1043,8 +926,8 @@ static int vpif_streamon(struct file *file, void *priv,
 static int vpif_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buftype)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_display_config *vpif_config_data =
 					vpif_dev->platform_data;
@@ -1054,11 +937,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
 	if (!common->started) {
 		vpif_err("channel->started\n");
 		return -EINVAL;
@@ -1090,9 +968,10 @@ static int vpif_streamoff(struct file *file, void *priv,
 static int vpif_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != crop->type)
 		return -EINVAL;
 
@@ -1109,9 +988,9 @@ static int vpif_enum_output(struct file *file, void *fh,
 {
 
 	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *vpif_handler = fh;
-	struct channel_obj *ch = vpif_handler->channel;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 	if (output->index >= chan_cfg->output_count) {
@@ -1205,9 +1084,9 @@ static int vpif_set_output(struct vpif_display_config *vpif_cfg,
 static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1225,32 +1104,14 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 
 static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*i = ch->output_idx;
 
 	return 0;
 }
 
-static int vpif_g_priority(struct file *file, void *priv, enum v4l2_priority *p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*p = v4l2_prio_max(&ch->prio);
-
-	return 0;
-}
-
-static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_prio_change(&ch->prio, &fh->prio, p);
-}
-
 /**
  * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
@@ -1261,8 +1122,8 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
@@ -1280,8 +1141,8 @@ vpif_enum_dv_timings(struct file *file, void *priv,
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
@@ -1369,8 +1230,8 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
 
 	*timings = vid_ch->dv_timings;
@@ -1396,8 +1257,6 @@ static int vpif_log_status(struct file *filep, void *priv)
 /* vpif display ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_querycap        	= vpif_querycap,
-	.vidioc_g_priority		= vpif_g_priority,
-	.vidioc_s_priority		= vpif_s_priority,
 	.vidioc_enum_fmt_vid_out	= vpif_enum_fmt_vid_out,
 	.vidioc_g_fmt_vid_out  		= vpif_g_fmt_vid_out,
 	.vidioc_s_fmt_vid_out   	= vpif_s_fmt_vid_out,
@@ -1422,8 +1281,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 
 static const struct v4l2_file_operations vpif_fops = {
 	.owner		= THIS_MODULE,
-	.open		= vpif_open,
-	.release	= vpif_release,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
 	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= vb2_fop_mmap,
 	.poll		= vb2_fop_poll
@@ -1556,12 +1415,8 @@ static int vpif_probe_complete(void)
 
 		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
 
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		ch->video_dev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
 
 		/* select output 0 */
 		err = vpif_set_output(vpif_obj.config, ch, 0);
@@ -1601,6 +1456,9 @@ static int vpif_probe_complete(void)
 
 		vdev = ch->video_dev;
 		vdev->queue = q;
+		vdev->lock = &common->lock;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		video_set_drvdata(ch->video_dev, ch);
 		err = video_register_device(vdev, VFL_TYPE_GRABBER,
 					    (j ? 3 : 2));
 		if (err < 0)
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 4d0485b..18c7bd5 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -113,8 +113,6 @@ struct channel_obj {
 	/* V4l2 specific parameters */
 	struct video_device *video_dev;	/* Identifies video device for
 					 * this channel */
-	struct v4l2_prio_state prio;	/* Used to keep track of state of
-					 * the priority */
 	atomic_t usrs;			/* number of open instances of
 					 * the channel */
 	u32 field_id;			/* Indicates id of the field
@@ -130,19 +128,6 @@ struct channel_obj {
 	struct video_obj video;
 };
 
-/* File handle structure */
-struct vpif_fh {
-	struct channel_obj *channel;	/* pointer to channel object for
-					 * opened device */
-	u8 io_allowed[VPIF_NUMOBJECTS];	/* Indicates whether this file handle
-					 * is doing IO */
-	enum v4l2_priority prio;	/* Used to keep track priority of
-					 * this instance */
-	u8 initialized;			/* Used to keep track of whether this
-					 * file handle has initialized
-					 * channel or not */
-};
-
 /* vpif device structure */
 struct vpif_device {
 	struct v4l2_device v4l2_dev;
-- 
1.7.9.5

