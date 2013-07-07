Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3GGNKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 09:10:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33195 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab3GGNJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 09:09:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lwe@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware expects Windows 8
Date: Sun, 07 Jul 2013 15:19:34 +0200
Message-ID: <12270512.1rshgKaUug@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3467567.zOLDhye8QD@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <51D7AF14.9050508@gmail.com> <3467567.zOLDhye8QD@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 06, 2013 03:33:01 PM Rafael J. Wysocki wrote:
> On Saturday, July 06, 2013 01:45:56 PM Aaron Lu wrote:
> > On 07/06/2013 06:23 AM, Rafael J. Wysocki wrote:
> > > On Friday, July 05, 2013 11:40:02 PM Rafael J. Wysocki wrote:
> > >> On Friday, July 05, 2013 10:00:55 PM Rafael J. Wysocki wrote:
> > >>> On Friday, July 05, 2013 02:20:14 PM Rafael J. Wysocki wrote:
> > >>>> On Sunday, June 09, 2013 07:01:39 PM Matthew Garrett wrote:

[...]

> > >>
> > >> Actually, I wonder what about

[...]

> > > 
> > > Or even something as simple as this one.
> > > 
> > > ---
> > >  drivers/acpi/video_detect.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > Index: linux-pm/drivers/acpi/video_detect.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/acpi/video_detect.c
> > > +++ linux-pm/drivers/acpi/video_detect.c
> > > @@ -203,6 +203,9 @@ long acpi_video_get_capabilities(acpi_ha
> > >  		 */
> > >  
> > >  		dmi_check_system(video_detect_dmi_table);
> > > +
> > > +		if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8)
> > > +			acpi_video_support |= ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
> > 
> > Then vendor driver(thinkpad_acpi) will step in and create a backlight
> > interface for the system, which, unfortunately, is also broken for those
> > win8 thinkpads.
> > 
> > So we will need to do something in thinkpad_acpi to also not create
> > backlight interface for these systems too.
> > 
> > This actually doesn't feel bad to me, since the modules are blacklisting
> > their own interfaces. The downside is of course, two quirk code exist.
> > 
> > BTW, unregistering ACPI video's backlight interface in GPU driver doesn't
> > have this problem since it made the platform driver think the ACPI video
> > driver will control the backlight and then use the newly added API to
> > remove ACPI video created backlight interface.
> 
> Yes, I know this.
> 
> I think I also know how to introduce that change in a slightly cleaner way.
> 
> I'll post a patch for comments later today or tomorrow.

OK, the patch is appended.  Please have a look and tell me what you think.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8

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
     own, equally broken, backlight interface if the ACPI one is not
     registered in advance.
Therefore we need to keep the ACPI backlight interface registered
until the i915 driver is loaded which then will unregister it if
the firmware has called _OSI for Windows 8.

For this reason, introduce an alternative function for registering
ACPI video, acpi_video_register_with_quirks(), that will check
whether or not the ACPI video driver has already been registered
and whether or not the backlight Windows 8 quirk has to be applied.
If the quirk has to be applied, it will block the ACPI backlight
support and either unregister the backlight interface if the ACPI
video driver has already been registered, or register the ACPI
video driver without the backlight interface otherwise.  Make
the i915 driver use acpi_video_register_with_quirks() instead of
acpi_video_register() in i915_driver_load().

This change is based on earlier patches from Matthew Garrett,
Chun-Yi Lee and Seth Forshee.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/video.c            |   61 ++++++++++++++++++++++++++++++++++++----
 drivers/acpi/video_detect.c     |   11 +++++++
 drivers/gpu/drm/i915/i915_dma.c |    2 -
 include/acpi/video.h            |   11 ++++++-
 include/linux/acpi.h            |    6 +++
 5 files changed, 84 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/acpi/video.c
===================================================================
--- linux-pm.orig/drivers/acpi/video.c
+++ linux-pm/drivers/acpi/video.c
@@ -1854,6 +1854,46 @@ static int acpi_video_bus_remove(struct
 	return 0;
 }
 
+static acpi_status video_unregister_backlight(acpi_handle handle, u32 lvl,
+					      void *context, void **rv)
+{
+	struct acpi_device *acpi_dev;
+	struct acpi_video_bus *video;
+	struct acpi_video_device *dev, *next;
+
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		return AE_OK;
+
+	if (acpi_match_device_ids(acpi_dev, video_device_ids))
+		return AE_OK;
+
+	video = acpi_driver_data(acpi_dev);
+	if (!video)
+		return AE_OK;
+
+	acpi_video_bus_stop_devices(video);
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
+		if (dev->backlight) {
+			backlight_device_unregister(dev->backlight);
+			dev->backlight = NULL;
+			kfree(dev->brightness->levels);
+			kfree(dev->brightness);
+		}
+		if (dev->cooling_dev) {
+			sysfs_remove_link(&dev->dev->dev.kobj,
+					  "thermal_cooling");
+			sysfs_remove_link(&dev->cooling_dev->device.kobj,
+					  "device");
+			thermal_cooling_device_unregister(dev->cooling_dev);
+			dev->cooling_dev = NULL;
+		}
+	}
+	mutex_unlock(&video->device_list_lock);
+	acpi_video_bus_start_devices(video);
+	return AE_OK;
+}
+
 static int __init is_i740(struct pci_dev *dev)
 {
 	if (dev->device == 0x00D1)
@@ -1885,14 +1925,25 @@ static int __init intel_opregion_present
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
+			acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+					    ACPI_UINT32_MAX,
+					    video_unregister_backlight,
+					    NULL, NULL, NULL);
+
 		return 0;
 	}
 
@@ -1908,7 +1959,7 @@ int acpi_video_register(void)
 
 	return 0;
 }
-EXPORT_SYMBOL(acpi_video_register);
+EXPORT_SYMBOL(__acpi_video_register);
 
 void acpi_video_unregister(void)
 {
Index: linux-pm/drivers/gpu/drm/i915/i915_dma.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/i915/i915_dma.c
+++ linux-pm/drivers/gpu/drm/i915/i915_dma.c
@@ -1660,7 +1660,7 @@ int i915_driver_load(struct drm_device *
 	if (INTEL_INFO(dev)->num_pipes) {
 		/* Must be done after probing outputs */
 		intel_opregion_init(dev);
-		acpi_video_register();
+		acpi_video_register_with_quirks();
 	}
 
 	if (IS_GEN5(dev))
Index: linux-pm/include/acpi/video.h
===================================================================
--- linux-pm.orig/include/acpi/video.h
+++ linux-pm/include/acpi/video.h
@@ -17,12 +17,21 @@ struct acpi_device;
 #define ACPI_VIDEO_DISPLAY_LEGACY_TV      0x0200
 
 #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
-extern int acpi_video_register(void);
+extern int __acpi_video_register(bool backlight_quirks);
+static inline int acpi_video_register(void)
+{
+	return __acpi_video_register(false);
+}
+static inline int acpi_video_register_with_quirks(void)
+{
+	return __acpi_video_register(true);
+}
 extern void acpi_video_unregister(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
 static inline int acpi_video_register(void) { return 0; }
+static inline int acpi_video_register_with_quirks(void) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 				      int device_id, void **edid)
Index: linux-pm/drivers/acpi/video_detect.c
===================================================================
--- linux-pm.orig/drivers/acpi/video_detect.c
+++ linux-pm/drivers/acpi/video_detect.c
@@ -234,6 +234,17 @@ static void acpi_video_caps_check(void)
 		acpi_video_get_capabilities(NULL);
 }
 
+bool acpi_video_backlight_quirks(void)
+{
+	if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8) {
+		acpi_video_caps_check();
+		acpi_video_support |= ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(acpi_video_backlight_quirks);
+
 /* Promote the vendor interface instead of the generic video module.
  * This function allow DMI blacklists to be implemented by externals
  * platform drivers instead of putting a big blacklist in video_detect.c
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -196,6 +196,7 @@ extern bool wmi_has_guid(const char *gui
 
 extern long acpi_video_get_capabilities(acpi_handle graphics_dev_handle);
 extern long acpi_is_video_device(acpi_handle handle);
+extern bool acpi_video_backlight_quirks(void);
 extern void acpi_video_dmi_promote_vendor(void);
 extern void acpi_video_dmi_demote_vendor(void);
 extern int acpi_video_backlight_support(void);
@@ -213,6 +214,11 @@ static inline long acpi_is_video_device(
 	return 0;
 }
 
+static inline bool acpi_video_backlight_quirks(void)
+{
+	return false;
+}
+
 static inline void acpi_video_dmi_promote_vendor(void)
 {
 }

