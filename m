Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbaGASQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:16:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36838 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaGASQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:16:00 -0400
Message-ID: <53B2FADC.8060708@wwwdotorg.org>
Date: Tue, 01 Jul 2014 12:15:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] thermal: of: Add support for hardware-tracked trip
 points
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-2-git-send-email-mperttunen@nvidia.com> <53B1D1C8.5010907@wwwdotorg.org> <53B262EA.9030806@nvidia.com>
In-Reply-To: <53B262EA.9030806@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:27 AM, Mikko Perttunen wrote:
> Inline.
> 
> On 01/07/14 00:08, Stephen Warren wrote:
>> On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
>>> This adds support for hardware-tracked trip points to the device tree
>>> thermal sensor framework.
>>>
>>> The framework supports an arbitrary number of trip points. Whenever
>>> the current temperature is updated, the trip points immediately
>>> below and above the current temperature are found. A sensor driver
>>> callback `set_trips' is then called with the temperatures.
>>> If there is no trip point above or below the current temperature,
>>> the passed trip temperature will be LONG_MAX or LONG_MIN respectively.
>>> In this callback, the driver should program the hardware such that
>>> it is notified when either of these trip points are triggered.
>>> When a trip point is triggered, the driver should call
>>> `thermal_zone_device_update' for the respective thermal zone. This
>>> will cause the trip points to be updated again.
>>>
>>> If the `set_trips' callback is not implemented (is NULL), the framework
>>> behaves as before.
>>
>> Is there no "core thermal" code? I would have expected this new feature
>> to be implemented in "core" code rather than of/dt "support" code.
>> Perhaps there would also be some additions to the of/dt code, but I'd
>> still expect the bulk of the feature to be complete independant of
>> of/dt. Systems still using board files or ACPI or ... would surely
>> benefit from this too?
> 
> The thermal core only supports a fixed number of trip points for each
> driver and the core informs the driver of any changes to those, so
> drivers using the core framework can already have hardware trip points,
> but just a fixed number of them.
> 
> The way of-thermal works, is it reads all the trip points from the
> device tree, registers a new thermal_zone_device with that number of
> trip points and then handles the trip points completely independently.
> Of course, if we're just polling, this is fine, since the thermal core
> also knows about those trip points and will trigger cooling when polling
> the each zone. However, the driver doesn't, so it cannot setup any
> interrupts to call thermal_zone_device_update.

Is there any possibility of cleaning that up? It's obviously horribly
inconsistent if core driver functionality works completely differently
simply because the list of trip-points comes from DT rather than a
static table in the driver. of_thermal should be limited to DT parsing
and related device instantiation/lookup, not introducing a completely
different functionality model.

>>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c

>>> +    for (i = 0; i < data->ntrips; ++i) {
>>> +        struct __thermal_trip *trip = data->trips + i;
>>> +        long trip_low = trip->temperature - trip->hysteresis;
>>> +
>>> +        if (trip_low < temp && trip_low > low)
>>> +            low = trip_low;
>>> +
>>> +        if (trip->temperature > temp && trip->temperature < high)
>>> +            high = trip->temperature;
>>> +    }
>>
>> That seems to always apply hysteresis to the low end of a trip object.
>> Don't you need to apply the hysteresis to either the low or high end of
>> the range, depending on whether the temperature is currently below/above
>> the range, and hence which direction the edge will be crossed?
> 
> I believe applying only to the low end is correct. Say that we have a
> trip point at 40C and hysteresis of 2C. When we exceed 40C cooling will
> start immediately, but it will only be stopped when we cool down to 38C.
> At that point there is again a 2C gap between the current temperature
> and the trip point. It would seem that this is the interpretation used
> by our downstream kernel and also some people on the Internet (however
> trustworthy they may be..)
> 
> If you don't feel this is right, please elaborate.

Ah, the point I was missing is that each trip point is a single
temperature, not a temperature range. As such, the code in your patch is
correct.
