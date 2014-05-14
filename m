Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaENNVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:21:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbaENNVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:21:51 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Cedric Le Goater <clg@fr.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] offb: Fix little-endian support
Date: Wed, 14 May 2014 15:21:49 +0200
Message-Id: <1400073709-15012-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the color palette was corrected for little endian by the
commit  [e1edf18b: offb: Add palette hack for little endian], the
graphics mode is still shown in psychedelic colors.  For fixing this
properly, we rather need to correct the RGB offsets depending on
endianess.

Since the RGB base offsets are corrected, we don't need the hack for
pallette color entries.  This patch reverts that, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/video/fbdev/offb.c | 51 +++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index 7d44d669d5b6..0224a62aa49d 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -93,13 +93,6 @@ extern boot_infos_t *boot_infos;
 
 #define FB_RIGHT_POS(p, bpp)         (fb_be_math(p) ? 0 : (32 - (bpp)))
 
-static inline u32 offb_cmap_byteswap(struct fb_info *info, u32 value)
-{
-	u32 bpp = info->var.bits_per_pixel;
-
-	return cpu_to_be32(value) >> FB_RIGHT_POS(info, bpp);
-}
-
     /*
      *  Set a single color register. The values supplied are already
      *  rounded down to the hardware's capabilities (according to the
@@ -129,7 +122,7 @@ static int offb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 			mask <<= info->var.transp.offset;
 			value |= mask;
 		}
-		pal[regno] = offb_cmap_byteswap(info, value);
+		pal[regno] = value;
 		return 0;
 	}
 
@@ -451,6 +444,8 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 	else
 		fix->visual = FB_VISUAL_TRUECOLOR;
 
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE | foreign_endian;
+
 	var->xoffset = var->yoffset = 0;
 	switch (depth) {
 	case 8:
@@ -466,35 +461,54 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 		break;
 	case 15:		/* RGB 555 */
 		var->bits_per_pixel = 16;
-		var->red.offset = 10;
+		if (fb_be_math(info)) {
+			var->red.offset = 10;
+			var->green.offset = 5;
+			var->blue.offset = 0;
+		} else {
+			var->red.offset = 0;
+			var->green.offset = 5;
+			var->blue.offset = 10;
+		}
 		var->red.length = 5;
-		var->green.offset = 5;
 		var->green.length = 5;
-		var->blue.offset = 0;
 		var->blue.length = 5;
 		var->transp.offset = 0;
 		var->transp.length = 0;
 		break;
 	case 16:		/* RGB 565 */
 		var->bits_per_pixel = 16;
-		var->red.offset = 11;
+		if (fb_be_math(info)) {
+			var->red.offset = 11;
+			var->green.offset = 5;
+			var->blue.offset = 0;
+		} else {
+			var->red.offset = 0;
+			var->green.offset = 5;
+			var->blue.offset = 11;
+		}
 		var->red.length = 5;
-		var->green.offset = 5;
 		var->green.length = 6;
-		var->blue.offset = 0;
 		var->blue.length = 5;
 		var->transp.offset = 0;
 		var->transp.length = 0;
 		break;
 	case 32:		/* RGB 888 */
 		var->bits_per_pixel = 32;
-		var->red.offset = 16;
+		if (fb_be_math(info)) {
+			var->red.offset = 16;
+			var->green.offset = 8;
+			var->blue.offset = 0;
+			var->transp.offset = 24;
+		} else {
+			var->red.offset = 8;
+			var->green.offset = 16;
+			var->blue.offset = 24;
+			var->transp.offset = 0;
+		}
 		var->red.length = 8;
-		var->green.offset = 8;
 		var->green.length = 8;
-		var->blue.offset = 0;
 		var->blue.length = 8;
-		var->transp.offset = 24;
 		var->transp.length = 8;
 		break;
 	}
@@ -521,7 +535,6 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 	info->fbops = &offb_ops;
 	info->screen_base = ioremap(address, fix->smem_len);
 	info->pseudo_palette = (void *) (info + 1);
-	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE | foreign_endian;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
-- 
1.9.2

