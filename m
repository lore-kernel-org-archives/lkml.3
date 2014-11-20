Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaKTOSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:18:13 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36236 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaKTOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:18:11 -0500
Date: Thu, 20 Nov 2014 10:18:08 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Linux PM <linux-pm@vger.kernel.org>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, lm-sensors@lm-sensors.org,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv5 1/1] thermal: of: improve of-thermal sensor
 registration API
Message-ID: <20141120141806.GA1746@developer>
References: <1416492733-1624-1-git-send-email-edubezval@gmail.com>
 <1416492733-1624-2-git-send-email-edubezval@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1416492733-1624-2-git-send-email-edubezval@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Thu, Nov 20, 2014 at 10:12:13AM -0400, Eduardo Valentin wrote:
> Different drivers request API extensions in of-thermal. For this reason,
> additional callbacks are required to fit the new drivers needs.
>=20
> The current API implementation expects the registering sensor driver
> to provide a get_temp and get_trend callbacks as function parameters.
> As the amount of callbacks is growing, this patch changes the existing
> implementation to use a .ops field to hold all the of thermal callbacks
> to sensor drivers.
>=20
> This patch also changes the existing of-thermal users to fit the new
> API design. No functional change is introduced in this patch.
>=20
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: devicetree@vger.kernel.org
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: lm-sensors@lm-sensors.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> Reviewed-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> ---
>  drivers/hwmon/lm75.c                               |  9 +++--
>  drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>  drivers/hwmon/tmp102.c                             |  6 +++-

Do you have objections if I queue this one for 3.19?


Cheers,

Eduardo Valentin

>  drivers/thermal/of-thermal.c                       | 39 ++++++++++------=
------
>  drivers/thermal/tegra_soctherm.c                   |  7 ++--
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  8 +++--
>  include/linux/thermal.h                            | 24 +++++++++----
>  7 files changed, 62 insertions(+), 37 deletions(-)
> ---
> Difference from V4:
>  - Corrected comment about which callbacks are currently mandatory.
>  - Fixed compilation error when !CONFIG_OF_THERMAL.
> Difference from V3:
>  - Keep the same behavior regarding callback checks.
>    Change in behavior may be sent in a separate patch.
> Difference from V2:
>  - Fix wrong assignment in tegra driver.
> Difference from V1:
>  - Fix error handling when .get_trend is not provided.
>=20
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index d16dbb3..e7c8bf9 100644
> --- a/drivers/hwmon/lm75.c
> +++ b/drivers/hwmon/lm75.c
> @@ -176,6 +176,10 @@ static struct attribute *lm75_attrs[] =3D {
>  };
>  ATTRIBUTE_GROUPS(lm75);
> =20
> +static const struct thermal_zone_of_device_ops lm75_of_thermal_ops =3D {
> +	.get_temp =3D lm75_read_temp,
> +};
> +
>  /*----------------------------------------------------------------------=
-*/
> =20
>  /* device probe and removal */
> @@ -291,10 +295,9 @@ lm75_probe(struct i2c_client *client, const struct i=
2c_device_id *id)
>  	if (IS_ERR(data->hwmon_dev))
>  		return PTR_ERR(data->hwmon_dev);
> =20
> -	data->tz =3D thermal_zone_of_sensor_register(data->hwmon_dev,
> -						   0,
> +	data->tz =3D thermal_zone_of_sensor_register(data->hwmon_dev, 0,
>  						   data->hwmon_dev,
> -						   lm75_read_temp, NULL);
> +						   &lm75_of_thermal_ops);
>  	if (IS_ERR(data->tz))
>  		data->tz =3D NULL;
> =20
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermisto=
r.c
> index 4ff89b2..bca8521c8 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -486,6 +486,10 @@ static const struct attribute_group ntc_attr_group =
=3D {
>  	.attrs =3D ntc_attributes,
>  };
> =20
> +static const struct thermal_zone_of_device_ops ntc_of_thermal_ops =3D {
> +	.get_temp =3D ntc_read_temp,
> +};
> +
>  static int ntc_thermistor_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id =3D
> @@ -579,7 +583,7 @@ static int ntc_thermistor_probe(struct platform_devic=
e *pdev)
>  								pdev_id->name);
> =20
>  	data->tz =3D thermal_zone_of_sensor_register(data->dev, 0, data->dev,
> -						ntc_read_temp, NULL);
> +						   &ntc_of_thermal_ops);
>  	if (IS_ERR(data->tz)) {
>  		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
>  		data->tz =3D NULL;
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index 5171995..ba9f478 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -158,6 +158,10 @@ ATTRIBUTE_GROUPS(tmp102);
>  #define TMP102_CONFIG  (TMP102_CONF_TM | TMP102_CONF_EM | TMP102_CONF_CR=
1)
>  #define TMP102_CONFIG_RD_ONLY (TMP102_CONF_R0 | TMP102_CONF_R1 | TMP102_=
CONF_AL)
> =20
> +static const struct thermal_zone_of_device_ops tmp102_of_thermal_ops =3D=
 {
> +	.get_temp =3D tmp102_read_temp,
> +};
> +
>  static int tmp102_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {
> @@ -215,7 +219,7 @@ static int tmp102_probe(struct i2c_client *client,
>  	}
>  	tmp102->hwmon_dev =3D hwmon_dev;
>  	tmp102->tz =3D thermal_zone_of_sensor_register(hwmon_dev, 0, hwmon_dev,
> -						     tmp102_read_temp, NULL);
> +						     &tmp102_of_thermal_ops);
>  	if (IS_ERR(tmp102->tz))
>  		tmp102->tz =3D NULL;
> =20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index f8eb625..b6e7a26 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -30,6 +30,7 @@
>  #include <linux/err.h>
>  #include <linux/export.h>
>  #include <linux/string.h>
> +#include <linux/thermal.h>
> =20
>  #include "thermal_core.h"
> =20
> @@ -77,8 +78,7 @@ struct __thermal_bind_params {
>   * @num_tbps: number of thermal bind params
>   * @tbps: an array of thermal bind params (0..num_tbps - 1)
>   * @sensor_data: sensor private data used while reading temperature and =
trend
> - * @get_temp: sensor callback to read temperature
> - * @get_trend: sensor callback to read temperature trend
> + * @ops: set of callbacks to handle the thermal zone based on DT
>   */
> =20
>  struct __thermal_zone {
> @@ -96,8 +96,7 @@ struct __thermal_zone {
> =20
>  	/* sensor interface */
>  	void *sensor_data;
> -	int (*get_temp)(void *, long *);
> -	int (*get_trend)(void *, long *);
> +	const struct thermal_zone_of_device_ops *ops;
>  };
> =20
>  /***   DT thermal zone device callbacks   ***/
> @@ -107,10 +106,10 @@ static int of_thermal_get_temp(struct thermal_zone_=
device *tz,
>  {
>  	struct __thermal_zone *data =3D tz->devdata;
> =20
> -	if (!data->get_temp)
> +	if (!data->ops->get_temp)
>  		return -EINVAL;
> =20
> -	return data->get_temp(data->sensor_data, temp);
> +	return data->ops->get_temp(data->sensor_data, temp);
>  }
> =20
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> @@ -120,10 +119,10 @@ static int of_thermal_get_trend(struct thermal_zone=
_device *tz, int trip,
>  	long dev_trend;
>  	int r;
> =20
> -	if (!data->get_trend)
> +	if (!data->ops->get_trend)
>  		return -EINVAL;
> =20
> -	r =3D data->get_trend(data->sensor_data, &dev_trend);
> +	r =3D data->ops->get_trend(data->sensor_data, &dev_trend);
>  	if (r)
>  		return r;
> =20
> @@ -324,8 +323,7 @@ static struct thermal_zone_device_ops of_thermal_ops =
=3D {
>  static struct thermal_zone_device *
>  thermal_zone_of_add_sensor(struct device_node *zone,
>  			   struct device_node *sensor, void *data,
> -			   int (*get_temp)(void *, long *),
> -			   int (*get_trend)(void *, long *))
> +			   const struct thermal_zone_of_device_ops *ops)
>  {
>  	struct thermal_zone_device *tzd;
>  	struct __thermal_zone *tz;
> @@ -336,9 +334,11 @@ thermal_zone_of_add_sensor(struct device_node *zone,
> =20
>  	tz =3D tzd->devdata;
> =20
> +	if (!ops)
> +		return ERR_PTR(-EINVAL);
> +
>  	mutex_lock(&tzd->lock);
> -	tz->get_temp =3D get_temp;
> -	tz->get_trend =3D get_trend;
> +	tz->ops =3D ops;
>  	tz->sensor_data =3D data;
> =20
>  	tzd->ops->get_temp =3D of_thermal_get_temp;
> @@ -356,8 +356,7 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>   *             than one sensors
>   * @data: a private pointer (owned by the caller) that will be passed
>   *        back, when a temperature reading is needed.
> - * @get_temp: a pointer to a function that reads the sensor temperature.
> - * @get_trend: a pointer to a function that reads the sensor temperature=
 trend.
> + * @ops: struct thermal_zone_of_device_ops *. Must contain at least .get=
_temp.
>   *
>   * This function will search the list of thermal zones described in devi=
ce
>   * tree and look for the zone that refer to the sensor device pointed by
> @@ -382,9 +381,8 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>   * check the return value with help of IS_ERR() helper.
>   */
>  struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> -				void *data, int (*get_temp)(void *, long *),
> -				int (*get_trend)(void *, long *))
> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void =
*data,
> +				const struct thermal_zone_of_device_ops *ops)
>  {
>  	struct device_node *np, *child, *sensor_np;
> =20
> @@ -424,9 +422,7 @@ thermal_zone_of_sensor_register(struct device *dev, i=
nt sensor_id,
>  		if (sensor_specs.np =3D=3D sensor_np && id =3D=3D sensor_id) {
>  			of_node_put(np);
>  			return thermal_zone_of_add_sensor(child, sensor_np,
> -							  data,
> -							  get_temp,
> -							  get_trend);
> +							  data, ops);
>  		}
>  	}
>  	of_node_put(np);
> @@ -468,8 +464,7 @@ void thermal_zone_of_sensor_unregister(struct device =
*dev,
>  	tzd->ops->get_temp =3D NULL;
>  	tzd->ops->get_trend =3D NULL;
> =20
> -	tz->get_temp =3D NULL;
> -	tz->get_trend =3D NULL;
> +	tz->ops =3D NULL;
>  	tz->sensor_data =3D NULL;
>  	mutex_unlock(&tzd->lock);
>  }
> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soc=
therm.c
> index 70f7e9e..9197fc0 100644
> --- a/drivers/thermal/tegra_soctherm.c
> +++ b/drivers/thermal/tegra_soctherm.c
> @@ -317,6 +317,10 @@ static int tegra_thermctl_get_temp(void *data, long =
*out_temp)
>  	return 0;
>  }
> =20
> +static const struct thermal_zone_of_device_ops tegra_of_thermal_ops =3D {
> +	.get_temp =3D tegra_thermctl_get_temp,
> +};
> +
>  static const struct of_device_id tegra_soctherm_of_match[] =3D {
>  	{ .compatible =3D "nvidia,tegra124-soctherm" },
>  	{ },
> @@ -416,8 +420,7 @@ static int tegra_soctherm_probe(struct platform_devic=
e *pdev)
>  		zone->shift =3D t124_thermctl_temp_zones[i].shift;
> =20
>  		tz =3D thermal_zone_of_sensor_register(&pdev->dev, i, zone,
> -						     tegra_thermctl_get_temp,
> -						     NULL);
> +						     &tegra_of_thermal_ops);
>  		if (IS_ERR(tz)) {
>  			err =3D PTR_ERR(tz);
>  			dev_err(&pdev->dev, "failed to register sensor: %d\n",
> diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers=
/thermal/ti-soc-thermal/ti-thermal-common.c
> index 9eec26d..5fd0386 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> @@ -286,6 +286,11 @@ static int ti_thermal_get_crit_temp(struct thermal_z=
one_device *thermal,
>  	return ti_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp);
>  }
> =20
> +static const struct thermal_zone_of_device_ops ti_of_thermal_ops =3D {
> +	.get_temp =3D __ti_thermal_get_temp,
> +	.get_trend =3D __ti_thermal_get_trend,
> +};
> +
>  static struct thermal_zone_device_ops ti_thermal_ops =3D {
>  	.get_temp =3D ti_thermal_get_temp,
>  	.get_trend =3D ti_thermal_get_trend,
> @@ -333,8 +338,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, =
int id,
> =20
>  	/* in case this is specified by DT */
>  	data->ti_thermal =3D thermal_zone_of_sensor_register(bgp->dev, id,
> -					data, __ti_thermal_get_temp,
> -					__ti_thermal_get_trend);
> +					data, &ti_of_thermal_ops);
>  	if (IS_ERR(data->ti_thermal)) {
>  		/* Create thermal zone */
>  		data->ti_thermal =3D thermal_zone_device_register(domain,
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index ef90838..5bc28a7 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -289,19 +289,31 @@ struct thermal_genl_event {
>  	enum events event;
>  };
> =20
> +/**
> + * struct thermal_zone_of_device_ops - scallbacks for handling DT based =
zones
> + *
> + * Mandatory:
> + * @get_temp: a pointer to a function that reads the sensor temperature.
> + *
> + * Optional:
> + * @get_trend: a pointer to a function that reads the sensor temperature=
 trend.
> + */
> +struct thermal_zone_of_device_ops {
> +	int (*get_temp)(void *, long *);
> +	int (*get_trend)(void *, long *);
> +};
> +
>  /* Function declarations */
>  #ifdef CONFIG_THERMAL_OF
>  struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int id,
> -				void *data, int (*get_temp)(void *, long *),
> -				int (*get_trend)(void *, long *));
> +thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
> +				const struct thermal_zone_of_device_ops *ops);
>  void thermal_zone_of_sensor_unregister(struct device *dev,
>  				       struct thermal_zone_device *tz);
>  #else
>  static inline struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int id,
> -				void *data, int (*get_temp)(void *, long *),
> -				int (*get_trend)(void *, long *))
> +thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
> +				const struct thermal_zone_of_device_ops *ops)
>  {
>  	return NULL;
>  }
> --=20
> 2.1.3
>=20

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbfgeAAoJEMLUO4d9pOJW1b0H/jpCUrTAeuB3Zm1RcOCKi0Q3
0C/T45zl7qL9CfpuKZRsiBFek9fFO1ZyDOFrkng35ut7wwWIvEC9JNDBRsKo67aI
gISn38d5Ze1NeLr7oXEVeIj5sdQ+vjtI7LQ6VFVMiFMEYq3R6lbVQ0rtOxtNGitM
Bh7SY8hGyMjxSGTtKGCaL4+vP9UUxc90fn7REFJ4BAN64iLzvKsoCfTjoQannPIY
LR1mq+rNVXonj4wd6MV7O+N0adTBB7Wa202vzW+5X5xbbAwwHMY8lFGqb3T4DVYP
sN7O1aZlOK53mC9+sa25Zjv4ioqwkdSQ0LtGkwcwhvj4bOfOFbA9KHwSbULVJhc=
=OTdf
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
