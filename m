Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3CVIEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:04:37 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38118 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3CVIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:04:07 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v7 2/2] ARM: davinci: dm365 EVM: add support for VPBE display
Date: Fri, 22 Mar 2013 13:33:08 +0530
Message-Id: <1363939388-22412-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363939388-22412-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1363939388-22412-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add support for V4L2 video display to DM365 EVM.
Support for SD and ED modes is provided, along with Composite
and Component outputs.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/board-dm365-evm.c |  164 ++++++++++++++++++++++++++++++-
 1 files changed, 163 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index cf77c46..0518ce5 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -27,6 +27,7 @@
 #include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/v4l2-dv-timings.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -39,6 +40,7 @@
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/keyscan-davinci.h>
 
+#include <media/ths7303.h>
 #include <media/tvp514x.h>
 
 #include "davinci.h"
@@ -374,6 +376,166 @@ static struct vpfe_config vpfe_cfg = {
 	.ccdc = "ISIF",
 };
 
+/* venc standards timings */
+static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
+	{
+		.name		= "ntsc",
+		.timings_type	= VPBE_ENC_STD,
+		.std_id		= V4L2_STD_525_60,
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 480,
+		.aspect		= {11, 10},
+		.fps		= {30000, 1001},
+		.left_margin	= 0x79,
+		.upper_margin	= 0x10,
+	},
+	{
+		.name		= "pal",
+		.timings_type	= VPBE_ENC_STD,
+		.std_id		= V4L2_STD_625_50,
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 576,
+		.aspect		= {54, 59},
+		.fps		= {25, 1},
+		.left_margin	= 0x7E,
+		.upper_margin	= 0x16,
+	},
+};
+
+/* venc dv timings */
+static struct vpbe_enc_mode_info dm365evm_enc_preset_timing[] = {
+	{
+		.name		= "480p59_94",
+		.timings_type	= VPBE_ENC_DV_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_720X480P59_94,
+		.interlaced	= 0,
+		.xres		= 720,
+		.yres		= 480,
+		.aspect		= {1, 1},
+		.fps		= {5994, 100},
+		.left_margin	= 0x8F,
+		.upper_margin	= 0x2D,
+	},
+	{
+		.name		= "576p50",
+		.timings_type	= VPBE_ENC_DV_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_720X576P50,
+		.interlaced	= 0,
+		.xres		= 720,
+		.yres		= 576,
+		.aspect		= {1, 1},
+		.fps		= {50, 1},
+		.left_margin	= 0x8C,
+		.upper_margin   = 0x36,
+	},
+	{
+		.name		= "720p60",
+		.timings_type	= VPBE_ENC_DV_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_1280X720P60,
+		.interlaced	= 0,
+		.xres		= 1280,
+		.yres		= 720,
+		.aspect		= {1, 1},
+		.fps		= {60, 1},
+		.left_margin	= 0x117,
+		.right_margin	= 70,
+		.upper_margin	= 38,
+		.lower_margin	= 3,
+		.hsync_len	= 80,
+		.vsync_len	= 5,
+	},
+	{
+		.name		= "1080i60",
+		.timings_type	= VPBE_ENC_DV_TIMINGS,
+		.dv_timings	= V4L2_DV_BT_CEA_1920X1080I60,
+		.interlaced	= 1,
+		.xres		= 1920,
+		.yres		= 1080,
+		.aspect		= {1, 1},
+		.fps		= {30, 1},
+		.left_margin	= 0xc9,
+		.right_margin	= 80,
+		.upper_margin	= 30,
+		.lower_margin	= 3,
+		.hsync_len	= 88,
+		.vsync_len	= 5,
+	},
+};
+
+#define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+
+/*
+ * The outputs available from VPBE + ecnoders. Keep the
+ * the order same as that of encoders. First those from venc followed by that
+ * from encoders. Index in the output refers to index on a particular
+ * encoder.Driver uses this index to pass it to encoder when it supports more
+ * than one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm365evm_vpbe_outputs[] = {
+	{
+		.output		= {
+			.index		= 0,
+			.name		= "Composite",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.std		= VENC_STD_ALL,
+			.capabilities	= V4L2_OUT_CAP_STD,
+		},
+		.subdev_name	= DM365_VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "ntsc",
+		.num_modes	= ARRAY_SIZE(dm365evm_enc_std_timing),
+		.modes		= dm365evm_enc_std_timing,
+		.if_params	= V4L2_MBUS_FMT_FIXED,
+	},
+	{
+		.output		= {
+			.index		= 1,
+			.name		= "Component",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.capabilities	= V4L2_OUT_CAP_DV_TIMINGS,
+		},
+		.subdev_name	= DM365_VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "480p59_94",
+		.num_modes	= ARRAY_SIZE(dm365evm_enc_preset_timing),
+		.modes		= dm365evm_enc_preset_timing,
+		.if_params	= V4L2_MBUS_FMT_FIXED,
+	},
+};
+
+/*
+ * Amplifiers on the board
+ */
+struct ths7303_platform_data ths7303_pdata = {
+	.ch_1 = 3,
+	.ch_2 = 3,
+	.ch_3 = 3,
+	.init_enable = 1,
+};
+
+static struct amp_config_info vpbe_amp = {
+	.module_name	= "ths7303",
+	.is_i2c		= 1,
+	.board_info	= {
+		I2C_BOARD_INFO("ths7303", 0x2c),
+		.platform_data = &ths7303_pdata,
+	}
+};
+
+static struct vpbe_config dm365evm_display_cfg = {
+	.module_name	= "dm365-vpbe-display",
+	.i2c_adapter_id	= 1,
+	.amp		= &vpbe_amp,
+	.osd		= {
+		.module_name	= DM365_VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc		= {
+		.module_name	= DM365_VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs	= ARRAY_SIZE(dm365evm_vpbe_outputs),
+	.outputs	= dm365evm_vpbe_outputs,
+};
+
 static void __init evm_init_i2c(void)
 {
 	davinci_init_i2c(&i2c_pdata);
@@ -595,7 +757,7 @@ static __init void dm365_evm_init(void)
 
 	davinci_setup_mmc(0, &dm365evm_mmc_config);
 
-	dm365_init_video(&vpfe_cfg, NULL);
+	dm365_init_video(&vpfe_cfg, &dm365evm_display_cfg);
 
 	/* maybe setup mmc1/etc ... _after_ mmc0 */
 	evm_init_cpld();
-- 
1.7.4.1

