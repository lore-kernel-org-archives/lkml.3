Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3LLQwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:52:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47926 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3LLQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:52:18 -0500
Date: Thu, 12 Dec 2013 16:51:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        vpalatin@chromium.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com
Message-ID: <20131212165149.GO11044@sirena.org.uk>
References: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
 <1386811131-2720-2-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FrxVhwK/bNRjN48l"
Content-Disposition: inline
In-Reply-To: <1386811131-2720-2-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: act8865: add PMIC(Power Management IC)
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FrxVhwK/bNRjN48l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 09:18:49AM +0800, Wenyou Yang wrote:

The main thing with this driver seems to be that it needs a bit of
modernisation to use current kernel features and APIs - there's nothing
terribly wrong from a quick glance through but it needs an update.
Details below.

> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -577,5 +577,12 @@ config REGULATOR_WM8994
>  	  This driver provides support for the voltage regulators on the
>  	  WM8994 CODEC.
> =20
> +config REGULATOR_ACT8865
> +	tristate "Active-semi act8865 voltage regulator"
> +	depends on I2C
> +	help
> +	  This driver controls a active-semi act8865 voltage output
> +	  regulator via I2C bus.
> +

Please keep this and the Makefile sorted.

> +static int act8865_read_reg(struct act8865_data *act8865, u8 reg)
> +{
> +	int ret =3D i2c_smbus_read_byte_data(act8865->client, reg);
> +	if (ret > 0)
> +		ret &=3D 0xff;
> +
> +	return ret;
> +}

Use regmap for register I/O and use the helpers provided by the core.

> +static int act8865_set_voltage_sel(struct regulator_dev *rdev, u32 selec=
tor)
> +{
> +	struct act8865_data *act8865 =3D rdev_get_drvdata(rdev);
> +	int id =3D rdev_get_id(rdev);
> +	u32	reg =3D act8865_vset_reg_addr(act8865, id);

Throughout the file the indentation is a really strange mix of the first
two lines (which are the normal kernel style) and the bottom line (which
isn't).

> +	pr_info("%s: suspend voltage %dmV\n", rdev->desc->name, uV / 1000);

Remove noisy logging like this.

> +		rdev[i] =3D regulator_register(&act8865_reg[id], &config);

devm_regulator_register().

> +static int __init act8865_pmu_init(void)
> +{
> +	return i2c_add_driver(&act8865_pmu_driver);
> +}
> +subsys_initcall(act8865_pmu_init);

module_i2c_driver().

--FrxVhwK/bNRjN48l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqemiAAoJELSic+t+oim9NNMP/1nxmWm8+oZLiMumjYT595+a
/0Ej3iksxmU629Up0bMhjIqGKInS18CQRpbHOnBFKAgfdYjyGxlntMp9njkVzLR2
WoWV0htGsdCQZ6U0L7+UP34IUPbbFt6oUpFGk5+9DwlHwTHo3+aEVnnnh5sziAVR
sSciKmHTAHJloTwWhMYHo7xx48CxZYEuiAXSqH0CZWJA4WTZJBuVUJS7Hztu6UA6
kG9G4NjIpa7h/K72aIIG7lkI8w2Utn1ZZy0TgBQwS0Rq3QnQY1Pgai8sM1JNZpts
vdjEH9iVyQtFw5kDwuhRKyb2Fux0nK8kdrUXzXZmw8y+o1HwrBDRdzbvGX5oowYl
BOT/Iqzzd0B+FU1xinIkPJFXpJpYNzIWyVH88T4MQf0JjqLcnJbOIPnPxC6HXQeY
Qcg0wbiTsktmDuvx9mFiydBAMtNye2OIRf96scWT4k/RfYWgGR7A6ZG/U18Obmrv
IYxxG3g3dWKR0YfstTDSidvYxVfoZXyy9vyYw245yqX6+GPg6odM/bKLohLiKGSx
MtJhS4GV8cGd49ja4iZkP5zbceQ4MU0PxVJoI/oSDQy/q/G6CJ7zve+bLhOOhbJK
BpnCwSGt2EDOt3zPpvMBFytOpZeNqK4/8h90qOInFIwqH1chmbegVaHnazq5dmDS
SeHpQc5EAJYjv0xEy9RX
=idYk
-----END PGP SIGNATURE-----

--FrxVhwK/bNRjN48l--
