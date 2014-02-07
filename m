Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaBGNqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:46:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:44760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaBGNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:46:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="479633356"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: vijay.a.purushothaman@intel.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, tomi.valkeinen@ti.com, airlied@redhat.com,
        robdclark@gmail.com, archit@ti.com, gregkh@linuxfoundation.org,
        joe@perches.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>
Subject: [PATCH v4 08/11] drm/i915: Make intel_plane_restore() return an error
Date: Fri,  7 Feb 2014 19:15:13 +0530
Message-Id: <1391780716-21896-9-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
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

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
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

