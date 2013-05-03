Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676Ab3ECIRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:17:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43378 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761830Ab3ECIRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:17:36 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=5D=20media=3A=20i2c=3A=20tvp7002=3A=20enable=20TVP7002=20decoder=20for=20media=20controller=20based=20usage?=
Date: Fri,  3 May 2013 13:47:19 +0530
Message-Id: <1367569039-12735-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch enables tvp7002 decoder driver for media controller
based usage by adding v4l2_subdev_pad_ops  operations support
for enum_mbus_code, set_pad_format, get_pad_format and media_entity_init()
on probe and media_entity_cleanup() on remove.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
  1: Fixed review comment pointed by Laurent, Don’t return error for set_fmt
    but fix the input parameters according to current timings.

 Changes for v3:
  1: Fixed review comments pointed by Laurent.

 drivers/media/i2c/tvp7002.c |   96 ++++++++++++++++++++++++++++++++++++++++--
 include/media/tvp7002.h     |    2 +
 2 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 027809c..270e699 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -424,6 +424,7 @@ struct tvp7002 {
 	int streaming;
 
 	const struct tvp7002_timings_definition *current_timings;
+	struct media_pad pad;
 };
 
 /*
@@ -880,6 +881,65 @@ static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
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
+	fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
+	fmt->format.width = tvp7002->current_timings->timings.bt.width;
+	fmt->format.height = tvp7002->current_timings->timings.bt.height;
+	fmt->format.field = tvp7002->current_timings->scanmode;
+	fmt->format.colorspace = tvp7002->current_timings->color_space;
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
+	return tvp7002_get_pad_format(sd, fh, fmt);
+}
+
 /* V4L2 core operation handlers */
 static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 	.g_chip_ident = tvp7002_g_chip_ident,
@@ -910,10 +970,18 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
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
@@ -993,19 +1061,35 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
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
+		goto error;
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
 	return 0;
+
+error:
+	v4l2_ctrl_handler_free(&device->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&device->sd.entity);
+#endif
+	return error;
 }
 
 /*
@@ -1022,7 +1106,9 @@ static int tvp7002_remove(struct i2c_client *c)
 
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

