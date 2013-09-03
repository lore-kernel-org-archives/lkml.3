Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3ICNR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:17:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52176 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760021Ab3ICNRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:17:25 -0400
Date: Tue, 3 Sep 2013 14:15:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/14] drivers: thermal: introduce device tree
 parser
Message-ID: <20130903131554.GE18206@e106331-lin.cambridge.arm.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
 <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com>
 <20130827102205.GC19893@e106331-lin.cambridge.arm.com>
 <521CAD48.2030306@ti.com>
 <20130827162309.GR19893@e106331-lin.cambridge.arm.com>
 <521CED34.2090008@ti.com>
 <521FD70F.7080104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521FD70F.7080104@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:19:43AM +0100, Eduardo Valentin wrote:
> Mark, Pawel and Stephen,
> 
> 
> On 27-08-2013 14:17, Eduardo Valentin wrote:
> > On 27-08-2013 12:23, Mark Rutland wrote:
> >> On Tue, Aug 27, 2013 at 02:44:40PM +0100, Eduardo Valentin wrote:
> >>> Hello Mark,

Hi, sorry for the delay.

> 
> <cut>
> 
> I believe now we need to align on thermal bindings, before I propose
> next version of this series. So, following the discussions on this
> thread, I believe a typical CPU thermal zone would look like the following:
> + #include <dt-bindings/thermal/thermal.h>
> +
> + cpu_thermal: cpu_thermal {
> +         passive-delay = <250>; /* milliseconds */
> +         polling-delay = <1000>; /* milliseconds */

I'm still not keen on placing these intervals in the dt. Why can the
kernel not choose sensible values?

> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors = <&bandgap0     0>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower
> bound             upper bound
> +                          */
> +         cooling-devices = <&cpu0        100     &cpu-alert
> THERMAL_NO_LIMITS        THERMAL_NO_LIMITS>;

I'm not sure it makes sense to group this data within a property. We
might need to extend this in future and it might not be possible to
extend this unambiguously. It may make more sense as a sub-node or
collection of properties.

> +         trips {
> +                 cpu-alert: cpu-alert {
> +                         temperature = <100000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 cpu-crit: cpu-crit {
> +                         temperature = <125000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };

How do the upper and lower bounds in the cooling-devices property
interact with temperatures described in the trips node?

> 
> *Note: THERMAL_NO_LIMIT means, it will be using the cooling device
> minimum and maximum limits.

I'm confused what are the cooling device min and max limits? Where are
they defined if not in the lower bound and upper bound entries of the
cooling-devices property?

> 
> Couple of comments.
> 1. I am keeping the pooling intervals. A possible alternative way to
> describe that would be specifying the maximum dT/dt. Essentially because
> I am still convinced that this is part of hw specs.

I still don't see why it's not possible to do this dynamically. I am not
entirely convinced this is part of the hw spec.

> 
> 2. The above follows your suggestion to use consumer pointing to
> producers. Although, I still need to figure out how this could be
> implemented for Linux. But I think that is another story, at least for
> now. We need to first align on the DT binding itself.

I assume you mean the sensors property? That looks fine to me, though we
may need to specify the way sensors relate to temperatures in trip
points and cooling device properties -- do those temperatures correspond
to an average of sensors readings, min/max, etc?

> 
> 3. The link from cooling device specification to trip points, from my
> perspective, should be enough, and thus we shall not need the thermal
> cells and size for trip points, as you proposed. Let me know what you think.

I'm not keen on the mixed bag of values in the cooling-device property,
as it's difficult to extend in future if necessary. I think we may need
cells for cooling devices -- what if a single fan controller controls
fans in different thermal zones?

I'm also not keen on devices being described as their own cooling
device, as I think this is more difficult to support than not listing a
cooling device -- it'll have to be special-cased anyway.

> Below is another example, on a more complex scenario, board specific
> case (hypothetical, just for exemplification):
> 
> + #include <dt-bindings/thermal/thermal.h>
> +
> + board_thermal: board_thermal {
> +         passive-delay = <1000>; /* milliseconds */
> +         polling-delay = <2500>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors = <&adc-dummy     0>,
> +		    <&adc-dummy     1>,
> +		    <&adc-dymmy     2>;

Here we have a set of sensors, but no relationship between these sensors
and the trips or cooling-devices are described. How does that work?

> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip		lower	upper
> +                          */
> +         cooling-devices = <&cpu0       75     &cpu-trip	0      2>,
> +			    <&gpu0       40     &gpu-trip	0      2>;
> +			    <&lcd0       25     &lcd-trip	5      10>;
> +         trips {
> +                 cpu-trip: cpu-trip {
> +                         temperature = <60000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 gpu-trip: gpu-trip {
> +                         temperature = <55000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 }
> +                 lcd-trip: lcp-trip {
> +                         temperature = <53000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 crit-trip: crit-trip {
> +                         temperature = <68000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
> 
> Now writing the above example, one might want to have a way to say the
> sensor correlation equation.
> 
> Another example:
> + #include <dt-bindings/thermal/thermal.h>
> +
> + dsp_thermal: dsp_thermal {
> +         passive-delay = <250>; /* milliseconds */
> +         polling-delay = <1000>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors = <&bandgap0     1>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower
> bound             upper bound
> +                          */
> +         cooling-devices = <&dsp0        100     &dsp-alert
> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
> +         trips {
> +                 dsp-alert: dsp-alert {
> +                         temperature = <100000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 dsp-crit: cdsp-crit {
> +                         temperature = <125000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
> +
> + gpu_thermal: gpu_thermal {
> +         passive-delay = <500>; /* milliseconds */
> +         polling-delay = <1000>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors = <&bandgap0     2>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower
> bound             upper bound
> +                          */
> +         cooling-devices = <&gpu0        100     &gpu-alert
> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
> +         trips {
> +                 gpu-alert: gpu-alert {
> +                         temperature = <100000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 gpu-crit: gpu-crit {
> +                         temperature = <125000>; /* milliCelsius */
> +                         hysteresis = <2000>; /* milliCelsius */
> +                         type = <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
> 
> 
> Wei, I think the above would cover for the IPs with multiple internal
> sensors cases you were looking for, right?
> 
> Durga, please also check if I am missing something to cover for your
> plans to, in case you will be using DT to describe your HW.
> 
> Anyways, Mark and Pawel, let me know if I missed something from our
> discussion. I believe the above bindings would look more like regular
> standard DT bindings. And also they should be now slim enough, without
> Linux implementation details and also without policies.

I think that the above can describe that, but I'd like to see a binding
document so we can consider it in more detail.

Thanks,
Mark.
