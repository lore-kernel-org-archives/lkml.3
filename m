Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3AYJwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:52:00 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:34702 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3AYJvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:51:54 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] media: tvp514x: enable TVP514X for media controller based usage
Date: Fri, 25 Jan 2013 15:21:40 +0530
Message-Id: <1359107500-16039-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add support for TVP514x as a media entity and support for
pad operations. The decoder supports 1 output pad.
The default format code was V4L2_MBUS_FMT_YUYV10_2X10
changed it to V4L2_MBUS_FMT_UYVY8_2X8.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 This patch depends on patch http://patchwork.linuxtv.org/patch/16458/

 drivers/media/i2c/tvp514x.c |  161 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 153 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index d5e1021..f0a768b 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -12,6 +12,7 @@
  *     Hardik Shah <hardik.shah@ti.com>
  *     Manjunath Hadli <mrh@ti.com>
  *     Karicheri Muralidharan <m-karicheri2@ti.com>
+ *     Prabhakar Lad <prabhakar.lad@ti.com>
  *
  * This package is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -33,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
+#include <linux/v4l2-mediabus.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
@@ -40,12 +42,10 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/tvp514x.h>
+#include <media/media-entity.h>
 
 #include "tvp514x_regs.h"
 
-/* Module Name */
-#define TVP514X_MODULE_NAME		"tvp514x"
-
 /* Private macros for TVP */
 #define I2C_RETRY_COUNT                 (5)
 #define LOCK_RETRY_COUNT                (5)
@@ -91,6 +91,9 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
  * @pdata: Board specific
  * @ver: Chip version
  * @streaming: TVP5146/47 decoder streaming - enabled or disabled.
+ * @pix: Current pixel format
+ * @num_fmts: Number of formats
+ * @fmt_list: Format list
  * @current_std: Current standard
  * @num_stds: Number of standards
  * @std_list: Standards list
@@ -106,12 +109,20 @@ struct tvp514x_decoder {
 	int ver;
 	int streaming;
 
+	struct v4l2_pix_format pix;
+	int num_fmts;
+	const struct v4l2_fmtdesc *fmt_list;
+
 	enum tvp514x_std current_std;
 	int num_stds;
 	const struct tvp514x_std_info *std_list;
 	/* Input and Output Routing parameters */
 	u32 input;
 	u32 output;
+
+	/* mc related members */
+	struct media_pad pad;
+	struct v4l2_mbus_framefmt format;
 };
 
 /* TVP514x default register values */
@@ -200,6 +211,21 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
 };
 
 /**
+ * List of image formats supported by TVP5146/47 decoder
+ * Currently we are using 8 bit mode only, but can be
+ * extended to 10/20 bit mode.
+ */
+static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
+	{
+	 .index		= 0,
+	 .type		= V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	 .flags		= 0,
+	 .description	= "8-bit UYVY 4:2:2 Format",
+	 .pixelformat	= V4L2_PIX_FMT_UYVY,
+	},
+};
+
+/**
  * Supported standards -
  *
  * Currently supports two standards only, need to add support for rest of the
@@ -733,7 +759,7 @@ tvp514x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
 }
 
 /**
- * tvp514x_mbus_fmt_cap() - V4L2 decoder interface handler for try/s/g_mbus_fmt
+ * tvp514x_mbus_fmt() - V4L2 decoder interface handler for try/s/g_mbus_fmt
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to the mediabus format structure
  *
@@ -751,12 +777,11 @@ tvp514x_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
 	/* Calculate height and width based on current standard */
 	current_std = decoder->current_std;
 
-	f->code = V4L2_MBUS_FMT_YUYV10_2X10;
+	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
 	f->width = decoder->std_list[current_std].width;
 	f->height = decoder->std_list[current_std].height;
 	f->field = V4L2_FIELD_INTERLACED;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
-
 	v4l2_dbg(1, debug, sd, "MBUS_FMT: Width - %d, Height - %d\n",
 			f->width, f->height);
 	return 0;
@@ -892,6 +917,88 @@ static const struct v4l2_ctrl_ops tvp514x_ctrl_ops = {
 	.s_ctrl = tvp514x_s_ctrl,
 };
 
+/**
+ * tvp514x_enum_mbus_code() - V4L2 decoder interface handler for enum_mbus_code
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ *
+ * Enumertaes mbus codes supported
+ */
+static int tvp514x_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	u32 pad = code->pad;
+	u32 index = code->index;
+
+	memset(code, 0, sizeof(*code));
+	code->index = index;
+	code->pad = pad;
+
+	if (index != 0)
+		return -EINVAL;
+
+	code->code = V4L2_MBUS_FMT_YUYV8_2X8;
+
+	return 0;
+}
+
+/**
+ * tvp514x_get_pad_format() - V4L2 decoder interface handler for get pad format
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle
+ * @format: pointer to v4l2_subdev_format structure
+ *
+ * Retrieves pad format which is active or tried based on requirement
+ */
+static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *format)
+{
+	struct tvp514x_decoder *decoder = to_decoder(sd);
+	__u32 which = format->which;
+
+	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		format->format = decoder->format;
+		return 0;
+	}
+
+	format->format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+	format->format.width = tvp514x_std_list[decoder->current_std].width;
+	format->format.height = tvp514x_std_list[decoder->current_std].height;
+	format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	format->format.field = V4L2_FIELD_INTERLACED;
+
+	return 0;
+}
+
+/**
+ * tvp514x_set_pad_format() - V4L2 decoder interface handler for set pad format
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle
+ * @format: pointer to v4l2_subdev_format structure
+ *
+ * Set pad format for the output pad
+ */
+static int tvp514x_set_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct tvp514x_decoder *decoder = to_decoder(sd);
+
+	if (fmt->format.field != V4L2_FIELD_INTERLACED ||
+	    fmt->format.code != V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    fmt->format.colorspace != V4L2_COLORSPACE_SMPTE170M ||
+	    fmt->format.width != tvp514x_std_list[decoder->current_std].width ||
+	    fmt->format.height != tvp514x_std_list[decoder->current_std].height)
+		return -EINVAL;
+
+	decoder->format = fmt->format;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
@@ -915,13 +1022,33 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_stream = tvp514x_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops tvp514x_pad_ops = {
+	.enum_mbus_code = tvp514x_enum_mbus_code,
+	.get_fmt = tvp514x_get_pad_format,
+	.set_fmt = tvp514x_set_pad_format,
+};
+
 static const struct v4l2_subdev_ops tvp514x_ops = {
 	.core = &tvp514x_core_ops,
 	.video = &tvp514x_video_ops,
+	.pad = &tvp514x_pad_ops,
 };
 
 static struct tvp514x_decoder tvp514x_dev = {
 	.streaming = 0,
+	.fmt_list = tvp514x_fmt_list,
+	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
+	.pix = {
+		/* Default to NTSC 8-bit YUV 422 */
+		.width		= NTSC_NUM_ACTIVE_PIXELS,
+		.height		= NTSC_NUM_ACTIVE_LINES,
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.field		= V4L2_FIELD_INTERLACED,
+		.bytesperline	= NTSC_NUM_ACTIVE_PIXELS * 2,
+		.sizeimage	= NTSC_NUM_ACTIVE_PIXELS * 2 *
+					NTSC_NUM_ACTIVE_LINES,
+		.colorspace	= V4L2_COLORSPACE_SMPTE170M,
+		},
 	.current_std = STD_NTSC_MJ,
 	.std_list = tvp514x_std_list,
 	.num_stds = ARRAY_SIZE(tvp514x_std_list),
@@ -941,6 +1068,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct tvp514x_decoder *decoder;
 	struct v4l2_subdev *sd;
+	int ret;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -981,7 +1109,21 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Register with V4L2 layer as slave device */
 	sd = &decoder->sd;
 	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
+	strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
+	decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	decoder->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
 
+	ret = media_entity_init(&decoder->sd.entity, 1, &decoder->pad, 0);
+	if (ret < 0) {
+		v4l2_err(sd, "%s decoder driver failed to register !!\n",
+			 sd->name);
+		kfree(decoder);
+		return ret;
+	}
+#endif
 	v4l2_ctrl_handler_init(&decoder->hdl, 5);
 	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
 		V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -995,11 +1137,11 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
 	sd->ctrl_handler = &decoder->hdl;
 	if (decoder->hdl.error) {
-		int err = decoder->hdl.error;
+		ret = decoder->hdl.error;
 
 		v4l2_ctrl_handler_free(&decoder->hdl);
 		kfree(decoder);
-		return err;
+		return ret;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
@@ -1022,6 +1164,9 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	v4l2_device_unregister_subdev(sd);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&decoder->sd.entity);
+#endif
 	v4l2_ctrl_handler_free(&decoder->hdl);
 	kfree(decoder);
 	return 0;
-- 
1.7.4.1

