Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaFIIy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:54:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58482 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504AbaFIIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/146] drm/i915: Don't check gmch state on inherited configs
Date: Mon,  9 Jun 2014 10:49:36 +0200
Message-Id: <45087225dbb035f7507270f3f07eea0bfc777af2.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_display.c | 23 ++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_drv.h     |  3 ++-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5aa836e6e190..48a4faf5e63a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8688,11 +8688,22 @@ intel_pipe_config_compare(struct drm_device *dev,
 	PIPE_CONF_CHECK_I(requested_mode.hdisplay);
 	PIPE_CONF_CHECK_I(requested_mode.vdisplay);
 
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
@@ -10443,6 +10454,8 @@ static void intel_modeset_readout_hw_state(struct drm_device *dev)
 			    base.head) {
 		memset(&crtc->config, 0, sizeof(crtc->config));
 
+		crtc->config.quirks |= PIPE_CONFIG_QUIRK_INHERITED_MODE;
+
 		crtc->active = dev_priv->display.get_pipe_config(crtc,
 								 &crtc->config);
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 7f2b384ac939..569c0c5ca450 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -204,7 +204,8 @@ struct intel_crtc_config {
 	 * tracked with quirk flags so that fastboot and state checker can act
 	 * accordingly.
 	 */
-#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS (1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_MODE_SYNC_FLAGS	(1<<0) /* unreliable sync mode.flags */
+#define PIPE_CONFIG_QUIRK_INHERITED_MODE	(1<<1) /* mode inherited from firmware */
 	unsigned long quirks;
 
 	struct drm_display_mode requested_mode;
-- 
1.9.3

