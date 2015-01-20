Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbbATLCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:02:35 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51618 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbbATKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:09 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/36] drm/tegra: Use tegra_commit_dc() in output drivers
Date: Tue, 20 Jan 2015 11:48:25 +0100
Message-Id: <1421750935-4023-7-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

All output drivers have open-coded variants of this function, so export
it to remove some code duplication.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   | 2 +-
 drivers/gpu/drm/tegra/drm.h  | 1 +
 drivers/gpu/drm/tegra/dsi.c  | 6 ++----
 drivers/gpu/drm/tegra/hdmi.c | 6 ++----
 drivers/gpu/drm/tegra/rgb.c  | 8 +++-----
 drivers/gpu/drm/tegra/sor.c  | 6 ++----
 6 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 8f64d8fdf967..6450f1a308cf 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -72,7 +72,7 @@ static void tegra_dc_cursor_commit(struct tegra_dc *dc)
  * into the ACTIVE copy, either immediately if the display controller is in
  * STOP mode, or at the next frame boundary otherwise.
  */
-static void tegra_dc_commit(struct tegra_dc *dc)
+void tegra_dc_commit(struct tegra_dc *dc)
 {
 	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
 	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 3a3b2e7b5b3f..5a0e96debcb1 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -177,6 +177,7 @@ struct tegra_dc_window {
 void tegra_dc_enable_vblank(struct tegra_dc *dc);
 void tegra_dc_disable_vblank(struct tegra_dc *dc);
 void tegra_dc_cancel_page_flip(struct drm_crtc *crtc, struct drm_file *file);
+void tegra_dc_commit(struct tegra_dc *dc);
 
 struct tegra_output_ops {
 	int (*enable)(struct tegra_output *output);
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index c5a14eea5e55..6554eac858b7 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -658,8 +658,7 @@ static int tegra_output_dsi_enable(struct tegra_output *output)
 		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
 	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+	tegra_dc_commit(dc);
 
 	/* enable DSI controller */
 	tegra_dsi_enable(dsi);
@@ -778,8 +777,7 @@ static int tegra_output_dsi_disable(struct tegra_output *output)
 		value &= ~DSI_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-		tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-		tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+		tegra_dc_commit(dc);
 	}
 
 	err = tegra_dsi_wait_idle(dsi, 100);
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 0f122eae7c64..f118b914293e 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -997,8 +997,7 @@ static int tegra_output_hdmi_enable(struct tegra_output *output)
 		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
 	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+	tegra_dc_commit(dc);
 
 	/* TODO: add HDCP support */
 
@@ -1042,8 +1041,7 @@ static int tegra_output_hdmi_disable(struct tegra_output *output)
 		value &= ~HDMI_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-		tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-		tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+		tegra_dc_commit(dc);
 	}
 
 	clk_disable_unprepare(hdmi->clk);
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index d6af9be48f42..3b851abbccae 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -123,8 +123,7 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
 		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
 	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-	tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+	tegra_dc_commit(rgb->dc);
 
 	rgb->enabled = true;
 
@@ -148,11 +147,10 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
 	value &= ~DISP_CTRL_MODE_MASK;
 	tegra_dc_writel(rgb->dc, value, DC_CMD_DISPLAY_COMMAND);
 
-	tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
-
 	tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
 
+	tegra_dc_commit(rgb->dc);
+
 	rgb->enabled = false;
 
 	return 0;
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 7829e81f065d..6a341822abe9 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -267,8 +267,7 @@ static int tegra_sor_wakeup(struct tegra_sor *sor)
 		 PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
 	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
 
-	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+	tegra_dc_commit(dc);
 
 	timeout = jiffies + msecs_to_jiffies(250);
 
@@ -1080,8 +1079,7 @@ static int tegra_output_sor_disable(struct tegra_output *output)
 		value &= ~SOR_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-		tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-		tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+		tegra_dc_commit(dc);
 	}
 
 	err = tegra_sor_power_down(sor);
-- 
2.1.3

