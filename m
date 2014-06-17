Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967275AbaFQWLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:11:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966848AbaFQVvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert N <crshman@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 125/212] drm/i915: Increase WM memory latency values on SNB
Date: Tue, 17 Jun 2014 14:43:39 -0700
Message-Id: <1403041506-13646-126-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit e95a2f7509f5219177d6821a0a8754f93892ca56 upstream.

On SNB the BIOS provided WM memory latency values seem insufficient to
handle high resolution displays.

In this particular case the display mode was a 2560x1440@60Hz, which
makes the pixel clock 241.5 MHz. It was empirically found that a memory
latency value if 1.2 usec is enough to avoid underruns, whereas the BIOS
provided value of 0.7 usec was clearly too low. Incidentally 1.2 usec
is what the typical BIOS provided values are on IVB systems.

Increase the WM memory latency values to at least 1.2 usec on SNB.
Hopefully this won't have a significant effect on power consumption.

v2: Increase the latency values regardless of the pixel clock

Cc: Robert N <crshman@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70254
Tested-by: Robert Navarro <crshman@gmail.com>
Tested-by: Vitaly Minko <vitaly.minko@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index e2d10ce..4128d0e 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2563,6 +2563,43 @@ static void intel_print_wm_latency(struct drm_device *dev,
 	}
 }
 
+static bool ilk_increase_wm_latency(struct drm_i915_private *dev_priv,
+				    uint16_t wm[5], uint16_t min)
+{
+	int level, max_level = ilk_wm_max_level(dev_priv->dev);
+
+	if (wm[0] >= min)
+		return false;
+
+	wm[0] = max(wm[0], min);
+	for (level = 1; level <= max_level; level++)
+		wm[level] = max_t(uint16_t, wm[level], DIV_ROUND_UP(min, 5));
+
+	return true;
+}
+
+static void snb_wm_latency_quirk(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	bool changed;
+
+	/*
+	 * The BIOS provided WM memory latency values are often
+	 * inadequate for high resolution displays. Adjust them.
+	 */
+	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12) |
+		ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12) |
+		ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
+
+	if (!changed)
+		return;
+
+	DRM_DEBUG_KMS("WM latency values increased to avoid potential underruns\n");
+	intel_print_wm_latency(dev, "Primary", dev_priv->wm.pri_latency);
+	intel_print_wm_latency(dev, "Sprite", dev_priv->wm.spr_latency);
+	intel_print_wm_latency(dev, "Cursor", dev_priv->wm.cur_latency);
+}
+
 static void intel_setup_wm_latency(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -2580,6 +2617,9 @@ static void intel_setup_wm_latency(struct drm_device *dev)
 	intel_print_wm_latency(dev, "Primary", dev_priv->wm.pri_latency);
 	intel_print_wm_latency(dev, "Sprite", dev_priv->wm.spr_latency);
 	intel_print_wm_latency(dev, "Cursor", dev_priv->wm.cur_latency);
+
+	if (IS_GEN6(dev))
+		snb_wm_latency_quirk(dev);
 }
 
 static void hsw_compute_wm_parameters(struct drm_crtc *crtc,
-- 
1.9.1

