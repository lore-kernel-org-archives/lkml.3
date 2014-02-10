Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaBJHb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:31:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:24280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaBJHbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607154"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: ville.syrjala@linux.intel.com, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Sagar Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH v5 03/11] drm: Add drm_mode_create_rotation_property()
Date: Mon, 10 Feb 2014 13:01:10 +0530
Message-Id: <1392017478-4945-4-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala at linux.intel.com>

Add a function to create a standards compliant rotation property.

v4: For creating rotation bitmask property send number of values
as only number of set rotations

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/drm_crtc.c | 33 +++++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 628d3d3..e7bbbad 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -4118,3 +4118,36 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	idr_destroy(&dev->mode_config.crtc_idr);
 }
 EXPORT_SYMBOL(drm_mode_config_cleanup);
+
+/*
+* Function to get number of bits set in bitmask
+* using Brian Kernighan's Algorithm
+*/
+unsigned int bits_set(unsigned int n)
+{
+	unsigned int count = 0;
+
+	while (n) {
+		n &= (n-1);
+		count ++;
+	}
+	return count;
+}
+
+struct drm_property *drm_mode_create_rotation_property(struct drm_device *dev,
+						       unsigned int supported_rotations)
+{
+	static const struct drm_prop_enum_list props[] = {
+		{ DRM_ROTATE_0,   "rotate-0" },
+		{ DRM_ROTATE_90,  "rotate-90" },
+		{ DRM_ROTATE_180, "rotate-180" },
+		{ DRM_ROTATE_270, "rotate-270" },
+		{ DRM_REFLECT_X,  "reflect-x" },
+		{ DRM_REFLECT_Y,  "reflect-y" },
+	};
+
+	return drm_property_create_bitmask(dev, 0, "rotation",
+					   props, bits_set(supported_rotations),
+					   supported_rotations);
+}
+EXPORT_SYMBOL(drm_mode_create_rotation_property);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 41b86d2..4b3ac70 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1183,6 +1183,8 @@ extern int drm_format_plane_cpp(uint32_t format, int plane);
 extern int drm_format_horz_chroma_subsampling(uint32_t format);
 extern int drm_format_vert_chroma_subsampling(uint32_t format);
 extern const char *drm_get_format_name(uint32_t format);
+extern struct drm_property *drm_mode_create_rotation_property(struct drm_device *dev,
+							      unsigned int supported_rotations);
 
 /* Helpers */
 static inline struct drm_crtc *drm_crtc_find(struct drm_device *dev,
-- 
1.8.5

