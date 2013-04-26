Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3DZFXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:23:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:58747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab3DZFXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,554,1363158000"; 
   d="scan'208";a="326083560"
Message-ID: <517A0FA1.3040406@intel.com>
Date: Fri, 26 Apr 2013 13:24:49 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chun-Yi Lee <joeyli.kernel@gmail.com>
CC: mjg@redhat.com, rjw@sisk.pl, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/2] acpi: video: add function to support unregister backlight
References: <1366634355-26482-1-git-send-email-jlee@suse.com> <1366634355-26482-2-git-send-email-jlee@suse.com>
In-Reply-To: <1366634355-26482-2-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 08:39 PM, Chun-Yi Lee wrote:
> From: "Lee, Chun-Yi" <jlee@suse.com>
>
> There have situation we unregister whole acpi/video driver by downstream driver
> just want to remove backlight control interface of acpi/video. It caues we lost
> other functions of acpi/video, e.g. transfer acpi event to input event.
>
> So, this patch add a new function, find_video_unregister_backlight, it provide
> the interface let downstream driver can tell acpi/video to unregister backlight
> interface of all acpi video devices. Then we can keep functions of acpi/video
> but only remove backlight support.
>
> Reference: bko#35622
>          https://bugzilla.kernel.org/show_bug.cgi?id=35622
>
> Tested-by: Andrzej Krentosz <endrjux@gmail.com>
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Aaron Lu <aaron.lu@intel.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>   drivers/acpi/video.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   include/acpi/video.h |  2 ++
>   2 files changed, 48 insertions(+)
>
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 313f959..acd2e7a 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1793,6 +1793,52 @@ static int __init intel_opregion_present(void)
>   	return opregion;
>   }
>
> +static acpi_status
> +find_video_unregister_backlight(acpi_handle handle, u32 lvl, void *context,
> +				void **rv)
> +{
> +	struct acpi_device *acpi_dev;
> +	struct acpi_video_bus *video = NULL;
> +	struct acpi_video_device *dev, *next;
> +
> +	if (acpi_bus_get_device(handle, &acpi_dev))
> +		return AE_OK;
> +
> +	if (!acpi_match_device_ids(acpi_dev, video_device_ids)) {
> +		video = acpi_driver_data(acpi_dev);
> +		acpi_video_bus_stop_devices(video);
> +		mutex_lock(&video->device_list_lock);
> +		list_for_each_entry_safe(dev, next, &video->video_device_list,
> +					entry) {
> +			if (dev->backlight) {
> +				backlight_device_unregister(dev->backlight);
> +				dev->backlight = NULL;
> +				kfree(dev->brightness->levels);
> +				kfree(dev->brightness);
> +			}

The cooling_dev should also be unregistered I think.

Thanks,
Aaron

> +		}
> +		mutex_unlock(&video->device_list_lock);
> +		acpi_video_bus_start_devices(video);
> +	}
> +	return AE_OK;
> +}
> +
> +void acpi_video_backlight_unregister(void)
> +{
> +	if (!register_count) {
> +		/*
> +		 * If the acpi video bus is already unloaded, don't
> +		 * unregister backlight of devices and return directly.
> +		 */
> +		return;
> +	}
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +			    ACPI_UINT32_MAX, find_video_unregister_backlight,
> +			    NULL, NULL, NULL);
> +	return;
> +}
> +EXPORT_SYMBOL(acpi_video_backlight_unregister);
> +
>   int acpi_video_register(void)
>   {
>   	int result = 0;
> diff --git a/include/acpi/video.h b/include/acpi/video.h
> index 61109f2..1e810a1 100644
> --- a/include/acpi/video.h
> +++ b/include/acpi/video.h
> @@ -19,11 +19,13 @@ struct acpi_device;
>   #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
>   extern int acpi_video_register(void);
>   extern void acpi_video_unregister(void);
> +extern void acpi_video_backlight_unregister(void);
>   extern int acpi_video_get_edid(struct acpi_device *device, int type,
>   			       int device_id, void **edid);
>   #else
>   static inline int acpi_video_register(void) { return 0; }
>   static inline void acpi_video_unregister(void) { return; }
> +static inline void acpi_video_backlight_unregister(void) { return; }
>   static inline int acpi_video_get_edid(struct acpi_device *device, int type,
>   				      int device_id, void **edid)
>   {
>

