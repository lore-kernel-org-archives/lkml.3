Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBJHcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:32:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:41877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaBJHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:32:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607204"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/11] drm/i915: Make intel_plane_restore() return an error
Date: Mon, 10 Feb 2014 13:01:15 +0530
Message-Id: <1392017478-4945-9-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Propagate the error from intel_update_plane() up through
intel_plane_restore() to the caller. This will be used for
rollback purposes when setting properties fails.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/i915/intel_drv.h    |  2 +-
 drivers/gpu/drm/i915/intel_sprite.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 85864fc..7a79b8e 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -897,7 +897,7 @@ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_sdvob);
 int intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane);
 void intel_flush_primary_plane(struct drm_i915_private *dev_priv,
 			       enum plane plane);
-void intel_plane_restore(struct drm_plane *plane);
+int intel_plane_restore(struct drm_plane *plane);
 void intel_plane_disable(struct drm_plane *plane);
 int intel_sprite_set_colorkey(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv);
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 477d4d7..511934c 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -1047,18 +1047,18 @@ out_unlock:
 	return ret;
 }
 
-void intel_plane_restore(struct drm_plane *plane)
+int intel_plane_restore(struct drm_plane *plane)
 {
 	struct intel_plane *intel_plane = to_intel_plane(plane);
 
 	if (!plane->crtc || !plane->fb)
-		return;
+		return 0;
 
-	intel_update_plane(plane, plane->crtc, plane->fb,
-			   intel_plane->crtc_x, intel_plane->crtc_y,
-			   intel_plane->crtc_w, intel_plane->crtc_h,
-			   intel_plane->src_x, intel_plane->src_y,
-			   intel_plane->src_w, intel_plane->src_h);
+	return intel_update_plane(plane, plane->crtc, plane->fb,
+				  intel_plane->crtc_x, intel_plane->crtc_y,
+				  intel_plane->crtc_w, intel_plane->crtc_h,
+				  intel_plane->src_x, intel_plane->src_y,
+				  intel_plane->src_w, intel_plane->src_h);
 }
 
 void intel_plane_disable(struct drm_plane *plane)
-- 
1.8.5

