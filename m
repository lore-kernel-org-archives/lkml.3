Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3AYHB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:01:58 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52554 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3AYHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:01:54 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 2/2] media: tvp7002: enable TVP7002 decoder for media controller based usage
Date: Fri, 25 Jan 2013 12:31:08 +0530
Message-Id: <1359097268-22779-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
References: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add pad operations support for g_mbus_fmt, enum_mbus_code,
set_pad_format, get_pad_format and media_entity_init.
The device supports 1 output pad and no input pads.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/i2c/tvp7002.c |  132 +++++++++++++++++++++++++++++++++++++++++-
 include/media/tvp7002.h     |    2 +
 2 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index fb6a5b5..312651e 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -41,9 +41,6 @@ MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
 MODULE_AUTHOR("Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>");
 MODULE_LICENSE("GPL");
 
-/* Module Name */
-#define TVP7002_MODULE_NAME	"tvp7002"
-
 /* I2C retry attempts */
 #define I2C_RETRY_COUNT		(5)
 
@@ -432,6 +429,9 @@ struct tvp7002 {
 	int streaming;
 
 	const struct tvp7002_preset_definition *current_preset;
+	/* mc related members */
+	struct media_pad pad;
+	struct v4l2_mbus_framefmt format;
 };
 
 /*
@@ -967,6 +967,109 @@ static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
 	.s_ctrl = tvp7002_s_ctrl,
 };
 
+/*
+ * tvp7002_enum_mbus_code() - Enum supported digital video format on pad
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle for the subdev
+ * @code: pointer to subdev enum mbus code struct
+ *
+ * Enumerate supported digital video formats for pad.
+ */
+static int
+tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_mbus_code_enum *code)
+{
+	/* Check pad index is valid */
+	if (code->pad != 0)
+		return -EINVAL;
+
+	/* Check requested format index is within range */
+	if (code->index != 0)
+		return -EINVAL;
+
+	code->code = V4L2_MBUS_FMT_YUYV10_1X20;
+
+	return 0;
+}
+
+/*
+ * tvp7002_set_pad_format() - set video format on pad
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle for the subdev
+ * @fmt: pointer to subdev format struct
+ *
+ * set video format for pad.
+ */
+static int
+tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *fmt)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_dv_enum_preset e_preset;
+	int error;
+
+	/* Check pad index is valid */
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	/* Calculate height and width based on current standard */
+	error = v4l_fill_dv_preset_info(device->current_preset->preset,
+					&e_preset);
+	if (error)
+		return error;
+
+	fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
+	fmt->format.width = e_preset.width;
+	fmt->format.height = e_preset.height;
+	fmt->format.field = device->current_preset->scanmode;
+	fmt->format.colorspace = device->current_preset->color_space;
+	/* store for future use */
+	device->format = fmt->format;
+
+	return 0;
+}
+
+/*
+ * tvp7002_get_pad_format() - get video format on pad
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @fh: file handle for the subdev
+ * @fmt: pointer to subdev format struct
+ *
+ * get video format for pad.
+ */
+static int
+tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *fmt)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_dv_enum_preset e_preset;
+	__u32 which = fmt->which;
+	int error;
+
+	/* Check pad index is valid */
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		fmt->format = device->format;
+		return 0;
+	}
+
+	/* Calculate height and width based on current standard */
+	error = v4l_fill_dv_preset_info(device->current_preset->preset,
+					&e_preset);
+	if (error)
+		return error;
+
+	fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
+	fmt->format.width = e_preset.width;
+	fmt->format.height = e_preset.height;
+	fmt->format.field = device->current_preset->scanmode;
+	fmt->format.colorspace = device->current_preset->color_space;
+
+	return 0;
+}
+
 /* V4L2 core operation handlers */
 static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 	.g_chip_ident = tvp7002_g_chip_ident,
@@ -1000,10 +1103,18 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.enum_mbus_fmt = tvp7002_enum_mbus_fmt,
 };
 
+/* media pad related operation handlers */
+static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
+	.enum_mbus_code = tvp7002_enum_mbus_code,
+	.get_fmt = tvp7002_get_pad_format,
+	.set_fmt = tvp7002_set_pad_format,
+};
+
 /* V4L2 top level operation handlers */
 static const struct v4l2_subdev_ops tvp7002_ops = {
 	.core = &tvp7002_core_ops,
 	.video = &tvp7002_video_ops,
+	.pad = &tvp7002_pad_ops,
 };
 
 /*
@@ -1047,6 +1158,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 
 	/* Tell v4l2 the device is ready */
 	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
+	strlcpy(sd->name, TVP7002_MODULE_NAME, sizeof(sd->name));
 	v4l_info(c, "tvp7002 found @ 0x%02x (%s)\n",
 					c->addr, c->adapter->name);
 
@@ -1096,6 +1208,16 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	device->pad.flags = MEDIA_PAD_FL_SOURCE;
+	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	device->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+
+	error = media_entity_init(&device->sd.entity, 1, &device->pad, 0);
+	if (error < 0)
+		goto found_error;
+#endif
+
 found_error:
 	if (error < 0)
 		kfree(device);
@@ -1117,7 +1239,9 @@ static int tvp7002_remove(struct i2c_client *c)
 
 	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
 				"on address 0x%x\n", c->addr);
-
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&device->sd.entity);
+#endif
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&device->hdl);
 	kfree(device);
diff --git a/include/media/tvp7002.h b/include/media/tvp7002.h
index ee43534..7123048 100644
--- a/include/media/tvp7002.h
+++ b/include/media/tvp7002.h
@@ -26,6 +26,8 @@
 #ifndef _TVP7002_H_
 #define _TVP7002_H_
 
+#define TVP7002_MODULE_NAME "tvp7002"
+
 /* Platform-dependent data
  *
  * clk_polarity:
-- 
1.7.4.1

