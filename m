Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966477Ab3DQTMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:12:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58968 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab3DQTMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:12:23 -0400
Message-ID: <516EF40E.5020007@ti.com>
Date: Wed, 17 Apr 2013 15:12:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <durgadoss.r@intel.com>
Subject: Re: [PATCHv3 1/3] thermal: introduce thermal_zone_get_zone_by_name
 helper function
References: <1365165150-11720-1-git-send-email-eduardo.valentin@ti.com>  <1365165150-11720-2-git-send-email-eduardo.valentin@ti.com> <1365990196.2803.2.camel@rzhang1-mobl4> <516BFEBF.4040204@ti.com>
In-Reply-To: <516BFEBF.4040204@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-04-2013 09:21, Eduardo Valentin wrote:
> On 14-04-2013 21:43, Zhang Rui wrote:
>> On Fri, 2013-04-05 at 08:32 -0400, Eduardo Valentin wrote:
>>> This patch adds a helper function to get a reference of
>>> a thermal zone, based on the zone type name.
>>>
>>> It will perform a zone name lookup and return a reference
>>> to a thermal zone device that matches the name requested.
>>> In case the zone is not found or when several zones match
>>> same name or if the required parameters are invalid, it will return
>>> the corresponding error code (ERR_PTR).
>>>
>>> Cc: Durgadoss R <durgadoss.r@intel.com>
>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>
>> refreshed the patch to modify drivers/thermal/thermal_core.c instead of
>> drivers/thermal/thermal_sys.c and applied to thermal -next.
>
> Thanks.



Just a gentle reminder, this one does not seam to be applied to 
thermal/next.

>
>>
>> thanks,
>> rui
>>> ---
>>>   drivers/thermal/thermal_sys.c |   38
>>> ++++++++++++++++++++++++++++++++++++++
>>>   include/linux/thermal.h       |    1 +
>>>   2 files changed, 39 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/thermal/thermal_sys.c
>>> b/drivers/thermal/thermal_sys.c
>>> index 5bd95d4..e9b636b 100644
>>> --- a/drivers/thermal/thermal_sys.c
>>> +++ b/drivers/thermal/thermal_sys.c
>>> @@ -1790,6 +1790,44 @@ void thermal_zone_device_unregister(struct
>>> thermal_zone_device *tz)
>>>   }
>>>   EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
>>>
>>> +/**
>>> + * thermal_zone_get_zone_by_name() - search for a zone and returns
>>> its ref
>>> + * @name: thermal zone name to fetch the temperature
>>> + *
>>> + * When only one zone is found with the passed name, returns a
>>> reference to it.
>>> + *
>>> + * Return: On success returns a reference to an unique thermal zone
>>> with
>>> + * matching name equals to @name, an ERR_PTR otherwise (-EINVAL for
>>> invalid
>>> + * paramenters, -ENODEV for not found and -EEXIST for multiple
>>> matches).
>>> + */
>>> +struct thermal_zone_device *thermal_zone_get_zone_by_name(const char
>>> *name)
>>> +{
>>> +    struct thermal_zone_device *pos = NULL, *ref = ERR_PTR(-EINVAL);
>>> +    unsigned int found = 0;
>>> +
>>> +    if (!name)
>>> +        goto exit;
>>> +
>>> +    mutex_lock(&thermal_list_lock);
>>> +    list_for_each_entry(pos, &thermal_tz_list, node)
>>> +        if (!strnicmp(name, pos->type, THERMAL_NAME_LENGTH)) {
>>> +            found++;
>>> +            ref = pos;
>>> +        }
>>> +    mutex_unlock(&thermal_list_lock);
>>> +
>>> +    /* nothing has been found, thus an error code for it */
>>> +    if (found == 0)
>>> +        ref = ERR_PTR(-ENODEV);
>>> +    else if (found > 1)
>>> +    /* Success only when an unique zone is found */
>>> +        ref = ERR_PTR(-EEXIST);
>>> +
>>> +exit:
>>> +    return ref;
>>> +}
>>> +EXPORT_SYMBOL_GPL(thermal_zone_get_zone_by_name);
>>> +
>>>   #ifdef CONFIG_NET
>>>   static struct genl_family thermal_event_genl_family = {
>>>       .id = GENL_ID_GENERATE,
>>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>>> index 542a39c..0cf9eb5 100644
>>> --- a/include/linux/thermal.h
>>> +++ b/include/linux/thermal.h
>>> @@ -237,6 +237,7 @@ void thermal_zone_device_update(struct
>>> thermal_zone_device *);
>>>   struct thermal_cooling_device *thermal_cooling_device_register(char
>>> *, void *,
>>>           const struct thermal_cooling_device_ops *);
>>>   void thermal_cooling_device_unregister(struct
>>> thermal_cooling_device *);
>>> +struct thermal_zone_device *thermal_zone_get_zone_by_name(const char
>>> *name);
>>>
>>>   int thermal_zone_trend_get(struct thermal_zone_device *, int);
>>>   struct thermal_instance *thermal_instance_get(struct
>>> thermal_zone_device *,
>>
>>
>>
>>
>
>
>

