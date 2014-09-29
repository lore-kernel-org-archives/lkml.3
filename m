Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaI2OE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:04:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426AbaI2ODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:03:51 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 3/5] drm: add bus_formats and nbus_formats fields to drm_display_info
Date: Mon, 29 Sep 2014 16:02:41 +0200
Message-Id: <1411999363-28770-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Add bus_formats and nbus_formats fields and
drm_display_info_set_bus_formats helper function to specify the bus
formats supported by a given display.

This information can be used by display controller drivers to configure
the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
RGB or LVDS busses).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/drm_crtc.c | 31 +++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     |  8 ++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 90e7730..c31420f 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -852,6 +852,37 @@ static void drm_mode_remove(struct drm_connector *connector,
 	drm_mode_destroy(connector->dev, mode);
 }
 
+/*
+ * drm_display_info_set_bus_formats - set the supported bus formats
+ * @info: display info to store bus formats in
+ * @fmts: array containing the supported bus formats
+ * @nfmts: the number of entries in the fmts array
+ *
+ * Store the suppported bus formats in display info structure.
+ */
+int drm_display_info_set_bus_formats(struct drm_display_info *info,
+				     const enum video_bus_format *fmts,
+				     unsigned int num_fmts)
+{
+	enum video_bus_format *formats = NULL;
+
+	if (!fmts && num_fmts)
+		return -EINVAL;
+
+	if (fmts && num_fmts) {
+		formats = kmemdup(fmts, sizeof(*fmts) * num_fmts, GFP_KERNEL);
+		if (!formats)
+			return -ENOMEM;
+	}
+
+	kfree(info->bus_formats);
+	info->bus_formats = formats;
+	info->num_bus_formats = num_fmts;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_display_info_set_bus_formats);
+
 /**
  * drm_connector_init - Init a preallocated connector
  * @dev: DRM device
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index f1105d0..488f779 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fb.h>
 #include <linux/hdmi.h>
+#include <linux/video-bus-format.h>
 #include <drm/drm_mode.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_modeset_lock.h>
@@ -130,6 +131,9 @@ struct drm_display_info {
 	enum subpixel_order subpixel_order;
 	u32 color_formats;
 
+	const enum video_bus_format *bus_formats;
+	int num_bus_formats;
+
 	/* Mask of supported hdmi deep color modes */
 	u8 edid_hdmi_dc_modes;
 
@@ -975,6 +979,10 @@ extern int drm_mode_connector_set_path_property(struct drm_connector *connector,
 extern int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 						struct edid *edid);
 
+extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
+					    const enum video_bus_format *fmts,
+					    unsigned int nfmts);
+
 static inline bool drm_property_type_is(struct drm_property *property,
 		uint32_t type)
 {
-- 
1.9.1

