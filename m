Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaFJTvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaFJTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/160] drm/i915: Don't check gmch state on inherited configs
Date: Tue, 10 Jun 2014 12:45:44 -0700
Message-Id: <1402429600-20477-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9953599bc02dbc1d3330e6a0bfc6c50e9dffcac6 upstream.

... our current modeset code isn't good enough yet to handle this. The
scenario is:

1. BIOS sets up a cloned config with lvds+external screen on the same
pipe, e.g. pipe B.

2. We read out that state for pipe B and assign the gmch_pfit state to
it.

3. The initial modeset switches the lvds to pipe A but due to lack of
atomic modeset we don't recompute the config of pipe B.

-> both pipes now claim (in the sw pipe config structure) to use the
gmch_pfit, which just won't work.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=74081
Tested-by: max <manikulin@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 23 ++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_drv.h     |  3 ++-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 334cf3f..10315b0 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9125,11 +9125,22 @@ intel_pipe_config_compare(struct drm_device *dev,
 	PIPE_CONF_CHECK_I(pipe_src_w);
 	PIPE_CONF_CHECK_I(pipe_src_h);
 
-	PIPE_CONF_CHECK_I(gmch_pfit.control);
-	/* pfit ratios are autocomputed by the hw on gen4+ */
-	if (INTEL_INFO(dev)->gen < 4)
-		PIPE_CONF_CHECK_I(gmch_pfit.pgm_ratios);
-	PIPE_CONF_CHECK_I(gmch_pfit.lvds_border_bits);
+	/*
+	 * FIXME: BIOS likes to set up a cloned config with lvds+external
+	 * screen. Since we don't yet re-compute the pipe config when moving
+	 * just the lvds port away to another pipe the sw tracking won't match.
+	 *
+	 * Proper atomic modesets with recomputed global state will fix this.
+	 * Until then just don't check gmch state for inherited modes.
+	 */
+	if (!PIPE_CONF_QUIRK(PIPE_CONFIG_QUIRK_INHERITED_MODE)) {
+		PIPE_CONF_CHECK_I(gmch_pfit.control);
+		/* pfit ratios are autocomputed by the hw on gen4+ */
+		if (INTEL_INFO(dev)->gen < 4)
+			PIPE_CONF_CHECK_I(gmch_pfit.pgm_ratios);
+		PIPE_CONF_CHECK_I(gmch_pfit.lvds_border_bits);
+	}
+
 	PIPE_CONF_CHECK_I(pch_pfit.enabled);
 	if (current_config->pch_pfit.enabled) {
 		PIPE_CONF_CHECK_I(pch_pfit.pos);
@@ -10919,6 +10930,8 @@ static void intel_modeset_readout_hw_state(struct drm_device *dev)
 			    base.head) {
 		memset(&crtc->config, 0, sizeof(crtc->config));
 
+		crtc->config.quirks |= PIPE_CONFIG_QUIRK_INHERITED_MODE;
+
 		crtc->active = dev_priv->display.get_pipe_config(crtc,
 								 &crtc->config);
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 79f91f2..d6e5653 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -207,7 +207,8 @@ struct intel_crtc_config {
 	 * tracked with quirk flags so that fastboot and state checker can act
 	 * accordingly.
 	 */
-#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS (1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS	(1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_INHERITED_MODE	(1<<1) /* mode inherited from firmware */
 	unsigned long quirks;
 
 	/* User requested mode, only valid as a starting point to
-- 
1.9.1

