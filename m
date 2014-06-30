Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaF3VI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:08:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38907 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaF3VI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:08:28 -0400
Message-ID: <53B1D1C8.5010907@wwwdotorg.org>
Date: Mon, 30 Jun 2014 15:08:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        mlongnecker@nvidia.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] thermal: of: Add support for hardware-tracked trip
 points
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-2-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403856699-2140-2-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
> This adds support for hardware-tracked trip points to the device tree
> thermal sensor framework.
> 
> The framework supports an arbitrary number of trip points. Whenever
> the current temperature is updated, the trip points immediately
> below and above the current temperature are found. A sensor driver
> callback `set_trips' is then called with the temperatures.
> If there is no trip point above or below the current temperature,
> the passed trip temperature will be LONG_MAX or LONG_MIN respectively.
> In this callback, the driver should program the hardware such that
> it is notified when either of these trip points are triggered.
> When a trip point is triggered, the driver should call
> `thermal_zone_device_update' for the respective thermal zone. This
> will cause the trip points to be updated again.
> 
> If the `set_trips' callback is not implemented (is NULL), the framework
> behaves as before.

Is there no "core thermal" code? I would have expected this new feature
to be implemented in "core" code rather than of/dt "support" code.
Perhaps there would also be some additions to the of/dt code, but I'd
still expect the bulk of the feature to be complete independant of
of/dt. Systems still using board files or ACPI or ... would surely
benefit from this too?

> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c

> +static int of_thermal_set_trips(struct thermal_zone_device *tz, long temp)

s/tz/tzd/ or s/tz/tzdev/ ? Since "tz" says "thermal zone" to me, but
it's actually a "thermal zone device".

> +	struct __thermal_zone *data = tz->devdata;

s/data/tz/ ? "data" is a rather generic term, and "tz" seems like a good
abbreviation for a __thermal_zone.

> +	for (i = 0; i < data->ntrips; ++i) {
> +		struct __thermal_trip *trip = data->trips + i;
> +		long trip_low = trip->temperature - trip->hysteresis;
> +
> +		if (trip_low < temp && trip_low > low)
> +			low = trip_low;
> +
> +		if (trip->temperature > temp && trip->temperature < high)
> +			high = trip->temperature;
> +	}

That seems to always apply hysteresis to the low end of a trip object.
Don't you need to apply the hysteresis to either the low or high end of
the range, depending on whether the temperature is currently below/above
the range, and hence which direction the edge will be crossed?

Similar comments elsewhere. Perhaps the patch is consistent with some
existing confusing naming style though?

> +static int of_thermal_update_trips(struct thermal_zone_device *tz)
> +{
> +	long temp;
> +	int err;
> +
> +	err = of_thermal_get_temp(tz, &temp);
> +	if (err)
> +		return err;
> +
> +	err = of_thermal_set_trips(tz, temp);

Doesn't this patch modify of_thermal_get_temp() to call
of_thermal_set_trips() itself?

> @@ -384,7 +467,8 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>  struct thermal_zone_device *
>  thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>  				void *data, int (*get_temp)(void *, long *),
> -				int (*get_trend)(void *, long *))
> +				int (*get_trend)(void *, long *),
> +				int (*set_trips)(void *, long, long))

Passing in a struct containing fields for all the ops seem better than
forever extending this function with more and more function pointers.
