Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3IYRl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:41:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59175 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3IYRlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:41:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 3/4] ACPI / video: Do not register backlight if win8 and native interface exists
Date: Wed, 25 Sep 2013 19:53:13 +0200
Message-ID: <2597446.Ay4U1OH2zV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380016052-15315-4-git-send-email-aaron.lu@intel.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com> <1380016052-15315-4-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 24, 2013 05:47:31 PM Aaron Lu wrote:
> According to Matthew Garrett, "Windows 8 leaves backlight control up
> to individual graphics drivers rather than making ACPI calls itself.
> There's plenty of evidence to suggest that the Intel driver for
> Windows [8] doesn't use the ACPI interface, including the fact that
> it's broken on a bunch of machines when the OS claims to support
> Windows 8.  The simplest thing to do appears to be to disable the
> ACPI backlight interface on these systems".
> 
> So for Win8 systems, if there is native backlight control interface
> registered by GPU driver, ACPI video will not register its own. For
> users who prefer to keep ACPI video's backlight interface, the existing
> kernel cmdline option acpi_backlight=video can be used.

I think the idea is to use the aggressive default for now and we can switch the
default back to the current behavior before the merge window in case there are
too many problems with it?

Rafael


> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> Tested-by: Yves-Alexis Perez <corsac@debian.org>
> ---
>  drivers/acpi/internal.h     |  5 ++---
>  drivers/acpi/video.c        | 10 +++++-----
>  drivers/acpi/video_detect.c | 14 ++++++++++++--
>  3 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 20f4233..453ae8d 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -169,9 +169,8 @@ int acpi_create_platform_device(struct acpi_device *adev,
>  					Video
>    -------------------------------------------------------------------------- */
>  #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
> -bool acpi_video_backlight_quirks(void);
> -#else
> -static inline bool acpi_video_backlight_quirks(void) { return false; }
> +bool acpi_osi_is_win8(void);
> +bool acpi_video_verify_backlight_support(void);
>  #endif
>  
>  #endif /* _ACPI_INTERNAL_H_ */
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 3bd1eaa..343db59 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1256,8 +1256,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
>  	unsigned long long level_current, level_next;
>  	int result = -EINVAL;
>  
> -	/* no warning message if acpi_backlight=vendor is used */
> -	if (!acpi_video_backlight_support())
> +	/* no warning message if acpi_backlight=vendor or a quirk is used */
> +	if (!acpi_video_verify_backlight_support())
>  		return 0;
>  
>  	if (!device->brightness)
> @@ -1386,13 +1386,13 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
>  static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
>  {
>  	return acpi_video_bus_DOS(video, 0,
> -				  acpi_video_backlight_quirks() ? 1 : 0);
> +				  acpi_osi_is_win8() ? 1 : 0);
>  }
>  
>  static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)
>  {
>  	return acpi_video_bus_DOS(video, 0,
> -				  acpi_video_backlight_quirks() ? 0 : 1);
> +				  acpi_osi_is_win8() ? 0 : 1);
>  }
>  
>  static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
> @@ -1558,7 +1558,7 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
>  
>  static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
>  {
> -	if (acpi_video_backlight_support()) {
> +	if (acpi_video_verify_backlight_support()) {
>  		struct backlight_properties props;
>  		struct pci_dev *pdev;
>  		acpi_handle acpi_parent;
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 940edbf..23d7d26 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -37,6 +37,7 @@
>  #include <linux/acpi.h>
>  #include <linux/dmi.h>
>  #include <linux/pci.h>
> +#include <linux/backlight.h>
>  
>  #include "internal.h"
>  
> @@ -233,11 +234,11 @@ static void acpi_video_caps_check(void)
>  		acpi_video_get_capabilities(NULL);
>  }
>  
> -bool acpi_video_backlight_quirks(void)
> +bool acpi_osi_is_win8(void)
>  {
>  	return acpi_gbl_osi_data >= ACPI_OSI_WIN_8;
>  }
> -EXPORT_SYMBOL(acpi_video_backlight_quirks);
> +EXPORT_SYMBOL(acpi_osi_is_win8);
>  
>  /* Promote the vendor interface instead of the generic video module.
>   * This function allow DMI blacklists to be implemented by externals
> @@ -283,6 +284,15 @@ int acpi_video_backlight_support(void)
>  }
>  EXPORT_SYMBOL(acpi_video_backlight_support);
>  
> +bool acpi_video_verify_backlight_support(void)
> +{
> +	if (!(acpi_video_support & ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO) &&
> +	    acpi_osi_is_win8() && backlight_device_registered(BACKLIGHT_RAW))
> +		return false;
> +	return acpi_video_backlight_support();
> +}
> +EXPORT_SYMBOL(acpi_video_verify_backlight_support);
> +
>  /*
>   * Use acpi_backlight=vendor/video to force that backlight switching
>   * is processed by vendor specific acpi drivers or video.ko driver.
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
