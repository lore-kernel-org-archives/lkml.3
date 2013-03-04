Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3CDWqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:46:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab3CDWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:46:17 -0500
Date: Mon, 4 Mar 2013 23:46:11 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Chew <achew@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Alex Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
Message-ID: <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de>
References: <1362433790-22560-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <1362433790-22560-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:PkbLj7hqtlMsHWbO3IN+u12OnOcv5gUa30TXpWSDwsg
 byVJfOwrwyIdSY671bYrEs4ZB6VOOfoUwo04G7spOxCODN+1dy
 1uzycvxvjVf1zjzitdjk4JvSU3pERgLqFz/WTe2rJH5HRK9Y+Z
 NSksrq0FSzFoOlDiJv+gQYmifgdclOHksP218vJlNbcJGnqgny
 Bs7aiV2AvfTC79Cohk/Hdt2CB5wm3vpiAFBOfKisC3CcFHMzjm
 JWgQr4X8qjrTe3JqeXGnORq6lcE/KeBrTw4QVqijbhME2OSU8v
 gpCl/n3it66hRvPZGi9PYdCrt8uXrhxrEfBfSy5Tu+XkslS+pl
 F3kjorE0hFnQIw6pS1rrx2Xe6YaDIX2V0vIWp981VkCcqyO9d5
 GBbDl9hMbUWuwtJqmhq/1VLlh0eh6LXj6FY2Ux8cqhjJ0HKM5O
 K/eq0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 01:49:49PM -0800, Andrew Chew wrote:
> The backlight enable GPIO is specified in the device tree node for
> backlight.
>=20
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  .../bindings/video/backlight/pwm-backlight.txt     |    2 ++
>  drivers/video/backlight/pwm_bl.c                   |   32 ++++++++++++++=
+++---
>  include/linux/pwm_backlight.h                      |    2 ++
>  3 files changed, 32 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 1e4fc72..1ed4f0f 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,8 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - enable-gpio: a GPIO that needs to be used to enable the backlight
> +  - enable-gpio-active-high: polarity of GPIO is active high (default is=
 low)
> =20
>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> =20
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 069983c..f29f9c7 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -20,10 +20,13 @@
>  #include <linux/pwm.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/slab.h>
> +#include <linux/of_gpio.h>
> =20
>  struct pwm_bl_data {
>  	struct pwm_device	*pwm;
>  	struct device		*dev;
> +	int			enable_gpio;
> +	unsigned int		enable_gpio_flags;
>  	unsigned int		period;
>  	unsigned int		lth_brightness;
>  	unsigned int		*levels;
> @@ -146,10 +149,15 @@ static int pwm_backlight_parse_dt(struct device *de=
v,
>  	}
> =20
>  	/*
> -	 * TODO: Most users of this driver use a number of GPIOs to control
> -	 *       backlight power. Support for specifying these needs to be
> -	 *       added.
> +	 * If "enable-gpio" is present, use that GPIO to enable the backlight.
> +	 * The presence (or not) of "enable-gpio-active-high" will determine
> +	 * the value of the GPIO.
>  	 */
> +	data->enable_gpio =3D of_get_named_gpio(node, "enable-gpio", 0);
> +	if (of_property_read_bool(node, "enable-gpio-active-high"))
> +		data->enable_gpio_flags =3D GPIOF_OUT_INIT_HIGH;
> +	else
> +		data->enable_gpio_flags =3D GPIOF_OUT_INIT_LOW;
> =20
>  	return 0;
>  }
> @@ -207,12 +215,23 @@ static int pwm_backlight_probe(struct platform_devi=
ce *pdev)
>  	} else
>  		max =3D data->max_brightness;
> =20
> +	pb->enable_gpio =3D data->enable_gpio;
> +	pb->enable_gpio_flags =3D data->enable_gpio_flags;
>  	pb->notify =3D data->notify;
>  	pb->notify_after =3D data->notify_after;
>  	pb->check_fb =3D data->check_fb;
>  	pb->exit =3D data->exit;
>  	pb->dev =3D &pdev->dev;
> =20
> +	if (gpio_is_valid(pb->enable_gpio)) {
> +		ret =3D gpio_request_one(pb->enable_gpio,
> +			GPIOF_DIR_OUT | pb->enable_gpio_flags, "bl_en");
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to allocate bl_en gpio");
> +			goto err_alloc;
> +		}
> +	}
> +
>  	pb->pwm =3D devm_pwm_get(&pdev->dev, NULL);
>  	if (IS_ERR(pb->pwm)) {
>  		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
> @@ -221,7 +240,7 @@ static int pwm_backlight_probe(struct platform_device=
 *pdev)
>  		if (IS_ERR(pb->pwm)) {
>  			dev_err(&pdev->dev, "unable to request legacy PWM\n");
>  			ret =3D PTR_ERR(pb->pwm);
> -			goto err_alloc;
> +			goto err_gpio;
>  		}
>  	}
> =20
> @@ -255,6 +274,9 @@ static int pwm_backlight_probe(struct platform_device=
 *pdev)
>  	platform_set_drvdata(pdev, bl);
>  	return 0;
> =20
> +err_gpio:
> +	if (gpio_is_valid(data->enable_gpio))
> +		gpio_free(data->enable_gpio);
>  err_alloc:
>  	if (data->exit)
>  		data->exit(&pdev->dev);
> @@ -269,6 +291,8 @@ static int pwm_backlight_remove(struct platform_devic=
e *pdev)
>  	backlight_device_unregister(bl);
>  	pwm_config(pb->pwm, 0, pb->period);
>  	pwm_disable(pb->pwm);
> +	if (gpio_is_valid(pb->enable_gpio))
> +		gpio_free(pb->enable_gpio);
>  	if (pb->exit)
>  		pb->exit(&pdev->dev);
>  	return 0;
> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
> index 56f4a86..2706805 100644
> --- a/include/linux/pwm_backlight.h
> +++ b/include/linux/pwm_backlight.h
> @@ -8,6 +8,8 @@
> =20
>  struct platform_pwm_backlight_data {
>  	int pwm_id;
> +	int enable_gpio;
> +	unsigned int enable_gpio_flags;
>  	unsigned int max_brightness;
>  	unsigned int dft_brightness;
>  	unsigned int lth_brightness;

Hi Andrew,

I'm Cc'ing Alexandre Courbot, who has been working on supporting this in
a more generic way using power sequences. Generally this kind of support
really belongs in the common display framework, but I guess we could add
this one GPIO since it really is related only to the backlight. Usually
more than just an enable for the backlight is required so I'm not sure
how useful this really is.

Alex, any thought?

Thierry

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNSQzAAoJEN0jrNd/PrOhhM0P/2SCtWwPrmYc5uk5GNW5CHh3
KIc1oKp9wNueIc/Zwej9TMlfQepzBA1eU4rMIxRveU+MTF+TGIdujF2dn3MMYaE/
chI194DfDjDdCgHFUtxbzdsBu/HQJ03WHIyJMjAfra7hEZIjSmMrAP8ApXwwgkfS
J4l4E1RGQYP8fBUQk3V1nUBpB+Epk5fKL9z1lOG8VSL4TP5GGxa0QfwFzvUwi93Z
s4B6Gf7tx/9BP7QWMp48XkMpzay05PhVGUyKRgmuMZ3jU0Ne5o9ooy2iXl+m3D0r
Q/KgYxPj/P4Sip0q4hxEAQP7o5NSsl6F2fa+EOI3R46wQj0V1LfJhAwsP0q1IlJN
OwOSOc7iydRBUikHfOf4aJqpNQMHzmgXVdC+Jk6E+YabR7p3Mr0zUiBrOPTKaUQw
owECEWuIkwlMKpP+NAr+Ez+u/vPpjVU4qYDhI8O/EpgkXRK9mSUFllnejO3oqTJm
mSS2Fi7/MotJaT8xi1APmO5SGbJhAqFwp4OuaFAFrWWmCPr8yNtPd75ThNUSfRiP
WfAh5XKbhuykxqygW3ySeMKx4lKVhllETO8oqIeWt2VeWbIkzR8aW9O0gqiC6hw0
WviURMIT7vwHVcVDZiTAfeZh58Rkc+JQeriG2YV5Y7uRGlIS1GbKAvMBsvP4uJzH
LvNhLgJn7aGNqkToGupg
=PrHc
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
