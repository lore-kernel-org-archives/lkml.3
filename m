Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaF0PB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:01:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33038 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaF0PB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:01:26 -0400
Date: Fri, 27 Jun 2014 16:00:57 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140627150057.GO23300@sirena.org.uk>
References: <201406030212.s532C6YM022573@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pdSIrcRjgC24tZqG"
Content-Disposition: inline
In-Reply-To: <201406030212.s532C6YM022573@swsrvapps-01.diasemi.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pdSIrcRjgC24tZqG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 08:17:03AM +0100, James Ban wrote:

> This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> Converter regulator. It communicates via an I2C bus to the device.

This *still* seems to have all the same problems with inconsistent
handling of the A and B register sets=20

> +	/* Make sure to exit from suspend mode on enable */
> +	if (regulator->reg_rselect =3D=3D DA9211_RSEL_NO_GPIO) {
> +		ret =3D regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_A);
> +		if (ret < 0)
> +			return ret;
> +	}

Here it forces set A if and only if in no GPIO mode but...

> +static int da9211_regulator_set_suspend_voltage(struct regulator_dev *rd=
ev,
> +						int uV)
> +{
> +	struct da9211_regulator *regulator =3D rdev_get_drvdata(rdev);
> +	struct da9211_regulator_info *info =3D regulator->info;
> +	struct da9211 *chip =3D regulator->da9211;
> +	int ret;
> +
> +	ret =3D regulator_map_voltage_linear(rdev, uV, uV);
> +	if (ret < 0)
> +		return ret;
> +
> +	return regmap_update_bits(chip->regmap, info->volt.reg_b,
> +				 info->volt.v_mask, ret);
> +}

=2E..this unconditionally uses set B and...

> +static int da9211_suspend_enable(struct regulator_dev *rdev)
> +{
> +	struct da9211_regulator *regulator =3D rdev_get_drvdata(rdev);
> +	struct da9211_regulator_info *info =3D regulator->info;
> +	struct da9211 *chip =3D regulator->da9211;
> +
> +	/* Select register set B for voltage ramping. */
> +	if (regulator->reg_rselect =3D=3D DA9211_RSEL_NO_GPIO)
> +		return regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_B);
> +	else
> +		return 0;
> +}

=2E..this uses B if not using a GPIO and otherwise reports success without
actually doing anything (which seems buggy).  These behaviours aren't
compatible with each other, set_suspend_voltage() will break if set B is
selected by GPIO for example.

Please either go through and try to make these things all consistent or
(probably better) strip out the suspend and probably GPIO handling for
now, get the bulk of the driver merged, and then come back and try to
deal with those tricky bits.

--pdSIrcRjgC24tZqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrYclAAoJELSic+t+oim9+CcP/3s5pUKpX5aNlCrsPBHFTILY
eXvNLBk+WQXYEL2hHuyQ4//ahgb+d8j4zc2vniqhkLAWtyJ4REYmM2Ft9lXSAQC3
Bymv+qtqNHxRYltOXBoG53gxMh26wuij8Rb333ts448cLkI6mVhQVuLWhl3c8Rgz
QLExRr3kX5b5g+jJ5mdKQusv63tD+55ehhmM7EYlduTsRgO5pYZt/sclk2U2ZdGS
Q2JhUz6yPq1dS4/GP3tkbXl1VRAXCz6vFeQvX2/zcVoNWAQA6Smuu8aVLtu571/W
nau4UChQytDVhEdsnnMz7gOWqopdKfP3duL0Zs6rRJDFiYyxJ28Bj4YJZ2zTbLRd
IiF8up3fIzRrUq9UYzpKsjj5K5rmwUs0vtyvelytdatvGhwY+UtQRVQiyJoQDV2O
ObpsRRe7YautRg7NUYnp732OqXWpunMSyY7yMaRAZzd/9mDzvtW3cocCtq0CCvPH
WiLqAohbypEkzs4Ml4GsZfJjLMu7EMiFRn3I6f7/faMrDnU+yFHN0MINTEa6jPwO
32Fw/DMV1ONcetELn7+CSXRhHJPyDU4cY99uKzzHl8CFmDfJ1n5gwdJZeNwlRd6x
j4zwjoUQGOX7pXv1lWjPmsHLJgVpDoYzIw+Dj3te6E91zv4ar7x4e69kK/R+mPLZ
w9Qm7QwvSljSfd40KvRX
=NBb4
-----END PGP SIGNATURE-----

--pdSIrcRjgC24tZqG--
