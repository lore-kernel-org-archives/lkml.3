Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaHZNN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:13:29 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40248 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbaHZNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:12:54 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v4 2/3] drm/tegra: Request memory bandwidth for the display controller
Date: Tue, 26 Aug 2014 15:12:07 +0200
Message-Id: <1409058728-13347-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now the amount requested is based solely on the current mode's refresh
rate.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Acked-by: Pavel Machek <pavel@ucw.cz>

---

v4: * Use vertical refresh rate when calculating the bandwidth requirement

v3: * Fixed the bandwidth calculation, and have the units be mbps
---
 drivers/gpu/drm/tegra/dc.c  | 15 +++++++++++++++
 drivers/gpu/drm/tegra/drm.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 6553fd2..8a3fee8 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -9,6 +9,7 @@
 
 #include <linux/clk.h>
 #include <linux/debugfs.h>
+#include <linux/pm_qos.h>
 #include <linux/reset.h>
 
 #include "dc.h"
@@ -753,6 +754,8 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 	}
 
 	drm_vblank_off(drm, dc->pipe);
+
+	pm_qos_update_request(&dc->qos_request, PM_QOS_DEFAULT_VALUE);
 }
 
 static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@ -839,6 +842,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
 	u32 value;
+	unsigned long bandwidth;
 	int err;
 
 	drm_vblank_pre_modeset(crtc->dev, dc->pipe);
@@ -879,6 +883,12 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	if (err < 0)
 		dev_err(dc->dev, "failed to enable root plane\n");
 
+	bandwidth = window.stride[0] * window.dst.h * 8;
+	bandwidth *= drm_mode_vrefresh(mode);
+	bandwidth /= 1024 * 1024;
+
+	pm_qos_update_request(&dc->qos_request, bandwidth);
+
 	return 0;
 }
 
@@ -1499,6 +1509,9 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pm_qos_add_request(&dc->qos_request, PM_QOS_MEMORY_BANDWIDTH,
+			   PM_QOS_DEFAULT_VALUE);
+
 	platform_set_drvdata(pdev, dc);
 
 	return 0;
@@ -1509,6 +1522,8 @@ static int tegra_dc_remove(struct platform_device *pdev)
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
+	pm_qos_remove_request(&dc->qos_request);
+
 	err = host1x_client_unregister(&dc->client);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index e89c70f..a99e533d 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -12,6 +12,7 @@
 
 #include <uapi/drm/tegra_drm.h>
 #include <linux/host1x.h>
+#include <linux/pm_qos.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -120,6 +121,8 @@ struct tegra_dc {
 	struct drm_pending_vblank_event *event;
 
 	const struct tegra_dc_soc_info *soc;
+
+	struct pm_qos_request qos_request;
 };
 
 static inline struct tegra_dc *
-- 
1.9.3

