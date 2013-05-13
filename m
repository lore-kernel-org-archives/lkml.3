Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3EMX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:59:23 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:54276 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3EMX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:59:18 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 7/9] uvesafb: Clean up MTRR code
Date: Mon, 13 May 2013 16:58:46 -0700
Message-Id: <d3b3c5ea13e5b2d38af340b02a844b055cb61e2c.1368485053.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code allowed very strange memory types.  Now it works like
all the other video drivers: ioremap_wc is used unconditionally,
and MTRRs are set if PAT is unavailable (unless MTRR is disabled
by a module parameter).

UC, WB, and WT support is gone.  If there are MTRR conflicts that prevent
addition of a WC MTRR, adding a non-conflicting MTRR is pointless; it's
better to just turn off MTRR support entirely.

As an added bonus, any MTRR added is freed on unload.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/fb/uvesafb.txt | 16 ++++------
 drivers/video/uvesafb.c      | 70 +++++++++++---------------------------------
 include/video/uvesafb.h      |  1 +
 3 files changed, 23 insertions(+), 64 deletions(-)

diff --git a/Documentation/fb/uvesafb.txt b/Documentation/fb/uvesafb.txt
index eefdd91..f6362d8 100644
--- a/Documentation/fb/uvesafb.txt
+++ b/Documentation/fb/uvesafb.txt
@@ -81,17 +81,11 @@ pmipal  Use the protected mode interface for palette changes.
 
 mtrr:n  Setup memory type range registers for the framebuffer
         where n:
-              0 - disabled (equivalent to nomtrr) (default)
-              1 - uncachable
-              2 - write-back
-              3 - write-combining
-              4 - write-through
-
-        If you see the following in dmesg, choose the type that matches
-        the old one.  In this example, use "mtrr:2".
-...
-mtrr: type mismatch for e0000000,8000000 old: write-back new: write-combining
-...
+              0 - disabled (equivalent to nomtrr)
+              3 - write-combining (default)
+
+	Values other than 0 and 3 will result in a warning and will be
+	treated just like 3.
 
 nomtrr  Do not use memory type range registers.
 
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index d428445..8701f96 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -24,9 +24,6 @@
 #ifdef CONFIG_X86
 #include <video/vga.h>
 #endif
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
-#endif
 #include "edid.h"
 
 static struct cb_id uvesafb_cn_id = {
@@ -1540,67 +1537,30 @@ static void uvesafb_init_info(struct fb_info *info, struct vbe_mode_ib *mode)
 
 static void uvesafb_init_mtrr(struct fb_info *info)
 {
-#ifdef CONFIG_MTRR
+	struct uvesafb_par *par = info->par;
+
 	if (mtrr && !(info->fix.smem_start & (PAGE_SIZE - 1))) {
 		int temp_size = info->fix.smem_len;
-		unsigned int type = 0;
 
-		switch (mtrr) {
-		case 1:
-			type = MTRR_TYPE_UNCACHABLE;
-			break;
-		case 2:
-			type = MTRR_TYPE_WRBACK;
-			break;
-		case 3:
-			type = MTRR_TYPE_WRCOMB;
-			break;
-		case 4:
-			type = MTRR_TYPE_WRTHROUGH;
-			break;
-		default:
-			type = 0;
-			break;
-		}
+		int rc;
 
-		if (type) {
-			int rc;
+		/* Find the largest power-of-two */
+		temp_size = roundup_pow_of_two(temp_size);
 
-			/* Find the largest power-of-two */
-			temp_size = roundup_pow_of_two(temp_size);
+		/* Try and find a power of two to add */
+		do {
+			rc = arch_phys_wc_add(info->fix.smem_start, temp_size);
+			temp_size >>= 1;
+		} while (temp_size >= PAGE_SIZE && rc == -EINVAL);
 
-			/* Try and find a power of two to add */
-			do {
-				rc = mtrr_add(info->fix.smem_start,
-					      temp_size, type, 1);
-				temp_size >>= 1;
-			} while (temp_size >= PAGE_SIZE && rc == -EINVAL);
-		}
+		if (rc >= 0)
+			par->mtrr_handle = rc;
 	}
-#endif /* CONFIG_MTRR */
 }
 
 static void uvesafb_ioremap(struct fb_info *info)
 {
-#ifdef CONFIG_X86
-	switch (mtrr) {
-	case 1: /* uncachable */
-		info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
-		break;
-	case 2: /* write-back */
-		info->screen_base = ioremap_cache(info->fix.smem_start, info->fix.smem_len);
-		break;
-	case 3: /* write-combining */
-		info->screen_base = ioremap_wc(info->fix.smem_start, info->fix.smem_len);
-		break;
-	case 4: /* write-through */
-	default:
-		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
-		break;
-	}
-#else
-	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
-#endif /* CONFIG_X86 */
+	info->screen_base = ioremap_wc(info->fix.smem_start, info->fix.smem_len);
 }
 
 static ssize_t uvesafb_show_vbe_ver(struct device *dev,
@@ -1851,6 +1811,7 @@ static int uvesafb_remove(struct platform_device *dev)
 		unregister_framebuffer(info);
 		release_region(0x3c0, 32);
 		iounmap(info->screen_base);
+		arch_phys_wc_del(par->mtrr_handle);
 		release_mem_region(info->fix.smem_start, info->fix.smem_len);
 		fb_destroy_modedb(info->monspecs.modedb);
 		fb_dealloc_cmap(&info->cmap);
@@ -1930,6 +1891,9 @@ static int uvesafb_setup(char *options)
 		}
 	}
 
+	if (mtrr != 3 && mtrr != 1)
+		pr_warn("uvesafb: mtrr should be set to 0 or 3; %d is unsupported", mtrr);
+
 	return 0;
 }
 #endif /* !MODULE */
diff --git a/include/video/uvesafb.h b/include/video/uvesafb.h
index 1a91850..30f5362 100644
--- a/include/video/uvesafb.h
+++ b/include/video/uvesafb.h
@@ -134,6 +134,7 @@ struct uvesafb_par {
 
 	int mode_idx;
 	struct vbe_crtc_ib crtc;
+	int mtrr_handle;
 };
 
 #endif /* _UVESAFB_H */
-- 
1.8.1.4

