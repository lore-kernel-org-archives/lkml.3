Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3DWEMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:12:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40173 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3DWEMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:12:49 -0400
Date: Mon, 22 Apr 2013 21:12:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chun-Yi Lee <joeyli.kernel@gmail.com>
Cc: mjg@redhat.com, rjw@sisk.pl, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Corentin Chary <corentincj@iksaif.net>, Aaron Lu <aaron.lu@intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/2] acpi: video: add function to support unregister
 backlight
Message-ID: <20130423041245.GB2435@core.coreip.homeip.net>
References: <1366634355-26482-1-git-send-email-jlee@suse.com>
 <1366634355-26482-2-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366634355-26482-2-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 08:39:15PM +0800, Chun-Yi Lee wrote:
> From: "Lee, Chun-Yi" <jlee@suse.com>
> +static acpi_status
> +find_video_unregister_backlight(acpi_handle handle, u32 lvl, void *context,
> +				void **rv)
> +{
> +	struct acpi_device *acpi_dev;
> +	struct acpi_video_bus *video = NULL;

Gratuitous initialization of local variables prevents compiler from
warning when you using variable uninitialized.

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

Locking? It looks like the rest of the driver ignores locking too...

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
>  int acpi_video_register(void)
>  {
>  	int result = 0;
> diff --git a/include/acpi/video.h b/include/acpi/video.h
> index 61109f2..1e810a1 100644
> --- a/include/acpi/video.h
> +++ b/include/acpi/video.h
> @@ -19,11 +19,13 @@ struct acpi_device;
>  #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
>  extern int acpi_video_register(void);
>  extern void acpi_video_unregister(void);
> +extern void acpi_video_backlight_unregister(void);
>  extern int acpi_video_get_edid(struct acpi_device *device, int type,
>  			       int device_id, void **edid);
>  #else
>  static inline int acpi_video_register(void) { return 0; }
>  static inline void acpi_video_unregister(void) { return; }
> +static inline void acpi_video_backlight_unregister(void) { return; }
>  static inline int acpi_video_get_edid(struct acpi_device *device, int type,
>  				      int device_id, void **edid)
>  {
> -- 
> 1.8.1.4
> 
> 

Thanks.

-- 
Dmitry
