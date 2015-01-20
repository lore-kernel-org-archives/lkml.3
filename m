Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbbATKtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:14 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54080 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbbATKtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:11 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/36] drm/tegra: Stop CRTC at CRTC disable time
Date: Tue, 20 Jan 2015 11:48:26 +0100
Message-Id: <1421750935-4023-8-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Previously output drivers would all stop the display controller in their
disable path. However with the transition to atomic modesetting the
display controller needs to be kept running until all planes have been
disabled so that software can properly determine (using VBLANK counts)
when it is safe to remove the framebuffers associated with the planes.

Moving this code into the display controller's disable path also gets
rid of the duplication of this into all output drivers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   | 6 ++++++
 drivers/gpu/drm/tegra/dsi.c  | 4 ----
 drivers/gpu/drm/tegra/hdmi.c | 4 ----
 drivers/gpu/drm/tegra/rgb.c  | 4 ----
 drivers/gpu/drm/tegra/sor.c  | 4 ----
 5 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 6450f1a308cf..db7865ab85c7 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -947,6 +947,7 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct drm_device *drm = crtc->dev;
 	struct drm_plane *plane;
+	u32 value;
 
 	drm_for_each_legacy_plane(plane, &drm->mode_config.plane_list) {
 		if (plane->crtc == crtc) {
@@ -960,6 +961,11 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 		}
 	}
 
+	/* stop the display controller */
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
+	value &= ~DISP_CTRL_MODE_MASK;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
 	drm_crtc_vblank_off(crtc);
 	tegra_dc_commit(dc);
 }
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 6554eac858b7..a8c208dab698 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -769,10 +769,6 @@ static int tegra_output_dsi_disable(struct tegra_output *output)
 			   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
 		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-		value &= ~DISP_CTRL_MODE_MASK;
-		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
 		value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 		value &= ~DSI_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index f118b914293e..d4c635148cc7 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1033,10 +1033,6 @@ static int tegra_output_hdmi_disable(struct tegra_output *output)
 		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 		*/
 
-		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-		value &= ~DISP_CTRL_MODE_MASK;
-		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
 		value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 		value &= ~HDMI_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 3b851abbccae..39b8d5fe04b2 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -143,10 +143,6 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
 		   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
 	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-	value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_COMMAND);
-	value &= ~DISP_CTRL_MODE_MASK;
-	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_COMMAND);
-
 	tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
 
 	tegra_dc_commit(rgb->dc);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 6a341822abe9..1fe801ee8eb0 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1071,10 +1071,6 @@ static int tegra_output_sor_disable(struct tegra_output *output)
 		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 		*/
 
-		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-		value &= ~DISP_CTRL_MODE_MASK;
-		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
 		value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 		value &= ~SOR_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
-- 
2.1.3

