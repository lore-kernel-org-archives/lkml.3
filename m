Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3DONWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:22:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39102 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3DONWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:22:09 -0400
Message-ID: <516BFEFB.1080405@ti.com>
Date: Mon, 15 Apr 2013 09:22:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <durgadoss.r@intel.com>
Subject: Re: [PATCHv3 2/3] thermal: expose thermal_zone_get_temp API
References: <1365165150-11720-1-git-send-email-eduardo.valentin@ti.com>  <1365165150-11720-3-git-send-email-eduardo.valentin@ti.com> <1365990234.2803.3.camel@rzhang1-mobl4>
In-Reply-To: <1365990234.2803.3.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-2013 21:43, Zhang Rui wrote:
> On Fri, 2013-04-05 at 08:32 -0400, Eduardo Valentin wrote:
>> This patch exports the thermal_zone_get_temp API so that driver
>> writers can fetch temperature of thermal zones managed by other
>> drivers.
>>
>> Acked-by: Durgadoss R <durgadoss.r@intel.com>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>
> refreshed the patch to modify drivers/thermal/thermal_core.c instead of
> drivers/thermal/thermal_sys.c and applied to thermal -next.

Thanks!

>
> thanks,
> rui
>
>> ---
>>   drivers/thermal/thermal_sys.c |   20 +++++++++++++++++---
>>   include/linux/thermal.h       |    1 +
>>   2 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>> index e9b636b..83bfa0d 100644
>> --- a/drivers/thermal/thermal_sys.c
>> +++ b/drivers/thermal/thermal_sys.c
>> @@ -371,16 +371,28 @@ static void handle_thermal_trip(struct thermal_zone_device *tz, int trip)
>>   	monitor_thermal_zone(tz);
>>   }
>>
>> -static int thermal_zone_get_temp(struct thermal_zone_device *tz,
>> -				unsigned long *temp)
>> +/**
>> + * thermal_zone_get_temp() - returns its the temperature of thermal zone
>> + * @tz: a valid pointer to a struct thermal_zone_device
>> + * @temp: a valid pointer to where to store the resulting temperature.
>> + *
>> + * When a valid thermal zone reference is passed, it will fetch its
>> + * temperature and fill @temp.
>> + *
>> + * Return: On success returns 0, an error code otherwise
>> + */
>> +int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp)
>>   {
>> -	int ret = 0;
>> +	int ret = -EINVAL;
>>   #ifdef CONFIG_THERMAL_EMULATION
>>   	int count;
>>   	unsigned long crit_temp = -1UL;
>>   	enum thermal_trip_type type;
>>   #endif
>>
>> +	if (IS_ERR_OR_NULL(tz))
>> +		goto exit;
>> +
>>   	mutex_lock(&tz->lock);
>>
>>   	ret = tz->ops->get_temp(tz, temp);
>> @@ -404,8 +416,10 @@ static int thermal_zone_get_temp(struct thermal_zone_device *tz,
>>   skip_emul:
>>   #endif
>>   	mutex_unlock(&tz->lock);
>> +exit:
>>   	return ret;
>>   }
>> +EXPORT_SYMBOL_GPL(thermal_zone_get_temp);
>>
>>   static void update_temperature(struct thermal_zone_device *tz)
>>   {
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index 0cf9eb5..8eea86c 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -238,6 +238,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
>>   		const struct thermal_cooling_device_ops *);
>>   void thermal_cooling_device_unregister(struct thermal_cooling_device *);
>>   struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
>> +int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
>>
>>   int thermal_zone_trend_get(struct thermal_zone_device *, int);
>>   struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
>
>
>
>

