Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaD3G5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:57:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaD3G5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:57:05 -0400
Date: Wed, 30 Apr 2014 08:56:55 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: mark.rutland@arm.com, broonie@kernel.org, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] regmap: add DT endianness binding support.
Message-ID: <20140430065655.GE15179@pengutronix.de>
References: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
 <1398833029-29546-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Content-Disposition: inline
In-Reply-To: <1398833029-29546-3-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:39:19 up 7 days, 10 min, 31 users,  load average: 0.01, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 30, 2014 at 12:43:49PM +0800, Xiubo Li wrote:
[...]
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 8e8cea1..946e901 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -15,6 +15,7 @@
>  #include <linux/export.h>
>  #include <linux/mutex.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
>  #include <linux/rbtree.h>
>  #include <linux/sched.h>
> =20
> @@ -422,6 +423,132 @@ static void regmap_range_exit(struct regmap *map)
>  	kfree(map->selector_work_buf);
>  }
> =20
> +enum regmap_endian_type {
> +	REGMAP_ENDIAN_REG,
> +	REGMAP_ENDIAN_VAL,
> +};
> +
> +/**
> + * of_regmap_endian_by_type() - Parse and lookup the endian referenced
> + * by a device node
> + * @np: pointer to clock consumer node

This is not the clock consumer, right?

> + * @type: type of consumer's endian input
> + *
> + * This function parses the device endian property, and uses them to
> + * determine the endian of the registers and values.
> + */
> +static int of_regmap_endian_by_type(struct device_node *np,
> +					enum regmap_endian_type type,
> +					enum regmap_endian *endian)
> +{
> +	if (!endian)
> +		return -EINVAL;
> +
> +	switch (type) {
> +	case REGMAP_ENDIAN_REG:
> +		if (of_property_read_bool(np, "big-endian-reg"))
> +			*endian =3D REGMAP_ENDIAN_BIG;
> +		else if (of_property_read_bool(np, "little-endian-reg"))
> +			*endian =3D REGMAP_ENDIAN_LITTLE;
> +		else
> +			*endian =3D REGMAP_ENDIAN_NATIVE;

You could also return an error code here as there was no DT property
found. This doesn't change to much in the code, just an idea.

Regards,

Markus

> +		break;
> +	case REGMAP_ENDIAN_VAL:
> +		if (of_property_read_bool(np, "big-endian-val"))
> +			*endian =3D REGMAP_ENDIAN_BIG;
> +		else if (of_property_read_bool(np, "little-endian-val"))
> +			*endian =3D REGMAP_ENDIAN_LITTLE;
> +		else
> +			*endian =3D REGMAP_ENDIAN_NATIVE;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int of_regmap_get_endian(struct device *dev,
> +				const struct regmap_bus *bus,
> +				const struct regmap_config *config,
> +				enum regmap_endian_type type,
> +				enum regmap_endian *endian)
> +{
> +	int ret;
> +
> +	if (!endian || !config)
> +		return -EINVAL;
> +
> +	/*
> +	 * Firstly, try to parse the endian from driver's config,
> +	 * this is to be compatible with the none DT or the old drivers.
> +	 * From the driver's config the endian value maybe:
> +	 *   REGMAP_ENDIAN_BIG,
> +	 *   REGMAP_ENDIAN_LITTLE,
> +	 *   REGMAP_ENDIAN_NATIVE,
> +	 *   REGMAP_ENDIAN_DEFAULT.
> +	 */
> +	switch (type) {
> +	case REGMAP_ENDIAN_REG:
> +		*endian =3D config->reg_format_endian;
> +		break;
> +	case REGMAP_ENDIAN_VAL:
> +		*endian =3D config->val_format_endian;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * If the endian parsing from driver's config is REGMAP_ENDIAN_DEFAULT,
> +	 * that means maybe we are using the DT node to specify the endianness.
> +	 */
> +	if (*endian !=3D REGMAP_ENDIAN_DEFAULT)
> +		return 0;
> +
> +	/*
> +	 * Secondly, try to parse the endian from DT node if the
> +	 * driver config does not specify it.
> +	 * From the DT node the endian value maybe:
> +	 *   REGMAP_ENDIAN_BIG,
> +	 *   REGMAP_ENDIAN_LITTLE,
> +	 *   REGMAP_ENDIAN_NATIVE,
> +	 */
> +	if (dev) {
> +		ret =3D of_regmap_endian_by_type(dev->of_node, type, endian);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/*
> +	 * If the endian parsing from DT node is REGMAP_ENDIAN_NATIVE, that
> +	 * maybe means the DT does not care the endianness or it should use
> +	 * the regmap bus's default endianness, then we should try to check
> +	 * whether the regmap bus has specified the default endianess.
> +	 */
> +	if (*endian !=3D REGMAP_ENDIAN_NATIVE)
> +		return 0;
> +
> +	/*
> +	 * Finally, try to parse the endian from regmap bus config
> +	 * if in device's DT node the endian property is absent.
> +	 */
> +	switch (type) {
> +	case REGMAP_ENDIAN_REG:
> +		if (bus && bus->reg_format_endian_default)
> +			*endian =3D bus->reg_format_endian_default;
> +		break;
> +	case REGMAP_ENDIAN_VAL:
> +		if (bus && bus->val_format_endian_default)
> +			*endian =3D bus->val_format_endian_default;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * regmap_init(): Initialise register map
>   *
> @@ -518,17 +645,15 @@ struct regmap *regmap_init(struct device *dev,
>  		map->reg_read  =3D _regmap_bus_read;
>  	}
> =20
> -	reg_endian =3D config->reg_format_endian;
> -	if (reg_endian =3D=3D REGMAP_ENDIAN_DEFAULT)
> -		reg_endian =3D bus->reg_format_endian_default;
> -	if (reg_endian =3D=3D REGMAP_ENDIAN_DEFAULT)
> -		reg_endian =3D REGMAP_ENDIAN_BIG;
> -
> -	val_endian =3D config->val_format_endian;
> -	if (val_endian =3D=3D REGMAP_ENDIAN_DEFAULT)
> -		val_endian =3D bus->val_format_endian_default;
> -	if (val_endian =3D=3D REGMAP_ENDIAN_DEFAULT)
> -		val_endian =3D REGMAP_ENDIAN_BIG;
> +	ret =3D of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
> +				   &reg_endian);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret =3D of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
> +				   &val_endian);
> +	if (ret)
> +		return ERR_PTR(ret);
> =20
>  	switch (config->reg_bits + map->reg_shift) {
>  	case 2:
> --=20
> 1.8.4
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTYJ62AAoJEEpcgKtcEGQQxr4P/05/9efvgXzcnzeMq25ZnswO
uj85QAvwiaVRD+4YeMoGAlv9N4McWi2o5239BC5odUK30GD5tNPtvXgqadDWYyCr
XhWF6cPEicphPc71gZnQNYYPqSLmvNCA88BkTkaz/CBHZQ5VgmUB/kaLRPWdJDSx
UPSiNWc3nfloJ4nsqGGQukvZAumUOsnjHlhac65c9SggehYjimX72XWbgcdAFAdZ
9S4g9r5Ro71b+/BQGpMhO15n0O78eAHPFuHoZU3l7SAwLe7oD+lu34B6etD/mssA
DyGclcchnDjItYs25g3WWOU9HY3H8W0tPHrHRPXOrc0Q67w4KWyuYq86wF2Vam7a
X3TzLi5owGFaxFtGLlipHWLm/nO+t0pjBDrZiXheeym/fmtXfu+J/KaK2RHAxOda
AdLpluiXECymqjRDXKiZVLx2ETOSAATGjg1n1FvUYU+gWaqAo3liZ2g57YIPpBFc
hzN7eyypy/wlDek6jrd5HiW7g2uH6CMHvC6K2+ByBa81HBvD0MAj6aTrAgmfUtkC
et9+Ze9uCY99R8spGpMaCgXYeKyr5dJ2OCn6792o3VHnyJ6a95NwNYY0i1lGzQnd
oQ2StHEhwPYqUWfDgq572gOKg8E5oZQLoV8p2mdvPkDnJRC0+7RKGG7QfytehlGw
l9cl3I2Xbj/4lID4FT62
=B5Up
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--
