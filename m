Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaAWOSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:18:02 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65196 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbaAWOP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:59 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 06/11] video: sysfb: add generic firmware-fb interface
Date: Thu, 23 Jan 2014 15:14:58 +0100
Message-Id: <1390486503-1504-7-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We supported many different firmware-fbs in linux for a long time. On x86,
we tried to unify the different types into platform-devices so their
lifetime and drivers can be more easily controlled. This patch moves the
x86-specific sysfb_*() helpers into drivers/video/sysfb.c so other
architectures can make use of it, too.

The sysfb API consists of 4 functions:
  sysfb_register()
  sysfb_register_dyn()
  sysfb_unregister()
  sysfb_claim()

The first 3 can be used by architecture setup code to register
firmware-framebuffers with the system/sysfb. Once the framebuffers are
registered, matching platform-drivers will pick it up. Via
sysfb_unregister() devices can be manually removed again, in case this is
ever needed (x86 doesn't make use of this).

Real hw-drivers like i915/radeon/nouveau can use sysfb_claim() to evict
any firmware-framebuffer from the system before accessing the hw. This
guarantees that any previous driver (like vesafb/efifb) will be unloaded
before the real hw driver takes over.

The sysfb file contains a thorough API documentation which explains the
corner-cases and how we guarantee firmware-fb drivers can no longer
interfere with real-hw drivers. Additionally, a short documentation of the
different existing firmware-fbs and handover-mechanisms is put into
Documentation/firmware-fbs.txt.

Compared to remove_conflicting_framebuffers(), the sysfb interface is
independent of FBDEV. Thus, we can use it for DRM-only handovers.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 Documentation/firmware-fbs.txt         | 236 ++++++++++++++++++++++
 arch/x86/Kconfig                       |   1 +
 arch/x86/include/asm/sysfb.h           |   5 -
 arch/x86/kernel/sysfb.c                |  64 ------
 arch/x86/kernel/sysfb_simplefb.c       |  26 ++-
 drivers/video/Kconfig                  |   3 +
 drivers/video/Makefile                 |   1 +
 drivers/video/fbmem.c                  |  24 ++-
 drivers/video/sysfb.c                  | 348 +++++++++++++++++++++++++++++++++
 include/linux/fb.h                     |   9 +-
 include/linux/platform_data/simplefb.h |   1 +
 include/linux/sysfb.h                  |  62 ++++++
 12 files changed, 692 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/firmware-fbs.txt
 create mode 100644 drivers/video/sysfb.c
 create mode 100644 include/linux/sysfb.h

diff --git a/Documentation/firmware-fbs.txt b/Documentation/firmware-fbs.txt
new file mode 100644
index 0000000..e0276ec
--- /dev/null
+++ b/Documentation/firmware-fbs.txt
@@ -0,0 +1,236 @@
+                           Firmware Framebuffers
+----------------------------------------------------------------------------
+
+1. Intro
+~~~~~~~~
+Modern firmware often initializes the graphics hardware before booting the
+kernel. A basic framebuffer is created and used for single-buffered rendering.
+Linux can detect such framebuffers and provide them to user-space. Early
+user-space can use it to draw boot-splashs, disk-encryption prompts and more.
+Once all hardware has been probed, real graphics drivers may take over.
+
+This document describes which firmware framebuffers are currently supported and
+how the handover works.
+
+2. Supported Drivers
+~~~~~~~~~~~~~~~~~~~~
+There are fbdev and DRM drivers which can make use of firmware framebuffers.
+This currently includes:
+
+  fbdev:
+    - vesafb: Uses VBE/VESA graphics mode
+    - efifb: Uses EFI UGA/GOP
+    - simplefb: Binds to custom platform-devices (eg., via DT)
+    - offb: Binds to custom platform-devices via DT
+    - vga16: Uses x86 VGA mode
+  DRM:
+    - SimpleDRM: Binds to custom platform-devices (eg., via DT)
+
+Furthermore, other miscellaneous drivers make use of firmware-framebuffers or
+their properties. Their effect is discussed at the end of this document (this
+includes vgacon and friends).
+
+3. Underlying Devices
+~~~~~~~~~~~~~~~~~~~~~
+Firmware-framebuffer drivers use different techniques to detect devices and bind
+to them. Some of these are compatible, some not. This section describes the
+different device types.
+
+3.1 simple-framebuffer
+~~~~~~~~~~~~~~~~~~~~~~
+The newest and most compatible way to represent firmware-fbs is to create a
+"simple-framebuffer" platform-device. Early boot code in arch/ should create
+such devices from device-tree data or other means of input (BIOS queries or boot
+parameters). Such devices are picked up by simplefb or SimpleDRM and provided to
+user-space as single raw framebuffer.
+
+Currently, the following ways exist to create such fbs:
+ - device-tree:
+   See: Documentation/devicetree/bindings/video/simple-framebuffer.txt
+   An example device-tree binding is:
+       framebuffer {
+           compatible = "simple-framebuffer";
+           reg = <0x1d385000 (1600 * 1200 * 2)>;
+           width = <1600>;
+           height = <1200>;
+           stride = <(1600 * 2)>;
+           format = "r5g6b5";
+       };
+ - platform-data:
+   You can create platform-devices in arch/ setup code and set the platform-data
+   to "struct simplefb_platform_data". It is defined in:
+     include/linux/platform_data/simplefb.h
+   It contains the width, height, stride and format of the framebuffer. Base
+   address and size should be passed as primary IORESOURCE_MEM resource.
+
+Supported pixel-formats are listed in:
+  include/linux/platform_data/simplefb.h
+
+All new code should use either method to advertise firmware-fbs. Other means are
+deprecated and may conflict with simple-framebuffers. If the simple-framebuffer
+method is not suitable, it should be extended to fulfil your needs. If that's
+not possible, you still should register your framebuffer with the device-model
+so it can be properly detected and driver-binding is well defined.
+See below (3.2 platform-devices) for other examples.
+
+3.2 platform-devices
+~~~~~~~~~~~~~~~~~~~~
+There are a bunch of legacy device-types that are incompatible to the
+"simple-framebuffer" platform-device or supported for backwards-compatibility.
+All these devices are represented as a "struct platform_device" similar to
+simple-framebuffers but with a different device-name.
+
+ - "vesa-framebuffer":
+   On x86, a "vesa-framebuffer" platform-device is created if a VESA framebuffer
+   is detected during boot. The platform-data contains a pointer to the
+   "struct screen_info" related to the device.
+   Currently, only the vesafb driver binds to such devices.
+ - "efi-framebuffer":
+   On EFI systems, a "efi-framebuffer" platform-device is created if an EFI
+   framebuffer is provided by the firmware. Similar to vesa-framebuffers, the
+   platform-data contains a pointer to the "struct screen_info" related to the
+   device.
+   Currently, only the efifb driver binds to such devices.
+
+3.3 open-firmware:
+~~~~~~~~~~~~~~~~~~
+There are several open-firmware based framebuffers that are supported by the
+"offb.c" driver. These are all very similar to the simple-framebuffer
+device-tree format and supported for compatibility reasons. See the offb.c
+driver source for more information on the exact format.
+Note that these are specific to the offb.c driver. They are *not* registered as
+platform-device (or any other device) and don't integrate at all with the
+device-model. Instead, only the fbdev device itself is registered as char-dev.
+The underlying un-typed firmware-framebuffer is not represented by a
+"struct device".
+
+3.4 "struct screen_info":
+~~~~~~~~~~~~~~~~~~~~~~~~~
+The legacy mode to register firmware-fbs on x86 was to initialize a global
+instance of type "struct screen_info". Drivers can access this object directly
+via its name "screen_info".
+This structure is defined in include/uapi/linux/screen_info.h and contains
+pixel-mode information, base-address and size of the framebuffer. Drivers simply
+use the information in this structure. There is no synchronization between those
+drivers and no-one prevents multiple of these to bind to the same device.
+
+The screen_info.orig_video_isVGA field defines the hw-mode during bootup. It may
+indicate a graphics or text-mode (see below 3.5 VGA for text-mode). This
+structure is *not* modified if the mode changes during runtime. Thus, such
+drivers will break if hotplugged after another driver was already loaded.
+
+vesafb and efifb have been converted to not use the global "screen_info" object
+but instead bind to platform-devices. All other drivers that use "screen_info"
+are deprecated and may not work well with hw-handover to real graphics drivers.
+Note that some platform-devices contain a "struct screen_info" as platform-data,
+which is fine! The platform-device itself provides synchronization and
+driver-binding. It's only the drivers that rely on the global "screen_info"
+object that will likely break during hw-takeover.
+
+3.5 VGA
+~~~~~~~
+On x86, drivers may use VGA I/O registers directly to test for text-mode or
+basic vga-graphics mode. These drivers usually verify that the system runs in a
+compatible VGA-mode by reading the global "screen_info" object.
+
+VGA drivers suffer from the same problem as screen_info drivers (see 3.4).
+No-one prevents multiple drivers from accessing the same device and there is no
+sane hand-over to real hw-drivers.
+
+VGA drivers should be used with care (best: not used at all!) if hw-handover is
+required. If someone cares for VGA/text-mode and hw-handover, they should add
+"vga-framebuffer" platform-devices and bind to them in the drivers (similar to
+vesa-framebuffer and efi-framebuffer devices). This would allow removing these
+devices on hw-handover and prevent further access from VGA drivers.
+
+4. Hand-over
+~~~~~~~~~~~~
+Many graphics devices support much more features than a single framebuffer.
+Therefore, linux allows real hw-drivers to take over control (eg., radeon-drm
+taking over from efifb).
+
+To support hand-over, we need to unload the previous driver before loading the
+new driver. Furthermore, we must prevent any firmware-driver from loading again
+later. Multiple hand-over helpers exist and are described below.
+
+4.1 sysfb
+~~~~~~~~~
+The sysfb-handover is the newest of all helpers and should be used by new code.
+Currently, only x86 uses it (arch/x86/kernel/sysfb.c). sysfb is quite simple and
+provides a single hand-over layer.
+
+Architecture setup must register all firmware-framebuffers via sysfb_register()
+instead of calling platform_device_register() directly. Currently sysfb supports
+only a single firmware-fb at a time, but could be extended to allow multiple fbs
+(once such systems occur in the wild).
+sysfb_register() remembers the device and calls platform_device_register().
+Generic firmware-fb drivers can now bind to the firmware devices. Once these
+devices are removed from the system, the generic firmware-fb drivers are
+automatically unbound.
+
+Any real hw video-driver that binds to a device *must* call sysfb_claim()
+before using the device. sysfb_claim() will check whether the given resource
+is used by any firmware-fb and remove any conflicting platform-device. Removing
+the platform-device will unbind the related platform-driver. Thus, the real hw
+driver can now be sure that there is no other driver accessing any firmware-fb
+based on its hardware.
+sysfb_claim() also makes sure that no following call to sysfb_register()
+will succeed, thus, preventing any new firmware-fb on the given device.
+
+Currently, remove_conflicting_framebuffers() (see below at 4.2) and DRM drivers
+call sysfb_claim() to remove conflicting firmware-fbs.
+
+See drivers/video/sysfb.c for a thorough API description of sysfb.
+
+4.2 fbdev
+~~~~~~~~~
+The fbdev layer provides a single helper called
+remove_conflicting_framebuffers(). This is implicitly called before any fbdev
+driver is registered and explicitly called by all affected DRM drivers. This
+helper is supposed to remove any existing framebuffer device that conflicts with
+the new device. Note that it does *not* prevent any new device from re-occuring.
+So loading a firmware-fb driver *after* the real hw-driver will break.
+
+Furthermore, this is limited to fbdev. If CONFIG_FB is disabled, it is not
+available.
+
+5. vgacon
+~~~~~~~~~
+The vgacon driver is similar to the vga-fbdev drivers (see above at 3.5). It
+does not register any "struct device" and thus there's no simple way to prevent
+multiple drivers from accessing vga registers simultaneously.
+
+The vgacon driver is created by early-arch-setup and marked as default VT
+console. Once the VT layer is started, it binds vgacon to all VTs. If VTs or
+VGACON are disabled, all this obviously does not apply. Same is true if the
+system is not booted in VGA/text-mode. vgacon only takes over if "screen_info"
+tells it that the system is booted in VGA/text-mode.
+
+vgacon then accesses VGA I/O registers directly to print the VT console. If a
+real-hw driver takes over, it cannot unregister vgacon directly. Instead, it
+needs to register another VT console and call do_take_over_console() (or you may
+call it with dummy_con). Obviously, vgacon must not be registered *after* the
+hw-driver is probed, otherwise, vgacon will take over unconditionally. This,
+however, seems to be no problem as vgacon is only probed by early arch-setup
+code.
+
+Currently, fbdev and DRM drivers register fbdev drivers, which are then picked
+up by fbcon which calls do_take_over_console() and removes vgacon. However, once
+the hw-driver is unloaded, fbcon is unbound, too. Therefore, vgacon will take
+over again (and fail horribly if the driver didn't restore VGA registers!).
+Running a system without fbdev but with vgacon+DRM will break, too. There's
+no-one who unloads vgacon when DRM starts up.
+
+6. Early Consoles
+~~~~~~~~~~~~~~~~~
+Architecture setup-code can register early-consoles. These may include consoles
+that access firmware-framebuffers. Such consoles are automatically removed from
+the system when the first real console-driver is loaded. However, you can
+disable this on the kernel-command line. Therefore, you're highly discouraged to
+enable early-boot consoles by default. You should only enable them for
+debugging. Especially on systems without VTs but DRM enabled, chances are high
+that no real console-driver will be available so no-one will ever remove
+early-boot consoles.
+
+----------------------------------------------------------------------------
+  Written 2013-2014 by David Herrmann <dh.herrmann@gmail.com>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 098228e..93df439 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2300,6 +2300,7 @@ source "drivers/rapidio/Kconfig"
 config X86_SYSFB
 	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
 	depends on FB_SIMPLE
+	select SYSFB
 	help
 	  Firmwares often provide initial graphics framebuffers so the BIOS,
 	  bootloader or kernel can show basic video-output during boot for
diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
index 4f9fda2..f777949 100644
--- a/arch/x86/include/asm/sysfb.h
+++ b/arch/x86/include/asm/sysfb.h
@@ -59,11 +59,6 @@ struct efifb_dmi_info {
 	int flags;
 };
 
-int __init sysfb_register(const char *name, int id,
-			  const struct resource *res, unsigned int res_num,
-			  const void *data, size_t data_size);
-void sysfb_unregister(const struct apertures_struct *apert, bool primary);
-
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index fd07b09..96f9289 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -39,70 +39,6 @@
 #include <linux/screen_info.h>
 #include <asm/sysfb.h>
 
-static DEFINE_MUTEX(sysfb_lock);
-static struct platform_device *sysfb_dev;
-
-int __init sysfb_register(const char *name, int id,
-			  const struct resource *res, unsigned int res_num,
-			  const void *data, size_t data_size)
-{
-	struct platform_device *pd;
-	int ret = 0;
-
-	mutex_lock(&sysfb_lock);
-	if (!sysfb_dev) {
-		pd = platform_device_register_resndata(NULL, name, id,
-						       res, res_num,
-						       data, data_size);
-		if (IS_ERR(pd))
-			ret = PTR_ERR(pd);
-		else
-			sysfb_dev = pd;
-	}
-	mutex_unlock(&sysfb_lock);
-
-	return ret;
-}
-
-static bool sysfb_match(const struct apertures_struct *apert)
-{
-	struct screen_info *si = &screen_info;
-	unsigned int i;
-	const struct aperture *a;
-
-	for (i = 0; i < apert->count; ++i) {
-		a = &apert->ranges[i];
-		if (a->base >= si->lfb_base &&
-		    a->base < si->lfb_base + ((u64)si->lfb_size << 16))
-			return true;
-		if (si->lfb_base >= a->base &&
-		    si->lfb_base < a->base + a->size)
-			return true;
-	}
-
-	return false;
-}
-
-/* Remove sysfb and disallow new sysfbs from now on. Can be called from any
- * context except recursively (see also remove_conflicting_framebuffers()). */
-void sysfb_unregister(const struct apertures_struct *apert, bool primary)
-{
-	if (!apert)
-		return;
-
-	mutex_lock(&sysfb_lock);
-	if (!IS_ERR(sysfb_dev) && sysfb_dev) {
-		if (primary || sysfb_match(apert)) {
-			platform_device_unregister(sysfb_dev);
-			sysfb_dev = ERR_PTR(-EALREADY);
-		}
-	} else {
-		/* set/overwrite error so no new sysfb is probed later */
-		sysfb_dev = ERR_PTR(-EALREADY);
-	}
-	mutex_unlock(&sysfb_lock);
-}
-
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 9338427..97ed702 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -22,6 +22,7 @@
 #include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
+#include <linux/sysfb.h>
 #include <asm/sysfb.h>
 
 static const char simplefb_resname[] = "BOOTFB";
@@ -86,7 +87,9 @@ __init bool parse_mode(const struct screen_info *si,
 __init int create_simplefb(const struct simplefb_platform_data *mode)
 {
 	const struct apertures_struct *apert = (void*)mode->apert_buf;
+	struct platform_device *dev;
 	struct resource res;
+	int ret;
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
@@ -97,6 +100,25 @@ __init int create_simplefb(const struct simplefb_platform_data *mode)
 	if (res.end <= res.start)
 		return -EINVAL;
 
-	return sysfb_register("simple-framebuffer", 0, &res, 1, mode,
-			      sizeof(*mode));
+	dev = platform_device_alloc("simple-framebuffer", 0);
+	if (!dev)
+		return -ENOMEM;
+
+	ret = platform_device_add_resources(dev, &res, 1);
+	if (ret)
+		goto err;
+
+	ret = platform_device_add_data(dev, mode, sizeof(*mode));
+	if (ret)
+		goto err;
+
+	/* platform_data is a copy of @mode, so adjust pointers */
+	mode = dev->dev.platform_data;
+	apert = (void*)mode->apert_buf;
+
+	sysfb_register(dev, apert);
+
+err:
+	platform_device_put(dev);
+	return ret;
 }
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4f2e1b3..06bbd5f 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -39,6 +39,9 @@ config VIDEOMODE_HELPERS
 config HDMI
 	bool
 
+config SYSFB
+	bool
+
 menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e8bae8d..384926e 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -6,6 +6,7 @@
 
 obj-$(CONFIG_VGASTATE)            += vgastate.o
 obj-$(CONFIG_HDMI)                += hdmi.o
+obj-$(CONFIG_SYSFB)               += sysfb.o
 obj-y                             += fb_notify.o
 obj-$(CONFIG_FB)                  += fb.o
 fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 79a47ff..e3bceaa 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -35,10 +35,6 @@
 
 #include <asm/fb.h>
 
-#ifdef CONFIG_X86_SYSFB
-#  include <asm/sysfb.h>
-#endif
-
     /*
      *  Frame buffer device initialization and setup routines
      */
@@ -1749,14 +1745,23 @@ int unlink_framebuffer(struct fb_info *fb_info)
 }
 EXPORT_SYMBOL(unlink_framebuffer);
 
+static void remove_conflicting_sysfb(struct apertures_struct *apert,
+				     bool primary)
+{
+	/* We must not call into sysfb_claim() from within ->probe() or
+	 * ->remove() of a sysfb-device, otherwise we dead-lock. Luckily, these
+	 * devices don't have any apertures set (and must never add any), so we
+	 * can just skip it then. */
+	if (apert)
+		sysfb_claim(apert, primary ? SYSFB_CLAIM_SHADOW : 0);
+}
+
 int remove_conflicting_framebuffers(struct apertures_struct *a,
 				    const char *name, bool primary)
 {
 	int ret;
 
-#ifdef CONFIG_X86_SYSFB
-	sysfb_unregister(a, primary);
-#endif
+	remove_conflicting_sysfb(a, primary);
 
 	mutex_lock(&registration_lock);
 	ret = do_remove_conflicting_framebuffers(a, name, primary);
@@ -1780,9 +1785,8 @@ register_framebuffer(struct fb_info *fb_info)
 {
 	int ret;
 
-#ifdef CONFIG_X86_SYSFB
-	sysfb_unregister(fb_info->apertures, fb_is_primary_device(fb_info));
-#endif
+	remove_conflicting_sysfb(fb_info->apertures,
+				 fb_is_primary_device(fb_info));
 
 	mutex_lock(&registration_lock);
 	ret = do_register_framebuffer(fb_info);
diff --git a/drivers/video/sysfb.c b/drivers/video/sysfb.c
new file mode 100644
index 0000000..91e0888
--- /dev/null
+++ b/drivers/video/sysfb.c
@@ -0,0 +1,348 @@
+/*
+ * Generic System Framebuffers
+ * Copyright (c) 2012-2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/sysfb.h>
+#include <linux/types.h>
+
+/**
+ * DOC: sysfb
+ *
+ * Firmware might initialize graphics hardware before booting a kernel. Usually,
+ * it sets up a single framebuffer that we can render to (no page-flipping,
+ * double-buffering, vsync, ..). Linux can pick these up to draw early boot
+ * oops/panic screens or allow user-space to render boot-splashs.
+ * However, once all hardware has been detected, we usually want to load real
+ * graphics drivers. But before they take off, we must remove the
+ * firmware-framebuffer first. Otherwise, we will end up with resource conflicts
+ * and invalid memory accesses from a generic firmware-framebuffer driver.
+ *
+ * The sysfb infrastructure allows architecture boot-up code to register
+ * firmware-framebuffers. Real hw-drivers can use sysfb to unload firmware-fbs
+ * before loading the real driver.
+ * A firmware-framebuffer is represented by a platform_device. Other device
+ * types may be supported if required, but currently only platform_devices
+ * make sense. The name and payload of these platform-devices depend on the
+ * firmware-framebuffer type and are outside the scope of sysfb. Known types are
+ * "simple-framebuffer", "vesa-framebuffer", "efi-framebuffer" and more.
+ *
+ * Architecture setup code should allocate a platform-device, set the payload
+ * and then call sysfb_register() to register the platform-device and integrate
+ * it with sysfb. It should then drop any reference to the device and let sysfb
+ * manage it. The architecture code *may* keep a reference and unregister the
+ * firmware-fb at any time via sysfb_unregister() if and only if it has other
+ * means of notification about firmware-framebuffer destruction. Usually, this
+ * is not given.
+ *
+ * Real hw-drivers for the underlying hardware of a firmware-framebuffer must be
+ * probed on separate "struct device" objects! These devices *must* represent
+ * the real hardware instead of the firmware-framebuffer. Once a real hw-driver
+ * is probed, it shall call sysfb_claim() to claim its real resources. This will
+ * evict any conflicting firmware-framebuffers from the system and prevent any
+ * new firmware-framebuffer from being registered (it is assumed that their
+ * underlying resources are invalidated). After that, the real hw-driver can
+ * initialize the device and will have exclusive access to the resources.
+ * sysfb_claim() will unregister any conflicting firmware-framebuffers that have
+ * been registered before. It causes the ->remove() callback of the
+ * platform-devices to be called and generic framebuffers driver will get
+ * removed. It then drops its reference to the platform-devices so they get
+ * destroyed (if no-one else keeps a reference).
+ * sysfb_claim() is synchronous so it may be called in parallel by many
+ * hw-drivers and it always guarantees that it returns *after* all conflicting
+ * framebuffers have been removed.
+ *
+ * After a real hw-driver has claimed resources, sysfb automatically prevents
+ * new firmware-framebuffers from being registered. Architecture setup code
+ * should make sure that firmware-framebuffer platform-devices are registered
+ * *before* real hw-drivers are probed. This is usually implicitly given by most
+ * bus systems.
+ * However, if you unload a real hw-driver, it *may* restore the previous
+ * firmware-fb or create a new one. In that case, the driver explicitly has to
+ * create a new platform-device and register it via sysfb_register_dyn().
+ * Compared to sysfb_register() this helper also allows adding devices after a
+ * real hw-driver has been probed.
+ *
+ * A system may support multiple firmware-framebuffers. For example, firmware
+ * may set up framebuffers for all available connectors on the
+ * display-controller. However, no such system has been seen in the wild and
+ * given that sysfb is usually only used during boot, the implementation is
+ * limited to a single firmware-framebuffer. However, the API doesn't reflect
+ * that so callers *must not* assume that. On the contrary, we may, at any
+ * point, decide to support multiple framebuffers without changing the API. But
+ * as that requires keeping track of *all* previous apertures, we didn't
+ * implement this now. You're highly encouraged to write proper *real*
+ * hw-drivers if you want more sophisticated access to your graphics-hardware.
+ */
+
+static DEFINE_MUTEX(sysfb_lock);
+static const struct apertures_struct *sysfb_apert;
+static struct platform_device *sysfb_dev;
+
+static int __sysfb_register(struct platform_device *dev,
+			    const struct apertures_struct *apert)
+{
+	int ret;
+
+	if (!IS_ERR_OR_NULL(sysfb_dev)) {
+		dev_info(&dev->dev,
+			 "multiple firmware-framebuffers are not supported\n");
+		return -EALREADY;
+	}
+
+	ret = platform_device_add(dev);
+	if (ret)
+		return ret;
+
+	get_device(&dev->dev);
+	sysfb_apert = apert;
+	sysfb_dev = dev;
+	return 0;
+}
+
+/**
+ * sysfb_register - Register firmware-framebuffer
+ * @dev: Non-registered platform-device for firmware-framebuffer
+ * @apert: Aperture describing the framebuffer location/size or NULL
+ *
+ * This takes an initialized platform-device and registers it with the system
+ * via platform_device_add(). Furthermore, the device is remembered by sysfb so
+ * real-hw drivers can evict the firmware-fb later via sysfb_claim(). The
+ * aperture parameter must be constant and is *not* copied by this helper. You
+ * can usually store it in the platform_data member of the platform-device.
+ * The aperture-object describes the regions of the framebuffer data so it can
+ * be matched against real hw-drivers. Set it to NULL if any hw-driver should
+ * evict this firmware-fb.
+ *
+ * The given platform device must not have been added to the system before this
+ * call! Furthermore, on success, this call takes a reference to the
+ * platform-device so the caller can (and should) drop its own.
+ *
+ * The firmware-framebuffer is unregistered and destroyed if a real hw-driver
+ * calls sysfb_claim() and the firmware-fb matches. You can manually unregister
+ * and destroy the device via sysfb_unregister(), if required. You must keep a
+ * reference to the device then, though.
+ *
+ * If the firmware-fb couldn't be registered, this function will fail. Callers
+ * should *not* try to register the fb themselves. Instead, they must assume a
+ * real hw-driver already took over and the firmware-fb has been invalidated.
+ * Furthermore, if a real-hw driver has been probed before, this call will
+ * always fail and prevent firmware-fbs from getting registered. It is assumed
+ * that the fbs have been invalidated by the real hw. Architecture code should
+ * make sure that firmware-fbs are added *before* any real hw-drivers are
+ * probed, otherwise, the firmware-fbs might not get used.
+ * If you create the firmware-fb on-the-fly, you can use sysfb_register_dyn().
+ *
+ * Currently, we also fail if you try to register multiple firmware-fbs. No such
+ * setup has been seen, yet, and there's no real reason to support multiple
+ * firmware-fbs so we simply drop them. This is an implementation detail and may
+ * change in the future. You can safely ignore it even if you actually have
+ * multiple firmware-fbs.
+ *
+ * sysfb_register() can be called from any context *except* from inside any
+ * callbacks of the platform-device itself. So the ->probe() and ->remove()
+ * callbacks of the driver probed on @dev must not call into sysfb or it will
+ * dead-lock.
+ *
+ * RETURNS:
+ * Returns 0 on success, a negative errno on failure. Callers should usually
+ * ignore the return code and just drop their reference to the platform-device.
+ */
+int sysfb_register(struct platform_device *dev,
+		   const struct apertures_struct *apert)
+{
+	int ret = -EALREADY;
+
+	mutex_lock(&sysfb_lock);
+	if (!IS_ERR(sysfb_dev))
+		ret = __sysfb_register(dev, apert);
+	mutex_unlock(&sysfb_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(sysfb_register);
+
+/**
+ * sysfb_register_dyn - Register firmware-framebuffer dynamically
+ * @dev: Non-registered platform-device for firmware-framebuffer
+ * @apert: Aperture describing the framebuffer location/size or NULL
+ *
+ * This is the same as sysfb_register() but also works if a real hw-driver has
+ * already been loaded. This can be used by real hw-drivers on unload. If they
+ * restore a firmware-framebuffer or leave a new one behind, they can setup a
+ * new platform-device and register it. Generic drivers will then be able to
+ * pick it up again and if a conflicting real hw-driver is probed again, it will
+ * evict it.
+ *
+ * Note that this *must* be called from within a safe unload/remove callback.
+ * The real hw-driver must make sure that this returns before it releases the
+ * real hw resources. Otherwise, another real hw-driver might be probed before
+ * this call returns.
+ *
+ * Usually, this helper is only used to allow unloading, recompiling and
+ * reloading the same real hw-driver and get graphics support in between.
+ *
+ * Note that @apert is *not* copied so you should store it in the platform-data
+ * field of @dev (same as for sysfb_register()).
+ *
+ * RETURNS:
+ * Returns 0 on success, a negative errno on failure. Callers should usually
+ * ignore the return code and just drop their reference to the platform-device.
+ */
+int sysfb_register_dyn(struct platform_device *dev,
+		       const struct apertures_struct *apert)
+{
+	int ret;
+
+	mutex_lock(&sysfb_lock);
+	ret = __sysfb_register(dev, apert);
+	mutex_unlock(&sysfb_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(sysfb_register_dyn);
+
+/**
+ * sysfb_unregister - Unregister firmware-framebuffer
+ * @dev: Firmware-framebuffer to unregister
+ *
+ * This undoes sysfb_register(). Usually a caller should just drop the
+ * reference to its platform-device and never call this. However, if it has its
+ * own detection when a platform-framebuffer gets invalidated, it can keep a
+ * reference and call this once the fb is invalid.
+ *
+ * If a real hw-driver has already evicted the firmware-fb, this does nothing.
+ * If, and only if the firmware-fb hasn't been evicted, yet, another firmware-fb
+ * can be registered via sysfb_register() afterwards. It is assumed that the
+ * caller of sysfb_unregister() knows what they're doing.
+ *
+ * sysfb_unregister() can be called from any context *except* from inside any
+ * callbacks of the platform-device itself. So the ->probe() and ->remove()
+ * callbacks of the driver probed on @dev must not call into sysfb or it will
+ * dead-lock.
+ */
+void sysfb_unregister(struct platform_device *dev)
+{
+	mutex_lock(&sysfb_lock);
+	if (sysfb_dev == dev) {
+		platform_device_del(dev);
+		put_device(&dev->dev);
+
+		/* allow new firmware-fbs as it has been explicitly removed */
+		sysfb_dev = NULL;
+		sysfb_apert = NULL;
+	}
+	mutex_unlock(&sysfb_lock);
+}
+EXPORT_SYMBOL(sysfb_unregister);
+
+/**
+ * __sysfb_match - Test whether hw conflicts with firmware-fb
+ * @apert: Apertures describing the real hw or NULL
+ * @flags: Matching flags
+ *
+ * This tests whether the apertures given in @apert overlap with any registered
+ * firmware-fb. If @apert is NULL, it is ignored. As we currently support only
+ * a single firmware-fb, the firmware-fb to match against is passed implicitly.
+ *
+ * Several flags are supported:
+ *   SYSFB_CLAIM_ALL: Regardless of @apert, this always matches. Should be used
+ *     if apertures are unknown.
+ *   SYSFB_CLAIM_SHADOW: Additionally to aperture matching, this also matches
+ *     against shadow mapped firmware-framebuffers. HW-drivers should use hints
+ *     like IORESOURCE_ROM_SHADOW to set/unset this flag.
+ *     Shadow mapped firmware-fbs include PCI-BARs mapped into VGA/VESA regions
+ *     for backwards-compatibility and alike.
+ *
+ * RETURNS:
+ * Returns true if the given apertures conflict with the registered firmware-fb,
+ * false if not.
+ */
+static bool __sysfb_match(const struct apertures_struct *apert,
+			  unsigned int flags)
+{
+	bool claim_shadow = flags & SYSFB_CLAIM_SHADOW;
+	const struct aperture *a, *b;
+	size_t i, j;
+
+	if (flags & SYSFB_CLAIM_ALL || !sysfb_apert)
+		return true;
+
+	for (i = 0; i < sysfb_apert->count; ++i) {
+		a = &sysfb_apert->ranges[i];
+
+		/* VBE/VESA base address is 0xA0000 */
+		if (claim_shadow && a->base == 0xA0000)
+			return true;
+		if (!apert)
+			continue;
+
+		for (j = 0; j < apert->count; ++j) {
+			b = &apert->ranges[j];
+
+			if (a->base >= b->base &&
+			    a->base < b->base + b->size)
+				return true;
+			if (b->base >= a->base &&
+			    b->base < a->base + a->size)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * sysfb_claim - Claim hw-resources and evict conflicting firmware-fbs
+ * @apert: Apertures describing real hw-resources or NULL
+ * @flags: Matching flags
+ *
+ * This shall be called by real hw-drivers to evict all firmware-fbs that
+ * conflict with the real hardware-driver. @apert describes the apertures of
+ * the real hw and is matched against the registered firmware-framebuffers.
+ * @flags contains some additional flags to control matching behavior. See
+ * __sysfb_match() for a description of the matching behavior.
+ *
+ * Note that after this has been called *once*, no new firmware-fb will be able
+ * to get registered. So even when unloading the real-hw driver, no firmware-fb
+ * will take over again. This is to protect against hw-drivers which don't
+ * restore the firmware fb correctly. See sysfb_register_dyn() for a safe
+ * exception to this rule.
+ *
+ * This must not be called from atomic-contexts. This also does *not* protect
+ * multiple real hw-drivers from each other. Real hw-drivers should use their
+ * underlying bus (pci, usb, platform, ..) to correctly bind to real resources.
+ * The sysfb_claim() helper only evicts pseudo-devices that were registered as
+ * firmware-framebuffers.
+ *
+ * sysfb_claim() can be called from any context *except* from inside any
+ * callbacks of the platform-device itself. So the ->probe() and ->remove()
+ * callbacks of the driver probed on @dev must not call into sysfb or it will
+ * dead-lock.
+ */
+void sysfb_claim(const struct apertures_struct *apert, unsigned int flags)
+{
+	mutex_lock(&sysfb_lock);
+	if (IS_ERR_OR_NULL(sysfb_dev)) {
+		/* set err to prevent new firmware-fbs to be probed later */
+		sysfb_dev = ERR_PTR(-EALREADY);
+	} else if (__sysfb_match(apert, flags)) {
+		platform_device_unregister(sysfb_dev);
+		put_device(&sysfb_dev->dev);
+		sysfb_dev = ERR_PTR(-EALREADY);
+		sysfb_apert = NULL;
+	}
+	mutex_unlock(&sysfb_lock);
+}
+EXPORT_SYMBOL(sysfb_claim);
diff --git a/include/linux/fb.h b/include/linux/fb.h
index fe6ac95..70695fc 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/backlight.h>
 #include <linux/slab.h>
+#include <linux/sysfb.h>
 #include <asm/io.h>
 
 struct vm_area_struct;
@@ -494,13 +495,7 @@ struct fb_info {
 	/* we need the PCI or similar aperture base/size not
 	   smem_start/size as smem_start may just be an object
 	   allocated inside the aperture so may not actually overlap */
-	struct apertures_struct {
-		unsigned int count;
-		struct aperture {
-			resource_size_t base;
-			resource_size_t size;
-		} ranges[0];
-	} *apertures;
+	struct apertures_struct *apertures;
 
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
 };
diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
index 21983cc..00e3575 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -15,6 +15,7 @@
 #include <drm/drm_fourcc.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
+#include <linux/sysfb.h>
 
 /* format array, use it to initialize a "struct simplefb_format" array */
 #define SIMPLEFB_FORMATS \
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
new file mode 100644
index 0000000..f1638ac
--- /dev/null
+++ b/include/linux/sysfb.h
@@ -0,0 +1,62 @@
+#ifndef _LINUX_SYSFB_H
+#define _LINUX_SYSFB_H
+
+/*
+ * Generic System Framebuffers
+ * Copyright (c) 2012-2014 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+struct platform_device;
+
+struct apertures_struct {
+	unsigned int count;
+	struct aperture {
+		resource_size_t base;
+		resource_size_t size;
+	} ranges[0];
+};
+
+enum sysfb_claim_flags {
+	SYSFB_CLAIM_ALL			= 0x01,
+	SYSFB_CLAIM_SHADOW		= 0x02,
+};
+
+#ifdef CONFIG_SYSFB
+
+int sysfb_register(struct platform_device *dev,
+		   const struct apertures_struct *apert);
+int sysfb_register_dyn(struct platform_device *dev,
+		       const struct apertures_struct *apert);
+void sysfb_unregister(struct platform_device *dev);
+void sysfb_claim(const struct apertures_struct *apert, unsigned int flags);
+
+#else /* CONFIG_SYSFB */
+
+static inline int sysfb_register(struct platform_device *dev,
+				 const struct apertures_struct *apert)
+{
+	return -ENOSYS;
+}
+
+static inline int sysfb_register_dyn(struct platform_device *dev,
+				     const struct apertures_struct *apert)
+{
+	return -ENOSYS;
+}
+
+static inline void sysfb_unregister(struct platform_device *dev) { }
+
+static inline void sysfb_claim(const struct apertures_struct *apert,
+			       unsigned int flags) { }
+
+#endif /* CONFIG_SYSFB */
+
+#endif /* _LINUX_SYSFB_H */
-- 
1.8.5.3

