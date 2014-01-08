Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaAHDTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:19:13 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11906 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaAHDTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:19:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Jan 2014 19:19:27 -0800
Message-ID: <52CCC3CF.7000103@nvidia.com>
Date: Wed, 8 Jan 2014 11:19:43 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
 <52C299A8.4010108@nvidia.com> <52CB6AE2.2090002@nvidia.com>
 <52CBE237.7010309@ti.com>
In-Reply-To: <52CBE237.7010309@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 07:17 PM, Eduardo Valentin wrote:
> * PGP Signed by an unknown key
> 
> On 06-01-2014 22:48, Wei Ni wrote:
>> Hi, Eduardo
>> Will you consider my comments :)
> 
> By now Wei, it is better if you start a new thread, by sending a patch
> on top of it, as this thread has been already merged by Rui.

Ok, I will send it.

Thanks.
Wei.
> 
>>
>> Thanks.
>> Wei.
>>
>> On 12/31/2013 06:17 PM, Wei Ni wrote:
>>> On 11/13/2013 03:46 AM, Eduardo Valentin wrote:
>>>> This patch introduces a device tree bindings for
>>>> describing the hardware thermal behavior and limits.
>>>> Also a parser to read and interpret the data and feed
>>>> it in the thermal framework is presented.
>>>>
>>>> This patch introduces a thermal data parser for device
>>>> tree. The parsed data is used to build thermal zones
>>>> and thermal binding parameters. The output data
>>>> can then be used to deploy thermal policies.
>>>>
>>>> This patch adds also documentation regarding this
>>>> API and how to define tree nodes to use
>>>> this infrastructure.
>>>>
>>>> Note that, in order to be able to have control
>>>> on the sensor registration on the DT thermal zone,
>>>> it was required to allow changing the thermal zone
>>>> .get_temp callback. For this reason, this patch
>>>> also removes the 'const' modifier from the .ops
>>>> field of thermal zone devices.
>>>>
>>>> ...
>>>> +
>>>> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>>>> +				enum thermal_trend *trend)
>>>> +{
>>>> +	struct __thermal_zone *data = tz->devdata;
>>>> +	long dev_trend;
>>>> +	int r;
>>>> +
>>>> +	if (!data->get_trend)
>>>> +		return -EINVAL;
>>>> +
>>>> +	r = data->get_trend(data->sensor_data, &dev_trend);
>>> I think the ->get_trend should be defined as:
>>> .get_trend(*dev, int, *long)
>>> so that the "trip" can be passed into it, otherwise the "trip" can't be
>>> used.
>>> And the dev_trend should be returned as THERMAL_TREND_XXX directly.
>>> because the THERM_TREND_xx is more than three states.
>>>
>>> The code may be something like:
>>> r = data->get_trend(data->sensor_data, trip, &dev_trend);
>>> if (r)
>>>     return r;
>>> *trend = dev_trend;
>>> return 0;
>>>> +	if (r)
>>>> +		return r;
>>>> +
>>>> +	/* TODO: These intervals might have some thresholds, but in core code */
>>>> +	if (dev_trend > 0)
>>>> +		*trend = THERMAL_TREND_RAISING;
>>>> +	else if (dev_trend < 0)
>>>> +		*trend = THERMAL_TREND_DROPPING;
>>>> +	else
>>>> +		*trend = THERMAL_TREND_STABLE;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> .....
>>>> +
>>>> +/***   sensor API   ***/
>>>> +
>>>> +static struct thermal_zone_device *
>>>> +thermal_zone_of_add_sensor(struct device_node *zone,
>>>> +			   struct device_node *sensor, void *data,
>>>> +			   int (*get_temp)(void *, long *),
>>>> +			   int (*get_trend)(void *, long *))
>>>> +{
>>>> +	struct thermal_zone_device *tzd;
>>>> +	struct __thermal_zone *tz;
>>>> +
>>>> +	tzd = thermal_zone_get_zone_by_name(zone->name);
>>> I think we could get the thermal zone by node,
>>> something like:
>>> thermal_zone_get_zone_by_node(zone);
>>> so that it can get unique zone.
>>>
>>> I think we can add a member "struct device_node *np" in the
>>> thermal_zone_device,
>>> and set it after you call thermal_zone_device_register successfully.
>>> Then add following codes:
>>> thermal_zone_get_zone_by_node(struct device_node *node)
>>> {
>>>         struct thermal_zone_device *pos = NULL, *ref = ERR_PTR(-ENODEV);
>>>         bool found = false;
>>>
>>>         if (!node)
>>>                 return ERR_PTR(-EINVAL);
>>>
>>>         mutex_lock(&thermal_list_lock);
>>>         list_for_each_entry(pos, &thermal_tz_list, node)
>>>                 if (node == pos->np) {
>>>                         ref = pos;
>>>                         found = true;
>>>                         break;
>>>                 }
>>>         mutex_unlock(&thermal_list_lock);
>>>
>>>         return ref;
>>> }
>>>
>>> Thanks.
>>> Wei.
>>>> +	if (IS_ERR(tzd))
>>>> +		return ERR_PTR(-EPROBE_DEFER);
>>>> +
>>>> +	tz = tzd->devdata;
>>>> +
>>>> +	mutex_lock(&tzd->lock);
>>>> +	tz->get_temp = get_temp;
>>>> +	tz->get_trend = get_trend;
>>>> +	tz->sensor_data = data;
>>>> +
>>>> +	tzd->ops->get_temp = of_thermal_get_temp;
>>>> +	tzd->ops->get_trend = of_thermal_get_trend;
>>>> +	mutex_unlock(&tzd->lock);
>>>> +
>>>> +	return tzd;
>>>> +}
>>>> +
>>>>
>>>
>>
>>
>>
> 
> 

