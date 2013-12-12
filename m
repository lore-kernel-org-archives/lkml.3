Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3LLIfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:35:33 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:59742 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3LLIfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:35:30 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] video: mxsfb: fix broken video mode selection
Date: Thu, 12 Dec 2013 09:35:24 +0100
Message-Id: <1386837324-6288-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently the driver re-implements the code found in
of_get_videomode() except for the fact that the latter honors the
'native-mode' property to select a spcific video timing from the list
of possible timings. The driver builds up a list of all video timings,
but uses only the last mode from the list anyway. While building the
list it incorrectly OR's the 'pixelclk-active' and 'de-active' flags
of all modes into single flags, possibly leading to a wrong pixelclock
or data-enable polarity setting.

Fix this by using the of_get_videomode() directly with the
OF_USE_NATIVE_MODE flag.

Since all current dts files only have one entry in their
display-timings node, this bug was not apparent and the fix does not
change the driver's behaviour for the current users.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/video/mxsfb.c |  126 ++++++++++++++++++++----------------------------
 1 files changed, 53 insertions(+), 73 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 27197a8..accf48a2 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -49,6 +49,7 @@
 #include <linux/fb.h>
 #include <linux/regulator/consumer.h>
 #include <video/of_display_timing.h>
+#include <video/of_videomode.h>
 #include <video/videomode.h>
 
 #define REG_SET	4
@@ -297,7 +298,7 @@ static int mxsfb_check_var(struct fb_var_screeninfo *var,
 		}
 		break;
 	default:
-		pr_debug("Unsupported colour depth: %u\n", var->bits_per_pixel);
+		pr_err("Unsupported colour depth: %u\n", var->bits_per_pixel);
 		return -EINVAL;
 	}
 
@@ -426,7 +427,7 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 		ctrl |= CTRL_SET_WORD_LENGTH(3);
 		switch (host->ld_intf_width) {
 		case STMLCDIF_8BIT:
-			dev_dbg(&host->pdev->dev,
+			dev_err(&host->pdev->dev,
 					"Unsupported LCD bus width mapping\n");
 			return -EINVAL;
 		case STMLCDIF_16BIT:
@@ -439,7 +440,7 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 		writel(CTRL1_SET_BYTE_PACKAGING(0x7), host->base + LCDC_CTRL1);
 		break;
 	default:
-		dev_dbg(&host->pdev->dev, "Unhandled color depth of %u\n",
+		dev_err(&host->pdev->dev, "Unhandled color depth of %u\n",
 				fb_info->var.bits_per_pixel);
 		return -EINVAL;
 	}
@@ -589,7 +590,8 @@ static struct fb_ops mxsfb_ops = {
 	.fb_imageblit = cfb_imageblit,
 };
 
-static int mxsfb_restore_mode(struct mxsfb_info *host)
+static int mxsfb_restore_mode(struct mxsfb_info *host,
+			struct fb_videomode *vmode)
 {
 	struct fb_info *fb_info = &host->fb_info;
 	unsigned line_count;
@@ -597,7 +599,6 @@ static int mxsfb_restore_mode(struct mxsfb_info *host)
 	unsigned long pa, fbsize;
 	int bits_per_pixel, ofs;
 	u32 transfer_count, vdctrl0, vdctrl2, vdctrl3, vdctrl4, ctrl;
-	struct fb_videomode vmode;
 
 	/* Only restore the mode when the controller is running */
 	ctrl = readl(host->base + LCDC_CTRL);
@@ -611,8 +612,8 @@ static int mxsfb_restore_mode(struct mxsfb_info *host)
 
 	transfer_count = readl(host->base + host->devdata->transfer_count);
 
-	vmode.xres = TRANSFER_COUNT_GET_HCOUNT(transfer_count);
-	vmode.yres = TRANSFER_COUNT_GET_VCOUNT(transfer_count);
+	vmode->xres = TRANSFER_COUNT_GET_HCOUNT(transfer_count);
+	vmode->yres = TRANSFER_COUNT_GET_VCOUNT(transfer_count);
 
 	switch (CTRL_GET_WORD_LENGTH(ctrl)) {
 	case 0:
@@ -628,40 +629,39 @@ static int mxsfb_restore_mode(struct mxsfb_info *host)
 
 	fb_info->var.bits_per_pixel = bits_per_pixel;
 
-	vmode.pixclock = KHZ2PICOS(clk_get_rate(host->clk) / 1000U);
-	vmode.hsync_len = get_hsync_pulse_width(host, vdctrl2);
-	vmode.left_margin = GET_HOR_WAIT_CNT(vdctrl3) - vmode.hsync_len;
-	vmode.right_margin = VDCTRL2_GET_HSYNC_PERIOD(vdctrl2) - vmode.hsync_len -
-		vmode.left_margin - vmode.xres;
-	vmode.vsync_len = VDCTRL0_GET_VSYNC_PULSE_WIDTH(vdctrl0);
+	vmode->pixclock = KHZ2PICOS(clk_get_rate(host->clk) / 1000U);
+	vmode->hsync_len = get_hsync_pulse_width(host, vdctrl2);
+	vmode->left_margin = GET_HOR_WAIT_CNT(vdctrl3) - vmode->hsync_len;
+	vmode->right_margin = VDCTRL2_GET_HSYNC_PERIOD(vdctrl2) -
+		vmode->hsync_len - vmode->left_margin - vmode->xres;
+	vmode->vsync_len = VDCTRL0_GET_VSYNC_PULSE_WIDTH(vdctrl0);
 	period = readl(host->base + LCDC_VDCTRL1);
-	vmode.upper_margin = GET_VERT_WAIT_CNT(vdctrl3) - vmode.vsync_len;
-	vmode.lower_margin = period - vmode.vsync_len - vmode.upper_margin - vmode.yres;
+	vmode->upper_margin = GET_VERT_WAIT_CNT(vdctrl3) - vmode->vsync_len;
+	vmode->lower_margin = period - vmode->vsync_len -
+		vmode->upper_margin - vmode->yres;
 
-	vmode.vmode = FB_VMODE_NONINTERLACED;
+	vmode->vmode = FB_VMODE_NONINTERLACED;
 
-	vmode.sync = 0;
+	vmode->sync = 0;
 	if (vdctrl0 & VDCTRL0_HSYNC_ACT_HIGH)
-		vmode.sync |= FB_SYNC_HOR_HIGH_ACT;
+		vmode->sync |= FB_SYNC_HOR_HIGH_ACT;
 	if (vdctrl0 & VDCTRL0_VSYNC_ACT_HIGH)
-		vmode.sync |= FB_SYNC_VERT_HIGH_ACT;
+		vmode->sync |= FB_SYNC_VERT_HIGH_ACT;
 
 	pr_debug("Reconstructed video mode:\n");
 	pr_debug("%dx%d, hsync: %u left: %u, right: %u, vsync: %u, upper: %u, lower: %u\n",
-			vmode.xres, vmode.yres,
-			vmode.hsync_len, vmode.left_margin, vmode.right_margin,
-			vmode.vsync_len, vmode.upper_margin, vmode.lower_margin);
-	pr_debug("pixclk: %ldkHz\n", PICOS2KHZ(vmode.pixclock));
-
-	fb_add_videomode(&vmode, &fb_info->modelist);
+		vmode->xres, vmode->yres, vmode->hsync_len, vmode->left_margin,
+		vmode->right_margin, vmode->vsync_len, vmode->upper_margin,
+		vmode->lower_margin);
+	pr_debug("pixclk: %ldkHz\n", PICOS2KHZ(vmode->pixclock));
 
 	host->ld_intf_width = CTRL_GET_BUS_WIDTH(ctrl);
 	host->dotclk_delay = VDCTRL4_GET_DOTCLK_DLY(vdctrl4);
 
-	fb_info->fix.line_length = vmode.xres * (bits_per_pixel >> 3);
+	fb_info->fix.line_length = vmode->xres * (bits_per_pixel >> 3);
 
 	pa = readl(host->base + host->devdata->cur_buf);
-	fbsize = fb_info->fix.line_length * vmode.yres;
+	fbsize = fb_info->fix.line_length * vmode->yres;
 	if (pa < fb_info->fix.smem_start)
 		return -EINVAL;
 	if (pa + fbsize > fb_info->fix.smem_start + fb_info->fix.smem_len)
@@ -681,18 +681,17 @@ static int mxsfb_restore_mode(struct mxsfb_info *host)
 	return 0;
 }
 
-static int mxsfb_init_fbinfo_dt(struct mxsfb_info *host)
+static int mxsfb_init_fbinfo_dt(struct mxsfb_info *host,
+				struct fb_videomode *vmode)
 {
 	struct fb_info *fb_info = &host->fb_info;
 	struct fb_var_screeninfo *var = &fb_info->var;
 	struct device *dev = &host->pdev->dev;
 	struct device_node *np = host->pdev->dev.of_node;
 	struct device_node *display_np;
-	struct device_node *timings_np;
-	struct display_timings *timings;
+	struct videomode vm;
 	u32 width;
-	int i;
-	int ret = 0;
+	int ret;
 
 	display_np = of_parse_phandle(np, "display", 0);
 	if (!display_np) {
@@ -732,54 +731,35 @@ static int mxsfb_init_fbinfo_dt(struct mxsfb_info *host)
 		goto put_display_node;
 	}
 
-	timings = of_get_display_timings(display_np);
-	if (!timings) {
-		dev_err(dev, "failed to get display timings\n");
-		ret = -ENOENT;
+	ret = of_get_videomode(display_np, &vm, OF_USE_NATIVE_MODE);
+	if (ret) {
+		dev_err(dev, "failed to get videomode from DT\n");
 		goto put_display_node;
 	}
 
-	timings_np = of_find_node_by_name(display_np,
-					  "display-timings");
-	if (!timings_np) {
-		dev_err(dev, "failed to find display-timings node\n");
-		ret = -ENOENT;
+	ret = fb_videomode_from_videomode(&vm, vmode);
+	if (ret < 0)
 		goto put_display_node;
-	}
 
-	for (i = 0; i < of_get_child_count(timings_np); i++) {
-		struct videomode vm;
-		struct fb_videomode fb_vm;
-
-		ret = videomode_from_timings(timings, &vm, i);
-		if (ret < 0)
-			goto put_timings_node;
-		ret = fb_videomode_from_videomode(&vm, &fb_vm);
-		if (ret < 0)
-			goto put_timings_node;
-
-		if (vm.flags & DISPLAY_FLAGS_DE_HIGH)
-			host->sync |= MXSFB_SYNC_DATA_ENABLE_HIGH_ACT;
-		if (vm.flags & DISPLAY_FLAGS_PIXDATA_NEGEDGE)
-			host->sync |= MXSFB_SYNC_DOTCLK_FALLING_ACT;
-		fb_add_videomode(&fb_vm, &fb_info->modelist);
-	}
+	if (vm.flags & DISPLAY_FLAGS_DE_HIGH)
+		host->sync |= MXSFB_SYNC_DATA_ENABLE_HIGH_ACT;
+	if (vm.flags & DISPLAY_FLAGS_PIXDATA_NEGEDGE)
+		host->sync |= MXSFB_SYNC_DOTCLK_FALLING_ACT;
 
-put_timings_node:
-	of_node_put(timings_np);
 put_display_node:
 	of_node_put(display_np);
 	return ret;
 }
 
-static int mxsfb_init_fbinfo(struct mxsfb_info *host)
+static int mxsfb_init_fbinfo(struct mxsfb_info *host,
+			struct fb_videomode *vmode)
 {
+	int ret;
 	struct fb_info *fb_info = &host->fb_info;
 	struct fb_var_screeninfo *var = &fb_info->var;
 	dma_addr_t fb_phys;
 	void *fb_virt;
 	unsigned fb_size;
-	int ret;
 
 	fb_info->fbops = &mxsfb_ops;
 	fb_info->flags = FBINFO_FLAG_DEFAULT | FBINFO_READS_FAST;
@@ -789,7 +769,7 @@ static int mxsfb_init_fbinfo(struct mxsfb_info *host)
 	fb_info->fix.visual = FB_VISUAL_TRUECOLOR,
 	fb_info->fix.accel = FB_ACCEL_NONE;
 
-	ret = mxsfb_init_fbinfo_dt(host);
+	ret = mxsfb_init_fbinfo_dt(host, vmode);
 	if (ret)
 		return ret;
 
@@ -810,7 +790,7 @@ static int mxsfb_init_fbinfo(struct mxsfb_info *host)
 	fb_info->screen_base = fb_virt;
 	fb_info->screen_size = fb_info->fix.smem_len = fb_size;
 
-	if (mxsfb_restore_mode(host))
+	if (mxsfb_restore_mode(host, vmode))
 		memset(fb_virt, 0, fb_size);
 
 	return 0;
@@ -850,7 +830,7 @@ static int mxsfb_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct mxsfb_info *host;
 	struct fb_info *fb_info;
-	struct fb_modelist *modelist;
+	struct fb_videomode *mode;
 	int ret;
 
 	if (of_id)
@@ -862,6 +842,11 @@ static int mxsfb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	mode = devm_kzalloc(&pdev->dev, sizeof(struct fb_videomode),
+			GFP_KERNEL);
+	if (mode == NULL)
+		return -ENOMEM;
+
 	host = to_imxfb_host(fb_info);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -893,15 +878,11 @@ static int mxsfb_probe(struct platform_device *pdev)
 		goto fb_release;
 	}
 
-	INIT_LIST_HEAD(&fb_info->modelist);
-
-	ret = mxsfb_init_fbinfo(host);
+	ret = mxsfb_init_fbinfo(host, mode);
 	if (ret != 0)
 		goto fb_release;
 
-	modelist = list_first_entry(&fb_info->modelist,
-			struct fb_modelist, list);
-	fb_videomode_to_var(&fb_info->var, &modelist->mode);
+	fb_videomode_to_var(&fb_info->var, mode);
 
 	/* init the color fields */
 	mxsfb_check_var(&fb_info->var, fb_info);
@@ -927,7 +908,6 @@ static int mxsfb_probe(struct platform_device *pdev)
 fb_destroy:
 	if (host->enabled)
 		clk_disable_unprepare(host->clk);
-	fb_destroy_modelist(&fb_info->modelist);
 fb_release:
 	framebuffer_release(fb_info);
 
-- 
1.7.2.5

