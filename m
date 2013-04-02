Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3DBNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:15:31 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:45079 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987Ab3DBNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:15:26 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v7 2/2] ARM: davinci: dm355 EVM: add support for VPBE display
Date: Tue,  2 Apr 2013 18:45:04 +0530
Message-Id: <1364908504-14232-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364908504-14232-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364908504-14232-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add support for V4L2 video display to DM355 EVM.
Support for SD modes is provided, along with Composite
output

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c |   69 ++++++++++++++++++++++++++++++-
 1 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 37d12cc..1043506 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -242,6 +242,73 @@ static struct vpfe_config vpfe_cfg = {
 	.ccdc = "DM355 CCDC",
 };
 
+/* venc standards timings */
+static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
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
+		.upper_margin	= 0x16
+	},
+};
+
+#define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+
+/*
+ * The outputs available from VPBE + ecnoders. Keep the
+ * the order same as that of encoders. First those from venc followed by that
+ * from encoders. Index in the output refers to index on a particular encoder.
+ * Driver uses this index to pass it to encoder when it supports more than
+ * one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm355evm_vpbe_outputs[] = {
+	{
+		.output		= {
+			.index		= 0,
+			.name		= "Composite",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.std		= VENC_STD_ALL,
+			.capabilities	= V4L2_OUT_CAP_STD,
+		},
+		.subdev_name	= DM355_VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "ntsc",
+		.num_modes	= ARRAY_SIZE(dm355evm_enc_preset_timing),
+		.modes		= dm355evm_enc_preset_timing,
+		.if_params	= V4L2_MBUS_FMT_FIXED,
+	},
+};
+
+static struct vpbe_config dm355evm_display_cfg = {
+	.module_name	= "dm355-vpbe-display",
+	.i2c_adapter_id	= 1,
+	.osd		= {
+		.module_name	= DM355_VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc		= {
+		.module_name	= DM355_VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs	= ARRAY_SIZE(dm355evm_vpbe_outputs),
+	.outputs	= dm355evm_vpbe_outputs,
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&dm355evm_dm9000,
 	&davinci_nand_device,
@@ -342,7 +409,7 @@ static __init void dm355_evm_init(void)
 	davinci_setup_mmc(0, &dm355evm_mmc_config);
 	davinci_setup_mmc(1, &dm355evm_mmc_config);
 
-	dm355_init_video(&vpfe_cfg, NULL);
+	dm355_init_video(&vpfe_cfg, &dm355evm_display_cfg);
 
 	dm355_init_spi0(BIT(0), dm355_evm_spi_info,
 			ARRAY_SIZE(dm355_evm_spi_info));
-- 
1.7.4.1

