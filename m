Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3C0Iqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:46:50 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:55905 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3C0Iqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:43 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, florianschandinat@gmx.de,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/6] video: vt8500: Make wmt_ge_rops optional
Date: Wed, 27 Mar 2013 21:46:56 +1300
Message-Id: <1364374021-10844-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
References: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wmt_ge_rops is a seperate driver to vt8500/wm8505 framebuffer
driver but is currently a required option. This patch makes
accelerated raster ops optional.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/Kconfig       |   22 ++++++++++++----------
 drivers/video/vt8500lcdfb.c |   15 +++++++++++++++
 drivers/video/wm8505fb.c    |   15 +++++++++++++++
 3 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..661aa54 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -212,14 +212,6 @@ config FB_SYS_FOPS
        depends on FB
        default n
 
-config FB_WMT_GE_ROPS
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include functions for accelerated rectangle filling and area
-	  copying using WonderMedia Graphics Engine operations.
-
 config FB_DEFERRED_IO
 	bool
 	depends on FB
@@ -1799,7 +1791,8 @@ config FB_AU1200
 config FB_VT8500
 	bool "VT8500 LCD Driver"
 	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_WMT_GE_ROPS
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
 	help
 	  This is the framebuffer driver for VIA VT8500 integrated LCD
@@ -1808,12 +1801,21 @@ config FB_VT8500
 config FB_WM8505
 	bool "WM8505 frame buffer support"
 	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_WMT_GE_ROPS
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
 	help
 	  This is the framebuffer driver for WonderMedia WM8505/WM8650
 	  integrated LCD controller.
 
+config FB_WMT_GE_ROPS
+	bool "VT8500/WM85xx accelerated raster ops support"
+	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
+	default n
+	help
+	  This adds support for accelerated raster operations on the
+	  VIA VT8500 and Wondermedia 85xx series SoCs.
+
 source "drivers/video/geode/Kconfig"
 
 config FB_HIT
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index aa2579c..d8cc1f6 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -33,7 +33,10 @@
 #include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "vt8500lcdfb.h"
+
+#ifdef CONFIG_FB_WMT_GE_ROPS
 #include "wmt_ge_rops.h"
+#endif
 
 #ifdef CONFIG_OF
 #include <linux/of.h>
@@ -249,12 +252,24 @@ static int vt8500lcd_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+#ifndef CONFIG_FB_WMT_GE_ROPS
+static int wmt_ge_sync(struct fb_info *p)
+{
+	return 0;
+}
+#endif
+
 static struct fb_ops vt8500lcd_ops = {
 	.owner		= THIS_MODULE,
 	.fb_set_par	= vt8500lcd_set_par,
 	.fb_setcolreg	= vt8500lcd_setcolreg,
+#ifdef CONFIG_FB_WMT_GE_ROPS
 	.fb_fillrect	= wmt_ge_fillrect,
 	.fb_copyarea	= wmt_ge_copyarea,
+#else
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+#endif
 	.fb_imageblit	= sys_imageblit,
 	.fb_sync	= wmt_ge_sync,
 	.fb_ioctl	= vt8500lcd_ioctl,
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 4dd0580..db49803 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -35,7 +35,10 @@
 #include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "wm8505fb_regs.h"
+
+#ifdef CONFIG_FB_WMT_GE_ROPS
 #include "wmt_ge_rops.h"
+#endif
 
 #define DRIVER_NAME "wm8505-fb"
 
@@ -248,12 +251,24 @@ static int wm8505fb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+#ifndef CONFIG_FB_WMT_GE_ROPS
+static int wmt_ge_sync(struct fb_info *p)
+{
+	return 0;
+}
+#endif
+
 static struct fb_ops wm8505fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_set_par	= wm8505fb_set_par,
 	.fb_setcolreg	= wm8505fb_setcolreg,
+#ifdef CONFIG_FB_WMT_GE_ROPS
 	.fb_fillrect	= wmt_ge_fillrect,
 	.fb_copyarea	= wmt_ge_copyarea,
+#else
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+#endif
 	.fb_imageblit	= sys_imageblit,
 	.fb_sync	= wmt_ge_sync,
 	.fb_pan_display	= wm8505fb_pan_display,
-- 
1.7.9.5

