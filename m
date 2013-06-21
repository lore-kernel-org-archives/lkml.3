Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423220Ab3FUPPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:15:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59275 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423118Ab3FUPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:15:28 -0400
Date: Fri, 21 Jun 2013 16:15:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130621151523.GA27646@sirena.org.uk>
References: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apg+fY3UKMMABzWO"
Content-Disposition: inline
In-Reply-To: <201306201454.r5KEsAAS010978@swsrvapps-01.diasemi.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] COMMIT 1: DA9210 driver files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--apg+fY3UKMMABzWO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 02:42:03PM +0100, Steve Twiss wrote:

> @@ -293,6 +293,13 @@ config REGULATOR_LP8788
>  	help
>  	  This driver supports LP8788 voltage regulator chip.
> =20
> +config REGULATOR_DA9210
> +	bool "Dialog Semiconductor DA9210 Regulator"
> +	depends on I2C=3Dy
> +	select REGMAP_I2C
> +	help
> +	  Support for the Dialog Semiconductor DA9210 chip.
> +
>  config REGULATOR_PCF50633

This file ought to be kept sorted though it seems that's not been
happening, and I'm not seeing any reason why this can't be a tristate.

> +#define DRIVER_NAME	"da9210"

Why?

> +struct da9210 {
> +	struct i2c_client *i2c;
> +	struct device *dev;
> +	struct mutex io_mutex;

Why do you need an I/O lock?

> +static int da9210_enable(struct regulator_dev *rdev);
> +static int da9210_set_voltage(struct regulator_dev *rdev, int min_uV,
> +			      int max_uV, unsigned *selector);
> +static int da9210_get_voltage(struct regulator_dev *rdev);
> +static int da9210_set_current_limit(struct regulator_dev *rdev, int min_=
uA,
> +				    int max_uA);
> +static int da9210_get_current_limit(struct regulator_dev *rdev);
> +
> +static struct regulator_ops da9210_buck_ops =3D {
> +	.enable =3D da9210_enable,
> +	.disable =3D regulator_disable_regmap,
> +	.is_enabled =3D regulator_is_enabled_regmap,
> +	.set_voltage =3D da9210_set_voltage,
> +	.get_voltage =3D da9210_get_voltage,
> +	.list_voltage =3D regulator_list_voltage_linear,
> +	.set_current_limit =3D da9210_set_current_limit,
> +	.get_current_limit =3D da9210_get_current_limit,
> +};

Drivers are normally written to avoid forward declarations like this.

> +static struct regulator_consumer_supply __initdata def_da9210_consumers[=
] =3D {
> +	REGULATOR_SUPPLY("DA9210", NULL),
> +};
> +
> +static struct regulator_init_data __initdata default_da9210_constraints =
=3D {
> +	.constraints =3D {

This is not at all sensible, there's a good solid reason why regulator
drivers don't generally do this...  please review the machine interface
and its purpose.

> +static int da9210_set_voltage(struct regulator_dev *rdev, int min_uV,
> +			      int max_uV, unsigned *selector)
> +{
> +	struct da9210 *chip =3D rdev_get_drvdata(rdev);
> +	int val;
> +	int ret;
> +
> +	val =3D regulator_map_voltage_linear(rdev, min_uV, max_uV);
> +	if (val < 0)
> +		return -EINVAL;
> +
> +	ret =3D regmap_update_bits(chip->regmap, DA9210_REG_VBUCK_A,
> +				 DA9210_VBUCK_MASK, val);
> +	return ret;
> +}

Why not just use set_voltage_sel()?

> +static int da9210_get_voltage_sel(struct regulator_dev *rdev)
> +{
> +	struct da9210 *chip =3D rdev_get_drvdata(rdev);
> +	unsigned int data;
> +	int sel;
> +	int ret;
> +
> +	ret =3D regmap_read(chip->regmap, DA9210_REG_VBUCK_A, &data);
> +	if (ret < 0)
> +		return ret;
> +
> +	sel =3D (data & DA9210_VBUCK_MASK) >> DA9210_VBUCK_SHIFT;
> +	sel -=3D DA9210_VBUCK_BIAS;
> +	if (sel < 0)
> +		sel =3D 0;
> +	if (sel >=3D chip->info->n_steps)
> +		sel =3D chip->info->n_steps - 1;

This looks like poor error handling, if the value is out of range isn't
there an error state?

> +static int da9210_get_voltage(struct regulator_dev *rdev)
> +{
> +	struct da9210 *chip =3D rdev_get_drvdata(rdev);
> +	int sel =3D da9210_get_voltage_sel(rdev);
> +
> +	if (sel < 0)
> +		return sel;
> +
> +	return (chip->info->step_uV * sel) + chip->info->min_uV;
> +}

Why are you open coding core functionalit?

> +static int da9210_enable(struct regulator_dev *rdev)
> +{
> +	return regulator_enable_regmap(rdev);
> +}

This is pointless, just use the generic function directly.

> +
> +	dev_info(chip->dev, "Device DA9210 detected.\n");

This is just noise.

> +static const struct i2c_device_id da9210_i2c_id[] =3D {
> +	{DRIVER_NAME, 0},
> +	{},

Just use the string.

> +static struct i2c_driver da9210_regulator_driver =3D {
> +	.driver =3D {
> +		.name =3D DRIVER_NAME,

Similarly here.

> +		.owner =3D THIS_MODULE,
> +		},

Indentation.

> +static int __init da9210_regulator_init(void)
> +{
> +	int ret;
> +
> +	ret =3D i2c_add_driver(&da9210_regulator_driver);
> +	if (0 !=3D ret)
> +		pr_err("Failed to register da9210 I2C driver\n");
> +
> +	return ret;
> +}
> +
> +subsys_initcall(da9210_regulator_init);

Just use module_platform_driver() now we have probe deferral.

> +/*
> + * Registers bits
> + */
> +/* DA9210_REG_PAGE_CON (addr=3D0x00) */
> +#define	DA9210_PEG_PAGE_SHIFT			0
> +#define	DA9210_REG_PAGE_MASK			0x0F
> +/* On I2C registers 0x00 - 0xFF */
> +#define	DA9210_REG_PAGE0			0
> +/* On I2C registers 0x100 - 0x1FF */
> +#define	DA9210_REG_PAGE2			2
> +#define	DA9210_PAGE_WRITE_MODE			0x00
> +#define	DA9210_REPEAT_WRITE_MODE		0x40
> +#define	DA9210_PAGE_REVERT			0x80

This looks liike you should be using a regmap range.

--apg+fY3UKMMABzWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxG4IAAoJELSic+t+oim9plAP/jVKJZQ58eXc1Txt99zsWCFb
JJKATx8NDrbcF8KJHojTtamHEYFwz+LEPTmKRAiKNXgUqBgYEiPNpv6SEWJTTIaf
P+s0fJ6dRllySML3bYjsz8S8bNvwvfFJl3oqhhghXAS7Fof6nhheH8VyKoBDzkVE
K3Xb8e384CHx1K9lUX8x8bOIY0fssv00DvPGLUVsf8T/76jH/4IqNvmQhv8P3pf9
CiXO/bEKqAAa2V2rJZiAhU7euEo4fCgOX3JYgufwTejg0nvhgELb/0jZw35byO0f
bIdeZVtThtt0VkZfWTzfw3u3Z9hOvvWYoqJQp1JnLUO/Q1Rys/I/GXsS3g34OH5x
kla6uICrD7E4sNtKXAmJ1/RFmWqx1loJMKt7Cw+pvjAZXvLg80Obv3jqYi0tIdzG
atd9+ZRgKvrD3kKAZTIF/mIKpH5+r58awnEQ0FQeOBNcX1sEVqaqX8Eox06ecWyo
1XxCTX9WplQRP1hRyNbRbKIoQoZ0vkhKF2JpNJhwMDQbagpYc9OF8auMvgZK+cX2
dtYiEIYEeq2Ysn38Yw8PTWC3EoEmNhPudBEnrp3q+ecHH2tfjc7At4QOPUuDdr+k
h61HOm+fLSwSpuQeXn3OgMC5vwKJkAp5De5pWBoEEFeH7ZCaCXWxDnIiO0UdRRvj
yTmjvKVgHaJTohA2Co5P
=6dW1
-----END PGP SIGNATURE-----

--apg+fY3UKMMABzWO--
