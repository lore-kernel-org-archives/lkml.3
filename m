Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbbATKuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:50:03 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:34739 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbbATKt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:59 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 36/36] drm/tegra: dc: Unify enabling the display controller
Date: Tue, 20 Jan 2015 11:48:55 +0100
Message-Id: <1421750935-4023-37-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Previously output drivers would enable continuous display mode and power
up the display controller at various points during the initialization.
This is suboptimal because it accesses display controller registers in
output drivers and duplicates a bit of code.

Move this code into the display controller driver and enable the display
controller as the final step of the ->mode_set_nofb() implementation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   | 12 ++++++++++++
 drivers/gpu/drm/tegra/dsi.c  | 10 ----------
 drivers/gpu/drm/tegra/hdmi.c | 10 ----------
 drivers/gpu/drm/tegra/rgb.c  | 11 +----------
 drivers/gpu/drm/tegra/sor.c  | 25 +++----------------------
 5 files changed, 16 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 1280b886481d..c4cbcbfbd3ab 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1248,6 +1248,18 @@ static void tegra_crtc_mode_set_nofb(struct drm_crtc *crtc)
 		value &= ~INTERLACE_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_INTERLACE_CONTROL);
 	}
+
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
+	value &= ~DISP_CTRL_MODE_MASK;
+	value |= DISP_CTRL_MODE_C_DISPLAY;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
+	value |= PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+
+	tegra_dc_commit(dc);
 }
 
 static void tegra_crtc_prepare(struct drm_crtc *crtc)
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 39c79a65b4f3..82f95f7f819c 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -824,16 +824,6 @@ static void tegra_dsi_encoder_mode_set(struct drm_encoder *encoder,
 	value |= DSI_ENABLE;
 	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-	value &= ~DISP_CTRL_MODE_MASK;
-	value |= DISP_CTRL_MODE_C_DISPLAY;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
-	value |= PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
 	tegra_dc_commit(dc);
 
 	/* enable DSI controller */
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 07771956cc94..7e06657ae58b 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1022,16 +1022,6 @@ static void tegra_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 	value |= HDMI_ENABLE;
 	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-	value &= ~DISP_CTRL_MODE_MASK;
-	value |= DISP_CTRL_MODE_C_DISPLAY;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
-	value |= PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
 	tegra_dc_commit(dc);
 
 	/* TODO: add HDCP support */
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 0c8b458b2364..7cd833f5b5b5 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -168,16 +168,6 @@ static void tegra_rgb_encoder_mode_set(struct drm_encoder *encoder,
 	value = SC0_H_QUALIFIER_NONE | SC1_H_QUALIFIER_NONE;
 	tegra_dc_writel(rgb->dc, value, DC_DISP_SHIFT_CLOCK_OPTIONS);
 
-	value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_COMMAND);
-	value &= ~DISP_CTRL_MODE_MASK;
-	value |= DISP_CTRL_MODE_C_DISPLAY;
-	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_COMMAND);
-
-	value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_POWER_CONTROL);
-	value |= PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
 	tegra_dc_commit(rgb->dc);
 
 	if (output->panel)
@@ -193,6 +183,7 @@ static void tegra_rgb_encoder_disable(struct drm_encoder *encoder)
 		drm_panel_disable(output->panel);
 
 	tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
+	tegra_dc_commit(rgb->dc);
 
 	if (output->panel)
 		drm_panel_unprepare(output->panel);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index e813df71e30c..2afe478ded3b 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -261,17 +261,8 @@ static int tegra_sor_attach(struct tegra_sor *sor)
 
 static int tegra_sor_wakeup(struct tegra_sor *sor)
 {
-	struct tegra_dc *dc = to_tegra_dc(sor->output.encoder.crtc);
 	unsigned long value, timeout;
 
-	/* enable display controller outputs */
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
-	value |= PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
-	tegra_dc_commit(dc);
-
 	timeout = jiffies + msecs_to_jiffies(250);
 
 	/* wait for head to wake up */
@@ -1112,18 +1103,6 @@ static void tegra_sor_encoder_mode_set(struct drm_encoder *encoder,
 		goto unlock;
 	}
 
-	/* start display controller in continuous mode */
-	value = tegra_dc_readl(dc, DC_CMD_STATE_ACCESS);
-	value |= WRITE_MUX;
-	tegra_dc_writel(dc, value, DC_CMD_STATE_ACCESS);
-
-	tegra_dc_writel(dc, VSYNC_H_POSITION(1), DC_DISP_DISP_TIMING_OPTIONS);
-	tegra_dc_writel(dc, DISP_CTRL_MODE_C_DISPLAY, DC_CMD_DISPLAY_COMMAND);
-
-	value = tegra_dc_readl(dc, DC_CMD_STATE_ACCESS);
-	value &= ~WRITE_MUX;
-	tegra_dc_writel(dc, value, DC_CMD_STATE_ACCESS);
-
 	/*
 	 * configure panel (24bpp, vsync-, hsync-, DP-A protocol, complete
 	 * raster, associate with display controller)
@@ -1198,11 +1177,13 @@ static void tegra_sor_encoder_mode_set(struct drm_encoder *encoder,
 		goto unlock;
 	}
 
+	tegra_sor_update(sor);
+
 	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 	value |= SOR_ENABLE;
 	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-	tegra_sor_update(sor);
+	tegra_dc_commit(dc);
 
 	err = tegra_sor_attach(sor);
 	if (err < 0) {
-- 
2.1.3

