Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121Ab3DBSUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:20:40 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:61523 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602Ab3DBSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:34 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 1/6] video: vt8500: Make wmt_ge_rops optional
Date: Wed,  3 Apr 2013 07:20:33 +1300
Message-Id: <1364926838-6721-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wmt_ge_rops is a seperate driver to vt8500/wm8505 framebuffer
driver but is currently a required option. This patch makes
accelerated raster ops optional.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Reviewed-by: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
---
 drivers/video/Kconfig       |   22 ++++++++++++----------
 drivers/video/wmt_ge_rops.h |   23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+), 10 deletions(-)

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
diff --git a/drivers/video/wmt_ge_rops.h b/drivers/video/wmt_ge_rops.h
index 8738075..f73ec63 100644
--- a/drivers/video/wmt_ge_rops.h
+++ b/drivers/video/wmt_ge_rops.h
@@ -1,5 +1,28 @@
+#ifdef CONFIG_FB_WMT_GE_ROPS
+
 extern void wmt_ge_fillrect(struct fb_info *info,
 			    const struct fb_fillrect *rect);
 extern void wmt_ge_copyarea(struct fb_info *info,
 			    const struct fb_copyarea *area);
 extern int wmt_ge_sync(struct fb_info *info);
+
+#else
+
+static inline int wmt_ge_sync(struct fb_info *p)
+{
+	return 0;
+}
+
+static inline void wmt_ge_fillrect(struct fb_info *p,
+				    const struct fb_fillrect *rect)
+{
+	sys_fillrect(p, rect);
+}
+
+static inline void wmt_ge_copyarea(struct fb_info *p,
+				     const struct fb_copyarea *area)
+{
+	sys_copyarea(p, area);
+}
+
+#endif
-- 
1.7.9.5

