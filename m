Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbbATKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:26 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:36230 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbATKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:21 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/36] drm/tegra: Add tegra_dc_setup_clock() helper
Date: Tue, 20 Jan 2015 11:48:32 +0100
Message-Id: <1421750935-4023-14-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This is a small helper that performs the basic steps required by all
output drivers to prepare the display controller for use with a given
encoder.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 20 ++++++++++++++++++++
 drivers/gpu/drm/tegra/drm.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 46fde25863a2..39e1b3b38536 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1099,6 +1099,26 @@ static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
 	return 0;
 }
 
+int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
+			 unsigned long pclk, unsigned int div)
+{
+	u32 value;
+	int err;
+
+	err = clk_set_parent(dc->clk, parent);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to set parent clock: %d\n", err);
+		return err;
+	}
+
+	DRM_DEBUG_KMS("rate: %lu, div: %u\n", clk_get_rate(dc->clk), div);
+
+	value = SHIFT_CLK_DIVIDER(div) | PIXEL_CLK_DIVIDER_PCD1;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
+
+	return 0;
+}
+
 static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 			       struct drm_display_mode *mode,
 			       struct drm_display_mode *adjusted,
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index d7433976a40b..e1374ec2b76e 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -178,6 +178,8 @@ void tegra_dc_enable_vblank(struct tegra_dc *dc);
 void tegra_dc_disable_vblank(struct tegra_dc *dc);
 void tegra_dc_cancel_page_flip(struct drm_crtc *crtc, struct drm_file *file);
 void tegra_dc_commit(struct tegra_dc *dc);
+int tegra_dc_setup_clock(struct tegra_dc *dc, struct clk *parent,
+			 unsigned long pclk, unsigned int div);
 
 struct tegra_output_ops {
 	int (*enable)(struct tegra_output *output);
-- 
2.1.3

