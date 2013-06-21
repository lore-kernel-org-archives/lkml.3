Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161320Ab3FUMa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:30:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39622 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161083Ab3FUMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:30:27 -0400
MIME-Version: 1.0
In-Reply-To: <51C238BA.9070200@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-17-git-send-email-amit.daniel@samsung.com>
	<51C238BA.9070200@ti.com>
Date: Fri, 21 Jun 2013 18:00:27 +0530
X-Google-Sender-Auth: DJ2oIopbfC8y0XqrremiIn9Z8fI
Message-ID: <CADGdYn66wqkJcce=4nThkQtZtgt_SdUz1pzuoWz2qHc0cnmXTQ@mail.gmail.com>
Subject: Re: [PATCH V6 16/30] thermal: exynos: Make the zone handling use trip information
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 20, 2013 at 4:33 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> This code simplifies the zone handling to use the trip information passed
>> by the TMU driver and not the hardcoded macros. This also helps in adding
>> more zone support.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_thermal_common.c |   61 +++++++++++++----------
>>  drivers/thermal/samsung/exynos_thermal_common.h |    3 +-
>>  drivers/thermal/samsung/exynos_tmu.c            |    5 ++-
>>  3 files changed, 40 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
>> index 86d39aa..2873ca3 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.c
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
>> @@ -78,17 +78,22 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
>>  static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
>>                                enum thermal_trip_type *type)
>>  {
>> -     switch (GET_ZONE(trip)) {
>> -     case MONITOR_ZONE:
>> -     case WARN_ZONE:
>> -             *type = THERMAL_TRIP_ACTIVE;
>> -             break;
>> -     case PANIC_ZONE:
>> -             *type = THERMAL_TRIP_CRITICAL;
>> -             break;
>> -     default:
>> +     struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +     int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>> +     int trip_type;
>> +
>> +     if (trip < 0 || trip >= max_trip)
>>               return -EINVAL;
>> -     }
>> +
>> +     trip_type = th_zone->sensor_conf->trip_data.trip_type[trip];
>> +
>> +     if (trip_type == SW_TRIP)
>> +             *type = THERMAL_TRIP_CRITICAL;
>> +     else if (trip_type == THROTTLE_ACTIVE)
>> +             *type = THERMAL_TRIP_ACTIVE;
>> +     else if (trip_type == THROTTLE_PASSIVE)
>> +             *type = THERMAL_TRIP_PASSIVE;
>> +
>>       return 0;
>>  }
>>
>> @@ -97,8 +102,9 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>>                               unsigned long *temp)
>>  {
>>       struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +     int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>>
>> -     if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
>> +     if (trip < 0 || trip >= max_trip)
>>               return -EINVAL;
>>
>>       *temp = th_zone->sensor_conf->trip_data.trip_val[trip];
>> @@ -112,10 +118,10 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>>  static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>>                               unsigned long *temp)
>>  {
>> -     int ret;
>> -     /* Panic zone */
>> -     ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
>> -     return ret;
>> +     struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +     int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>> +     /* Get the temp of highest trip*/
>> +     return exynos_get_trip_temp(thermal, max_trip - 1, temp);
>>  }
>>
>>  /* Bind callback functions for thermal zone */
>> @@ -340,19 +346,22 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>>               return -ENOMEM;
>>
>>       th_zone->sensor_conf = sensor_conf;
>> -     cpumask_set_cpu(0, &mask_val);
>> -     th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
>> -     if (IS_ERR(th_zone->cool_dev[0])) {
>> -             pr_err("Failed to register cpufreq cooling device\n");
>> -             ret = -EINVAL;
>> -             goto err_unregister;
>> +     if (sensor_conf->cooling_data.freq_clip_count > 0) {
>> +             cpumask_set_cpu(0, &mask_val);
>> +             th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
>
> Did you mean th_zone->cool_dev[th_zone->cool_dev_size] ?
Yes.
>
> I think the logic behind the allocation of these cpufreq cooling devices
> needs to be revisited. You always assigned to cool_dev[0], but you
> always iterate the array until cool_dev_size. Remember that
> cool_dev_size now is per th_zone, not global.
I have kept an array of cooling devices to add other type of cooling
devices in the same thermal zone in future. For current use case
although it does not make sense and only one cpufreq cooling device is
present
>
>> +             if (IS_ERR(th_zone->cool_dev[0])) {
>> +                     pr_err("Failed to register cpufreq cooling device\n");
>> +                     ret = -EINVAL;
>> +                     goto err_unregister;
>> +             }
>> +             th_zone->cool_dev_size++;
>>       }
>> -     th_zone->cool_dev_size++;
>>
>> -     th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
>> -                     EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
>> -                     sensor_conf->trip_data.trigger_falling ?
>> -                     0 : IDLE_INTERVAL);
>> +     th_zone->therm_dev = thermal_zone_device_register(
>> +                     sensor_conf->name, sensor_conf->trip_data.trip_count,
>> +                     0, th_zone, &exynos_dev_ops, NULL, 0,
>> +                     sensor_conf->trip_data.trigger_falling ? 0 :
>> +                     IDLE_INTERVAL);
>>
>>       if (IS_ERR(th_zone->therm_dev)) {
>>               pr_err("Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index 1e9a326..dd0077e 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -42,8 +42,6 @@
>>  #define GET_ZONE(trip) (trip + 2)
>>  #define GET_TRIP(zone) (zone - 2)
>>
>> -#define EXYNOS_ZONE_COUNT    3
>> -
>>  enum trigger_type {
>>       THROTTLE_ACTIVE = 1,
>>       THROTTLE_PASSIVE,
>> @@ -68,6 +66,7 @@ struct freq_clip_table {
>>  };
>>  struct       thermal_trip_point_conf {
>>       int trip_val[MAX_TRIP_COUNT];
>> +     int trip_type[MAX_TRIP_COUNT];
>>       int trip_count;
>>       unsigned char trigger_falling;
>>  };
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 40e0cfd..acbd295 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -509,9 +509,12 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>                       pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>>                       pdata->trigger_enable[3];
>>
>> -     for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
>> +     for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++) {
>>               exynos_sensor_conf.trip_data.trip_val[i] =
>>                       pdata->threshold + pdata->trigger_levels[i];
>> +             exynos_sensor_conf.trip_data.trip_type[i] =
>> +                                     pdata->trigger_type[i];
>> +     }
>>
>>       exynos_sensor_conf.trip_data.trigger_falling = pdata->threshold_falling;
>>
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
