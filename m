Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3IIImV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:42:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:29474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab3IIImT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:42:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="375384404"
Message-ID: <522D89EC.6050103@intel.com>
Date: Mon, 09 Sep 2013 16:42:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if firmware
 expects Windows 8
References: <522D88C3.7000808@intel.com>
In-Reply-To: <522D88C3.7000808@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Matthew Garrett, "Windows 8 leaves backlight control up
to individual graphics drivers rather than making ACPI calls itself.
There's plenty of evidence to suggest that the Intel driver for
Windows [8] doesn't use the ACPI interface, including the fact that
it's broken on a bunch of machines when the OS claims to support
Windows 8.  The simplest thing to do appears to be to disable the
ACPI backlight interface on these systems".

There's a problem with that approach, however, because simply
avoiding to register the ACPI backlight interface if the firmware
calls _OSI for Windows 8 may not work in the following situations:
 (1) The ACPI backlight interface actually works on the given system
     and the i915 driver is not loaded (e.g. another graphics driver
     is used).
 (2) The ACPI backlight interface doesn't work on the given system,
     but there is a vendor platform driver that will register its
     own, equally broken, backlight interface if not prevented from
     doing so by the ACPI subsystem.
Therefore we need to allow the ACPI backlight interface to be
registered until the i915 driver is loaded which then will unregister
it if the firmware has called _OSI for Windows 8 (or will register
the ACPI video driver without backlight support if not already
present).

For this reason, introduce an alternative function for registering
ACPI video, __acpi_video_register(bool), that if ture is passed,
will check whether or not the ACPI video driver has already been
registered and whether or not the backlight Windows 8 quirk has to
be applied. If the quirk has to be applied, it will block the ACPI
backlight support and either unregister the backlight interface if
the ACPI video driver has already been registered, or register the
ACPI video driver without the backlight interface otherwise.  Make
the i915 driver use __acpi_video_register() instead of
acpi_video_register() in i915_driver_load(), and the param passed
there is controlled by the i915 module level parameter
i915_take_over_backlight, which is set to false by default.

This change is evolved from earlier patches of Matthew Garrett,
Chun-Yi Lee and Seth Forshee and is heavily based on two patches
from Rafael:
https://lkml.org/lkml/2013/7/17/720
https://lkml.org/lkml/2013/7/24/806

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/internal.h         |  2 ++
 drivers/acpi/video.c            | 24 ++++++++++++++++--------
 drivers/acpi/video_detect.c     | 15 ++++++++++++++-
 drivers/gpu/drm/i915/i915_dma.c |  2 +-
 drivers/gpu/drm/i915/i915_drv.c |  5 +++++
 drivers/gpu/drm/i915/i915_drv.h |  1 +
 include/acpi/video.h            |  9 +++++++--
 include/linux/acpi.h            |  1 +
 8 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 20f4233..a53832e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -170,8 +170,10 @@ int acpi_create_platform_device(struct acpi_device *adev,
   -------------------------------------------------------------------------- */
 #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
 bool acpi_video_backlight_quirks(void);
+bool acpi_video_verify_backlight_support(void);
 #else
 static inline bool acpi_video_backlight_quirks(void) { return false; }
+static inline bool acpi_video_verify_backlight_support(void) { return false; }
 #endif
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5ad5a71..cc709a7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1256,8 +1256,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
 	unsigned long long level_current, level_next;
 	int result = -EINVAL;
 
-	/* no warning message if acpi_backlight=vendor is used */
-	if (!acpi_video_backlight_support())
+	/* no warning message if acpi_backlight=vendor or a quirk is used */
+	if (!acpi_video_verify_backlight_support())
 		return 0;
 
 	if (!device->brightness)
@@ -1558,7 +1558,7 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
 
 static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 {
-	if (acpi_video_backlight_support()) {
+	if (acpi_video_verify_backlight_support()) {
 		struct backlight_properties props;
 		struct pci_dev *pdev;
 		acpi_handle acpi_parent;
@@ -1933,14 +1933,22 @@ static int __init intel_opregion_present(void)
 	return opregion;
 }
 
-int acpi_video_register(void)
+int __acpi_video_register(bool backlight_quirks)
 {
-	int result = 0;
+	bool no_backlight;
+	int result;
+
+	no_backlight = backlight_quirks ? acpi_video_backlight_quirks() : false;
+
 	if (register_count) {
 		/*
-		 * if the function of acpi_video_register is already called,
-		 * don't register the acpi_vide_bus again and return no error.
+		 * If acpi_video_register() has been called already, don't try
+		 * to register acpi_video_bus, but unregister backlight devices
+		 * if no backlight support is requested.
 		 */
+		if (no_backlight)
+			acpi_video_unregister_backlight();
+
 		return 0;
 	}
 
@@ -1959,7 +1967,7 @@ int acpi_video_register(void)
 
 	return 0;
 }
-EXPORT_SYMBOL(acpi_video_register);
+EXPORT_SYMBOL(__acpi_video_register);
 
 void acpi_video_unregister(void)
 {
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 940edbf..c7e43ec 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -235,7 +235,12 @@ static void acpi_video_caps_check(void)
 
 bool acpi_video_backlight_quirks(void)
 {
-	return acpi_gbl_osi_data >= ACPI_OSI_WIN_8;
+	if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8) {
+		acpi_video_caps_check();
+		acpi_video_support |= ACPI_VIDEO_SKIP_BACKLIGHT;
+		return true;
+	}
+	return false;
 }
 EXPORT_SYMBOL(acpi_video_backlight_quirks);
 
@@ -283,6 +288,14 @@ int acpi_video_backlight_support(void)
 }
 EXPORT_SYMBOL(acpi_video_backlight_support);
 
+/* For the ACPI video driver use only. */
+bool acpi_video_verify_backlight_support(void)
+{
+	return (acpi_video_support & ACPI_VIDEO_SKIP_BACKLIGHT) ?
+		false : acpi_video_backlight_support();
+}
+EXPORT_SYMBOL(acpi_video_verify_backlight_support);
+
 /*
  * Use acpi_backlight=vendor/video to force that backlight switching
  * is processed by vendor specific acpi drivers or video.ko driver.
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index f466980..75fba17 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1650,7 +1650,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (INTEL_INFO(dev)->num_pipes) {
 		/* Must be done after probing outputs */
 		intel_opregion_init(dev);
-		acpi_video_register();
+		__acpi_video_register(i915_take_over_backlight);
 	}
 
 	if (IS_GEN5(dev))
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 45b3c03..b014398 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -132,6 +132,11 @@ int i915_enable_ips __read_mostly = 1;
 module_param_named(enable_ips, i915_enable_ips, int, 0600);
 MODULE_PARM_DESC(enable_ips, "Enable IPS (default: true)");
 
+bool i915_take_over_backlight = false;
+module_param_named(take_over_backlight, i915_take_over_backlight, bool, 0644);
+MODULE_PARM_DESC(take_over_backlight,
+		"Prevent ACPI backlight from being used (default: false)");
+
 static struct drm_driver driver;
 extern int intel_agp_enabled;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1929bff..b43c430 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1543,6 +1543,7 @@ extern int i915_enable_ppgtt __read_mostly;
 extern unsigned int i915_preliminary_hw_support __read_mostly;
 extern int i915_disable_power_well __read_mostly;
 extern int i915_enable_ips __read_mostly;
+extern bool i915_take_over_backlight __read_mostly;
 
 extern int i915_suspend(struct drm_device *dev, pm_message_t state);
 extern int i915_resume(struct drm_device *dev);
diff --git a/include/acpi/video.h b/include/acpi/video.h
index 0c665b5..dc5b8ad 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -17,13 +17,13 @@ struct acpi_device;
 #define ACPI_VIDEO_DISPLAY_LEGACY_TV      0x0200
 
 #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
-extern int acpi_video_register(void);
+extern int __acpi_video_register(bool backlight_quirks);
 extern void acpi_video_unregister(void);
 extern int acpi_video_unregister_backlight(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
-static inline int acpi_video_register(void) { return 0; }
+static inline int __acpi_video_register(bool backlight_quirks) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
 static inline int acpi_video_unregister_backlight(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
@@ -33,4 +33,9 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 }
 #endif
 
+static inline int acpi_video_register(void)
+{
+	return __acpi_video_register(false);
+}
+
 #endif
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index a5db4ae..a0dcce5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -191,6 +191,7 @@ extern bool wmi_has_guid(const char *guid);
 #define ACPI_VIDEO_BACKLIGHT_DMI_VIDEO			0x0200
 #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VENDOR		0x0400
 #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VIDEO		0x0800
+#define ACPI_VIDEO_SKIP_BACKLIGHT			0x1000
 
 #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
 
-- 
1.8.4.12.g2ea3df6

