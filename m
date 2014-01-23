Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaAWSTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:19:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaAWSTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:19:38 -0500
Date: Thu, 23 Jan 2014 13:19:35 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] tgafb: fix mode setting with fbset
In-Reply-To: <alpine.LRH.2.02.1401231308070.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231310460.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231307120.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231308070.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 drivers/video/tgafb.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-3.8-rc3-fast/drivers/video/tgafb.c
===================================================================
--- linux-3.8-rc3-fast.orig/drivers/video/tgafb.c	2013-01-10 23:42:12.000000000 +0100
+++ linux-3.8-rc3-fast/drivers/video/tgafb.c	2013-01-10 23:43:16.000000000 +0100
@@ -188,6 +188,8 @@ tgafb_check_var(struct fb_var_screeninfo
 
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
 
@@ -1476,6 +1479,7 @@ tgafb_init_fix(struct fb_info *info)
 	int tga_bus_tc = TGA_BUS_TC(par->dev);
 	u8 tga_type = par->tga_type;
 	const char *tga_type_name = NULL;
+	unsigned memory_size;
 
 	switch (tga_type) {
 	case TGA_TYPE_8PLANE:
@@ -1483,21 +1487,25 @@ tgafb_init_fix(struct fb_info *info)
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
 
@@ -1509,9 +1517,8 @@ tgafb_init_fix(struct fb_info *info)
 			    ? FB_VISUAL_PSEUDOCOLOR
 			    : FB_VISUAL_DIRECTCOLOR);
 
-	info->fix.line_length = par->xres * (par->bits_per_pixel >> 3);
 	info->fix.smem_start = (size_t) par->tga_fb_base;
-	info->fix.smem_len = info->fix.line_length * par->yres;
+	info->fix.smem_len = memory_size;
 	info->fix.mmio_start = (size_t) par->tga_regs_base;
 	info->fix.mmio_len = 512;
 
@@ -1635,6 +1642,9 @@ static int tgafb_register(struct device 
 		modedb_tga = &modedb_tc;
 		modedbsize_tga = 1;
 	}
+
+	tgafb_init_fix(info);
+
 	ret = fb_find_mode(&info->var, info,
 			   mode_option ? mode_option : mode_option_tga,
 			   modedb_tga, modedbsize_tga, NULL,
@@ -1652,7 +1662,6 @@ static int tgafb_register(struct device 
 	}
 
 	tgafb_set_par(info);
-	tgafb_init_fix(info);
 
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");

