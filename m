Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3CYLZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:25:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48165 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab3CYLZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:25:41 -0400
Message-ID: <51503428.2060807@ti.com>
Date: Mon, 25 Mar 2013 07:25:28 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] thermal: introduce thermal_zone_lookup_temperature
 helper function
References: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>  <1363986787-28147-2-git-send-email-eduardo.valentin@ti.com>  <1364191837.2465.7.camel@rzhang1-mobl4>  <4D68720C2E767A4AA6A8796D42C8EB59C57DBF@BGSMSX101.gar.corp.intel.com> <1364192766.2465.21.camel@rzhang1-mobl4>
In-Reply-To: <1364192766.2465.21.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-03-2013 02:26, Zhang Rui wrote:
> On Mon, 2013-03-25 at 00:20 -0600, R, Durgadoss wrote:
>>> -----Original Message-----
>>> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
>>> owner@vger.kernel.org] On Behalf Of Zhang Rui
>>> Sent: Monday, March 25, 2013 11:41 AM
>>> To: Eduardo Valentin
>>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Subject: Re: [PATCH 1/2] thermal: introduce
>>> thermal_zone_lookup_temperature helper function
>>>
>>> On Fri, 2013-03-22 at 17:13 -0400, Eduardo Valentin wrote:
>>>> This patch adds a helper function to get temperature of
>>>> a thermal zone, based on the zone type name.
>>>>
>>>> It will perform a zone name lookup and return the last
>>>> sensor temperature reading. In case the zone is not found
>>>> or if the required parameters are invalid, it will return
>>>> the corresponding error code.
>>>>
>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>> ---
>>>>   drivers/thermal/thermal_sys.c |   32
>>> ++++++++++++++++++++++++++++++++
>>>>   include/linux/thermal.h       |    1 +
>>>>   2 files changed, 33 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>>>> index 5bd95d4..f0caa13 100644
>>>> --- a/drivers/thermal/thermal_sys.c
>>>> +++ b/drivers/thermal/thermal_sys.c
>>>> @@ -1790,6 +1790,38 @@ void thermal_zone_device_unregister(struct
>>> thermal_zone_device *tz)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
>>>>
>>>> +/**
>>>> + * thermal_lookup_temperature - search for a zone and returns its
>>> temperature
>>>> + * @name: thermal zone name to fetch the temperature
>>>> + * @temperature: pointer to store the zone temperature, in case it is
>>> found
>>>> + *
>>>> + * When the zone is found, updates @temperature and returns 0.
>>>> + *
>>>> + * Return: -EINVAL in case of wrong parameters, -ENODEV in case the
>>> zone
>>>> + * is not found and 0 when it is successfully found.
>>>> + */
>>>> +int thermal_zone_lookup_temperature(const char *name, int
>>> *temperature)
>>>> +{
>>>> +	struct thermal_zone_device *pos = NULL;
>>>> +	bool found = false;
>>>> +
>>>> +	if (!name || !temperature)
>>>> +		return -EINVAL;
>>>> +
>>>> +	mutex_lock(&thermal_list_lock);
>>>> +	list_for_each_entry(pos, &thermal_tz_list, node)
>>>> +		if (!strcmp(pos->type, name)) {
>>>> +			found = true;
>>>> +			break;
>>>> +		}
>>>> +	if (found)
>>>> +		*temperature = pos->last_temperature;
>>>> +	mutex_unlock(&thermal_list_lock);
>>>> +
>>>> +	return found ? 0 : -ENODEV;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(thermal_zone_lookup_temperature);
>>>> +
>>> please do not use thermal zone type as the parameter because unique
>>> thermal zone type string is not a hard rule.

OK. I didn't consider this, as I was just resending the patch and the FW 
has evolve since last time I sent it.

>>
>> Okay, agree with this. This is what I am implementing in
>> my changes as well.
>>
>>> If this is really needed, I'd prefer two APIs instead
>>> 1. struct thermal_zone_device * thermal_zone_get_zone_by_name(char
>>> *name);
>>> 2. int thermal_zone_get_temperature(struct thermal_zone_device *, int
>>> *temperature);
>>
>> Why do we need this second API?
>> If the driver has a 'tz' pointer, it can use tz->ops->get_temp
>> to retrieve the temperature, right ?
>>
>
> probably it is because one driver want to get the temperature of a
> sensor registered by another driver.

Unless API 1. can be used on other cases, why do we need two APIs? Why 
not keep the same signature I proposed, but with the same care on 'type' 
you mentioned for 1.?

>
> thanks,
> rui
>
>
>

