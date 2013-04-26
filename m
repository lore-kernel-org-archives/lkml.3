Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3DZIGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:06:09 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:34807 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab3DZIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:05:47 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: tvp7002: enable TVP7002 decoder for media controller based usage
Date: Fri, 26 Apr 2013 13:35:35 +0530
Message-Id: <1366963535-15963-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch enables tvp7002 decoder driver for media controller
based usage by adding v4l2_subdev_pad_ops  operations support
for enum_mbus_code, set_pad_format, get_pad_format and media_entity_init()
on probe and media_entity_cleanup() on remove.

The device supports 1 output pad and no input pads.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/tvp7002.c |  125 +++++++++++++++++++++++++++++++++++++++++--
 include/media/tvp7002.h     |    2 +
 2 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 027809c..b212d41 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -424,6 +424,8 @@ struct tvp7002 {
 	int streaming;
 
 	const struct tvp7002_timings_definition *current_timings;
+	struct media_pad pad;
+	struct v4l2_mbus_framefmt format;
 };
 
 /*
@@ -880,6 +882,93 @@ static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
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
+*/
+static int
+tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *fmt)
+{
+	struct tvp7002 *tvp7002 = to_tvp7002(sd);
+
+	/* Check pad index is valid */
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	if (fmt->format.field != tvp7002->current_timings->scanmode ||
+	    fmt->format.code != V4L2_MBUS_FMT_YUYV10_1X20 ||
+	    fmt->format.colorspace != tvp7002->current_timings->color_space ||
+	    fmt->format.width != tvp7002->current_timings->timings.bt.width ||
+	    fmt->format.height != tvp7002->current_timings->timings.bt.height)
+		return -EINVAL;
+
+	tvp7002->format = fmt->format;
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
+	struct tvp7002 *tvp7002 = to_tvp7002(sd);
+
+	/* Check pad index is valid */
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		fmt->format = tvp7002->format;
+		return 0;
+	}
+
+	fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
+	fmt->format.width = tvp7002->current_timings->timings.bt.width;
+	fmt->format.height = tvp7002->current_timings->timings.bt.height;
+	fmt->format.field = tvp7002->current_timings->scanmode;
+	fmt->format.colorspace = tvp7002->current_timings->color_space;
+
+	return 0;
+}
+
 /* V4L2 core operation handlers */
 static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 	.g_chip_ident = tvp7002_g_chip_ident,
@@ -910,10 +999,18 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
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
@@ -993,19 +1090,35 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	timings = device->current_timings->timings;
 	error = tvp7002_s_dv_timings(sd, &timings);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	strlcpy(sd->name, TVP7002_MODULE_NAME, sizeof(sd->name));
+	device->pad.flags = MEDIA_PAD_FL_SOURCE;
+	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	device->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+
+	error = media_entity_init(&device->sd.entity, 1, &device->pad, 0);
+	if (error < 0)
+		return error;
+#endif
+
 	v4l2_ctrl_handler_init(&device->hdl, 1);
 	v4l2_ctrl_new_std(&device->hdl, &tvp7002_ctrl_ops,
 			V4L2_CID_GAIN, 0, 255, 1, 0);
 	sd->ctrl_handler = &device->hdl;
 	if (device->hdl.error) {
-		int err = device->hdl.error;
-
-		v4l2_ctrl_handler_free(&device->hdl);
-		return err;
+		error = device->hdl.error;
+		goto done;
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
 	return 0;
+
+done:
+	v4l2_ctrl_handler_free(&device->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&device->sd.entity);
+#endif
+	return error;
 }
 
 /*
@@ -1022,7 +1135,9 @@ static int tvp7002_remove(struct i2c_client *c)
 
 	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
 				"on address 0x%x\n", c->addr);
-
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&device->sd.entity);
+#endif
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&device->hdl);
 	return 0;
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

