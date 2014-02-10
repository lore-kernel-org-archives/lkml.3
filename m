Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBJNQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:16:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39998 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaBJNQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:16:09 -0500
Date: Mon, 10 Feb 2014 13:15:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de
Message-ID: <20140210131557.GB1757@sirena.org.uk>
References: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ERHfpFOxJvIsVBXy"
Content-Disposition: inline
In-Reply-To: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: anatop: Add power gating support to
 digital LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ERHfpFOxJvIsVBXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2014 at 03:43:32PM +0100, Philipp Zabel wrote:
> The ARM, PU, and SOC LDOs in the i.MX6 PMU can completely gate
> their power output. Since power gating is configured by writing
> zero to the voltage target bitfield,, store a copy of the
> voltage selector to be restored when reenabling the regulator.

This is mostly good but...

>  static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
>  					unsigned selector)
>  {
>  	struct anatop_regulator *anatop_reg =3D rdev_get_drvdata(reg);
> +	int ret;
> =20
>  	if (!anatop_reg->control_reg)
>  		return -ENOTSUPP;
> =20
> -	return regulator_set_voltage_sel_regmap(reg, selector);
> +	ret =3D regulator_set_voltage_sel_regmap(reg, selector);
> +	if (!ret)
> +		anatop_reg->sel =3D selector;
> +	return ret;
>  }

=2E..I don't understand this.  If the regulator is disabled won't this
cause it to be reenabled since we just write the stored selector in to
do that?  What I'd expect to see happening is the data being written to
the cache always and only written to the hardware if it's enabled.

> +static int anatop_regmap_disable(struct regulator_dev *reg)
> +{
> +	struct anatop_regulator *anatop_reg =3D rdev_get_drvdata(reg);
> +
> +	if (!anatop_is_core_reg(anatop_reg))
> +		return -ENOTSUPP;
> +
> +	return regulator_set_voltage_sel_regmap(reg, LDO_POWER_GATE);
> +}

It's starting to seem like it's worth having separate ops for the core
regulator rather than all these conditionals.

--ERHfpFOxJvIsVBXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+NEKAAoJELSic+t+oim9LNwQAIw86VJOdFzLhVrxa17fP34g
BOP9eqHhqSTNd78hDnw2wQgtp1ggXM+lI+teaXAG/bheaTmurQtHpJJ4IDwzBMMX
RqEXe1dz9n7ofIP170rCuVlCxjDIJCTEP0oFdl3As3v9cvyqXA0ETXc4omsGZeku
LSXh3ItvEFcPE0r02yea6XuZyN7YE8cv7iUUpxmKuOAtLFFaBIfQTSnG0VWMYY3/
yDIp9Kr87mHBLs0fJcG9zs8TbTwBU4MQO7QEgMOSxlVVS5juF/OlbepCG/gHelbi
ewdInr4KbL8Dtxj8hGrtRHLn3N6LKPkDiBIVH8wjdIYMYM4RGZmgPMEZXKXIBnRD
u7aVIUbyRctBickOvA/vDmPMhn5Lmdyf9cUBHfMCgeC+zQSu9u+ReoaSugREQqJq
I+DNsr7pRSu341tn3Xm48vzdo7gQL31uWkNatCCzaNwmUOii3GbSVpEeye7fPtFc
x1oHS2eBJfZLe59ZYPlM6bqJxDDPZXKyTLIzRpohUq3h+Ep2YKHip9+KUdHROfOR
b+2tzQTIxnBQRXjhX1YOlfxOBf972Z9hlgPABkj7XVN1/8/zLJ6Ut+XjTCSf7NgO
4mdlKRH5cysDRmG+oJM9ouoFTXkpvWMGNwcIrzWI6dedGDEpk1Cc83tVK9G+vRdV
Cte2KHlpSZNltm1VI3zP
=VEtO
-----END PGP SIGNATURE-----

--ERHfpFOxJvIsVBXy--
