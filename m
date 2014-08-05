Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaHEOgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:36:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46000 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaHEOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:35:47 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC 2/2] drm/tegra: Request memory bandwidth for the display controller
Date: Tue,  5 Aug 2014 16:35:24 +0200
Message-Id: <1407249324-8568-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407249324-8568-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1407249324-8568-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now the amount requested is based solely on the current mode's refresh
rate.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/gpu/drm/tegra/dc.c  | 11 +++++++++++
 drivers/gpu/drm/tegra/drm.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index ef40381..4bcf09b 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -683,6 +683,8 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
 	}
 
 	drm_vblank_off(drm, dc->pipe);
+
+	pm_qos_update_request(&dc->qos_request, PM_QOS_DEFAULT_VALUE);
 }
 
 static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
@@ -769,6 +771,7 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
 	u32 value;
+	unsigned long bandwidth;
 	int err;
 
 	drm_vblank_pre_modeset(crtc->dev, dc->pipe);
@@ -809,6 +812,9 @@ static int tegra_crtc_mode_set(struct drm_crtc *crtc,
 	if (err < 0)
 		dev_err(dc->dev, "failed to enable root plane\n");
 
+	bandwidth = mode->clock * window.bits_per_pixel / 8;
+	pm_qos_update_request(&dc->qos_request, bandwidth);
+
 	return 0;
 }
 
@@ -1407,6 +1413,9 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pm_qos_add_request(&dc->qos_request, PM_QOS_MEMORY_BANDWIDTH,
+			   PM_QOS_DEFAULT_VALUE);
+
 	platform_set_drvdata(pdev, dc);
 
 	return 0;
@@ -1417,6 +1426,8 @@ static int tegra_dc_remove(struct platform_device *pdev)
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
+	pm_qos_remove_request(&dc->qos_request);
+
 	err = host1x_client_unregister(&dc->client);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 6b8fe9d..6029693 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -116,6 +116,8 @@ struct tegra_dc {
 	struct drm_pending_vblank_event *event;
 
 	const struct tegra_dc_soc_info *soc;
+
+	struct pm_qos_request qos_request;
 };
 
 static inline struct tegra_dc *
-- 
1.9.3

