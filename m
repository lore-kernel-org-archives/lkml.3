Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaEPNlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:05 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60702 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbaEPNlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:01 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 25/49] media: davinci: vpif_display: fix v4l-complinace issues
Date: Fri, 16 May 2014 19:03:30 +0530
Message-Id: <1400247235-31434-27-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_display.c |  138 +++++++++----------------
 1 file changed, 51 insertions(+), 87 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index f581e7a..cda0851 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -466,6 +466,7 @@ static int vpif_update_resolution(struct channel_obj *ch)
 			return -EINVAL;
 	}
 
+	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
 	common->fmt.fmt.pix.width = std_info->width;
 	common->fmt.fmt.pix.height = std_info->height;
 	vpif_dbg(1, debug, "Pixel details: Width = %d,Height = %d\n",
@@ -474,6 +475,17 @@ static int vpif_update_resolution(struct channel_obj *ch)
 	/* Set height and width paramateres */
 	common->height = std_info->height;
 	common->width = std_info->width;
+	common->fmt.fmt.pix.sizeimage = common->height * common->width * 2;
+
+	if (vid_ch->stdid)
+		common->fmt.fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		common->fmt.fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+
+	if (ch->vpifparams.std_info.frm_fmt)
+		common->fmt.fmt.pix.field = V4L2_FIELD_NONE;
+	else
+		common->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
 
 	return 0;
 }
@@ -544,63 +556,6 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	ch->vpifparams.video_params.stdid = ch->vpifparams.std_info.stdid;
 }
 
-static void vpif_config_format(struct channel_obj *ch)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
-	common->fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-}
-
-static int vpif_check_format(struct channel_obj *ch,
-			     struct v4l2_pix_format *pixfmt)
-{
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	enum v4l2_field field = pixfmt->field;
-	u32 sizeimage, hpitch, vpitch;
-
-	if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
-		goto invalid_fmt_exit;
-
-	if (!(VPIF_VALID_FIELD(field)))
-		goto invalid_fmt_exit;
-
-	if (pixfmt->bytesperline <= 0)
-		goto invalid_pitch_exit;
-
-	sizeimage = pixfmt->sizeimage;
-
-	if (vpif_update_resolution(ch))
-		return -EINVAL;
-
-	hpitch = pixfmt->bytesperline;
-	vpitch = sizeimage / (hpitch * 2);
-
-	/* Check for valid value of pitch */
-	if ((hpitch < ch->vpifparams.std_info.width) ||
-	    (vpitch < ch->vpifparams.std_info.height))
-		goto invalid_pitch_exit;
-
-	/* Check for 8 byte alignment */
-	if (!ISALIGNED(hpitch)) {
-		vpif_err("invalid pitch alignment\n");
-		return -EINVAL;
-	}
-	pixfmt->width = common->fmt.fmt.pix.width;
-	pixfmt->height = common->fmt.fmt.pix.height;
-
-	return 0;
-
-invalid_fmt_exit:
-	vpif_err("invalid field format\n");
-	return -EINVAL;
-
-invalid_pitch_exit:
-	vpif_err("invalid pitch\n");
-	return -EINVAL;
-}
-
 static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 {
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
@@ -640,16 +595,14 @@ static int vpif_querycap(struct file *file, void  *priv,
 static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *fmt)
 {
-	if (fmt->index != 0) {
-		vpif_err("Invalid format index\n");
+	if (fmt->index != 0)
 		return -EINVAL;
-	}
 
 	/* Fill in the information about format */
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	strcpy(fmt->description, "YCbCr4:2:2 YC Planar");
 	fmt->pixelformat = V4L2_PIX_FMT_YUV422P;
-
+	fmt->flags = 0;
 	return 0;
 }
 
@@ -670,47 +623,57 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
-static int vpif_s_fmt_vid_out(struct file *file, void *priv,
+static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct v4l2_pix_format *pixfmt;
-	int ret = 0;
+	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
-	if (vb2_is_busy(&common->buffer_queue))
-		return -EBUSY;
+	/*
+	 * to supress v4l-compliance warnings silently correct
+	 * the pixelformat
+	 */
+	if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
+		pixfmt->pixelformat = common->fmt.fmt.pix.pixelformat;
 
-	pixfmt = &fmt->fmt.pix;
-	/* Check for valid field format */
-	ret = vpif_check_format(ch, pixfmt);
-	if (ret)
-		return ret;
+	if (vpif_update_resolution(ch))
+		return -EINVAL;
+
+	pixfmt->colorspace = common->fmt.fmt.pix.colorspace;
+	pixfmt->field = common->fmt.fmt.pix.field;
+	pixfmt->bytesperline = common->fmt.fmt.pix.width;
+	pixfmt->width = common->fmt.fmt.pix.width;
+	pixfmt->height = common->fmt.fmt.pix.height;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height * 2;
+	pixfmt->priv = 0;
 
-	/* store the pix format in the channel object */
-	common->fmt.fmt.pix = *pixfmt;
-	/* store the format in the channel object */
-	common->fmt = *fmt;
 	return 0;
 }
 
-static int vpif_try_fmt_vid_out(struct file *file, void *priv,
+static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
-	int ret = 0;
+	int ret;
 
-	ret = vpif_check_format(ch, pixfmt);
-	if (ret) {
-		*pixfmt = common->fmt.fmt.pix;
-		pixfmt->sizeimage = pixfmt->width * pixfmt->height * 2;
-	}
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
 
-	return ret;
+	ret = vpif_try_fmt_vid_out(file, priv, fmt);
+	if (ret)
+		return ret;
+
+	/* store the pix format in the channel object */
+	common->fmt.fmt.pix = *pixfmt;
+
+	/* store the format in the channel object */
+	common->fmt = *fmt;
+	return 0;
 }
 
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
@@ -738,7 +701,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	if (!(std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
-
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = std_id;
 	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
@@ -747,8 +709,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 		return -EINVAL;
 
 	common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
-	/* Configure the default format information */
-	vpif_config_format(ch);
 
 	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
 						s_std_output, std_id);
@@ -1215,6 +1175,11 @@ static int vpif_probe_complete(void)
 		if (err)
 			goto probe_out;
 
+		/* set initial format */
+		ch->video.stdid = V4L2_STD_525_60;
+		memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
+		vpif_update_resolution(ch);
+
 		/* Initialize vb2 queue */
 		q = &common->buffer_queue;
 		q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
@@ -1226,7 +1191,6 @@ static int vpif_probe_complete(void)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 1;
 		q->lock = &common->lock;
-
 		err = vb2_queue_init(q);
 		if (err) {
 			vpif_err("vpif_display: vb2_queue_init() failed\n");
-- 
1.7.9.5

