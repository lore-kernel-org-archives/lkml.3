Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBJHdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:33:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:51443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaBJHbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:31:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607178"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/11] drm: Add drm_rotation_simplify()
Date: Mon, 10 Feb 2014 13:01:13 +0530
Message-Id: <1392017478-4945-7-git-send-email-sagar.a.kamble@intel.com>
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

drm_rotation_simplify() can be used to eliminate unsupported rotation
flags. It will check if any unsupported flags are present, and if so
it will modify the rotation to an alternate form by adding 180 degrees
to rotation angle, and flipping the reflect x and y bits. The hope is
that this identity transform will eliminate the unsupported flags.

Of course that might not result in any more supported rotation, so
the caller is still responsible for checking the result afterwards.

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/drm_crtc.c | 30 ++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e7bbbad..30e0008 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -4006,6 +4006,36 @@ int drm_format_vert_chroma_subsampling(uint32_t format)
 EXPORT_SYMBOL(drm_format_vert_chroma_subsampling);
 
 /**
+ * drm_rotation_simplify() - Try to simplify the rotation
+ * @rotation: Rotation to be simplified
+ * @supported_rotations: Supported rotations
+ *
+ * Attempt to simplify the rotation to a form that is supported.
+ * Eg. if the hardware supports everything except DRM_REFLECT_X
+ * one could call this function like this:
+ *
+ * drm_rotation_simplify(rotation, BIT(DRM_ROTATE_0) |
+ *                       BIT(DRM_ROTATE_90) | BIT(DRM_ROTATE_180) |
+ *                       BIT(DRM_ROTATE_270) | BIT(DRM_REFLECT_Y));
+ *
+ * to eliminate the DRM_ROTATE_X flag. Depending on what kind of
+ * transforms the hardware supports, this function may not
+ * be able to produce a supported transform, so the caller should
+ * check the result afterwards.
+ */
+unsigned int drm_rotation_simplify(unsigned int rotation,
+				   unsigned int supported_rotations)
+{
+	if (rotation & ~supported_rotations) {
+		rotation ^= BIT(DRM_REFLECT_X) | BIT(DRM_REFLECT_Y);
+		rotation = (rotation & ~0xf) | BIT((ffs(rotation & 0xf) + 1) % 4);
+	}
+
+	return rotation;
+}
+EXPORT_SYMBOL(drm_rotation_simplify);
+
+/**
  * drm_mode_config_init - initialize DRM mode_configuration structure
  * @dev: DRM device
  *
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 4b3ac70..18f2eed 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1185,6 +1185,8 @@ extern int drm_format_vert_chroma_subsampling(uint32_t format);
 extern const char *drm_get_format_name(uint32_t format);
 extern struct drm_property *drm_mode_create_rotation_property(struct drm_device *dev,
 							      unsigned int supported_rotations);
+extern unsigned int drm_rotation_simplify(unsigned int rotation,
+					  unsigned int supported_rotations);
 
 /* Helpers */
 static inline struct drm_crtc *drm_crtc_find(struct drm_device *dev,
-- 
1.8.5

