Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DZL7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:59:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44979 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3DZL7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:59:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, eduardo.valentin@ti.com
Subject: Re: [PATCH] ACPI thermal: do not always return THERMAL_TREND_RAISING for active trip points
Date: Fri, 26 Apr 2013 14:07:45 +0200
Message-ID: <2045208.arlEGZ66vS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366967993-3812-1-git-send-email-rui.zhang@intel.com>
References: <1366967993-3812-1-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 26, 2013 05:19:53 PM Zhang Rui wrote:
> Commit 4ae46befb49d4173122e0afa995c4e93d01948a2
> introduces a regression that the fan is always on
> even if the system is in idle state.
> 
> My original idea in that commit is that:
> when the current temperature is above the trip point,
> keep the fan on, even if the temperature is dropping.
> when the current temperature is below the trip point,
> turn on the fan when the temperature is raising,
> turn off the fan when the temperature is dropping.
> 
> But this is what the code actually does:
> when the current temperature is above the trip point,
> the fan keeps on.
> when the current temperature is below the trip point,
> the fan is always on because thermal_get_trend()
> in driver/acpi/thermal.c returns THERMAL_TREND_RAISING.
> Thus the fan keeps running even if the system is idle.
> 
> Fix this in drivers/acpi/thermal.c.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=56591
> https://bugzilla.kernel.org/show_bug.cgi?id=56601
> https://bugzilla.kernel.org/show_bug.cgi?id=50041#c45
> 
> Patch should be applied to 3.7 stable kernel and later.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Matthias <morpheusxyz123@yahoo.de>
> Tested-by: Ville Syrjälä <syrjala@sci.fi>
> Cc: <stable@vger.kernel.org> # v3.7+

Applied.

Thanks,
Rafael


> ---
>  drivers/acpi/thermal.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 8470771..a33821c 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -723,9 +723,19 @@ static int thermal_get_trend(struct thermal_zone_device *thermal,
>  		return -EINVAL;
>  
>  	if (type == THERMAL_TRIP_ACTIVE) {
> -		/* aggressive active cooling */
> -		*trend = THERMAL_TREND_RAISING;
> -		return 0;
> +		unsigned long trip_temp;
> +		unsigned long temp = KELVIN_TO_MILLICELSIUS(tz->temperature,
> +							tz->kelvin_offset);
> +		if (thermal_get_trip_temp(thermal, trip, &trip_temp))
> +			return -EINVAL;
> +
> +		if (temp > trip_temp) {
> +			*trend = THERMAL_TREND_RAISING;
> +			return 0;
> +		} else {
> +			/* Fall back on default trend */
> +			return -EINVAL;
> +		}
>  	}
>  
>  	/*
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
