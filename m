Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3DLLQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:16:12 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33298 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3DLLQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <51672183.3030109@ti.com>
References: <1364297642-2746-6-git-send-email-amit.daniel@samsung.com>
	<51672183.3030109@ti.com>
Date: Fri, 12 Apr 2013 16:46:09 +0530
X-Google-Sender-Auth: IJN4ztLBiC4e9Tx671iCp3MlQPA
Message-ID: <CADGdYn4aAoPWSA94R+io5GEzD9i-pA5JMBg_SqXMb3K4c+FqNg@mail.gmail.com>
Subject: Re: [5/9] thermal: exynos: Make the zone handling dependent on trip count
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Fri, Apr 12, 2013 at 2:18 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 26-03-2013 07:33, Amit Daniel Kachhap wrote:
>>
>> This code changes the zone handling to use the trip count passed
>> by the TMU driver. This also helps in adding more zone support.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> ---
>> drivers/thermal/samsung/exynos_common.c      |   56
>> +++++++++++++------------
>>   drivers/thermal/samsung/exynos_common.h      |   13 +++---
>>   include/linux/platform_data/exynos_thermal.h |    7 ++-
>>   3 files changed, 40 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_common.c
>> b/drivers/thermal/samsung/exynos_common.c
>> index 649d67c..0c0098d 100644
>> --- a/drivers/thermal/samsung/exynos_common.c
>> +++ b/drivers/thermal/samsung/exynos_common.c
>> @@ -84,17 +84,16 @@ static int exynos_set_mode(struct thermal_zone_device
>> *thermal,
>>   static int exynos_get_trip_type(struct thermal_zone_device *thermal, int
>> trip,
>>                                  enum thermal_trip_type *type)
>>   {
>> -       switch (GET_ZONE(trip)) {
>> -       case MONITOR_ZONE:
>> -       case WARN_ZONE:
>> -               *type = THERMAL_TRIP_ACTIVE;
>> -               break;
>> -       case PANIC_ZONE:
>> -               *type = THERMAL_TRIP_CRITICAL;
>> -               break;
>> -       default:
>> +       struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +       int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>> +
>> +       if (trip < 0 || trip >= max_trip)
>>                 return -EINVAL;
>> -       }
>> +       else if (trip == (max_trip - 1))
>> +               *type = THERMAL_TRIP_CRITICAL;
>> +       else
>> +               *type = THERMAL_TRIP_ACTIVE;
>> +
>>         return 0;
>>   }
>>
>> @@ -103,8 +102,9 @@ static int exynos_get_trip_temp(struct
>> thermal_zone_device *thermal, int trip,
>>                                 unsigned long *temp)
>>   {
>>         struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +       int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>>
>> -       if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
>> +       if (trip < 0 || trip >= max_trip)
>>                 return -EINVAL;
>>
>>         *temp = th_zone->sensor_conf->trip_data.trip_val[trip];
>> @@ -118,10 +118,10 @@ static int exynos_get_trip_temp(struct
>> thermal_zone_device *thermal, int trip,
>>   static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>>                                 unsigned long *temp)
>>   {
>> -       int ret;
>> -       /* Panic zone */
>> -       ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
>> -       return ret;
>> +       struct exynos_thermal_zone *th_zone = thermal->devdata;
>> +       int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>> +       /* Get the temp of highest trip*/
>> +       return exynos_get_trip_temp(thermal, max_trip - 1, temp);
>>   }
>>
>>   int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>> @@ -157,7 +157,7 @@ static int exynos_bind(struct thermal_zone_device
>> *thermal,
>>         tab_size = data->cooling_data.freq_clip_count;
>>
>>         if (tab_ptr == NULL || tab_size == 0)
>> -               return -EINVAL;
>> +               return 0;
>>
>>         /* find the cooling device registered*/
>>         for (i = 0; i < th_zone->cool_dev_size; i++)
>> @@ -206,7 +206,7 @@ static int exynos_unbind(struct thermal_zone_device
>> *thermal,
>>         tab_size = data->cooling_data.freq_clip_count;
>>
>>         if (tab_size == 0)
>> -               return -EINVAL;
>> +               return 0;
>>
>>         /* find the cooling device registered*/
>>         for (i = 0; i < th_zone->cool_dev_size; i++)
>
>
> The above two chunks are confusing. I dont understand how they are now
> supposed to be valid settings.
Well it is made valid when there is no cooling table registered and
hence no cooling.
>
>
>> @@ -366,19 +366,21 @@ int exynos_register_thermal(struct
>> thermal_sensor_conf *sensor_conf)
>>                 return -ENOMEM;
>>
>>         th_zone->sensor_conf = sensor_conf;
>> -       cpumask_set_cpu(0, &mask_val);
>> -       th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
>> -       if (IS_ERR(th_zone->cool_dev[0])) {
>> -               pr_err("Failed to register cpufreq cooling device\n");
>> -               ret = -EINVAL;
>> -               goto err_unregister;
>> +       if (sensor_conf->cooling_data.freq_clip_count > 0) {
>> +               cpumask_set_cpu(0, &mask_val);
>> +               th_zone->cool_dev[0] =
>> cpufreq_cooling_register(&mask_val);
>> +               if (IS_ERR(th_zone->cool_dev[0])) {
>> +                       pr_err("Failed to register cpufreq cooling
>> device\n");
>> +                       ret = -EINVAL;
>> +                       goto err_unregister;
>> +               }
>> +               th_zone->cool_dev_size++;
>>         }
>> -       th_zone->cool_dev_size++;
>>
>>         th_zone->therm_dev =
>> thermal_zone_device_register(sensor_conf->name,
>> -                       EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops,
>> NULL, 0,
>> -                       sensor_conf->trip_data.trigger_falling ?
>> -                       0 : IDLE_INTERVAL);
>> +               sensor_conf->trip_data.trip_count, 0, th_zone,
>> &exynos_dev_ops,
>> +               NULL, 0, sensor_conf->trip_data.trigger_falling ?
>> +               0 : IDLE_INTERVAL);
>>
>>         if (IS_ERR(th_zone->therm_dev)) {
>>                 pr_err("Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/samsung/exynos_common.h
>> b/drivers/thermal/samsung/exynos_common.h
>> index b8d289e..453e09a 100644
>> --- a/drivers/thermal/samsung/exynos_common.h
>> +++ b/drivers/thermal/samsung/exynos_common.h
>> @@ -27,23 +27,22 @@
>>   #define SENSOR_NAME_LEN       16
>>   #define MAX_TRIP_COUNT        8
>>   #define MAX_COOLING_DEVICE 4
>> -#define MAX_THRESHOLD_LEVS 4
>> +#define MAX_THRESHOLD_LEVS 5
>>
>>   #define ACTIVE_INTERVAL 500
>>   #define IDLE_INTERVAL 10000
>>   #define MCELSIUS      1000
>>
>>   /* CPU Zone information */
>> -#define PANIC_ZONE      4
>> -#define WARN_ZONE       3
>> -#define MONITOR_ZONE    2
>> -#define SAFE_ZONE       1
>> +#define PANIC_ZONE     5
>> +#define ALARM_ZONE     4
>> +#define WARN_ZONE      3
>> +#define MONITOR_ZONE   2
>> +#define SAFE_ZONE      1
>>
>
>
> Updating this does not seam to be part of the intent of this patch. You
> probably want to send a separate patch for this.
yes right.
>
>
>>   #define GET_ZONE(trip) (trip + 2)
>>   #define GET_TRIP(zone) (zone - 2)
>>
>> -#define EXYNOS_ZONE_COUNT      3
>> -
>>   struct        thermal_trip_point_conf {
>>         int trip_val[MAX_TRIP_COUNT];
>>         int trip_count;
>> diff --git a/include/linux/platform_data/exynos_thermal.h
>> b/include/linux/platform_data/exynos_thermal.h
>> index da7e627..893b758 100644
>> --- a/include/linux/platform_data/exynos_thermal.h
>> +++ b/include/linux/platform_data/exynos_thermal.h
>> @@ -23,6 +23,8 @@
>>   #define _LINUX_EXYNOS_THERMAL_H
>>   #include <linux/cpu_cooling.h>
>>
>> +#define MAX_TRIP       5
>> +
>
>
>
> Should MAX_TRIP/THRESHOLD_LEVEL/PANIC_ZONE be somewhat same
Yes they can be removed.
>
>
>>   enum calibration_type {
>>         TYPE_ONE_POINT_TRIMMING,
>>         TYPE_TWO_POINT_TRIMMING,
>> @@ -100,11 +102,12 @@ struct freq_clip_table {
>>   struct exynos_tmu_platform_data {
>>         u8 threshold;
>>         u8 threshold_falling;
>> -       u8 trigger_levels[4];
>> +       u8 trigger_levels[MAX_TRIP];
>>         bool trigger_level0_en;
>>         bool trigger_level1_en;
>>         bool trigger_level2_en;
>>         bool trigger_level3_en;
>> +       bool trigger_level4_en;
>>
>>         u8 gain;
>>         u8 reference_voltage;
>> @@ -113,7 +116,7 @@ struct exynos_tmu_platform_data {
>>
>>         enum calibration_type cal_type;
>>         enum soc_type type;
>> -       struct freq_clip_table freq_tab[4];
>> +       struct freq_clip_table freq_tab[MAX_TRIP];
>>         unsigned int freq_tab_count;
>>   };
>>   #endif /* _LINUX_EXYNOS_THERMAL_H */
>>
>
