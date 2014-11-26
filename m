Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaKZUm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:42:58 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6720 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZUmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:42:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 26 Nov 2014 12:41:31 -0800
Message-ID: <54763B66.90208@nvidia.com>
Date: Wed, 26 Nov 2014 12:43:18 -0800
From: navneet kumar <navneetk@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: Re: [PATCH v2 3/4] thermal: of: Extend of-thermal to export table
 of trip points
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com> <1416500488-7232-1-git-send-email-l.majewski@samsung.com> <1416500488-7232-4-git-send-email-l.majewski@samsung.com> <20141125203629.GA14292@developer> <20141126093510.4233ff7f@amdc2363> <20141126151828.GC3925@developer>
In-Reply-To: <20141126151828.GC3925@developer>
X-Originating-IP: [172.17.185.249]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL104.nvidia.com (172.18.146.11)
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eduardo, Lukasz,

[Combining my concerns as a single text blob here]

I. Firstly, with the current patch
	1. is it really needed to duplicate the struct thermal_trip? Why don’t
	we get rid of the __thermal_trip and stay with the 'thermal_trip' ? it
	is not a big change.

	2. gtrips is not updated on "set_trip_temp" etc. actions via sysfs. (am
	I missing something?).

II. The other concern is more of a design question
	1. Do we intend to keep the of-thermal as a middle layer between the
	thermal_core and the sensor device? OR, is the role of of-thermal just
	to parse the DT and opt out ? currently of-thermal is somewhat a hybrid
	of these as, in addition to parsing the dt, it holds on to the data
	related to trip points etc. etc.

	2. assuming latter is true (OF is just a dt parser helper): we should
	not be adding more intelligence and dependencies linked to the OF.

	3. assuming former is true (OF is a well-defined middle layer): All is
	good till the point OF maintains the trip points (which is a good thing
	since, OF caches on to the data); BUT, if we expose this information to
	the sensor device too (as this patch is doing),

		3a. we violate the layering principle :-)

		3b. more importantly, this is all just excessive logic that we
		put in which *could be useful* only if we intend to extend the
		role of OF as a trip point management layer that does more than
		just holding on to the data. This may include -

			-> The sensor devices to know nothing about the
			trip_points, instead the sensor devices would work on
			"temperature thresholds" and OF would map sensor
			thresholds to the actual trip points as needed
			(configured from DT); while the sensor devices stick to
			using "thresholds".

			-> Queuing from above, sensors, most of the time, only
			need to know a high and a low temp threshold; which
			essentially is a subset of the active/passive etc. trip
			points. Calculation of that based on the current temp,
			as of today is replicated across all the sensor drivers
			and can be hoisted up to the of-thermal.

Seems like this is the opportune time to make a call about the role of of-thermal?

On 11/26/2014 07:18 AM, Eduardo Valentin wrote:
> * PGP Signed by an unknown key
> 
> Hello,
> 
> On Wed, Nov 26, 2014 at 09:35:10AM +0100, Lukasz Majewski wrote:
>> Hi Eduardo,
>>
>>> Hello Lukasz,
>>>
>>> On Thu, Nov 20, 2014 at 05:21:27PM +0100, Lukasz Majewski wrote:
>>>> This patch extends the of-thermal.c to export copy of trip points
>>>> for a given thermal zone.
>>>>
>>>> Thermal drivers should use of_thermal_get_trip_points() method to
>>>> get pointer to table of thermal trip points.
>>>>
>>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>>>> ---
>>>> Changes for v2:
>>>> - New patch - as suggested by Eduardo Valentin
>>>> ---
>>>>  drivers/thermal/of-thermal.c   | 33
>>>> +++++++++++++++++++++++++++++++++ drivers/thermal/thermal_core.h |
>>>> 7 +++++++ include/linux/thermal.h        | 14 ++++++++++++++
>>>>  3 files changed, 54 insertions(+)
>>>>
>>>> diff --git a/drivers/thermal/of-thermal.c
>>>> b/drivers/thermal/of-thermal.c index 336af7f..33921c5 100644
>>>> --- a/drivers/thermal/of-thermal.c
>>>> +++ b/drivers/thermal/of-thermal.c
>>>> @@ -89,6 +89,7 @@ struct __thermal_zone {
>>>>  	/* trip data */
>>>>  	int ntrips;
>>>>  	struct __thermal_trip *trips;
>>>> +	struct thermal_trip *gtrips;
Do we really need this duplication ?
>>>>  
>>>>  	/* cooling binding data */
>>>>  	int num_tbps;
>>>> @@ -152,6 +153,27 @@ bool of_thermal_is_trip_en(struct
>>>> thermal_zone_device *tz, int trip) return true;
>>>>  }
>>>>  
>>>> +/**
>>>> + * of_thermal_get_trip_points - function to get access to a
>>>> globally exported
>>>> + *				trip points
>>>> + *
>>>> + * @tz:	pointer to a thermal zone
>>>> + *
>>>> + * This function provides a pointer to the copy of trip points
>>>> table
>>>> + *
>>>> + * Return: pointer to trip points table, NULL otherwise
>>>> + */
>>>> +const struct thermal_trip * const
>>>> +of_thermal_get_trip_points(struct thermal_zone_device *tz)
>>>> +{
>>>> +	struct __thermal_zone *data = tz->devdata;
>>>> +
>>>> +	if (!data)
>>>> +		return NULL;
>>>> +
>>>> +	return data->gtrips;
>>>> +}
>>>> +
>>>
>>> EXPORT_SYMBOL_GPL(of_thermal_get_trip_points);
>>
>> Ok.
>>
>>>
>>>>  static int of_thermal_get_trend(struct thermal_zone_device *tz,
>>>> int trip, enum thermal_trend *trend)
>>>>  {
>>>> @@ -767,6 +789,16 @@ thermal_of_build_thermal_zone(struct
>>>> device_node *np) goto free_tbps;
>>>>  	}
>>>>  
>>>> +	tz->gtrips = kcalloc(tz->ntrips, sizeof(*tz->gtrips),
>>>> GFP_KERNEL);
>>>> +	if (!tz->gtrips) {
>>>> +		ret = -ENOMEM;
>>>> +		goto free_tbps;
>>>> +	}
>>>> +
>>>> +	for (i = 0; i < tz->ntrips; i++)
>>>> +		memcpy(&(tz->gtrips[i]),
>>>> &(tz->trips[i].temperature),
>>>> +		       sizeof(*tz->gtrips));
>>>> +
>>>>  finish:
>>>>  	of_node_put(child);
>>>>  	tz->mode = THERMAL_DEVICE_DISABLED;
>>>> @@ -793,6 +825,7 @@ static inline void of_thermal_free_zone(struct
>>>> __thermal_zone *tz) {
>>>>  	int i;
>>>>  
>>>> +	kfree(tz->gtrips);
>>>>  	for (i = 0; i < tz->num_tbps; i++)
>>>>  		of_node_put(tz->tbps[i].cooling_device);
>>>>  	kfree(tz->tbps);
Couldn't find the code that updates *gtrips as a result of set_trip_temp via
sysfs.

>>>> diff --git a/drivers/thermal/thermal_core.h
>>>> b/drivers/thermal/thermal_core.h index 466208c..a9580ca 100644
>>>> --- a/drivers/thermal/thermal_core.h
>>>> +++ b/drivers/thermal/thermal_core.h
>>>> @@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
>>>>  void of_thermal_destroy_zones(void);
>>>>  int of_thermal_get_ntrips(struct thermal_zone_device *);
>>>>  bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
>>>> +const struct thermal_trip * const
>>>> +of_thermal_get_trip_points(struct thermal_zone_device *);
>>>>  #else
>>>>  static inline int of_parse_thermal_zones(void) { return 0; }
>>>>  static inline void of_thermal_destroy_zones(void) { }
>>>> @@ -102,6 +104,11 @@ static inline bool
>>>> of_thermal_is_trip_en(struct thermal_zone_device *, int) {
>>>
>>> This produces compilation error when CONFIG_THERMAL_OF is not set.
>>> Name the parameters to fix.
>>
>> As all the other cases, I will fix that.
>>
>>>
>>>>  	return 0;
>>>>  }
>>>> +static inline const struct thermal_trip * const
>>>> +of_thermal_get_trip_points(struct thermal_zone_device *)
>>>> +{
>>>> +	return NULL;
>>>> +}
>>>>  #endif
>>>>  
>>>>  #endif /* __THERMAL_CORE_H__ */
>>>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>>>> index 5bc28a7..88d7249 100644
>>>> --- a/include/linux/thermal.h
>>>> +++ b/include/linux/thermal.h
>>>> @@ -303,6 +303,20 @@ struct thermal_zone_of_device_ops {
>>>>  	int (*get_trend)(void *, long *);
>>>>  };
>>>>  
>>>> +/**
>>>> + * struct thermal_trip - Structure representing themal trip points
>>>> exported from
>>>> + *                       of-thermal
>>>> + *
>>>
>>> The only problem I have with this name is that would look like it is
>>> in use in all thermal framework, which is not really the case. But I
>>> do think having a type here is a good thing. So, not sure :-)
>>
>> It can stay to be struct thermal_trip or we can rename it to
>> struct of_thermal_trip.
>>
>> I'm fine with both names.
> 
> Leave it as 'thermal_trip'.
> 
>>
>>>
>>>> + * @temperature:	trip point temperature
>>>> + * @hysteresis:		trip point hysteresis
>>>> + * @type:		trip point type
>>>> + */
>>>> +struct thermal_trip {
>>>> +	unsigned long int temperature;
>>>> +	unsigned long int hysteresis;
>>>> +	enum thermal_trip_type type;
>>>> +};
>>>> +
>>>>  /* Function declarations */
>>>>  #ifdef CONFIG_THERMAL_OF
>>>>  struct thermal_zone_device *
>>>> -- 
>>>> 2.0.0.rc2
>>>>
>>
>>
>>
>> -- 
>> Best regards,
>>
>> Lukasz Majewski
>>
>> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
> 
> * Unknown Key
> * 0x7DA4E256
> 
