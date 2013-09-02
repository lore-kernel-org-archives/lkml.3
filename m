Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3IBINl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:13:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8568 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3IBINi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:13:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Sep 2013 01:10:54 -0700
Message-ID: <522448CB.3080102@nvidia.com>
Date: Mon, 2 Sep 2013 16:14:03 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/14] drivers: thermal: introduce device tree parser
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com> <521CAD48.2030306@ti.com> <20130827162309.GR19893@e106331-lin.cambridge.arm.com> <521CED34.2090008@ti.com> <521FD70F.7080104@ti.com>
In-Reply-To: <521FD70F.7080104@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 07:19 AM, Eduardo Valentin wrote:
> * PGP Signed: 08/29/2013 at 04:19:46 PM
> 
> Mark, Pawel and Stephen,
> 
> 
> On 27-08-2013 14:17, Eduardo Valentin wrote:
>> On 27-08-2013 12:23, Mark Rutland wrote:
>>> On Tue, Aug 27, 2013 at 02:44:40PM +0100, Eduardo Valentin wrote:
>>>> Hello Mark,
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
> 
> *Note: THERMAL_NO_LIMIT means, it will be using the cooling device
> minimum and maximum limits.
> 
> Couple of comments.
> 1. I am keeping the pooling intervals. A possible alternative way to
> describe that would be specifying the maximum dT/dt. Essentially because
> I am still convinced that this is part of hw specs.
> 
> 2. The above follows your suggestion to use consumer pointing to
> producers. Although, I still need to figure out how this could be
> implemented for Linux. But I think that is another story, at least for
> now. We need to first align on the DT binding itself.
> 
> 3. The link from cooling device specification to trip points, from my
> perspective, should be enough, and thus we shall not need the thermal
> cells and size for trip points, as you proposed. Let me know what you think.
> 
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
Yes, I think so, and this series is what I'm looking for, thanks again.

> 
> Durga, please also check if I am missing something to cover for your
> plans to, in case you will be using DT to describe your HW.
> 
> Anyways, Mark and Pawel, let me know if I missed something from our
> discussion. I believe the above bindings would look more like regular
> standard DT bindings. And also they should be now slim enough, without
> Linux implementation details and also without policies.
> 
>>
>>
> 
> 

