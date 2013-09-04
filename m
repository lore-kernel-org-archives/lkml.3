Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741Ab3IDJzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934205Ab3IDJzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:55:21 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH] add bochs dispi interface framebuffer driver
Date: Wed,  4 Sep 2013 11:54:43 +0200
Message-Id: <1378288483-16160-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds a frame buffer driver for (virtual/emulated) vga cards
implementing the bochs dispi interface.  Supported hardware are the
bochs vga card with vbe extension and the qemu standard vga.

The driver uses a fixed depth of 32bpp.  Otherwise it supports the full
(but small) feature set of the bochs dispi interface:  Resolution
switching and display panning.  It is tweaked to maximize fbcon speed,
so you'll get the comfort of the framebuffer console in kvm guests
without performance penalty.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/video/Kconfig   |  18 ++
 drivers/video/Makefile  |   1 +
 drivers/video/bochsfb.c | 460 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 479 insertions(+)
 create mode 100644 drivers/video/bochsfb.c

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4cf1e1d..3f0ead4 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -284,6 +284,24 @@ config FB_CIRRUS
 	  Say N unless you have such a graphics board or plan to get one
 	  before you next recompile the kernel.
 
+config FB_BOCHS
+	tristate "Bochs dispi interface support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  This is the frame buffer driver for (virtual/emulated) vga
+          cards implementing the bochs dispi interface.  Supported
+          hardware are the bochs vga card with vbe extension and the
+          qemu standard vga.
+
+          The driver handles the PCI variants only.  It uses a fixed
+          depth of 32bpp, anything else doesn't make sense these days.
+
+          Say Y here if you plan to run the kernel in a virtual machine
+          emulated by bochs or qemu.
+
 config FB_PM2
 	tristate "Permedia2 support"
 	depends on FB && ((AMIGA && BROKEN) || PCI)
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e8bae8d..a946a36 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_FB_GOLDFISH)         += goldfishfb.o
 obj-$(CONFIG_FB_68328)            += 68328fb.o
 obj-$(CONFIG_FB_GBE)              += gbefb.o
 obj-$(CONFIG_FB_CIRRUS)		  += cirrusfb.o
+obj-$(CONFIG_FB_BOCHS)		  += bochsfb.o
 obj-$(CONFIG_FB_ASILIANT)	  += asiliantfb.o
 obj-$(CONFIG_FB_PXA)		  += pxafb.o
 obj-$(CONFIG_FB_PXA168)		  += pxa168fb.o
diff --git a/drivers/video/bochsfb.c b/drivers/video/bochsfb.c
new file mode 100644
index 0000000..b31472e
--- /dev/null
+++ b/drivers/video/bochsfb.c
@@ -0,0 +1,460 @@
+/*
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fb.h>
+#include <linux/pm.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/console.h>
+#include <asm/io.h>
+
+#define VBE_DISPI_IOPORT_INDEX           0x01CE
+#define VBE_DISPI_IOPORT_DATA            0x01CF
+
+#define VBE_DISPI_INDEX_ID               0x0
+#define VBE_DISPI_INDEX_XRES             0x1
+#define VBE_DISPI_INDEX_YRES             0x2
+#define VBE_DISPI_INDEX_BPP              0x3
+#define VBE_DISPI_INDEX_ENABLE           0x4
+#define VBE_DISPI_INDEX_BANK             0x5
+#define VBE_DISPI_INDEX_VIRT_WIDTH       0x6
+#define VBE_DISPI_INDEX_VIRT_HEIGHT      0x7
+#define VBE_DISPI_INDEX_X_OFFSET         0x8
+#define VBE_DISPI_INDEX_Y_OFFSET         0x9
+#define VBE_DISPI_INDEX_VIDEO_MEMORY_64K 0xa
+
+#define VBE_DISPI_ID0                    0xB0C0
+#define VBE_DISPI_ID1                    0xB0C1
+#define VBE_DISPI_ID2                    0xB0C2
+#define VBE_DISPI_ID3                    0xB0C3
+#define VBE_DISPI_ID4                    0xB0C4
+#define VBE_DISPI_ID5                    0xB0C5
+
+#define VBE_DISPI_DISABLED               0x00
+#define VBE_DISPI_ENABLED                0x01
+#define VBE_DISPI_GETCAPS                0x02
+#define VBE_DISPI_8BIT_DAC               0x20
+#define VBE_DISPI_LFB_ENABLED            0x40
+#define VBE_DISPI_NOCLEARMEM             0x80
+
+enum bochs_types {
+	BOCHS_QEMU_STDVGA,
+	BOCHS_UNKNOWN,
+};
+
+static const char *bochs_names[] = {
+	[ BOCHS_QEMU_STDVGA ] = "QEMU standard vga",
+	[ BOCHS_UNKNOWN ]     = "unknown",
+};
+
+struct bochs_par {
+	void __iomem  *mmio;
+	int           ioports;
+};
+
+static struct fb_fix_screeninfo bochsfb_fix = {
+	.id          = "bochsfb",
+	.type        = FB_TYPE_PACKED_PIXELS,
+	.visual      = FB_VISUAL_TRUECOLOR,
+	.accel       = FB_ACCEL_NONE,
+	.xpanstep    = 1,
+	.ypanstep    = 1,
+};
+
+static struct fb_var_screeninfo bochsfb_var = {
+	.xres           = 1024,
+	.yres           = 768,
+	.bits_per_pixel = 32,
+#ifdef __BIG_ENDIAN
+	.transp         = { .length = 8, .offset =  0 },
+	.red            = { .length = 8, .offset =  8 },
+	.green          = { .length = 8, .offset = 16 },
+	.blue           = { .length = 8, .offset = 24 },
+#else
+	.transp         = { .length = 8, .offset = 24 },
+	.red            = { .length = 8, .offset = 16 },
+	.green          = { .length = 8, .offset =  8 },
+	.blue           = { .length = 8, .offset =  0 },
+#endif
+	.height         = -1,
+	.width          = -1,
+	.vmode          = FB_VMODE_NONINTERLACED,
+	.pixclock       = 10000,
+	.left_margin    = 16,
+	.right_margin   = 16,
+	.upper_margin   = 16,
+	.lower_margin   = 16,
+	.hsync_len      = 8,
+	.vsync_len      = 8,
+};
+
+static char *mode;
+module_param(mode, charp, 0);
+MODULE_PARM_DESC(mode, "Initial video mode, default is '1024x768'");
+
+static u16 bochs_read(struct fb_info *info, u16 reg)
+{
+	struct bochs_par *bochs = info->par;
+	u16 ret = 0;
+
+	if (bochs->mmio) {
+		int offset = 0x500 + (reg << 1);
+		ret = readw(bochs->mmio + offset);
+	} else {
+		outw(reg, VBE_DISPI_IOPORT_INDEX);
+		ret = inw(VBE_DISPI_IOPORT_DATA);
+	}
+	return ret;
+}
+
+static void bochs_write(struct fb_info *info, u16 reg, u16 val)
+{
+	struct bochs_par *bochs = info->par;
+
+	if (bochs->mmio) {
+		int offset = 0x500 + (reg << 1);
+		writew(val, bochs->mmio + offset);
+	} else {
+		outw(reg, VBE_DISPI_IOPORT_INDEX);
+		outw(val, VBE_DISPI_IOPORT_DATA);
+	}
+}
+
+static int bochsfb_check_var(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
+{
+	uint32_t x,y, xv,yv, pixels;
+
+	if (var->bits_per_pixel != 32 ||
+	    var->xres > 65535 ||
+	    var->xres_virtual > 65535 ||
+	    (var->vmode & FB_VMODE_MASK) != FB_VMODE_NONINTERLACED)
+		return -EINVAL;
+
+	x  = var->xres;
+	y  = var->yres;
+	xv = var->xres_virtual;
+	yv = var->yres_virtual;
+	if (xv < x)
+		xv = x;
+	pixels = info->fix.smem_len * 8 / info->var.bits_per_pixel;
+	yv = pixels / xv;
+	if (y > yv)
+		return -EINVAL;
+
+	var->xres = x;
+	var->yres = y;
+	var->xres_virtual = xv;
+	var->yres_virtual = yv;
+	var->xoffset = 0;
+	var->yoffset = 0;
+
+	return 0;
+}
+
+static int bochsfb_set_par(struct fb_info *info)
+{
+	dev_dbg(info->dev, "set mode: real: %dx%d, virtual: %dx%d\n",
+		info->var.xres, info->var.yres,
+		info->var.xres_virtual, info->var.yres_virtual);
+
+	info->fix.line_length = info->var.xres * info->var.bits_per_pixel / 8;
+
+	bochs_write(info, VBE_DISPI_INDEX_BPP,         info->var.bits_per_pixel);
+	bochs_write(info, VBE_DISPI_INDEX_XRES,        info->var.xres);
+	bochs_write(info, VBE_DISPI_INDEX_YRES,        info->var.yres);
+	bochs_write(info, VBE_DISPI_INDEX_BANK,        0);
+	bochs_write(info, VBE_DISPI_INDEX_VIRT_WIDTH,  info->var.xres_virtual);
+	bochs_write(info, VBE_DISPI_INDEX_VIRT_HEIGHT, info->var.yres_virtual);
+	bochs_write(info, VBE_DISPI_INDEX_X_OFFSET,    info->var.xoffset);
+	bochs_write(info, VBE_DISPI_INDEX_Y_OFFSET,    info->var.yoffset);
+
+	bochs_write(info, VBE_DISPI_INDEX_ENABLE,
+		    VBE_DISPI_ENABLED | VBE_DISPI_LFB_ENABLED);
+	return 0;
+}
+
+static int bochsfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			     unsigned blue, unsigned transp,
+			     struct fb_info *info)
+{
+	if (regno < 16 && info->var.bits_per_pixel == 32) {
+		red   >>= 8;
+		green >>= 8;
+		blue  >>= 8;
+		((u32 *)(info->pseudo_palette))[regno] =
+			(red   << info->var.red.offset)   |
+			(green << info->var.green.offset) |
+			(blue  << info->var.blue.offset);
+	}
+	return 0;
+}
+
+static int bochsfb_pan_display(struct fb_var_screeninfo *var,
+			       struct fb_info *info)
+{
+	bochs_write(info, VBE_DISPI_INDEX_X_OFFSET, var->xoffset);
+	bochs_write(info, VBE_DISPI_INDEX_Y_OFFSET, var->yoffset);
+	return 0;
+}
+
+static struct fb_ops bochsfb_ops = {
+	.owner	        = THIS_MODULE,
+	.fb_check_var   = bochsfb_check_var,
+	.fb_set_par     = bochsfb_set_par,
+	.fb_setcolreg   = bochsfb_setcolreg,
+	.fb_pan_display = bochsfb_pan_display,
+	.fb_fillrect    = cfb_fillrect,
+	.fb_copyarea    = cfb_copyarea,
+	.fb_imageblit   = cfb_imageblit,
+};
+
+static int
+bochsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
+{
+	struct fb_info *p;
+	unsigned long addr, size, mem, ioaddr, iosize;
+	struct bochs_par *bochs;
+	u16 id;
+	int rc = -ENODEV;
+
+	p = framebuffer_alloc(sizeof(struct bochs_par), &dp->dev);
+	if (p == NULL) {
+		dev_err(&dp->dev, "Cannot allocate framebuffer structure\n");
+		return -ENOMEM;
+	}
+	bochs = p->par;
+
+	if (pci_enable_device(dp) < 0) {
+		dev_err(&dp->dev, "Cannot enable PCI device\n");
+		goto err_out;
+	}
+
+	if ((ent->driver_data == BOCHS_QEMU_STDVGA) &&
+	    (dp->resource[2].flags & IORESOURCE_MEM)) {
+		/* mmio bar with vga and bochs registers present */
+		if (pci_request_region(dp, 2, "bochsfb") != 0) {
+ 			dev_err(&dp->dev, "Cannot request mmio region\n");
+			rc = -EBUSY;
+			goto err_out;
+		}
+		ioaddr = pci_resource_start(dp, 2);
+		iosize = pci_resource_len(dp, 2);
+		bochs->mmio = ioremap(ioaddr, iosize);
+		if (bochs->mmio == NULL) {
+			dev_err(&dp->dev, "Cannot map mmio region\n");
+			rc = -ENOMEM;
+			goto err_out;
+		}
+	} else {
+		ioaddr = VBE_DISPI_IOPORT_INDEX;
+		iosize = 2;
+		if (!request_region(ioaddr, iosize, "bochsfb")) {
+			dev_err(&dp->dev, "Cannot request ioports\n");
+			rc = -EBUSY;
+			goto err_out;
+		}
+		bochs->ioports = 1;
+	}
+
+	id = bochs_read(p, VBE_DISPI_INDEX_ID);
+	mem = bochs_read(p, VBE_DISPI_INDEX_VIDEO_MEMORY_64K) * 64 * 1024;
+	if ((id & 0xfff0) != VBE_DISPI_ID0) {
+		dev_err(&dp->dev, "ID mismatch\n");
+		goto err_out;
+	}
+
+	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
+		goto err_out;
+	addr = pci_resource_start(dp, 0);
+	size = pci_resource_len(dp, 0);
+	if (addr == 0)
+		goto err_out;
+	if (size != mem) {
+		dev_err(&dp->dev, "Size mismatch: pci=%ld, bochs=%ld\n", size, mem);
+		size = min(size, mem);
+	}
+
+	p->apertures = alloc_apertures(1);
+	if (!p->apertures) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+	p->apertures->ranges[0].base = addr;
+	p->apertures->ranges[0].size = size;
+	remove_conflicting_framebuffers(p->apertures, "bochsfb", false);
+
+	if (pci_request_region(dp, 0, "bochsfb") != 0) {
+		dev_err(&dp->dev, "Cannot request framebuffer\n");
+		rc = -EBUSY;
+		goto err_out;
+	}
+
+	p->screen_base = ioremap(addr, size);
+	if (p->screen_base == NULL) {
+		dev_err(&dp->dev, "Cannot map framebuffer\n");
+		rc = -ENOMEM;
+		goto err_out;
+	}
+	memset(p->screen_base, 0, size);
+
+	dev_info(&dp->dev,"Found bochs VGA, ID 0x%x, type \"%s\".\n",
+		 id, bochs_names[ent->driver_data]);
+	dev_info(&dp->dev,"Framebuffer size %ld kB @ 0x%lx, %s @ 0x%lx.\n",
+		 size / 1024, addr,
+		 bochs->ioports ? "ioports" : "mmio",
+		 ioaddr);
+
+	pci_set_drvdata(dp, p);
+	p->fbops = &bochsfb_ops;
+	p->flags = FBINFO_FLAG_DEFAULT
+		| FBINFO_READS_FAST
+		| FBINFO_HWACCEL_XPAN
+		| FBINFO_HWACCEL_YPAN;
+	p->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
+	p->fix = bochsfb_fix;
+	p->fix.smem_start = addr;
+	p->fix.smem_len = size;
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ||
+	    screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
+		dev_info(&dp->dev,"Picking up default res %dx%d from %s.\n",
+			 screen_info.lfb_width, screen_info.lfb_height,
+			 screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ?
+			 "vesa" : "efi");
+		screen_info.orig_video_isVGA = 0;
+		bochsfb_var.xres = screen_info.lfb_width;
+		bochsfb_var.yres = screen_info.lfb_height;
+	}
+
+	p->var = bochsfb_var;
+	bochsfb_check_var(&p->var, p);
+	if (mode) {
+		dev_info(&dp->dev,"Looking up configured res \"%s\" in modedb.\n",
+			 mode);
+		fb_find_mode(&p->var, p, mode, NULL, 0, NULL, 32);
+	}
+
+	if (register_framebuffer(p) < 0) {
+		dev_err(&dp->dev,"Framebuffer failed to register\n");
+		goto err_out;
+	}
+
+	dev_info(&dp->dev,"fb%d: bochs VGA frame buffer initialized.\n",
+		 p->node);
+
+	return 0;
+
+err_out:
+	if (bochs->mmio)
+		iounmap(bochs->mmio);
+	if (bochs->ioports)
+		release_region(VBE_DISPI_IOPORT_INDEX, 2);
+	if (p->screen_base)
+		iounmap(p->screen_base);
+	pci_release_regions(dp);
+	framebuffer_release(p);
+	return rc;
+}
+
+static void bochsfb_remove(struct pci_dev *dp)
+{
+	struct fb_info *p = pci_get_drvdata(dp);
+	struct bochs_par *bochs = p->par;
+
+	if (p->screen_base == NULL)
+		return;
+	unregister_framebuffer(p);
+	if (bochs->mmio)
+		iounmap(bochs->mmio);
+	if (bochs->ioports)
+		release_region(VBE_DISPI_IOPORT_INDEX, 2);
+	if (p->screen_base)
+		iounmap(p->screen_base);
+	pci_release_regions(dp);
+	kfree(p->pseudo_palette);
+	framebuffer_release(p);
+}
+
+static struct pci_device_id bochsfb_pci_tbl[] = {
+	{
+		.vendor      = 0x1234,
+		.device      = 0x1111,
+		.subvendor   = 0x1af4,
+		.subdevice   = 0x1100,
+		.driver_data = BOCHS_QEMU_STDVGA,
+	},
+	{
+		.vendor      = 0x1234,
+		.device      = 0x1111,
+		.subvendor   = PCI_ANY_ID,
+		.subdevice   = PCI_ANY_ID,
+		.driver_data = BOCHS_UNKNOWN,
+	},
+	{ /* end of list */ }
+};
+
+MODULE_DEVICE_TABLE(pci, bochsfb_pci_tbl);
+
+static struct pci_driver bochsfb_driver = {
+	.name =		"bochsfb",
+	.id_table =	bochsfb_pci_tbl,
+	.probe =	bochsfb_pci_init,
+	.remove =	bochsfb_remove,
+};
+
+#ifndef MODULE
+static int __init bochsfb_setup(char *options)
+{
+	char *this_opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((this_opt = strsep(&options, ",")) != NULL) {
+		if (!*this_opt)
+			continue;
+		if (!strncmp(this_opt, "mode:", 5))
+			mode = this_opt + 5;
+		else
+			mode = this_opt;
+	}
+	return 0;
+}
+#endif
+
+int __init bochs_init(void)
+{
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("bochsfb", &option))
+		return -ENODEV;
+	bochsfb_setup(option);
+#endif
+	return pci_register_driver(&bochsfb_driver);
+}
+
+module_init(bochs_init);
+
+static void __exit bochsfb_exit(void)
+{
+	pci_unregister_driver(&bochsfb_driver);
+}
+
+module_exit(bochsfb_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Gerd Hoffmann <kraxel@redhat.com>");
+MODULE_DESCRIPTION("bochs dispi interface framebuffer driver");
-- 
1.8.3.1

