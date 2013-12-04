Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3LDAn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:43:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:30949 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab3LDAn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:43:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="418912964"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org
Subject: [PATCH 1/3] ACPI/i915: Fix wrong <acpi/acpi.h> inclusion in i915 opregion module.
Date: Wed,  4 Dec 2013 08:38:08 +0800
Message-Id: <58025298b10c01a76adeed0f27e12d4b764ad99c.1386116927.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1386116927.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386116927.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
all external modules should depend on CONFIG_ACPI rather than using ACPICA
header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
dependent modules.

One of the build breakage is:
include/linux/acpi_io.h:7:45: error: unknown type name 'acpi_physical_address'
include/linux/acpi_io.h:8:10: error: unknown type name 'acpi_size'
include/linux/acpi_io.h:13:33: error: unknown type name 'acpi_physical_address'
include/linux/acpi_io.h:15:40: warning: 'struct acpi_generic_address' declared inside parameter list [enabled by default]
include/linux/acpi_io.h:15:40: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/acpi_io.h:16:43: warning: 'struct acpi_generic_address' declared inside parameter list [enabled by default]
drivers/gpu/drm/i915/intel_opregion.c: In function 'intel_opregion_setup':
drivers/gpu/drm/i915/intel_opregion.c:883:2: error: implicit declaration of function 'acpi_os_ioremap' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/intel_opregion.c:883:7: warning: assignment makes pointer from integer without a cast [enabled by default]

The root causes of this breakage are:
1. The <linux/acpi_io.h> depends on CONFIG_ACPI=y as most of the prototypes
   exported by it are implemented in drivers/acpi/osl.c.
2. CONFIG_DRM_I915 uses the only "inline" function acpi_os_ioremap() to
   implement stubs but it shouldn't.

Since ACPI IGD OpRegion is an ACPI-based mechanism, (please refer to the
Doclink below), this patch fixes this issue by making
drivers/gpu/drm/i915/intel_opregion.c dependent on CONFIG_ACPI.  This is
identical to other Intel DRM drivers' OpRegion support (e.x.,
drivers/gpu/drm/gma500/opregion.c).

Since acpi_io.h is not safe for CONFIG_ACPI=y environment, this patch also
moves it to include/acpi, includes it in <linux/acpi.h> for CONFIG_ACPI=y
build environment and cleans up its inclusions by converting them into
<linux/acpi.h> inclusions.

Doclink: https://01.org/linuxgraphics/sites/default/files/documentation/acpi_igd_opregion_spec.pdf
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/apei/apei-base.c     |    1 -
 drivers/acpi/apei/apei-internal.h |    1 -
 drivers/acpi/apei/ghes.c          |    1 -
 drivers/acpi/nvs.c                |    1 -
 drivers/acpi/osl.c                |    1 -
 drivers/gpu/drm/gma500/opregion.c |    1 -
 drivers/gpu/drm/i915/Makefile     |    3 +--
 drivers/gpu/drm/i915/i915_drv.h   |    3 ++-
 include/acpi/acpi_io.h            |   17 +++++++++++++++++
 include/linux/acpi.h              |    1 +
 include/linux/acpi_io.h           |   18 ------------------
 11 files changed, 21 insertions(+), 27 deletions(-)
 create mode 100644 include/acpi/acpi_io.h
 delete mode 100644 include/linux/acpi_io.h

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 6d2c49b..0760b75 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/kref.h>
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index 21ba34a..e5bcd91 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -8,7 +8,6 @@
 
 #include <linux/cper.h>
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 
 struct apei_exec_context;
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a30bc31..694c486 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 386a9fe..ef28613 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 
 /* ACPI NVS regions, APEI may use it */
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 7e2d814..63251b6 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -39,7 +39,6 @@
 #include <linux/workqueue.h>
 #include <linux/nmi.h>
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 #include <linux/efi.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
diff --git a/drivers/gpu/drm/gma500/opregion.c b/drivers/gpu/drm/gma500/opregion.c
index ad0d6de..13ec628 100644
--- a/drivers/gpu/drm/gma500/opregion.c
+++ b/drivers/gpu/drm/gma500/opregion.c
@@ -22,7 +22,6 @@
  *
  */
 #include <linux/acpi.h>
-#include <linux/acpi_io.h>
 #include "psb_drv.h"
 #include "psb_intel_reg.h"
 
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 41838ea..d4ae48b 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -38,7 +38,6 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o \
 	  intel_ringbuffer.o \
 	  intel_overlay.o \
 	  intel_sprite.o \
-	  intel_opregion.o \
 	  intel_sideband.o \
 	  intel_uncore.o \
 	  dvo_ch7xxx.o \
@@ -51,7 +50,7 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o \
 
 i915-$(CONFIG_COMPAT)   += i915_ioc32.o
 
-i915-$(CONFIG_ACPI)	+= intel_acpi.o
+i915-$(CONFIG_ACPI)	+= intel_acpi.o intel_opregion.o
 
 i915-$(CONFIG_DRM_I915_FBDEV) += intel_fbdev.o
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index ccdbecc..7f37b83 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2336,8 +2336,8 @@ extern void intel_i2c_reset(struct drm_device *dev);
 
 /* intel_opregion.c */
 struct intel_encoder;
-extern int intel_opregion_setup(struct drm_device *dev);
 #ifdef CONFIG_ACPI
+extern int intel_opregion_setup(struct drm_device *dev);
 extern void intel_opregion_init(struct drm_device *dev);
 extern void intel_opregion_fini(struct drm_device *dev);
 extern void intel_opregion_asle_intr(struct drm_device *dev);
@@ -2346,6 +2346,7 @@ extern int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
 extern int intel_opregion_notify_adapter(struct drm_device *dev,
 					 pci_power_t state);
 #else
+static inline int intel_opregion_setup(struct drm_device *dev) { return 0; }
 static inline void intel_opregion_init(struct drm_device *dev) { return; }
 static inline void intel_opregion_fini(struct drm_device *dev) { return; }
 static inline void intel_opregion_asle_intr(struct drm_device *dev) { return; }
diff --git a/include/acpi/acpi_io.h b/include/acpi/acpi_io.h
new file mode 100644
index 0000000..2be8580
--- /dev/null
+++ b/include/acpi/acpi_io.h
@@ -0,0 +1,17 @@
+#ifndef _ACPI_IO_H_
+#define _ACPI_IO_H_
+
+#include <linux/io.h>
+
+static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
+					    acpi_size size)
+{
+       return ioremap_cache(phys, size);
+}
+
+void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
+
+int acpi_os_map_generic_address(struct acpi_generic_address *addr);
+void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
+
+#endif
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d9099b1..726a6aa 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -42,6 +42,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_numa.h>
+#include <acpi/acpi_io.h>
 #include <asm/acpi.h>
 
 static inline acpi_handle acpi_device_handle(struct acpi_device *adev)
diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
deleted file mode 100644
index 2a5a139..0000000
--- a/include/linux/acpi_io.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _ACPI_IO_H_
-#define _ACPI_IO_H_
-
-#include <linux/io.h>
-#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
-
-static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
-					    acpi_size size)
-{
-       return ioremap_cache(phys, size);
-}
-
-void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
-
-int acpi_os_map_generic_address(struct acpi_generic_address *addr);
-void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
-
-#endif
-- 
1.7.10

