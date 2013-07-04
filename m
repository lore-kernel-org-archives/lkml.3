Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3GDM1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:11 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56450 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3GDM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:27 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH v2 01/14] fbdev: simplefb: add init through platform_data
Date: Thu,  4 Jul 2013 14:25:01 +0200
Message-Id: <1372940714-12470-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we create proper platform-devices in x86 boot-code, we can use simplefb
for VBE or EFI framebuffers, too. However, there is normally no OF support
so we introduce a platform_data object so x86 boot-code can pass the
parameters via plain old platform-data.

This also removes the OF dependency as it is not needed. The headers
provide proper dummies for the case OF is disabled.

Furthermore, we move the FORMAT-definitions to the common platform header
so initialization code can use it to transform "struct screen_info" to
the right format-name.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/Kconfig                  |  5 ++-
 drivers/video/simplefb.c               | 48 +++++++++++++++++++++--------
 include/linux/platform_data/simplefb.h | 56 ++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/platform_data/simplefb.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2e937bd..22586ee 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2455,7 +2455,7 @@ config FB_HYPERV
 
 config FB_SIMPLE
 	bool "Simple framebuffer support"
-	depends on (FB = y) && OF
+	depends on (FB = y)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -2467,8 +2467,7 @@ config FB_SIMPLE
 	  pre-allocated frame buffer surface.
 
 	  Configuration re: surface address, size, and format must be provided
-	  through device tree, or potentially plain old platform data in the
-	  future.
+	  through device tree, or plain old platform data.
 
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index e2e9e3e..5886989 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -24,6 +24,7 @@
 #include <linux/fb.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 
 static struct fb_fix_screeninfo simplefb_fix = {
@@ -73,18 +74,7 @@ static struct fb_ops simplefb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-struct simplefb_format {
-	const char *name;
-	u32 bits_per_pixel;
-	struct fb_bitfield red;
-	struct fb_bitfield green;
-	struct fb_bitfield blue;
-	struct fb_bitfield transp;
-};
-
-static struct simplefb_format simplefb_formats[] = {
-	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
-};
+static struct simplefb_format simplefb_formats[] = SIMPLEFB_FORMATS;
 
 struct simplefb_params {
 	u32 width;
@@ -139,6 +129,33 @@ static int simplefb_parse_dt(struct platform_device *pdev,
 	return 0;
 }
 
+static int simplefb_parse_pd(struct platform_device *pdev,
+			     struct simplefb_params *params)
+{
+	struct simplefb_platform_data *pd = pdev->dev.platform_data;
+	int i;
+
+	params->width = pd->width;
+	params->height = pd->height;
+	params->stride = pd->stride;
+
+	params->format = NULL;
+	for (i = 0; i < ARRAY_SIZE(simplefb_formats); i++) {
+		if (strcmp(pd->format, simplefb_formats[i].name))
+			continue;
+
+		params->format = &simplefb_formats[i];
+		break;
+	}
+
+	if (!params->format) {
+		dev_err(&pdev->dev, "Invalid format value\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int simplefb_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -149,7 +166,12 @@ static int simplefb_probe(struct platform_device *pdev)
 	if (fb_get_options("simplefb", NULL))
 		return -ENODEV;
 
-	ret = simplefb_parse_dt(pdev, &params);
+	ret = -ENODEV;
+	if (pdev->dev.platform_data)
+		ret = simplefb_parse_pd(pdev, &params);
+	else if (pdev->dev.of_node)
+		ret = simplefb_parse_dt(pdev, &params);
+
 	if (ret)
 		return ret;
 
diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
new file mode 100644
index 0000000..5fa2c5e
--- /dev/null
+++ b/include/linux/platform_data/simplefb.h
@@ -0,0 +1,56 @@
+/*
+ * simplefb.h - Simple Framebuffer Device
+ *
+ * Copyright (C) 2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PLATFORM_DATA_SIMPLEFB_H__
+#define __PLATFORM_DATA_SIMPLEFB_H__
+
+#include <drm/drm_fourcc.h>
+#include <linux/fb.h>
+#include <linux/kernel.h>
+
+/* format array, use it to initialize a "struct simplefb_format" array */
+#define SIMPLEFB_FORMATS \
+{ \
+	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0}, DRM_FORMAT_RGB565 }, \
+}
+
+/*
+ * Data-Format for Simple-Framebuffers
+ * @name: unique 0-terminated name that can be used to identify the mode
+ * @red,green,blue: Offsets and sizes of the single RGB parts
+ * @transp: Offset and size of the alpha bits. length=0 means no alpha
+ * @fourcc: 32bit DRM four-CC code (see drm_fourcc.h)
+ */
+struct simplefb_format {
+	const char *name;
+	u32 bits_per_pixel;
+	struct fb_bitfield red;
+	struct fb_bitfield green;
+	struct fb_bitfield blue;
+	struct fb_bitfield transp;
+	u32 fourcc;
+};
+
+/*
+ * Simple-Framebuffer description
+ * If the arch-boot code creates simple-framebuffers without DT support, it
+ * can pass the width, height, stride and format via this platform-data object.
+ * The framebuffer location must be given as IORESOURCE_MEM resource.
+ * @format must be a format as described in "struct simplefb_format" above.
+ */
+struct simplefb_platform_data {
+	u32 width;
+	u32 height;
+	u32 stride;
+	const char *format;
+};
+
+#endif /* __PLATFORM_DATA_SIMPLEFB_H__ */
-- 
1.8.3.2

