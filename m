Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab3CZQRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:17:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab3CZPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/150] atmel_lcdfb: fix 16-bpp modes on older SOCs
Date: Tue, 26 Mar 2013 15:18:51 +0000
Message-Id: <1364311249-14454-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a79eac7165ed62114e6ca197195aa5060a54f137 upstream.

Fix regression introduced by commit 787f9fd23283 ("atmel_lcdfb: support
16bit BGR:565 mode, remove unsupported 15bit modes") which broke 16-bpp
modes for older SOCs which use IBGR:555 (msb is intensity) rather
than BGR:565.

Use SOC-type to determine the pixel layout.

Tested on at91sam9263 and at91sam9g45.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/atmel_lcdfb.c | 22 +++++++++++++++-------
 include/video/atmel_lcdc.h  |  1 +
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index d99505b..78506eb 100644
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
1.8.1.2

