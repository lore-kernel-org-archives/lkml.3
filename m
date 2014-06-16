Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaFPTZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:25:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44243 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaFPTZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:25:45 -0400
Date: Mon, 16 Jun 2014 20:25:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140616192500.GJ5099@sirena.org.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MmzhKBr7cvVIsstX"
Content-Disposition: inline
In-Reply-To: <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MmzhKBr7cvVIsstX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 08:02:35PM +0200, Javier Martinez Canillas wrote:

> --- a/drivers/mfd/max77802.c
> +++ b/drivers/mfd/max77802.c
> @@ -37,6 +37,7 @@
>  #include <linux/err.h>
> =20
>  static const struct mfd_cell max77802_devs[] =3D {
> +	{ .name =3D "max77802-pmic", },
>  };
> =20
>  static bool max77802_pmic_is_accessible_reg(struct device *dev,

Please don't do things like this, it makes it harder to apply your
series.  Just register all the devices in the MFD when you add the MFD
driver.

> +	default:
> +		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
> +			rdev->desc->name, mode);
> +		return -EINVAL;

dev_warn().

> +static void max77802_copy_reg(struct device *dev, struct regmap *regmap,
> +			      int from_reg, int to_reg)
> +{
> +	int val;
> +	int ret;
> +
> +	if (from_reg =3D=3D to_reg)
> +		return;
> +
> +	ret =3D regmap_read(regmap, from_reg, &val);
> +	if (!ret)
> +		ret =3D regmap_write(regmap, to_reg, val);
> +
> +	if (ret)
> +		dev_warn(dev, "Copy err %d =3D> %d (%d)\n",
> +			 from_reg, to_reg, ret);
> +}

Again, this looks like it should be generic.

> +static int max77802_pmic_probe(struct platform_device *pdev)
> +{

> +	dev_dbg(&pdev->dev, "%s\n", __func__);

This isn't adding anything, just remove it - the core already logs
probes if you want.

> +	config.dev =3D &pdev->dev;

Are you sure this shouldn't be the MFD?

> +	for (i =3D 0; i < MAX77802_MAX_REGULATORS; i++) {
> +		struct regulator_dev *rdev;
> +		int id =3D pdata->regulators[i].id;
> +
> +		config.init_data =3D pdata->regulators[i].initdata;
> +		config.of_node =3D pdata->regulators[i].of_node;
> +
> +		max77802->opmode[id] =3D MAX77802_OPMODE_NORMAL;

Why isn't this being read from the hardware, this may lead to a
configuration change the first time we pay attention?

--MmzhKBr7cvVIsstX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn0SIAAoJELSic+t+oim9E20P/35IuJBmgJxhAznpLcstFe9J
ZmLvNWxRuf/Ofl97sD0O3e54M+pxhlAR9DgRKGxBYbZmrc7wW5nmpcZ5Z9e1A2Cc
5UfljaITnYtK+toYzCdRnkWKTeeCCwRXQNMF3X03PDgU1NcHIvxOu9dfqctRG5BL
HoDFZxnGY5lZsFuu3ZVI5FFmi/nWxoNQ5Gg1tCYtFzO/0AGdPgTVBCA6c7Oj/wmM
Gx5NCImhayBljy6S5FP5SPlvKCbwpExr9rOXPRwfJ/FDnc2VNbciM5R9GMikJ8cX
fW2MSjieGwqp1BQmVIcixM2b5iaakzRxWhglWUy4omXdUu/cum1HuO0zuGRDQIgC
eVpW8DZZytvAsxa2HcBQWZTbQMCcIeRIl6kRA03WY2meDoqaVI8O5WsoGlGyKCgz
+uJsMbvfOpv0IayRJTFOSQ1tL8TnA6EmpIAcC7bPdh8vJFgv/duzx53Nqbeyg142
pP51sxRe9g0aMRe0t7opaHpfZUi9gQ+9ovABwAN4kdLJEx0JGxBR9SrzTz1YFC/6
hY4ISauMVVUUGeZ1CpvZYpjWrcrb6gE8vuQHcN6FTOUW7r+gVhNH0Ymg+z7hjaCr
1HF0OvUSXM1y2hr6t55mw5oTdJBaaBKplSdTVQYrW5eoXFpNy7lHynjLSDk+cYiH
TcJQq/1pW97kyqnTVWcO
=Gno6
-----END PGP SIGNATURE-----

--MmzhKBr7cvVIsstX--
