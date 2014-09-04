Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaIDKZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaIDKZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:25:51 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: coreboot@coreboot.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Subject: [PATCH] x86: add coreboot framebuffer support
Date: Thu,  4 Sep 2014 12:25:07 +0200
Message-Id: <1409826307-23075-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/Kconfig           |  12 +++
 arch/x86/kernel/Makefile   |   1 +
 arch/x86/kernel/coreboot.c | 232 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 arch/x86/kernel/coreboot.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 778178f..3aeb038 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2372,6 +2372,18 @@ config X86_SYSFB
 
 	  If unsure, say Y.
 
+config COREBOOT
+	bool "coreboot"
+	depends on X86_SYSFB
+	depends on FB_SIMPLE
+	help
+	  Add coreboot framebuffer support to the linux kernel.	 Say Y here
+	  if you want the linux kernel find and use the firmware framebuffer
+	  initialized by coreboot.  Useful when using the linux kernel as
+	  coreboot payload.
+
+	  If unsure, or if you don't know what coreboot is, say N.
+
 endmenu
 
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ada2e2d..4b30b0e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_UPROBES)			+= uprobes.o
 obj-y					+= sysfb.o
 obj-$(CONFIG_X86_SYSFB)			+= sysfb_simplefb.o
 obj-$(CONFIG_EFI)			+= sysfb_efi.o
+obj-$(CONFIG_COREBOOT)			+= coreboot.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
diff --git a/arch/x86/kernel/coreboot.c b/arch/x86/kernel/coreboot.c
new file mode 100644
index 0000000..44ed3fa
--- /dev/null
+++ b/arch/x86/kernel/coreboot.c
@@ -0,0 +1,232 @@
+/*
+ * Find and parse coreboot tables.  Register framebuffer if present.
+ * See src/include/boot/coreboot_tables.h in coreboot source tree.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/screen_info.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/simplefb.h>
+#include <video/vga.h>
+
+#include <asm/checksum.h>
+#include <asm/io.h>
+#include <asm/sysfb.h>
+
+struct cb_header {
+	u32     signature;
+	u32     header_bytes;
+	u32     header_checksum;
+	u32     table_bytes;
+	u32     table_checksum;
+	u32     table_entries;
+};
+
+#define CB_TAG_MAINBOARD        0x0003
+#define CB_TAG_VERSION          0x0004
+#define CB_TAG_FORWARD          0x0011
+#define CB_TAG_FRAMEBUFFER      0x0012
+
+struct cb_mainboard {
+	u8      vendor_idx;
+	u8      part_idx;
+	char    strings[0];
+};
+
+struct cb_framebuffer {
+	u64     physical_address;
+	u32     x_resolution;
+	u32     y_resolution;
+	u32     bytes_per_line;
+	u8      bits_per_pixel;
+	u8      red_mask_pos;
+	u8      red_mask_size;
+	u8      green_mask_pos;
+	u8      green_mask_size;
+	u8      blue_mask_pos;
+	u8      blue_mask_size;
+	u8      reserved_mask_pos;
+	u8      reserved_mask_size;
+};
+
+struct cb_entry {
+	u32     tag;
+	u32     size;
+	union {
+		char    string[0];
+		u64     forward;
+		struct cb_mainboard   mb;
+		struct cb_framebuffer fb;
+	} u;
+};
+
+#define CB_SIGNATURE 0x4f49424C  /* "LBIO" */
+
+/* Try to locate the coreboot header in a given address range. */
+static __init struct cb_header *coreboot_find_header(u32 addr, int len)
+{
+	struct cb_header *cbh, *copy;
+	int offset;
+	void *map;
+
+	map = ioremap(addr, len);
+	for (offset = 0; offset < len; offset += 16) {
+		cbh = map + offset;
+		if (!cbh)
+			continue;
+		if (cbh->signature != CB_SIGNATURE)
+			continue;
+		if (!cbh->table_bytes)
+			continue;
+		if (ip_compute_csum(cbh, sizeof(*cbh)) != 0)
+			continue;
+		if (ip_compute_csum(cbh + 1, cbh->table_bytes)
+		    != cbh->table_checksum)
+			continue;
+		pr_debug("coreboot: header found at 0x%x\n",
+			 addr + offset);
+		copy = kzalloc(sizeof(*cbh) + cbh->table_bytes, GFP_KERNEL);
+		memcpy(copy, cbh, sizeof(*cbh) + cbh->table_bytes);
+		iounmap(map);
+		return copy;
+	}
+	iounmap(map);
+	return NULL;
+}
+
+static __init bool check_vga_text_mode(void)
+{
+	uint8_t reg;
+
+	if (screen_info.orig_video_isVGA != 1)
+		return false;
+
+	reg = inb(VGA_GFX_I);
+	if (reg == 0xff)
+		/* no vga present */
+		return false;
+
+	outb(VGA_GFX_MISC, VGA_GFX_I);
+	reg = inb(VGA_GFX_D);
+	if (reg & 0x01)
+		/* vga is in gfx mode */
+		return false;
+
+	return true;
+}
+
+static __init void coreboot_fb_init(struct cb_framebuffer *fb)
+{
+	const char *reason = "";
+	struct simplefb_platform_data mode;
+	struct screen_info si;
+	struct resource res;
+
+	pr_info("coreboot: framebuffer: %dx%d, %d bpp, at %llx\n",
+		fb->x_resolution,
+		fb->y_resolution,
+		fb->bits_per_pixel,
+		fb->physical_address);
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
+		reason = "have vesa lfb";
+		goto skip;
+	}
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
+		reason = "have efi gop";
+		goto skip;
+	}
+	if (check_vga_text_mode()) {
+		reason = "vga is in text mode";
+		goto skip;
+	}
+
+	memset(&si, 0, sizeof(si));
+	si.orig_video_isVGA = VIDEO_TYPE_VLFB;
+	si.lfb_width        = fb->x_resolution;
+	si.lfb_height       = fb->y_resolution;
+	si.lfb_depth        = fb->bits_per_pixel;
+	si.lfb_base         = fb->physical_address;
+	si.lfb_linelength   = fb->bytes_per_line;
+	si.lfb_size         =
+		(fb->y_resolution * fb->bytes_per_line + 65535) / 65536;
+	si.pages            = 1;
+	si.red_size         = fb->red_mask_size;
+	si.red_pos          = fb->red_mask_pos;
+	si.green_size       = fb->green_mask_size;
+	si.green_pos        = fb->green_mask_pos;
+	si.blue_size        = fb->blue_mask_size;
+	si.blue_pos         = fb->blue_mask_pos;
+	si.rsvd_size        = fb->reserved_mask_size;
+	si.rsvd_pos         = fb->reserved_mask_pos;
+	if (!parse_mode(&si, &mode)) {
+		reason = "mode not compatible";
+		goto skip;
+	}
+
+	memset(&res, 0, sizeof(res));
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res.name = "coreboot-fb";
+	res.start = si.lfb_base;
+	res.end = si.lfb_base + si.lfb_size * 65536 - 1;
+
+	pr_info("coreboot: setting up simplefb\n");
+	platform_device_register_resndata(NULL, "simple-framebuffer", 0,
+					  &res, 1, &mode, sizeof(mode));
+	return;
+
+skip:
+	pr_info("coreboot: skipping framebuffer setup (%s)\n", reason);
+	return;
+}
+
+static __init int coreboot_detect(void)
+{
+	struct cb_header *cbh;
+	struct cb_entry *cbe;
+	u64 addr = 0;
+	void *next;
+	int i;
+
+newheader:
+	cbh = coreboot_find_header(addr, 0x1000);
+	if (!cbh)
+		return 0;
+
+	next = cbh + 1;
+	for (i = 0; i < cbh->table_entries; i++) {
+		cbe = next;
+		next += cbe->size;
+		switch (cbe->tag) {
+		case CB_TAG_MAINBOARD:
+			pr_info("coreboot: mainboard: %s / %s\n",
+				cbe->u.mb.strings + cbe->u.mb.vendor_idx,
+				cbe->u.mb.strings + cbe->u.mb.part_idx);
+			break;
+		case CB_TAG_VERSION:
+			pr_info("coreboot: version: %s\n",
+				cbe->u.string);
+			break;
+		case CB_TAG_FORWARD:
+			pr_debug("coreboot: forward to 0x%llx\n",
+				 cbe->u.forward);
+			addr = cbe->u.forward;
+			kfree(cbh);
+			goto newheader;
+		case CB_TAG_FRAMEBUFFER:
+			coreboot_fb_init(&cbe->u.fb);
+			break;
+		default:
+			pr_debug("%s: unhandled tag 0x%x (size %d)\n",
+				 __func__, cbe->tag, cbe->size);
+			break;
+		}
+	}
+
+	kfree(cbh);
+	return 0;
+}
+
+device_initcall(coreboot_detect);
-- 
1.8.3.1

