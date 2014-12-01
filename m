Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaLAVYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:24:36 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55648 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932389AbaLAVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:23:56 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 1/3] drm: add bus_formats and num_bus_formats fields to drm_display_info
Date: Mon,  1 Dec 2014 22:23:49 +0100
Message-Id: <1417469031-22202-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417469031-22202-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417469031-22202-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bus_formats and num_bus_formats fields and
drm_display_info_set_bus_formats helper function to specify the bus
formats supported by a given display.

This information can be used by display controller drivers to configure
the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
RGB or LVDS busses).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/drm/drm_crtc.c | 35 +++++++++++++++++++++++++++++++++++
 include/drm/drm_crtc.h     |  8 ++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e79c8d3..1295863 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -764,6 +764,40 @@ static void drm_mode_remove(struct drm_connector *connector,
 }
 
 /**
+ * drm_display_info_set_bus_formats - set the supported bus formats
+ * @info: display info to store bus formats in
+ * @fmts: array containing the supported bus formats
+ * @nfmts: the number of entries in the fmts array
+ *
+ * Store the supported bus formats in display info structure.
+ * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
+ * a full list of available formats.
+ */
+int drm_display_info_set_bus_formats(struct drm_display_info *info,
+				     const u32 *formats,
+				     unsigned int num_formats)
+{
+	u32 *fmts = NULL;
+
+	if (!formats && num_formats)
+		return -EINVAL;
+
+	if (formats && num_formats) {
+		fmts = kmemdup(formats, sizeof(*formats) * num_formats,
+			       GFP_KERNEL);
+		if (!formats)
+			return -ENOMEM;
+	}
+
+	kfree(info->bus_formats);
+	info->bus_formats = fmts;
+	info->num_bus_formats = num_formats;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_display_info_set_bus_formats);
+
+/**
  * drm_connector_get_cmdline_mode - reads the user's cmdline mode
  * @connector: connector to quwery
  * @mode: returned mode
@@ -914,6 +948,7 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	ida_remove(&drm_connector_enum_list[connector->connector_type].ida,
 		   connector->connector_type_id);
 
+	kfree(connector->display_info.bus_formats);
 	drm_mode_object_put(dev, &connector->base);
 	kfree(connector->name);
 	connector->name = NULL;
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index c40070a..5d351f5 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fb.h>
 #include <linux/hdmi.h>
+#include <linux/media-bus-format.h>
 #include <uapi/drm/drm_mode.h>
 #include <uapi/drm/drm_fourcc.h>
 #include <drm/drm_modeset_lock.h>
@@ -130,6 +131,9 @@ struct drm_display_info {
 	enum subpixel_order subpixel_order;
 	u32 color_formats;
 
+	const u32 *bus_formats;
+	unsigned int num_bus_formats;
+
 	/* Mask of supported hdmi deep color modes */
 	u8 edid_hdmi_dc_modes;
 
@@ -982,6 +986,10 @@ extern int drm_mode_connector_set_path_property(struct drm_connector *connector,
 extern int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 						struct edid *edid);
 
+extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
+					    const u32 *formats,
+					    unsigned int num_formats);
+
 static inline bool drm_property_type_is(struct drm_property *property,
 		uint32_t type)
 {
-- 
1.9.1

