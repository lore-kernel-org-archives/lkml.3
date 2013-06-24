Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3FXW2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:28:14 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63187 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3FXW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:28:12 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        linux-fbdev@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC 1/6] fbdev: simplefb: add init through platform_data
Date: Tue, 25 Jun 2013 00:27:24 +0200
Message-Id: <1372112849-670-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we create proper platform-devices in x86 boot-code, we can use simplefb
for VBE or EFI framebuffers, too. However, there is normally no OF support
so we introduce a platform_data object so x86 boot-code can pass the
paramaters via plain old platform-data.

This also removes the OF dependency as it is not needed. The headers
provide proper dummies for the case OF is disabled.

Furthermore, we move the FORMAT-definitions to the common platform header
so initialization code can use it to transform "struct screen_info" to
the right format-name.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/Kconfig                  |  5 ++--
 drivers/video/simplefb.c               | 45 +++++++++++++++++++++++++---------
 include/linux/platform_data/simplefb.h | 40 ++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 14 deletions(-)
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
index e2e9e3e..35e36c5 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -24,6 +24,7 @@
 #include <linux/fb.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 
 static struct fb_fix_screeninfo simplefb_fix = {
@@ -73,17 +74,8 @@ static struct fb_ops simplefb_ops = {
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
 static struct simplefb_format simplefb_formats[] = {
-	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
+	SIMPLEFB_FORMATS
 };
 
 struct simplefb_params {
@@ -139,6 +131,32 @@ static int simplefb_parse_dt(struct platform_device *pdev,
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
@@ -149,7 +167,12 @@ static int simplefb_probe(struct platform_device *pdev)
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
index 0000000..a18353d
--- /dev/null
+++ b/include/linux/platform_data/simplefb.h
@@ -0,0 +1,40 @@
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
+#define SIMPLEFB_FORMATS \
+	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0}, DRM_FORMAT_RGB565 }
+
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
+/* the framebuffer size and location is available as IORESOURCE_MEM */
+struct simplefb_platform_data {
+	u32 width;
+	u32 height;
+	u32 stride;
+	char format[64];
+};
+
+#endif /* __PLATFORM_DATA_SIMPLEFB_H__ */
-- 
1.8.3.1

