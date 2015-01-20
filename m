Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbbATK6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:58:06 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52914 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbATKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:38 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/36] drm/tegra: Atomic conversion, phase 2
Date: Tue, 20 Jan 2015 11:48:42 +0100
Message-Id: <1421750935-4023-24-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Hook up the default ->reset() and ->atomic_duplicate_state() helpers.
This ensures that state objects are properly created and framebuffer
reference counts correctly maintained.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   | 12 ++++++++++++
 drivers/gpu/drm/tegra/drm.c  |  2 ++
 drivers/gpu/drm/tegra/dsi.c  |  2 ++
 drivers/gpu/drm/tegra/hdmi.c |  2 ++
 drivers/gpu/drm/tegra/rgb.c  |  2 ++
 drivers/gpu/drm/tegra/sor.c  |  2 ++
 6 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index e7efb6ca127c..cb2bd0088295 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -25,6 +25,7 @@
 #include "drm.h"
 #include "gem.h"
 
+#include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 
@@ -406,6 +407,8 @@ static const struct drm_plane_funcs tegra_primary_plane_funcs = {
 	.update_plane = drm_plane_helper_update,
 	.disable_plane = drm_plane_helper_disable,
 	.destroy = tegra_primary_plane_destroy,
+	.reset = drm_atomic_helper_plane_reset,
+	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
 };
 
@@ -690,6 +693,8 @@ static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
 	.update_plane = drm_plane_helper_update,
 	.disable_plane = drm_plane_helper_disable,
 	.destroy = tegra_plane_destroy,
+	.reset = drm_atomic_helper_plane_reset,
+	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
 };
 
@@ -738,6 +743,8 @@ static const struct drm_plane_funcs tegra_overlay_plane_funcs = {
 	.update_plane = drm_plane_helper_update,
 	.disable_plane = drm_plane_helper_disable,
 	.destroy = tegra_overlay_plane_destroy,
+	.reset = drm_atomic_helper_plane_reset,
+	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
 };
 
@@ -990,6 +997,9 @@ static int tegra_dc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		drm_crtc_vblank_get(crtc);
 	}
 
+	if (crtc->primary->state)
+		drm_atomic_set_fb_for_plane(crtc->primary->state, fb);
+
 	tegra_dc_set_base(dc, 0, 0, fb);
 	crtc->primary->fb = fb;
 
@@ -1005,6 +1015,8 @@ static const struct drm_crtc_funcs tegra_crtc_funcs = {
 	.page_flip = tegra_dc_page_flip,
 	.set_config = drm_crtc_helper_set_config,
 	.destroy = tegra_dc_destroy,
+	.reset = drm_atomic_helper_crtc_reset,
+	.atomic_duplicate_state = drm_atomic_helper_crtc_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_crtc_destroy_state,
 };
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 3326df252c52..58a4ed192e61 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -77,6 +77,8 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 	if (err < 0)
 		goto fbdev;
 
+	drm_mode_config_reset(drm);
+
 	/*
 	 * We don't use the drm_irq_install() helpers provided by the DRM
 	 * core, so we need to set this manually in order to allow the
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 4bb06c119a18..9799f3edc3f8 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -734,9 +734,11 @@ static void tegra_dsi_connector_dpms(struct drm_connector *connector, int mode)
 
 static const struct drm_connector_funcs tegra_dsi_connector_funcs = {
 	.dpms = tegra_dsi_connector_dpms,
+	.reset = drm_atomic_helper_connector_reset,
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index bf868d54ef7e..728681a3f8c9 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -779,9 +779,11 @@ static void tegra_hdmi_connector_dpms(struct drm_connector *connector,
 
 static const struct drm_connector_funcs tegra_hdmi_connector_funcs = {
 	.dpms = tegra_hdmi_connector_dpms,
+	.reset = drm_atomic_helper_connector_reset,
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 23ba40370eb2..78e3cb1529d0 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -95,9 +95,11 @@ static void tegra_rgb_connector_dpms(struct drm_connector *connector,
 
 static const struct drm_connector_funcs tegra_rgb_connector_funcs = {
 	.dpms = tegra_rgb_connector_dpms,
+	.reset = drm_atomic_helper_connector_reset,
 	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index e2f399363f09..2793e75c6573 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -735,9 +735,11 @@ tegra_sor_connector_detect(struct drm_connector *connector, bool force)
 
 static const struct drm_connector_funcs tegra_sor_connector_funcs = {
 	.dpms = tegra_sor_connector_dpms,
+	.reset = drm_atomic_helper_connector_reset,
 	.detect = tegra_sor_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = tegra_output_connector_destroy,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-- 
2.1.3

