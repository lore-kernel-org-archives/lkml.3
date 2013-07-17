Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3GQQZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:25:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:48918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab3GQQZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:25:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,685,1367996400"; 
   d="scan'208";a="366723506"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
CC: "wni@nvidia.com" <wni@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>
Subject: RE: [lm-sensors] [RESEND PATCH V1 3/9] thermal: thermal_core: allow
	binding with limits on bind_params
Thread-Topic: [lm-sensors] [RESEND PATCH V1 3/9] thermal: thermal_core:
 allow	binding with limits on bind_params
Thread-Index: AQHOgwFk5ragkdvpYEGRt4c2aEH5NplpDV+w
Date: Wed, 17 Jul 2013 16:25:11 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59CED41F@BGSMSX101.gar.corp.intel.com>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <1374074248-31690-4-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1374074248-31690-4-git-send-email-eduardo.valentin@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: lm-sensors-bounces@lm-sensors.org [mailto:lm-sensors-bounces@lm-
> sensors.org] On Behalf Of Eduardo Valentin
> Sent: Wednesday, July 17, 2013 8:47 PM
> To: devicetree-discuss@lists.ozlabs.org
> Cc: wni@nvidia.com; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> lm-sensors@lm-sensors.org; Eduardo Valentin; Zhang, Rui;
> l.stach@pengutronix.de
> Subject: [lm-sensors] [RESEND PATCH V1 3/9] thermal: thermal_core: allow
> binding with limits on bind_params
> 
> When registering a thermal zone device using platform information
> via bind_params, the thermal framework will always perform the
> cdev binding using the lowest and highest limits (THERMAL_NO_LIMIT).
> 
> This patch changes the data structures so that it is possible
> to inform what are the desired limits for each trip point
> inside a bind_param. The way the binding is performed is also
> changed so that it uses the new data structure.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

This patch looks good to me.
Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> ---
>  Documentation/thermal/sysfs-api.txt |  7 +++++++
>  drivers/thermal/thermal_core.c      | 19 +++++++++++++++----
>  include/linux/thermal.h             | 10 ++++++++++
>  3 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/thermal/sysfs-api.txt
> b/Documentation/thermal/sysfs-api.txt
> index a71bd5b..2ad50e7 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -134,6 +134,13 @@ temperature) and throttle appropriate devices.
>                 this thermal zone and cdev, for a particular trip point.
>                 If nth bit is set, then the cdev and thermal zone are bound
>                 for trip point n.
> +    .limits: This is an array of cooling state limits. Must have exactly
> +         2 * thermal_zone.number_of_trip_points. It is an array consisting
> +         of tuples <lower-state upper-state> of state limits. Each trip
> +         will be associated with one state limit tuple when binding.
> +         A NULL pointer means <THERMAL_NO_LIMITS THERMAL_NO_LIMITS>
> +         on all trips. These limits are used when binding a cdev to a
> +         trip point.
>      .match: This call back returns success(0) if the 'tz and cdev' need to
>  	    be bound, as per platform data.
>  1.4.2 struct thermal_zone_params
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 247528b..096c8be 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -202,14 +202,23 @@ static void print_bind_err_msg(struct
> thermal_zone_device *tz,
>  }
> 
>  static void __bind(struct thermal_zone_device *tz, int mask,
> -			struct thermal_cooling_device *cdev)
> +			struct thermal_cooling_device *cdev,
> +			unsigned long *limits)
>  {
>  	int i, ret;
> 
>  	for (i = 0; i < tz->trips; i++) {
>  		if (mask & (1 << i)) {
> +			unsigned long upper, lower;
> +
> +			upper = THERMAL_NO_LIMIT;
> +			lower = THERMAL_NO_LIMIT;
> +			if (limits) {
> +				lower = limits[i * 2];
> +				upper = limits[i * 2 + 1];
> +			}
>  			ret = thermal_zone_bind_cooling_device(tz, i, cdev,
> -					THERMAL_NO_LIMIT,
> THERMAL_NO_LIMIT);
> +							       upper, lower);
>  			if (ret)
>  				print_bind_err_msg(tz, cdev, ret);
>  		}
> @@ -254,7 +263,8 @@ static void bind_cdev(struct thermal_cooling_device
> *cdev)
>  			if (tzp->tbp[i].match(pos, cdev))
>  				continue;
>  			tzp->tbp[i].cdev = cdev;
> -			__bind(pos, tzp->tbp[i].trip_mask, cdev);
> +			__bind(pos, tzp->tbp[i].trip_mask, cdev,
> +			       tzp->tbp[i].binding_limits);
>  		}
>  	}
> 
> @@ -292,7 +302,8 @@ static void bind_tz(struct thermal_zone_device *tz)
>  			if (tzp->tbp[i].match(tz, pos))
>  				continue;
>  			tzp->tbp[i].cdev = pos;
> -			__bind(tz, tzp->tbp[i].trip_mask, pos);
> +			__bind(tz, tzp->tbp[i].trip_mask, pos,
> +			       tzp->tbp[i].binding_limits);
>  		}
>  	}
>  exit:
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index a386a1c..39575eb 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -207,6 +207,16 @@ struct thermal_bind_params {
>  	 * See Documentation/thermal/sysfs-api.txt for more information.
>  	 */
>  	int trip_mask;
> +
> +	/*
> +	 * This is an array of cooling state limits. Must have exactly
> +	 * 2 * thermal_zone.number_of_trip_points. It is an array consisting
> +	 * of tuples <lower-state upper-state> of state limits. Each trip
> +	 * will be associated with one state limit tuple when binding.
> +	 * A NULL pointer means <THERMAL_NO_LIMITS THERMAL_NO_LIMITS>
> +	 * on all trips.
> +	 */
> +	unsigned long *binding_limits;
>  	int (*match) (struct thermal_zone_device *tz,
>  			struct thermal_cooling_device *cdev);
>  };
> --
> 1.8.2.1.342.gfa7285d
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
