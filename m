Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3BAFoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 00:44:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:55431 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3BAFoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 00:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="285161958"
Message-ID: <1359697446.2241.95.camel@rzhang1-mobl4>
Subject: Re: [PATCH] Thermal: Fix to use read critical temperature when
 required
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com
Date: Fri, 01 Feb 2013 13:44:06 +0800
In-Reply-To: <1357690739-17009-1-git-send-email-amit.daniel@samsung.com>
References: <1357690739-17009-1-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 16:18 -0800, Amit Daniel Kachhap wrote:
> This patch modifies the code to use get_crit_temp instead of
> the normal get_trip_temp when critical threshold point is crossed
> or queried about.
> 

is there any problem in the current code?

> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/thermal_sys.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index ecdfc7d..0dc6403 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -345,7 +345,10 @@ static void handle_critical_trips(struct thermal_zone_device *tz,
>  {
>  	long trip_temp;
>  
> -	tz->ops->get_trip_temp(tz, trip, &trip_temp);
> +	if (tz->ops->get_crit_temp)
> +		tz->ops->get_crit_temp(tz, &trip_temp);
> +	else
> +		tz->ops->get_trip_temp(tz, trip, &trip_temp);
>  
handle_critical_trips() can handle both active and hot trip points.
this change will break HOT trip point.

>  	/* If we have not crossed the trip_temp, we do not care. */
>  	if (tz->temperature < trip_temp)
> @@ -550,6 +553,7 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
>  	int trip, ret;
>  	long temperature;
> +	enum thermal_trip_type type;
>  
>  	if (!tz->ops->get_trip_temp)
>  		return -EPERM;
> @@ -557,7 +561,14 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
>  	if (!sscanf(attr->attr.name, "trip_point_%d_temp", &trip))
>  		return -EINVAL;
>  
> -	ret = tz->ops->get_trip_temp(tz, trip, &temperature);
> +	ret = tz->ops->get_trip_type(tz, trip, &type);
> +	if (ret)
> +		return ret;
> +
> +	if (type == THERMAL_TRIP_CRITICAL && tz->ops->get_crit_temp)
> +		ret = tz->ops->get_crit_temp(tz, &temperature);
> +	else
> +		ret = tz->ops->get_trip_temp(tz, trip, &temperature);
>  

what's the benefit of using .get_crit_temp() instead of .get_trip_temp()
for CRITICAL trip points here?
.get_trip_point can also get the critical trip point temperature.

instead, I think we could remove .get_crit_temp callback.
for hwmon sysfs, we just need to use get_trip_type to find the critical
trip point.

thanks,
rui

