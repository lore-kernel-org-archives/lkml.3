Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3COIhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:37:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:2798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3COIhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="302645866"
Message-ID: <5142DDF6.1010102@intel.com>
Date: Fri, 15 Mar 2013 16:38:14 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/3] ACPI video: Fix brightness control initialization
 for some laptops.
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de> <1363257264-15984-2-git-send-email-dannybaumann@web.de>
In-Reply-To: <1363257264-15984-2-git-send-email-dannybaumann@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 06:34 PM, Danny Baumann wrote:
> In particular, this fixes brightness control initialization for all
> devices that return index values from _BQC and don't happen to have the
> initial index set by the BIOS in their _BCL table. One example for that
> is the Dell Inspiron 15R SE (model number 7520).
> 
> What happened for those devices is that acpi_init_brightness queried the
> initial brightness by calling acpi_video_device_lcd_get_level_current.
> This called _BQC, which returned e.g. 13. As _BQC_use_index isn't
> determined at this point (and thus has its initial value of 0), the
> index isn't converted into the actual level. As '13' isn't present in
> the _BCL list, *level is later overwritten with brightness->curr, which
> was initialized to max_level (100) before. Later in
> acpi_init_brightness, level_old (with the value 100) is used as an index
> into the _BCL table, which causes a value outside of the actual table to
> be used as input into acpi_video_device_lcd_set_level(). Depending on
> the (undefined) value of that location, this call will fail, causing the
> brightness control for the device in question not to be enabled.
> 
> Fix that by returning the raw value returned by the _BQC call in the
> initialization case.

You missed Signed-off-by tag here.
Other than that, Reviewed-by: Aaron Lu <aaron.lu@intel.com>.

Thanks,
Aaron

> ---
>  drivers/acpi/video.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 313f959..ef85574 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -463,6 +463,15 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  		status = acpi_evaluate_integer(device->dev->handle, buf,
>  						NULL, level);
>  		if (ACPI_SUCCESS(status)) {
> +			if (init) {
> +				/*
> +				 * At init time we don't yet know whether the
> +				 * value is indexed or not. Don't mess with it
> +				 * until we have determined how to handle it.
> +				 */
> +				return 0;
> +			}
> +
>  			if (device->brightness->flags._BQC_use_index) {
>  				if (device->brightness->flags._BCL_reversed)
>  					*level = device->brightness->count
> @@ -476,16 +485,14 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  					device->brightness->curr = *level;
>  					return 0;
>  			}
> -			if (!init) {
> -				/*
> -				 * BQC returned an invalid level.
> -				 * Stop using it.
> -				 */
> -				ACPI_WARNING((AE_INFO,
> -					      "%s returned an invalid level",
> -					      buf));
> -				device->cap._BQC = device->cap._BCQ = 0;
> -			}
> +			/*
> +			 * BQC returned an invalid level.
> +			 * Stop using it.
> +			 */
> +			ACPI_WARNING((AE_INFO,
> +				      "%s returned an invalid level",
> +				      buf));
> +			device->cap._BQC = device->cap._BCQ = 0;
>  		} else {
>  			/* Fixme:
>  			 * should we return an error or ignore this failure?
> @@ -714,7 +721,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>  	if (result)
>  		goto out_free_levels;
>  
> -	result = acpi_video_device_lcd_get_level_current(device, &level, 0);
> +	result = acpi_video_device_lcd_get_level_current(device, &level, 1);
>  	if (result)
>  		goto out_free_levels;
>  
> 

