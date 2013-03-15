Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3COIrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:47:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:54319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab3COIrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:47:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="279910128"
Message-ID: <5142E04F.1010400@intel.com>
Date: Fri, 15 Mar 2013 16:48:15 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/3] ACPI video: Fix applying indexed initial brightness
 value.
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de> <1363257264-15984-4-git-send-email-dannybaumann@web.de>
In-Reply-To: <1363257264-15984-4-git-send-email-dannybaumann@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 06:34 PM, Danny Baumann wrote:
> The value initially read via _BQC also needs to be offset by 2 to
> compensate for the first 2 special items in _BCL. Introduce a helper
> function to do the conversion in order to not needlessly duplicate code.
> ---
>  drivers/acpi/video.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index d0fade7..562ccc3 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -450,6 +450,16 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>  	{}
>  };
>  
> +static unsigned long long
> +acpi_video_index_to_level(struct acpi_video_device *device,
> +			  unsigned long long index)
> +{
> +	if (device->brightness->flags._BCL_reversed)
> +		index = device->brightness->count - 3 - index;
> +
> +	return device->brightness->levels[index + 2];
> +}

What about making this function also take care of the
bqc_offset_aml_bug_workaround? so that this function serves more like a
conversion from raw value to fixed value, the function name can perhaps
be named as: acpi_video_fix_bqc_value, or whatever you think is more
appropriate.

> +
>  static int
>  acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  					unsigned long long *level, int init)
> @@ -472,13 +482,10 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  				return 0;
>  			}
>  
> -			if (device->brightness->flags._BQC_use_index) {
> -				if (device->brightness->flags._BCL_reversed)
> -					*level = device->brightness->count
> -								 - 3 - (*level);
> -				*level = device->brightness->levels[*level + 2];
> +			if (device->brightness->flags._BQC_use_index)
> +				*level = acpi_video_index_to_level(device,
> +								   *level);
>  
> -			}
>  			*level += bqc_offset_aml_bug_workaround;
>  			for (i = 2; i < device->brightness->count; i++)
>  				if (device->brightness->levels[i] == *level) {
> @@ -742,9 +749,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>  				}
>  		}
>  	} else {
> -		if (br->flags._BCL_reversed)
> -			level_old = (br->count - 1) - level_old;
> -		level = br->levels[level_old];
> +		level = acpi_video_index_to_level(device, level_old);

And here, that new function should be used, which also takes care of the
offset_aml_bug problem(though in theory, the two problems may not happen
on the same BIOS table).

And the acpi_video_device_lcd_get_level_current's param init can
probably be renamed as raw, meaning if raw value is desired or fixed
value, but it's not a big deal.

Thanks,
Aaron

>  	}
>  
>  set_level:
> 

