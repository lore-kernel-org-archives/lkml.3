Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaHANPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:15:43 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43752 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaHANPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <53DB7D0D.1070508@nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
	<1403856699-2140-2-git-send-email-mperttunen@nvidia.com>
	<20140730141639.GA3715@developer>
	<53DB7D0D.1070508@nvidia.com>
Date: Fri, 1 Aug 2014 09:15:39 -0400
Message-ID: <CAC-25o-9WNyWWuSWw4mUrKkBzSvPYKG1NWs5Mtb0q3AjGo6wfw@mail.gmail.com>
Subject: Re: [PATCH 1/6] thermal: of: Add support for hardware-tracked trip points
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moro,

On Fri, Aug 1, 2014 at 7:42 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
> Moi Eduardo :)
>
>
> On 30/07/14 17:16, Eduardo Valentin wrote:
>>
>> Terve Mikko,
>>
>> On Fri, Jun 27, 2014 at 11:11:34AM +0300, Mikko Perttunen wrote:
>>>
>>> This adds support for hardware-tracked trip points to the device tree
>>> thermal sensor framework.
>>>
>>> The framework supports an arbitrary number of trip points. Whenever
>>> the current temperature is updated, the trip points immediately
>>> below and above the current temperature are found. A sensor driver
>>
>>
>> One thing I don't follow on your proposal is the groundings you need to
>> 'set_trips' whenever temperature changes. Given your intention is to add
>> support to interrupt driven devices, shouldn't we 'set_trips' just when
>> we cross the previously set trips range?
>
>
> I think the reasoning for this was that I didn't want to make changes to
> thermal_core and thermal_zone_device_update only calls get_temp on the zone,
> so I had to add this code to get_temp. set_trips would anyway only be called
> if we had crossed a trip point.
>
>

I see.

>>
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
>>
>> As already mentioned by swarren, the proposal must be wider. We shall
>> keep the same support in case the device is used in a system without
>> device tree. In other words, if you want to see extra functionality for
>> interrupt driven devices, you shall update the core part too, and draft
>> a common messaging path.
>
>
> Yeah, this is sensible. A simpler solution would be to just tell of-thermal
> drivers about the trip points and let the driver do whatever it wants. That
> would mirror the way normal thermal_core drivers are done. What is your
> opinion on that?
>
>

In fact, with the current implementation in the thermal framework,
there is nothing else left than coding the feature in the driver
itself. The framework would know only about the existance of the
trips. This approach would need to be cleaned whenever we write the
fix in the core though.

For this reason, I would prefer to clean the core first, then write
the driver as a proof that the changes in core are properly covering
the existing drivers and interrupt driven drivers.

>>
>> In general, interrupt driven devices are not mapped in the current
>> thermal framework. That is, the current code is timer interrupt driven.
>> Other interrupt updates from devices are propagated to
>> the framework using thermal_zone_device_update(). In other words, you
>> would
>> reprogram your hardware trips from your interrupt handler/workqueue then
>> just let the framework know what is going on with temperature, via a
>> simple
>> thermal_zone_device_update().
>>
>> The way I see this going forward it would be a common interface to
>> configure the thermal zones to be monitored:
>> a. via polling only
>> b. via interrupt only
>> c. both a + b
>>
>> obviously, the above shall be informative only for userland.
>>
>> keep in mind also that changing interrupt configuration for high and low
>> temperature thresholds can be racy.
>>
>> This feature was kept in the TODO list of the of-thermal.c because the
>> we lack a proper support from the thermal framework (never came out of
>> the TODO list, I know, I apologize for this). And this missing feature
>> was spotted by the hwmon folks also, as they do have such support. So,
>> the major missing improvements on interrupt driven devices shall come in
>> three steps: (i) thermal framework, (ii) of-thermal (iii) thermal
>> framework and hwmon interface.
>
>
> For now, I think I'll submit a driver with just polling support so that we
> can get some support in.


I see. I will be looking into the changes in core. Whenever I have a
working RFC I will share with the list.

Terveydeksi!,

>
>>
>>
>> Cheers,
>>
>>
>
> Thanks, Mikko
>
>
>>>
>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>> ---
>>>   drivers/thermal/of-thermal.c | 97
>>> ++++++++++++++++++++++++++++++++++++++++++--
>>>   include/linux/thermal.h      |  3 +-
>>>   2 files changed, 95 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
>>> index 04b1be7..bfccea5 100644
>>> --- a/drivers/thermal/of-thermal.c
>>> +++ b/drivers/thermal/of-thermal.c
>>> @@ -89,6 +89,7 @@ struct __thermal_zone {
>>>        /* trip data */
>>>        int ntrips;
>>>        struct __thermal_trip *trips;
>>> +     long prev_low_trip, prev_high_trip;
>>>
>>>        /* cooling binding data */
>>>        int num_tbps;
>>> @@ -98,19 +99,66 @@ struct __thermal_zone {
>>>        void *sensor_data;
>>>        int (*get_temp)(void *, long *);
>>>        int (*get_trend)(void *, long *);
>>> +     int (*set_trips)(void *, long, long);
>>>   };
>>>
>>> +/***   Automatic trip handling   ***/
>>> +
>>> +static int of_thermal_set_trips(struct thermal_zone_device *tz, long
>>> temp)
>>> +{
>>> +     struct __thermal_zone *data = tz->devdata;
>>> +     long low = LONG_MIN, high = LONG_MAX;
>>> +     int i;
>>> +
>>> +     /* Hardware trip points not supported */
>>> +     if (!data->set_trips)
>>> +             return 0;
>>> +
>>> +     /* No need to change trip points */
>>> +     if (temp > data->prev_low_trip && temp < data->prev_high_trip)
>>> +             return 0;
>>> +
>>> +     for (i = 0; i < data->ntrips; ++i) {
>>> +             struct __thermal_trip *trip = data->trips + i;
>>> +             long trip_low = trip->temperature - trip->hysteresis;
>>> +
>>> +             if (trip_low < temp && trip_low > low)
>>> +                     low = trip_low;
>>> +
>>> +             if (trip->temperature > temp && trip->temperature < high)
>>> +                     high = trip->temperature;
>>> +     }
>>> +
>>> +     dev_dbg(&tz->device,
>>> +             "temperature %ld, updating trip points to %ld, %ld\n",
>>> +             temp, low, high);
>>> +
>>> +     data->prev_low_trip = low;
>>> +     data->prev_high_trip = high;
>>> +
>>> +     return data->set_trips(data->sensor_data, low, high);
>>> +}
>>> +
>>>   /***   DT thermal zone device callbacks   ***/
>>>
>>>   static int of_thermal_get_temp(struct thermal_zone_device *tz,
>>>                               unsigned long *temp)
>>>   {
>>>        struct __thermal_zone *data = tz->devdata;
>>> +     int err;
>>>
>>>        if (!data->get_temp)
>>>                return -EINVAL;
>>>
>>> -     return data->get_temp(data->sensor_data, temp);
>>> +     err = data->get_temp(data->sensor_data, temp);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     err = of_thermal_set_trips(tz, *temp);
>>
>>
>> Here, if you update trips whenever you get_temp, you are possibly
>> reprogramming your trips on every poll. Remember, this function will be
>> called on every poll, in the current implementation.
>>
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     return 0;
>>>   }
>>>
>>>   static int of_thermal_get_trend(struct thermal_zone_device *tz, int
>>> trip,
>>> @@ -222,6 +270,22 @@ static int of_thermal_set_mode(struct
>>> thermal_zone_device *tz,
>>>        return 0;
>>>   }
>>>
>>> +static int of_thermal_update_trips(struct thermal_zone_device *tz)
>>> +{
>>> +     long temp;
>>> +     int err;
>>> +
>>> +     err = of_thermal_get_temp(tz, &temp);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     err = of_thermal_set_trips(tz, temp);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>>   static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int
>>> trip,
>>>                                    enum thermal_trip_type *type)
>>>   {
>>> @@ -252,6 +316,7 @@ static int of_thermal_set_trip_temp(struct
>>> thermal_zone_device *tz, int trip,
>>>                                    unsigned long temp)
>>>   {
>>>        struct __thermal_zone *data = tz->devdata;
>>> +     int err;
>>>
>>>        if (trip >= data->ntrips || trip < 0)
>>>                return -EDOM;
>>> @@ -259,6 +324,10 @@ static int of_thermal_set_trip_temp(struct
>>> thermal_zone_device *tz, int trip,
>>>        /* thermal framework should take care of data->mask & (1 << trip)
>>> */
>>>        data->trips[trip].temperature = temp;
>>>
>>> +     err = of_thermal_update_trips(tz);
>>> +     if (err)
>>> +             return err;
>>> +
>>>        return 0;
>>>   }
>>>
>>> @@ -279,6 +348,7 @@ static int of_thermal_set_trip_hyst(struct
>>> thermal_zone_device *tz, int trip,
>>>                                    unsigned long hyst)
>>>   {
>>>        struct __thermal_zone *data = tz->devdata;
>>> +     int err;
>>>
>>>        if (trip >= data->ntrips || trip < 0)
>>>                return -EDOM;
>>> @@ -286,6 +356,10 @@ static int of_thermal_set_trip_hyst(struct
>>> thermal_zone_device *tz, int trip,
>>>        /* thermal framework should take care of data->mask & (1 << trip)
>>> */
>>>        data->trips[trip].hysteresis = hyst;
>>>
>>> +     err = of_thermal_update_trips(tz);
>>> +     if (err)
>>> +             return err;
>>> +
>>>        return 0;
>>>   }
>>>
>>> @@ -325,10 +399,12 @@ static struct thermal_zone_device *
>>>   thermal_zone_of_add_sensor(struct device_node *zone,
>>>                           struct device_node *sensor, void *data,
>>>                           int (*get_temp)(void *, long *),
>>> -                        int (*get_trend)(void *, long *))
>>> +                        int (*get_trend)(void *, long *),
>>> +                        int (*set_trips)(void *, long, long))
>>
>>
>> we need to clean the above arguments. they should become a .ops.
>>
>>>   {
>>>        struct thermal_zone_device *tzd;
>>>        struct __thermal_zone *tz;
>>> +     int err;
>>>
>>>        tzd = thermal_zone_get_zone_by_name(zone->name);
>>>        if (IS_ERR(tzd))
>>> @@ -339,8 +415,15 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>>>        mutex_lock(&tzd->lock);
>>>        tz->get_temp = get_temp;
>>>        tz->get_trend = get_trend;
>>> +     tz->set_trips = set_trips;
>>>        tz->sensor_data = data;
>>>
>>> +     err = of_thermal_update_trips(tzd);
>>> +     if (err) {
>>> +             mutex_unlock(&tzd->lock);
>>> +             return ERR_PTR(err);
>>> +     }
>>> +
>>>        tzd->ops->get_temp = of_thermal_get_temp;
>>>        tzd->ops->get_trend = of_thermal_get_trend;
>>>        mutex_unlock(&tzd->lock);
>>> @@ -384,7 +467,8 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>>>   struct thermal_zone_device *
>>>   thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>>>                                void *data, int (*get_temp)(void *, long
>>> *),
>>> -                             int (*get_trend)(void *, long *))
>>> +                             int (*get_trend)(void *, long *),
>>> +                             int (*set_trips)(void *, long, long))
>>
>>
>> ditto.
>>
>>>   {
>>>        struct device_node *np, *child, *sensor_np;
>>>
>>> @@ -422,7 +506,8 @@ thermal_zone_of_sensor_register(struct device *dev,
>>> int sensor_id,
>>>                        return thermal_zone_of_add_sensor(child,
>>> sensor_np,
>>>                                                          data,
>>>                                                          get_temp,
>>> -                                                       get_trend);
>>> +                                                       get_trend,
>>> +                                                       set_trips);
>>
>>
>> ditto.
>>
>>>                }
>>>        }
>>>        of_node_put(np);
>>> @@ -466,6 +551,7 @@ void thermal_zone_of_sensor_unregister(struct device
>>> *dev,
>>>
>>>        tz->get_temp = NULL;
>>>        tz->get_trend = NULL;
>>> +     tz->set_trips = NULL;
>>>        tz->sensor_data = NULL;
>>>        mutex_unlock(&tzd->lock);
>>>   }
>>> @@ -671,6 +757,9 @@ thermal_of_build_thermal_zone(struct device_node *np)
>>>        /* trips */
>>>        child = of_get_child_by_name(np, "trips");
>>>
>>> +     tz->prev_high_trip = LONG_MIN;
>>> +     tz->prev_low_trip = LONG_MAX;
>>> +
>>>        /* No trips provided */
>>>        if (!child)
>>>                goto finish;
>>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>>> index f7e11c7..2f8951c 100644
>>> --- a/include/linux/thermal.h
>>> +++ b/include/linux/thermal.h
>>> @@ -248,7 +248,8 @@ struct thermal_genl_event {
>>>   struct thermal_zone_device *
>>>   thermal_zone_of_sensor_register(struct device *dev, int id,
>>>                                void *data, int (*get_temp)(void *, long
>>> *),
>>> -                             int (*get_trend)(void *, long *));
>>> +                             int (*get_trend)(void *, long *),
>>> +                             int (*set_trips)(void *, long, long));
>>>   void thermal_zone_of_sensor_unregister(struct device *dev,
>>>                                       struct thermal_zone_device *tz);
>>>   #else
>>> --
>>> 1.8.1.5
>>>
>>
>



-- 
Eduardo Bezerra Valentin
