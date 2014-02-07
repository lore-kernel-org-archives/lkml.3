Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaBGNqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:46:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:34893 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaBGNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:45:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="479633076"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: vijay.a.purushothaman@intel.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, tomi.valkeinen@ti.com, airlied@redhat.com,
        robdclark@gmail.com, archit@ti.com, gregkh@linuxfoundation.org,
        joe@perches.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, ville.syrjala@linux.intel.com
Subject: [PATCH v4 02/11] drm: Add support_bits parameter to drm_property_create_bitmask()
Date: Fri,  7 Feb 2014 19:15:07 +0530
Message-Id: <1391780716-21896-3-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
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

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
---
 drivers/gpu/drm/drm_crtc.c | 6 +++++-
 include/drm/drm_crtc.h     | 3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 3b7d32d..628d3d3 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2906,7 +2906,8 @@ EXPORT_SYMBOL(drm_property_create_enum);
 struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 					 int flags, const char *name,
 					 const struct drm_prop_enum_list *props,
-					 int num_values)
+					 int num_values,
+					 unsigned int supported_bits)
 {
 	struct drm_property *property;
 	int i, ret;
@@ -2918,6 +2919,9 @@ struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 		return NULL;
 
 	for (i = 0; i < num_values; i++) {
+		if (!(supported_bits & (1 << i)))
+			continue;
+
 		ret = drm_property_add_enum(property, i,
 				      props[i].type,
 				      props[i].name);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index d5c46c1..41b86d2 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1070,7 +1070,8 @@ extern struct drm_property *drm_property_create_enum(struct drm_device *dev, int
 struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
 					 int flags, const char *name,
 					 const struct drm_prop_enum_list *props,
-					 int num_values);
+					 int num_values,
+					 unsigned int supported_bits);
 struct drm_property *drm_property_create_range(struct drm_device *dev, int flags,
 					 const char *name,
 					 uint64_t min, uint64_t max);
-- 
1.8.5

