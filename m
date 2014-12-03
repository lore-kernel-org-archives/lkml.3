Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaLCJSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:18:51 -0500
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:21952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751948AbaLCJRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:17:47 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <alexander.stein@systec-electronic.com>, <shawn.guo@linaro.org>,
        <linux-fbdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/4] video: fsl-dcfb: Add dcfb framebuffer driver for LS1021A platform
Date: Wed, 3 Dec 2014 17:15:59 +0800
Message-ID: <1417598162-40433-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(99396003)(229853001)(48376002)(50466002)(31966008)(120916001)(50986999)(102836001)(36756003)(107046002)(77156002)(62966003)(104166001)(68736005)(77096005)(88136002)(97736003)(104016003)(95666004)(106466001)(47776003)(575784001)(21056001)(86362001)(93916002)(76176999)(105606002)(92726001)(64706001)(20776003)(92566001)(46102003)(87936001)(84676001)(87286001)(6806004)(89996001)(19580395003)(19580405001)(50226001)(44976005)(4396001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Display Controller module is a system master that fetches graphics
stored in internal/external memory and displays them on a TFT LCD panel.
A wide range of panel sizes is supported and the timing of the interface
signals is configurable.

The dcfb has these features:
o Full RGB888 output to TFT LCD panel.
o Optional output to system memory dependent on implementation.
o Supports Programmable panel size upto a maximum of 2032x2047. The actual
  resolution supported depends upon the pixel clock and bus bandwidth
  available.
o Gamma correction with 8-bit resolution on each color component.
o Dedicated memory blocks to store a cursor and Color Look Up Tables(CLUTs).
o Temporal Dithering.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/video/fbdev/Kconfig    |  19 +
 drivers/video/fbdev/Makefile   |   1 +
 drivers/video/fbdev/fsl-dcfb.c | 814 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 834 insertions(+)
 create mode 100644 drivers/video/fbdev/fsl-dcfb.c

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 4916c97..460fe39 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1948,6 +1948,25 @@ config FB_MBX_DEBUG
 
          If unsure, say N.
 
+config FB_FSL_DCFB
+	tristate "Freescale Display Control Framebuffer Support"
+	depends on FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	select REGMAP_MMIO
+	---help---
+	  Framebuffer driver for the Freescale SoC Display Control.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want).
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+
 config FB_FSL_DIU
 	tristate "Freescale DIU framebuffer support"
 	depends on FB && FSL_SOC
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 1979aff..9015138 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_FB_SH7760)		  += sh7760fb.o
 obj-$(CONFIG_FB_IMX)              += imxfb.o
 obj-$(CONFIG_FB_S3C)		  += s3c-fb.o
 obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
+obj-$(CONFIG_FB_FSL_DCFB)	  += fsl-dcfb.o
 obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
 obj-$(CONFIG_FB_COBALT)           += cobalt_lcdfb.o
 obj-$(CONFIG_FB_IBM_GXT4500)	  += gxt4500.o
diff --git a/drivers/video/fbdev/fsl-dcfb.c b/drivers/video/fbdev/fsl-dcfb.c
new file mode 100644
index 0000000..c3843bf
--- /dev/null
+++ b/drivers/video/fbdev/fsl-dcfb.c
@@ -0,0 +1,814 @@
+/*
+ * Copyright 2012-2014 Freescale Semiconductor, Inc.
+ *
+ * Freescale Dispaly Controller Framebuffer Driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/regmap.h>
+#include <video/of_display_timing.h>
+#include <video/videomode.h>
+
+#define FSL_SCFG_CTRL		0x28
+#define FSL_SCFG_PIXEL_EN	BIT(31)
+
+#define FSL_DCFB_MODE		0x10
+#define FSL_DCFB_BGND		0x14
+#define FSL_DCFB_FIX_SIZE	0x18
+#define FSL_DCFB_HSYN		0x1c
+#define FSL_DCFB_VSYN		0x20
+#define FSL_DCFB_SP		0x24
+#define FSL_DCFB_TS		0x28
+#define FSL_DCFB_DIV_RATIO	0x54
+#define FSL_DCFB_UPDATE		0xcc
+#define FSL_DCFB_VAR_SIZE	0x200
+#define FSL_DCFB_POS		0x204
+#define FSL_DCFB_BASE		0x208
+#define FSL_DCFB_CTRL		0x20c
+#define FSL_DCFB_CKMAX		0x210
+#define FSL_DCFB_CKMIN		0x214
+#define FSL_DCFB_FCOLOR		0x21c
+#define FSL_DCFB_BCOLOR		0x220
+#define FSL_DCFB_SKIP		0x224
+#define FSL_DCFB_MAX		0x300
+
+#define FSL_DCFB_HSYN_BP(x)	((x) << 22)
+#define FSL_DCFB_HSYN_PW(x)	((x) << 11)
+#define FSL_DCFB_HSYN_FP(x)	(x)
+#define FSL_DCFB_VSYN_BP(x)	((x) << 22)
+#define FSL_DCFB_VSYN_PW(x)	((x) << 11)
+#define FSL_DCFB_VSYN_FP(x)	(x)
+
+#define FSL_DCFB_SP_VS		BIT(1)
+#define FSL_DCFB_SP_HS		BIT(0)
+
+#define FSL_DCFB_TS_LBV(x)	((x) << 16)
+#define FSL_DCFB_TS_OBH(x)	((x) << 8)
+#define FSL_DCFB_TS_OBL(x)	(x)
+
+#define FSL_DCFB_UPDATE_MODE	BIT(31)
+#define FSL_DCFB_UPDATE_READREG	BIT(30)
+
+#define FSL_DCFB_VAR_SIZE_H(x)	((x) << 16)
+#define FSL_DCFB_VAR_SIZE_W(x)	(x)
+
+#define FSL_DCFB_POSY(x)	((x) << 16)
+#define FSL_DCFB_POSX(x)	(x)
+
+#define FSL_DCFB_CTRL_EN	BIT(31)
+#define FSL_DCFB_CTRL_TILE_EN	BIT(30)
+#define FSL_DCFB_CTRL_DATA_SEL_CLUT	BIT(29)
+#define FSL_DCFB_CTRL_SAFETY_EN	BIT(28)
+#define FSL_DCFB_CTRL_TRANS(x)	((x) << 20)
+#define FSL_DCFB_CTRL_BPP(x)	((x) << 16)
+#define FSL_DCFB_CTRL_RLE_EN	BIT(15)
+#define FSL_DCFB_CTRL_LUOFFS(x)	((x) << 4)
+#define FSL_DCFB_CTRL_BB_ON	BIT(2)
+
+#define FSL_DCFB_CKMAX_R(x)	((x) << 16)
+#define FSL_DCFB_CKMAX_G(x)	((x) << 8)
+#define FSL_DCFB_CKMAX_B(x)	(x)
+
+#define FSL_DCFB_CKMIN_R(x)	((x) << 16)
+#define FSL_DCFB_CKMIN_G(x)	((x) << 8)
+#define FSL_DCFB_CKMIN_B(x)	(x)
+
+#define FSL_DCFB_TILE_SIZE_W(x)	((x) << 16)
+#define FSL_DCFB_TILE_SIZE_H(x)	(x)
+
+#define FSL_DCFB_FCOLOR_OFF(x)	(x)
+#define FSL_DCFB_BCOLOR_OFF(x)	(x)
+
+#define FSL_DCFB_MODE_BITER(x)	((x) << 20)
+#define FSL_DCFB_MODE_RASTER_EN	BIT(14)
+#define FSL_DCFB_MODE_MODE(x)	(x)
+#define FSL_DCFB_MODE_MODE_MASK	0x03
+
+#define FSL_DCFB_BGND_R(x)	((x) << 16)
+#define FSL_DCFB_BGND_G(x)	((x) << 8)
+#define FSL_DCFB_BGND_B(x)	(x)
+
+#define FSL_DCFB_FIX_SIZE_Y(x)	((x) << 16)
+#define FSL_DCFB_FIX_SIZE_X(x)	(x)
+
+enum fsl_dcfb_fmt {
+	FSL_DCFB_RGB565 = 4,
+	FSL_DCFB_RGB888,
+	FSL_DCFB_ARGB8888,
+};
+
+enum fsl_dcfb_mode {
+	FSL_DCFB_MOD_OFF = 0,
+	FSL_DCFB_MOD_NORMAL,
+	FSL_DCFB_MOD_TEST,
+	FSL_DCFB_MOD_COLORBAR,
+};
+
+struct fsl_dcfb_fb_private {
+	struct fb_info *fsl_dcfb_info;
+	struct device *dev;
+	struct regmap *regmap;
+	struct clk *clk;
+};
+
+struct fsl_dcfb_fb_info {
+	unsigned long pseudo_palette[16];
+	unsigned int count;
+	struct fsl_dcfb_fb_private *parent;
+};
+
+static inline struct fsl_dcfb_fb_private *to_fsl_private(struct fb_info *info)
+{
+	struct fsl_dcfb_fb_info *fsl_info = info->par;
+
+	return (struct fsl_dcfb_fb_private *)fsl_info->parent;
+}
+
+static int fsl_dcfb_get_bpp(unsigned int bits_per_pixel)
+{
+	int bpp;
+
+	switch (bits_per_pixel) {
+	case 16:
+		bpp = FSL_DCFB_RGB565;
+		break;
+	case 24:
+		bpp = FSL_DCFB_RGB888;
+		break;
+	case 32:
+		bpp = FSL_DCFB_ARGB8888;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return bpp;
+}
+
+static int fsl_dcfb_set_panel(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	int bpp;
+
+	regmap_write(dcfb->regmap, FSL_DCFB_VAR_SIZE,
+		     FSL_DCFB_VAR_SIZE_H(var->yres) |
+		     FSL_DCFB_VAR_SIZE_W(var->xres));
+	regmap_write(dcfb->regmap, FSL_DCFB_POS,
+		     FSL_DCFB_POSY(0) | FSL_DCFB_POSX(0));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_BASE, info->fix.smem_start);
+
+	bpp = fsl_dcfb_get_bpp(var->bits_per_pixel);
+	if (bpp < 0) {
+		dev_err(dcfb->dev, "unsupported color depth: %u\n",
+				var->bits_per_pixel);
+		return bpp;
+	}
+
+	regmap_write(dcfb->regmap, FSL_DCFB_CTRL, FSL_DCFB_CTRL_EN |
+		     FSL_DCFB_CTRL_TRANS(0xFF) | FSL_DCFB_CTRL_BPP(bpp));
+	regmap_write(dcfb->regmap, FSL_DCFB_CKMAX, FSL_DCFB_CKMAX_R(0xFF) |
+		     FSL_DCFB_CKMAX_G(0xFF) | FSL_DCFB_CKMAX_B(0xFF));
+	regmap_write(dcfb->regmap, FSL_DCFB_CKMIN, FSL_DCFB_CKMIN_R(0) |
+		     FSL_DCFB_CKMIN_G(0) | FSL_DCFB_CKMIN_B(0));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_FCOLOR, FSL_DCFB_FCOLOR_OFF(0));
+	regmap_write(dcfb->regmap, FSL_DCFB_BCOLOR, FSL_DCFB_BCOLOR_OFF(0));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_UPDATE, FSL_DCFB_UPDATE_READREG);
+
+	return 0;
+}
+
+static int fsl_dcfb_reset_panel(struct fsl_dcfb_fb_private *dcfb)
+{
+	regmap_write(dcfb->regmap, FSL_DCFB_VAR_SIZE, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_POS, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_BASE, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_CTRL, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_CKMAX, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_CKMIN, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_FCOLOR, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_BCOLOR, 0x0);
+	regmap_write(dcfb->regmap, FSL_DCFB_SKIP, 0x0);
+
+	regmap_write(dcfb->regmap, FSL_DCFB_UPDATE, FSL_DCFB_UPDATE_READREG);
+
+	return 0;
+}
+
+static void fsl_dcfb_modeset(struct fsl_dcfb_fb_private *dcfb,
+			     enum fsl_dcfb_mode mode)
+{
+	regmap_update_bits(dcfb->regmap, FSL_DCFB_MODE,
+			   FSL_DCFB_MODE_MODE_MASK,
+			   FSL_DCFB_MODE_MODE(mode));
+}
+
+static int fsl_dcfb_check_var(struct fb_var_screeninfo *var,
+		struct fb_info *info)
+{
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	if (var->xoffset + info->var.xres > info->var.xres_virtual)
+		var->xoffset = info->var.xres_virtual - info->var.xres;
+
+	if (var->yoffset + info->var.yres > info->var.yres_virtual)
+		var->yoffset = info->var.yres_virtual - info->var.yres;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		var->red.length = 5;
+		var->red.offset = 11;
+		var->red.msb_right = 0;
+
+		var->green.length = 6;
+		var->green.offset = 5;
+		var->green.msb_right = 0;
+
+		var->blue.length = 5;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 24:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 32:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 8;
+		var->transp.offset = 24;
+		var->transp.msb_right = 0;
+		break;
+	default:
+		dev_err(dcfb->dev, "unsupported color depth: %u\n",
+			var->bits_per_pixel);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fsl_dcfb_alloc_mem(struct fb_info *info)
+{
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	u32 smem_len = info->fix.line_length * info->var.yres_virtual;
+
+	info->fix.smem_len = smem_len;
+
+	info->screen_base = dma_alloc_writecombine(info->device,
+		info->fix.smem_len, (dma_addr_t *)&info->fix.smem_start,
+		GFP_KERNEL);
+	if (!info->screen_base) {
+		dev_err(dcfb->dev, "unable to allocate fb memory\n");
+		return -ENOMEM;
+	}
+
+	memset(info->screen_base, 0, info->fix.smem_len);
+
+	return 0;
+}
+
+static void fsl_dcfb_free_mem(struct fb_info *info)
+{
+	if (!info->screen_base)
+		return;
+
+	dma_free_writecombine(info->device, info->fix.smem_len,
+		info->screen_base, info->fix.smem_start);
+
+	info->screen_base = NULL;
+	info->fix.smem_start = 0;
+	info->fix.smem_len = 0;
+}
+
+static int fsl_dcfb_set_par(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct fb_fix_screeninfo *fix = &info->fix;
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	unsigned int div, len;
+
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->accel = FB_ACCEL_NONE;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	fix->xpanstep = fix->ypanstep = 1;
+
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+	len = info->var.yres_virtual * info->fix.line_length;
+	if (len != info->fix.smem_len) {
+		if (info->fix.smem_start)
+			fsl_dcfb_free_mem(info);
+
+		if (fsl_dcfb_alloc_mem(info)) {
+			dev_err(dcfb->dev, "unable to allocate FB memory\n");
+			return -ENOMEM;
+		}
+	}
+
+	div = KHZ2PICOS(clk_get_rate(dcfb->clk) / 1000);
+	regmap_write(dcfb->regmap, FSL_DCFB_DIV_RATIO,
+		     info->var.pixclock / div);
+
+	regmap_write(dcfb->regmap, FSL_DCFB_FIX_SIZE,
+		     FSL_DCFB_FIX_SIZE_Y(var->yres) |
+		     FSL_DCFB_FIX_SIZE_X(var->xres / 16));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_HSYN,
+		     FSL_DCFB_HSYN_BP(var->left_margin) |
+		     FSL_DCFB_HSYN_PW(var->hsync_len) |
+		     FSL_DCFB_HSYN_FP(var->right_margin));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_VSYN,
+		     FSL_DCFB_VSYN_BP(var->upper_margin) |
+		     FSL_DCFB_VSYN_PW(var->vsync_len) |
+		     FSL_DCFB_VSYN_FP(var->lower_margin));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_SP,
+		     FSL_DCFB_SP_VS | FSL_DCFB_SP_HS);
+
+	regmap_write(dcfb->regmap, FSL_DCFB_BGND, FSL_DCFB_BGND_R(0) |
+		     FSL_DCFB_BGND_G(0) | FSL_DCFB_BGND_B(0));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_MODE,
+		     FSL_DCFB_MODE_BITER(1) | FSL_DCFB_MODE_RASTER_EN);
+
+	regmap_write(dcfb->regmap, FSL_DCFB_TS, FSL_DCFB_TS_LBV(0x03) |
+		     FSL_DCFB_TS_OBH(0x78) | FSL_DCFB_TS_OBL(0x0A));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_UPDATE, FSL_DCFB_UPDATE_READREG);
+
+	fsl_dcfb_modeset(dcfb, FSL_DCFB_MOD_NORMAL);
+	fsl_dcfb_set_panel(info);
+
+	return 0;
+}
+
+#define CNVT_TOHW(val, width) ((((val) << (width)) + 0x7FFF - (val)) >> 16)
+static int fsl_dcfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			      unsigned blue, unsigned transp,
+			      struct fb_info *info)
+{
+	int ret = 1;
+
+	/*
+	 * If greyscale is true, then we convert the RGB value
+	 * to greyscale no matter what visual we are using.
+	 */
+	if (info->var.grayscale)
+		red = green = blue = (19595 * red + 38470 * green +
+				      7471 * blue) >> 16;
+
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+			u32 value;
+
+			red = CNVT_TOHW(red, info->var.red.length);
+			green = CNVT_TOHW(green, info->var.green.length);
+			blue = CNVT_TOHW(blue, info->var.blue.length);
+			transp = CNVT_TOHW(transp, info->var.transp.length);
+
+			value = (red << info->var.red.offset) |
+				(green << info->var.green.offset) |
+				(blue << info->var.blue.offset) |
+				(transp << info->var.transp.offset);
+
+			pal[regno] = value;
+			ret = 0;
+		}
+		break;
+	case FB_VISUAL_STATIC_PSEUDOCOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		break;
+	}
+
+	return ret;
+}
+#undef CNVT_TOHW
+
+static int fsl_dcfb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
+{
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	unsigned long addr;
+	int offset;
+
+	if ((info->var.xoffset == var->xoffset) &&
+	    (info->var.yoffset == var->yoffset))
+		return 0;
+
+	if ((var->xoffset + info->var.xres) > info->var.xres_virtual
+	    || (var->yoffset + info->var.yres) > info->var.yres_virtual)
+		return -EINVAL;
+
+	info->var.xoffset = var->xoffset;
+	info->var.yoffset = var->yoffset;
+
+	if (var->vmode & FB_VMODE_YWRAP)
+		info->var.vmode |= FB_VMODE_YWRAP;
+	else
+		info->var.vmode &= ~FB_VMODE_YWRAP;
+
+	offset = (info->var.yoffset * info->var.xres_virtual);
+	offset += info->var.xoffset;
+	addr = info->fix.smem_start +
+		(offset * (info->var.bits_per_pixel >> 3));
+
+	regmap_write(dcfb->regmap, FSL_DCFB_BASE, addr);
+	regmap_write(dcfb->regmap, FSL_DCFB_UPDATE, FSL_DCFB_UPDATE_READREG);
+
+	return 0;
+}
+
+static int fsl_dcfb_blank(int blank_mode, struct fb_info *info)
+{
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+
+	switch (blank_mode) {
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		fsl_dcfb_reset_panel(dcfb);
+		break;
+	case FB_BLANK_POWERDOWN:
+		fsl_dcfb_modeset(dcfb, FSL_DCFB_MOD_OFF);
+		break;
+	case FB_BLANK_UNBLANK:
+		fsl_dcfb_set_panel(info);
+		break;
+	}
+
+	return 0;
+}
+
+static int fsl_dcfb_open(struct fb_info *info, int user)
+{
+	struct fsl_dcfb_fb_info *fsl_info = info->par;
+	int ret = 0;
+
+	fsl_info->count++;
+	if (fsl_info->count == 1) {
+		fsl_dcfb_check_var(&info->var, info);
+		ret = fsl_dcfb_set_par(info);
+		if (ret < 0)
+			fsl_info->count--;
+	}
+
+	return ret;
+}
+
+static int fsl_dcfb_release(struct fb_info *info, int user)
+{
+	struct fsl_dcfb_fb_info *fsl_info = info->par;
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	int ret = 0;
+
+	fsl_info->count--;
+	if (fsl_info->count == 0)
+		ret = fsl_dcfb_reset_panel(dcfb);
+
+	return ret;
+}
+
+static struct fb_ops fsl_dcfb_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = fsl_dcfb_check_var,
+	.fb_set_par = fsl_dcfb_set_par,
+	.fb_setcolreg = fsl_dcfb_setcolreg,
+	.fb_blank = fsl_dcfb_blank,
+	.fb_pan_display = fsl_dcfb_pan_display,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_open = fsl_dcfb_open,
+	.fb_release = fsl_dcfb_release,
+};
+
+static int fsl_dcfb_init_fbinfo(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct fsl_dcfb_fb_private *dcfb = to_fsl_private(info);
+	struct device_node *np = dcfb->dev->of_node;
+	struct device_node *dnp, *tnp;
+	struct display_timings *timings;
+	struct fb_videomode fb_vm;
+	int i, ret;
+
+	INIT_LIST_HEAD(&info->modelist);
+
+	dnp = of_parse_phandle(np, "display", 0);
+	if (!dnp) {
+		dev_err(dcfb->dev, "failed to find \"display\" phandle.\n");
+		return -ENODEV;
+	}
+
+	ret = of_property_read_u32(dnp, "bits-per-pixel",
+				   &var->bits_per_pixel);
+	if (ret < 0) {
+		dev_err(dcfb->dev, "failed to get \"bits-per-pixel\" property.\n");
+		goto put_dnp;
+	}
+
+	timings = of_get_display_timings(dnp);
+	if (!timings) {
+		dev_err(dcfb->dev, "failed to get display timings\n");
+		return -ENODEV;
+		goto put_dnp;
+	}
+
+	tnp = of_find_node_by_name(dnp, "display-timings");
+	if (!tnp) {
+		dev_err(dcfb->dev, "failed to find \"display-timings\" node\n");
+		return -ENODEV;
+		goto put_dnp;
+	}
+
+	for (i = 0; i < of_get_child_count(tnp); i++) {
+		struct videomode vm;
+
+		ret = videomode_from_timings(timings, &vm, i);
+		if (ret < 0)
+			goto put_tnp;
+
+		ret = fb_videomode_from_videomode(&vm, &fb_vm);
+		if (ret < 0)
+			goto put_tnp;
+
+		fb_add_videomode(&fb_vm, &info->modelist);
+	}
+
+	ret = of_get_fb_videomode(dnp, &fb_vm, OF_USE_NATIVE_MODE);
+	if (ret)
+		goto put_dnp;
+
+	fb_videomode_to_var(&info->var, &fb_vm);
+	ret = fsl_dcfb_check_var(&info->var, info);
+
+put_tnp:
+	of_node_put(tnp);
+put_dnp:
+	of_node_put(dnp);
+
+	return ret;
+}
+
+static const struct regmap_config fsl_scfg_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+
+	.max_register = FSL_SCFG_CTRL,
+};
+
+static int scfg_config(struct fsl_dcfb_fb_private *dcfb, struct device_node *np)
+{
+	struct device_node *snp;
+	struct platform_device *pdev;
+	struct resource *res;
+	void __iomem *base;
+	struct regmap *regmap;
+	int ret = 0;
+
+	snp = of_parse_phandle(np, "scfg-controller", 0);
+	if (!snp)
+		return -ENODEV;
+
+	pdev = of_find_device_by_node(snp);
+	if (!pdev) {
+		ret = -ENODEV;
+		goto put_snp;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENODEV;
+		goto put_snp;
+	}
+
+	base = ioremap(res->start, SZ_4K);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "could not ioremap scfg resource\n");
+		ret = PTR_ERR(base);
+		goto put_snp;
+	}
+
+	regmap = regmap_init_mmio(&pdev->dev, base,
+				  &fsl_scfg_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		ret = PTR_ERR(regmap);
+		goto ioremap;
+	}
+
+	regmap_write(regmap, FSL_SCFG_CTRL, FSL_SCFG_PIXEL_EN);
+
+	regmap_exit(regmap);
+ioremap:
+	iounmap(base);
+put_snp:
+	of_node_put(snp);
+
+	return ret;
+}
+
+static int fsl_dcfb_dev_init(struct device_node *np,
+			     struct fsl_dcfb_fb_private *dcfb)
+{
+	int ret;
+
+	ret = scfg_config(dcfb, np);
+	if (ret) {
+		dev_err(dcfb->dev, "could not config scfg\n");
+		return -EINVAL;
+	}
+
+	return fsl_dcfb_reset_panel(dcfb);
+}
+
+static const struct regmap_config fsl_dcfb_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+
+	.max_register = FSL_DCFB_MAX,
+};
+
+static int fsl_dcfb_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct fsl_dcfb_fb_private *dcfb;
+	struct fsl_dcfb_fb_info *fsl_info;
+	struct fb_info *info;
+	struct resource *res;
+	void __iomem *base;
+	int ret = 0;
+
+	dcfb = devm_kzalloc(&pdev->dev,
+		sizeof(struct fsl_dcfb_fb_private), GFP_KERNEL);
+	if (!dcfb)
+		return -ENOMEM;
+
+	dcfb->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "could not get memory IO resource\n");
+		return -ENODEV;
+	}
+
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "could not ioremap resource\n");
+		return PTR_ERR(base);
+	}
+
+	dcfb->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
+				NULL, base, &fsl_dcfb_regmap_config);
+	if (IS_ERR(dcfb->regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		return PTR_ERR(dcfb->regmap);
+	}
+
+	dcfb->clk = devm_clk_get(&pdev->dev, "dcfb");
+	if (IS_ERR(dcfb->clk)) {
+		ret = PTR_ERR(dcfb->clk);
+		dev_err(&pdev->dev, "could not get clock\n");
+		return -EINVAL;
+	}
+	clk_prepare_enable(dcfb->clk);
+
+	fsl_dcfb_dev_init(np, dcfb);
+
+	dcfb->fsl_dcfb_info =
+		framebuffer_alloc(sizeof(struct fsl_dcfb_fb_info), &pdev->dev);
+	if (!dcfb->fsl_dcfb_info) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
+
+	dcfb->fsl_dcfb_info->fix.smem_start = 0;
+
+	fsl_info = dcfb->fsl_dcfb_info->par;
+	fsl_info->count = 0,
+	fsl_info->parent = dcfb;
+
+	info = dcfb->fsl_dcfb_info;
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->fbops = &fsl_dcfb_ops;
+	info->flags = FBINFO_FLAG_DEFAULT;
+	info->pseudo_palette = &fsl_info->pseudo_palette;
+
+	ret = fb_alloc_cmap(&info->cmap, 16, 0);
+	if (ret) {
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	ret = fsl_dcfb_init_fbinfo(info);
+	if (ret)
+		goto err_cmap;
+
+	ret = register_framebuffer(info);
+	if (ret < 0) {
+		dev_err(dcfb->dev, "failed to register framebuffer device\n");
+		goto err_cmap;
+	}
+
+	dev_set_drvdata(&pdev->dev, dcfb);
+
+	goto out;
+
+err_cmap:
+	fb_dealloc_cmap(&info->cmap);
+err_mem:
+	framebuffer_release(dcfb->fsl_dcfb_info);
+err_clk:
+	clk_disable_unprepare(dcfb->clk);
+out:
+	return ret;
+}
+
+static int fsl_dcfb_remove(struct platform_device *pdev)
+{
+	struct fsl_dcfb_fb_private *dcfb = dev_get_drvdata(&pdev->dev);
+	struct fb_info *info = dcfb->fsl_dcfb_info;
+
+	fsl_dcfb_modeset(dcfb, FSL_DCFB_MOD_OFF);
+	fsl_dcfb_free_mem(info);
+
+	unregister_framebuffer(info);
+	fb_dealloc_cmap(&info->cmap);
+	framebuffer_release(dcfb->fsl_dcfb_info);
+	clk_disable_unprepare(dcfb->clk);
+
+	return 0;
+}
+
+static struct of_device_id fsl_dcfb_dt_ids[] = {
+	{ .compatible = "fsl,ls1021a-dcfb", },
+	{}
+};
+
+static struct platform_driver fsl_dcfb_driver = {
+	.driver = {
+		.name = "fsl-dcfb",
+		.owner = THIS_MODULE,
+		.of_match_table = fsl_dcfb_dt_ids,
+	},
+	.probe = fsl_dcfb_probe,
+	.remove = fsl_dcfb_remove,
+};
+
+module_platform_driver(fsl_dcfb_driver);
+
+MODULE_DESCRIPTION("Freescale Simple Display Controller FB Driver");
+MODULE_ALIAS("platform:fsl-dcfb");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0.27.g96db324

