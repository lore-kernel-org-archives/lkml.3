Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3FYNgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:36:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37037 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3FYNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:36:30 -0400
Message-ID: <51C99CCF.2050500@ti.com>
Date: Tue, 25 Jun 2013 09:36:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH RESEND V7 16/30] thermal: exynos: Make the zone handling
 use trip information
References: <1372071051-3167-17-git-send-email-amit.daniel@samsung.com> <1372160359-14504-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1372160359-14504-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2EEMIWCCBMKNCSECQPCFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EEMIWCCBMKNCSECQPCFB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-06-2013 07:39, Amit Daniel Kachhap wrote:
> This code simplifies the zone handling to use the trip information pass=
ed
> by the TMU driver and not the hardcoded macros. This also helps in addi=
ng
> more zone support.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |   67 ++++++++++++++-=
--------
>  drivers/thermal/samsung/exynos_thermal_common.h |    3 +-
>  drivers/thermal/samsung/exynos_tmu.c            |    5 ++-
>  3 files changed, 47 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index 99318e5..ecf95da 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -79,17 +79,24 @@ static int exynos_set_mode(struct thermal_zone_devi=
ce *thermal,
>  static int exynos_get_trip_type(struct thermal_zone_device *thermal, i=
nt trip,
>  				 enum thermal_trip_type *type)
>  {
> -	switch (GET_ZONE(trip)) {
> -	case MONITOR_ZONE:
> -	case WARN_ZONE:
> -		*type =3D THERMAL_TRIP_ACTIVE;
> -		break;
> -	case PANIC_ZONE:
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> +	int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
> +	int trip_type;
> +
> +	if (trip < 0 || trip >=3D max_trip)
> +		return -EINVAL;
> +
> +	trip_type =3D th_zone->sensor_conf->trip_data.trip_type[trip];
> +
> +	if (trip_type =3D=3D SW_TRIP)
>  		*type =3D THERMAL_TRIP_CRITICAL;
> -		break;
> -	default:
> +	else if (trip_type =3D=3D THROTTLE_ACTIVE)
> +		*type =3D THERMAL_TRIP_ACTIVE;
> +	else if (trip_type =3D=3D THROTTLE_PASSIVE)
> +		*type =3D THERMAL_TRIP_PASSIVE;
> +	else
>  		return -EINVAL;
> -	}
> +
>  	return 0;
>  }
> =20
> @@ -98,8 +105,9 @@ static int exynos_get_trip_temp(struct thermal_zone_=
device *thermal, int trip,
>  				unsigned long *temp)
>  {
>  	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> +	int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
> =20
> -	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
> +	if (trip < 0 || trip >=3D max_trip)
>  		return -EINVAL;
> =20
>  	*temp =3D th_zone->sensor_conf->trip_data.trip_val[trip];
> @@ -113,10 +121,10 @@ static int exynos_get_trip_temp(struct thermal_zo=
ne_device *thermal, int trip,
>  static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>  				unsigned long *temp)
>  {
> -	int ret;
> -	/* Panic zone */
> -	ret =3D exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
> -	return ret;
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> +	int max_trip =3D th_zone->sensor_conf->trip_data.trip_count;
> +	/* Get the temp of highest trip*/
> +	return exynos_get_trip_temp(thermal, max_trip - 1, temp);
>  }
> =20
>  /* Bind callback functions for thermal zone */
> @@ -348,19 +356,28 @@ int exynos_register_thermal(struct thermal_sensor=
_conf *sensor_conf)
>  		return -ENOMEM;
> =20
>  	th_zone->sensor_conf =3D sensor_conf;
> -	cpumask_set_cpu(0, &mask_val);
> -	th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask_val);
> -	if (IS_ERR(th_zone->cool_dev[0])) {
> -		pr_err("Failed to register cpufreq cooling device\n");
> -		ret =3D -EINVAL;
> -		goto err_unregister;
> +	/*
> +	 * TODO: 1) Handle multiple cooling devices in a thermal zone
> +	 *	 2) Add a flag/name in cooling info to map to specific
> +	 *	 sensor
> +	 */
> +	if (sensor_conf->cooling_data.freq_clip_count > 0) {
> +		cpumask_set_cpu(0, &mask_val);
> +		th_zone->cool_dev[th_zone->cool_dev_size] =3D
> +					cpufreq_cooling_register(&mask_val);
> +		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
> +			pr_err("Failed to register cpufreq cooling device\n");
> +			ret =3D -EINVAL;
> +			goto err_unregister;
> +		}
> +		th_zone->cool_dev_size++;
>  	}
> -	th_zone->cool_dev_size++;
> =20
> -	th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf->name=
,
> -			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
> -			sensor_conf->trip_data.trigger_falling ?
> -			0 : IDLE_INTERVAL);
> +	th_zone->therm_dev =3D thermal_zone_device_register(
> +			sensor_conf->name, sensor_conf->trip_data.trip_count,
> +			0, th_zone, &exynos_dev_ops, NULL, 0,
> +			sensor_conf->trip_data.trigger_falling ? 0 :
> +			IDLE_INTERVAL);
> =20
>  	if (IS_ERR(th_zone->therm_dev)) {
>  		pr_err("Failed to register thermal zone device\n");
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index 6ca3096..bfcf69e 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -42,8 +42,6 @@
>  #define GET_ZONE(trip) (trip + 2)
>  #define GET_TRIP(zone) (zone - 2)
> =20
> -#define EXYNOS_ZONE_COUNT	3
> -
>  enum trigger_type {
>  	THROTTLE_ACTIVE =3D 1,
>  	THROTTLE_PASSIVE,
> @@ -69,6 +67,7 @@ struct freq_clip_table {
> =20
>  struct	thermal_trip_point_conf {
>  	int trip_val[MAX_TRIP_COUNT];
> +	int trip_type[MAX_TRIP_COUNT];
>  	int trip_count;
>  	unsigned char trigger_falling;
>  };
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 40e0cfd..acbd295 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -509,9 +509,12 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>  			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>  			pdata->trigger_enable[3];
> =20
> -	for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
> +	for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++) {
>  		exynos_sensor_conf.trip_data.trip_val[i] =3D
>  			pdata->threshold + pdata->trigger_levels[i];
> +		exynos_sensor_conf.trip_data.trip_type[i] =3D
> +					pdata->trigger_type[i];
> +	}
> =20
>  	exynos_sensor_conf.trip_data.trigger_falling =3D pdata->threshold_fal=
ling;
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2EEMIWCCBMKNCSECQPCFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHJnM8ACgkQCXcVR3XQvP0DHAEA7bckyoeh8LYs9I+pcEnxAAp5
m+Or2KXNhl8H7iHUXG8A/j1AFuxfE47ao6F4C5Hw1ybGW2dxSU9H/gZyZT2cS3P1
=xtcx
-----END PGP SIGNATURE-----

------enig2EEMIWCCBMKNCSECQPCFB--
