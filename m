Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbbAYNxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:53:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:43266 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbbAYNxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:53:47 -0500
Date: Sun, 25 Jan 2015 14:53:40 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH 4/6] power: max77843_battery: Add Max77843 fuel gauge
 device driver
Message-ID: <20150125135340.GC2719@earth.universe>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-5-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1421989367-32721-5-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 23, 2015 at 02:02:45PM +0900, Jaewon Kim wrote:
> From: Beomho Seo <beomho.seo@samsung.com>
>=20
> This patch adds device driver of max77843 fuel gauge.
> The driver support for battery fuel gauge in Maxim Max77843.
> It is fuel-gauge systems for lithuum-ion batteries in handled and
> portable devices.
>=20
> Cc: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> ---
>  drivers/power/Kconfig            |    9 ++
>  drivers/power/Makefile           |    1 +
>  drivers/power/max77843_battery.c |  283 ++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 293 insertions(+)
>  create mode 100644 drivers/power/max77843_battery.c
>=20
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index a054a28..0039bbb 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -212,6 +212,15 @@ config BATTERY_MAX17042
>  	  with MAX17042. This driver also supports max17047/50 chips which are
>  	  improved version of max17042.
> =20
> +config BATTERY_MAX77843
> +	tristate "Maxim MAX77843 Fuel Gauge"
> +	depends on MFD_MAX77843
> +	help
> +	  This add support for battery fuel gauge in Maxim MAX77843.

add -> adds

> +	  It is fuel-gauge systems for lithuum-ion (Li+) batteries in handled a=
nd
> +	  portable devices. The MAX17040 is configured to operate with a single
> +	  lithium cell.

It is a fuel-gauge for a lithium-ion batteries with a single
cell and can be found in portable devices.

> +
>  config BATTERY_Z2
>  	tristate "Z2 battery driver"
>  	depends on I2C && MACH_ZIPIT2
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 212c6a2..ae0d795 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_BATTERY_DA9030)	+=3D da9030_battery.o
>  obj-$(CONFIG_BATTERY_DA9052)	+=3D da9052-battery.o
>  obj-$(CONFIG_BATTERY_MAX17040)	+=3D max17040_battery.o
>  obj-$(CONFIG_BATTERY_MAX17042)	+=3D max17042_battery.o
> +obj-$(CONFIG_BATTERY_MAX77843)	+=3D max77843_battery.o
>  obj-$(CONFIG_BATTERY_Z2)	+=3D z2_battery.o
>  obj-$(CONFIG_BATTERY_S3C_ADC)	+=3D s3c_adc_battery.o
>  obj-$(CONFIG_BATTERY_TWL4030_MADC)	+=3D twl4030_madc_battery.o
> diff --git a/drivers/power/max77843_battery.c b/drivers/power/max77843_ba=
ttery.c
> new file mode 100644
> index 0000000..a08dd0c
> --- /dev/null
> +++ b/drivers/power/max77843_battery.c
> @@ -0,0 +1,283 @@
> +/*
> + * Fuel gauge driver for Maxim MAX77843
> + *
> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/power_supply.h>
> +#include <linux/mfd/max77843-private.h>
> +
> +struct max77843_battery {
> +	struct device		*dev;
> +	struct max77843		*max77843;
> +	struct i2c_client	*client;
> +	struct regmap		*regmap;
> +	struct power_supply	psy;
> +};
> +
> +static int max77843_battery_get_capacity(struct max77843_battery *batter=
y)
> +{
> +	struct regmap *regmap =3D battery->regmap;
> +	int ret, val;
> +	u8 reg_data[2];
> +
> +	ret =3D regmap_bulk_read(regmap, MAX77843_FG_REG_SOCREP, reg_data, 2);
> +	if (ret) {
> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
> +		return ret;
> +	}
> +
> +	val =3D  ((reg_data[1] * 100) + (reg_data[0] * 100 / 256)) / 100;

so

val =3D reg_data[1]?

> +	return val;
> +}
> +
> +static int max77843_battery_get_energy_prop(struct max77843_battery *bat=
tery,
> +		enum power_supply_property psp)
> +{
> +	struct regmap *regmap =3D battery->regmap;
> +	unsigned int reg;
> +	int ret, val;
> +	u8 reg_data[2];
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_ENERGY_FULL:
> +		reg =3D MAX77843_FG_REG_FULLCAP;
> +		break;
> +	case POWER_SUPPLY_PROP_ENERGY_NOW:
> +		reg =3D MAX77843_FG_REG_REMCAP_REP;
> +		break;
> +	case POWER_SUPPLY_PROP_ENERGY_AVG:
> +		reg =3D MAX77843_FG_REG_REMCAP_AV;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret =3D regmap_bulk_read(regmap, reg, reg_data, 2);
> +	if (ret) {
> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
> +		return ret;
> +	}
> +
> +	val =3D (reg_data[1] << 8) | reg_data[0];
> +
> +	return val;
> +}
> +
> +static int max77843_battery_get_current_prop(struct max77843_battery *ba=
ttery,
> +		enum power_supply_property psp)
> +{
> +	struct regmap *regmap =3D battery->regmap;
> +	unsigned int reg;
> +	int ret, val;
> +	u8 reg_data[2];
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +		reg =3D MAX77843_FG_REG_CURRENT;
> +		break;
> +	case POWER_SUPPLY_PROP_CURRENT_AVG:
> +		reg =3D MAX77843_FG_REG_AVG_CURRENT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret =3D regmap_bulk_read(regmap, reg, reg_data, 2);
> +	if (ret) {
> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
> +		return ret;
> +	}
> +
> +	val =3D (reg_data[1] << 8) | reg_data[0];
> +	if (val & 0x8000) {
> +		/* Negative */
> +		val =3D ~val & 0xffff;
> +		val++;
> +		val *=3D -1;
> +	}
> +	/* Unit of current is mA */
> +	val =3D  val * 15625 / 100000;
> +
> +	return val;
> +}
> +
> +static int max77843_battery_get_voltage_prop(struct max77843_battery *ba=
ttery,
> +		enum power_supply_property psp)
> +{
> +	struct regmap *regmap =3D battery->regmap;
> +	unsigned int reg;
> +	int ret, val;
> +	u8 reg_data[2];
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		reg =3D MAX77843_FG_REG_VCELL;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
> +		reg =3D MAX77843_FG_REG_AVG_VCELL;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
> +		reg =3D MAX77843_FG_REG_OCV;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret =3D regmap_bulk_read(regmap, reg, reg_data, 2);
> +	if (ret) {
> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
> +		return ret;
> +	}
> +
> +	val =3D ((reg_data[1] << 4) + (reg_data[0] >> 4)) * 125;
> +	val /=3D 100;
> +
> +	return val;
> +}
> +
> +static const char *model_name =3D "MAX77843";
> +static const char *manufacturer =3D "Maxim Integrated";
> +
> +static int max77843_battery_get_property(struct power_supply *psy,
> +		enum power_supply_property psp,
> +		union power_supply_propval *val)
> +{
> +	struct max77843_battery *battery =3D container_of(psy,
> +				struct max77843_battery, psy);
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
> +	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
> +		val->intval =3D max77843_battery_get_voltage_prop(battery, psp);
> +		break;
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +	case POWER_SUPPLY_PROP_CURRENT_AVG:
> +		val->intval =3D max77843_battery_get_current_prop(battery, psp);
> +		break;
> +	case POWER_SUPPLY_PROP_ENERGY_FULL:
> +	case POWER_SUPPLY_PROP_ENERGY_NOW:
> +	case POWER_SUPPLY_PROP_ENERGY_AVG:
> +		val->intval =3D max77843_battery_get_energy_prop(battery, psp);
> +		break;
> +	case POWER_SUPPLY_PROP_CAPACITY:
> +		val->intval =3D max77843_battery_get_capacity(battery);
> +		break;
> +	case POWER_SUPPLY_PROP_MODEL_NAME:
> +		val->strval =3D  model_name;
> +		break;
> +	case POWER_SUPPLY_PROP_MANUFACTURER:
> +		val->strval =3D manufacturer;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static enum power_supply_property max77843_battery_props[] =3D {
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_VOLTAGE_AVG,
> +	POWER_SUPPLY_PROP_VOLTAGE_OCV,
> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_AVG,
> +	POWER_SUPPLY_PROP_ENERGY_FULL,
> +	POWER_SUPPLY_PROP_ENERGY_NOW,
> +	POWER_SUPPLY_PROP_ENERGY_AVG,
> +	POWER_SUPPLY_PROP_CAPACITY,
> +	POWER_SUPPLY_PROP_MODEL_NAME,
> +	POWER_SUPPLY_PROP_MANUFACTURER,
> +};
> +
> +static const struct regmap_config max77843_fuel_regmap_config =3D {
> +	.reg_bits	=3D 8,
> +	.val_bits	=3D 8,
> +	.max_register	=3D MAX77843_FG_END,
> +};

You always read 2 bytes, so it seems the device uses 16 bit sized
values?

> +static int max77843_battery_probe(struct platform_device *pdev)
> +{
> +	struct max77843 *max77843 =3D dev_get_drvdata(pdev->dev.parent);
> +	struct max77843_battery *battery;
> +	int ret;
> +
> +	battery =3D devm_kzalloc(&pdev->dev, sizeof(*battery), GFP_KERNEL);
> +	if (!battery)
> +		return -ENOMEM;
> +
> +	battery->dev =3D &pdev->dev;
> +	battery->max77843 =3D max77843;
> +
> +	battery->client =3D i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_FG);
> +	if (!battery->client) {
> +		dev_err(&pdev->dev, "Failed to get dummy i2c client.\n");
> +		return PTR_ERR(battery->client);
> +	}
> +	i2c_set_clientdata(battery->client, max77843);
> +
> +	battery->regmap =3D devm_regmap_init_i2c(battery->client,
> +			&max77843_fuel_regmap_config);
> +	if (IS_ERR(battery->regmap)) {
> +		ret =3D PTR_ERR(battery->regmap);
> +		goto err_i2c;
> +	}
> +
> +	platform_set_drvdata(pdev, battery);
> +
> +	battery->psy.name	=3D "max77843-fuelgauge";
> +	battery->psy.type	=3D POWER_SUPPLY_TYPE_BATTERY;
> +	battery->psy.get_property	=3D max77843_battery_get_property;
> +	battery->psy.properties		=3D max77843_battery_props;
> +	battery->psy.num_properties	=3D ARRAY_SIZE(max77843_battery_props);
> +
> +	ret =3D power_supply_register(&pdev->dev, &battery->psy);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed  to register power supply\n");
> +		goto err_i2c;
> +	}
> +
> +	return 0;
> +
> +err_i2c:
> +	i2c_unregister_device(battery->client);

This is missing in max77843_battery_remove()

> +
> +	return ret;
> +}
> +
> +static int max77843_battery_remove(struct platform_device *pdev)
> +{
> +	struct max77843_battery *battery =3D platform_get_drvdata(pdev);
> +
> +	power_supply_unregister(&battery->psy);
> +
> +	return 0;
> +}

> [...]

-- Sebastian

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUxPVhAAoJENju1/PIO/qa3DgQAI7j4rAmqprvh4vkdkIeb3kz
TMCG8QD1iibC+s31xki+r/E57Ooc2AdbqtRNCRnuyp/9kb6D8H8shFCaWAYktkIZ
KxpnED6riJ5vPPc830H+vHI7HLZPiCyseNDIOgy5Y0Hkh6I2R6EdtJMct/ispyao
1H1eNxHVppItlLVyAdsq6CsocK9yYdyP4MemvlHwuEeb1c9V9XzPFKVkWmvTOvG9
tNHWLyDPg8nYYHbbL2npLiy3zvjKhQx7IUbj89qJZoS6abT2C/3Qq7RVu/QW8qu4
MvmF9t9fpNIs7dA49KNmcwubzZ2jNFsFcrbd6sS9KKne0ax1WZ0fANQrlIAcPlZ3
4k6lHHAABjtlNLDwpAg3DXDStl3loOL+kHiD6iZLOfv9GEiDsylLV+Bc3KR5cIop
ZenJo79fZawFuWJ0mwe6rqkHKDerRu0DHiuk9T2PlUtAgSzVKkRqT4q1bmWgWN/+
jDMHgfkQAcAQLiNG569NDgZL3ITBZ7rZ6x/QqHEqQc9H2VIItLQ4VW0Uwjcbo1EV
PwtKCCHLURJWadSTvB+iKxkvDXgfeZtLr6yJcAcbXEfixgdaRACRXR5yKT/WS1mW
zPeaP0zrXGBKzS5aeFi+QgKm5AKb8Lr7iBhbpnPU9l5gbifgo7aC3IItVMAvbTQB
BgeyJLyNzAtQNVqegYaN
=7F8D
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
