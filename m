Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbaE2OVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:21:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59317 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933160AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        stable@vga.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/103] tgafb: fix mode setting with fbset
Date: Thu, 29 May 2014 15:47:57 +0200
Message-Id: <a1c6804ab9dc4e83633c6fb9ce4cdc88d6c8d016.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 624966589041deb32a2626ee2e176e8274581101 upstream.

Mode setting in the TGA driver is broken for these reasons:

- info->fix.line_length is set just once in tgafb_init_fix function. If
  we change videomode, info->fix.line_length is not recalculated - so
  the video mode is changed but the screen is corrupted because of wrong
  info->fix.line_length.

- info->fix.smem_len is set in tgafb_init_fix to the size of the default
  video mode (640x480). If we set a higher resolution,
  info->fix.smem_len is smaller than the current screen size, preventing
  the userspace program from mapping the framebuffer.

This patch fixes it:

- info->fix.line_length initialization is moved to tgafb_set_par so that
  it is recalculated with each mode change.

- info->fix.smem_len is set to a fixed value representing the real
  amount of video ram (the values are taken from xfree86 driver).

- add a check to tgafb_check_var to prevent us from setting a videomode
  that doesn't fit into videoram.

- in tgafb_register, tgafb_init_fix is moved upwards, to be called
  before fb_find_mode (because fb_find_mode already needs the videoram
  size set in tgafb_init_fix).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vga.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/tgafb.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index ba77f753649c..a78ca6a01094 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -188,6 +188,8 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	if (var->xres_virtual != var->xres || var->yres_virtual != var->yres)
 		return -EINVAL;
+	if (var->xres * var->yres * (var->bits_per_pixel >> 3) > info->fix.smem_len)
+		return -EINVAL;
 	if (var->nonstd)
 		return -EINVAL;
 	if (1000000000 / var->pixclock > TGA_PLL_MAX_FREQ)
@@ -268,6 +270,7 @@ tgafb_set_par(struct fb_info *info)
 	par->yres = info->var.yres;
 	par->pll_freq = pll_freq = 1000000000 / info->var.pixclock;
 	par->bits_per_pixel = info->var.bits_per_pixel;
+	info->fix.line_length = par->xres * (par->bits_per_pixel >> 3);
 
 	tga_type = par->tga_type;
 
@@ -1314,6 +1317,7 @@ tgafb_init_fix(struct fb_info *info)
 	int tga_bus_tc = TGA_BUS_TC(par->dev);
 	u8 tga_type = par->tga_type;
 	const char *tga_type_name = NULL;
+	unsigned memory_size;
 
 	switch (tga_type) {
 	case TGA_TYPE_8PLANE:
@@ -1321,21 +1325,25 @@ tgafb_init_fix(struct fb_info *info)
 			tga_type_name = "Digital ZLXp-E1";
 		if (tga_bus_tc)
 			tga_type_name = "Digital ZLX-E1";
+		memory_size = 2097152;
 		break;
 	case TGA_TYPE_24PLANE:
 		if (tga_bus_pci)
 			tga_type_name = "Digital ZLXp-E2";
 		if (tga_bus_tc)
 			tga_type_name = "Digital ZLX-E2";
+		memory_size = 8388608;
 		break;
 	case TGA_TYPE_24PLUSZ:
 		if (tga_bus_pci)
 			tga_type_name = "Digital ZLXp-E3";
 		if (tga_bus_tc)
 			tga_type_name = "Digital ZLX-E3";
+		memory_size = 16777216;
 		break;
 	default:
 		tga_type_name = "Unknown";
+		memory_size = 16777216;
 		break;
 	}
 
@@ -1347,9 +1355,8 @@ tgafb_init_fix(struct fb_info *info)
 			    ? FB_VISUAL_PSEUDOCOLOR
 			    : FB_VISUAL_DIRECTCOLOR);
 
-	info->fix.line_length = par->xres * (par->bits_per_pixel >> 3);
 	info->fix.smem_start = (size_t) par->tga_fb_base;
-	info->fix.smem_len = info->fix.line_length * par->yres;
+	info->fix.smem_len = memory_size;
 	info->fix.mmio_start = (size_t) par->tga_regs_base;
 	info->fix.mmio_len = 512;
 
@@ -1473,6 +1480,9 @@ static int tgafb_register(struct device *dev)
 		modedb_tga = &modedb_tc;
 		modedbsize_tga = 1;
 	}
+
+	tgafb_init_fix(info);
+
 	ret = fb_find_mode(&info->var, info,
 			   mode_option ? mode_option : mode_option_tga,
 			   modedb_tga, modedbsize_tga, NULL,
@@ -1490,7 +1500,6 @@ static int tgafb_register(struct device *dev)
 	}
 
 	tgafb_set_par(info);
-	tgafb_init_fix(info);
 
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
-- 
1.9.3

