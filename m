Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3GDM05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:26:57 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47266 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3GDM0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:31 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Peter Jones <pjones@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 04/14] x86: sysfb: move EFI quirks from efifb to sysfb
Date: Thu,  4 Jul 2013 14:25:04 +0200
Message-Id: <1372940714-12470-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI FB quirks from efifb.c are useful for simple-framebuffer devices
as well. Apply them by default so we can convert efifb.c to use
efi-framebuffer platform devices.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 arch/x86/include/asm/sysfb.h |  57 +++++++++++
 arch/x86/kernel/Makefile     |   1 +
 arch/x86/kernel/sysfb.c      |   3 +
 arch/x86/kernel/sysfb_efi.c  | 214 +++++++++++++++++++++++++++++++++++++++
 drivers/video/efifb.c        | 234 ++-----------------------------------------
 5 files changed, 282 insertions(+), 227 deletions(-)
 create mode 100644 arch/x86/kernel/sysfb_efi.c

diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
index 2395fe0..2aeb3e2 100644
--- a/arch/x86/include/asm/sysfb.h
+++ b/arch/x86/include/asm/sysfb.h
@@ -15,6 +15,63 @@
 #include <linux/platform_data/simplefb.h>
 #include <linux/screen_info.h>
 
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
 #ifdef CONFIG_X86_SYSFB
 
 bool parse_mode(const struct screen_info *si,
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c5e7677..66c87da 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 obj-y					+= sysfb.o
 obj-$(CONFIG_X86_SYSFB)			+= sysfb_simplefb.o
+obj-$(CONFIG_EFI)			+= sysfb_efi.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 7f30e19..193ec2c 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -47,6 +47,8 @@ static __init int sysfb_init(void)
 	bool compatible;
 	int ret;
 
+	sysfb_apply_efi_quirks();
+
 	/* try to create a simple-framebuffer device */
 	compatible = parse_mode(si, &mode);
 	if (compatible) {
@@ -68,4 +70,5 @@ static __init int sysfb_init(void)
 	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
 }
 
+/* must execute after PCI subsystem for EFI quirks */
 device_initcall(sysfb_init);
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
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 50fe668..e493bcb 100644
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
@@ -553,10 +337,6 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
-	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
-		dmi_check_system(dmi_system_table);
-
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
 
-- 
1.8.3.2

