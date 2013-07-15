Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3GOLcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:32:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43368 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3GOLcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:32:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        daniel.vetter@ffwll.ch, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
Date: Mon, 15 Jul 2013 13:42:15 +0200
Message-ID: <196299995.fotXCOt3dc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E3601F.1020605@intel.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1683364.CdnoW81WLH@vostro.rjw.lan> <51E3601F.1020605@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 15, 2013 10:36:15 AM Aaron Lu wrote:
> On 07/13/2013 08:46 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > According to Matthew Garrett, "Windows 8 leaves backlight control up
> > to individual graphics drivers rather than making ACPI calls itself.
> > There's plenty of evidence to suggest that the Intel driver for
> > Windows [8] doesn't use the ACPI interface, including the fact that
> > it's broken on a bunch of machines when the OS claims to support
> > Windows 8.  The simplest thing to do appears to be to disable the
> > ACPI backlight interface on these systems".
> > 
> > There's a problem with that approach, however, because simply
> > avoiding to register the ACPI backlight interface if the firmware
> > calls _OSI for Windows 8 may not work in the following situations:
> >  (1) The ACPI backlight interface actually works on the given system
> >      and the i915 driver is not loaded (e.g. another graphics driver
> >      is used).
> >  (2) The ACPI backlight interface doesn't work on the given system,
> >      but there is a vendor platform driver that will register its
> >      own, equally broken, backlight interface if not prevented from
> >      doing so by the ACPI subsystem.
> > Therefore we need to allow the ACPI backlight interface to be
> > registered until the i915 driver is loaded which then will unregister
> > it if the firmware has called _OSI for Windows 8 (or will register
> > the ACPI video driver without backlight support if not already
> > present).
> > 
> > For this reason, introduce an alternative function for registering
> > ACPI video, acpi_video_register_with_quirks(), that will check
> > whether or not the ACPI video driver has already been registered
> > and whether or not the backlight Windows 8 quirk has to be applied.
> > If the quirk has to be applied, it will block the ACPI backlight
> > support and either unregister the backlight interface if the ACPI
> > video driver has already been registered, or register the ACPI
> > video driver without the backlight interface otherwise.  Make
> > the i915 driver use acpi_video_register_with_quirks() instead of
> > acpi_video_register() in i915_driver_load().
> > 
> > This change is based on earlier patches from Matthew Garrett,
> > Chun-Yi Lee and Seth Forshee and Aaron Lu's comments.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Reviewed-by: Aaron Lu <aaron.lu@intel.com>
> 
> BTW, I also tested on a Toshiba laptop Z830 where its AML code
> claims support of win8, the result is as expected: ACPI video
> interface is removed, i915 Xorg driver picks intel_backlight.
> 
> Thanks for the fix.

Cool, thanks for testing this!

Can you please also ask bug reporters in the BZ entires related to this to test
it too?

Rafael


> > ---
> >  drivers/acpi/internal.h         |   11 ++++++
> >  drivers/acpi/video.c            |   65 ++++++++++++++++++++++++++++++++++++----
> >  drivers/acpi/video_detect.c     |   21 ++++++++++++
> >  drivers/gpu/drm/i915/i915_dma.c |    2 -
> >  include/acpi/video.h            |   11 ++++++
> >  include/linux/acpi.h            |    1 
> >  6 files changed, 103 insertions(+), 8 deletions(-)
> > 
> > Index: linux-pm/drivers/acpi/video.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/video.c
> > +++ linux-pm/drivers/acpi/video.c
> > @@ -44,6 +44,8 @@
> >  #include <linux/suspend.h>
> >  #include <acpi/video.h>
> >  
> > +#include "internal.h"
> > +
> >  #define PREFIX "ACPI: "
> >  
> >  #define ACPI_VIDEO_BUS_NAME		"Video Bus"
> > @@ -898,7 +900,7 @@ static void acpi_video_device_find_cap(s
> >  		device->cap._DDC = 1;
> >  	}
> >  
> > -	if (acpi_video_backlight_support()) {
> > +	if (acpi_video_verify_backlight_support()) {
> >  		struct backlight_properties props;
> >  		struct pci_dev *pdev;
> >  		acpi_handle acpi_parent;
> > @@ -1854,6 +1856,46 @@ static int acpi_video_bus_remove(struct
> >  	return 0;
> >  }
> >  
> > +static acpi_status video_unregister_backlight(acpi_handle handle, u32 lvl,
> > +					      void *context, void **rv)
> > +{
> > +	struct acpi_device *acpi_dev;
> > +	struct acpi_video_bus *video;
> > +	struct acpi_video_device *dev, *next;
> > +
> > +	if (acpi_bus_get_device(handle, &acpi_dev))
> > +		return AE_OK;
> > +
> > +	if (acpi_match_device_ids(acpi_dev, video_device_ids))
> > +		return AE_OK;
> > +
> > +	video = acpi_driver_data(acpi_dev);
> > +	if (!video)
> > +		return AE_OK;
> > +
> > +	acpi_video_bus_stop_devices(video);
> > +	mutex_lock(&video->device_list_lock);
> > +	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
> > +		if (dev->backlight) {
> > +			backlight_device_unregister(dev->backlight);
> > +			dev->backlight = NULL;
> > +			kfree(dev->brightness->levels);
> > +			kfree(dev->brightness);
> > +		}
> > +		if (dev->cooling_dev) {
> > +			sysfs_remove_link(&dev->dev->dev.kobj,
> > +					  "thermal_cooling");
> > +			sysfs_remove_link(&dev->cooling_dev->device.kobj,
> > +					  "device");
> > +			thermal_cooling_device_unregister(dev->cooling_dev);
> > +			dev->cooling_dev = NULL;
> > +		}
> > +	}
> > +	mutex_unlock(&video->device_list_lock);
> > +	acpi_video_bus_start_devices(video);
> > +	return AE_OK;
> > +}
> > +
> >  static int __init is_i740(struct pci_dev *dev)
> >  {
> >  	if (dev->device == 0x00D1)
> > @@ -1885,14 +1927,25 @@ static int __init intel_opregion_present
> >  	return opregion;
> >  }
> >  
> > -int acpi_video_register(void)
> > +int __acpi_video_register(bool backlight_quirks)
> >  {
> > -	int result = 0;
> > +	bool no_backlight;
> > +	int result;
> > +
> > +	no_backlight = backlight_quirks ? acpi_video_backlight_quirks() : false;
> > +
> >  	if (register_count) {
> >  		/*
> > -		 * if the function of acpi_video_register is already called,
> > -		 * don't register the acpi_vide_bus again and return no error.
> > +		 * If acpi_video_register() has been called already, don't try
> > +		 * to register acpi_video_bus, but unregister backlight devices
> > +		 * if no backlight support is requested.
> >  		 */
> > +		if (no_backlight)
> > +			acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> > +					    ACPI_UINT32_MAX,
> > +					    video_unregister_backlight,
> > +					    NULL, NULL, NULL);
> > +
> >  		return 0;
> >  	}
> >  
> > @@ -1908,7 +1961,7 @@ int acpi_video_register(void)
> >  
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL(acpi_video_register);
> > +EXPORT_SYMBOL(__acpi_video_register);
> >  
> >  void acpi_video_unregister(void)
> >  {
> > Index: linux-pm/drivers/gpu/drm/i915/i915_dma.c
> > ===================================================================
> > --- linux-pm.orig/drivers/gpu/drm/i915/i915_dma.c
> > +++ linux-pm/drivers/gpu/drm/i915/i915_dma.c
> > @@ -1660,7 +1660,7 @@ int i915_driver_load(struct drm_device *
> >  	if (INTEL_INFO(dev)->num_pipes) {
> >  		/* Must be done after probing outputs */
> >  		intel_opregion_init(dev);
> > -		acpi_video_register();
> > +		acpi_video_register_with_quirks();
> >  	}
> >  
> >  	if (IS_GEN5(dev))
> > Index: linux-pm/include/acpi/video.h
> > ===================================================================
> > --- linux-pm.orig/include/acpi/video.h
> > +++ linux-pm/include/acpi/video.h
> > @@ -17,12 +17,21 @@ struct acpi_device;
> >  #define ACPI_VIDEO_DISPLAY_LEGACY_TV      0x0200
> >  
> >  #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> > -extern int acpi_video_register(void);
> > +extern int __acpi_video_register(bool backlight_quirks);
> > +static inline int acpi_video_register(void)
> > +{
> > +	return __acpi_video_register(false);
> > +}
> > +static inline int acpi_video_register_with_quirks(void)
> > +{
> > +	return __acpi_video_register(true);
> > +}
> >  extern void acpi_video_unregister(void);
> >  extern int acpi_video_get_edid(struct acpi_device *device, int type,
> >  			       int device_id, void **edid);
> >  #else
> >  static inline int acpi_video_register(void) { return 0; }
> > +static inline int acpi_video_register_with_quirks(void) { return 0; }
> >  static inline void acpi_video_unregister(void) { return; }
> >  static inline int acpi_video_get_edid(struct acpi_device *device, int type,
> >  				      int device_id, void **edid)
> > Index: linux-pm/drivers/acpi/video_detect.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/video_detect.c
> > +++ linux-pm/drivers/acpi/video_detect.c
> > @@ -38,6 +38,8 @@
> >  #include <linux/dmi.h>
> >  #include <linux/pci.h>
> >  
> > +#include "internal.h"
> > +
> >  #define PREFIX "ACPI: "
> >  
> >  ACPI_MODULE_NAME("video");
> > @@ -234,6 +236,17 @@ static void acpi_video_caps_check(void)
> >  		acpi_video_get_capabilities(NULL);
> >  }
> >  
> > +bool acpi_video_backlight_quirks(void)
> > +{
> > +	if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8) {
> > +		acpi_video_caps_check();
> > +		acpi_video_support |= ACPI_VIDEO_SKIP_BACKLIGHT;
> > +		return true;
> > +	}
> > +	return false;
> > +}
> > +EXPORT_SYMBOL(acpi_video_backlight_quirks);
> > +
> >  /* Promote the vendor interface instead of the generic video module.
> >   * This function allow DMI blacklists to be implemented by externals
> >   * platform drivers instead of putting a big blacklist in video_detect.c
> > @@ -278,6 +291,14 @@ int acpi_video_backlight_support(void)
> >  }
> >  EXPORT_SYMBOL(acpi_video_backlight_support);
> >  
> > +/* For the ACPI video driver's use only. */
> > +bool acpi_video_verify_backlight_support(void)
> > +{
> > +	return (acpi_video_support & ACPI_VIDEO_SKIP_BACKLIGHT) ?
> > +		false : acpi_video_backlight_support();
> > +}
> > +EXPORT_SYMBOL(acpi_video_verify_backlight_support);
> > +
> >  /*
> >   * Use acpi_backlight=vendor/video to force that backlight switching
> >   * is processed by vendor specific acpi drivers or video.ko driver.
> > Index: linux-pm/include/linux/acpi.h
> > ===================================================================
> > --- linux-pm.orig/include/linux/acpi.h
> > +++ linux-pm/include/linux/acpi.h
> > @@ -191,6 +191,7 @@ extern bool wmi_has_guid(const char *gui
> >  #define ACPI_VIDEO_BACKLIGHT_DMI_VIDEO			0x0200
> >  #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VENDOR		0x0400
> >  #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VIDEO		0x0800
> > +#define ACPI_VIDEO_SKIP_BACKLIGHT			0x1000
> >  
> >  #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
> >  
> > Index: linux-pm/drivers/acpi/internal.h
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/internal.h
> > +++ linux-pm/drivers/acpi/internal.h
> > @@ -164,4 +164,15 @@ struct platform_device;
> >  int acpi_create_platform_device(struct acpi_device *adev,
> >  				const struct acpi_device_id *id);
> >  
> > +/*--------------------------------------------------------------------------
> > +					Video
> > +  -------------------------------------------------------------------------- */
> > +#ifdef CONFIG_ACPI_VIDEO
> > +bool acpi_video_backlight_quirks(void);
> > +bool acpi_video_verify_backlight_support(void);
> > +#else
> > +static inline bool acpi_video_backlight_quirks(void) { return false; }
> > +static inline bool acpi_video_verify_backlight_support(void) { return false; }
> > +#endif
> > +
> >  #endif /* _ACPI_INTERNAL_H_ */
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
