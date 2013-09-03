Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3ICO5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:57:33 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45784 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3ICO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:57:31 -0400
Date: Tue, 3 Sep 2013 16:57:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fb changes for v3.12
Message-ID: <20130903145727.GA29463@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fb-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fb-for-linus

   HEAD: 765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92 fbdev: fbcon: select VT_HW_CONSOLE_BINDING

This tree includes preparatory patches for SimpleDRM driver support, by 
David Herrmann. They clean up x86 framebuffer support by creating simplefb 
devices wherever possible. More background can be found at:

   http://lwn.net/Articles/558104/

out-of-topic modifications in x86-fb-for-linus:
-----------------------------------------------
drivers/video/Kconfig              # 5ef76da: fbdev: simplefb: add init through
drivers/video/console/Kconfig      # 765d5b9: fbdev: fbcon: select VT_HW_CONSOL
drivers/video/efifb.c              # e6816a8: fbdev: efifb: bind to efi-framebu
                                   # 2995e50: x86: sysfb: move EFI quirks from 
drivers/video/simplefb.c           # df0960a: fbdev: simplefb: mark as fw and a
                                   # 5ef76da: fbdev: simplefb: add init through
drivers/video/vesafb.c             # 2e5155e: fbdev: vesafb: bind to platform-f
include/linux/platform_data/simplefb.h# 9a6a36d: fbdev: simplefb: add common x86 R
                                   # 5ef76da: fbdev: simplefb: add init through

 Thanks,

	Ingo

------------------>
David Herrmann (8):
      fbdev: simplefb: add init through platform_data
      fbdev: simplefb: mark as fw and allocate apertures
      x86: provide platform-devices for boot-framebuffers
      x86: sysfb: move EFI quirks from efifb to sysfb
      fbdev: simplefb: add common x86 RGB formats
      fbdev: vesafb: bind to platform-framebuffer device
      fbdev: efifb: bind to efi-framebuffer
      fbdev: fbcon: select VT_HW_CONSOLE_BINDING


 arch/x86/Kconfig                       |  26 +++
 arch/x86/include/asm/sysfb.h           |  98 +++++++++++
 arch/x86/kernel/Makefile               |   3 +
 arch/x86/kernel/sysfb.c                |  74 ++++++++
 arch/x86/kernel/sysfb_efi.c            | 214 +++++++++++++++++++++++
 arch/x86/kernel/sysfb_simplefb.c       |  95 +++++++++++
 drivers/video/Kconfig                  |   5 +-
 drivers/video/console/Kconfig          |   3 +-
 drivers/video/efifb.c                  | 302 ++++-----------------------------
 drivers/video/simplefb.c               |  58 +++++--
 drivers/video/vesafb.c                 |  55 ++----
 include/linux/platform_data/simplefb.h |  63 +++++++
 12 files changed, 666 insertions(+), 330 deletions(-)
 create mode 100644 arch/x86/include/asm/sysfb.h
 create mode 100644 arch/x86/kernel/sysfb.c
 create mode 100644 arch/x86/kernel/sysfb_efi.c
 create mode 100644 arch/x86/kernel/sysfb_simplefb.c
 create mode 100644 include/linux/platform_data/simplefb.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..5c56559 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2270,6 +2270,32 @@ config RAPIDIO
 
 source "drivers/rapidio/Kconfig"
 
+config X86_SYSFB
+	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
+	help
+	  Firmwares often provide initial graphics framebuffers so the BIOS,
+	  bootloader or kernel can show basic video-output during boot for
+	  user-guidance and debugging. Historically, x86 used the VESA BIOS
+	  Extensions and EFI-framebuffers for this, which are mostly limited
+	  to x86.
+	  This option, if enabled, marks VGA/VBE/EFI framebuffers as generic
+	  framebuffers so the new generic system-framebuffer drivers can be
+	  used on x86. If the framebuffer is not compatible with the generic
+	  modes, it is adverticed as fallback platform framebuffer so legacy
+	  drivers like efifb, vesafb and uvesafb can pick it up.
+	  If this option is not selected, all system framebuffers are always
+	  marked as fallback platform framebuffers as usual.
+
+	  Note: Legacy fbdev drivers, including vesafb, efifb, uvesafb, will
+	  not be able to pick up generic system framebuffers if this option
+	  is selected. You are highly encouraged to enable simplefb as
+	  replacement if you select this option. simplefb can correctly deal
+	  with generic system framebuffers. But you should still keep vesafb
+	  and others enabled as fallback if a system framebuffer is
+	  incompatible with simplefb.
+
+	  If unsure, say Y.
+
 endmenu
 
 
diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
new file mode 100644
index 0000000..2aeb3e2
--- /dev/null
+++ b/arch/x86/include/asm/sysfb.h
@@ -0,0 +1,98 @@
+#ifndef _ARCH_X86_KERNEL_SYSFB_H
+#define _ARCH_X86_KERNEL_SYSFB_H
+
+/*
+ * Generic System Framebuffers on x86
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_data/simplefb.h>
+#include <linux/screen_info.h>
+
+enum {
+	M_I17,		/* 17-Inch iMac */
+	M_I20,		/* 20-Inch iMac */
+	M_I20_SR,	/* 20-Inch iMac (Santa Rosa) */
+	M_I24,		/* 24-Inch iMac */
+	M_I24_8_1,	/* 24-Inch iMac, 8,1th gen */
+	M_I24_10_1,	/* 24-Inch iMac, 10,1th gen */
+	M_I27_11_1,	/* 27-Inch iMac, 11,1th gen */
+	M_MINI,		/* Mac Mini */
+	M_MINI_3_1,	/* Mac Mini, 3,1th gen */
+	M_MINI_4_1,	/* Mac Mini, 4,1th gen */
+	M_MB,		/* MacBook */
+	M_MB_2,		/* MacBook, 2nd rev. */
+	M_MB_3,		/* MacBook, 3rd rev. */
+	M_MB_5_1,	/* MacBook, 5th rev. */
+	M_MB_6_1,	/* MacBook, 6th rev. */
+	M_MB_7_1,	/* MacBook, 7th rev. */
+	M_MB_SR,	/* MacBook, 2nd gen, (Santa Rosa) */
+	M_MBA,		/* MacBook Air */
+	M_MBA_3,	/* Macbook Air, 3rd rev */
+	M_MBP,		/* MacBook Pro */
+	M_MBP_2,	/* MacBook Pro 2nd gen */
+	M_MBP_2_2,	/* MacBook Pro 2,2nd gen */
+	M_MBP_SR,	/* MacBook Pro (Santa Rosa) */
+	M_MBP_4,	/* MacBook Pro, 4th gen */
+	M_MBP_5_1,	/* MacBook Pro, 5,1th gen */
+	M_MBP_5_2,	/* MacBook Pro, 5,2th gen */
+	M_MBP_5_3,	/* MacBook Pro, 5,3rd gen */
+	M_MBP_6_1,	/* MacBook Pro, 6,1th gen */
+	M_MBP_6_2,	/* MacBook Pro, 6,2th gen */
+	M_MBP_7_1,	/* MacBook Pro, 7,1th gen */
+	M_MBP_8_2,	/* MacBook Pro, 8,2nd gen */
+	M_UNKNOWN	/* placeholder */
+};
+
+struct efifb_dmi_info {
+	char *optname;
+	unsigned long base;
+	int stride;
+	int width;
+	int height;
+	int flags;
+};
+
+#ifdef CONFIG_EFI
+
+extern struct efifb_dmi_info efifb_dmi_list[];
+void sysfb_apply_efi_quirks(void);
+
+#else /* CONFIG_EFI */
+
+static inline void sysfb_apply_efi_quirks(void)
+{
+}
+
+#endif /* CONFIG_EFI */
+
+#ifdef CONFIG_X86_SYSFB
+
+bool parse_mode(const struct screen_info *si,
+		struct simplefb_platform_data *mode);
+int create_simplefb(const struct screen_info *si,
+		    const struct simplefb_platform_data *mode);
+
+#else /* CONFIG_X86_SYSFB */
+
+static inline bool parse_mode(const struct screen_info *si,
+			      struct simplefb_platform_data *mode)
+{
+	return false;
+}
+
+static inline int create_simplefb(const struct screen_info *si,
+				  const struct simplefb_platform_data *mode)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_X86_SYSFB */
+
+#endif /* _ARCH_X86_KERNEL_SYSFB_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 88d99ea..a5408b9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -103,6 +103,9 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
+obj-y					+= sysfb.o
+obj-$(CONFIG_X86_SYSFB)			+= sysfb_simplefb.o
+obj-$(CONFIG_EFI)			+= sysfb_efi.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
new file mode 100644
index 0000000..193ec2c
--- /dev/null
+++ b/arch/x86/kernel/sysfb.c
@@ -0,0 +1,74 @@
+/*
+ * Generic System Framebuffers on x86
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * Simple-Framebuffer support for x86 systems
+ * Create a platform-device for any available boot framebuffer. The
+ * simple-framebuffer platform device is already available on DT systems, so
+ * this module parses the global "screen_info" object and creates a suitable
+ * platform device compatible with the "simple-framebuffer" DT object. If
+ * the framebuffer is incompatible, we instead create a legacy
+ * "vesa-framebuffer", "efi-framebuffer" or "platform-framebuffer" device and
+ * pass the screen_info as platform_data. This allows legacy drivers
+ * to pick these devices up without messing with simple-framebuffer drivers.
+ * The global "screen_info" is still valid at all times.
+ *
+ * If CONFIG_X86_SYSFB is not selected, we never register "simple-framebuffer"
+ * platform devices, but only use legacy framebuffer devices for
+ * backwards compatibility.
+ *
+ * TODO: We set the dev_id field of all platform-devices to 0. This allows
+ * other x86 OF/DT parsers to create such devices, too. However, they must
+ * start at offset 1 for this to work.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/platform_data/simplefb.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+#include <asm/sysfb.h>
+
+static __init int sysfb_init(void)
+{
+	struct screen_info *si = &screen_info;
+	struct simplefb_platform_data mode;
+	struct platform_device *pd;
+	const char *name;
+	bool compatible;
+	int ret;
+
+	sysfb_apply_efi_quirks();
+
+	/* try to create a simple-framebuffer device */
+	compatible = parse_mode(si, &mode);
+	if (compatible) {
+		ret = create_simplefb(si, &mode);
+		if (!ret)
+			return 0;
+	}
+
+	/* if the FB is incompatible, create a legacy framebuffer device */
+	if (si->orig_video_isVGA == VIDEO_TYPE_EFI)
+		name = "efi-framebuffer";
+	else if (si->orig_video_isVGA == VIDEO_TYPE_VLFB)
+		name = "vesa-framebuffer";
+	else
+		name = "platform-framebuffer";
+
+	pd = platform_device_register_resndata(NULL, name, 0,
+					       NULL, 0, si, sizeof(*si));
+	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+}
+
+/* must execute after PCI subsystem for EFI quirks */
+device_initcall(sysfb_init);
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
new file mode 100644
index 0000000..b285d4e
--- /dev/null
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -0,0 +1,214 @@
+/*
+ * Generic System Framebuffers on x86
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * EFI Quirks Copyright (c) 2006 Edgar Hucek <gimli@dark-green.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * EFI Quirks
+ * Several EFI systems do not correctly advertise their boot framebuffers.
+ * Hence, we use this static table of known broken machines and fix up the
+ * information so framebuffer drivers can load corectly.
+ */
+
+#include <linux/dmi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/screen_info.h>
+#include <video/vga.h>
+#include <asm/sysfb.h>
+
+enum {
+	OVERRIDE_NONE = 0x0,
+	OVERRIDE_BASE = 0x1,
+	OVERRIDE_STRIDE = 0x2,
+	OVERRIDE_HEIGHT = 0x4,
+	OVERRIDE_WIDTH = 0x8,
+};
+
+struct efifb_dmi_info efifb_dmi_list[] = {
+	[M_I17] = { "i17", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE }, /* guess */
+	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE },
+	[M_I24] = { "i24", 0x80010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE }, /* guess */
+	[M_I24_8_1] = { "imac8", 0xc0060000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
+	[M_I24_10_1] = { "imac10", 0xc0010000, 2048 * 4, 1920, 1080, OVERRIDE_NONE },
+	[M_I27_11_1] = { "imac11", 0xc0010000, 2560 * 4, 2560, 1440, OVERRIDE_NONE },
+	[M_MINI]= { "mini", 0x80000000, 2048 * 4, 1024, 768, OVERRIDE_NONE },
+	[M_MINI_3_1] = { "mini31", 0x40010000, 1024 * 4, 1024, 768, OVERRIDE_NONE },
+	[M_MINI_4_1] = { "mini41", 0xc0010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
+	[M_MB] = { "macbook", 0x80000000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	[M_MB_5_1] = { "macbook51", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	[M_MB_6_1] = { "macbook61", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	[M_MB_7_1] = { "macbook71", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	[M_MBA] = { "mba", 0x80000000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	/* 11" Macbook Air 3,1 passes the wrong stride */
+	[M_MBA_3] = { "mba3", 0, 2048 * 4, 0, 0, OVERRIDE_STRIDE },
+	[M_MBP] = { "mbp", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_MBP_2] = { "mbp2", 0, 0, 0, 0, OVERRIDE_NONE }, /* placeholder */
+	[M_MBP_2_2] = { "mbp22", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
+	[M_MBP_5_1] = { "mbp51", 0xc0010000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_MBP_5_2] = { "mbp52", 0xc0010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
+	[M_MBP_5_3] = { "mbp53", 0xd0010000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_MBP_6_1] = { "mbp61", 0x90030000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
+	[M_MBP_6_2] = { "mbp62", 0x90030000, 2048 * 4, 1680, 1050, OVERRIDE_NONE },
+	[M_MBP_7_1] = { "mbp71", 0xc0010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
+	[M_MBP_8_2] = { "mbp82", 0x90010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
+	[M_UNKNOWN] = { NULL, 0, 0, 0, 0, OVERRIDE_NONE }
+};
+
+#define choose_value(dmivalue, fwvalue, field, flags) ({	\
+		typeof(fwvalue) _ret_ = fwvalue;		\
+		if ((flags) & (field))				\
+			_ret_ = dmivalue;			\
+		else if ((fwvalue) == 0)			\
+			_ret_ = dmivalue;			\
+		_ret_;						\
+	})
+
+static int __init efifb_set_system(const struct dmi_system_id *id)
+{
+	struct efifb_dmi_info *info = id->driver_data;
+
+	if (info->base == 0 && info->height == 0 && info->width == 0 &&
+	    info->stride == 0)
+		return 0;
+
+	/* Trust the bootloader over the DMI tables */
+	if (screen_info.lfb_base == 0) {
+#if defined(CONFIG_PCI)
+		struct pci_dev *dev = NULL;
+		int found_bar = 0;
+#endif
+		if (info->base) {
+			screen_info.lfb_base = choose_value(info->base,
+				screen_info.lfb_base, OVERRIDE_BASE,
+				info->flags);
+
+#if defined(CONFIG_PCI)
+			/* make sure that the address in the table is actually
+			 * on a VGA device's PCI BAR */
+
+			for_each_pci_dev(dev) {
+				int i;
+				if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+					continue;
+				for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+					resource_size_t start, end;
+
+					start = pci_resource_start(dev, i);
+					if (start == 0)
+						break;
+					end = pci_resource_end(dev, i);
+					if (screen_info.lfb_base >= start &&
+					    screen_info.lfb_base < end) {
+						found_bar = 1;
+					}
+				}
+			}
+			if (!found_bar)
+				screen_info.lfb_base = 0;
+#endif
+		}
+	}
+	if (screen_info.lfb_base) {
+		screen_info.lfb_linelength = choose_value(info->stride,
+			screen_info.lfb_linelength, OVERRIDE_STRIDE,
+			info->flags);
+		screen_info.lfb_width = choose_value(info->width,
+			screen_info.lfb_width, OVERRIDE_WIDTH,
+			info->flags);
+		screen_info.lfb_height = choose_value(info->height,
+			screen_info.lfb_height, OVERRIDE_HEIGHT,
+			info->flags);
+		if (screen_info.orig_video_isVGA == 0)
+			screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
+	} else {
+		screen_info.lfb_linelength = 0;
+		screen_info.lfb_width = 0;
+		screen_info.lfb_height = 0;
+		screen_info.orig_video_isVGA = 0;
+		return 0;
+	}
+
+	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at 0x%08x "
+			 "(%dx%d, stride %d)\n", id->ident,
+			 screen_info.lfb_base, screen_info.lfb_width,
+			 screen_info.lfb_height, screen_info.lfb_linelength);
+
+	return 1;
+}
+
+#define EFIFB_DMI_SYSTEM_ID(vendor, name, enumid)		\
+	{							\
+		efifb_set_system,				\
+		name,						\
+		{						\
+			DMI_MATCH(DMI_BIOS_VENDOR, vendor),	\
+			DMI_MATCH(DMI_PRODUCT_NAME, name)	\
+		},						\
+		&efifb_dmi_list[enumid]				\
+	}
+
+static const struct dmi_system_id efifb_dmi_system_table[] __initconst = {
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
+	/* At least one of these two will be right; maybe both? */
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac5,1", M_I20),
+	/* At least one of these two will be right; maybe both? */
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac6,1", M_I24),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac6,1", M_I24),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac7,1", M_I20_SR),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac8,1", M_I24_8_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac10,1", M_I24_10_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac11,1", M_I27_11_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "Macmini1,1", M_MINI),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini3,1", M_MINI_3_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini4,1", M_MINI_4_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook1,1", M_MB),
+	/* At least one of these two will be right; maybe both? */
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook2,1", M_MB),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook2,1", M_MB),
+	/* At least one of these two will be right; maybe both? */
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook3,1", M_MB),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook3,1", M_MB),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook4,1", M_MB),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook5,1", M_MB_5_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook6,1", M_MB_6_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook7,1", M_MB_7_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir1,1", M_MBA),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir3,1", M_MBA_3),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro1,1", M_MBP),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,1", M_MBP_2),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,2", M_MBP_2_2),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro2,1", M_MBP_2),
+	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,2", M_MBP_5_2),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,3", M_MBP_5_3),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,1", M_MBP_6_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,2", M_MBP_6_2),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro7,1", M_MBP_7_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro8,2", M_MBP_8_2),
+	{},
+};
+
+__init void sysfb_apply_efi_quirks(void)
+{
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
+	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
+		dmi_check_system(efifb_dmi_system_table);
+}
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
new file mode 100644
index 0000000..22513e9
--- /dev/null
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -0,0 +1,95 @@
+/*
+ * Generic System Framebuffers on x86
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * simple-framebuffer probing
+ * Try to convert "screen_info" into a "simple-framebuffer" compatible mode.
+ * If the mode is incompatible, we return "false" and let the caller create
+ * legacy nodes instead.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/platform_data/simplefb.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+#include <asm/sysfb.h>
+
+static const char simplefb_resname[] = "BOOTFB";
+static const struct simplefb_format formats[] = SIMPLEFB_FORMATS;
+
+/* try parsing x86 screen_info into a simple-framebuffer mode struct */
+__init bool parse_mode(const struct screen_info *si,
+		       struct simplefb_platform_data *mode)
+{
+	const struct simplefb_format *f;
+	__u8 type;
+	unsigned int i;
+
+	type = si->orig_video_isVGA;
+	if (type != VIDEO_TYPE_VLFB && type != VIDEO_TYPE_EFI)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		f = &formats[i];
+		if (si->lfb_depth == f->bits_per_pixel &&
+		    si->red_size == f->red.length &&
+		    si->red_pos == f->red.offset &&
+		    si->green_size == f->green.length &&
+		    si->green_pos == f->green.offset &&
+		    si->blue_size == f->blue.length &&
+		    si->blue_pos == f->blue.offset &&
+		    si->rsvd_size == f->transp.length &&
+		    si->rsvd_pos == f->transp.offset) {
+			mode->format = f->name;
+			mode->width = si->lfb_width;
+			mode->height = si->lfb_height;
+			mode->stride = si->lfb_linelength;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+__init int create_simplefb(const struct screen_info *si,
+			   const struct simplefb_platform_data *mode)
+{
+	struct platform_device *pd;
+	struct resource res;
+	unsigned long len;
+
+	/* don't use lfb_size as it may contain the whole VMEM instead of only
+	 * the part that is occupied by the framebuffer */
+	len = mode->height * mode->stride;
+	len = PAGE_ALIGN(len);
+	if (len > si->lfb_size << 16) {
+		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
+		return -EINVAL;
+	}
+
+	/* setup IORESOURCE_MEM as framebuffer memory */
+	memset(&res, 0, sizeof(res));
+	res.flags = IORESOURCE_MEM;
+	res.name = simplefb_resname;
+	res.start = si->lfb_base;
+	res.end = si->lfb_base + len - 1;
+	if (res.end <= res.start)
+		return -EINVAL;
+
+	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
+					       &res, 1, mode, sizeof(*mode));
+	if (IS_ERR(pd))
+		return PTR_ERR(pd);
+
+	return 0;
+}
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4cf1e1d..34c3d96 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2457,7 +2457,7 @@ config FB_HYPERV
 
 config FB_SIMPLE
 	bool "Simple framebuffer support"
-	depends on (FB = y) && OF
+	depends on (FB = y)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -2469,8 +2469,7 @@ config FB_SIMPLE
 	  pre-allocated frame buffer surface.
 
 	  Configuration re: surface address, size, and format must be provided
-	  through device tree, or potentially plain old platform data in the
-	  future.
+	  through device tree, or plain old platform data.
 
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 8c30603..846caab 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -92,7 +92,8 @@ config DUMMY_CONSOLE_ROWS
 
 config FRAMEBUFFER_CONSOLE
 	tristate "Framebuffer Console support"
-	depends on FB
+	depends on FB && !UML
+	select VT_HW_CONSOLE_BINDING
 	select CRC32
 	select FONT_SUPPORT
 	help
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 50fe668..2a8286e 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -15,6 +15,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <video/vga.h>
+#include <asm/sysfb.h>
 
 static bool request_mem_succeeded = false;
 
@@ -38,223 +39,6 @@ static struct fb_fix_screeninfo efifb_fix = {
 	.visual			= FB_VISUAL_TRUECOLOR,
 };
 
-enum {
-	M_I17,		/* 17-Inch iMac */
-	M_I20,		/* 20-Inch iMac */
-	M_I20_SR,	/* 20-Inch iMac (Santa Rosa) */
-	M_I24,		/* 24-Inch iMac */
-	M_I24_8_1,	/* 24-Inch iMac, 8,1th gen */
-	M_I24_10_1,	/* 24-Inch iMac, 10,1th gen */
-	M_I27_11_1,	/* 27-Inch iMac, 11,1th gen */
-	M_MINI,		/* Mac Mini */
-	M_MINI_3_1,	/* Mac Mini, 3,1th gen */
-	M_MINI_4_1,	/* Mac Mini, 4,1th gen */
-	M_MB,		/* MacBook */
-	M_MB_2,		/* MacBook, 2nd rev. */
-	M_MB_3,		/* MacBook, 3rd rev. */
-	M_MB_5_1,	/* MacBook, 5th rev. */
-	M_MB_6_1,	/* MacBook, 6th rev. */
-	M_MB_7_1,	/* MacBook, 7th rev. */
-	M_MB_SR,	/* MacBook, 2nd gen, (Santa Rosa) */
-	M_MBA,		/* MacBook Air */
-	M_MBA_3,	/* Macbook Air, 3rd rev */
-	M_MBP,		/* MacBook Pro */
-	M_MBP_2,	/* MacBook Pro 2nd gen */
-	M_MBP_2_2,	/* MacBook Pro 2,2nd gen */
-	M_MBP_SR,	/* MacBook Pro (Santa Rosa) */
-	M_MBP_4,	/* MacBook Pro, 4th gen */
-	M_MBP_5_1,    /* MacBook Pro, 5,1th gen */
-	M_MBP_5_2,	/* MacBook Pro, 5,2th gen */
-	M_MBP_5_3,	/* MacBook Pro, 5,3rd gen */
-	M_MBP_6_1,	/* MacBook Pro, 6,1th gen */
-	M_MBP_6_2,	/* MacBook Pro, 6,2th gen */
-	M_MBP_7_1,	/* MacBook Pro, 7,1th gen */
-	M_MBP_8_2,	/* MacBook Pro, 8,2nd gen */
-	M_UNKNOWN	/* placeholder */
-};
-
-#define OVERRIDE_NONE	0x0
-#define OVERRIDE_BASE	0x1
-#define OVERRIDE_STRIDE	0x2
-#define OVERRIDE_HEIGHT	0x4
-#define OVERRIDE_WIDTH	0x8
-
-static struct efifb_dmi_info {
-	char *optname;
-	unsigned long base;
-	int stride;
-	int width;
-	int height;
-	int flags;
-} dmi_list[] __initdata = {
-	[M_I17] = { "i17", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE }, /* guess */
-	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE },
-	[M_I24] = { "i24", 0x80010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE }, /* guess */
-	[M_I24_8_1] = { "imac8", 0xc0060000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
-	[M_I24_10_1] = { "imac10", 0xc0010000, 2048 * 4, 1920, 1080, OVERRIDE_NONE },
-	[M_I27_11_1] = { "imac11", 0xc0010000, 2560 * 4, 2560, 1440, OVERRIDE_NONE },
-	[M_MINI]= { "mini", 0x80000000, 2048 * 4, 1024, 768, OVERRIDE_NONE },
-	[M_MINI_3_1] = { "mini31", 0x40010000, 1024 * 4, 1024, 768, OVERRIDE_NONE },
-	[M_MINI_4_1] = { "mini41", 0xc0010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
-	[M_MB] = { "macbook", 0x80000000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	[M_MB_5_1] = { "macbook51", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	[M_MB_6_1] = { "macbook61", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	[M_MB_7_1] = { "macbook71", 0x80010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	[M_MBA] = { "mba", 0x80000000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	/* 11" Macbook Air 3,1 passes the wrong stride */
-	[M_MBA_3] = { "mba3", 0, 2048 * 4, 0, 0, OVERRIDE_STRIDE },
-	[M_MBP] = { "mbp", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_MBP_2] = { "mbp2", 0, 0, 0, 0, OVERRIDE_NONE }, /* placeholder */
-	[M_MBP_2_2] = { "mbp22", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
-	[M_MBP_5_1] = { "mbp51", 0xc0010000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_MBP_5_2] = { "mbp52", 0xc0010000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
-	[M_MBP_5_3] = { "mbp53", 0xd0010000, 2048 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_MBP_6_1] = { "mbp61", 0x90030000, 2048 * 4, 1920, 1200, OVERRIDE_NONE },
-	[M_MBP_6_2] = { "mbp62", 0x90030000, 2048 * 4, 1680, 1050, OVERRIDE_NONE },
-	[M_MBP_7_1] = { "mbp71", 0xc0010000, 2048 * 4, 1280, 800, OVERRIDE_NONE },
-	[M_MBP_8_2] = { "mbp82", 0x90010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
-	[M_UNKNOWN] = { NULL, 0, 0, 0, 0, OVERRIDE_NONE }
-};
-
-static int set_system(const struct dmi_system_id *id);
-
-#define EFIFB_DMI_SYSTEM_ID(vendor, name, enumid)		\
-	{ set_system, name, {					\
-		DMI_MATCH(DMI_BIOS_VENDOR, vendor),		\
-		DMI_MATCH(DMI_PRODUCT_NAME, name) },		\
-	  &dmi_list[enumid] }
-
-static const struct dmi_system_id dmi_system_table[] __initconst = {
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
-	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac5,1", M_I20),
-	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac6,1", M_I24),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac6,1", M_I24),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac7,1", M_I20_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac8,1", M_I24_8_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac10,1", M_I24_10_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac11,1", M_I27_11_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "Macmini1,1", M_MINI),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini3,1", M_MINI_3_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini4,1", M_MINI_4_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook1,1", M_MB),
-	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook2,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook2,1", M_MB),
-	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook3,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook3,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook4,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook5,1", M_MB_5_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook6,1", M_MB_6_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook7,1", M_MB_7_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir1,1", M_MBA),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir3,1", M_MBA_3),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro1,1", M_MBP),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,1", M_MBP_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,2", M_MBP_2_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro2,1", M_MBP_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,2", M_MBP_5_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,3", M_MBP_5_3),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,1", M_MBP_6_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,2", M_MBP_6_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro7,1", M_MBP_7_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro8,2", M_MBP_8_2),
-	{},
-};
-
-#define choose_value(dmivalue, fwvalue, field, flags) ({	\
-		typeof(fwvalue) _ret_ = fwvalue;		\
-		if ((flags) & (field))				\
-			_ret_ = dmivalue;			\
-		else if ((fwvalue) == 0)			\
-			_ret_ = dmivalue;			\
-		_ret_;						\
-	})
-
-static int set_system(const struct dmi_system_id *id)
-{
-	struct efifb_dmi_info *info = id->driver_data;
-
-	if (info->base == 0 && info->height == 0 && info->width == 0
-			&& info->stride == 0)
-		return 0;
-
-	/* Trust the bootloader over the DMI tables */
-	if (screen_info.lfb_base == 0) {
-#if defined(CONFIG_PCI)
-		struct pci_dev *dev = NULL;
-		int found_bar = 0;
-#endif
-		if (info->base) {
-			screen_info.lfb_base = choose_value(info->base,
-				screen_info.lfb_base, OVERRIDE_BASE,
-				info->flags);
-
-#if defined(CONFIG_PCI)
-			/* make sure that the address in the table is actually
-			 * on a VGA device's PCI BAR */
-
-			for_each_pci_dev(dev) {
-				int i;
-				if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
-					continue;
-				for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-					resource_size_t start, end;
-
-					start = pci_resource_start(dev, i);
-					if (start == 0)
-						break;
-					end = pci_resource_end(dev, i);
-					if (screen_info.lfb_base >= start &&
-					    screen_info.lfb_base < end) {
-						found_bar = 1;
-					}
-				}
-			}
-			if (!found_bar)
-				screen_info.lfb_base = 0;
-#endif
-		}
-	}
-	if (screen_info.lfb_base) {
-		screen_info.lfb_linelength = choose_value(info->stride,
-			screen_info.lfb_linelength, OVERRIDE_STRIDE,
-			info->flags);
-		screen_info.lfb_width = choose_value(info->width,
-			screen_info.lfb_width, OVERRIDE_WIDTH,
-			info->flags);
-		screen_info.lfb_height = choose_value(info->height,
-			screen_info.lfb_height, OVERRIDE_HEIGHT,
-			info->flags);
-		if (screen_info.orig_video_isVGA == 0)
-			screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
-	} else {
-		screen_info.lfb_linelength = 0;
-		screen_info.lfb_width = 0;
-		screen_info.lfb_height = 0;
-		screen_info.orig_video_isVGA = 0;
-		return 0;
-	}
-
-	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at 0x%08x "
-			 "(%dx%d, stride %d)\n", id->ident,
-			 screen_info.lfb_base, screen_info.lfb_width,
-			 screen_info.lfb_height, screen_info.lfb_linelength);
-
-
-	return 1;
-}
-
 static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			   unsigned blue, unsigned transp,
 			   struct fb_info *info)
@@ -312,7 +96,7 @@ void vga_set_default_device(struct pci_dev *pdev)
 	default_vga = pdev;
 }
 
-static int __init efifb_setup(char *options)
+static int efifb_setup(char *options)
 {
 	char *this_opt;
 	int i;
@@ -323,12 +107,12 @@ static int __init efifb_setup(char *options)
 			if (!*this_opt) continue;
 
 			for (i = 0; i < M_UNKNOWN; i++) {
-				if (!strcmp(this_opt, dmi_list[i].optname) &&
-				    dmi_list[i].base != 0) {
-					screen_info.lfb_base = dmi_list[i].base;
-					screen_info.lfb_linelength = dmi_list[i].stride;
-					screen_info.lfb_width = dmi_list[i].width;
-					screen_info.lfb_height = dmi_list[i].height;
+				if (!strcmp(this_opt, efifb_dmi_list[i].optname) &&
+				    efifb_dmi_list[i].base != 0) {
+					screen_info.lfb_base = efifb_dmi_list[i].base;
+					screen_info.lfb_linelength = efifb_dmi_list[i].stride;
+					screen_info.lfb_width = efifb_dmi_list[i].width;
+					screen_info.lfb_height = efifb_dmi_list[i].height;
 				}
 			}
 			if (!strncmp(this_opt, "base:", 5))
@@ -369,13 +153,28 @@ static int __init efifb_setup(char *options)
 	return 0;
 }
 
-static int __init efifb_probe(struct platform_device *dev)
+static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int err;
 	unsigned int size_vmode;
 	unsigned int size_remap;
 	unsigned int size_total;
+	char *option = NULL;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return -ENODEV;
+
+	if (fb_get_options("efifb", &option))
+		return -ENODEV;
+	efifb_setup(option);
+
+	/* We don't get linelength from UGA Draw Protocol, only from
+	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
+	 * passed in from the user, we really can't use the framebuffer.
+	 */
+	if (!screen_info.lfb_linelength)
+		return -ENODEV;
 
 	if (!screen_info.lfb_depth)
 		screen_info.lfb_depth = 32;
@@ -539,55 +338,12 @@ err_release_mem:
 }
 
 static struct platform_driver efifb_driver = {
-	.driver	= {
-		.name	= "efifb",
+	.driver = {
+		.name = "efi-framebuffer",
+		.owner = THIS_MODULE,
 	},
+	.probe = efifb_probe,
 };
 
-static struct platform_device efifb_device = {
-	.name	= "efifb",
-};
-
-static int __init efifb_init(void)
-{
-	int ret;
-	char *option = NULL;
-
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
-	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
-		dmi_check_system(dmi_system_table);
-
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
-		return -ENODEV;
-
-	if (fb_get_options("efifb", &option))
-		return -ENODEV;
-	efifb_setup(option);
-
-	/* We don't get linelength from UGA Draw Protocol, only from
-	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
-	 * passed in from the user, we really can't use the framebuffer.
-	 */
-	if (!screen_info.lfb_linelength)
-		return -ENODEV;
-
-	ret = platform_device_register(&efifb_device);
-	if (ret)
-		return ret;
-
-	/*
-	 * This is not just an optimization.  We will interfere
-	 * with a real driver if we get reprobed, so don't allow
-	 * it.
-	 */
-	ret = platform_driver_probe(&efifb_driver, efifb_probe);
-	if (ret) {
-		platform_device_unregister(&efifb_device);
-		return ret;
-	}
-
-	return ret;
-}
-module_init(efifb_init);
-
+module_platform_driver(efifb_driver);
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index e2e9e3e..8d78106 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -24,6 +24,7 @@
 #include <linux/fb.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 
 static struct fb_fix_screeninfo simplefb_fix = {
@@ -73,18 +74,7 @@ static struct fb_ops simplefb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-struct simplefb_format {
-	const char *name;
-	u32 bits_per_pixel;
-	struct fb_bitfield red;
-	struct fb_bitfield green;
-	struct fb_bitfield blue;
-	struct fb_bitfield transp;
-};
-
-static struct simplefb_format simplefb_formats[] = {
-	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
-};
+static struct simplefb_format simplefb_formats[] = SIMPLEFB_FORMATS;
 
 struct simplefb_params {
 	u32 width;
@@ -139,6 +129,33 @@ static int simplefb_parse_dt(struct platform_device *pdev,
 	return 0;
 }
 
+static int simplefb_parse_pd(struct platform_device *pdev,
+			     struct simplefb_params *params)
+{
+	struct simplefb_platform_data *pd = pdev->dev.platform_data;
+	int i;
+
+	params->width = pd->width;
+	params->height = pd->height;
+	params->stride = pd->stride;
+
+	params->format = NULL;
+	for (i = 0; i < ARRAY_SIZE(simplefb_formats); i++) {
+		if (strcmp(pd->format, simplefb_formats[i].name))
+			continue;
+
+		params->format = &simplefb_formats[i];
+		break;
+	}
+
+	if (!params->format) {
+		dev_err(&pdev->dev, "Invalid format value\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int simplefb_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -149,7 +166,12 @@ static int simplefb_probe(struct platform_device *pdev)
 	if (fb_get_options("simplefb", NULL))
 		return -ENODEV;
 
-	ret = simplefb_parse_dt(pdev, &params);
+	ret = -ENODEV;
+	if (pdev->dev.platform_data)
+		ret = simplefb_parse_pd(pdev, &params);
+	else if (pdev->dev.of_node)
+		ret = simplefb_parse_dt(pdev, &params);
+
 	if (ret)
 		return ret;
 
@@ -180,8 +202,16 @@ static int simplefb_probe(struct platform_device *pdev)
 	info->var.blue = params.format->blue;
 	info->var.transp = params.format->transp;
 
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		framebuffer_release(info);
+		return -ENOMEM;
+	}
+	info->apertures->ranges[0].base = info->fix.smem_start;
+	info->apertures->ranges[0].size = info->fix.smem_len;
+
 	info->fbops = &simplefb_ops;
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
 	info->screen_base = devm_ioremap(&pdev->dev, info->fix.smem_start,
 					 info->fix.smem_len);
 	if (!info->screen_base) {
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 501b340..bd83233 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -29,7 +29,7 @@
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vesafb_defined __initdata = {
+static struct fb_var_screeninfo vesafb_defined = {
 	.activate	= FB_ACTIVATE_NOW,
 	.height		= -1,
 	.width		= -1,
@@ -40,7 +40,7 @@ static struct fb_var_screeninfo vesafb_defined __initdata = {
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo vesafb_fix __initdata = {
+static struct fb_fix_screeninfo vesafb_fix = {
 	.id	= "VESA VGA",
 	.type	= FB_TYPE_PACKED_PIXELS,
 	.accel	= FB_ACCEL_NONE,
@@ -48,8 +48,8 @@ static struct fb_fix_screeninfo vesafb_fix __initdata = {
 
 static int   inverse    __read_mostly;
 static int   mtrr       __read_mostly;		/* disable mtrr */
-static int   vram_remap __initdata;		/* Set amount of memory to be used */
-static int   vram_total __initdata;		/* Set total amount of memory */
+static int   vram_remap;			/* Set amount of memory to be used */
+static int   vram_total;			/* Set total amount of memory */
 static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
 static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
 static void  (*pmi_start)(void) __read_mostly;
@@ -192,7 +192,7 @@ static struct fb_ops vesafb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int __init vesafb_setup(char *options)
+static int vesafb_setup(char *options)
 {
 	char *this_opt;
 	
@@ -226,13 +226,18 @@ static int __init vesafb_setup(char *options)
 	return 0;
 }
 
-static int __init vesafb_probe(struct platform_device *dev)
+static int vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int i, err;
 	unsigned int size_vmode;
 	unsigned int size_remap;
 	unsigned int size_total;
+	char *option = NULL;
+
+	/* ignore error return of fb_get_options */
+	fb_get_options("vesafb", &option);
+	vesafb_setup(option);
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;
@@ -496,40 +501,12 @@ err:
 }
 
 static struct platform_driver vesafb_driver = {
-	.driver	= {
-		.name	= "vesafb",
+	.driver = {
+		.name = "vesa-framebuffer",
+		.owner = THIS_MODULE,
 	},
+	.probe = vesafb_probe,
 };
 
-static struct platform_device *vesafb_device;
-
-static int __init vesafb_init(void)
-{
-	int ret;
-	char *option = NULL;
-
-	/* ignore error return of fb_get_options */
-	fb_get_options("vesafb", &option);
-	vesafb_setup(option);
-
-	vesafb_device = platform_device_alloc("vesafb", 0);
-	if (!vesafb_device)
-		return -ENOMEM;
-
-	ret = platform_device_add(vesafb_device);
-	if (!ret) {
-		ret = platform_driver_probe(&vesafb_driver, vesafb_probe);
-		if (ret)
-			platform_device_del(vesafb_device);
-	}
-
-	if (ret) {
-		platform_device_put(vesafb_device);
-		vesafb_device = NULL;
-	}
-
-	return ret;
-}
-module_init(vesafb_init);
-
+module_platform_driver(vesafb_driver);
 MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
new file mode 100644
index 0000000..53774b0
--- /dev/null
+++ b/include/linux/platform_data/simplefb.h
@@ -0,0 +1,63 @@
+/*
+ * simplefb.h - Simple Framebuffer Device
+ *
+ * Copyright (C) 2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PLATFORM_DATA_SIMPLEFB_H__
+#define __PLATFORM_DATA_SIMPLEFB_H__
+
+#include <drm/drm_fourcc.h>
+#include <linux/fb.h>
+#include <linux/kernel.h>
+
+/* format array, use it to initialize a "struct simplefb_format" array */
+#define SIMPLEFB_FORMATS \
+{ \
+	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0}, DRM_FORMAT_RGB565 }, \
+	{ "x1r5g5b5", 16, {10, 5}, {5, 5}, {0, 5}, {0, 0}, DRM_FORMAT_XRGB1555 }, \
+	{ "a1r5g5b5", 16, {10, 5}, {5, 5}, {0, 5}, {15, 1}, DRM_FORMAT_ARGB1555 }, \
+	{ "r8g8b8", 24, {16, 8}, {8, 8}, {0, 8}, {0, 0}, DRM_FORMAT_RGB888 }, \
+	{ "x8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {0, 0}, DRM_FORMAT_XRGB8888 }, \
+	{ "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }, \
+	{ "x2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {0, 0}, DRM_FORMAT_XRGB2101010 }, \
+	{ "a2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {30, 2}, DRM_FORMAT_ARGB2101010 }, \
+}
+
+/*
+ * Data-Format for Simple-Framebuffers
+ * @name: unique 0-terminated name that can be used to identify the mode
+ * @red,green,blue: Offsets and sizes of the single RGB parts
+ * @transp: Offset and size of the alpha bits. length=0 means no alpha
+ * @fourcc: 32bit DRM four-CC code (see drm_fourcc.h)
+ */
+struct simplefb_format {
+	const char *name;
+	u32 bits_per_pixel;
+	struct fb_bitfield red;
+	struct fb_bitfield green;
+	struct fb_bitfield blue;
+	struct fb_bitfield transp;
+	u32 fourcc;
+};
+
+/*
+ * Simple-Framebuffer description
+ * If the arch-boot code creates simple-framebuffers without DT support, it
+ * can pass the width, height, stride and format via this platform-data object.
+ * The framebuffer location must be given as IORESOURCE_MEM resource.
+ * @format must be a format as described in "struct simplefb_format" above.
+ */
+struct simplefb_platform_data {
+	u32 width;
+	u32 height;
+	u32 stride;
+	const char *format;
+};
+
+#endif /* __PLATFORM_DATA_SIMPLEFB_H__ */
