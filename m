Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3GHH7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:59:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53313 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3GHH7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:59:43 -0400
Message-ID: <51DA7190.6080208@gmail.com>
Date: Mon, 08 Jul 2013 16:00:16 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch,
        linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware
 expects Windows 8
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <51D7AF14.9050508@gmail.com> <3467567.zOLDhye8QD@vostro.rjw.lan> <12270512.1rshgKaUug@vostro.rjw.lan>
In-Reply-To: <12270512.1rshgKaUug@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 09:19 PM, Rafael J. Wysocki wrote:
> OK, the patch is appended.  Please have a look and tell me what you think.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
> 
> According to Matthew Garrett, "Windows 8 leaves backlight control up
> to individual graphics drivers rather than making ACPI calls itself.
> There's plenty of evidence to suggest that the Intel driver for
> Windows [8] doesn't use the ACPI interface, including the fact that
> it's broken on a bunch of machines when the OS claims to support
> Windows 8.  The simplest thing to do appears to be to disable the
> ACPI backlight interface on these systems".
> 
> There's a problem with that approach, however, because simply
> avoiding to register the ACPI backlight interface if the firmware
> calls _OSI for Windows 8 may not work in the following situations:
>  (1) The ACPI backlight interface actually works on the given system
>      and the i915 driver is not loaded (e.g. another graphics driver
>      is used).
>  (2) The ACPI backlight interface doesn't work on the given system,
>      but there is a vendor platform driver that will register its
>      own, equally broken, backlight interface if the ACPI one is not
>      registered in advance.

The condition thinkpad_acpi checks to decide if it wants to create
backlight control interface is acpi_video_backlight_support function,
not that if ACPI video driver has registered previously. I'm sorry if my
previous words gave you such a conclusion.

> Therefore we need to keep the ACPI backlight interface registered
> until the i915 driver is loaded which then will unregister it if
> the firmware has called _OSI for Windows 8.
> 
> For this reason, introduce an alternative function for registering
> ACPI video, acpi_video_register_with_quirks(), that will check
> whether or not the ACPI video driver has already been registered
> and whether or not the backlight Windows 8 quirk has to be applied.
> If the quirk has to be applied, it will block the ACPI backlight
> support and either unregister the backlight interface if the ACPI
> video driver has already been registered, or register the ACPI
> video driver without the backlight interface otherwise.  Make
> the i915 driver use acpi_video_register_with_quirks() instead of
> acpi_video_register() in i915_driver_load().
> 
> This change is based on earlier patches from Matthew Garrett,
> Chun-Yi Lee and Seth Forshee.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/video.c            |   61 ++++++++++++++++++++++++++++++++++++----
>  drivers/acpi/video_detect.c     |   11 +++++++
>  drivers/gpu/drm/i915/i915_dma.c |    2 -
>  include/acpi/video.h            |   11 ++++++-
>  include/linux/acpi.h            |    6 +++
>  5 files changed, 84 insertions(+), 7 deletions(-)
> 
> Index: linux-pm/drivers/acpi/video.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/video.c
> +++ linux-pm/drivers/acpi/video.c
> @@ -1854,6 +1854,46 @@ static int acpi_video_bus_remove(struct
>  	return 0;
>  }
>  
> +static acpi_status video_unregister_backlight(acpi_handle handle, u32 lvl,
> +					      void *context, void **rv)
> +{
> +	struct acpi_device *acpi_dev;
> +	struct acpi_video_bus *video;
> +	struct acpi_video_device *dev, *next;
> +
> +	if (acpi_bus_get_device(handle, &acpi_dev))
> +		return AE_OK;
> +
> +	if (acpi_match_device_ids(acpi_dev, video_device_ids))
> +		return AE_OK;
> +
> +	video = acpi_driver_data(acpi_dev);
> +	if (!video)
> +		return AE_OK;
> +
> +	acpi_video_bus_stop_devices(video);
> +	mutex_lock(&video->device_list_lock);
> +	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
> +		if (dev->backlight) {
> +			backlight_device_unregister(dev->backlight);
> +			dev->backlight = NULL;
> +			kfree(dev->brightness->levels);
> +			kfree(dev->brightness);
> +		}
> +		if (dev->cooling_dev) {
> +			sysfs_remove_link(&dev->dev->dev.kobj,
> +					  "thermal_cooling");
> +			sysfs_remove_link(&dev->cooling_dev->device.kobj,
> +					  "device");
> +			thermal_cooling_device_unregister(dev->cooling_dev);
> +			dev->cooling_dev = NULL;
> +		}
> +	}
> +	mutex_unlock(&video->device_list_lock);
> +	acpi_video_bus_start_devices(video);
> +	return AE_OK;
> +}
> +
>  static int __init is_i740(struct pci_dev *dev)
>  {
>  	if (dev->device == 0x00D1)
> @@ -1885,14 +1925,25 @@ static int __init intel_opregion_present
>  	return opregion;
>  }
>  
> -int acpi_video_register(void)
> +int __acpi_video_register(bool backlight_quirks)
>  {
> -	int result = 0;
> +	bool no_backlight;
> +	int result;
> +
> +	no_backlight = backlight_quirks ? acpi_video_backlight_quirks() : false;
> +
>  	if (register_count) {
>  		/*
> -		 * if the function of acpi_video_register is already called,
> -		 * don't register the acpi_vide_bus again and return no error.
> +		 * If acpi_video_register() has been called already, don't try
> +		 * to register acpi_video_bus, but unregister backlight devices
> +		 * if no backlight support is requested.
>  		 */
> +		if (no_backlight)
> +			acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +					    ACPI_UINT32_MAX,
> +					    video_unregister_backlight,
> +					    NULL, NULL, NULL);
> +
>  		return 0;
>  	}
>  
> @@ -1908,7 +1959,7 @@ int acpi_video_register(void)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(acpi_video_register);
> +EXPORT_SYMBOL(__acpi_video_register);
>  
>  void acpi_video_unregister(void)
>  {
> Index: linux-pm/drivers/gpu/drm/i915/i915_dma.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/i915/i915_dma.c
> +++ linux-pm/drivers/gpu/drm/i915/i915_dma.c
> @@ -1660,7 +1660,7 @@ int i915_driver_load(struct drm_device *
>  	if (INTEL_INFO(dev)->num_pipes) {
>  		/* Must be done after probing outputs */
>  		intel_opregion_init(dev);
> -		acpi_video_register();
> +		acpi_video_register_with_quirks();
>  	}
>  
>  	if (IS_GEN5(dev))
> Index: linux-pm/include/acpi/video.h
> ===================================================================
> --- linux-pm.orig/include/acpi/video.h
> +++ linux-pm/include/acpi/video.h
> @@ -17,12 +17,21 @@ struct acpi_device;
>  #define ACPI_VIDEO_DISPLAY_LEGACY_TV      0x0200
>  
>  #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> -extern int acpi_video_register(void);
> +extern int __acpi_video_register(bool backlight_quirks);
> +static inline int acpi_video_register(void)
> +{
> +	return __acpi_video_register(false);
> +}
> +static inline int acpi_video_register_with_quirks(void)
> +{
> +	return __acpi_video_register(true);
> +}
>  extern void acpi_video_unregister(void);
>  extern int acpi_video_get_edid(struct acpi_device *device, int type,
>  			       int device_id, void **edid);
>  #else
>  static inline int acpi_video_register(void) { return 0; }
> +static inline int acpi_video_register_with_quirks(void) { return 0; }
>  static inline void acpi_video_unregister(void) { return; }
>  static inline int acpi_video_get_edid(struct acpi_device *device, int type,
>  				      int device_id, void **edid)
> Index: linux-pm/drivers/acpi/video_detect.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/video_detect.c
> +++ linux-pm/drivers/acpi/video_detect.c
> @@ -234,6 +234,17 @@ static void acpi_video_caps_check(void)
>  		acpi_video_get_capabilities(NULL);
>  }
>  
> +bool acpi_video_backlight_quirks(void)
> +{
> +	if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8) {
> +		acpi_video_caps_check();
> +		acpi_video_support |= ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;

If the ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR flag is set,
acpi_video_backlight_support will return 0, thinkpad_acpi will create
backlight interface for the system, which is not what we want.

Thanks,
Aaron

> +		return true;
> +	}
> +	return false;
> +}
> +EXPORT_SYMBOL(acpi_video_backlight_quirks);
> +
>  /* Promote the vendor interface instead of the generic video module.
>   * This function allow DMI blacklists to be implemented by externals
>   * platform drivers instead of putting a big blacklist in video_detect.c
> Index: linux-pm/include/linux/acpi.h
> ===================================================================
> --- linux-pm.orig/include/linux/acpi.h
> +++ linux-pm/include/linux/acpi.h
> @@ -196,6 +196,7 @@ extern bool wmi_has_guid(const char *gui
>  
>  extern long acpi_video_get_capabilities(acpi_handle graphics_dev_handle);
>  extern long acpi_is_video_device(acpi_handle handle);
> +extern bool acpi_video_backlight_quirks(void);
>  extern void acpi_video_dmi_promote_vendor(void);
>  extern void acpi_video_dmi_demote_vendor(void);
>  extern int acpi_video_backlight_support(void);
> @@ -213,6 +214,11 @@ static inline long acpi_is_video_device(
>  	return 0;
>  }
>  
> +static inline bool acpi_video_backlight_quirks(void)
> +{
> +	return false;
> +}
> +
>  static inline void acpi_video_dmi_promote_vendor(void)
>  {
>  }
> 

