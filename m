Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaBJOGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:06:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:50526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:06:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="480918029"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Sagar Kamble <sagar.a.kamble@intel.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2 02/11] drm: Add support_bits parameter to drm_property_create_bitmask()
Date: Mon, 10 Feb 2014 16:05:45 +0200
Message-Id: <1392041145-5691-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140210134311.GL3891@intel.com>
References: <20140210134311.GL3891@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala at linux.intel.com>

Make drm_property_create_bitmask() a bit more generic by allowing the
caller to specify which bits are in fact supported. This allows multiple
callers to use the same enum list, but still create different versions
of the same property with different list of supported bits.

v2: Populate values[] array as non-sparse
    Make supported_bits 64bit
    Fix up omapdrm call site (Rob)

Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Sagar Kamble <sagar.a.kamble@intel.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
This should also make my original "drm: Add drm_mode_create_rotation_property()"
patch do the right thing. So patch 03/11 of the series needs to be replaced with the
original.

 drivers/gpu/drm/drm_crtc.c           | 18 ++++++++++++++----
 drivers/gpu/drm/omapdrm/omap_plane.c |  5 ++++-
 include/drm/drm_crtc.h               |  3 ++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 3b7d32d..6e099069 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2906,10 +2906,12 @@ EXPORT_SYMBOL(drm_property_create_enum);
 struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 					 int flags, const char *name,
 					 const struct drm_prop_enum_list *props,
-					 int num_values)
+					 int num_props,
+					 uint64_t supported_bits)
 {
 	struct drm_property *property;
-	int i, ret;
+	int i, ret, index = 0;
+	int num_values = hweight64(supported_bits);
 
 	flags |= DRM_MODE_PROP_BITMASK;
 
@@ -2917,8 +2919,16 @@ struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 	if (!property)
 		return NULL;
 
-	for (i = 0; i < num_values; i++) {
-		ret = drm_property_add_enum(property, i,
+	for (i = 0; i < num_props; i++) {
+		if (!(supported_bits & (1ULL << props[i].type)))
+			continue;
+
+		if (WARN_ON(index >= num_values)) {
+			drm_property_destroy(dev, property);
+			return NULL;
+		}
+
+		ret = drm_property_add_enum(property, index++,
 				      props[i].type,
 				      props[i].name);
 		if (ret) {
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 046d5e6..0d97650 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -309,7 +309,10 @@ void omap_plane_install_properties(struct drm_plane *plane,
 					{ DRM_REFLECT_Y,  "reflect-y" },
 			};
 			prop = drm_property_create_bitmask(dev, 0, "rotation",
-					props, ARRAY_SIZE(props));
+					props, ARRAY_SIZE(props),
+					BIT(DRM_ROTATE_0) | BIT(DRM_ROTATE_90) |
+					BIT(DRM_ROTATE_180) | BIT(DRM_ROTATE_270) |
+					BIT(DRM_REFLECT_X) | BIT(DRM_REFLECT_Y));
 			if (prop == NULL)
 				return;
 			priv->rotation_prop = prop;
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index d5c46c1..4e6d2aa 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1070,7 +1070,8 @@ extern struct drm_property *drm_property_create_enum(struct drm_device *dev, int
 struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 					 int flags, const char *name,
 					 const struct drm_prop_enum_list *props,
-					 int num_values);
+					 int num_props,
+					 uint64_t supported_bits);
 struct drm_property *drm_property_create_range(struct drm_device *dev, int flags,
 					 const char *name,
 					 uint64_t min, uint64_t max);
-- 
1.8.3.2

