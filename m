Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3KOIIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:08:09 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45322 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3KOIHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:07:55 -0500
Date: Fri, 15 Nov 2013 09:07:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>,
        devicetree@vger.kernel.org, wni@nvidia.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        grant.likely@linaro.org
Subject: Re: [lm-sensors] [PATCHv9 02/20] thermal: introduce device tree
 parser
Message-ID: <20131115090736.4f360dc8@endymion.delvare>
In-Reply-To: <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
	<1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Tue, 12 Nov 2013 15:46:04 -0400, Eduardo Valentin wrote:
> This patch introduces a device tree bindings for
> describing the hardware thermal behavior and limits.
> Also a parser to read and interpret the data and feed
> it in the thermal framework is presented.
> 
> This patch introduces a thermal data parser for device
> tree. The parsed data is used to build thermal zones
> and thermal binding parameters. The output data
> can then be used to deploy thermal policies.
> 
> This patch adds also documentation regarding this
> API and how to define tree nodes to use
> this infrastructure.
> 
> Note that, in order to be able to have control
> on the sensor registration on the DT thermal zone,
> it was required to allow changing the thermal zone
> .get_temp callback. For this reason, this patch
> also removes the 'const' modifier from the .ops
> field of thermal zone devices.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
> (...)
> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> +				enum thermal_trend *trend)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +	long dev_trend;
> +	int r;
> +
> +	if (!data->get_trend)
> +		return -EINVAL;
> +
> +	r = data->get_trend(data->sensor_data, &dev_trend);
> +	if (r)
> +		return r;
> +
> +	/* TODO: These intervals might have some thresholds, but in core code */
> +	if (dev_trend > 0)
> +		*trend = THERMAL_TREND_RAISING;
> +	else if (dev_trend < 0)
> +		*trend = THERMAL_TREND_DROPPING;
> +	else
> +		*trend = THERMAL_TREND_STABLE;
> +
> +	return 0;
> +}

I don't like the whole trend thing.

I've been writing hwmon drivers for the past decade and I've never seen
a thermal sensor device being able to report trends. And as a rule of
thumb, if the hardware can't do it then the (hardware-specific) drivers
should not report it.

Hwmon devices (and drivers) report temperature values, and sometimes
historical min/max. They can do that because these are facts that need
no interpretation.

Defining a trend, however, requires care and, more importantly,
decisions. For example, consider a thermal sensor which reports 50°C at
time t, then 47°C at time t+3s, then 48°C at time t+6s. At t+7s someone
asks for the trend, what should the driver reply? If you consider only
the last 5 seconds, temperature is raising. If you consider the last 10
seconds instead, temperature is dropping. How would the driver know
what time frame the caller is interested in?

Another example: "small" temperature variations. If temperatures varies
by 1°C in my kitchen's oven, I'd call it stable. If my body temperature
varies by 1°C, I'd call it non-stable, and my doctor for an appointment
also ;-)

My point is that only the caller, and not the driver, knows how to
convert a series of measurements into a trend. So I don't think drivers
should implement anything like get_trend(). Whatever piece of code
needs to establish a trend should call get_temp() repeatedly, store the
results and do its own analysis of the data.

-- 
Jean Delvare
