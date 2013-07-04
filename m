Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3GDM0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:26:53 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46659 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3GDM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:29 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 03/14] x86: provide platform-devices for boot-framebuffers
Date: Thu,  4 Jul 2013 14:25:03 +0200
Message-Id: <1372940714-12470-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current situation regarding boot-framebuffers (VGA, VESA/VBE, EFI) on
x86 causes troubles when loading multiple fbdev drivers. The global
"struct screen_info" does not provide any state-tracking about which
drivers use the FBs. request_mem_region() theoretically works, but
unfortunately vesafb/efifb ignore it due to quirks for broken boards.

Avoid this by creating a platform framebuffer devices with a pointer
to the "struct screen_info" as platform-data. Drivers can now create
platform-drivers and the driver-core will refuse multiple drivers being
active simultaneously.

We keep the screen_info available for backwards-compatibility. Drivers
can be converted in follow-up patches.

Different devices are created for VGA/VESA/EFI FBs to allow multiple
drivers to be loaded on distro kernels. We create:
 - "vesa-framebuffer" for VBE/VESA graphics FBs
 - "efi-framebuffer" for EFI FBs
 - "platform-framebuffer" for everything else
This allows to load vesafb, efifb and others simultaneously and each
picks up only the supported FB types.

Apart from platform-framebuffer devices, this also introduces a
compatibility option for "simple-framebuffer" drivers which recently got
introduced for OF based systems. If CONFIG_X86_SYSFB is selected, we
try to match the screen_info against a simple-framebuffer supported
format. If we succeed, we create a "simple-framebuffer" device instead
of a platform-framebuffer.
This allows to reuse the simplefb.c driver across architectures and also
to introduce a SimpleDRM driver. There is no need to have vesafb.c,
efifb.c, simplefb.c and more just to have architecture specific quirks
in their setup-routines.

Instead, we now move the architecture specific quirks into x86-setup and
provide a generic simple-framebuffer. For backwards-compatibility (if
strange formats are used), we still allow vesafb/efifb to be loaded
simultaneously and pick up all remaining devices.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 arch/x86/Kconfig                 | 26 +++++++++++
 arch/x86/include/asm/sysfb.h     | 41 +++++++++++++++++
 arch/x86/kernel/Makefile         |  2 +
 arch/x86/kernel/sysfb.c          | 71 ++++++++++++++++++++++++++++++
 arch/x86/kernel/sysfb_simplefb.c | 95 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 235 insertions(+)
 create mode 100644 arch/x86/include/asm/sysfb.h
 create mode 100644 arch/x86/kernel/sysfb.c
 create mode 100644 arch/x86/kernel/sysfb_simplefb.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe120da..54a93a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2255,6 +2255,32 @@ config RAPIDIO
 
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
index 0000000..2395fe0
--- /dev/null
+++ b/arch/x86/include/asm/sysfb.h
@@ -0,0 +1,41 @@
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
index 7bd3bd3..c5e7677 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,6 +100,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
+obj-y					+= sysfb.o
+obj-$(CONFIG_X86_SYSFB)			+= sysfb_simplefb.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
new file mode 100644
index 0000000..7f30e19
--- /dev/null
+++ b/arch/x86/kernel/sysfb.c
@@ -0,0 +1,71 @@
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
+device_initcall(sysfb_init);
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
-- 
1.8.3.2

