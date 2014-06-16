Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaFPNgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:36:07 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54025 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaFPNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:36:01 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC PATCH 3/4] drm/tegra: Request memory bandwidth for the display controller
Date: Mon, 16 Jun 2014 15:35:12 +0200
Message-Id: <1402925713-25426-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request it based solely on the current mode's refresh rate. More
accurate requirements can be requested in future patches.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/gpu/drm/tegra/dc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index ef40381..6739d69 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -10,6 +10,7 @@
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/reset.h>
+#include <linux/platform_data/tegra_emc.h>
 
 #include "dc.h"
 #include "drm.h"
@@ -683,6 +684,8 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 	}
 
 	drm_vblank_off(drm, dc->pipe);
+
+	tegra124_emc_reserve_bandwidth(TEGRA_EMC_CONSUMER_DISP1, 0);
 }
 
 static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@ -769,6 +772,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
 	u32 value;
+	unsigned long bandwidth;
 	int err;
 
 	drm_vblank_pre_modeset(crtc->dev, dc->pipe);
@@ -809,6 +813,11 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	if (err < 0)
 		dev_err(dc->dev, "failed to enable root plane\n");
 
+	bandwidth = mode->clock * window.bits_per_pixel / 8;
+	err = tegra124_emc_reserve_bandwidth(TEGRA_EMC_CONSUMER_DISP1, bandwidth);
+	if (err)
+		dev_err(dc->dev, "failed to reserve EMC bandwidth: %d\n", err);
+
 	return 0;
 }
 
-- 
1.9.3

