Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaK0O2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:28:36 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57200 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaK0O2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:28:34 -0500
Date: Thu, 27 Nov 2014 10:28:25 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Navneet Kumar <navneetk@nvidia.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] thermal: of: consolidate sensor callbacks as ops
Message-ID: <20141127142823.GC3342@developer>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
 <1417050989-25405-2-git-send-email-navneetk@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1417050989-25405-2-git-send-email-navneetk@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Navneet,

On Wed, Nov 26, 2014 at 05:16:28PM -0800, Navneet Kumar wrote:
> From: navneet kumar <navneetk@nvidia.com>
>=20
> Consolidate all the sensor callbacks (get_temp/get_trend)
> into a 'thermal_of_sensor_ops' struct.
>=20
> As a part of this, introduce a 'thermal_zone_of_sensor_register2'
> sensor API that accepts sensor_ops instead of the two callbacks
> as separate arguments to the register function.

This is usually not a good thing to do. Specially about the suffix
'.*2', sounds really broken :-(. Best thing to do is to update the API
with the improvement, and update all the users of that old API.=20

This is one of the key Linux design decision. Please, have a look at:
Documentation/stable_api_nonsense.txt

To understand why doing such thing is a bad thing to do.

>=20
> Modify the older version of register function to call register2.
>=20
> Adjust all the references to get_temp/get_trend callbacks.
>=20
> Signed-off-by: navneet kumar <navneetk@nvidia.com>
> ---
>  drivers/thermal/of-thermal.c | 78 ++++++++++++++++++++++++++++----------=
------
>  include/linux/thermal.h      | 14 ++++++++
>  2 files changed, 64 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index cf9ee3e82fee..3d47a0cf3825 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -96,8 +96,7 @@ struct __thermal_zone {
> =20
>  	/* sensor interface */
>  	void *sensor_data;
> -	int (*get_temp)(void *, long *);
> -	int (*get_trend)(void *, long *);
> +	struct thermal_of_sensor_ops sops;

Have you seen this patch:
https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux-soc-thermal.git=
/commit/?h=3Dlinus&id=3D2251aef64a38db60f4ae7a4a83f9203c6791f196

?

Please rebase your changes on top of my -linus branch:
git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.gi=
t linus


BR,

Eduardo Valentin
>  };
> =20
>  /***   DT thermal zone device callbacks   ***/
> @@ -107,10 +106,10 @@ static int of_thermal_get_temp(struct thermal_zone_=
device *tz,
>  {
>  	struct __thermal_zone *data =3D tz->devdata;
> =20
> -	if (!data->get_temp)
> +	if (!data->sops.get_temp)
>  		return -EINVAL;
> =20
> -	return data->get_temp(data->sensor_data, temp);
> +	return data->sops.get_temp(data->sensor_data, temp);
>  }
> =20
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> @@ -120,10 +119,10 @@ static int of_thermal_get_trend(struct thermal_zone=
_device *tz, int trip,
>  	long dev_trend;
>  	int r;
> =20
> -	if (!data->get_trend)
> +	if (!data->sops.get_trend)
>  		return -EINVAL;
> =20
> -	r =3D data->get_trend(data->sensor_data, &dev_trend);
> +	r =3D data->sops.get_trend(data->sensor_data, &dev_trend);
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
> +			   struct thermal_of_sensor_ops *sops)
>  {
>  	struct thermal_zone_device *tzd;
>  	struct __thermal_zone *tz;
> @@ -337,8 +335,9 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>  	tz =3D tzd->devdata;
> =20
>  	mutex_lock(&tzd->lock);
> -	tz->get_temp =3D get_temp;
> -	tz->get_trend =3D get_trend;
> +	if (sops)
> +		memcpy(&(tz->sops), sops, sizeof(*sops));
> +
>  	tz->sensor_data =3D data;
> =20
>  	tzd->ops->get_temp =3D of_thermal_get_temp;
> @@ -349,15 +348,15 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>  }
> =20
>  /**
> - * thermal_zone_of_sensor_register - registers a sensor to a DT thermal =
zone
> + * thermal_zone_of_sensor_register2 - registers a sensor to a DT thermal=
 zone
>   * @dev: a valid struct device pointer of a sensor device. Must contain
>   *       a valid .of_node, for the sensor node.
>   * @sensor_id: a sensor identifier, in case the sensor IP has more
>   *             than one sensors
>   * @data: a private pointer (owned by the caller) that will be passed
>   *        back, when a temperature reading is needed.
> - * @get_temp: a pointer to a function that reads the sensor temperature.
> - * @get_trend: a pointer to a function that reads the sensor temperature=
 trend.
> + * @sops: handle to the sensor ops (get_temp/get_trend etc.) provided by=
 the
> + *		sensor to OF.
>   *
>   * This function will search the list of thermal zones described in devi=
ce
>   * tree and look for the zone that refer to the sensor device pointed by
> @@ -370,21 +369,13 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>   * The thermal zone temperature trend is provided by the @get_trend func=
tion
>   * pointer. When called, it will have the private pointer @data back.
>   *
> - * TODO:
> - * 01 - This function must enqueue the new sensor instead of using
> - * it as the only source of temperature values.
> - *
> - * 02 - There must be a way to match the sensor with all thermal zones
> - * that refer to it.
> - *
>   * Return: On success returns a valid struct thermal_zone_device,
>   * otherwise, it returns a corresponding ERR_PTR(). Caller must
>   * check the return value with help of IS_ERR() helper.
>   */
>  struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> -				void *data, int (*get_temp)(void *, long *),
> -				int (*get_trend)(void *, long *))
> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
> +				void *data, struct thermal_of_sensor_ops *sops)
>  {
>  	struct device_node *np, *child, *sensor_np;
>  	struct thermal_zone_device *tzd =3D ERR_PTR(-ENODEV);
> @@ -426,9 +417,8 @@ thermal_zone_of_sensor_register(struct device *dev, i=
nt sensor_id,
> =20
>  		if (sensor_specs.np =3D=3D sensor_np && id =3D=3D sensor_id) {
>  			tzd =3D thermal_zone_of_add_sensor(child, sensor_np,
> -							 data,
> -							 get_temp,
> -							 get_trend);
> +							  data,
> +							  sops);
>  			of_node_put(sensor_specs.np);
>  			of_node_put(child);
>  			goto exit;
> @@ -441,6 +431,38 @@ exit:
> =20
>  	return tzd;
>  }
> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register2);
> +
> +/**
> + * thermal_zone_of_sensor_register - registers a sensor to a DT thermal =
zone
> + * @dev: a valid struct device pointer of a sensor device. Must contain
> + *       a valid .of_node, for the sensor node.
> + * @sensor_id: a sensor identifier, in case the sensor IP has more
> + *             than one sensors
> + * @data: a private pointer (owned by the caller) that will be passed
> + *        back, when a temperature reading is needed.
> + * @get_temp: a pointer to a function that reads the sensor temperature.
> + * @get_trend: a pointer to a function that reads the sensor temperature=
 trend.
> + *
> + * This function calls thermal_zone_of_sensor_register2 after translating
> + * the sensor callbacks into a single structi (sops).
> + *
> + * Return: Bubbles up the return status from thermal_zone_of_register2
> + *
> + */
> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *))
> +{
> +	struct thermal_of_sensor_ops sops =3D {
> +		.get_temp =3D get_temp,
> +		.get_trend =3D get_trend,
> +	};
> +
> +	return thermal_zone_of_sensor_register2(dev, sensor_id, data, &sops);
> +
> +}
>  EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);
> =20
>  /**
> @@ -476,8 +498,8 @@ void thermal_zone_of_sensor_unregister(struct device =
*dev,
>  	tzd->ops->get_temp =3D NULL;
>  	tzd->ops->get_trend =3D NULL;
> =20
> -	tz->get_temp =3D NULL;
> -	tz->get_trend =3D NULL;
> +	tz->sops.get_temp =3D NULL;
> +	tz->sops.get_trend =3D NULL;
>  	tz->sensor_data =3D NULL;
>  	mutex_unlock(&tzd->lock);
>  }
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index ef90838b36a0..58341c56a01f 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -289,6 +289,11 @@ struct thermal_genl_event {
>  	enum events event;
>  };
> =20
> +struct thermal_of_sensor_ops {
> +	int (*get_temp)(void *, long *);
> +	int (*get_trend)(void *, long *);
> +};
> +
>  /* Function declarations */
>  #ifdef CONFIG_THERMAL_OF
>  struct thermal_zone_device *
> @@ -297,6 +302,9 @@ thermal_zone_of_sensor_register(struct device *dev, i=
nt id,
>  				int (*get_trend)(void *, long *));
>  void thermal_zone_of_sensor_unregister(struct device *dev,
>  				       struct thermal_zone_device *tz);
> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
> +				void *data, struct thermal_of_sensor_ops *sops);
>  #else
>  static inline struct thermal_zone_device *
>  thermal_zone_of_sensor_register(struct device *dev, int id,
> @@ -312,6 +320,12 @@ void thermal_zone_of_sensor_unregister(struct device=
 *dev,
>  {
>  }
> =20
> +static inline struct thermal_zone_device *
> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
> +				void *data, struct thermal_of_sensor_ops *sops)
> +{
> +	return NULL;
> +}
>  #endif
>  struct thermal_zone_device *thermal_zone_device_register(const char *, i=
nt, int,
>  		void *, struct thermal_zone_device_ops *,
> --=20
> 1.8.1.5
>=20

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdzT9AAoJEMLUO4d9pOJWR50IAJQTB7Ql4BUipgDoUkt98fsp
NjWuWZg7gwAMYuVpfSZuDJXp4JS4jtqfcFZ/N0cHZatXOrzxY19ufi8+cCDPV7Ns
QmnQ+vqP//P2DSkRNQLF5R0+w+1x2U22lToyDezv8Xj7jylausNC8Ald4KN7pQGk
rE/y0REliwrYXW/Zz5NvEIYySEU6sHh+rmtQbDZMVg6xxxJNRabuDgSFzBcNRVzy
bQFXJrhG5p9nIy2yR49X6beMrLSHcHRidfHNG6/WjGsh3JpihApvS9h8SzkT74i2
IDpY7zdH1ufbcidfsFkDYoHL8dG1JN+ViH657pE6JzsTcsNoH85xL/3cqwZR670=
=tvqE
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
