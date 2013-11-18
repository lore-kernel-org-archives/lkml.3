Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab3KRGDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 01:03:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:21875 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3KRGDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 01:03:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,721,1378882800"; 
   d="scan'208";a="429426042"
Message-ID: <1384754650.2316.32.camel@rzhang-lenovo>
Subject: Re: [lm-sensors] [PATCHv9 02/20] thermal: introduce device tree
 parser
From: Zhang Rui <rui.zhang@intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, swarren@wwwdotorg.org,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob.herring@calxeda.com, linux@roeck-us.net,
        devicetree@vger.kernel.org, wni@nvidia.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        grant.likely@linaro.org
Date: Mon, 18 Nov 2013 14:04:10 +0800
In-Reply-To: <20131115090736.4f360dc8@endymion.delvare>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
	 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
	 <20131115090736.4f360dc8@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2013-11-15 at 09:07 +0100, Jean Delvare wrote:
> Hi Eduardo,
> 
> On Tue, 12 Nov 2013 15:46:04 -0400, Eduardo Valentin wrote:
> > This patch introduces a device tree bindings for
> > describing the hardware thermal behavior and limits.
> > Also a parser to read and interpret the data and feed
> > it in the thermal framework is presented.
> > 
> > This patch introduces a thermal data parser for device
> > tree. The parsed data is used to build thermal zones
> > and thermal binding parameters. The output data
> > can then be used to deploy thermal policies.
> > 
> > This patch adds also documentation regarding this
> > API and how to define tree nodes to use
> > this infrastructure.
> > 
> > Note that, in order to be able to have control
> > on the sensor registration on the DT thermal zone,
> > it was required to allow changing the thermal zone
> > .get_temp callback. For this reason, this patch
> > also removes the 'const' modifier from the .ops
> > field of thermal zone devices.
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> > ---
> > (...)
> > +static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> > +				enum thermal_trend *trend)
> > +{
> > +	struct __thermal_zone *data = tz->devdata;
> > +	long dev_trend;
> > +	int r;
> > +
> > +	if (!data->get_trend)
> > +		return -EINVAL;
> > +
> > +	r = data->get_trend(data->sensor_data, &dev_trend);
> > +	if (r)
> > +		return r;
> > +
> > +	/* TODO: These intervals might have some thresholds, but in core code */
> > +	if (dev_trend > 0)
> > +		*trend = THERMAL_TREND_RAISING;
> > +	else if (dev_trend < 0)
> > +		*trend = THERMAL_TREND_DROPPING;
> > +	else
> > +		*trend = THERMAL_TREND_STABLE;
> > +
> > +	return 0;
> > +}
> 
> I don't like the whole trend thing.
> 
> I've been writing hwmon drivers for the past decade and I've never seen
> a thermal sensor device being able to report trends. And as a rule of
> thumb, if the hardware can't do it then the (hardware-specific) drivers
> should not report it.

I agree that a sensor device should not be able to report trends. But
currently, the thermal zone driver is not only a sensor driver, it also
owns the platform thermal cooling strategy.
And some platforms do have this kind of knowledge, right?
e.g. ACPI spec provides an equation for processor passive cooling (ACPI
Spec 5.0 11.1.5).

> 
> Hwmon devices (and drivers) report temperature values, and sometimes
> historical min/max. They can do that because these are facts that need
> no interpretation.
> 
> Defining a trend, however, requires care and, more importantly,
> decisions.

We had the assumption that we will get an interrupt when the firmware
thinks there is an temperature change that should be noticed by OS.

>  For example, consider a thermal sensor which reports 50°C at
> time t, then 47°C at time t+3s,

does firmware thinks this should be noticed by OS?
If no, there is no interrupt and this temperature change is totally
transparent to the OS at all.
If yes, the thermal core will check if the system is overheating, if
yes, it throttles the devices, and if no, do nothing.

>  then 48°C at time t+6s. At t+7s someone
> asks for the trend,

the trend is needed when platform thermal driver calls
thermal_zone_device_update(), and mostly following a temperature change
interrupt.

>  what should the driver reply?
>  If you consider only
> the last 5 seconds, temperature is raising. If you consider the last 10
> seconds instead, temperature is dropping. How would the driver know
> what time frame the caller is interested in?
> 
> Another example: "small" temperature variations. If temperatures varies
> by 1°C in my kitchen's oven, I'd call it stable. If my body temperature
> varies by 1°C, I'd call it non-stable, and my doctor for an appointment
> also ;-)
> 

> My point is that only the caller, and not the driver, knows how to
> convert a series of measurements into a trend. So I don't think drivers
> should implement anything like get_trend(). Whatever piece of code
> needs to establish a trend should call get_temp() repeatedly, store the
> results and do its own analysis of the data.
> 
I think the key problem is that,
the thermal subsystem just provides a basic/minimum thermal control
framework in kernel, and it is totally platform independent. And any
platform driver can use this framework to do some basic thermal control
easily but just telling thermal core if the thermal core should take
some cooling actions (trip points + trend + current temperature) and how
(by choosing thermal governors).

So if you want to do more precise thermal control, you'd better disable
kernel thermal control and do it in userspace. In this case,
the .get_trend() will never be invoked at all.
Further more, I'm indeed considering introduce platform specific thermal
governors, so that platform thermal driver can tell thermal core what to
do at a certain point.

thanks,
rui

