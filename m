Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937351Ab3DKAGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:06:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937220Ab3DKAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 13/30] video/s3c: move platform_data out of arch/arm
Date: Thu, 11 Apr 2013 02:04:55 +0200
Message-Id: <1365638712-1028578-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uH1TiuSwrWKSkAmFTK80kUtvfwmNNLB3k4QUuCByTm6
 6EeRJchI7hLr3SZI7a6a/qaniLnzGLZqtLb6kh1Ddy0MrKs2ys
 W5Vsyv+VHQ3cgUzECQrGmiKZNmZkMTUKq9IJxqboUNJ3GLO2y5
 3EXzv/3D3Eihzr1Cz4lVw7TUBhTirtvwEoVi5jfBfU6S76JMjz
 hAj6NFslOKWIgFbloZsxP3BqFGKioTvqohUBUGmx6hMmvGMt5R
 hbn7lToiHjBpcQ1XOk8jsLyfMdOfYNmtIxRWs57lWm16OI/fle
 VjwIzlGMji1dzs0fn4Uf3z3tDiwtGtJHCTELj8xNDfQ45cGUm7
 0McgIOWmusR5qgnpu/EJW7BIQPm0/tTbTNLZkGsmtJNYo1/q6z
 Y02k4EceXmYnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c-fb driver requires header files from the samsung platforms
to find its platform_data definition, but this no longer works on
multiplatform kernels, so let's move the data into a new header
file under include/linux/platform_data.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fbdev@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/plat-samsung/include/plat/fb.h | 50 +-----------------------------
 drivers/video/s3c-fb.c                  |  3 +-
 include/linux/platform_data/video_s3c.h | 54 +++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/platform_data/video_s3c.h

diff --git a/arch/arm/plat-samsung/include/plat/fb.h b/arch/arm/plat-samsung/include/plat/fb.h
index b885322..9ae5072 100644
--- a/arch/arm/plat-samsung/include/plat/fb.h
+++ b/arch/arm/plat-samsung/include/plat/fb.h
@@ -15,55 +15,7 @@
 #ifndef __PLAT_S3C_FB_H
 #define __PLAT_S3C_FB_H __FILE__
 
-/* S3C_FB_MAX_WIN
- * Set to the maximum number of windows that any of the supported hardware
- * can use. Since the platform data uses this for an array size, having it
- * set to the maximum of any version of the hardware can do is safe.
- */
-#define S3C_FB_MAX_WIN	(5)
-
-/**
- * struct s3c_fb_pd_win - per window setup data
- * @xres     : The window X size.
- * @yres     : The window Y size.
- * @virtual_x: The virtual X size.
- * @virtual_y: The virtual Y size.
- */
-struct s3c_fb_pd_win {
-	unsigned short		default_bpp;
-	unsigned short		max_bpp;
-	unsigned short		xres;
-	unsigned short		yres;
-	unsigned short		virtual_x;
-	unsigned short		virtual_y;
-};
-
-/**
- * struct s3c_fb_platdata -  S3C driver platform specific information
- * @setup_gpio: Setup the external GPIO pins to the right state to transfer
- *		the data from the display system to the connected display
- *		device.
- * @vidcon0: The base vidcon0 values to control the panel data format.
- * @vidcon1: The base vidcon1 values to control the panel data output.
- * @vtiming: Video timing when connected to a RGB type panel.
- * @win: The setup data for each hardware window, or NULL for unused.
- * @display_mode: The LCD output display mode.
- *
- * The platform data supplies the video driver with all the information
- * it requires to work with the display(s) attached to the machine. It
- * controls the initial mode, the number of display windows (0 is always
- * the base framebuffer) that are initialised etc.
- *
- */
-struct s3c_fb_platdata {
-	void	(*setup_gpio)(void);
-
-	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
-	struct fb_videomode     *vtiming;
-
-	u32			 vidcon0;
-	u32			 vidcon1;
-};
+#include <linux/platform_data/video_s3c.h>
 
 /**
  * s3c_fb_set_platdata() - Setup the FB device with platform data.
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 968a625..2e7991c 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -24,10 +24,9 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
+#include <linux/platform_data/video_s3c.h>
 
 #include <video/samsung_fimd.h>
-#include <mach/map.h>
-#include <plat/fb.h>
 
 /* This driver will export a number of framebuffer interfaces depending
  * on the configuration passed in via the platform data. Each fb instance
diff --git a/include/linux/platform_data/video_s3c.h b/include/linux/platform_data/video_s3c.h
new file mode 100644
index 0000000..fa40f96
--- /dev/null
+++ b/include/linux/platform_data/video_s3c.h
@@ -0,0 +1,54 @@
+#ifndef __PLATFORM_DATA_VIDEO_S3C
+#define __PLATFORM_DATA_VIDEO_S3C
+
+/* S3C_FB_MAX_WIN
+ * Set to the maximum number of windows that any of the supported hardware
+ * can use. Since the platform data uses this for an array size, having it
+ * set to the maximum of any version of the hardware can do is safe.
+ */
+#define S3C_FB_MAX_WIN	(5)
+
+/**
+ * struct s3c_fb_pd_win - per window setup data
+ * @xres     : The window X size.
+ * @yres     : The window Y size.
+ * @virtual_x: The virtual X size.
+ * @virtual_y: The virtual Y size.
+ */
+struct s3c_fb_pd_win {
+	unsigned short		default_bpp;
+	unsigned short		max_bpp;
+	unsigned short		xres;
+	unsigned short		yres;
+	unsigned short		virtual_x;
+	unsigned short		virtual_y;
+};
+
+/**
+ * struct s3c_fb_platdata -  S3C driver platform specific information
+ * @setup_gpio: Setup the external GPIO pins to the right state to transfer
+ *		the data from the display system to the connected display
+ *		device.
+ * @vidcon0: The base vidcon0 values to control the panel data format.
+ * @vidcon1: The base vidcon1 values to control the panel data output.
+ * @vtiming: Video timing when connected to a RGB type panel.
+ * @win: The setup data for each hardware window, or NULL for unused.
+ * @display_mode: The LCD output display mode.
+ *
+ * The platform data supplies the video driver with all the information
+ * it requires to work with the display(s) attached to the machine. It
+ * controls the initial mode, the number of display windows (0 is always
+ * the base framebuffer) that are initialised etc.
+ *
+ */
+struct s3c_fb_platdata {
+	void	(*setup_gpio)(void);
+
+	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
+	struct fb_videomode     *vtiming;
+
+	u32			 vidcon0;
+	u32			 vidcon1;
+};
+ 
+#endif
-- 
1.8.1.2

