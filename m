Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab3BHQfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:35:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35752 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218Ab3BHQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:35:38 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, <stable@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/5] atmel_lcdfb: fix 16-bpp modes on older SOCs
Date: Fri, 8 Feb 2013 17:35:14 +0100
Message-ID: <7543f557bed835c79f6981989e96034a326bb48f.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Fix regression introduced by commit 787f9fd23283 ("atmel_lcdfb: support
16bit BGR:565 mode, remove unsupported 15bit modes") which broke 16-bpp
modes for older SOCs which use IBGR:555 (msb is intensity) rather
than BGR:565.

Use SOC-type to determine the pixel layout.

Tested on at91sam9263 and at91sam9g45.

Cc: <stable@vger.kernel.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/atmel_lcdfb.c | 22 +++++++++++++++-------
 include/video/atmel_lcdc.h  |  1 +
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 12cf5f3..025428e 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -422,17 +422,22 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 			= var->bits_per_pixel;
 		break;
 	case 16:
+		/* Older SOCs use IBGR:555 rather than BGR:565. */
+		if (sinfo->have_intensity_bit)
+			var->green.length = 5;
+		else
+			var->green.length = 6;
+
 		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
-			/* RGB:565 mode */
-			var->red.offset = 11;
+			/* RGB:5X5 mode */
+			var->red.offset = var->green.length + 5;
 			var->blue.offset = 0;
 		} else {
-			/* BGR:565 mode */
+			/* BGR:5X5 mode */
 			var->red.offset = 0;
-			var->blue.offset = 11;
+			var->blue.offset = var->green.length + 5;
 		}
 		var->green.offset = 5;
-		var->green.length = 6;
 		var->red.length = var->blue.length = 5;
 		break;
 	case 32:
@@ -679,8 +684,7 @@ static int atmel_lcdfb_setcolreg(unsigned int regno, unsigned int red,
 
 	case FB_VISUAL_PSEUDOCOLOR:
 		if (regno < 256) {
-			if (cpu_is_at91sam9261() || cpu_is_at91sam9263()
-			    || cpu_is_at91sam9rl()) {
+			if (sinfo->have_intensity_bit) {
 				/* old style I+BGR:555 */
 				val  = ((red   >> 11) & 0x001f);
 				val |= ((green >>  6) & 0x03e0);
@@ -870,6 +874,10 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	}
 	sinfo->info = info;
 	sinfo->pdev = pdev;
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9263() ||
+							cpu_is_at91sam9rl()) {
+		sinfo->have_intensity_bit = true;
+	}
 
 	strcpy(info->fix.id, sinfo->pdev->name);
 	info->flags = ATMEL_LCDFB_FBINFO_DEFAULT;
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 28447f1..5f0e234 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -62,6 +62,7 @@ struct atmel_lcdfb_info {
 	void (*atmel_lcdfb_power_control)(int on);
 	struct fb_monspecs	*default_monspecs;
 	u32			pseudo_palette[16];
+	bool			have_intensity_bit;
 };
 
 #define ATMEL_LCDC_DMABADDR1	0x00
-- 
1.8.0

