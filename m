Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3HBXkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:40:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HBXkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:40:00 -0400
Date: Fri, 2 Aug 2013 16:39:47 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-5ef76da644bf346d29200007d8d3779e7009dabb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        swarren@nvidia.com, tglx@linutronix.de, hpa@linux.intel.com,
        dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, swarren@nvidia.com, dh.herrmann@gmail.com,
        hpa@linux.intel.com
In-Reply-To: <1375445127-15480-2-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-2-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: simplefb: add init through platform_data
Git-Commit-ID: 5ef76da644bf346d29200007d8d3779e7009dabb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:39:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ef76da644bf346d29200007d8d3779e7009dabb
Gitweb:     http://git.kernel.org/tip/5ef76da644bf346d29200007d8d3779e7009dabb
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:20 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:44 -0700

fbdev: simplefb: add init through platform_data

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
Link: http://lkml.kernel.org/r/1375445127-15480-2-git-send-email-dh.herrmann@gmail.com
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/video/Kconfig                  |  5 ++-
 drivers/video/simplefb.c               | 48 +++++++++++++++++++++--------
 include/linux/platform_data/simplefb.h | 56 ++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 16 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4cf1e1d..34c3d96 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2457,7 +2457,7 @@ config FB_HYPERV
 
 config FB_SIMPLE
 	bool "Simple framebuffer support"
-	depends on (FB = y) && OF
+	depends on (FB = y)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -2469,8 +2469,7 @@ config FB_SIMPLE
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
