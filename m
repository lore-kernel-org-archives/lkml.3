Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3ETQBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:01:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:39360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372Ab3ETQBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:01:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="340292141"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
 point only.
Thread-Topic: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
 point only.
Thread-Index: AQHOU606/Yh7o2smg0ibDPkuu1vutpkOPjKw
Date: Mon, 20 May 2013 16:00:57 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301102442@SHSMSX101.ccr.corp.intel.com>
References: <1368870663-1225-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1368870663-1225-1-git-send-email-jonghwa3.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> Sent: Saturday, May 18, 2013 5:51 PM
> To: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
> Subject: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
> point only.
> Importance: High
> 
> When thermal zone device is updated, it doesn't need to check every
> trip points and its handling mathod even current temperature doesn't
> exceed the trip's temperature. To modify those dissipatve mechanism,
> this patch introduces the way to get current thermal trip point to call
> only correspond trip point handling.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

NAK.

> ---
>  drivers/thermal/thermal_core.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c index ce4384a..1cc4825 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -333,14 +333,6 @@ static void handle_non_critical_trips(struct
> thermal_zone_device *tz,  static void handle_critical_trips(struct
> thermal_zone_device *tz,
>  				int trip, enum thermal_trip_type trip_type)  {
> -	long trip_temp;
> -
> -	tz->ops->get_trip_temp(tz, trip, &trip_temp);
> -
> -	/* If we have not crossed the trip_temp, we do not care. */
> -	if (tz->temperature < trip_temp)
> -		return;
> -
>  	if (tz->ops->notify)
>  		tz->ops->notify(tz, trip, trip_type);
> 
> @@ -437,14 +429,28 @@ static void update_temperature(struct
> thermal_zone_device *tz)
>  	mutex_unlock(&tz->lock);
>  }
> 
> +static int thermal_zone_get_current_trip(struct thermal_zone_device
> +*tz) {
> +	int trip;
> +	long trip_temp;
> +
> +	for (trip = tz->trips - 1; trip > 0; trip--) {
> +		tz->ops->get_trip_temp(tz, trip, &trip_temp);
> +		if (tz->temperature > trip_temp)
> +			continue;
> +	}
> +	return trip;
> +}
> +
>  void thermal_zone_device_update(struct thermal_zone_device *tz)  {
> -	int count;
> +	int trip;
> 
>  	update_temperature(tz);
> 
> -	for (count = 0; count < tz->trips; count++)
> -		handle_thermal_trip(tz, count);
> +	trip = thermal_zone_get_current_trip(tz);
> +
> +	handle_thermal_trip(tz, trip);

Say, trip point 1 for thermal zone 0 is 60C,
The system is running above 60C for somethime,
thus the thermal_instance for this trip point is running at upper_limit.
When the temperature suddenly drops below 60C,
we still need to handle trip point 1 to deactivate it.

Thanks,
rui
>  }
>  EXPORT_SYMBOL_GPL(thermal_zone_device_update);
> 
> --
> 1.7.9.5

