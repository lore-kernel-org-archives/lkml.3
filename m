Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3AYKgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:36:42 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62509 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3AYKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:36:37 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 2/2] media: add support for THS7353 video amplifier
Date: Fri, 25 Jan 2013 16:06:07 +0530
Message-Id: <1359110167-5703-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359110167-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1359110167-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

The patch adds support for THS7353 video amplifier. Enable
dv_preset support for THS7353 so that setting a HD mode on the
host device makes sure appropriate mode in the amplifier is enabled.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/i2c/Kconfig   |   10 ++
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/ths7353.c |  223 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ths7353.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 24d78e2..d1ebb0b 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -570,6 +570,16 @@ config VIDEO_THS7303
 	  To compile this driver as a module, choose M here: the
 	  module will be called ths7303.
 
+config VIDEO_THS7353
+	tristate "THS7353 Video Amplifier"
+	depends on I2C
+	help
+	  Support for TI THS7353 video amplifier
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ths7353. This helps tvp7002 to amplify
+	  the signals.
+
 config VIDEO_M52790
 	tristate "Mitsubishi M52790 A/V switch"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index b1d62df..9944d06 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
 obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
 obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
+obj-$(CONFIG_VIDEO_THS7353) += ths7353.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
 obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
diff --git a/drivers/media/i2c/ths7353.c b/drivers/media/i2c/ths7353.c
new file mode 100644
index 0000000..288cd1f
--- /dev/null
+++ b/drivers/media/i2c/ths7353.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Inc
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
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-device.h>
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Debug level 0-1");
+
+#define THS7353_CHANNEL_1	1
+#define THS7353_CHANNEL_2	2
+#define THS7353_CHANNEL_3	3
+
+#define THS7353_DEF_LUMA_CHANNEL	2
+
+/* all supported modes */
+enum ths7353_filter_mode {
+	THS_FILTER_MODE_480I_576I,
+	THS_FILTER_MODE_480P_576P,
+	THS_FILTER_MODE_720P_1080I,
+	THS_FILTER_MODE_1080P
+};
+
+static int ths7353_luma_channel;
+
+/* following function is used to set ths7353 */
+static int ths7353_setvalue(struct v4l2_subdev *sd,
+			    enum ths7353_filter_mode mode)
+{
+	u8 val = 0, input_bias_luma = 5, input_bias_chroma = 4, temp;
+	struct i2c_client *client;
+	int err, disable;
+	int channel = 3;
+
+	client = v4l2_get_subdevdata(sd);
+
+	switch (mode) {
+	case THS_FILTER_MODE_1080P:
+		/* LPF - 5MHz */
+		val = (3 << 6);
+		/* LPF - bypass */
+		val |= (3 << 3);
+		break;
+	case THS_FILTER_MODE_720P_1080I:
+		/* LPF - 5MHz */
+		val = (2 << 6);
+		/* LPF - 35 MHz */
+		val |= (2 << 3);
+		break;
+	case THS_FILTER_MODE_480P_576P:
+		/* LPF - 2.5MHz */
+		val = (1 << 6);
+		/* LPF - 16 MHz */
+		val |= (1 << 3);
+		break;
+	case THS_FILTER_MODE_480I_576I:
+		/* LPF - 500 KHz, LPF - 9 MHz. Do nothing */
+		break;
+	default:
+		/* disable all channels */
+		disable = 1;
+	}
+
+	channel = ths7353_luma_channel;
+
+	/* Setup channel 2 - Luma - Green */
+	temp = val;
+	if (!disable)
+		val |= input_bias_luma;
+	err = i2c_smbus_write_byte_data(client, channel, val);
+	if (err)
+		goto out;
+
+	/* setup two chroma channels */
+	if (!disable)
+		temp |= input_bias_chroma;
+	channel++;
+	if (channel > THS7353_CHANNEL_3)
+		channel = THS7353_CHANNEL_1;
+	err = i2c_smbus_write_byte_data(client, channel, temp);
+	if (err)
+		goto out;
+
+	channel++;
+	if (channel > THS7353_CHANNEL_3)
+		channel = THS7353_CHANNEL_1;
+	err = i2c_smbus_write_byte_data(client, channel, temp);
+	if (err)
+		goto out;
+
+	return 0;
+
+out:
+	v4l2_err(sd, "ths7353 write failed\n");
+	return err;
+}
+
+static int ths7353_s_preset(struct v4l2_subdev *sd,
+			    struct v4l2_dv_preset *preset)
+{
+	switch (preset->preset) {
+	case V4L2_DV_576P50:
+	case V4L2_DV_480P59_94:
+		return ths7353_setvalue(sd, THS_FILTER_MODE_480P_576P);
+
+	case V4L2_DV_720P50:
+	case V4L2_DV_720P60:
+	case V4L2_DV_1080I60:
+	case V4L2_DV_1080I50:
+		return ths7353_setvalue(sd, THS_FILTER_MODE_720P_1080I);
+
+	case V4L2_DV_1080P60:
+		return ths7353_setvalue(sd, THS_FILTER_MODE_1080P);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int ths7353_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_THS7353, 0);
+}
+
+static const struct v4l2_subdev_video_ops ths7353_video_ops = {
+	.s_dv_preset	= ths7353_s_preset,
+};
+
+static const struct v4l2_subdev_core_ops ths7353_core_ops = {
+	.g_chip_ident	= ths7353_g_chip_ident,
+};
+
+static const struct v4l2_subdev_ops ths7353_ops = {
+	.core	= &ths7353_core_ops,
+	.video	= &ths7353_video_ops,
+};
+
+static int ths7353_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct v4l2_subdev *sd;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	v4l_info(client, "chip found @ 0x%x (%s)\n",
+				client->addr << 1, client->adapter->name);
+
+	if (!client->dev.platform_data) {
+		v4l_warn(client, "No platform data!!\n");
+		ths7353_luma_channel = THS7353_DEF_LUMA_CHANNEL;
+	} else {
+		ths7353_luma_channel = (int)(client->dev.platform_data);
+		if (ths7353_luma_channel < THS7353_CHANNEL_1 ||
+		    ths7353_luma_channel > THS7353_CHANNEL_3) {
+			v4l_warn(client, "Invalid Luma Channel!!\n");
+			ths7353_luma_channel = THS7353_DEF_LUMA_CHANNEL;
+		}
+	}
+
+	sd = devm_kzalloc(&client->dev, sizeof(struct v4l2_subdev), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(sd, client, &ths7353_ops);
+	strlcpy(sd->name, "ths7353", sizeof(sd->name));
+
+	return ths7353_setvalue(sd, THS_FILTER_MODE_480I_576I);
+}
+
+static int ths7353_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct i2c_device_id ths7353_id[] = {
+	{"ths7353", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, ths7353_id);
+
+static struct i2c_driver ths7353_driver = {
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "ths7353",
+	},
+	.probe		= ths7353_probe,
+	.remove		= ths7353_remove,
+	.id_table	= ths7353_id,
+};
+
+module_i2c_driver(ths7353_driver);
+
+MODULE_DESCRIPTION("TI THS7353 video amplifier driver");
+MODULE_AUTHOR("Muralidharan Karicheri");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

