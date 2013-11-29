Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3K2Pq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:46:56 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:50482 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab3K2Pqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:46:53 -0500
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH v4] video: add OpenCores VGA/LCD framebuffer driver
Date: Fri, 29 Nov 2013 17:45:11 +0200
Message-Id: <1385739911-6541-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the VGA/LCD core available from OpenCores:
http://opencores.org/project,vga_lcd

The driver have been tested together with both OpenRISC and
ARM (socfpga) processors.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
Changes in v2:
- Add Microblaze as an example user and fix a typo in Xilinx Zynq

Changes in v3:
- Use devm_kzalloc instead of kzalloc
- Remove superflous MODULE #ifdef

Changes in v4:
- Remove 'default n' in Kconfig
- Simplify ioremap/request_mem_region by using devm_ioremap_resource
- Remove release_mem_region
---
 drivers/video/Kconfig  |  16 ++
 drivers/video/Makefile |   1 +
 drivers/video/ocfb.c   | 454 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 471 insertions(+)
 create mode 100644 drivers/video/ocfb.c

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 84b685f..8e41a1e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -979,6 +979,22 @@ config FB_PVR2
 	  (<file:drivers/video/pvr2fb.c>). Please see the file
 	  <file:Documentation/fb/pvr2fb.txt>.
 
+config FB_OPENCORES
+	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
+	depends on FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This enables support for the OpenCores VGA/LCD core.
+
+	  The OpenCores VGA/LCD core is typically used together with
+	  softcore CPUs (e.g. OpenRISC or Microblaze) or hard processor
+	  systems (e.g. Altera socfpga or Xilinx Zynq) on FPGAs.
+
+	  The source code and specification for the core is available at
+	  <http://opencores.org/project,vga_lcd>
+
 config FB_S1D13XXX
 	tristate "Epson S1D13XXX framebuffer support"
 	depends on FB
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e8bae8d..ae17ddf 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -150,6 +150,7 @@ obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
 obj-$(CONFIG_FB_JZ4740)		  += jz4740_fb.o
 obj-$(CONFIG_FB_PUV3_UNIGFX)      += fb-puv3.o
 obj-$(CONFIG_FB_HYPERV)		  += hyperv_fb.o
+obj-$(CONFIG_FB_OPENCORES)	  += ocfb.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff --git a/drivers/video/ocfb.c b/drivers/video/ocfb.c
new file mode 100644
index 0000000..51e9795
--- /dev/null
+++ b/drivers/video/ocfb.c
@@ -0,0 +1,454 @@
+/*
+ * OpenCores VGA/LCD 2.0 core frame buffer driver
+ *
+ * Copyright (C) 2013 Stefan Kristiansson, stefan.kristiansson@saunalahti.fi
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+
+/* OCFB register defines */
+#define OCFB_CTRL	0x000
+#define OCFB_STAT	0x004
+#define OCFB_HTIM	0x008
+#define OCFB_VTIM	0x00c
+#define OCFB_HVLEN	0x010
+#define OCFB_VBARA	0x014
+#define OCFB_PALETTE	0x800
+
+#define OCFB_CTRL_VEN	0x00000001 /* Video Enable */
+#define OCFB_CTRL_HIE	0x00000002 /* HSync Interrupt Enable */
+#define OCFB_CTRL_PC	0x00000800 /* 8-bit Pseudo Color Enable*/
+#define OCFB_CTRL_CD8	0x00000000 /* Color Depth 8 */
+#define OCFB_CTRL_CD16	0x00000200 /* Color Depth 16 */
+#define OCFB_CTRL_CD24	0x00000400 /* Color Depth 24 */
+#define OCFB_CTRL_CD32	0x00000600 /* Color Depth 32 */
+#define OCFB_CTRL_VBL1	0x00000000 /* Burst Length 1 */
+#define OCFB_CTRL_VBL2	0x00000080 /* Burst Length 2 */
+#define OCFB_CTRL_VBL4	0x00000100 /* Burst Length 4 */
+#define OCFB_CTRL_VBL8	0x00000180 /* Burst Length 8 */
+
+#define PALETTE_SIZE	256
+
+#define OCFB_NAME	"OC VGA/LCD"
+
+static char *mode_option;
+
+static const struct fb_videomode default_mode = {
+	/* 640x480 @ 60 Hz, 31.5 kHz hsync */
+	NULL, 60, 640, 480, 39721, 40, 24, 32, 11, 96, 2,
+	0, FB_VMODE_NONINTERLACED
+};
+
+struct ocfb_dev {
+	struct fb_info info;
+	void __iomem *regs;
+	/* flag indicating whether the regs are little endian accessed */
+	int little_endian;
+	/* Physical and virtual addresses of framebuffer */
+	phys_addr_t fb_phys;
+	void __iomem *fb_virt;
+	u32 pseudo_palette[PALETTE_SIZE];
+};
+
+struct ocfb_par {
+	void __iomem *pal_adr;
+};
+
+static struct ocfb_par ocfb_par_priv;
+
+static struct fb_var_screeninfo ocfb_var;
+static struct fb_fix_screeninfo ocfb_fix;
+
+#ifndef MODULE
+static int __init ocfb_setup(char *options)
+{
+	char *curr_opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((curr_opt = strsep(&options, ",")) != NULL) {
+		if (!*curr_opt)
+			continue;
+		mode_option = curr_opt;
+	}
+
+	return 0;
+}
+#endif
+
+static inline u32 ocfb_readreg(struct ocfb_dev *fbdev, loff_t offset)
+{
+	if (fbdev->little_endian)
+		return ioread32(fbdev->regs + offset);
+	else
+		return ioread32be(fbdev->regs + offset);
+}
+
+static void ocfb_writereg(struct ocfb_dev *fbdev, loff_t offset, u32 data)
+{
+	if (fbdev->little_endian)
+		iowrite32(data, fbdev->regs + offset);
+	else
+		iowrite32be(data, fbdev->regs + offset);
+}
+
+static int ocfb_setupfb(struct ocfb_dev *fbdev)
+{
+	unsigned long bpp_config;
+	struct fb_var_screeninfo *var = &fbdev->info.var;
+	struct device *dev = fbdev->info.device;
+	u32 hlen;
+	u32 vlen;
+
+	/* Disable display */
+	ocfb_writereg(fbdev, OCFB_CTRL, 0);
+
+	/* Register framebuffer address */
+	fbdev->little_endian = 0;
+	ocfb_writereg(fbdev, OCFB_VBARA, fbdev->fb_phys);
+
+	/* Detect endianess */
+	if (ocfb_readreg(fbdev, OCFB_VBARA) != fbdev->fb_phys) {
+		fbdev->little_endian = 1;
+		ocfb_writereg(fbdev, OCFB_VBARA, fbdev->fb_phys);
+	}
+
+	/* Horizontal timings */
+	ocfb_writereg(fbdev, OCFB_HTIM, (var->hsync_len - 1) << 24 |
+		      (var->right_margin - 1) << 16 | (var->xres - 1));
+
+	/* Vertical timings */
+	ocfb_writereg(fbdev, OCFB_VTIM, (var->vsync_len - 1) << 24 |
+		      (var->lower_margin - 1) << 16 | (var->yres - 1));
+
+	/* Total length of frame */
+	hlen = var->left_margin + var->right_margin + var->hsync_len +
+		var->xres;
+
+	vlen = var->upper_margin + var->lower_margin + var->vsync_len +
+		var->yres;
+
+	ocfb_writereg(fbdev, OCFB_HVLEN, (hlen - 1) << 16 | (vlen - 1));
+
+	bpp_config = OCFB_CTRL_CD8;
+	switch (var->bits_per_pixel) {
+	case 8:
+		if (!var->grayscale)
+			bpp_config |= OCFB_CTRL_PC;  /* enable palette */
+		break;
+
+	case 16:
+		bpp_config |= OCFB_CTRL_CD16;
+		break;
+
+	case 24:
+		bpp_config |= OCFB_CTRL_CD24;
+		break;
+
+	case 32:
+		bpp_config |= OCFB_CTRL_CD32;
+		break;
+
+	default:
+		dev_err(dev, "no bpp specified\n");
+		break;
+	}
+
+	/* maximum (8) VBL (video memory burst length) */
+	bpp_config |= OCFB_CTRL_VBL8;
+
+	/* Enable output */
+	ocfb_writereg(fbdev, OCFB_CTRL, (OCFB_CTRL_VEN | bpp_config));
+
+	return 0;
+}
+
+static int ocfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			  unsigned blue, unsigned transp,
+			  struct fb_info *info)
+{
+	struct ocfb_par *par = (struct ocfb_par *)info->par;
+	u32 color;
+
+	if (regno >= info->cmap.len) {
+		dev_err(info->device, "regno >= cmap.len\n");
+		return 1;
+	}
+
+	if (info->var.grayscale) {
+		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
+	}
+
+	red >>= (16 - info->var.red.length);
+	green >>= (16 - info->var.green.length);
+	blue >>= (16 - info->var.blue.length);
+	transp >>= (16 - info->var.transp.length);
+
+	if (info->var.bits_per_pixel == 8 && !info->var.grayscale) {
+		regno <<= 2;
+		color = (red << 16) | (green << 8) | blue;
+		ocfb_writereg(par->pal_adr, regno, color);
+	} else {
+		((u32 *)(info->pseudo_palette))[regno] =
+			(red << info->var.red.offset) |
+			(green << info->var.green.offset) |
+			(blue << info->var.blue.offset) |
+			(transp << info->var.transp.offset);
+	}
+
+	return 0;
+}
+
+static int ocfb_init_fix(struct ocfb_dev *fbdev)
+{
+	struct fb_var_screeninfo *var = &fbdev->info.var;
+	struct fb_fix_screeninfo *fix = &fbdev->info.fix;
+
+	strcpy(fix->id, OCFB_NAME);
+
+	fix->line_length = var->xres * var->bits_per_pixel/8;
+	fix->smem_len = fix->line_length * var->yres;
+	fix->type = FB_TYPE_PACKED_PIXELS;
+
+	if (var->bits_per_pixel == 8 && !var->grayscale)
+		fix->visual = FB_VISUAL_PSEUDOCOLOR;
+	else
+		fix->visual = FB_VISUAL_TRUECOLOR;
+
+	return 0;
+}
+
+static int ocfb_init_var(struct ocfb_dev *fbdev)
+{
+	struct fb_var_screeninfo *var = &fbdev->info.var;
+
+	var->accel_flags = FB_ACCEL_NONE;
+	var->activate = FB_ACTIVATE_NOW;
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+
+	switch (var->bits_per_pixel) {
+	case 8:
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->red.offset = 0;
+		var->red.length = 8;
+		var->green.offset = 0;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		break;
+
+	case 16:
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->red.offset = 11;
+		var->red.length = 5;
+		var->green.offset = 5;
+		var->green.length = 6;
+		var->blue.offset = 0;
+		var->blue.length  = 5;
+		break;
+
+	case 24:
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->red.offset = 16;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		break;
+
+	case 32:
+		var->transp.offset = 24;
+		var->transp.length = 8;
+		var->red.offset = 16;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		break;
+	}
+
+	return 0;
+}
+
+static struct fb_ops ocfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_setcolreg	= ocfb_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+static int ocfb_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct ocfb_dev *fbdev;
+	struct ocfb_par *par = &ocfb_par_priv;
+	struct resource *res;
+	int fbsize;
+
+	fbdev = devm_kzalloc(&pdev->dev, sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, fbdev);
+
+	fbdev->info.fbops = &ocfb_ops;
+	fbdev->info.var = ocfb_var;
+	fbdev->info.fix = ocfb_fix;
+	fbdev->info.device = &pdev->dev;
+	fbdev->info.par = par;
+
+	/* Video mode setup */
+	if (!fb_find_mode(&fbdev->info.var, &fbdev->info, mode_option,
+			  NULL, 0, &default_mode, 16)) {
+		dev_err(&pdev->dev, "No valid video modes found\n");
+		return -EINVAL;
+	}
+	ocfb_init_var(fbdev);
+	ocfb_init_fix(fbdev);
+
+	/* Request I/O resource */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "I/O resource request failed\n");
+		return -ENXIO;
+	}
+	res->flags &= ~IORESOURCE_CACHEABLE;
+	fbdev->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fbdev->regs))
+		return PTR_ERR(fbdev->regs);
+
+	par->pal_adr = fbdev->regs + OCFB_PALETTE;
+
+	/* Allocate framebuffer memory */
+	fbsize = fbdev->info.fix.smem_len;
+	fbdev->fb_virt = dma_alloc_coherent(&pdev->dev, PAGE_ALIGN(fbsize),
+					    &fbdev->fb_phys, GFP_KERNEL);
+	if (!fbdev->fb_virt) {
+		dev_err(&pdev->dev,
+			"Frame buffer memory allocation failed\n");
+		return -ENOMEM;
+	}
+	fbdev->info.fix.smem_start = fbdev->fb_phys;
+	fbdev->info.screen_base = (void __iomem *)fbdev->fb_virt;
+	fbdev->info.pseudo_palette = fbdev->pseudo_palette;
+
+	/* Clear framebuffer */
+	memset_io((void __iomem *)fbdev->fb_virt, 0, fbsize);
+
+	/* Setup and enable the framebuffer */
+	ocfb_setupfb(fbdev);
+
+	if (fbdev->little_endian)
+		fbdev->info.flags |= FBINFO_FOREIGN_ENDIAN;
+
+	/* Allocate color map */
+	ret = fb_alloc_cmap(&fbdev->info.cmap, PALETTE_SIZE, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "Color map allocation failed\n");
+		goto err_dma_free;
+	}
+
+	/* Register framebuffer */
+	ret = register_framebuffer(&fbdev->info);
+	if (ret) {
+		dev_err(&pdev->dev, "Framebuffer registration failed\n");
+		goto err_dealloc_cmap;
+	}
+
+	return 0;
+
+err_dealloc_cmap:
+	fb_dealloc_cmap(&fbdev->info.cmap);
+
+err_dma_free:
+	dma_free_coherent(&pdev->dev, PAGE_ALIGN(fbsize), fbdev->fb_virt,
+			  fbdev->fb_phys);
+
+	return ret;
+}
+
+static int ocfb_remove(struct platform_device *pdev)
+{
+	struct ocfb_dev *fbdev = platform_get_drvdata(pdev);
+
+	unregister_framebuffer(&fbdev->info);
+	fb_dealloc_cmap(&fbdev->info.cmap);
+	dma_free_coherent(&pdev->dev, PAGE_ALIGN(fbdev->info.fix.smem_len),
+			  fbdev->fb_virt, fbdev->fb_phys);
+
+	/* Disable display */
+	ocfb_writereg(fbdev, OCFB_CTRL, 0);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct of_device_id ocfb_match[] = {
+	{ .compatible = "opencores,ocfb", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ocfb_match);
+
+static struct platform_driver ocfb_driver = {
+	.probe  = ocfb_probe,
+	.remove	= ocfb_remove,
+	.driver = {
+		.name = "ocfb_fb",
+		.of_match_table = ocfb_match,
+	}
+};
+
+/*
+ * Init and exit routines
+ */
+static int __init ocfb_init(void)
+{
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("ocfb", &option))
+		return -ENODEV;
+	ocfb_setup(option);
+#endif
+	return platform_driver_register(&ocfb_driver);
+}
+
+static void __exit ocfb_exit(void)
+{
+	platform_driver_unregister(&ocfb_driver);
+}
+
+module_init(ocfb_init);
+module_exit(ocfb_exit);
+
+MODULE_AUTHOR("Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>");
+MODULE_DESCRIPTION("OpenCores VGA/LCD 2.0 frame buffer driver");
+MODULE_LICENSE("GPL v2");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Video mode ('<xres>x<yres>[-<bpp>][@refresh]')");
-- 
1.8.3.2

