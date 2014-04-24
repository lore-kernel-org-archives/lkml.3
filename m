Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaDXM3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:29:32 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51252 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbaDXM3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:29:05 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 04/13] video/omap: fix modular build
Date: Thu, 24 Apr 2014 13:28:20 +0100
Message-Id: <1398342509-10243-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The framebuffer layer can be a loadable module, which forces
omapfb to be a module as well. However, this breaks the lcd
drivers, which are linked into the omapfb driver but each
have their own module_init() function. To solve this,
we split out the lcd drivers into separate modules and
export omapfb_register_panel, which is the only interface
required between the main omapfb driver and the lcd panel
drivers.

We also have to introduce a new Kconfig symbol for H3, since
that lcd driver has a dependency on TPS65010, which we can
express better in Kconfig than Makefile syntax.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-omap@vger.kernel.org
---
 drivers/video/fbdev/omap/Kconfig       |    9 +++++++++
 drivers/video/fbdev/omap/Makefile      |   23 ++++++++++++-----------
 drivers/video/fbdev/omap/omapfb_main.c |    1 +
 include/linux/omap-dma.h               |    2 +-
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbdev/omap/Kconfig b/drivers/video/fbdev/omap/Kconfig
index 0bc3a93..18c4cb0 100644
--- a/drivers/video/fbdev/omap/Kconfig
+++ b/drivers/video/fbdev/omap/Kconfig
@@ -39,6 +39,15 @@ config FB_OMAP_LCD_MIPID
 	  the Mobile Industry Processor Interface DBI-C/DCS
 	  specification. (Supported LCDs: Philips LPH8923, Sharp LS041Y3)
 
+config FB_OMAP_LCD_H3
+	bool "TPS65010 LCD controller on OMAP-H3"
+	depends on MACH_OMAP_H3
+	depends on TPS65010
+	default y
+	help
+	  Say Y here if you want to have support for the LCD on the
+	  H3 board.
+
 config FB_OMAP_DMA_TUNE
         bool "Set DMA SDRAM access priority high"
         depends on FB_OMAP
diff --git a/drivers/video/fbdev/omap/Makefile b/drivers/video/fbdev/omap/Makefile
index 1927faf..732e071 100644
--- a/drivers/video/fbdev/omap/Makefile
+++ b/drivers/video/fbdev/omap/Makefile
@@ -10,17 +10,18 @@ objs-y$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += sossi.o
 
 objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
 
-objs-y$(CONFIG_MACH_AMS_DELTA) += lcd_ams_delta.o
-objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
-objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
-objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
-objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
-objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
-objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
-objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
-
-objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
-objs-y$(CONFIG_MACH_HERALD) += lcd_htcherald.o
+lcds-y$(CONFIG_MACH_AMS_DELTA) += lcd_ams_delta.o
+lcds-y$(CONFIG_FB_OMAP_LCD_H3) += lcd_h3.o
+lcds-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
+lcds-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
+lcds-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
+lcds-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
+lcds-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
+lcds-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
+
+lcds-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
+lcds-y$(CONFIG_MACH_HERALD) += lcd_htcherald.o
 
 omapfb-objs := $(objs-yy)
 
+obj-$(CONFIG_FB_OMAP) += $(lcds-yy)
diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index e4fc6d9..d8d028d 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1823,6 +1823,7 @@ void omapfb_register_panel(struct lcd_panel *panel)
 	if (fbdev_pdev != NULL)
 		omapfb_do_probe(fbdev_pdev, fbdev_panel);
 }
+EXPORT_SYMBOL_GPL(omapfb_register_panel);
 
 /* Called when the device is being detached from the driver */
 static int omapfb_remove(struct platform_device *pdev)
diff --git a/include/linux/omap-dma.h b/include/linux/omap-dma.h
index 41a13e7..0a1a2e2 100644
--- a/include/linux/omap-dma.h
+++ b/include/linux/omap-dma.h
@@ -393,7 +393,7 @@ extern int omap_modify_dma_chain_params(int chain_id,
 extern int omap_dma_chain_status(int chain_id);
 #endif
 
-#if defined(CONFIG_ARCH_OMAP1) && defined(CONFIG_FB_OMAP)
+#if defined(CONFIG_ARCH_OMAP1) && IS_ENABLED(CONFIG_FB_OMAP)
 #include <mach/lcd_dma.h>
 #else
 static inline int omap_lcd_dma_running(void)
-- 
1.7.9.5

