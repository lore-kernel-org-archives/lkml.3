Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3CRIPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:15:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:17942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3CRIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,863,1355126400"; 
   d="scan'208";a="215879577"
Message-ID: <5146CD67.8070203@intel.com>
Date: Mon, 18 Mar 2013 16:16:39 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 3/3] ACPI video: Fix applying indexed initial brightness
 value.
References: <1363342248-6496-1-git-send-email-dannybaumann@web.de> <1363342248-6496-3-git-send-email-dannybaumann@web.de>
In-Reply-To: <1363342248-6496-3-git-send-email-dannybaumann@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:10 PM, Danny Baumann wrote:
> The value initially read via _BQC also needs to be offset by 2 to
> compensate for the first 2 special items in _BCL. Introduce a helper
> function that does the BQC-value-to-level conversion in order to not
> needlessly duplicate code.
> 
> Signed-off-by: Danny Baumann <dannybaumann@web.de>
> ---
>  drivers/acpi/video.c | 52 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 5ef329a..8faea35 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -450,6 +450,26 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>  	{}
>  };
>  
> +static unsigned long long
> +acpi_video_bqc_value_to_level(struct acpi_video_device *device,
> +			      unsigned long long bqc_value)
> +{
> +	unsigned long long level;
> +
> +	if (device->brightness->flags._BQC_use_index) {
> +		if (device->brightness->flags._BCL_reversed)
> +			bqc_value = device->brightness->count - 3 - bqc_value;
> +
> +		level = device->brightness->levels[bqc_value + 2];

I don't understand this, what does the +2 have to do here?
_BQC returned us an index, and then we should just convert it to level,
why +2?

The only explanation would be, for BIOS tables that return _BQC as
index, they are indexing from the 3rd entry. Is it the case? If so, I
think we need to put a comment here.

> +	} else {
> +		level = bqc_value;
> +	}
> +
> +	level += bqc_offset_aml_bug_workaround;
> +
> +	return level;
> +}
> +
>  static int
>  acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  					unsigned long long *level, int raw)
> @@ -472,14 +492,8 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  				return 0;
>  			}
>  
> -			if (device->brightness->flags._BQC_use_index) {
> -				if (device->brightness->flags._BCL_reversed)
> -					*level = device->brightness->count
> -								 - 3 - (*level);
> -				*level = device->brightness->levels[*level + 2];
> +			*level = acpi_video_bqc_value_to_level(device, *level);
>  
> -			}
> -			*level += bqc_offset_aml_bug_workaround;
>  			for (i = 2; i < device->brightness->count; i++)
>  				if (device->brightness->levels[i] == *level) {
>  					device->brightness->curr = *level;
> @@ -727,24 +741,24 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>  
>  	br->flags._BQC_use_index = (level == max_level ? 0 : 1);
>  
> -	if (!br->flags._BQC_use_index) {
> -		/*
> -		 * Set the backlight to the initial state.
> -		 * On some buggy laptops, _BQC returns an uninitialized value
> -		 * when invoked for the first time, i.e. level_old is invalid.
> -		 * set the backlight to max_level in this case
> -		 */
> -		if (use_bios_initial_backlight) {

-------------------------------------------------------------------
> +	if (use_bios_initial_backlight) {
> +		if (!br->flags._BQC_use_index) {
> +			/*
> +			 * Set the backlight to the initial state.
> +			 * On some buggy laptops, _BQC returns an uninitialized
> +			 * value when invoked for the first time, i.e.
> +			 * level_old is invalid. Set the backlight to max_level
> +			 * in this case.
> +			 */
>  			for (i = 2; i < br->count; i++)
>  				if (level_old == br->levels[i]) {
>  					level = level_old;
>  					break;
>  				}
> +		} else {
> +			level = acpi_video_bqc_value_to_level(device,
> +							      level_old);

What about we convert the value to level first?

	if (use_bios_initial_backlight) {
		level = acpi_video_bqc_value_to_level(device, level_old);
		/*
		 * Set the backlight to the initial state.
		 * On some buggy laptops, _BQC returns an uninitialized
		 * value when invoked for the first time, i.e.
		 * level_old is invalid(no matter it is a level, or an
		 * index.) Set the backlight to max_level in this case.
		 */
		for (i = 2; i < br->count; i++)
			if (level == br->levels[i])
				break;
		if (i == br->count)
			level = max_level;
	}

Thanks,
Aaron

>  		}
> -	} else {
> -		if (br->flags._BCL_reversed)
> -			level_old = (br->count - 1) - level_old;
> -		level = br->levels[level_old];
>  	}
>  
>  set_level:
> 

