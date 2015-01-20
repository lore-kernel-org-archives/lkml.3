Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbbATLBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:01:53 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42748 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbbATKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:12 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/36] drm/tegra: dc: Wait for idle when disabled
Date: Tue, 20 Jan 2015 11:48:27 +0100
Message-Id: <1421750935-4023-9-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

When disabling the display controller, stop it and wait for it to become
idle. Doing so ensures that no further accesses to the framebuffer occur
and the buffers can be safely unmapped or freed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 70 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index db7865ab85c7..0c2972e4b41a 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -61,6 +61,26 @@ static void tegra_dc_cursor_commit(struct tegra_dc *dc)
 }
 
 /*
+ * Reads the active copy of a register. This takes the dc->lock spinlock to
+ * prevent races with the VBLANK processing which also needs access to the
+ * active copy of some registers.
+ */
+static u32 tegra_dc_readl_active(struct tegra_dc *dc, unsigned long offset)
+{
+	unsigned long flags;
+	u32 value;
+
+	spin_lock_irqsave(&dc->lock, flags);
+
+	tegra_dc_writel(dc, READ_MUX, DC_CMD_STATE_ACCESS);
+	value = tegra_dc_readl(dc, offset);
+	tegra_dc_writel(dc, 0, DC_CMD_STATE_ACCESS);
+
+	spin_unlock_irqrestore(&dc->lock, flags);
+	return value;
+}
+
+/*
  * Double-buffered registers have two copies: ASSEMBLY and ACTIVE. When the
  * *_ACT_REQ bits are set the ASSEMBLY copy is latched into the ACTIVE copy.
  * Latching happens mmediately if the display controller is in STOP mode or
@@ -942,12 +962,47 @@ static const struct drm_crtc_funcs tegra_crtc_funcs = {
 	.destroy = tegra_dc_destroy,
 };
 
+static void tegra_dc_stop(struct tegra_dc *dc)
+{
+	u32 value;
+
+	/* stop the display controller */
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
+	value &= ~DISP_CTRL_MODE_MASK;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	tegra_dc_commit(dc);
+}
+
+static bool tegra_dc_idle(struct tegra_dc *dc)
+{
+	u32 value;
+
+	value = tegra_dc_readl_active(dc, DC_CMD_DISPLAY_COMMAND);
+
+	return (value & DISP_CTRL_MODE_MASK) == 0;
+}
+
+static int tegra_dc_wait_idle(struct tegra_dc *dc, unsigned long timeout)
+{
+	timeout = jiffies + msecs_to_jiffies(timeout);
+
+	while (time_before(jiffies, timeout)) {
+		if (tegra_dc_idle(dc))
+			return 0;
+
+		usleep_range(1000, 2000);
+	}
+
+	dev_dbg(dc->dev, "timeout waiting for DC to become idle\n");
+	return -ETIMEDOUT;
+}
+
 static void tegra_crtc_disable(struct drm_crtc *crtc)
 {
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct drm_device *drm = crtc->dev;
 	struct drm_plane *plane;
-	u32 value;
 
 	drm_for_each_legacy_plane(plane, &drm->mode_config.plane_list) {
 		if (plane->crtc == crtc) {
@@ -961,10 +1016,15 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 		}
 	}
 
-	/* stop the display controller */
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-	value &= ~DISP_CTRL_MODE_MASK;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+	if (!tegra_dc_idle(dc)) {
+		tegra_dc_stop(dc);
+
+		/*
+		 * Ignore the return value, there isn't anything useful to do
+		 * in case this fails.
+		 */
+		tegra_dc_wait_idle(dc, 100);
+	}
 
 	drm_crtc_vblank_off(crtc);
 	tegra_dc_commit(dc);
-- 
2.1.3

