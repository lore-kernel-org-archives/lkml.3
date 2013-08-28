Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3H1Kmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:42:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10305 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3H1KlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:41:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 03:41:20 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 1/5] host1x: hdmi: Add Tegra114 support
Date: Wed, 28 Aug 2013 13:40:55 +0300
Message-ID: <1377686459-16634-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Tegra114 TMDS configuration, add new peak_current field and
use new place for drive current override bit on Tegra114 platform.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/gpu/host1x/drm/drm.c  |   1 +
 drivers/gpu/host1x/drm/hdmi.c | 102 +++++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/hdmi.h | 152 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 252 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 8c61cee..37f5166 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -88,6 +88,7 @@ static int host1x_parse_dt(struct host1x_drm *host1x)
 		"nvidia,tegra30-dc",
 		"nvidia,tegra30-hdmi",
 		"nvidia,tegra30-gr2d",
+		"nvidia,tegra114-hdmi",
 	};
 	unsigned int i;
 	int err;
diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index 01097da..d81fac8 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -149,6 +149,7 @@ struct tmds_config {
 	u32 pll1;
 	u32 pe_current;
 	u32 drive_current;
+	u32 peak_current;
 };
 
 static const struct tmds_config tegra2_tmds_config[] = {
@@ -230,6 +231,85 @@ static const struct tmds_config tegra3_tmds_config[] = {
 	},
 };
 
+const struct tmds_config tegra114_tmds_config[] = {
+	{ /* 480p/576p / 25.2MHz/27MHz modes */
+		.pclk = 27000000,
+		.pll0 = SOR_PLL_ICHPMP(1) | SOR_PLL_BG_V17_S(3) |
+			SOR_PLL_VCOCAP(0) | SOR_PLL_RESISTORSEL,
+		.pll1 = SOR_PLL_LOADADJ(3) | SOR_PLL_TMDS_TERMADJ(0),
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT1(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT2(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT3(PE_CURRENT_0_mA_T114),
+		.drive_current =
+			DRIVE_CURRENT_LANE0_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE1_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE2_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE3_T114(DRIVE_CURRENT_10_400_mA_T114),
+		.peak_current = PEAK_CURRENT_LANE0(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE1(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE2(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE3(PEAK_CURRENT_0_000_mA),
+	}, { /* 720p / 74.25MHz modes */
+		.pclk = 74250000,
+		.pll0 = SOR_PLL_ICHPMP(1) | SOR_PLL_BG_V17_S(3) |
+			SOR_PLL_VCOCAP(1) | SOR_PLL_RESISTORSEL,
+		.pll1 = SOR_PLL_PE_EN | SOR_PLL_LOADADJ(3) |
+			SOR_PLL_TMDS_TERMADJ(0),
+		.pe_current = PE_CURRENT0(PE_CURRENT_15_mA_T114) |
+			PE_CURRENT1(PE_CURRENT_15_mA_T114) |
+			PE_CURRENT2(PE_CURRENT_15_mA_T114) |
+			PE_CURRENT3(PE_CURRENT_15_mA_T114),
+		.drive_current =
+			DRIVE_CURRENT_LANE0_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE1_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE2_T114(DRIVE_CURRENT_10_400_mA_T114) |
+			DRIVE_CURRENT_LANE3_T114(DRIVE_CURRENT_10_400_mA_T114),
+		.peak_current = PEAK_CURRENT_LANE0(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE1(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE2(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE3(PEAK_CURRENT_0_000_mA),
+	}, { /* 1080p / 148.5MHz modes */
+		.pclk = 148500000,
+		.pll0 = SOR_PLL_ICHPMP(1) | SOR_PLL_BG_V17_S(3) |
+			SOR_PLL_VCOCAP(3) | SOR_PLL_RESISTORSEL,
+		.pll1 = SOR_PLL_PE_EN | SOR_PLL_LOADADJ(3) |
+			SOR_PLL_TMDS_TERMADJ(0),
+		.pe_current = PE_CURRENT0(PE_CURRENT_10_mA_T114) |
+			PE_CURRENT1(PE_CURRENT_10_mA_T114) |
+			PE_CURRENT2(PE_CURRENT_10_mA_T114) |
+			PE_CURRENT3(PE_CURRENT_10_mA_T114),
+		.drive_current =
+			DRIVE_CURRENT_LANE0_T114(DRIVE_CURRENT_12_400_mA_T114) |
+			DRIVE_CURRENT_LANE1_T114(DRIVE_CURRENT_12_400_mA_T114) |
+			DRIVE_CURRENT_LANE2_T114(DRIVE_CURRENT_12_400_mA_T114) |
+			DRIVE_CURRENT_LANE3_T114(DRIVE_CURRENT_12_400_mA_T114),
+		.peak_current = PEAK_CURRENT_LANE0(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE1(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE2(PEAK_CURRENT_0_000_mA) |
+			PEAK_CURRENT_LANE3(PEAK_CURRENT_0_000_mA),
+	}, { /* 225/297MHz modes */
+		.pclk = UINT_MAX,
+		.pll0 = SOR_PLL_ICHPMP(1) | SOR_PLL_BG_V17_S(3) |
+			SOR_PLL_VCOCAP(0xf) | SOR_PLL_RESISTORSEL,
+		.pll1 = SOR_PLL_LOADADJ(3) | SOR_PLL_TMDS_TERMADJ(7)
+			| SOR_PLL_TMDS_TERM_ENABLE,
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT1(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT2(PE_CURRENT_0_mA_T114) |
+			PE_CURRENT3(PE_CURRENT_0_mA_T114),
+		.drive_current =
+			DRIVE_CURRENT_LANE0_T114(DRIVE_CURRENT_25_200_mA_T114) |
+			DRIVE_CURRENT_LANE1_T114(DRIVE_CURRENT_25_200_mA_T114) |
+			DRIVE_CURRENT_LANE2_T114(DRIVE_CURRENT_25_200_mA_T114) |
+			DRIVE_CURRENT_LANE3_T114(DRIVE_CURRENT_19_200_mA_T114),
+		.peak_current = PEAK_CURRENT_LANE0(PEAK_CURRENT_3_000_mA) |
+			PEAK_CURRENT_LANE1(PEAK_CURRENT_3_000_mA) |
+			PEAK_CURRENT_LANE2(PEAK_CURRENT_3_000_mA) |
+			PEAK_CURRENT_LANE3(PEAK_CURRENT_0_800_mA),
+	},
+};
+
 static const struct tegra_hdmi_audio_config *
 tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
 {
@@ -593,8 +673,20 @@ static void tegra_hdmi_setup_tmds(struct tegra_hdmi *hdmi,
 	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
 	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
 
-	value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+	if (of_device_is_compatible(hdmi->dev->of_node,
+		"nvidia,tegra114-hdmi")) {
+		tegra_hdmi_writel(hdmi, tmds->drive_current,
+				  HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_SOR_PAD_CTLS0);
+		value |= DRIVE_CURRENT_FUSE_OVERRIDE_T114;
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_PAD_CTLS0);
+		tegra_hdmi_writel(hdmi, tmds->peak_current,
+				  HDMI_NV_PDISP_SOR_IO_PEAK_CURRENT);
+	} else {
+		value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
+		tegra_hdmi_writel(hdmi, value,
+				  HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+	}
 }
 
 static int tegra_output_hdmi_enable(struct tegra_output *output)
@@ -726,7 +818,10 @@ static int tegra_output_hdmi_enable(struct tegra_output *output)
 	tegra_hdmi_setup_stereo_infoframe(hdmi);
 
 	/* TMDS CONFIG */
-	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+	if (of_device_is_compatible(node, "nvidia,tegra114-hdmi")) {
+		num_tmds = ARRAY_SIZE(tegra114_tmds_config);
+		tmds = tegra114_tmds_config;
+	} else if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
 		num_tmds = ARRAY_SIZE(tegra3_tmds_config);
 		tmds = tegra3_tmds_config;
 	} else {
@@ -1299,6 +1394,7 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
 static struct of_device_id tegra_hdmi_of_match[] = {
 	{ .compatible = "nvidia,tegra30-hdmi", },
 	{ .compatible = "nvidia,tegra20-hdmi", },
+	{ .compatible = "nvidia,tegra114-hdmi", },
 	{ },
 };
 
diff --git a/drivers/gpu/host1x/drm/hdmi.h b/drivers/gpu/host1x/drm/hdmi.h
index 52ac36e..37925c2 100644
--- a/drivers/gpu/host1x/drm/hdmi.h
+++ b/drivers/gpu/host1x/drm/hdmi.h
@@ -233,6 +233,10 @@
 #define DRIVE_CURRENT_LANE1(x)      (((x) & 0x3f) <<  8)
 #define DRIVE_CURRENT_LANE2(x)      (((x) & 0x3f) << 16)
 #define DRIVE_CURRENT_LANE3(x)      (((x) & 0x3f) << 24)
+#define DRIVE_CURRENT_LANE0_T114(x) (((x) & 0x7f) <<  0)
+#define DRIVE_CURRENT_LANE1_T114(x) (((x) & 0x7f) <<  8)
+#define DRIVE_CURRENT_LANE2_T114(x) (((x) & 0x7f) << 16)
+#define DRIVE_CURRENT_LANE3_T114(x) (((x) & 0x7f) << 24)
 #define DRIVE_CURRENT_FUSE_OVERRIDE (1 << 31)
 
 #define DRIVE_CURRENT_1_500_mA  0x00
@@ -299,6 +303,79 @@
 #define DRIVE_CURRENT_24_375_mA 0x3d
 #define DRIVE_CURRENT_24_750_mA 0x3e
 
+#define DRIVE_CURRENT_0_000_mA_T114 0x00
+#define DRIVE_CURRENT_0_400_mA_T114 0x01
+#define DRIVE_CURRENT_0_800_mA_T114 0x02
+#define DRIVE_CURRENT_1_200_mA_T114 0x03
+#define DRIVE_CURRENT_1_600_mA_T114 0x04
+#define DRIVE_CURRENT_2_000_mA_T114 0x05
+#define DRIVE_CURRENT_2_400_mA_T114 0x06
+#define DRIVE_CURRENT_2_800_mA_T114 0x07
+#define DRIVE_CURRENT_3_200_mA_T114 0x08
+#define DRIVE_CURRENT_3_600_mA_T114 0x09
+#define DRIVE_CURRENT_4_000_mA_T114 0x0a
+#define DRIVE_CURRENT_4_400_mA_T114 0x0b
+#define DRIVE_CURRENT_4_800_mA_T114 0x0c
+#define DRIVE_CURRENT_5_200_mA_T114 0x0d
+#define DRIVE_CURRENT_5_600_mA_T114 0x0e
+#define DRIVE_CURRENT_6_000_mA_T114 0x0f
+#define DRIVE_CURRENT_6_400_mA_T114 0x10
+#define DRIVE_CURRENT_6_800_mA_T114 0x11
+#define DRIVE_CURRENT_7_200_mA_T114 0x12
+#define DRIVE_CURRENT_7_600_mA_T114 0x13
+#define DRIVE_CURRENT_8_000_mA_T114 0x14
+#define DRIVE_CURRENT_8_400_mA_T114 0x15
+#define DRIVE_CURRENT_8_800_mA_T114 0x16
+#define DRIVE_CURRENT_9_200_mA_T114 0x17
+#define DRIVE_CURRENT_9_600_mA_T114 0x18
+#define DRIVE_CURRENT_10_000_mA_T114 0x19
+#define DRIVE_CURRENT_10_400_mA_T114 0x1a
+#define DRIVE_CURRENT_10_800_mA_T114 0x1b
+#define DRIVE_CURRENT_11_200_mA_T114 0x1c
+#define DRIVE_CURRENT_11_600_mA_T114 0x1d
+#define DRIVE_CURRENT_12_000_mA_T114 0x1e
+#define DRIVE_CURRENT_12_400_mA_T114 0x1f
+#define DRIVE_CURRENT_12_800_mA_T114 0x20
+#define DRIVE_CURRENT_13_200_mA_T114 0x21
+#define DRIVE_CURRENT_13_600_mA_T114 0x22
+#define DRIVE_CURRENT_14_000_mA_T114 0x23
+#define DRIVE_CURRENT_14_400_mA_T114 0x24
+#define DRIVE_CURRENT_14_800_mA_T114 0x25
+#define DRIVE_CURRENT_15_200_mA_T114 0x26
+#define DRIVE_CURRENT_15_600_mA_T114 0x27
+#define DRIVE_CURRENT_16_000_mA_T114 0x28
+#define DRIVE_CURRENT_16_400_mA_T114 0x29
+#define DRIVE_CURRENT_16_800_mA_T114 0x2a
+#define DRIVE_CURRENT_17_200_mA_T114 0x2b
+#define DRIVE_CURRENT_17_600_mA_T114 0x2c
+#define DRIVE_CURRENT_18_000_mA_T114 0x2d
+#define DRIVE_CURRENT_18_400_mA_T114 0x2e
+#define DRIVE_CURRENT_18_800_mA_T114 0x2f
+#define DRIVE_CURRENT_19_200_mA_T114 0x30
+#define DRIVE_CURRENT_19_600_mA_T114 0x31
+#define DRIVE_CURRENT_20_000_mA_T114 0x32
+#define DRIVE_CURRENT_20_400_mA_T114 0x33
+#define DRIVE_CURRENT_20_800_mA_T114 0x34
+#define DRIVE_CURRENT_21_200_mA_T114 0x35
+#define DRIVE_CURRENT_21_600_mA_T114 0x36
+#define DRIVE_CURRENT_22_000_mA_T114 0x37
+#define DRIVE_CURRENT_22_400_mA_T114 0x38
+#define DRIVE_CURRENT_22_800_mA_T114 0x39
+#define DRIVE_CURRENT_23_200_mA_T114 0x3a
+#define DRIVE_CURRENT_23_600_mA_T114 0x3b
+#define DRIVE_CURRENT_24_000_mA_T114 0x3c
+#define DRIVE_CURRENT_24_400_mA_T114 0x3d
+#define DRIVE_CURRENT_24_800_mA_T114 0x3e
+#define DRIVE_CURRENT_25_200_mA_T114 0x3f
+#define DRIVE_CURRENT_25_400_mA_T114 0x40
+#define DRIVE_CURRENT_25_800_mA_T114 0x41
+#define DRIVE_CURRENT_26_200_mA_T114 0x42
+#define DRIVE_CURRENT_26_600_mA_T114 0x43
+#define DRIVE_CURRENT_27_000_mA_T114 0x44
+#define DRIVE_CURRENT_27_400_mA_T114 0x45
+#define DRIVE_CURRENT_27_800_mA_T114 0x46
+#define DRIVE_CURRENT_28_200_mA_T114 0x47
+
 #define HDMI_NV_PDISP_AUDIO_DEBUG0				0x7f
 #define HDMI_NV_PDISP_AUDIO_DEBUG1				0x80
 #define HDMI_NV_PDISP_AUDIO_DEBUG2				0x81
@@ -358,6 +435,23 @@
 #define PE_CURRENT_7_0_mA 0xe
 #define PE_CURRENT_7_5_mA 0xf
 
+#define PE_CURRENT_0_mA_T114 0x0
+#define PE_CURRENT_1_mA_T114 0x1
+#define PE_CURRENT_2_mA_T114 0x2
+#define PE_CURRENT_3_mA_T114 0x3
+#define PE_CURRENT_4_mA_T114 0x4
+#define PE_CURRENT_5_mA_T114 0x5
+#define PE_CURRENT_6_mA_T114 0x6
+#define PE_CURRENT_7_mA_T114 0x7
+#define PE_CURRENT_8_mA_T114 0x8
+#define PE_CURRENT_9_mA_T114 0x9
+#define PE_CURRENT_10_mA_T114 0xa
+#define PE_CURRENT_11_mA_T114 0xb
+#define PE_CURRENT_12_mA_T114 0xc
+#define PE_CURRENT_13_mA_T114 0xd
+#define PE_CURRENT_14_mA_T114 0xe
+#define PE_CURRENT_15_mA_T114 0xf
+
 #define HDMI_NV_PDISP_KEY_CTRL					0x9a
 #define HDMI_NV_PDISP_KEY_DEBUG0				0x9b
 #define HDMI_NV_PDISP_KEY_DEBUG1				0x9c
@@ -383,4 +477,62 @@
 #define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920    0xc5
 #define HDMI_NV_PDISP_SOR_AUDIO_AVAL_DEFAULT 0xc5
 
+#define HDMI_NV_PDISP_SOR_IO_PEAK_CURRENT		0xd1
+#define PEAK_CURRENT_LANE0(x) (((x) & 0x7f) <<  0)
+#define PEAK_CURRENT_LANE1(x) (((x) & 0x7f) <<  8)
+#define PEAK_CURRENT_LANE2(x) (((x) & 0x7f) << 16)
+#define PEAK_CURRENT_LANE3(x) (((x) & 0x7f) << 24)
+
+#define PEAK_CURRENT_0_000_mA 0x00
+#define PEAK_CURRENT_0_200_mA 0x01
+#define PEAK_CURRENT_0_400_mA 0x02
+#define PEAK_CURRENT_0_600_mA 0x03
+#define PEAK_CURRENT_0_800_mA 0x04
+#define PEAK_CURRENT_1_000_mA 0x05
+#define PEAK_CURRENT_1_200_mA 0x06
+#define PEAK_CURRENT_1_400_mA 0x07
+#define PEAK_CURRENT_1_600_mA 0x08
+#define PEAK_CURRENT_1_800_mA 0x09
+#define PEAK_CURRENT_2_000_mA 0x0a
+#define PEAK_CURRENT_2_200_mA 0x0b
+#define PEAK_CURRENT_2_400_mA 0x0c
+#define PEAK_CURRENT_2_600_mA 0x0d
+#define PEAK_CURRENT_2_800_mA 0x0e
+#define PEAK_CURRENT_3_000_mA 0x0f
+#define PEAK_CURRENT_3_200_mA 0x10
+#define PEAK_CURRENT_3_400_mA 0x11
+#define PEAK_CURRENT_3_600_mA 0x12
+#define PEAK_CURRENT_3_800_mA 0x13
+#define PEAK_CURRENT_4_000_mA 0x14
+#define PEAK_CURRENT_4_200_mA 0x15
+#define PEAK_CURRENT_4_400_mA 0x16
+#define PEAK_CURRENT_4_600_mA 0x17
+#define PEAK_CURRENT_4_800_mA 0x18
+#define PEAK_CURRENT_5_000_mA 0x19
+#define PEAK_CURRENT_5_200_mA 0x1a
+#define PEAK_CURRENT_5_400_mA 0x1b
+#define PEAK_CURRENT_5_600_mA 0x1c
+#define PEAK_CURRENT_5_800_mA 0x1d
+#define PEAK_CURRENT_6_000_mA 0x1e
+#define PEAK_CURRENT_6_200_mA 0x1f
+#define PEAK_CURRENT_6_400_mA 0x20
+#define PEAK_CURRENT_6_600_mA 0x21
+#define PEAK_CURRENT_6_800_mA 0x22
+#define PEAK_CURRENT_7_000_mA 0x23
+#define PEAK_CURRENT_7_200_mA 0x24
+#define PEAK_CURRENT_7_400_mA 0x25
+#define PEAK_CURRENT_7_600_mA 0x26
+#define PEAK_CURRENT_7_800_mA 0x27
+#define PEAK_CURRENT_8_000_mA 0x28
+#define PEAK_CURRENT_8_200_mA 0x29
+#define PEAK_CURRENT_8_400_mA 0x2a
+#define PEAK_CURRENT_8_600_mA 0x2b
+#define PEAK_CURRENT_8_800_mA 0x2c
+#define PEAK_CURRENT_9_000_mA 0x2d
+#define PEAK_CURRENT_9_200_mA 0x2e
+#define PEAK_CURRENT_9_400_mA 0x2f
+
+#define HDMI_NV_PDISP_SOR_PAD_CTLS0		0xd2
+#define DRIVE_CURRENT_FUSE_OVERRIDE_T114	(1 << 31)
+
 #endif /* TEGRA_HDMI_H */
-- 
1.8.1.5

