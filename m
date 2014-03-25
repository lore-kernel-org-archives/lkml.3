Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaCYObj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 10:31:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:22358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaCYObd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 10:31:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,728,1389772800"; 
   d="scan'208";a="507164593"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Sagar Kamble <sagar.a.kamble@intel.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] drm: Added plane alpha and color blending property
Date: Tue, 25 Mar 2014 20:02:25 +0530
Message-Id: <1395757947-16492-2-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1395757947-16492-1-git-send-email-sagar.a.kamble@intel.com>
References: <20140320135151.GO6912@strange.amr.corp.intel.com>
 <1395757947-16492-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

This patch creates a generic blending bitmask property modeled after
glBlendFunc. Drivers may support subset of these values.

v2: Removing blend properties that are not applicable
    [Damien's Review Comments].
    Adding DRM_MODE_PROP_32BIT_PAIR flag to blend property.

Cc: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/drm_crtc.c | 27 +++++++++++++++++++++++++++
 include/drm/drm_crtc.h     | 19 +++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index d0d03ec..a1f254e 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -4157,3 +4157,30 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	idr_destroy(&dev->mode_config.crtc_idr);
 }
 EXPORT_SYMBOL(drm_mode_config_cleanup);
+
+struct drm_property *drm_mode_create_blend_property(struct drm_device *dev,
+				unsigned int supported_factors)
+{
+	static const struct drm_prop_enum_list props[] = {
+		{ DRM_BLEND_ZERO,  			"zero" },
+		{ DRM_BLEND_ONE, 			"one" },
+		{ DRM_BLEND_SRC_COLOR, 			"src-color" },
+		{ DRM_BLEND_ONE_MINUS_SRC_COLOR,  	"one-minus-src-color" },
+		{ DRM_BLEND_DST_COLOR, 			"dst-color" },
+		{ DRM_BLEND_ONE_MINUS_DST_COLOR,  	"one-minus-dst-color" },
+		{ DRM_BLEND_SRC_ALPHA, 			"src-alpha" },
+		{ DRM_BLEND_ONE_MINUS_SRC_ALPHA, 	"one-minus-src-alpha" },
+		{ DRM_BLEND_DST_ALPHA, 			"dst-alpha" },
+		{ DRM_BLEND_ONE_MINUS_DST_ALPHA, 	"one-minus-dst-alpha" },
+		{ DRM_BLEND_CONSTANT_COLOR, 		"constant-color" },
+		{ DRM_BLEND_ONE_MINUS_CONSTANT_COLOR, 	"one-minus-constant-color" },
+		{ DRM_BLEND_CONSTANT_ALPHA, 		"constant-alpha" },
+		{ DRM_BLEND_ONE_MINUS_CONSTANT_ALPHA, 	"one-minus-constant-alpha" },
+		{ DRM_BLEND_SRC_ALPHA_SATURATE, 	"alpha-saturate" }
+	};
+
+	return drm_property_create_bitmask(dev, DRM_MODE_PROP_32BIT_PAIR, "blend",
+					   props, ARRAY_SIZE(props),
+					   supported_factors);
+}
+EXPORT_SYMBOL(drm_mode_create_blend_property);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 784a568..a9fbfec 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -65,6 +65,23 @@ struct drm_object_properties {
 	uint64_t values[DRM_OBJECT_MAX_PROPERTY];
 };
 
+/* Blending property bits */
+#define DRM_BLEND_ZERO				0
+#define DRM_BLEND_ONE				1
+#define DRM_BLEND_SRC_COLOR			2
+#define DRM_BLEND_ONE_MINUS_SRC_COLOR		3
+#define DRM_BLEND_DST_COLOR			4
+#define DRM_BLEND_ONE_MINUS_DST_COLOR		5
+#define DRM_BLEND_SRC_ALPHA			6
+#define DRM_BLEND_ONE_MINUS_SRC_ALPHA		7
+#define DRM_BLEND_DST_ALPHA			8
+#define DRM_BLEND_ONE_MINUS_DST_ALPHA		9
+#define DRM_BLEND_CONSTANT_COLOR		10
+#define DRM_BLEND_ONE_MINUS_CONSTANT_COLOR	11
+#define DRM_BLEND_CONSTANT_ALPHA		12
+#define DRM_BLEND_ONE_MINUS_CONSTANT_ALPHA	13
+#define DRM_BLEND_SRC_ALPHA_SATURATE		14
+
 /*
  * Note on terminology:  here, for brevity and convenience, we refer to connector
  * control chips as 'CRTCs'.  They can control any type of connector, VGA, LVDS,
@@ -1179,6 +1196,8 @@ extern int drm_format_plane_cpp(uint32_t format, int plane);
 extern int drm_format_horz_chroma_subsampling(uint32_t format);
 extern int drm_format_vert_chroma_subsampling(uint32_t format);
 extern const char *drm_get_format_name(uint32_t format);
+extern struct drm_property *drm_mode_create_blend_property(struct drm_device *dev,
+				unsigned int supported_factors);
 
 /* Helpers */
 static inline struct drm_crtc *drm_crtc_find(struct drm_device *dev,
-- 
1.8.5

