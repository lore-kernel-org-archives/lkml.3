Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3BEXnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:43:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53307 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3BEXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:43:14 -0500
From: Sean Paul <seanpaul@chromium.org>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, inki.dae@samsung.com,
        t.stanislaws@samsung.com, tomasz.figa@gmail.com,
        sylvester.nawrocki@gmail.com, olofj@chromium.org,
        rahul.sharma@samsung.com, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3 1/3] drm/exynos: Get HDMI version from device tree
Date: Tue,  5 Feb 2013 15:42:56 -0800
Message-Id: <1360107777-17490-2-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1360107777-17490-1-git-send-email-seanpaul@chromium.org>
References: <1360107777-17490-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the compatible string in the device tree to determine which
registers/functions to use in the HDMI driver. Also changes the
references from v13 to 4210 and v14 to 4212 to reflect the IP
block version instead of the HDMI version.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 .../devicetree/bindings/drm/exynos/hdmi.txt        |    9 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  354 ++++++++++----------
 drivers/gpu/drm/exynos/regs-hdmi.h                 |   78 +++---
 3 files changed, 223 insertions(+), 218 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
index 589edee..781b6bc 100644
--- a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
+++ b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
@@ -1,7 +1,11 @@
 Device-Tree bindings for drm hdmi driver
 
 Required properties:
-- compatible: value should be "samsung,exynos5-hdmi".
+- compatible: suitable values are:
+	- "samsung,exynos5250-hdmi"
+	- "samsung,exynos4212-hdmi"
+	- "samsung,exynos4210-hdmi"
+	- "samsung,exynos4-hdmi"
 - reg: physical base address of the hdmi and length of memory mapped
 	region.
 - interrupts: interrupt number to the cpu.
@@ -15,7 +19,8 @@ Required properties:
 Example:
 
 	hdmi {
-		compatible = "samsung,exynos5-hdmi";
+		compatible = "samsung,exynos5250-hdmi",
+			     "samsung,exynos4212-hdmi", "samsung,exynos4-hdmi";
 		reg = <0x14530000 0x100000>;
 		interrupts = <0 95 0>;
 		hpd-gpio = <&gpx3 7 0xf 1 3>;
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 9e3c2ad..622637f 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -73,9 +73,10 @@ enum HDMI_PACKET_TYPE {
 	HDMI_PACKET_TYPE_AUI = HDMI_PACKET_TYPE_INFOFRAME + 4
 };
 
-enum hdmi_type {
-	HDMI_TYPE13,
-	HDMI_TYPE14,
+enum hdmi_version {
+	HDMI_VER_EXYNOS4210	= 1 << 0,
+	HDMI_VER_EXYNOS4212	= 1 << 1,
+	HDMI_VER_EXYNOS5250	= 1 << 2,
 };
 
 struct hdmi_resources {
@@ -148,7 +149,7 @@ struct hdmi_core_regs {
 	u8 vact_space_6[2];
 };
 
-struct hdmi_v14_conf {
+struct hdmi_4212_conf {
 	int pixel_clock;
 	struct hdmi_core_regs core;
 	struct hdmi_tg_regs tg;
@@ -173,52 +174,51 @@ struct hdmi_context {
 
 	/* current hdmiphy conf index */
 	int cur_conf;
-	struct hdmi_v14_conf		mode_conf;
+	struct hdmi_4212_conf		mode_conf;
 
 	struct hdmi_resources		res;
 
 	int				hpd_gpio;
 
-	enum hdmi_type			type;
+	int				version;
 };
 
-/* HDMI Version 1.3 */
-static const u8 hdmiphy_v13_conf27[32] = {
+static const u8 hdmiphy_4210_conf27[32] = {
 	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
 	0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
 	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
 	0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00,
 };
 
-static const u8 hdmiphy_v13_conf27_027[32] = {
+static const u8 hdmiphy_4210_conf27_027[32] = {
 	0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
 	0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
 	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
 	0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00,
 };
 
-static const u8 hdmiphy_v13_conf74_175[32] = {
+static const u8 hdmiphy_4210_conf74_175[32] = {
 	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
 	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
 	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
 	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
 };
 
-static const u8 hdmiphy_v13_conf74_25[32] = {
+static const u8 hdmiphy_4210_conf74_25[32] = {
 	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
 	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
 	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xe0,
 	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
 };
 
-static const u8 hdmiphy_v13_conf148_5[32] = {
+static const u8 hdmiphy_4210_conf148_5[32] = {
 	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
 	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
 	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
 	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
 };
 
-struct hdmi_v13_tg_regs {
+struct hdmi_4210_tg_regs {
 	u8 cmd;
 	u8 h_fsz_l;
 	u8 h_fsz_h;
@@ -250,7 +250,7 @@ struct hdmi_v13_tg_regs {
 	u8 field_bot_hdmi_h;
 };
 
-struct hdmi_v13_core_regs {
+struct hdmi_4210_core_regs {
 	u8 h_blank[2];
 	u8 v_blank[3];
 	u8 h_v_line[3];
@@ -263,22 +263,22 @@ struct hdmi_v13_core_regs {
 	u8 v_sync_gen3[3];
 };
 
-struct hdmi_v13_preset_conf {
-	struct hdmi_v13_core_regs core;
-	struct hdmi_v13_tg_regs tg;
+struct hdmi_4210_preset_conf {
+	struct hdmi_4210_core_regs core;
+	struct hdmi_4210_tg_regs tg;
 };
 
-struct hdmi_v13_conf {
+struct hdmi_4210_conf {
 	int width;
 	int height;
 	int vrefresh;
 	bool interlace;
 	int cea_video_id;
 	const u8 *hdmiphy_data;
-	const struct hdmi_v13_preset_conf *conf;
+	const struct hdmi_4210_preset_conf *conf;
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_480p = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_480p = {
 	.core = {
 		.h_blank = {0x8a, 0x00},
 		.v_blank = {0x0d, 0x6a, 0x01},
@@ -304,7 +304,7 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_480p = {
 	},
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_720p60 = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_720p60 = {
 	.core = {
 		.h_blank = {0x72, 0x01},
 		.v_blank = {0xee, 0xf2, 0x00},
@@ -332,7 +332,7 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_720p60 = {
 	},
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080i50 = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_1080i50 = {
 	.core = {
 		.h_blank = {0xd0, 0x02},
 		.v_blank = {0x32, 0xB2, 0x00},
@@ -360,7 +360,7 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080i50 = {
 	},
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080p50 = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_1080p50 = {
 	.core = {
 		.h_blank = {0xd0, 0x02},
 		.v_blank = {0x65, 0x6c, 0x01},
@@ -388,7 +388,7 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080p50 = {
 	},
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080i60 = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_1080i60 = {
 	.core = {
 		.h_blank = {0x18, 0x01},
 		.v_blank = {0x32, 0xB2, 0x00},
@@ -416,7 +416,7 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080i60 = {
 	},
 };
 
-static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080p60 = {
+static const struct hdmi_4210_preset_conf hdmi_4210_conf_1080p60 = {
 	.core = {
 		.h_blank = {0x18, 0x01},
 		.v_blank = {0x65, 0x6c, 0x01},
@@ -444,31 +444,31 @@ static const struct hdmi_v13_preset_conf hdmi_v13_conf_1080p60 = {
 	},
 };
 
-static const struct hdmi_v13_conf hdmi_v13_confs[] = {
-	{ 1280, 720, 60, false, 4, hdmiphy_v13_conf74_25,
-			&hdmi_v13_conf_720p60 },
-	{ 1280, 720, 50, false, 19, hdmiphy_v13_conf74_25,
-			&hdmi_v13_conf_720p60 },
-	{ 720, 480, 60, false, 3, hdmiphy_v13_conf27_027,
-			&hdmi_v13_conf_480p },
-	{ 1920, 1080, 50, true, 20, hdmiphy_v13_conf74_25,
-			&hdmi_v13_conf_1080i50 },
-	{ 1920, 1080, 50, false, 31, hdmiphy_v13_conf148_5,
-			&hdmi_v13_conf_1080p50 },
-	{ 1920, 1080, 60, true, 5, hdmiphy_v13_conf74_25,
-			&hdmi_v13_conf_1080i60 },
-	{ 1920, 1080, 60, false, 16, hdmiphy_v13_conf148_5,
-			&hdmi_v13_conf_1080p60 },
+static const struct hdmi_4210_conf hdmi_4210_confs[] = {
+	{ 1280, 720, 60, false, 4, hdmiphy_4210_conf74_25,
+			&hdmi_4210_conf_720p60 },
+	{ 1280, 720, 50, false, 19, hdmiphy_4210_conf74_25,
+			&hdmi_4210_conf_720p60 },
+	{ 720, 480, 60, false, 3, hdmiphy_4210_conf27_027,
+			&hdmi_4210_conf_480p },
+	{ 1920, 1080, 50, true, 20, hdmiphy_4210_conf74_25,
+			&hdmi_4210_conf_1080i50 },
+	{ 1920, 1080, 50, false, 31, hdmiphy_4210_conf148_5,
+			&hdmi_4210_conf_1080p50 },
+	{ 1920, 1080, 60, true, 5, hdmiphy_4210_conf74_25,
+			&hdmi_4210_conf_1080i60 },
+	{ 1920, 1080, 60, false, 16, hdmiphy_4210_conf148_5,
+			&hdmi_4210_conf_1080p60 },
 };
 
-/* HDMI Version 1.4 */
+/* For exynos4212-hdmi */
 struct hdmiphy_config {
 	int pixel_clock;
 	u8 conf[32];
 };
 
 /* list of all required phy config settings */
-static const struct hdmiphy_config hdmiphy_v14_configs[] = {
+static const struct hdmiphy_config hdmiphy_4212_configs[] = {
 	{
 		.pixel_clock = 25200000,
 		.conf = {
@@ -613,7 +613,7 @@ static inline void hdmi_reg_writemask(struct hdmi_context *hdata,
 	writel(value, hdata->regs + reg_id);
 }
 
-static void hdmi_v13_regs_dump(struct hdmi_context *hdata, char *prefix)
+static void hdmi_4210_regs_dump(struct hdmi_context *hdata, char *prefix)
 {
 #define DUMPREG(reg_id) \
 	DRM_DEBUG_KMS("%s:" #reg_id " = %08x\n", prefix, \
@@ -622,50 +622,50 @@ static void hdmi_v13_regs_dump(struct hdmi_context *hdata, char *prefix)
 	DUMPREG(HDMI_INTC_FLAG);
 	DUMPREG(HDMI_INTC_CON);
 	DUMPREG(HDMI_HPD_STATUS);
-	DUMPREG(HDMI_V13_PHY_RSTOUT);
-	DUMPREG(HDMI_V13_PHY_VPLL);
-	DUMPREG(HDMI_V13_PHY_CMU);
-	DUMPREG(HDMI_V13_CORE_RSTOUT);
+	DUMPREG(HDMI_4210_PHY_RSTOUT);
+	DUMPREG(HDMI_4210_PHY_VPLL);
+	DUMPREG(HDMI_4210_PHY_CMU);
+	DUMPREG(HDMI_4210_CORE_RSTOUT);
 
 	DRM_DEBUG_KMS("%s: ---- CORE REGISTERS ----\n", prefix);
 	DUMPREG(HDMI_CON_0);
 	DUMPREG(HDMI_CON_1);
 	DUMPREG(HDMI_CON_2);
 	DUMPREG(HDMI_SYS_STATUS);
-	DUMPREG(HDMI_V13_PHY_STATUS);
+	DUMPREG(HDMI_4210_PHY_STATUS);
 	DUMPREG(HDMI_STATUS_EN);
 	DUMPREG(HDMI_HPD);
 	DUMPREG(HDMI_MODE_SEL);
-	DUMPREG(HDMI_V13_HPD_GEN);
-	DUMPREG(HDMI_V13_DC_CONTROL);
-	DUMPREG(HDMI_V13_VIDEO_PATTERN_GEN);
+	DUMPREG(HDMI_4210_HPD_GEN);
+	DUMPREG(HDMI_4210_DC_CONTROL);
+	DUMPREG(HDMI_4210_VIDEO_PATTERN_GEN);
 
 	DRM_DEBUG_KMS("%s: ---- CORE SYNC REGISTERS ----\n", prefix);
 	DUMPREG(HDMI_H_BLANK_0);
 	DUMPREG(HDMI_H_BLANK_1);
-	DUMPREG(HDMI_V13_V_BLANK_0);
-	DUMPREG(HDMI_V13_V_BLANK_1);
-	DUMPREG(HDMI_V13_V_BLANK_2);
-	DUMPREG(HDMI_V13_H_V_LINE_0);
-	DUMPREG(HDMI_V13_H_V_LINE_1);
-	DUMPREG(HDMI_V13_H_V_LINE_2);
+	DUMPREG(HDMI_4210_V_BLANK_0);
+	DUMPREG(HDMI_4210_V_BLANK_1);
+	DUMPREG(HDMI_4210_V_BLANK_2);
+	DUMPREG(HDMI_4210_H_V_LINE_0);
+	DUMPREG(HDMI_4210_H_V_LINE_1);
+	DUMPREG(HDMI_4210_H_V_LINE_2);
 	DUMPREG(HDMI_VSYNC_POL);
 	DUMPREG(HDMI_INT_PRO_MODE);
-	DUMPREG(HDMI_V13_V_BLANK_F_0);
-	DUMPREG(HDMI_V13_V_BLANK_F_1);
-	DUMPREG(HDMI_V13_V_BLANK_F_2);
-	DUMPREG(HDMI_V13_H_SYNC_GEN_0);
-	DUMPREG(HDMI_V13_H_SYNC_GEN_1);
-	DUMPREG(HDMI_V13_H_SYNC_GEN_2);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_1_0);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_1_1);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_1_2);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_2_0);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_2_1);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_2_2);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_3_0);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_3_1);
-	DUMPREG(HDMI_V13_V_SYNC_GEN_3_2);
+	DUMPREG(HDMI_4210_V_BLANK_F_0);
+	DUMPREG(HDMI_4210_V_BLANK_F_1);
+	DUMPREG(HDMI_4210_V_BLANK_F_2);
+	DUMPREG(HDMI_4210_H_SYNC_GEN_0);
+	DUMPREG(HDMI_4210_H_SYNC_GEN_1);
+	DUMPREG(HDMI_4210_H_SYNC_GEN_2);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_1_0);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_1_1);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_1_2);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_2_0);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_2_1);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_2_2);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_3_0);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_3_1);
+	DUMPREG(HDMI_4210_V_SYNC_GEN_3_2);
 
 	DRM_DEBUG_KMS("%s: ---- TG REGISTERS ----\n", prefix);
 	DUMPREG(HDMI_TG_CMD);
@@ -700,7 +700,7 @@ static void hdmi_v13_regs_dump(struct hdmi_context *hdata, char *prefix)
 #undef DUMPREG
 }
 
-static void hdmi_v14_regs_dump(struct hdmi_context *hdata, char *prefix)
+static void hdmi_4212_regs_dump(struct hdmi_context *hdata, char *prefix)
 {
 	int i;
 
@@ -869,21 +869,21 @@ static void hdmi_v14_regs_dump(struct hdmi_context *hdata, char *prefix)
 
 static void hdmi_regs_dump(struct hdmi_context *hdata, char *prefix)
 {
-	if (hdata->type == HDMI_TYPE13)
-		hdmi_v13_regs_dump(hdata, prefix);
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		hdmi_4210_regs_dump(hdata, prefix);
 	else
-		hdmi_v14_regs_dump(hdata, prefix);
+		hdmi_4212_regs_dump(hdata, prefix);
 }
 
-static int hdmi_v13_conf_index(struct drm_display_mode *mode)
+static int hdmi_4210_conf_index(struct drm_display_mode *mode)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(hdmi_v13_confs); ++i)
-		if (hdmi_v13_confs[i].width == mode->hdisplay &&
-				hdmi_v13_confs[i].height == mode->vdisplay &&
-				hdmi_v13_confs[i].vrefresh == mode->vrefresh &&
-				hdmi_v13_confs[i].interlace ==
+	for (i = 0; i < ARRAY_SIZE(hdmi_4210_confs); ++i)
+		if (hdmi_4210_confs[i].width == mode->hdisplay &&
+				hdmi_4210_confs[i].height == mode->vdisplay &&
+				hdmi_4210_confs[i].vrefresh == mode->vrefresh &&
+				hdmi_4210_confs[i].interlace ==
 				((mode->flags & DRM_MODE_FLAG_INTERLACE) ?
 				 true : false))
 			return i;
@@ -945,8 +945,8 @@ static void hdmi_reg_infoframe(struct hdmi_context *hdata,
 		hdmi_reg_writeb(hdata, HDMI_AVI_BYTE(2), aspect_ratio |
 				AVI_SAME_AS_PIC_ASPECT_RATIO);
 
-		if (hdata->type == HDMI_TYPE13)
-			vic = hdmi_v13_confs[hdata->cur_conf].cea_video_id;
+		if (hdata->version & HDMI_VER_EXYNOS4210)
+			vic = hdmi_4210_confs[hdata->cur_conf].cea_video_id;
 		else
 			vic = hdata->mode_conf.cea_video_id;
 
@@ -1002,7 +1002,7 @@ static struct edid *hdmi_get_edid(void *ctx, struct drm_connector *connector)
 	return raw_edid;
 }
 
-static int hdmi_v13_check_timing(struct fb_videomode *check_timing)
+static int hdmi_4210_check_timing(struct fb_videomode *check_timing)
 {
 	int i;
 
@@ -1011,11 +1011,11 @@ static int hdmi_v13_check_timing(struct fb_videomode *check_timing)
 			check_timing->refresh, (check_timing->vmode &
 			FB_VMODE_INTERLACED) ? true : false);
 
-	for (i = 0; i < ARRAY_SIZE(hdmi_v13_confs); ++i)
-		if (hdmi_v13_confs[i].width == check_timing->xres &&
-			hdmi_v13_confs[i].height == check_timing->yres &&
-			hdmi_v13_confs[i].vrefresh == check_timing->refresh &&
-			hdmi_v13_confs[i].interlace ==
+	for (i = 0; i < ARRAY_SIZE(hdmi_4210_confs); ++i)
+		if (hdmi_4210_confs[i].width == check_timing->xres &&
+			hdmi_4210_confs[i].height == check_timing->yres &&
+			hdmi_4210_confs[i].vrefresh == check_timing->refresh &&
+			hdmi_4210_confs[i].interlace ==
 			((check_timing->vmode & FB_VMODE_INTERLACED) ?
 			 true : false))
 				return 0;
@@ -1025,12 +1025,12 @@ static int hdmi_v13_check_timing(struct fb_videomode *check_timing)
 	return -EINVAL;
 }
 
-static int hdmi_v14_find_phy_conf(int pixel_clock)
+static int hdmi_4212_find_phy_conf(int pixel_clock)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(hdmiphy_v14_configs); i++) {
-		if (hdmiphy_v14_configs[i].pixel_clock == pixel_clock)
+	for (i = 0; i < ARRAY_SIZE(hdmiphy_4212_configs); i++) {
+		if (hdmiphy_4212_configs[i].pixel_clock == pixel_clock)
 			return i;
 	}
 
@@ -1038,7 +1038,7 @@ static int hdmi_v14_find_phy_conf(int pixel_clock)
 	return -EINVAL;
 }
 
-static int hdmi_v14_check_timing(struct fb_videomode *check_timing)
+static int hdmi_4212_check_timing(struct fb_videomode *check_timing)
 {
 	int i;
 
@@ -1048,8 +1048,8 @@ static int hdmi_v14_check_timing(struct fb_videomode *check_timing)
 			(check_timing->vmode & FB_VMODE_INTERLACED) ?
 			true : false);
 
-	for (i = 0; i < ARRAY_SIZE(hdmiphy_v14_configs); i++)
-		if (hdmiphy_v14_configs[i].pixel_clock ==
+	for (i = 0; i < ARRAY_SIZE(hdmiphy_4212_configs); i++)
+		if (hdmiphy_4212_configs[i].pixel_clock ==
 			check_timing->pixclock)
 			return 0;
 
@@ -1066,10 +1066,10 @@ static int hdmi_check_timing(void *ctx, struct fb_videomode *timing)
 			timing->yres, timing->refresh,
 			timing->vmode);
 
-	if (hdata->type == HDMI_TYPE13)
-		return hdmi_v13_check_timing(timing);
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		return hdmi_4210_check_timing(timing);
 	else
-		return hdmi_v14_check_timing(timing);
+		return hdmi_4212_check_timing(timing);
 }
 
 static void hdmi_set_acr(u32 freq, u8 *acr)
@@ -1132,8 +1132,8 @@ static void hdmi_reg_acr(struct hdmi_context *hdata, u8 *acr)
 	hdmi_reg_writeb(hdata, HDMI_ACR_CTS1, acr[2]);
 	hdmi_reg_writeb(hdata, HDMI_ACR_CTS2, acr[1]);
 
-	if (hdata->type == HDMI_TYPE13)
-		hdmi_reg_writeb(hdata, HDMI_V13_ACR_CON, 4);
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		hdmi_reg_writeb(hdata, HDMI_4210_ACR_CON, 4);
 	else
 		hdmi_reg_writeb(hdata, HDMI_ACR_CON, 4);
 }
@@ -1236,8 +1236,8 @@ static void hdmi_conf_reset(struct hdmi_context *hdata)
 {
 	u32 reg;
 
-	if (hdata->type == HDMI_TYPE13)
-		reg = HDMI_V13_CORE_RSTOUT;
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		reg = HDMI_4210_CORE_RSTOUT;
 	else
 		reg = HDMI_CORE_RSTOUT;
 
@@ -1270,21 +1270,21 @@ static void hdmi_conf_init(struct hdmi_context *hdata)
 				HDMI_VID_PREAMBLE_DIS | HDMI_GUARD_BAND_DIS);
 	}
 
-	if (hdata->type == HDMI_TYPE13) {
+	if (hdata->version & HDMI_VER_EXYNOS4210) {
 		/* choose bluescreen (fecal) color */
-		hdmi_reg_writeb(hdata, HDMI_V13_BLUE_SCREEN_0, 0x12);
-		hdmi_reg_writeb(hdata, HDMI_V13_BLUE_SCREEN_1, 0x34);
-		hdmi_reg_writeb(hdata, HDMI_V13_BLUE_SCREEN_2, 0x56);
+		hdmi_reg_writeb(hdata, HDMI_4210_BLUE_SCREEN_0, 0x12);
+		hdmi_reg_writeb(hdata, HDMI_4210_BLUE_SCREEN_1, 0x34);
+		hdmi_reg_writeb(hdata, HDMI_4210_BLUE_SCREEN_2, 0x56);
 
 		/* enable AVI packet every vsync, fixes purple line problem */
-		hdmi_reg_writeb(hdata, HDMI_V13_AVI_CON, 0x02);
+		hdmi_reg_writeb(hdata, HDMI_4210_AVI_CON, 0x02);
 		/* force RGB, look to CEA-861-D, table 7 for more detail */
-		hdmi_reg_writeb(hdata, HDMI_V13_AVI_BYTE(0), 0 << 5);
+		hdmi_reg_writeb(hdata, HDMI_4210_AVI_BYTE(0), 0 << 5);
 		hdmi_reg_writemask(hdata, HDMI_CON_1, 0x10 << 5, 0x11 << 5);
 
-		hdmi_reg_writeb(hdata, HDMI_V13_SPD_CON, 0x02);
-		hdmi_reg_writeb(hdata, HDMI_V13_AUI_CON, 0x02);
-		hdmi_reg_writeb(hdata, HDMI_V13_ACR_CON, 0x04);
+		hdmi_reg_writeb(hdata, HDMI_4210_SPD_CON, 0x02);
+		hdmi_reg_writeb(hdata, HDMI_4210_AUI_CON, 0x02);
+		hdmi_reg_writeb(hdata, HDMI_4210_ACR_CON, 0x04);
 	} else {
 		infoframe.type = HDMI_PACKET_TYPE_AVI;
 		infoframe.ver = HDMI_AVI_VERSION;
@@ -1301,40 +1301,40 @@ static void hdmi_conf_init(struct hdmi_context *hdata)
 	}
 }
 
-static void hdmi_v13_timing_apply(struct hdmi_context *hdata)
+static void hdmi_4210_timing_apply(struct hdmi_context *hdata)
 {
-	const struct hdmi_v13_preset_conf *conf =
-		hdmi_v13_confs[hdata->cur_conf].conf;
-	const struct hdmi_v13_core_regs *core = &conf->core;
-	const struct hdmi_v13_tg_regs *tg = &conf->tg;
+	const struct hdmi_4210_preset_conf *conf =
+		hdmi_4210_confs[hdata->cur_conf].conf;
+	const struct hdmi_4210_core_regs *core = &conf->core;
+	const struct hdmi_4210_tg_regs *tg = &conf->tg;
 	int tries;
 
 	/* setting core registers */
 	hdmi_reg_writeb(hdata, HDMI_H_BLANK_0, core->h_blank[0]);
 	hdmi_reg_writeb(hdata, HDMI_H_BLANK_1, core->h_blank[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_0, core->v_blank[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_1, core->v_blank[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_2, core->v_blank[2]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_V_LINE_0, core->h_v_line[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_V_LINE_1, core->h_v_line[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_V_LINE_2, core->h_v_line[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_0, core->v_blank[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_1, core->v_blank[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_2, core->v_blank[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_V_LINE_0, core->h_v_line[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_V_LINE_1, core->h_v_line[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_V_LINE_2, core->h_v_line[2]);
 	hdmi_reg_writeb(hdata, HDMI_VSYNC_POL, core->vsync_pol[0]);
 	hdmi_reg_writeb(hdata, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_F_0, core->v_blank_f[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_F_1, core->v_blank_f[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_BLANK_F_2, core->v_blank_f[2]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_SYNC_GEN_0, core->h_sync_gen[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_SYNC_GEN_1, core->h_sync_gen[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_H_SYNC_GEN_2, core->h_sync_gen[2]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
-	hdmi_reg_writeb(hdata, HDMI_V13_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_F_0, core->v_blank_f[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_F_1, core->v_blank_f[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_BLANK_F_2, core->v_blank_f[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_SYNC_GEN_0, core->h_sync_gen[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_SYNC_GEN_1, core->h_sync_gen[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_H_SYNC_GEN_2, core->h_sync_gen[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
+	hdmi_reg_writeb(hdata, HDMI_4210_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
 	/* Timing generator registers */
 	hdmi_reg_writeb(hdata, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
 	hdmi_reg_writeb(hdata, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
@@ -1367,7 +1367,7 @@ static void hdmi_v13_timing_apply(struct hdmi_context *hdata)
 
 	/* waiting for HDMIPHY's PLL to get to steady state */
 	for (tries = 100; tries; --tries) {
-		u32 val = hdmi_reg_read(hdata, HDMI_V13_PHY_STATUS);
+		u32 val = hdmi_reg_read(hdata, HDMI_4210_PHY_STATUS);
 		if (val & HDMI_PHY_STATUS_READY)
 			break;
 		usleep_range(1000, 2000);
@@ -1391,7 +1391,7 @@ static void hdmi_v13_timing_apply(struct hdmi_context *hdata)
 		hdmi_reg_writemask(hdata, HDMI_TG_CMD, ~0, HDMI_TG_EN);
 }
 
-static void hdmi_v14_timing_apply(struct hdmi_context *hdata)
+static void hdmi_4212_timing_apply(struct hdmi_context *hdata)
 {
 	struct hdmi_core_regs *core = &hdata->mode_conf.core;
 	struct hdmi_tg_regs *tg = &hdata->mode_conf.tg;
@@ -1559,10 +1559,10 @@ static void hdmi_v14_timing_apply(struct hdmi_context *hdata)
 
 static void hdmi_timing_apply(struct hdmi_context *hdata)
 {
-	if (hdata->type == HDMI_TYPE13)
-		hdmi_v13_timing_apply(hdata);
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		hdmi_4210_timing_apply(hdata);
 	else
-		hdmi_v14_timing_apply(hdata);
+		hdmi_4212_timing_apply(hdata);
 }
 
 static void hdmiphy_conf_reset(struct hdmi_context *hdata)
@@ -1581,8 +1581,8 @@ static void hdmiphy_conf_reset(struct hdmi_context *hdata)
 	if (hdata->hdmiphy_port)
 		i2c_master_send(hdata->hdmiphy_port, buffer, 2);
 
-	if (hdata->type == HDMI_TYPE13)
-		reg = HDMI_V13_PHY_RSTOUT;
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		reg = HDMI_4210_PHY_RSTOUT;
 	else
 		reg = HDMI_PHY_RSTOUT;
 
@@ -1597,7 +1597,7 @@ static void hdmiphy_poweron(struct hdmi_context *hdata)
 {
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
-	if (hdata->type == HDMI_TYPE14)
+	if (hdata->version & HDMI_VER_EXYNOS4212)
 		hdmi_reg_writemask(hdata, HDMI_PHY_CON_0, 0,
 			HDMI_PHY_POWER_OFF_EN);
 }
@@ -1606,7 +1606,7 @@ static void hdmiphy_poweroff(struct hdmi_context *hdata)
 {
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
-	if (hdata->type == HDMI_TYPE14)
+	if (hdata->version & HDMI_VER_EXYNOS4212)
 		hdmi_reg_writemask(hdata, HDMI_PHY_CON_0, ~0,
 			HDMI_PHY_POWER_OFF_EN);
 }
@@ -1626,16 +1626,16 @@ static void hdmiphy_conf_apply(struct hdmi_context *hdata)
 	}
 
 	/* pixel clock */
-	if (hdata->type == HDMI_TYPE13) {
-		hdmiphy_data = hdmi_v13_confs[hdata->cur_conf].hdmiphy_data;
+	if (hdata->version & HDMI_VER_EXYNOS4210) {
+		hdmiphy_data = hdmi_4210_confs[hdata->cur_conf].hdmiphy_data;
 	} else {
-		i = hdmi_v14_find_phy_conf(hdata->mode_conf.pixel_clock);
+		i = hdmi_4212_find_phy_conf(hdata->mode_conf.pixel_clock);
 		if (i < 0) {
 			DRM_ERROR("failed to find hdmiphy conf\n");
 			return;
 		}
 
-		hdmiphy_data = hdmiphy_v14_configs[i].conf;
+		hdmiphy_data = hdmiphy_4212_configs[i].conf;
 	}
 
 	memcpy(buffer, hdmiphy_data, 32);
@@ -1701,10 +1701,10 @@ static void hdmi_mode_fixup(void *ctx, struct drm_connector *connector,
 
 	drm_mode_set_crtcinfo(adjusted_mode, 0);
 
-	if (hdata->type == HDMI_TYPE13)
-		index = hdmi_v13_conf_index(adjusted_mode);
+	if (hdata->version & HDMI_VER_EXYNOS4210)
+		index = hdmi_4210_conf_index(adjusted_mode);
 	else
-		index = hdmi_v14_find_phy_conf(adjusted_mode->clock * 1000);
+		index = hdmi_4212_find_phy_conf(adjusted_mode->clock * 1000);
 
 	/* just return if user desired mode exists. */
 	if (index >= 0)
@@ -1715,10 +1715,10 @@ static void hdmi_mode_fixup(void *ctx, struct drm_connector *connector,
 	 * to adjusted_mode.
 	 */
 	list_for_each_entry(m, &connector->modes, head) {
-		if (hdata->type == HDMI_TYPE13)
-			index = hdmi_v13_conf_index(m);
+		if (hdata->version & HDMI_VER_EXYNOS4210)
+			index = hdmi_4210_conf_index(m);
 		else
-			index = hdmi_v14_find_phy_conf(m->clock * 1000);
+			index = hdmi_4212_find_phy_conf(m->clock * 1000);
 
 		if (index >= 0) {
 			struct drm_mode_object base;
@@ -1749,7 +1749,7 @@ static void hdmi_set_reg(u8 *reg_pair, int num_bytes, u32 value)
 		reg_pair[i] = (value >> (8 * i)) & 0xff;
 }
 
-static void hdmi_v14_mode_set(struct hdmi_context *hdata,
+static void hdmi_4212_mode_set(struct hdmi_context *hdata,
 			struct drm_display_mode *m)
 {
 	struct hdmi_core_regs *core = &hdata->mode_conf.core;
@@ -1864,14 +1864,14 @@ static void hdmi_mode_set(void *ctx, void *mode)
 
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
-	if (hdata->type == HDMI_TYPE13) {
-		conf_idx = hdmi_v13_conf_index(mode);
+	if (hdata->version & HDMI_VER_EXYNOS4210) {
+		conf_idx = hdmi_4210_conf_index(mode);
 		if (conf_idx >= 0)
 			hdata->cur_conf = conf_idx;
 		else
 			DRM_DEBUG_KMS("not supported mode\n");
 	} else {
-		hdmi_v14_mode_set(hdata, mode);
+		hdmi_4212_mode_set(hdata, mode);
 	}
 }
 
@@ -2145,16 +2145,16 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 static struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
-		.driver_data    = HDMI_TYPE13,
+		.driver_data    = HDMI_VER_EXYNOS4210,
 	}, {
 		.name		= "exynos4-hdmi",
-		.driver_data    = HDMI_TYPE13,
+		.driver_data    = HDMI_VER_EXYNOS4210,
 	}, {
 		.name		= "exynos4-hdmi14",
-		.driver_data	= HDMI_TYPE14,
+		.driver_data    = HDMI_VER_EXYNOS4212,
 	}, {
 		.name		= "exynos5-hdmi",
-		.driver_data	= HDMI_TYPE14,
+		.driver_data    = HDMI_VER_EXYNOS4212 | HDMI_VER_EXYNOS5250,
 	}, {
 		/* end node */
 	}
@@ -2163,8 +2163,7 @@ static struct platform_device_id hdmi_driver_types[] = {
 #ifdef CONFIG_OF
 static struct of_device_id hdmi_match_types[] = {
 	{
-		.compatible = "samsung,exynos5-hdmi",
-		.data	= (void	*)HDMI_TYPE14,
+		.compatible = "samsung,exynos4-hdmi",
 	}, {
 		/* end node */
 	}
@@ -2218,17 +2217,18 @@ static int hdmi_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
-	if (dev->of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(of_match_ptr(hdmi_match_types),
-					pdev->dev.of_node);
-		if (match == NULL)
-			return -ENODEV;
-		hdata->type = (enum hdmi_type)match->data;
-	} else {
-		hdata->type = (enum hdmi_type)platform_get_device_id
-					(pdev)->driver_data;
+	hdata->version = 0;
+	if (!dev->of_node) {
+		hdata->version = (enum hdmi_version)
+			platform_get_device_id(pdev)->driver_data;
 	}
+
+	if (of_device_is_compatible(dev->of_node, "samsung,exynos4210-hdmi"))
+		hdata->version |= HDMI_VER_EXYNOS4210;
+	if (of_device_is_compatible(dev->of_node, "samsung,exynos4212-hdmi"))
+		hdata->version |= HDMI_VER_EXYNOS4212;
+	if (of_device_is_compatible(dev->of_node, "samsung,exynos5250-hdmi"))
+		hdata->version |= HDMI_VER_EXYNOS5250;
 
 	hdata->hpd_gpio = pdata->hpd_gpio;
 	hdata->dev = dev;
diff --git a/drivers/gpu/drm/exynos/regs-hdmi.h b/drivers/gpu/drm/exynos/regs-hdmi.h
index ef1b3eb..5b14fa3 100644
--- a/drivers/gpu/drm/exynos/regs-hdmi.h
+++ b/drivers/gpu/drm/exynos/regs-hdmi.h
@@ -19,7 +19,7 @@
  * Register part
 */
 
-/* HDMI Version 1.3 & Common */
+/* Base addresses */
 #define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
 #define HDMI_CORE_BASE(x)		((x) + 0x00010000)
 #define HDMI_I2S_BASE(x)		((x) + 0x00040000)
@@ -29,57 +29,57 @@
 #define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
 #define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
 #define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
-#define HDMI_V13_PHY_RSTOUT		HDMI_CTRL_BASE(0x0014)
-#define HDMI_V13_PHY_VPLL		HDMI_CTRL_BASE(0x0018)
-#define HDMI_V13_PHY_CMU		HDMI_CTRL_BASE(0x001C)
-#define HDMI_V13_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
+#define HDMI_4210_PHY_RSTOUT		HDMI_CTRL_BASE(0x0014)
+#define HDMI_4210_PHY_VPLL		HDMI_CTRL_BASE(0x0018)
+#define HDMI_4210_PHY_CMU		HDMI_CTRL_BASE(0x001C)
+#define HDMI_4210_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
 
 /* Core registers */
 #define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
 #define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
 #define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
 #define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
-#define HDMI_V13_PHY_STATUS		HDMI_CORE_BASE(0x0014)
+#define HDMI_4210_PHY_STATUS		HDMI_CORE_BASE(0x0014)
 #define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
 #define HDMI_HPD			HDMI_CORE_BASE(0x0030)
 #define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
 #define HDMI_ENC_EN			HDMI_CORE_BASE(0x0044)
-#define HDMI_V13_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
-#define HDMI_V13_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
-#define HDMI_V13_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
+#define HDMI_4210_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
+#define HDMI_4210_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
+#define HDMI_4210_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
 #define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
 #define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
-#define HDMI_V13_V_BLANK_0		HDMI_CORE_BASE(0x00B0)
-#define HDMI_V13_V_BLANK_1		HDMI_CORE_BASE(0x00B4)
-#define HDMI_V13_V_BLANK_2		HDMI_CORE_BASE(0x00B8)
-#define HDMI_V13_H_V_LINE_0		HDMI_CORE_BASE(0x00C0)
-#define HDMI_V13_H_V_LINE_1		HDMI_CORE_BASE(0x00C4)
-#define HDMI_V13_H_V_LINE_2		HDMI_CORE_BASE(0x00C8)
+#define HDMI_4210_V_BLANK_0		HDMI_CORE_BASE(0x00B0)
+#define HDMI_4210_V_BLANK_1		HDMI_CORE_BASE(0x00B4)
+#define HDMI_4210_V_BLANK_2		HDMI_CORE_BASE(0x00B8)
+#define HDMI_4210_H_V_LINE_0		HDMI_CORE_BASE(0x00C0)
+#define HDMI_4210_H_V_LINE_1		HDMI_CORE_BASE(0x00C4)
+#define HDMI_4210_H_V_LINE_2		HDMI_CORE_BASE(0x00C8)
 #define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
 #define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
-#define HDMI_V13_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
-#define HDMI_V13_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
-#define HDMI_V13_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
-#define HDMI_V13_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
-#define HDMI_V13_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
-#define HDMI_V13_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
-#define HDMI_V13_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
-#define HDMI_V13_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
-#define HDMI_V13_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
-#define HDMI_V13_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
-#define HDMI_V13_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
-#define HDMI_V13_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
-#define HDMI_V13_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
-#define HDMI_V13_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
-#define HDMI_V13_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
-#define HDMI_V13_ACR_CON		HDMI_CORE_BASE(0x0180)
-#define HDMI_V13_AVI_CON		HDMI_CORE_BASE(0x0300)
-#define HDMI_V13_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
-#define HDMI_V13_DC_CONTROL		HDMI_CORE_BASE(0x05C0)
-#define HDMI_V13_VIDEO_PATTERN_GEN	HDMI_CORE_BASE(0x05C4)
-#define HDMI_V13_HPD_GEN		HDMI_CORE_BASE(0x05C8)
-#define HDMI_V13_AUI_CON		HDMI_CORE_BASE(0x0360)
-#define HDMI_V13_SPD_CON		HDMI_CORE_BASE(0x0400)
+#define HDMI_4210_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
+#define HDMI_4210_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
+#define HDMI_4210_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
+#define HDMI_4210_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
+#define HDMI_4210_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
+#define HDMI_4210_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
+#define HDMI_4210_V_SYNC_GEN_1_0	HDMI_CORE_BASE(0x0130)
+#define HDMI_4210_V_SYNC_GEN_1_1	HDMI_CORE_BASE(0x0134)
+#define HDMI_4210_V_SYNC_GEN_1_2	HDMI_CORE_BASE(0x0138)
+#define HDMI_4210_V_SYNC_GEN_2_0	HDMI_CORE_BASE(0x0140)
+#define HDMI_4210_V_SYNC_GEN_2_1	HDMI_CORE_BASE(0x0144)
+#define HDMI_4210_V_SYNC_GEN_2_2	HDMI_CORE_BASE(0x0148)
+#define HDMI_4210_V_SYNC_GEN_3_0	HDMI_CORE_BASE(0x0150)
+#define HDMI_4210_V_SYNC_GEN_3_1	HDMI_CORE_BASE(0x0154)
+#define HDMI_4210_V_SYNC_GEN_3_2	HDMI_CORE_BASE(0x0158)
+#define HDMI_4210_ACR_CON		HDMI_CORE_BASE(0x0180)
+#define HDMI_4210_AVI_CON		HDMI_CORE_BASE(0x0300)
+#define HDMI_4210_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
+#define HDMI_4210_DC_CONTROL		HDMI_CORE_BASE(0x05C0)
+#define HDMI_4210_VIDEO_PATTERN_GEN	HDMI_CORE_BASE(0x05C4)
+#define HDMI_4210_HPD_GEN		HDMI_CORE_BASE(0x05C8)
+#define HDMI_4210_AUI_CON		HDMI_CORE_BASE(0x0360)
+#define HDMI_4210_SPD_CON		HDMI_CORE_BASE(0x0400)
 
 /* Timing generator registers */
 #define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
@@ -155,7 +155,7 @@
 #define HDMI_FIELD_EN			(1 << 1)
 
 
-/* HDMI Version 1.4 */
+/* Exynos 4212 */
 /* Control registers */
 /* #define HDMI_INTC_CON		HDMI_CTRL_BASE(0x0000) */
 /* #define HDMI_INTC_FLAG		HDMI_CTRL_BASE(0x0004) */
-- 
1.7.7.3

