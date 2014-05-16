Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbaEPNnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:43:11 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38208 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbaEPNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:43:03 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 48/49] media: davinci: vpif_capture: fix v4l-complinace issues
Date: Fri, 16 May 2014 19:03:54 +0530
Message-Id: <1400247235-31434-51-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch does following,
1: sets initial default format during probe.
2: removes spurious messages.
3: optimize vpif_s/try_fmt_vid_out code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |  191 +++++++------------------
 1 file changed, 54 insertions(+), 137 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 8d7ada2..5226798 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -497,10 +497,28 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	common->width = std_info->width;
 	common->fmt.fmt.pix.height = std_info->height;
 	common->height = std_info->height;
+	common->fmt.fmt.pix.sizeimage = common->height * common->width * 2;
 	common->fmt.fmt.pix.bytesperline = std_info->width;
 	vpifparams->video_params.hpitch = std_info->width;
 	vpifparams->video_params.storage_mode = std_info->frm_fmt;
 
+	if (vid_ch->stdid)
+		common->fmt.fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		common->fmt.fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+
+	if (ch->vpifparams.std_info.frm_fmt)
+		common->fmt.fmt.pix.field = V4L2_FIELD_NONE;
+	else
+		common->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
+
+	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
+		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
+	else
+		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
+
+	common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
 	return 0;
 }
 
@@ -577,24 +595,6 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 }
 
 /**
- * vpif_config_format: configure default frame format in the device
- * ch : ptr to channel object
- */
-static void vpif_config_format(struct channel_obj *ch)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	vpif_dbg(2, debug, "vpif_config_format\n");
-
-	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
-		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
-	else
-		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
-	common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-}
-
-/**
  * vpif_get_default_field() - Get default field type based on interface
  * @vpif_params - ptr to vpif params
  */
@@ -606,112 +606,6 @@ static inline enum v4l2_field vpif_get_default_field(
 }
 
 /**
- * vpif_check_format()  - check given pixel format for compatibility
- * @ch - channel  ptr
- * @pixfmt - Given pixel format
- * @update - update the values as per hardware requirement
- *
- * Check the application pixel format for S_FMT and update the input
- * values as per hardware limits for TRY_FMT. The default pixel and
- * field format is selected based on interface type.
- */
-static int vpif_check_format(struct channel_obj *ch,
-			     struct v4l2_pix_format *pixfmt,
-			     int update)
-{
-	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
-	struct vpif_params *vpif_params = &ch->vpifparams;
-	enum v4l2_field field = pixfmt->field;
-	u32 sizeimage, hpitch, vpitch;
-	int ret = -EINVAL;
-
-	vpif_dbg(2, debug, "vpif_check_format\n");
-	/**
-	 * first check for the pixel format. If if_type is Raw bayer,
-	 * only V4L2_PIX_FMT_SBGGR8 format is supported. Otherwise only
-	 * V4L2_PIX_FMT_YUV422P is supported
-	 */
-	if (vpif_params->iface.if_type == VPIF_IF_RAW_BAYER) {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8) {
-			if (!update) {
-				vpif_dbg(2, debug, "invalid pix format\n");
-				goto exit;
-			}
-			pixfmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
-		}
-	} else {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P) {
-			if (!update) {
-				vpif_dbg(2, debug, "invalid pixel format\n");
-				goto exit;
-			}
-			pixfmt->pixelformat = V4L2_PIX_FMT_YUV422P;
-		}
-	}
-
-	if (!(VPIF_VALID_FIELD(field))) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid field format\n");
-			goto exit;
-		}
-		/**
-		 * By default use FIELD_NONE for RAW Bayer capture
-		 * and FIELD_INTERLACED for other interfaces
-		 */
-		field = vpif_get_default_field(&vpif_params->iface);
-	} else if (field == V4L2_FIELD_ANY)
-		/* unsupported field. Use default */
-		field = vpif_get_default_field(&vpif_params->iface);
-
-	/* validate the hpitch */
-	hpitch = pixfmt->bytesperline;
-	if (hpitch < vpif_params->std_info.width) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid hpitch\n");
-			goto exit;
-		}
-		hpitch = vpif_params->std_info.width;
-	}
-
-	sizeimage = pixfmt->sizeimage;
-
-	vpitch = sizeimage / (hpitch * 2);
-
-	/* validate the vpitch */
-	if (vpitch < vpif_params->std_info.height) {
-		if (!update) {
-			vpif_dbg(2, debug, "Invalid vpitch\n");
-			goto exit;
-		}
-		vpitch = vpif_params->std_info.height;
-	}
-
-	/* Check for 8 byte alignment */
-	if (!ALIGN(hpitch, 8)) {
-		if (!update) {
-			vpif_dbg(2, debug, "invalid pitch alignment\n");
-			goto exit;
-		}
-		/* adjust to next 8 byte boundary */
-		hpitch = (((hpitch + 7) / 8) * 8);
-	}
-	/* if update is set, modify the bytesperline and sizeimage */
-	if (update) {
-		pixfmt->bytesperline = hpitch;
-		pixfmt->sizeimage = hpitch * vpitch * 2;
-	}
-	/**
-	 * Image width and height is always based on current standard width and
-	 * height
-	 */
-	pixfmt->width = common->fmt.fmt.pix.width;
-	pixfmt->height = common->fmt.fmt.pix.height;
-	return 0;
-exit:
-	return ret;
-}
-
-/**
  * vpif_config_addr() - function to configure buffer address in vpif
  * @ch - channel ptr
  * @muxmode - channel mux mode
@@ -921,9 +815,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 		return -EINVAL;
 	}
 
-	/* Configure the default format information */
-	vpif_config_format(ch);
-
 	/* set standard in the sub device */
 	ret = v4l2_subdev_call(ch->sd, core, s_std, std_id);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
@@ -950,10 +841,8 @@ static int vpif_enum_input(struct file *file, void *priv,
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
-	if (input->index >= chan_cfg->input_count) {
-		vpif_dbg(1, debug, "Invalid input index\n");
+	if (input->index >= chan_cfg->input_count)
 		return -EINVAL;
-	}
 
 	memcpy(input, &chan_cfg->inputs[input->index].input,
 		sizeof(*input));
@@ -1042,8 +931,34 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
+	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
+	struct vpif_params *vpif_params = &ch->vpifparams;
+
+	/*
+	 * to supress v4l-compliance warnings silently correct
+	 * the pixelformat
+	 */
+	if (vpif_params->iface.if_type == VPIF_IF_RAW_BAYER) {
+		if (pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8)
+			pixfmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
+	} else {
+		if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
+			pixfmt->pixelformat = V4L2_PIX_FMT_YUV422P;
+	}
+
+	common->fmt.fmt.pix.pixelformat = pixfmt->pixelformat;
 
-	return vpif_check_format(ch, pixfmt, 1);
+	vpif_update_std_info(ch);
+
+	pixfmt->field = common->fmt.fmt.pix.field;
+	pixfmt->colorspace = common->fmt.fmt.pix.colorspace;
+	pixfmt->bytesperline = common->fmt.fmt.pix.width;
+	pixfmt->width = common->fmt.fmt.pix.width;
+	pixfmt->height = common->fmt.fmt.pix.height;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height * 2;
+	pixfmt->priv = 0;
+
+	return 0;
 }
 
 
@@ -1081,20 +996,17 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct v4l2_pix_format *pixfmt;
-	int ret = 0;
+	int ret;
 
 	vpif_dbg(2, debug, "%s\n", __func__);
 
 	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
 
-	pixfmt = &fmt->fmt.pix;
-	/* Check for valid field format */
-	ret = vpif_check_format(ch, pixfmt, 0);
-
+	ret = vpif_try_fmt_vid_cap(file, priv, fmt);
 	if (ret)
 		return ret;
+
 	/* store the format in the channel object */
 	common->fmt = *fmt;
 	return 0;
@@ -1440,6 +1352,11 @@ static int vpif_probe_complete(void)
 		if (err)
 			goto probe_out;
 
+		/* set initial format */
+		ch->video.stdid = V4L2_STD_525_60;
+		memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
+		vpif_update_std_info(ch);
+
 		/* Initialize vb2 queue */
 		q = &common->buffer_queue;
 		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-- 
1.7.9.5

