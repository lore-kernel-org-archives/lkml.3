Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab3FCR1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:27:15 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52265 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230Ab3FCR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:27:12 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mats Randgaard <mats.randgaard@cisco.com>,
        Martin Bugge <martin.bugge@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: i2c: ths8200: driver for TI video encoder.
Date: Mon,  3 Jun 2013 22:56:17 +0530
Message-Id: <1370280378-2570-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370280378-2570-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1370280378-2570-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

The full datasheets are available from TI website:-

http://www.ti.com/product/ths8200

Note:- This patch adds support only for progressive format
as of now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mats Randgaard <mats.randgaard@cisco.com>
Signed-off-by: Martin Bugge <martin.bugge@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/Kconfig        |    9 +
 drivers/media/i2c/Makefile       |    1 +
 drivers/media/i2c/ths8200.c      |  560 ++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200_regs.h |  161 +++++++++++
 4 files changed, 731 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ths8200.c
 create mode 100644 drivers/media/i2c/ths8200_regs.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index f981d50..c897d42 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -425,6 +425,15 @@ config VIDEO_AK881X
 	help
 	  Video output driver for AKM AK8813 and AK8814 TV encoders
 
+config VIDEO_THS8200
+	tristate "Texas Instruments THS8200 video encoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Texas Instruments THS8200 video encoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ths8200.
+
 comment "Camera sensor devices"
 
 config VIDEO_APTINA_PLL
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 720f42d..936c4dd 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
 obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
 obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
+obj-$(CONFIG_VIDEO_THS8200) += ths8200.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
 obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
new file mode 100644
index 0000000..9396829
--- /dev/null
+++ b/drivers/media/i2c/ths8200.c
@@ -0,0 +1,560 @@
+/*
+ * ths8200 - Texas Instruments THS8200 video encoder driver
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/v4l2-dv-timings.h>
+
+#include <media/v4l2-device.h>
+
+#include "ths8200_regs.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
+MODULE_DESCRIPTION("Texas Instruments THS8200 video encoder driver");
+MODULE_AUTHOR("Mats Randgaard <mats.randgaard@cisco.com>");
+MODULE_AUTHOR("Martin Bugge <martin.bugge@cisco.com>");
+MODULE_LICENSE("GPL v2");
+
+struct ths8200_state {
+	struct v4l2_subdev sd;
+	uint8_t chip_version;
+	/* Is the ths8200 powered on? */
+	bool power_on;
+	struct v4l2_dv_timings dv_timings;
+};
+
+static const struct v4l2_dv_timings ths8200_timings[] = {
+	V4L2_DV_BT_CEA_720X480P59_94,
+	V4L2_DV_BT_CEA_1280X720P24,
+	V4L2_DV_BT_CEA_1280X720P25,
+	V4L2_DV_BT_CEA_1280X720P30,
+	V4L2_DV_BT_CEA_1280X720P50,
+	V4L2_DV_BT_CEA_1280X720P60,
+	V4L2_DV_BT_CEA_1920X1080P24,
+	V4L2_DV_BT_CEA_1920X1080P25,
+	V4L2_DV_BT_CEA_1920X1080P30,
+	V4L2_DV_BT_CEA_1920X1080P50,
+	V4L2_DV_BT_CEA_1920X1080P60,
+};
+
+static inline struct ths8200_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ths8200_state, sd);
+}
+
+static inline unsigned hblanking(const struct v4l2_bt_timings *t)
+{
+	return t->hfrontporch + t->hsync + t->hbackporch;
+}
+
+static inline unsigned htotal(const struct v4l2_bt_timings *t)
+{
+	return t->width + t->hfrontporch + t->hsync + t->hbackporch;
+}
+
+static inline unsigned vblanking(const struct v4l2_bt_timings *t)
+{
+	return t->vfrontporch + t->vsync + t->vbackporch;
+}
+
+static inline unsigned vtotal(const struct v4l2_bt_timings *t)
+{
+	return t->height + t->vfrontporch + t->vsync + t->vbackporch;
+}
+
+static int ths8200_read(struct v4l2_subdev *sd, u8 reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int ths8200_write(struct v4l2_subdev *sd, u8 reg, u8 val)
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
+	v4l2_err(sd, "I2C Write Problem\n");
+	return ret;
+}
+
+/* To set specific bits in the register, a clear-mask is given (to be AND-ed),
+ * and then the value-mask (to be OR-ed).
+ */
+static inline void
+ths8200_write_and_or(struct v4l2_subdev *sd, u8 reg,
+		     uint8_t clr_mask, uint8_t val_mask)
+{
+	ths8200_write(sd, reg, (ths8200_read(sd, reg) & clr_mask) | val_mask);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+static int ths8200_g_register(struct v4l2_subdev *sd,
+			      struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	reg->val = ths8200_read(sd, reg->reg & 0xff);
+	reg->size = 1;
+
+	return 0;
+}
+
+static int ths8200_s_register(struct v4l2_subdev *sd,
+			      const struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	ths8200_write(sd, reg->reg & 0xff, reg->val & 0xff);
+
+	return 0;
+}
+#endif
+
+static void ths8200_print_timings(struct v4l2_subdev *sd,
+				  struct v4l2_dv_timings *timings,
+				  const char *txt, bool detailed)
+{
+	struct v4l2_bt_timings *bt = &timings->bt;
+	u32 htot, vtot;
+
+	if (timings->type != V4L2_DV_BT_656_1120)
+		return;
+
+	htot = htotal(bt);
+	vtot = vtotal(bt);
+
+	v4l2_info(sd, "%s %dx%d%s%d (%dx%d)",
+		  txt, bt->width, bt->height, bt->interlaced ? "i" : "p",
+		  (htot * vtot) > 0 ? ((u32)bt->pixelclock / (htot * vtot)) : 0,
+		  htot, vtot);
+
+	if (detailed) {
+		v4l2_info(sd, "    horizontal: fp = %d, %ssync = %d, bp = %d\n",
+			  bt->hfrontporch,
+			  (bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
+			  bt->hsync, bt->hbackporch);
+		v4l2_info(sd, "    vertical: fp = %d, %ssync = %d, bp = %d\n",
+			  bt->vfrontporch,
+			  (bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
+			  bt->vsync, bt->vbackporch);
+		v4l2_info(sd,
+			  "    pixelclock: %lld, flags: 0x%x, standards: 0x%x\n",
+			  bt->pixelclock, bt->flags, bt->standards);
+	}
+}
+
+static int ths8200_log_status(struct v4l2_subdev *sd)
+{
+	struct ths8200_state *state = to_state(sd);
+	uint8_t reg_03 = ths8200_read(sd, THS8200_CHIP_CTL);
+
+	v4l2_info(sd, "----- Chip status -----\n");
+	v4l2_info(sd, "version: %u\n", state->chip_version);
+	v4l2_info(sd, "power: %s\n", (reg_03 & 0x0c) ? "off" : "on");
+	v4l2_info(sd, "reset: %s\n", (reg_03 & 0x01) ? "off" : "on");
+	v4l2_info(sd, "test pattern: %s\n",
+		  (reg_03 & 0x20) ? "enabled" : "disabled");
+	v4l2_info(sd, "format: %ux%u\n",
+		  ths8200_read(sd, THS8200_DTG2_PIXEL_CNT_MSB) * 256 +
+		  ths8200_read(sd, THS8200_DTG2_PIXEL_CNT_LSB),
+		  (ths8200_read(sd, THS8200_DTG2_LINE_CNT_MSB) & 0x07) * 256 +
+		  ths8200_read(sd, THS8200_DTG2_LINE_CNT_LSB));
+	ths8200_print_timings(sd, &state->dv_timings,
+			      "Configured format:", true);
+
+	return 0;
+}
+
+/* Power up/down ths8200 */
+static int ths8200_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ths8200_state *state = to_state(sd);
+
+	v4l2_dbg(1, debug, sd, "%s: power %s\n", __func__, on ? "on" : "off");
+
+	state->power_on = on;
+
+	/* Power up/down - leave in reset state until input video is present */
+	ths8200_write_and_or(sd, THS8200_CHIP_CTL, 0xf2, (on ? 0x00 : 0x0c));
+
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops ths8200_core_ops = {
+	.log_status = ths8200_log_status,
+	.s_power = ths8200_s_power,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = ths8200_g_register,
+	.s_register = ths8200_s_register,
+#endif
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev video operations
+ */
+
+static int ths8200_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ths8200_state *state = to_state(sd);
+
+	if (enable && !state->power_on)
+		ths8200_s_power(sd, true);
+
+	ths8200_write_and_or(sd, THS8200_CHIP_CTL, 0xfe,
+			     (enable ? 0x01 : 0x00));
+
+	v4l2_dbg(1, debug, sd, "%s: %sable\n",
+		 __func__, (enable ? "en" : "dis"));
+
+	return 0;
+}
+
+static void ths8200_core_init(struct v4l2_subdev *sd)
+{
+	/* setup clocks */
+	ths8200_write_and_or(sd, THS8200_CHIP_CTL, 0x3f, 0xc0);
+
+	/**** Data path control (DATA) ****/
+	/* Set FSADJ 700 mV,
+	 * bypass 422-444 interpolation,
+	 * input format 30 bit RGB444
+	 */
+	ths8200_write(sd, THS8200_DATA_CNTL, 0x70);
+
+	/* DTG Mode (Video blocked during blanking
+	 * VESA slave
+	 */
+	ths8200_write(sd, THS8200_DTG1_MODE, 0x87);
+
+	/**** Display Timing Generator Control, Part 1 (DTG1). ****/
+
+	/* Disable embedded syncs on the output by setting
+	 * the amplitude to zero for all channels.
+	 */
+	ths8200_write(sd, THS8200_DTG1_Y_SYNC_MSB, 0x2a);
+	ths8200_write(sd, THS8200_DTG1_CBCR_SYNC_MSB, 0x2a);
+}
+
+static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
+{
+	uint8_t polarity = 0;
+	uint16_t line_start_active_video = (bt->vsync + bt->vbackporch);
+	uint16_t line_start_front_porch  = (vtotal(bt) - bt->vfrontporch);
+
+	/*** System ****/
+	/* Set chip in reset while it is configured */
+	ths8200_s_stream(sd, false);
+
+	/* configure video output timings */
+	ths8200_write(sd, THS8200_DTG1_SPEC_A, bt->hsync);
+	ths8200_write(sd, THS8200_DTG1_SPEC_B, bt->hfrontporch);
+
+	/* Zero for progressive scan formats.*/
+	if (!bt->interlaced)
+		ths8200_write(sd, THS8200_DTG1_SPEC_C, 0x00);
+
+	/* Distance from leading edge of h sync to start of active video.
+	 * MSB in 0x2b
+	 */
+	ths8200_write(sd, THS8200_DTG1_SPEC_D_LSB,
+		      (bt->hbackporch + bt->hsync) & 0xff);
+	/* Zero for SDTV-mode. MSB in 0x2b */
+	ths8200_write(sd, THS8200_DTG1_SPEC_E_LSB, 0x00);
+	/*
+	 * MSB for dtg1_spec(d/e/h). See comment for
+	 * corresponding LSB registers.
+	 */
+	ths8200_write(sd, THS8200_DTG1_SPEC_DEH_MSB,
+		      ((bt->hbackporch + bt->hsync) & 0x100) >> 1);
+
+	/* h front porch */
+	ths8200_write(sd, THS8200_DTG1_SPEC_K_LSB, (bt->hfrontporch) & 0xff);
+	ths8200_write(sd, THS8200_DTG1_SPEC_K_MSB,
+		      ((bt->hfrontporch) & 0x700) >> 8);
+
+	/* Half the line length. Used to calculate SDTV line types. */
+	ths8200_write(sd, THS8200_DTG1_SPEC_G_LSB, (htotal(bt)/2) & 0xff);
+	ths8200_write(sd, THS8200_DTG1_SPEC_G_MSB,
+		      ((htotal(bt)/2) >> 8) & 0x0f);
+
+	/* Total pixels per line (ex. 720p: 1650) */
+	ths8200_write(sd, THS8200_DTG1_TOT_PIXELS_MSB, htotal(bt) >> 8);
+	ths8200_write(sd, THS8200_DTG1_TOT_PIXELS_LSB, htotal(bt) & 0xff);
+
+	/* Frame height and field height */
+	/* Field height should be programmed higher than frame_size for
+	 * progressive scan formats
+	 */
+	ths8200_write(sd, THS8200_DTG1_FRAME_FIELD_SZ_MSB,
+		      ((vtotal(bt) >> 4) & 0xf0) + 0x7);
+	ths8200_write(sd, THS8200_DTG1_FRAME_SZ_LSB, vtotal(bt) & 0xff);
+
+	/* Should be programmed higher than frame_size
+	 * for progressive formats
+	 */
+	if (!bt->interlaced)
+		ths8200_write(sd, THS8200_DTG1_FIELD_SZ_LSB, 0xff);
+
+	/**** Display Timing Generator Control, Part 2 (DTG2). ****/
+	/* Set breakpoint line numbers and types
+	 * THS8200 generates line types with different properties. A line type
+	 * that sets all the RGB-outputs to zero is used in the blanking areas,
+	 * while a line type that enable the RGB-outputs is used in active video
+	 * area. The line numbers for start of active video, start of front
+	 * porch and after the last line in the frame must be set with the
+	 * corresponding line types.
+	 *
+	 * Line types:
+	 * 0x9 - Full normal sync pulse: Blocks data when dtg1_pass is off.
+	 *       Used in blanking area.
+	 * 0x0 - Active video: Video data is always passed. Used in active
+	 *       video area.
+	 */
+	ths8200_write_and_or(sd, THS8200_DTG2_BP1_2_MSB, 0x88,
+			     ((line_start_active_video >> 4) & 0x70) +
+			     ((line_start_front_porch >> 8) & 0x07));
+	ths8200_write(sd, THS8200_DTG2_BP3_4_MSB, ((vtotal(bt)) >> 4) & 0x70);
+	ths8200_write(sd, THS8200_DTG2_BP1_LSB, line_start_active_video & 0xff);
+	ths8200_write(sd, THS8200_DTG2_BP2_LSB, line_start_front_porch & 0xff);
+	ths8200_write(sd, THS8200_DTG2_BP3_LSB, (vtotal(bt)) & 0xff);
+
+	/* line types */
+	ths8200_write(sd, THS8200_DTG2_LINETYPE1, 0x90);
+	ths8200_write(sd, THS8200_DTG2_LINETYPE2, 0x90);
+
+	/* h sync width transmitted */
+	ths8200_write(sd, THS8200_DTG2_HLENGTH_LSB, bt->hsync & 0xff);
+	ths8200_write_and_or(sd, THS8200_DTG2_HLENGTH_LSB_HDLY_MSB, 0x3f,
+			     (bt->hsync >> 2) & 0xc0);
+
+	/* The pixel value h sync is asserted on */
+	ths8200_write_and_or(sd, THS8200_DTG2_HLENGTH_LSB_HDLY_MSB, 0xe0,
+			     (htotal(bt) >> 8) & 0x1f);
+	ths8200_write(sd, THS8200_DTG2_HLENGTH_HDLY_LSB, htotal(bt));
+
+	/* v sync width transmitted */
+	ths8200_write(sd, THS8200_DTG2_VLENGTH1_LSB, (bt->vsync) & 0xff);
+	ths8200_write_and_or(sd, THS8200_DTG2_VLENGTH1_MSB_VDLY1_MSB, 0x3f,
+			     ((bt->vsync) >> 2) & 0xc0);
+
+	/* The pixel value v sync is asserted on */
+	ths8200_write_and_or(sd, THS8200_DTG2_VLENGTH1_MSB_VDLY1_MSB, 0xf8,
+			     (vtotal(bt)>>8) & 0x7);
+	ths8200_write(sd, THS8200_DTG2_VDLY1_LSB, vtotal(bt));
+
+	/* For progressive video vlength2 must be set to all 0 and vdly2 must
+	 * be set to all 1.
+	 */
+	ths8200_write(sd, THS8200_DTG2_VLENGTH2_LSB, 0x00);
+	ths8200_write(sd, THS8200_DTG2_VLENGTH2_MSB_VDLY2_MSB, 0x07);
+	ths8200_write(sd, THS8200_DTG2_VDLY2_LSB, 0xff);
+
+	/* Internal delay factors to synchronize the sync pulses and the data */
+	/* Experimental values delays (hor 4, ver 1) */
+	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_MSB, (htotal(bt)>>8) & 0x1f);
+	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_LSB, (htotal(bt) - 4) & 0xff);
+	ths8200_write(sd, THS8200_DTG2_VS_IN_DLY_MSB, 0);
+	ths8200_write(sd, THS8200_DTG2_VS_IN_DLY_LSB, 1);
+
+	/* Polarity of received and transmitted sync signals */
+	if (bt->polarities & V4L2_DV_HSYNC_POS_POL) {
+		polarity |= 0x01; /* HS_IN */
+		polarity |= 0x08; /* HS_OUT */
+	}
+	if (bt->polarities & V4L2_DV_VSYNC_POS_POL) {
+		polarity |= 0x02; /* VS_IN */
+		polarity |= 0x10; /* VS_OUT */
+	}
+
+	/* RGB mode, no embedded timings */
+	/* Timing of video input bus is derived from HS, VS, and FID dedicated
+	 * inputs
+	 */
+	ths8200_write(sd, THS8200_DTG2_CNTL, 0x47 | polarity);
+
+	/* leave reset */
+	ths8200_s_stream(sd, true);
+
+	v4l2_dbg(1, debug, sd, "%s: frame %dx%d, polarity %d\n"
+		 "horizontal: front porch %d, back porch %d, sync %d\n"
+		 "vertical: sync %d\n", __func__, htotal(bt), vtotal(bt),
+		 polarity, bt->hfrontporch, bt->hbackporch,
+		 bt->hsync, bt->vsync);
+}
+
+static int ths8200_s_dv_timings(struct v4l2_subdev *sd,
+				struct v4l2_dv_timings *timings)
+{
+	struct ths8200_state *state = to_state(sd);
+	int i;
+
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
+	if (timings->type != V4L2_DV_BT_656_1120)
+		return -EINVAL;
+
+	/* TODO Support interlaced formats */
+	if (timings->bt.interlaced) {
+		v4l2_dbg(1, debug, sd, "TODO Support interlaced formats\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ths8200_timings); i++) {
+		if (v4l_match_dv_timings(&ths8200_timings[i], timings, 10))
+			break;
+	}
+
+	if (i == ARRAY_SIZE(ths8200_timings)) {
+		v4l2_dbg(1, debug, sd, "Unsupported format\n");
+		return -EINVAL;
+	}
+
+	timings->bt.flags &= ~V4L2_DV_FL_REDUCED_FPS;
+
+	/* save timings */
+	state->dv_timings = *timings;
+
+	ths8200_setup(sd, &timings->bt);
+
+	return 0;
+}
+
+static int ths8200_g_dv_timings(struct v4l2_subdev *sd,
+				struct v4l2_dv_timings *timings)
+{
+	struct ths8200_state *state = to_state(sd);
+
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
+	*timings = state->dv_timings;
+
+	return 0;
+}
+
+static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
+				   struct v4l2_enum_dv_timings *timings)
+{
+	/* Check requested format index is within range */
+	if (timings->index >= ARRAY_SIZE(ths8200_timings))
+		return -EINVAL;
+
+	timings->timings = ths8200_timings[timings->index];
+
+	return 0;
+}
+
+static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
+				  struct v4l2_dv_timings_cap *cap)
+{
+	cap->type = V4L2_DV_BT_656_1120;
+	cap->bt.max_width = 1920;
+	cap->bt.max_height = 1080;
+	cap->bt.min_pixelclock = 27000000;
+	cap->bt.max_pixelclock = 148500000;
+	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
+	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE;
+
+	return 0;
+}
+
+/* Specific video subsystem operation handlers */
+static const struct v4l2_subdev_video_ops ths8200_video_ops = {
+	.s_stream = ths8200_s_stream,
+	.s_dv_timings = ths8200_s_dv_timings,
+	.g_dv_timings = ths8200_g_dv_timings,
+	.enum_dv_timings = ths8200_enum_dv_timings,
+	.dv_timings_cap = ths8200_dv_timings_cap,
+};
+
+/* V4L2 top level operation handlers */
+static const struct v4l2_subdev_ops ths8200_ops = {
+	.core  = &ths8200_core_ops,
+	.video = &ths8200_video_ops,
+};
+
+static int ths8200_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct ths8200_state *state;
+	struct v4l2_subdev *sd;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &ths8200_ops);
+
+	state->chip_version = ths8200_read(sd, THS8200_VERSION);
+	v4l2_dbg(1, debug, sd, "chip version 0x%x\n", state->chip_version);
+
+	ths8200_core_init(sd);
+
+	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
+		  client->addr << 1, client->adapter->name);
+
+	return 0;
+}
+
+static int ths8200_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_dbg(1, debug, sd, "%s removed @ 0x%x (%s)\n", client->name,
+		 client->addr << 1, client->adapter->name);
+
+	ths8200_s_power(sd, false);
+
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static struct i2c_device_id ths8200_id[] = {
+	{ "ths8200", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ths8200_id);
+
+static struct i2c_driver ths8200_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "ths8200",
+	},
+	.probe = ths8200_probe,
+	.remove = ths8200_remove,
+	.id_table = ths8200_id,
+};
+
+module_i2c_driver(ths8200_driver);
diff --git a/drivers/media/i2c/ths8200_regs.h b/drivers/media/i2c/ths8200_regs.h
new file mode 100644
index 0000000..6bc9fd1
--- /dev/null
+++ b/drivers/media/i2c/ths8200_regs.h
@@ -0,0 +1,161 @@
+/*
+ * ths8200 - Texas Instruments THS8200 video encoder driver
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef THS8200_REGS_H
+#define THS8200_REGS_H
+
+/* Register offset macros */
+#define THS8200_VERSION				0x02
+#define THS8200_CHIP_CTL			0x03
+#define THS8200_CSC_R11				0x04
+#define THS8200_CSC_R12				0x05
+#define THS8200_CSC_R21				0x06
+#define THS8200_CSC_R22				0x07
+#define THS8200_CSC_R31				0x08
+#define THS8200_CSC_R32				0x09
+#define THS8200_CSC_G11				0x0a
+#define THS8200_CSC_G12				0x0b
+#define THS8200_CSC_G21				0x0c
+#define THS8200_CSC_G22				0x0d
+#define THS8200_CSC_G31				0x0e
+#define THS8200_CSC_G32				0x0f
+#define THS8200_CSC_B11				0x10
+#define THS8200_CSC_B12				0x11
+#define THS8200_CSC_B21				0x12
+#define THS8200_CSC_B22				0x13
+#define THS8200_CSC_B31				0x14
+#define THS8200_CSC_B32				0x15
+#define THS8200_CSC_OFFS1			0x16
+#define THS8200_CSC_OFFS12			0x17
+#define THS8200_CSC_OFFS23			0x18
+#define THS8200_CSC_OFFS3			0x19
+#define THS8200_TST_CNTL1			0x1a
+#define THS8200_TST_CNTL2			0x1b
+#define THS8200_DATA_CNTL			0x1c
+#define THS8200_DTG1_Y_SYNC1_LSB		0x1d
+#define THS8200_DTG1_Y_SYNC2_LSB		0x1e
+#define THS8200_DTG1_Y_SYNC3_LSB		0x1f
+#define THS8200_DTG1_CBCR_SYNC1_LSB		0x20
+#define THS8200_DTG1_CBCR_SYNC2_LSB		0x21
+#define THS8200_DTG1_CBCR_SYNC3_LSB		0x22
+#define THS8200_DTG1_Y_SYNC_MSB			0x23
+#define THS8200_DTG1_CBCR_SYNC_MSB		0x24
+#define THS8200_DTG1_SPEC_A			0x25
+#define THS8200_DTG1_SPEC_B			0x26
+#define THS8200_DTG1_SPEC_C			0x27
+#define THS8200_DTG1_SPEC_D_LSB			0x28
+#define THS8200_DTG1_SPEC_D1			0x29
+#define THS8200_DTG1_SPEC_E_LSB			0x2a
+#define THS8200_DTG1_SPEC_DEH_MSB		0x2b
+#define THS8200_DTG1_SPEC_H_LSB			0x2c
+#define THS8200_DTG1_SPEC_I_MSB			0x2d
+#define THS8200_DTG1_SPEC_I_LSB			0x2e
+#define THS8200_DTG1_SPEC_K_LSB			0x2f
+#define THS8200_DTG1_SPEC_K_MSB			0x30
+#define THS8200_DTG1_SPEC_K1			0x31
+#define THS8200_DTG1_SPEC_G_LSB			0x32
+#define THS8200_DTG1_SPEC_G_MSB			0x33
+#define THS8200_DTG1_TOT_PIXELS_MSB		0x34
+#define THS8200_DTG1_TOT_PIXELS_LSB		0x35
+#define THS8200_DTG1_FLD_FLIP_LINECNT_MSB	0x36
+#define THS8200_DTG1_LINECNT_LSB		0x37
+#define THS8200_DTG1_MODE			0x38
+#define THS8200_DTG1_FRAME_FIELD_SZ_MSB		0x39
+#define THS8200_DTG1_FRAME_SZ_LSB		0x3a
+#define THS8200_DTG1_FIELD_SZ_LSB		0x3b
+#define THS8200_DTG1_VESA_CBAR_SIZE		0x3c
+#define THS8200_DAC_CNTL_MSB			0x3d
+#define THS8200_DAC1_CNTL_LSB			0x3e
+#define THS8200_DAC2_CNTL_LSB			0x3f
+#define THS8200_DAC3_CNTL_LSB			0x40
+#define THS8200_CSM_CLIP_GY_LOW			0x41
+#define THS8200_CSM_CLIP_BCB_LOW		0x42
+#define THS8200_CSM_CLIP_RCR_LOW		0x43
+#define THS8200_CSM_CLIP_GY_HIGH		0x44
+#define THS8200_CSM_CLIP_BCB_HIGH		0x45
+#define THS8200_CSM_CLIP_RCR_HIGH		0x46
+#define THS8200_CSM_SHIFT_GY			0x47
+#define THS8200_CSM_SHIFT_BCB			0x48
+#define THS8200_CSM_SHIFT_RCR			0x49
+#define THS8200_CSM_GY_CNTL_MULT_MSB		0x4a
+#define THS8200_CSM_MULT_BCB_RCR_MSB		0x4b
+#define THS8200_CSM_MULT_GY_LSB			0x4c
+#define THS8200_CSM_MULT_BCB_LSB		0x4d
+#define THS8200_CSM_MULT_RCR_LSB		0x4e
+#define THS8200_CSM_MULT_RCR_BCB_CNTL		0x4f
+#define THS8200_CSM_MULT_RCR_LSB		0x4e
+#define THS8200_DTG2_BP1_2_MSB			0x50
+#define THS8200_DTG2_BP3_4_MSB			0x51
+#define THS8200_DTG2_BP5_6_MSB			0x52
+#define THS8200_DTG2_BP7_8_MSB			0x53
+#define THS8200_DTG2_BP9_10_MSB			0x54
+#define THS8200_DTG2_BP11_12_MSB		0x55
+#define THS8200_DTG2_BP13_14_MSB		0x56
+#define THS8200_DTG2_BP15_16_MSB		0x57
+#define THS8200_DTG2_BP1_LSB			0x58
+#define THS8200_DTG2_BP2_LSB			0x59
+#define THS8200_DTG2_BP3_LSB			0x5a
+#define THS8200_DTG2_BP4_LSB			0x5b
+#define THS8200_DTG2_BP5_LSB			0x5c
+#define THS8200_DTG2_BP6_LSB			0x5d
+#define THS8200_DTG2_BP7_LSB			0x5e
+#define THS8200_DTG2_BP8_LSB			0x5f
+#define THS8200_DTG2_BP9_LSB			0x60
+#define THS8200_DTG2_BP10_LSB			0x61
+#define THS8200_DTG2_BP11_LSB			0x62
+#define THS8200_DTG2_BP12_LSB			0x63
+#define THS8200_DTG2_BP13_LSB			0x64
+#define THS8200_DTG2_BP14_LSB			0x65
+#define THS8200_DTG2_BP15_LSB			0x66
+#define THS8200_DTG2_BP16_LSB			0x67
+#define THS8200_DTG2_LINETYPE1			0x68
+#define THS8200_DTG2_LINETYPE2			0x69
+#define THS8200_DTG2_LINETYPE3			0x6a
+#define THS8200_DTG2_LINETYPE4			0x6b
+#define THS8200_DTG2_LINETYPE5			0x6c
+#define THS8200_DTG2_LINETYPE6			0x6d
+#define THS8200_DTG2_LINETYPE7			0x6e
+#define THS8200_DTG2_LINETYPE8			0x6f
+#define THS8200_DTG2_HLENGTH_LSB		0x70
+#define THS8200_DTG2_HLENGTH_LSB_HDLY_MSB	0x71
+#define THS8200_DTG2_HLENGTH_HDLY_LSB		0x72
+#define THS8200_DTG2_VLENGTH1_LSB		0x73
+#define THS8200_DTG2_VLENGTH1_MSB_VDLY1_MSB	0x74
+#define THS8200_DTG2_VDLY1_LSB			0x75
+#define THS8200_DTG2_VLENGTH2_LSB		0x76
+#define THS8200_DTG2_VLENGTH2_MSB_VDLY2_MSB	0x77
+#define THS8200_DTG2_VDLY2_LSB			0x78
+#define THS8200_DTG2_HS_IN_DLY_MSB		0x79
+#define THS8200_DTG2_HS_IN_DLY_LSB		0x7a
+#define THS8200_DTG2_VS_IN_DLY_MSB		0x7b
+#define THS8200_DTG2_VS_IN_DLY_LSB		0x7c
+#define THS8200_DTG2_PIXEL_CNT_MSB		0x7d
+#define THS8200_DTG2_PIXEL_CNT_LSB		0x7e
+#define THS8200_DTG2_LINE_CNT_MSB		0x7f
+#define THS8200_DTG2_LINE_CNT_LSB		0x80
+#define THS8200_DTG2_CNTL			0x82
+#define THS8200_CGMS_CNTL_HEADER		0x83
+#define THS8200_CGMS_PAYLOAD_MSB		0x84
+#define THS8200_CGMS_PAYLOAD_LSB		0x85
+#define THS8200_MISC_PPL_LSB			0x86
+#define THS8200_MISC_PPL_MSB			0x87
+#define THS8200_MISC_LPF_MSB			0x88
+#define THS8200_MISC_LPF_LSB			0x89
+
+#endif /* THS8200_REGS_H */
-- 
1.7.0.4

