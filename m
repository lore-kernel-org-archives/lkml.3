Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbbATKtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38644 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbATKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:29 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/36] drm/tegra: output: Make ->setup_clock() optional
Date: Tue, 20 Jan 2015 11:48:31 +0100
Message-Id: <1421750935-4023-13-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

In order to transition output drivers to using the struct tegra_output
as a helper rather than midlayer, make this callback optional. Instead
drivers should implement the equivalent as part of ->mode_fixup(). For
the conversion to atomic modesetting a new callback ->atomic_check()
should be implemented that updates the display controller's state with
the corresponding parent clock, rate and shift clock divider.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  | 10 +++++++++-
 drivers/gpu/drm/tegra/drm.h | 10 ----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 9cee6465b753..46fde25863a2 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1074,10 +1074,18 @@ static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
 		return -ENODEV;
 
 	/*
+	 * The ->setup_clock() callback is optional, but if encoders don't
+	 * implement it they most likely need to do the equivalent within the
+	 * ->mode_fixup() callback.
+	 */
+	if (!output->ops || !output->ops->setup_clock)
+		return 0;
+
+	/*
 	 * This assumes that the parent clock is pll_d_out0 or pll_d2_out
 	 * respectively, each of which divides the base pll_d by 2.
 	 */
-	err = tegra_output_setup_clock(output, dc->clk, pclk, &div);
+	err = output->ops->setup_clock(output, dc->clk, pclk, &div);
 	if (err < 0) {
 		dev_err(dc->dev, "failed to setup clock: %ld\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index bf749ac4a344..d7433976a40b 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -240,16 +240,6 @@ static inline int tegra_output_disable(struct tegra_output *output)
 	return output ? -ENOSYS : -EINVAL;
 }
 
-static inline int tegra_output_setup_clock(struct tegra_output *output,
-					   struct clk *clk, unsigned long pclk,
-					   unsigned int *div)
-{
-	if (output && output->ops && output->ops->setup_clock)
-		return output->ops->setup_clock(output, clk, pclk, div);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
 static inline int tegra_output_check_mode(struct tegra_output *output,
 					  struct drm_display_mode *mode,
 					  enum drm_mode_status *status)
-- 
2.1.3

