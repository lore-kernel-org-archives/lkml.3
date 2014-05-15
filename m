Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaEOSxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:53:42 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33686 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaEOSxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:53:06 -0400
Date: Thu, 15 May 2014 14:58:14 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: Re: [RFC PATCH 4/5] thermal: cpu_cooling: Release the upper cooling
 limit checks
Message-ID: <20140515185814.GD3138@developer>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
 <1399559880-20562-5-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399559880-20562-5-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,

On Thu, May 08, 2014 at 08:07:59PM +0530, Amit Daniel Kachhap wrote:
> This is required as with addition of cpufreq cooling notifiers
> mechanism the client can enable some more cooling states at a later
> point of time. Say when minimum p state is reached then ACPI specific
> throttling is enabled which may add some more cooling states.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/step_wise.c    |    2 +-
>  drivers/thermal/thermal_core.c |    9 +++------
>  include/linux/thermal.h        |    1 +
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> index f251521..7d65617 100644
> --- a/drivers/thermal/step_wise.c
> +++ b/drivers/thermal/step_wise.c
> @@ -72,7 +72,7 @@ static unsigned long get_target_state(struct thermal_instance *instance,
>  		}
>  		break;
>  	case THERMAL_TREND_RAISE_FULL:
> -		if (throttle)
> +		if (instance->upper != THERMAL_CSTATE_MAX && throttle)
>  			next_target = instance->upper;
>  		break;
>  	case THERMAL_TREND_DROPPING:
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 71b0ec0..36bb107 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -921,7 +921,6 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	struct thermal_instance *pos;
>  	struct thermal_zone_device *pos1;
>  	struct thermal_cooling_device *pos2;
> -	unsigned long max_state;
>  	int result;
>  
>  	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
> @@ -939,13 +938,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	if (tz != pos1 || cdev != pos2)
>  		return -EINVAL;
>  
> -	cdev->ops->get_max_state(cdev, &max_state);
> -

I am not sure I follow why we need to release this check. Can't the user
use the notifier infrastructure and change the max state?

I think I need a better view of use cases where max state would change.



> -	/* lower default 0, upper default max_state */
> +	/* lower default 0, upper default THERMAL_CSTATE_MAX */
>  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> -	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
> +	upper = upper == THERMAL_NO_LIMIT ? THERMAL_CSTATE_MAX : upper;
>  
> -	if (lower > upper || upper > max_state)
> +	if (lower > upper)
>  		return -EINVAL;
>  
>  	dev =
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..3748e6d 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -36,6 +36,7 @@
>  
>  /* invalid cooling state */
>  #define THERMAL_CSTATE_INVALID -1UL
> +#define THERMAL_CSTATE_MAX 1UL
>  
>  /* No upper/lower limit requirement */
>  #define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
