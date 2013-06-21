Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab3FUOgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:36:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59011 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161369Ab3FUOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:36:08 -0400
Message-ID: <51C464CD.7070401@ti.com>
Date: Fri, 21 Jun 2013 10:35:57 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 16/30] thermal: exynos: Make the zone handling use
 trip information
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-17-git-send-email-amit.daniel@samsung.com> <51C238BA.9070200@ti.com> <CADGdYn66wqkJcce=4nThkQtZtgt_SdUz1pzuoWz2qHc0cnmXTQ@mail.gmail.com>
In-Reply-To: <CADGdYn66wqkJcce=4nThkQtZtgt_SdUz1pzuoWz2qHc0cnmXTQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2PQCTDHRPQWENXWOEJFJB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2PQCTDHRPQWENXWOEJFJB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21-06-2013 08:30, amit daniel kachhap wrote:
> Hi
>=20
> On Thu, Jun 20, 2013 at 4:33 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>>> This code simplifies the zone handling to use the trip information pa=
ssed
>>> by the TMU driver and not the hardcoded macros. This also helps in ad=
ding
>>> more zone support.
>>>
>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> ---
>>>  drivers/thermal/samsung/exynos_thermal_common.c |   61 +++++++++++++=
----------
>>>  drivers/thermal/samsung/exynos_thermal_common.h |    3 +-
>>>  drivers/thermal/samsung/exynos_tmu.c            |    5 ++-
>>>  3 files changed, 40 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/driver=
s/thermal/samsung/exynos_thermal_common.c
>>> index 86d39aa..2873ca3 100644
>>> --- a/drivers/thermal/samsung/exynos_thermal_common.c
>>> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
>>> @@ -78,17 +78,22 @@ static int exynos_set_mode(struct thermal_zone_de=
vice *thermal,
>>>  static int exynos_get_trip_type(struct thermal_zone_device *thermal,=
 int trip,
>>>                                enum thermal_trip_type *type)
>>>  {
>>> -     switch (GET_ZONE(trip)) {
>>> -     case MONITOR_ZONE:
>>> -     case WARN_ZONE:
>>> -             *type =3D THERMAL_TRIP_ACTIVE;
>>> -             break;
>>> -     case PANIC_ZONE:
>>> -             *type =3D THERMAL_TRIP_CRITICAL;
>>> -             break;
>>> -     default:
>>> +     struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>>> +     int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
>>> +     int trip_type;
>>> +
>>> +     if (trip < 0 || trip >=3D max_trip)
>>>               return -EINVAL;
>>> -     }
>>> +
>>> +     trip_type =3D th_zone->sensor_conf->trip_data.trip_type[trip];
>>> +
>>> +     if (trip_type =3D=3D SW_TRIP)
>>> +             *type =3D THERMAL_TRIP_CRITICAL;
>>> +     else if (trip_type =3D=3D THROTTLE_ACTIVE)
>>> +             *type =3D THERMAL_TRIP_ACTIVE;
>>> +     else if (trip_type =3D=3D THROTTLE_PASSIVE)
>>> +             *type =3D THERMAL_TRIP_PASSIVE;
>>> +
>>>       return 0;
>>>  }
>>>
>>> @@ -97,8 +102,9 @@ static int exynos_get_trip_temp(struct thermal_zon=
e_device *thermal, int trip,
>>>                               unsigned long *temp)
>>>  {
>>>       struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>>> +     int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
>>>
>>> -     if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE=
))
>>> +     if (trip < 0 || trip >=3D max_trip)
>>>               return -EINVAL;
>>>
>>>       *temp =3D th_zone->sensor_conf->trip_data.trip_val[trip];
>>> @@ -112,10 +118,10 @@ static int exynos_get_trip_temp(struct thermal_=
zone_device *thermal, int trip,
>>>  static int exynos_get_crit_temp(struct thermal_zone_device *thermal,=

>>>                               unsigned long *temp)
>>>  {
>>> -     int ret;
>>> -     /* Panic zone */
>>> -     ret =3D exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), tem=
p);
>>> -     return ret;
>>> +     struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>>> +     int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
>>> +     /* Get the temp of highest trip*/
>>> +     return exynos_get_trip_temp(thermal, max_trip - 1, temp);
>>>  }
>>>
>>>  /* Bind callback functions for thermal zone */
>>> @@ -340,19 +346,22 @@ int exynos_register_thermal(struct thermal_sens=
or_conf *sensor_conf)
>>>               return -ENOMEM;
>>>
>>>       th_zone->sensor_conf =3D sensor_conf;
>>> -     cpumask_set_cpu(0, &mask_val);
>>> -     th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask_val);
>>> -     if (IS_ERR(th_zone->cool_dev[0])) {
>>> -             pr_err("Failed to register cpufreq cooling device\n");
>>> -             ret =3D -EINVAL;
>>> -             goto err_unregister;
>>> +     if (sensor_conf->cooling_data.freq_clip_count > 0) {
>>> +             cpumask_set_cpu(0, &mask_val);
>>> +             th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask=
_val);
>>
>> Did you mean th_zone->cool_dev[th_zone->cool_dev_size] ?
> Yes.
>>
>> I think the logic behind the allocation of these cpufreq cooling devic=
es
>> needs to be revisited. You always assigned to cool_dev[0], but you
>> always iterate the array until cool_dev_size. Remember that
>> cool_dev_size now is per th_zone, not global.
> I have kept an array of cooling devices to add other type of cooling
> devices in the same thermal zone in future. For current use case
> although it does not make sense and only one cpufreq cooling device is
> present

I would at least put a TODO mark. This code can easily evolve to a bug.
What it would be better is to have a proper flag/way to say how you want
to do the cooling on a specific TMU. Now you rely on the fact that you
either cool with cpufreq if freq table is present or you don't cool.
This is not scalable to what you are planing to do.

>>
>>> +             if (IS_ERR(th_zone->cool_dev[0])) {
>>> +                     pr_err("Failed to register cpufreq cooling devi=
ce\n");
>>> +                     ret =3D -EINVAL;
>>> +                     goto err_unregister;
>>> +             }
>>> +             th_zone->cool_dev_size++;
>>>       }
>>> -     th_zone->cool_dev_size++;
>>>
>>> -     th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf=
->name,
>>> -                     EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops,=
 NULL, 0,
>>> -                     sensor_conf->trip_data.trigger_falling ?
>>> -                     0 : IDLE_INTERVAL);
>>> +     th_zone->therm_dev =3D thermal_zone_device_register(
>>> +                     sensor_conf->name, sensor_conf->trip_data.trip_=
count,
>>> +                     0, th_zone, &exynos_dev_ops, NULL, 0,
>>> +                     sensor_conf->trip_data.trigger_falling ? 0 :
>>> +                     IDLE_INTERVAL);
>>>
>>>       if (IS_ERR(th_zone->therm_dev)) {
>>>               pr_err("Failed to register thermal zone device\n");
>>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/driver=
s/thermal/samsung/exynos_thermal_common.h
>>> index 1e9a326..dd0077e 100644
>>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>>> @@ -42,8 +42,6 @@
>>>  #define GET_ZONE(trip) (trip + 2)
>>>  #define GET_TRIP(zone) (zone - 2)
>>>
>>> -#define EXYNOS_ZONE_COUNT    3
>>> -
>>>  enum trigger_type {
>>>       THROTTLE_ACTIVE =3D 1,
>>>       THROTTLE_PASSIVE,
>>> @@ -68,6 +66,7 @@ struct freq_clip_table {
>>>  };
>>>  struct       thermal_trip_point_conf {
>>>       int trip_val[MAX_TRIP_COUNT];
>>> +     int trip_type[MAX_TRIP_COUNT];
>>>       int trip_count;
>>>       unsigned char trigger_falling;
>>>  };
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/s=
amsung/exynos_tmu.c
>>> index 40e0cfd..acbd295 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -509,9 +509,12 @@ static int exynos_tmu_probe(struct platform_devi=
ce *pdev)
>>>                       pdata->trigger_enable[1] + pdata->trigger_enabl=
e[2]+
>>>                       pdata->trigger_enable[3];
>>>
>>> -     for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++)=

>>> +     for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++)=
 {
>>>               exynos_sensor_conf.trip_data.trip_val[i] =3D
>>>                       pdata->threshold + pdata->trigger_levels[i];
>>> +             exynos_sensor_conf.trip_data.trip_type[i] =3D
>>> +                                     pdata->trigger_type[i];
>>> +     }
>>>
>>>       exynos_sensor_conf.trip_data.trigger_falling =3D pdata->thresho=
ld_falling;
>>>
>>>
>>
>>
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2PQCTDHRPQWENXWOEJFJB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHEZM0ACgkQCXcVR3XQvP1nvwD8DUQ+OgHuo+0C0JCND8przase
nx/4Yj2wWdzeJYZY/jwBAPJrNghsHeUOt+sZ98C+i9cWXJiHaU/icW0MC51FoaFN
=XXK2
-----END PGP SIGNATURE-----

------enig2PQCTDHRPQWENXWOEJFJB--
