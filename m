Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaFATBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:01:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50176 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaFATBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:01:54 -0400
Date: Sun, 1 Jun 2014 20:01:41 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [James Seong-Won Ban]" <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140601190141.GM5099@sirena.org.uk>
References: <201405190656.s4J6uMCD015467@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5TZBROn01cl7bgIF"
Content-Disposition: inline
In-Reply-To: <201405190656.s4J6uMCD015467@swsrvapps-01.diasemi.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5TZBROn01cl7bgIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 02:45:51AM +0100, Opensource [James Seong-Won Ban] wrote:

> This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> Converter regulator. It communicates via an I2C bus to the device.

I'm still really not convinced that the whole handling of the A and B
settings is doing what it's supposed to be doing.  Like I said before I
know another one of your drivers is doing something similar (and not
sharing the code!) but still...

It looks like the driver is basically written so that register set A
must be used when Linux is running and set B must be used in suspend
mode but not everything seems joined up and consistent.

> Signed-off-by: Opensource [James Seong-Won Ban] <james.ban.opensource@diasemi.com>

Please just use your name in signoffs, the "Opensource []" garbage that
your mail system inserts isn't helping.

> +static int da9211_regulator_get_voltage_sel(struct regulator_dev *rdev)
> +{

> +	/*
> +	 * There are two voltage register set A & B for voltage ramping but
> +	 * either one of then can be active therefore we first determine
> +	 * the active register set.
> +	 */
> +	ret = regmap_read(chip->regmap, info->conf.reg, &data);
> +	if (ret < 0)
> +		return ret;

This appears to be picking the active register set...

> +	/*
> +	 * Regulator register set A/B is not selected through GPIO therefore
> +	 * we use default register set A for voltage ramping.
> +	 */
> +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> +		/* Select register set A */
> +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_A);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Set the voltage */
> +		return regmap_update_bits(chip->regmap, info->volt.reg_a,
> +					 info->volt.v_mask, selector);
> +	}

This forces to register set A.

> +	/*
> +	 * Here regulator register set A/B is selected through GPIO.
> +	 * Therefore we first determine the selected register set A/B and
> +	 * then set the desired voltage for that register set A/B.
> +	 */
> +	ret = regmap_read(chip->regmap, info->conf.reg, &data);
> +	if (ret < 0)
> +		return ret;

We don't appear to be controlling this GPIO - this then assumes that the
GPIO can only be used for selecting suspend mode but doesn't impose any
restrictions on this.

> +static int da9211_regulator_set_suspend_voltage(struct regulator_dev *rdev,
> +						int uV)
> +{
> +	struct da9211_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9211_regulator_info *info = regulator->info;
> +	struct da9211 *chip = regulator->da9211;
> +	int ret;
> +
> +	/* Select register set B for suspend voltage ramping. */
> +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_B);
> +		if (ret < 0)
> +			return ret;
> +	}

This appears to immediately change the active register set to set B
which as I said previously is broken; we may not be suspended yet and
clearly we haven't actually applied the desired setting yet either.

--5TZBROn01cl7bgIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTi3iSAAoJELSic+t+oim9BuIP/Aor2CEynJfJAR/MitcinnvV
PDTWDx9HlZNCk6ntHrvlRNI2T2f8glZ3h5Ef1mAbAFyRc98QJWWsPZdECvwAJMKk
2GfzclABTIvk8ido1y67WNyB1egJ32IaIDrVh9Tx4/yvTMgX7IFOBn3Mx0R7vsPC
LKkFGyvQ3uhBGIpj0Gpvm2q+6GnANSsJoNOogeW1a1lN513nIAaAYsLFf6NWpKZs
BP2RcLF9WcwQ4/TS9NJxLwoVa1lA42m/ATtWFPaV6o11/lv7L3kaqzKaX8ryrAY3
XdUrakLB55FVOufv9yPF10OUwMxZI9lMVLWh9Z4+aAGDhUi8QzBAAy/r3rFFLd6+
mbhjexLtFTaA/gegLa8R+Ll5VFhvI/d8diptW9gOd60T/teNsf+UrF7muGq1qS66
lM9IYq6MSQwhhTxSOR7T7Gev8abhqVt6MIdqeW4m3Ytx5qU/lPdDMs1AYrwxKu1v
KzjjK12pQbhFjjNPI+9Zw+ug2eDEiGAkwf+WQOzCM0TTdJUEgxsA4iP+Uybv4bRh
mpXPK1GHvNMHtVhZOo7DC0cqPNznh9IHWdceo9MS1kuh70kPdLROiIoa4rV7bdLN
RVKg9VCJsE70zgkvxwQPMSVERpFM7MX0aJWENIm/iDJlkgUr0LG15Pv7ryL4uO6W
HU8dLK6hU0IroIgi7T7d
=8QF+
-----END PGP SIGNATURE-----

--5TZBROn01cl7bgIF--
