Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbbAILqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:46:12 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47667 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbbAILqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:46:10 -0500
Date: Fri, 9 Jan 2015 07:46:01 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH V2] (gpio-fan): Add thermal control hooks
Message-ID: <20150109114559.GA9510@developer>
References: <1420740303-12529-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <1420740303-12529-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 12:05:03PM -0600, Nishanth Menon wrote:
> Allow gpio-fan to be used as thermal cooling device for platforms that
> use GPIO maps to control fans.
>=20
> As part of this change, we make the shutdown and remove logic the same
> as well.
>=20
> Signed-off-by: Nishanth Menon <nm@ti.com>

For the thermal part:

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> ---
>=20
> Changes since v1:
> 	- review comments incorporated (hopefully correct)
> 	- checkpatch verified
> 	- retested :).
>=20
> V1: https://patchwork.kernel.org/patch/5587061/
>=20
>  .../devicetree/bindings/gpio/gpio-fan.txt          |   13 +++
>  drivers/hwmon/gpio-fan.c                           |   83 ++++++++++++++=
++++--
>  2 files changed, 89 insertions(+), 7 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-fan.txt b/Docume=
ntation/devicetree/bindings/gpio/gpio-fan.txt
> index 2dd457a3469a..43ca2a45b862 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-fan.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-fan.txt
> @@ -11,6 +11,9 @@ Required properties:
>  Optional properties:
>  - alarm-gpios: This pin going active indicates something is wrong with
>    the fan, and a udev event will be fired.
> +- cooling-cells: If used as a cooling device, must be <2>
> +  Also see: Documentation/devicetree/bindings/thermal/thermal.txt
> +  min and max states are derived from the speed-map of the fan.
> =20
>  Examples:
> =20
> @@ -23,3 +26,13 @@ Examples:
>  				      6000 2>;
>  		alarm-gpios =3D <&gpio1 15 1>;
>  	};
> +	gpio_fan_cool: gpio_fan {
> +		compatible =3D "gpio-fan";
> +		gpios =3D <&gpio2 14 1
> +			 &gpio2 13 1>;
> +		gpio-fan,speed-map =3D	<0    0>,
> +					<3000 1>,
> +					<6000 2>;
> +		alarm-gpios =3D <&gpio2 15 1>;
> +		#cooling-cells =3D <2>; /* min followed by max */
> +	};
> diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
> index 36abf814b8c7..20232c11b579 100644
> --- a/drivers/hwmon/gpio-fan.c
> +++ b/drivers/hwmon/gpio-fan.c
> @@ -34,10 +34,13 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
> +#include <linux/thermal.h>
> =20
>  struct gpio_fan_data {
>  	struct platform_device	*pdev;
>  	struct device		*hwmon_dev;
> +	/* Cooling device if any */
> +	struct thermal_cooling_device *cdev;
>  	struct mutex		lock; /* lock GPIOs operations. */
>  	int			num_ctrl;
>  	unsigned		*ctrl;
> @@ -387,6 +390,53 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_d=
ata,
>  	return 0;
>  }
> =20
> +static int gpio_fan_get_max_state(struct thermal_cooling_device *cdev,
> +				  unsigned long *state)
> +{
> +	struct gpio_fan_data *fan_data =3D cdev->devdata;
> +
> +	if (!fan_data)
> +		return -EINVAL;
> +
> +	*state =3D fan_data->num_speed - 1;
> +	return 0;
> +}
> +
> +static int gpio_fan_get_cur_state(struct thermal_cooling_device *cdev,
> +				  unsigned long *state)
> +{
> +	struct gpio_fan_data *fan_data =3D cdev->devdata;
> +	int r;
> +
> +	if (!fan_data)
> +		return -EINVAL;
> +
> +	r =3D get_fan_speed_index(fan_data);
> +	if (r < 0)
> +		return r;
> +
> +	*state =3D r;
> +	return 0;
> +}
> +
> +static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
> +				  unsigned long state)
> +{
> +	struct gpio_fan_data *fan_data =3D cdev->devdata;
> +
> +	if (!fan_data)
> +		return -EINVAL;
> +
> +	set_fan_speed(fan_data, state);
> +	return 0;
> +}
> +
> +static const struct thermal_cooling_device_ops gpio_fan_cool_ops =3D {
> +	.get_max_state =3D gpio_fan_get_max_state,
> +	.get_cur_state =3D gpio_fan_get_cur_state,
> +	.set_cur_state =3D gpio_fan_set_cur_state,
> +};
> +
>  #ifdef CONFIG_OF_GPIO
>  /*
>   * Translate OpenFirmware node properties into platform_data
> @@ -495,6 +545,11 @@ static int gpio_fan_probe(struct platform_device *pd=
ev)
>  	struct gpio_fan_data *fan_data;
>  	struct gpio_fan_platform_data *pdata =3D dev_get_platdata(&pdev->dev);
> =20
> +	fan_data =3D devm_kzalloc(&pdev->dev, sizeof(struct gpio_fan_data),
> +				GFP_KERNEL);
> +	if (!fan_data)
> +		return -ENOMEM;
> +
>  #ifdef CONFIG_OF_GPIO
>  	if (!pdata) {
>  		pdata =3D devm_kzalloc(&pdev->dev,
> @@ -506,17 +561,20 @@ static int gpio_fan_probe(struct platform_device *p=
dev)
>  		err =3D gpio_fan_get_of_pdata(&pdev->dev, pdata);
>  		if (err)
>  			return err;
> +		/* Optional cooling device register for Device tree platforms */
> +		fan_data->cdev =3D
> +			thermal_of_cooling_device_register(pdev->dev.of_node,
> +							   "gpio-fan", fan_data,
> +							   &gpio_fan_cool_ops);
>  	}
>  #else /* CONFIG_OF_GPIO */
>  	if (!pdata)
>  		return -EINVAL;
> +	/* Optional cooling device register for non Device tree platforms */
> +	fan_data->cdev =3D thermal_cooling_device_register("gpio-fan", fan_data,
> +							 &gpio_fan_cool_ops);
>  #endif /* CONFIG_OF_GPIO */
> =20
> -	fan_data =3D devm_kzalloc(&pdev->dev, sizeof(struct gpio_fan_data),
> -				GFP_KERNEL);
> -	if (!fan_data)
> -		return -ENOMEM;
> -
>  	fan_data->pdev =3D pdev;
>  	platform_set_drvdata(pdev, fan_data);
>  	mutex_init(&fan_data->lock);
> @@ -550,12 +608,22 @@ static int gpio_fan_probe(struct platform_device *p=
dev)
>  	return 0;
>  }
> =20
> -static void gpio_fan_shutdown(struct platform_device *pdev)
> +static int gpio_fan_remove(struct platform_device *pdev)
>  {
> -	struct gpio_fan_data *fan_data =3D dev_get_drvdata(&pdev->dev);
> +	struct gpio_fan_data *fan_data =3D platform_get_drvdata(pdev);
> +
> +	if (!IS_ERR(fan_data->cdev))
> +		thermal_cooling_device_unregister(fan_data->cdev);
> =20
>  	if (fan_data->ctrl)
>  		set_fan_speed(fan_data, 0);
> +
> +	return 0;
> +}
> +
> +static void gpio_fan_shutdown(struct platform_device *pdev)
> +{
> +	gpio_fan_remove(pdev);
>  }
> =20
>  #ifdef CONFIG_PM_SLEEP
> @@ -589,6 +657,7 @@ static SIMPLE_DEV_PM_OPS(gpio_fan_pm, gpio_fan_suspen=
d, gpio_fan_resume);
> =20
>  static struct platform_driver gpio_fan_driver =3D {
>  	.probe		=3D gpio_fan_probe,
> +	.remove		=3D gpio_fan_remove,
>  	.shutdown	=3D gpio_fan_shutdown,
>  	.driver	=3D {
>  		.name	=3D "gpio-fan",
> --=20
> 1.7.9.5
>=20

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUr79uAAoJEMLUO4d9pOJWoS8H/ifD0Ym3utI4XqEzYJuODYCd
i3fo96W/+yMFR4HIWrnAXKHv6p9Z9IoaYsUCO+igOhqmQjzwRQ8xMpx0vMfbGNfy
wRLZdUAh7z0nexVMVgFCHZUTjztjxTczZh3Prs4jSuwv+o91+a5g+f5+mS+arQ/o
pF8jqnFNkuBgzTWjKYNcyYj+Mrys4jt9j1T8eMlbzeW1M4O7af1+uL7QmphTz2bK
Fb5yXqwKLKcGT3bPQgU3pG9lYrNwVYXJRqm03kLkr1Mi0P0nO/OQhhaWQ5PL8WSi
UH6fp4OQa3WknYnt8dJv72YVY/eNFqL/alNcNWWTequ4OzHNZuwakeWs1l1WzrU=
=w3qV
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
