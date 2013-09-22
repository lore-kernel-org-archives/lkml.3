Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3IVCqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 22:46:35 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39337 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3IVCqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 22:46:33 -0400
Message-ID: <523E5A28.70708@intel.com>
Date: Sun, 22 Sep 2013 10:47:04 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: Re: [PATCH v2 3/3] ACPI / video: Do not register backlight if win8
 and native interface exists
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com> <1379409796-29350-4-git-send-email-aaron.lu@intel.com> <8761tv7uu3.fsf@intel.com>
In-Reply-To: <8761tv7uu3.fsf@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 04:36 PM, Jani Nikula wrote:
> On Tue, 17 Sep 2013, Aaron Lu <aaron.lu@intel.com> wrote:
>> According to Matthew Garrett, "Windows 8 leaves backlight control up
>> to individual graphics drivers rather than making ACPI calls itself.
>> There's plenty of evidence to suggest that the Intel driver for
>> Windows 8 doesn't use the ACPI interface, including the fact that
>> it's broken on a bunch of machines when the OS claims to support
>> Windows 8.  The simplest thing to do appears to be to disable the
>> ACPI backlight interface on these systems".
>>
>> So for Win8 systems, if there is native backlight control interface
>> registered by GPU driver, ACPI video will not register its own. For
>> users who prefer to keep ACPI video's backlight interface, the existing
>> kernel cmdline option acpi_backlight=video can be used.
>>
>> This patch is an evolution from previous work done by Matthew Garrett,
>> Chun-Yi Lee, Seth Forshee and Rafael J. Wysocki.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>>  drivers/acpi/internal.h     |  5 ++---
>>  drivers/acpi/video.c        | 27 +++++----------------------
>>  drivers/acpi/video_detect.c | 14 ++++++++++++--
>>  3 files changed, 19 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
>> index 20f4233..453ae8d 100644
>> --- a/drivers/acpi/internal.h
>> +++ b/drivers/acpi/internal.h
>> @@ -169,9 +169,8 @@ int acpi_create_platform_device(struct acpi_device *adev,
>>  					Video
>>    -------------------------------------------------------------------------- */
>>  #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
>> -bool acpi_video_backlight_quirks(void);
>> -#else
>> -static inline bool acpi_video_backlight_quirks(void) { return false; }
>> +bool acpi_osi_is_win8(void);
>> +bool acpi_video_verify_backlight_support(void);
>>  #endif
>>  
>>  #endif /* _ACPI_INTERNAL_H_ */
>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>> index 5ad5a71..343db59 100644
>> --- a/drivers/acpi/video.c
>> +++ b/drivers/acpi/video.c
>> @@ -1256,8 +1256,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
>>  	unsigned long long level_current, level_next;
>>  	int result = -EINVAL;
>>  
>> -	/* no warning message if acpi_backlight=vendor is used */
>> -	if (!acpi_video_backlight_support())
>> +	/* no warning message if acpi_backlight=vendor or a quirk is used */
>> +	if (!acpi_video_verify_backlight_support())
>>  		return 0;
>>  
>>  	if (!device->brightness)
>> @@ -1386,13 +1386,13 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
>>  static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
>>  {
>>  	return acpi_video_bus_DOS(video, 0,
>> -				  acpi_video_backlight_quirks() ? 1 : 0);
>> +				  acpi_osi_is_win8() ? 1 : 0);
>>  }
>>  
>>  static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)
>>  {
>>  	return acpi_video_bus_DOS(video, 0,
>> -				  acpi_video_backlight_quirks() ? 0 : 1);
>> +				  acpi_osi_is_win8() ? 0 : 1);
>>  }
>>  
>>  static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
>> @@ -1558,7 +1558,7 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
>>  
>>  static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
>>  {
>> -	if (acpi_video_backlight_support()) {
>> +	if (acpi_video_verify_backlight_support()) {
>>  		struct backlight_properties props;
>>  		struct pci_dev *pdev;
>>  		acpi_handle acpi_parent;
>> @@ -1677,23 +1677,6 @@ static int acpi_video_bus_unregister_backlight(struct acpi_video_bus *video)
>>  	return error;
>>  }
>>  
>> -int acpi_video_unregister_backlight(void)
>> -{
>> -	struct acpi_video_bus *video;
>> -	int error = 0;
>> -
>> -	mutex_lock(&video_list_lock);
>> -	list_for_each_entry(video, &video_bus_head, entry) {
>> -		error = acpi_video_bus_unregister_backlight(video);
>> -		if (error)
>> -			break;
>> -	}
>> -	mutex_unlock(&video_list_lock);
>> -
>> -	return error;
>> -}
>> -EXPORT_SYMBOL(acpi_video_unregister_backlight);
> 
> You add this in patch 2/3 only to remove it again in 3/3?

This is a mistake while I'm preparing the patches, I'll fix it in next
revision, thanks for pointing this out.

> 
>> -
>>  static void acpi_video_dev_add_notify_handler(struct acpi_video_device *device)
>>  {
>>  	acpi_status status;
>> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
>> index 940edbf..23d7d26 100644
>> --- a/drivers/acpi/video_detect.c
>> +++ b/drivers/acpi/video_detect.c
>> @@ -37,6 +37,7 @@
>>  #include <linux/acpi.h>
>>  #include <linux/dmi.h>
>>  #include <linux/pci.h>
>> +#include <linux/backlight.h>
>>  
>>  #include "internal.h"
>>  
>> @@ -233,11 +234,11 @@ static void acpi_video_caps_check(void)
>>  		acpi_video_get_capabilities(NULL);
>>  }
>>  
>> -bool acpi_video_backlight_quirks(void)
>> +bool acpi_osi_is_win8(void)
>>  {
>>  	return acpi_gbl_osi_data >= ACPI_OSI_WIN_8;
>>  }
>> -EXPORT_SYMBOL(acpi_video_backlight_quirks);
>> +EXPORT_SYMBOL(acpi_osi_is_win8);
>>  
>>  /* Promote the vendor interface instead of the generic video module.
>>   * This function allow DMI blacklists to be implemented by externals
>> @@ -283,6 +284,15 @@ int acpi_video_backlight_support(void)
>>  }
>>  EXPORT_SYMBOL(acpi_video_backlight_support);
>>  
>> +bool acpi_video_verify_backlight_support(void)
>> +{
>> +	if (!(acpi_video_support & ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO) &&
>> +	    acpi_osi_is_win8() && backlight_device_registered(BACKLIGHT_RAW))
>> +		return false;
>> +	return acpi_video_backlight_support();
>> +}
> 
> IIUC this expects the raw backlight device to have been registered prior
> to calling acpi_video_register(). This only works for i915 which calls
> acpi_video_register() itself.

Yes. Since all problematic laptops reported till now are intel graphics
card based, I didn't cover other cases.

Thanks,
Aaron

> 
> 
> BR,
> Jani.
> 
> 
> 
>> +EXPORT_SYMBOL(acpi_video_verify_backlight_support);
>> +
>>  /*
>>   * Use acpi_backlight=vendor/video to force that backlight switching
>>   * is processed by vendor specific acpi drivers or video.ko driver.
>> -- 
>> 1.8.4.12.g2ea3df6
>>
> 

