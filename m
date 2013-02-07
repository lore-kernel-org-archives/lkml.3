Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab3BGFkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:40:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53487 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3BGFkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:40:47 -0500
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <marbugge@cisco.com>, Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH v3] media: ths7353: add support for ths7353 video amplifier
Date: Thu,  7 Feb 2013 11:10:28 +0530
Message-Id: <1360215628-25303-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

The patch adds support for THS7353 video amplifier.
The the THS7353 amplifier is very much similar to the
existing THS7303 video amplifier driver.
This patch appropriately makes changes to the existing
ths7303 driver and adds support for the THS7353.
This patch also adds V4L2_IDENT_THS7353 for the THS7353
chip and appropriate changes to Kconfig file for building.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
Cc: Chaithrika U S <chaithrika@ti.com>
---
 Changes for v3:
 1: Fixed review comments pointed out by Hans.

 Changes for v2:
 1: Merged the driver in existing ths7303 driver.
 2: Merged the patch which adds the chip indent in same patch.

 drivers/media/i2c/Kconfig       |    6 +-
 drivers/media/i2c/ths7303.c     |  353 ++++++++++++++++++++++++++++++++-------
 include/media/ths7303.h         |   42 +++++
 include/media/v4l2-chip-ident.h |    3 +
 4 files changed, 343 insertions(+), 61 deletions(-)
 create mode 100644 include/media/ths7303.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ecdf7e3..bd08541 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -576,10 +576,10 @@ config VIDEO_UPD64083
 comment "Miscelaneous helper chips"
 
 config VIDEO_THS7303
-	tristate "THS7303 Video Amplifier"
-	depends on I2C
+	tristate "THS7303/53 Video Amplifier"
+	depends on VIDEO_V4L2 && I2C
 	help
-	  Support for TI THS7303 video amplifier
+	  Support for TI THS7303/53 video amplifier
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ths7303.
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index e747524..7300abc 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -1,7 +1,15 @@
 /*
- * ths7303- THS7303 Video Amplifier driver
+ * ths7303/53- THS7303/53 Video Amplifier driver
  *
  * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.
+ *
+ * Author: Chaithrika U S <chaithrika@ti.com>
+ *
+ * Contributors:
+ *     Lad, Prabhakar <prabhakar.lad@ti.com>
+ *     Hans Verkuil <hans.verkuil@cisco.com>
+ *     Martin Bugge <marbugge@cisco.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -13,25 +21,27 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/ctype.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/device.h>
-#include <linux/delay.h>
 #include <linux/module.h>
-#include <linux/uaccess.h>
-#include <linux/videodev2.h>
+#include <linux/slab.h>
 
-#include <media/v4l2-device.h>
-#include <media/v4l2-subdev.h>
+#include <media/ths7303.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-device.h>
 
 #define THS7303_CHANNEL_1	1
 #define THS7303_CHANNEL_2	2
 #define THS7303_CHANNEL_3	3
 
+struct ths7303_state {
+	struct v4l2_subdev		sd;
+	struct ths7303_platform_data	pdata;
+	struct v4l2_bt_timings		bt;
+	int std_id;
+	int stream_on;
+	int driver_data;
+};
+
 enum ths7303_filter_mode {
 	THS7303_FILTER_MODE_480I_576I,
 	THS7303_FILTER_MODE_480P_576P,
@@ -48,64 +58,84 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
+static inline struct ths7303_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ths7303_state, sd);
+}
+
+static int ths7303_read(struct v4l2_subdev *sd, u8 reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int ths7303_write(struct v4l2_subdev *sd, u8 reg, u8 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		ret = i2c_smbus_write_byte_data(client, reg, val);
+		if (ret == 0)
+			return 0;
+	}
+	return ret;
+}
+
 /* following function is used to set ths7303 */
 int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
 {
-	u8 input_bias_chroma = 3;
-	u8 input_bias_luma = 3;
-	int disable = 0;
-	int err = 0;
-	u8 val = 0;
-	u8 temp;
-
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ths7303_state *state = to_state(sd);
+	struct ths7303_platform_data *pdata = &state->pdata;
+	u8 val, sel = 0;
+	int err, disable = 0;
 
 	if (!client)
 		return -EINVAL;
 
 	switch (mode) {
 	case THS7303_FILTER_MODE_1080P:
-		val = (3 << 6);
-		val |= (3 << 3);
+		sel = 0x3;	/*1080p and SXGA/UXGA */
 		break;
 	case THS7303_FILTER_MODE_720P_1080I:
-		val = (2 << 6);
-		val |= (2 << 3);
+		sel = 0x2;	/*720p, 1080i and SVGA/XGA */
 		break;
 	case THS7303_FILTER_MODE_480P_576P:
-		val = (1 << 6);
-		val |= (1 << 3);
+		sel = 0x1;	/* EDTV 480p/576p and VGA */
 		break;
 	case THS7303_FILTER_MODE_480I_576I:
+		sel = 0x0;	/* SDTV, S-Video, 480i/576i */
 		break;
-	case THS7303_FILTER_MODE_DISABLE:
-		pr_info("mode disabled\n");
-		/* disable all channels */
-		disable = 1;
 	default:
 		/* disable all channels */
 		disable = 1;
 	}
-	/* Setup channel 2 - Luma - Green */
-	temp = val;
+
+	val = (sel << 6) | (sel << 3);
 	if (!disable)
-		val |= input_bias_luma;
-	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_2, val);
+		val |= (pdata->ch_1 & 0x27);
+	err = ths7303_write(sd, 0x01, val);
 	if (err)
 		goto out;
 
-	/* setup two chroma channels */
+	val = (sel << 6) | (sel << 3);
 	if (!disable)
-		temp |= input_bias_chroma;
-
-	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_1, temp);
+		val |= (pdata->ch_2 & 0x27);
+	err = ths7303_write(sd, 0x02, val);
 	if (err)
 		goto out;
 
-	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_3, temp);
+	val = (sel << 6) | (sel << 3);
+	if (!disable)
+		val |= (pdata->ch_3 & 0x27);
+	err = ths7303_write(sd, 0x03, val);
 	if (err)
 		goto out;
-	return err;
+
+	return 0;
 out:
 	pr_info("write byte data failed\n");
 	return err;
@@ -113,49 +143,213 @@ out:
 
 static int ths7303_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
-	if (norm & (V4L2_STD_ALL & ~V4L2_STD_SECAM))
+	struct ths7303_state *state = to_state(sd);
+
+	if (norm & (V4L2_STD_ALL & ~V4L2_STD_SECAM)) {
+		state->std_id = 1;
+		state->bt.pixelclock = 0;
 		return ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I);
-	else
-		return ths7303_setval(sd, THS7303_FILTER_MODE_DISABLE);
+	}
+
+	return ths7303_setval(sd, THS7303_FILTER_MODE_DISABLE);
 }
 
-/* for setting filter for HD output */
-static int ths7303_s_dv_timings(struct v4l2_subdev *sd,
-			       struct v4l2_dv_timings *dv_timings)
+static int ths7303_config(struct v4l2_subdev *sd)
 {
-	u32 height = dv_timings->bt.height;
-	int interlaced = dv_timings->bt.interlaced;
-	int res = 0;
+	struct ths7303_state *state = to_state(sd);
+	int res;
+
+	if (!state->stream_on) {
+		ths7303_write(sd, THS7303_CHANNEL_1,
+			      (ths7303_read(sd, THS7303_CHANNEL_1) & 0xf8) |
+			      0x00);
+		ths7303_write(sd, THS7303_CHANNEL_2,
+			      (ths7303_read(sd, THS7303_CHANNEL_2) & 0xf8) |
+			      0x00);
+		ths7303_write(sd, THS7303_CHANNEL_3,
+			      (ths7303_read(sd, THS7303_CHANNEL_3) & 0xf8) |
+			      0x00);
+		return 0;
+	}
 
-	if (height == 1080 && !interlaced)
+	if (state->bt.pixelclock > 120000000)
 		res = ths7303_setval(sd, THS7303_FILTER_MODE_1080P);
-	else if ((height == 720 && !interlaced) ||
-			(height == 1080 && interlaced))
+	else if (state->bt.pixelclock > 70000000)
 		res = ths7303_setval(sd, THS7303_FILTER_MODE_720P_1080I);
-	else if ((height == 480 || height == 576) && !interlaced)
+	else if (state->bt.pixelclock > 20000000)
 		res = ths7303_setval(sd, THS7303_FILTER_MODE_480P_576P);
+	else if (state->std_id)
+		res = ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I);
 	else
 		/* disable all channels */
 		res = ths7303_setval(sd, THS7303_FILTER_MODE_DISABLE);
 
 	return res;
+
+}
+
+static int ths7303_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ths7303_state *state = to_state(sd);
+
+	state->stream_on = enable;
+
+	return ths7303_config(sd);
+}
+
+/* for setting filter for HD output */
+static int ths7303_s_dv_timings(struct v4l2_subdev *sd,
+			       struct v4l2_dv_timings *dv_timings)
+{
+	struct ths7303_state *state = to_state(sd);
+
+	if (!dv_timings || dv_timings->type != V4L2_DV_BT_656_1120)
+		return -EINVAL;
+
+	state->bt = dv_timings->bt;
+	state->std_id = 0;
+
+	return ths7303_config(sd);
 }
 
 static int ths7303_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *chip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 indent = V4L2_IDENT_THS7303;
+	struct ths7303_state *state = to_state(sd);
 
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_THS7303, 0);
+	if (state->driver_data)
+		indent = V4L2_IDENT_THS7353;
+
+	return v4l2_chip_ident_i2c_client(client, chip, indent, 0);
 }
 
 static const struct v4l2_subdev_video_ops ths7303_video_ops = {
+	.s_stream	= ths7303_s_stream,
 	.s_std_output	= ths7303_s_std_output,
-	.s_dv_timings    = ths7303_s_dv_timings,
+	.s_dv_timings   = ths7303_s_dv_timings,
+};
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+static int ths7303_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	reg->size = 1;
+	reg->val = ths7303_read(sd, reg->reg);
+	return 0;
+}
+
+static int ths7303_s_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ths7303_write(sd, reg->reg, reg->val);
+	return 0;
+}
+#endif
+
+static const char * const stc_lpf_sel_txt[4] = {
+	"500-kHz Filter",
+	"2.5-MHz Filter",
+	"5-MHz Filter",
+	"5-MHz Filter",
+};
+
+static const char * const in_mux_sel_txt[2] = {
+	"Input A Select",
+	"Input B Select",
+};
+
+static const char * const lpf_freq_sel_txt[4] = {
+	"9-MHz LPF",
+	"16-MHz LPF",
+	"35-MHz LPF",
+	"Bypass LPF",
 };
 
+static const char * const in_bias_sel_dis_cont_txt[8] = {
+	"Disable Channel",
+	"Mute Function - No Output",
+	"DC Bias Select",
+	"DC Bias + 250 mV Offset Select",
+	"AC Bias Select",
+	"Sync Tip Clamp with low bias",
+	"Sync Tip Clamp with mid bias",
+	"Sync Tip Clamp with high bias",
+};
+
+static void ths7303_log_channel_status(struct v4l2_subdev *sd, u8 reg)
+{
+	u8 val = ths7303_read(sd, reg);
+
+	if ((val & 0x7) == 0) {
+		v4l2_info(sd, "Channel %d Off\n", reg);
+		return;
+	}
+
+	v4l2_info(sd, "Channel %d On\n", reg);
+	v4l2_info(sd, "  value 0x%x\n", val);
+	v4l2_info(sd, "  %s\n", stc_lpf_sel_txt[(val >> 6) & 0x3]);
+	v4l2_info(sd, "  %s\n", in_mux_sel_txt[(val >> 5) & 0x1]);
+	v4l2_info(sd, "  %s\n", lpf_freq_sel_txt[(val >> 3) & 0x3]);
+	v4l2_info(sd, "  %s\n", in_bias_sel_dis_cont_txt[(val >> 0) & 0x7]);
+}
+
+static int ths7303_log_status(struct v4l2_subdev *sd)
+{
+	struct ths7303_state *state = to_state(sd);
+
+	v4l2_info(sd, "stream %s\n", state->stream_on ? "On" : "Off");
+
+	if (state->bt.pixelclock) {
+		struct v4l2_bt_timings *bt = bt = &state->bt;
+		u32 frame_width, frame_height;
+
+		frame_width = bt->width + bt->hfrontporch +
+			      bt->hsync + bt->hbackporch;
+		frame_height = bt->height + bt->vfrontporch +
+			       bt->vsync + bt->vbackporch;
+		v4l2_info(sd,
+			  "timings: %dx%d%s%d (%dx%d). Pix freq. = %d Hz. Polarities = 0x%x\n",
+			  bt->width, bt->height, bt->interlaced ? "i" : "p",
+			  (frame_height * frame_width) > 0 ?
+			  (int)bt->pixelclock /
+			  (frame_height * frame_width) : 0,
+			  frame_width, frame_height,
+			  (int)bt->pixelclock, bt->polarities);
+	} else {
+		v4l2_info(sd, "no timings set\n");
+	}
+
+	ths7303_log_channel_status(sd, THS7303_CHANNEL_1);
+	ths7303_log_channel_status(sd, THS7303_CHANNEL_2);
+	ths7303_log_channel_status(sd, THS7303_CHANNEL_3);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_core_ops ths7303_core_ops = {
 	.g_chip_ident = ths7303_g_chip_ident,
+	.log_status = ths7303_log_status,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = ths7303_g_register,
+	.s_register = ths7303_s_register,
+#endif
 };
 
 static const struct v4l2_subdev_ops ths7303_ops = {
@@ -163,11 +357,38 @@ static const struct v4l2_subdev_ops ths7303_ops = {
 	.video 	= &ths7303_video_ops,
 };
 
+static int ths7303_setup(struct v4l2_subdev *sd)
+{
+	struct ths7303_state *state = to_state(sd);
+	struct ths7303_platform_data *pdata = &state->pdata;
+	int ret;
+	u8 mask;
+
+	state->stream_on = pdata->init_enable;
+
+	mask = state->stream_on ? 0xff : 0xf8;
+
+	ret = ths7303_write(sd, 0x01, pdata->ch_1 & mask);
+	if (ret)
+		return ret;
+
+	ret = ths7303_write(sd, 0x02, pdata->ch_2 & mask);
+	if (ret)
+		return ret;
+
+	ret = ths7303_write(sd, 0x03, pdata->ch_3 & mask);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int ths7303_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
+	struct ths7303_platform_data *pdata = client->dev.platform_data;
+	struct ths7303_state *state;
 	struct v4l2_subdev *sd;
-	v4l2_std_id std_id = V4L2_STD_NTSC;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -175,13 +396,28 @@ static int ths7303_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = devm_kzalloc(&client->dev, sizeof(struct v4l2_subdev), GFP_KERNEL);
-	if (sd == NULL)
+	state = devm_kzalloc(&client->dev, sizeof(struct ths7303_state),
+			     GFP_KERNEL);
+	if (!state)
 		return -ENOMEM;
 
+	if (!pdata)
+		v4l_warn(client, "No platform data, using default data!\n");
+	else
+		state->pdata = *pdata;
+
+	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &ths7303_ops);
 
-	return ths7303_s_std_output(sd, std_id);
+	/* store the driver data to differntiate the chip */
+	state->driver_data = (int)id->driver_data;
+
+	if (ths7303_setup(sd) < 0) {
+		v4l_err(client, "init failed\n");
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int ths7303_remove(struct i2c_client *client)
@@ -195,6 +431,7 @@ static int ths7303_remove(struct i2c_client *client)
 
 static const struct i2c_device_id ths7303_id[] = {
 	{"ths7303", 0},
+	{"ths7353", 1},
 	{},
 };
 
@@ -203,7 +440,7 @@ MODULE_DEVICE_TABLE(i2c, ths7303_id);
 static struct i2c_driver ths7303_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
-		.name	= "ths7303",
+		.name	= "ths73x3",
 	},
 	.probe		= ths7303_probe,
 	.remove		= ths7303_remove,
diff --git a/include/media/ths7303.h b/include/media/ths7303.h
new file mode 100644
index 0000000..fa58ae0
--- /dev/null
+++ b/include/media/ths7303.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Inc
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.
+ *
+ * Contributors:
+ *     Lad, Prabhakar <prabhakar.lad@ti.com>
+ *     Hans Verkuil <hans.verkuil@cisco.com>
+ *     Martin Bugge <marbugge@cisco.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef THS7353_H
+#define THS7353_H
+
+/**
+ * struct ths7303_platform_data - Platform dependent data
+ * @ch_1: Bias value for channel one.
+ * @ch_2: Bias value for channel two.
+ * @ch_3: Bias value for channel three.
+ * @init_enable: initalize on init.
+ */
+struct ths7303_platform_data {
+	u8 ch_1;
+	u8 ch_2;
+	u8 ch_3;
+	u8 init_enable;
+};
+
+#endif
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 4ee125b..f9f687e 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -180,6 +180,9 @@ enum {
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,
 
+	/* module ths7353: just ident 7353 */
+	V4L2_IDENT_THS7353 = 7353,
+
 	/* module adv7393: just ident 7393 */
 	V4L2_IDENT_ADV7393 = 7393,
 
-- 
1.7.4.1

