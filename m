Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaJQVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:15:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:34699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaJQVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:15:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,741,1406617200"; 
   d="scan'208";a="620775036"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linuxppc-dev@lists.ozlabs.org, platform-driver-x86@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jens Frederich <jfrederich@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
Date: Sat, 18 Oct 2014 00:13:23 +0300
Message-Id: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
X-Mailer: git-send-email 2.1.1
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/kbuild/kconfig-language.txt warns to use select with care,
and in general use select only for non-visible symbols and for symbols
with no dependencies, because select will force a symbol to a value
without visiting the dependencies.

Select has become particularly problematic, interdependently, with the
BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO configs. For example:

scripts/kconfig/conf --randconfig Kconfig
KCONFIG_SEED=0x48312B00
warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
&& FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
&& FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)

With tristates it's possible to end up selecting FOO=y depending on
BAR=m in the config, which gets discovered at build time, not config
time, like reported in the thread referenced below.

Do the following to fix the dependencies:

* Depend on instead of select BACKLIGHT_CLASS_DEVICE everywhere. Drop
  select BACKLIGHT_LCD_SUPPORT in such cases, as it's a dependency of
  BACKLIGHT_CLASS_DEVICE.

* Remove config FB_BACKLIGHT altogether, and replace it with a
  dependency on BACKLIGHT_CLASS_DEVICE. All configs selecting
  FB_BACKLIGHT select or depend on FB anyway, so we can simplify.

* Depend on (ACPI && ACPI_VIDEO) || ACPI=n in several places instead of
  selecting ACPI_VIDEO and a number of its dependencies if ACPI is
  enabled. This is tied to backlight, as ACPI_VIDEO depends on
  BACKLIGHT_CLASS_DEVICE.

* Replace a couple of select INPUT/VT with depends as it seemed to be
  necessary.

Reference: http://lkml.kernel.org/r/CA+r1ZhhmT4DrWtf6MbRQo5EqXwx+LxCqh15Vsu_d9WpftLhnxw@mail.gmail.com
Reported-by: Jim Davis <jim.epost@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jens Frederich <jfrederich@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

Sorry for the huge distribution; this is really quite hard to split up
sensibly without breaking the build!
---
 drivers/gpu/drm/Kconfig            |  2 +-
 drivers/gpu/drm/gma500/Kconfig     |  4 +---
 drivers/gpu/drm/i915/Kconfig       |  9 ++-------
 drivers/gpu/drm/nouveau/Kconfig    | 10 ++--------
 drivers/gpu/drm/shmobile/Kconfig   |  2 +-
 drivers/gpu/drm/tilcdc/Kconfig     |  3 +--
 drivers/macintosh/Kconfig          |  2 +-
 drivers/platform/x86/Kconfig       | 19 ++++++++-----------
 drivers/staging/olpc_dcon/Kconfig  |  2 +-
 drivers/usb/misc/Kconfig           |  3 +--
 drivers/video/fbdev/Kconfig        | 29 +++++++++++------------------
 drivers/video/fbdev/core/fbsysfs.c |  8 ++++----
 include/linux/fb.h                 |  2 +-
 include/uapi/linux/fb.h            |  2 +-
 14 files changed, 36 insertions(+), 61 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index e3b4b0f02b3d..dc789d0e293c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -99,6 +99,7 @@ config DRM_R128
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI
+	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -108,7 +109,6 @@ config DRM_RADEON
         select DRM_TTM
 	select POWER_SUPPLY
 	select HWMON
-	select BACKLIGHT_CLASS_DEVICE
 	select INTERVAL_TREE
 	select MMU_NOTIFIER
 	help
diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
index 17f928ec84ea..a84d0a4fcc58 100644
--- a/drivers/gpu/drm/gma500/Kconfig
+++ b/drivers/gpu/drm/gma500/Kconfig
@@ -8,9 +8,7 @@ config DRM_GMA500
 	select DRM_KMS_FB_HELPER
 	select DRM_TTM
 	# GMA500 depends on ACPI_VIDEO when ACPI is enabled, just like i915
-	select ACPI_VIDEO if ACPI
-	select BACKLIGHT_CLASS_DEVICE if ACPI
-	select INPUT if ACPI
+	depends on (ACPI && ACPI_VIDEO) || ACPI=n
 	help
 	  Say yes for an experimental 2D KMS framebuffer driver for the
 	  Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 4e39ab34eb1c..75d4c52c0971 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -3,6 +3,8 @@ config DRM_I915
 	depends on DRM
 	depends on X86 && PCI
 	depends on (AGP || AGP=n)
+	depends on (ACPI && ACPI_VIDEO) || ACPI=n
+	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n
 	select INTEL_GTT
 	select AGP_INTEL if AGP
 	select INTERVAL_TREE
@@ -11,13 +13,6 @@ config DRM_I915
 	select SHMEM
 	select TMPFS
 	select DRM_KMS_HELPER
-	# i915 depends on ACPI_VIDEO when ACPI is enabled
-	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
-	select BACKLIGHT_LCD_SUPPORT if ACPI
-	select BACKLIGHT_CLASS_DEVICE if ACPI
-	select INPUT if ACPI
-	select ACPI_VIDEO if ACPI
-	select ACPI_BUTTON if ACPI
 	help
 	  Choose this option if you have a system that has "Intel Graphics
 	  Media Accelerator" or "HD Graphics" integrated graphics,
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 40afc69a3778..40227fc4f284 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -1,6 +1,7 @@
 config DRM_NOUVEAU
 	tristate "Nouveau (NVIDIA) cards"
 	depends on DRM && PCI
+	depends on (ACPI && ACPI_VIDEO) || ACPI=n
         select FW_LOADER
 	select DRM_KMS_HELPER
 	select DRM_KMS_FB_HELPER
@@ -10,18 +11,10 @@ config DRM_NOUVEAU
 	select FB_CFB_IMAGEBLIT
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EXPERT
-	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
-	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && INPUT
 	select X86_PLATFORM_DEVICES if ACPI && X86
 	select ACPI_WMI if ACPI && X86
 	select MXM_WMI if ACPI && X86
 	select POWER_SUPPLY
-	# Similar to i915, we need to select ACPI_VIDEO and it's dependencies
-	select BACKLIGHT_LCD_SUPPORT if ACPI && X86
-	select BACKLIGHT_CLASS_DEVICE if ACPI && X86
-	select INPUT if ACPI && X86
-	select THERMAL if ACPI && X86
-	select ACPI_VIDEO if ACPI && X86
 	help
 	  Choose this option for open-source NVIDIA support.
 
@@ -64,6 +57,7 @@ config NOUVEAU_DEBUG_DEFAULT
 config DRM_NOUVEAU_BACKLIGHT
 	bool "Support for backlight control"
 	depends on DRM_NOUVEAU
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display
diff --git a/drivers/gpu/drm/shmobile/Kconfig b/drivers/gpu/drm/shmobile/Kconfig
index a50fe0eeaa0d..71c00f3c0fbc 100644
--- a/drivers/gpu/drm/shmobile/Kconfig
+++ b/drivers/gpu/drm/shmobile/Kconfig
@@ -2,7 +2,7 @@ config DRM_SHMOBILE
 	tristate "DRM Support for SH Mobile"
 	depends on DRM && ARM
 	depends on ARCH_SHMOBILE || COMPILE_TEST
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	select DRM_KMS_HELPER
 	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
diff --git a/drivers/gpu/drm/tilcdc/Kconfig b/drivers/gpu/drm/tilcdc/Kconfig
index 7c3ef79fcb37..52e60feaae53 100644
--- a/drivers/gpu/drm/tilcdc/Kconfig
+++ b/drivers/gpu/drm/tilcdc/Kconfig
@@ -1,13 +1,12 @@
 config DRM_TILCDC
 	tristate "DRM Support for TI LCDC Display Controller"
 	depends on DRM && OF && ARM
+	depends on BACKLIGHT_CLASS_DEVICE
 	select DRM_KMS_HELPER
 	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
 	select VIDEOMODE_HELPERS
-	select BACKLIGHT_CLASS_DEVICE
-	select BACKLIGHT_LCD_SUPPORT
 	help
 	  Choose this option if you have an TI SoC with LCDC display
 	  controller, for example AM33xx in beagle-bone, DA8xx, or
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 3067d56b11a6..50cb2c3b567e 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -135,7 +135,7 @@ config PMAC_MEDIABAY
 config PMAC_BACKLIGHT
 	bool "Backlight control for LCD screens"
 	depends on ADB_PMU && FB = y && (BROKEN || !PPC64)
-	select FB_BACKLIGHT
+	depends on BACKLIGHT_CLASS_DEVICE
 	help
 	  Say Y here to enable Macintosh specific extensions of the generic
 	  backlight code. With this enabled, the brightness keys on older
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4dcfb7116a04..63e99ce0e3f8 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -17,7 +17,7 @@ if X86_PLATFORM_DEVICES
 
 config ACER_WMI
 	tristate "Acer WMI Laptop Extras"
-	depends on ACPI
+	depends on ACPI && ACPI_VIDEO
 	select LEDS_CLASS
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -26,8 +26,6 @@ config ACER_WMI
 	depends on RFKILL || RFKILL = n
 	depends on ACPI_WMI
 	select INPUT_SPARSEKMAP
-	# Acer WMI depends on ACPI_VIDEO when ACPI is enabled
-        select ACPI_VIDEO if ACPI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
 	  wireless radio and bluetooth control, and on some laptops,
@@ -70,7 +68,7 @@ config ASUS_LAPTOP
 	depends on ACPI
 	select LEDS_CLASS
 	select NEW_LEDS
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
 	select INPUT_SPARSEKMAP
@@ -294,7 +292,7 @@ config COMPAL_LAPTOP
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
 	depends on ACPI
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
 	depends on RFKILL
 	  ---help---
@@ -329,8 +327,7 @@ config THINKPAD_ACPI
 	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select NVRAM
 	select NEW_LEDS
@@ -499,7 +496,7 @@ config EEEPC_LAPTOP
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
 	depends on HOTPLUG_PCI
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select LEDS_CLASS
 	select NEW_LEDS
@@ -675,8 +672,8 @@ config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
 	depends on X86 && ACPI
 	depends on RFKILL || RFKILL=n
-	select INPUT
-	select BACKLIGHT_CLASS_DEVICE
+	depends on INPUT
+	depends on BACKLIGHT_CLASS_DEVICE
 	default n
 	help
 	  Support for Intel Classmate PC ACPI devices, including some
@@ -805,7 +802,7 @@ config INTEL_OAKTRAIL
 config SAMSUNG_Q10
 	tristate "Samsung Q10 Extras"
 	depends on ACPI
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver provides support for backlight control on Samsung Q10
 	  and related laptops, including Dell Latitude X200.
diff --git a/drivers/staging/olpc_dcon/Kconfig b/drivers/staging/olpc_dcon/Kconfig
index d277f048789e..94acb4279704 100644
--- a/drivers/staging/olpc_dcon/Kconfig
+++ b/drivers/staging/olpc_dcon/Kconfig
@@ -3,7 +3,7 @@ config FB_OLPC_DCON
 	depends on OLPC && FB
 	depends on I2C
 	depends on (GPIO_CS5535 || GPIO_CS5535=n)
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	---help---
 	  In order to support very low power operation, the XO laptop uses a
 	  secondary Display CONtroller, or DCON.  This secondary controller
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 76d77206e011..824630b09662 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -150,8 +150,7 @@ config USB_FTDI_ELAN
 
 config USB_APPLEDISPLAY
 	tristate "Apple Cinema Display support"
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	help
 	  Say Y here if you want to control the backlight of Apple Cinema
 	  Displays over USB. This driver provides a sysfs interface.
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index ccbe2ae22ac5..8cae7da2c723 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -185,13 +185,6 @@ config FB_MACMODES
        depends on FB
        default n
 
-config FB_BACKLIGHT
-	bool
-	depends on FB
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
-	default n
-
 config FB_MODE_HELPERS
         bool "Enable Video Mode Handling Helpers"
         depends on FB
@@ -323,7 +316,7 @@ config FB_CLPS711X
 	tristate "CLPS711X LCD support"
 	depends on FB && (ARCH_CLPS711X || COMPILE_TEST)
 	select FB_CLPS711X_OLD if ARCH_CLPS711X && !ARCH_MULTIPLATFORM
-	select BACKLIGHT_LCD_SUPPORT
+	depends on BACKLIGHT_LCD_SUPPORT
 	select FB_MODE_HELPERS
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
@@ -351,7 +344,7 @@ config FB_SA1100
 config FB_IMX
 	tristate "Freescale i.MX1/21/25/27 LCD support"
 	depends on FB && ARCH_MXC
-	select BACKLIGHT_LCD_SUPPORT
+	depends on BACKLIGHT_LCD_SUPPORT
 	select LCD_CLASS_DEVICE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -674,7 +667,7 @@ config FB_STI
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select STI_CONSOLE
-	select VT
+	depends on VT
 	default y
 	---help---
 	  STI refers to the HP "Standard Text Interface" which is a set of
@@ -990,7 +983,7 @@ config FB_S1D13XXX
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
 	depends on FB && HAVE_FB_ATMEL
-	select FB_BACKLIGHT
+	depends on BACKLIGHT_CLASS_DEVICE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1019,7 +1012,6 @@ config FB_ATMEL_STN
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
 	depends on FB && PCI
-	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1060,6 +1052,7 @@ config FB_NVIDIA_DEBUG
 config FB_NVIDIA_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_NVIDIA
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1067,7 +1060,6 @@ config FB_NVIDIA_BACKLIGHT
 config FB_RIVA
 	tristate "nVidia Riva support"
 	depends on FB && PCI
-	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1107,6 +1099,7 @@ config FB_RIVA_DEBUG
 config FB_RIVA_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_RIVA
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1345,7 +1338,6 @@ config FB_MATROX_MAVEN
 config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
-	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1370,6 +1362,7 @@ config FB_RADEON_I2C
 config FB_RADEON_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_RADEON
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1389,7 +1382,6 @@ config FB_ATY128
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
 	select FB_MACMODES if PPC_PMAC
 	help
 	  This driver supports graphics boards with the ATI Rage128 chips.
@@ -1402,6 +1394,7 @@ config FB_ATY128
 config FB_ATY128_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_ATY128
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1412,7 +1405,6 @@ config FB_ATY
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
 	select FB_MACMODES if PPC
 	help
 	  This driver supports graphics boards with the ATI Mach64 chips.
@@ -1452,6 +1444,7 @@ config FB_ATY_GX
 config FB_ATY_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_ATY
+	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1997,12 +1990,12 @@ config FB_SH_MOBILE_LCDC
 	tristate "SuperH Mobile LCDC framebuffer support"
 	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
 	depends on FB_SH_MOBILE_MERAM || !FB_SH_MOBILE_MERAM
+	depends on BACKLIGHT_CLASS_DEVICE
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_SYS_FOPS
 	select FB_DEFERRED_IO
-	select FB_BACKLIGHT
 	select SH_MIPI_DSI if SH_LCD_MIPI_DSI
 	---help---
 	  Frame buffer driver for the on-chip SH-Mobile LCD controller.
@@ -2356,10 +2349,10 @@ config FB_MSM
 config FB_MX3
 	tristate "MX3 Framebuffer support"
 	depends on FB && MX3_IPU
+	depends on BACKLIGHT_CLASS_DEVICE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  This is a framebuffer device for the i.MX31 LCD Controller. So
diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 53444ac19fe0..8f766f14038e 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -59,7 +59,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 
 	info->device = dev;
 
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 	mutex_init(&info->bl_curve_mutex);
 #endif
 
@@ -428,7 +428,7 @@ static ssize_t show_fbstate(struct device *device,
 	return snprintf(buf, PAGE_SIZE, "%d\n", fb_info->state);
 }
 
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 static ssize_t store_bl_curve(struct device *device,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
@@ -517,7 +517,7 @@ static struct device_attribute device_attrs[] = {
 	__ATTR(stride, S_IRUGO, show_stride, NULL),
 	__ATTR(rotate, S_IRUGO|S_IWUSR, show_rotate, store_rotate),
 	__ATTR(state, S_IRUGO|S_IWUSR, show_fbstate, store_fbstate),
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 	__ATTR(bl_curve, S_IRUGO|S_IWUSR, show_bl_curve, store_bl_curve),
 #endif
 };
@@ -558,7 +558,7 @@ void fb_cleanup_device(struct fb_info *fb_info)
 	}
 }
 
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 /* This function generates a linear backlight curve
  *
  *     0: off
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 09bb7a18d287..47e7742fdc9e 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -461,7 +461,7 @@ struct fb_info {
 	struct list_head modelist;      /* mode list */
 	struct fb_videomode *mode;	/* current mode */
 
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 	/* assigned backlight device */
 	/* set before framebuffer registration, 
 	   remove after unregister */
diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
index fb795c3b3c17..a7a4be063432 100644
--- a/include/uapi/linux/fb.h
+++ b/include/uapi/linux/fb.h
@@ -392,7 +392,7 @@ struct fb_cursor {
 	struct fb_image	image;	/* Cursor image */
 };
 
-#ifdef CONFIG_FB_BACKLIGHT
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
 /* Settings for the generic backlight code */
 #define FB_BACKLIGHT_LEVELS	128
 #define FB_BACKLIGHT_MAX	0xFF
-- 
2.1.1

