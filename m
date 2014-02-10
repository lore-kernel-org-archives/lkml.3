Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBJHcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:32:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:51443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaBJHbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:31:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="452607171"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/11] drm: Add drm_rect rotation functions
Date: Mon, 10 Feb 2014 13:01:12 +0530
Message-Id: <1392017478-4945-6-git-send-email-sagar.a.kamble@intel.com>
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

Add some helper functions to move drm_rects between different rotated
coordinate spaces. One function does the forward transform and
another does the inverse.

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/drm_rect.c | 140 +++++++++++++++++++++++++++++++++++++++++++++
 include/drm/drm_rect.h     |   6 ++
 2 files changed, 146 insertions(+)

diff --git a/drivers/gpu/drm/drm_rect.c b/drivers/gpu/drm/drm_rect.c
index 7047ca0..631f5af 100644
--- a/drivers/gpu/drm/drm_rect.c
+++ b/drivers/gpu/drm/drm_rect.c
@@ -293,3 +293,143 @@ void drm_rect_debug_print(const struct drm_rect *r, bool fixed_point)
 		DRM_DEBUG_KMS("%dx%d%+d%+d\n", w, h, r->x1, r->y1);
 }
 EXPORT_SYMBOL(drm_rect_debug_print);
+
+/**
+ * drm_rect_rotate - Rotate the rectangle
+ * @r: rectangle to be rotated
+ * @width: Width of the coordinate space
+ * @height: Height of the coordinate space
+ * @rotation: Transformation to be applied
+ *
+ * Apply @rotation to the coordinates of rectangle @r.
+ *
+ * @width and @height combined with @rotation define
+ * the location of the new origin.
+ *
+ * @width correcsponds to the horizontal and @height
+ * to the vertical axis of the untransformed coordinate
+ * space.
+ */
+void drm_rect_rotate(struct drm_rect *r,
+		     int width, int height,
+		     unsigned int rotation)
+{
+	struct drm_rect tmp;
+
+	if (rotation & (BIT(DRM_REFLECT_X) | BIT(DRM_REFLECT_Y))) {
+		tmp = *r;
+
+		if (rotation & BIT(DRM_REFLECT_X)) {
+			r->x1 = width - tmp.x2;
+			r->x2 = width - tmp.x1;
+		}
+
+		if (rotation & BIT(DRM_REFLECT_Y)) {
+			r->y1 = height - tmp.y2;
+			r->y2 = height - tmp.y1;
+		}
+	}
+
+	switch (rotation & 0xf) {
+	case BIT(DRM_ROTATE_0):
+		break;
+	case BIT(DRM_ROTATE_90):
+		tmp = *r;
+		r->x1 = tmp.y1;
+		r->x2 = tmp.y2;
+		r->y1 = width - tmp.x2;
+		r->y2 = width - tmp.x1;
+		break;
+	case BIT(DRM_ROTATE_180):
+		tmp = *r;
+		r->x1 = width - tmp.x2;
+		r->x2 = width - tmp.x1;
+		r->y1 = height - tmp.y2;
+		r->y2 = height - tmp.y1;
+		break;
+	case BIT(DRM_ROTATE_270):
+		tmp = *r;
+		r->x1 = height - tmp.y2;
+		r->x2 = height - tmp.y1;
+		r->y1 = tmp.x1;
+		r->y2 = tmp.x2;
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL(drm_rect_rotate);
+
+/**
+ * drm_rect_rotate_inv - Inverse rotate the rectangle
+ * @r: rectangle to be rotated
+ * @width: Width of the coordinate space
+ * @height: Height of the coordinate space
+ * @rotation: Transformation whose inverse is to be applied
+ *
+ * Apply the inverse of @rotation to the coordinates
+ * of rectangle @r.
+ *
+ * @width and @height combined with @rotation define
+ * the location of the new origin.
+ *
+ * @width correcsponds to the horizontal and @height
+ * to the vertical axis of the original untransformed
+ * coordinate space, so that you never have to flip
+ * them when doing a rotatation and its inverse.
+ * That is, if you do:
+ *
+ * drm_rotate(&r, width, height, rotation);
+ * drm_rotate_inv(&r, width, height, rotation);
+ *
+ * you will always get back the original rectangle.
+ */
+void drm_rect_rotate_inv(struct drm_rect *r,
+			 int width, int height,
+			 unsigned int rotation)
+{
+	struct drm_rect tmp;
+
+	switch (rotation & 0xf) {
+	case BIT(DRM_ROTATE_0):
+		break;
+	case BIT(DRM_ROTATE_90):
+		tmp = *r;
+		r->x1 = width - tmp.y2;
+		r->x2 = width - tmp.y1;
+		r->y1 = tmp.x1;
+		r->y2 = tmp.x2;
+		break;
+	case BIT(DRM_ROTATE_180):
+		tmp = *r;
+		r->x1 = width - tmp.x2;
+		r->x2 = width - tmp.x1;
+		r->y1 = height - tmp.y2;
+		r->y2 = height - tmp.y1;
+		break;
+	case BIT(DRM_ROTATE_270):
+		tmp = *r;
+		r->x1 = tmp.y1;
+		r->x2 = tmp.y2;
+		r->y1 = height - tmp.x2;
+		r->y2 = height - tmp.x1;
+		break;
+	default:
+		break;
+	}
+
+	if (rotation & (BIT(DRM_REFLECT_X) | BIT(DRM_REFLECT_Y))) {
+		tmp = *r;
+
+		if (rotation & BIT(DRM_REFLECT_X)) {
+			r->x1 = width - tmp.x2;
+			r->x2 = width - tmp.x1;
+		}
+
+		if (rotation & BIT(DRM_REFLECT_Y)) {
+			r->y1 = height - tmp.y2;
+			r->y2 = height - tmp.y1;
+		}
+	}
+}
+EXPORT_SYMBOL(drm_rect_rotate_inv);
diff --git a/include/drm/drm_rect.h b/include/drm/drm_rect.h
index d128629..26bb55e 100644
--- a/include/drm/drm_rect.h
+++ b/include/drm/drm_rect.h
@@ -163,5 +163,11 @@ int drm_rect_calc_vscale_relaxed(struct drm_rect *src,
 				 struct drm_rect *dst,
 				 int min_vscale, int max_vscale);
 void drm_rect_debug_print(const struct drm_rect *r, bool fixed_point);
+void drm_rect_rotate(struct drm_rect *r,
+		     int width, int height,
+		     unsigned int rotation);
+void drm_rect_rotate_inv(struct drm_rect *r,
+			 int width, int height,
+			 unsigned int rotation);
 
 #endif
-- 
1.8.5

