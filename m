Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDOWw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:52:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaDOWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:52:52 -0400
Date: Tue, 15 Apr 2014 23:52:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140415225210.GK12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397592876-5741-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ef8eQmdvO1j1gFMO"
Content-Disposition: inline
In-Reply-To: <1397592876-5741-4-git-send-email-dianders@chromium.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: tps65090: Make FETs more reliable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ef8eQmdvO1j1gFMO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 01:14:36PM -0700, Doug Anderson wrote:

> Mitigate the problem by:
> * Allow setting the overcurrent wait time so devices with this problem
>   can set it to the max.
> * Add retry logic on enables of FETs.

This is two changes, should really be two patches.

> +- ti,overcurrent-wait: This is applicable to FET registers, which have a
> +  poorly defined "overcurrent wait" field.  If this property is present it
> +  should be between 0 - 3.  If this property isn't present we won't touch the
> +  "overcurrent wait" field and we'll leave it to the BIOS/EC to deal with.

I take it this is the raw value to write to the register?

> +static int tps65090_fet_is_enabled(struct regulator_dev *rdev)
> +{
> +	unsigned int control;
> +	unsigned int expected = rdev->desc->enable_mask | BIT(CTRL_PG_BIT);
> +	int ret;
> +
> +	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &control);
> +	if (ret != 0)
> +		return ret;
> +
> +	return (control & expected) == expected;
> +}

No need to open code this, regulator_is_enabled_regmap() can check for
any value in a bitfield.

> +static int tps6090_try_enable_fet(struct regulator_dev *rdev)

Why is this called tps6090_try_enable_fet(), looks like a missing 5?

> +	/*
> +	 * Try enabling multiple times until we succeed since sometimes the
> +	 * first try times out.
> +	 */
> +	for (tries = 0; ; tries++) {
> +		ret = tps6090_try_enable_fet(rdev);
> +		if (!ret)
> +			break;
> +		if (ret != -ENOTRECOVERABLE || tries == MAX_FET_ENABLE_TRIES)
> +			goto err;

Make this a do { } while so we don't have the exit condition missing in
the for loop please, it's doing the right thing but it's not as obvious
as it could be.

> +	if (tries) {
> +		dev_warn(&rdev->dev, "reg %#x enable ok after %d tries\n",
> +			 rdev->desc->enable_reg, tries);
> +	}

No need for braces here, and I guess that ought to be retries rather
than tries (though that is pedantry).

--ef8eQmdvO1j1gFMO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTbgXAAoJELSic+t+oim9d4sP/i/a/GYy9I0TNekV4rWaxk67
7KMA9v6M2BlBpwpefTkd+WD4zEgk1T9KsLei+yHI/AaXvwQyT4MNAkgTEw7x/UQS
B0XIg7bbIPMGb1zX6izsNqZbARMZPmNd16K3DLtD8B0tdZTZVN1r8G7cUxO675DQ
poYYRLgP+Zr+1CZVFVmE7HyNelQgDx+aVMg4Q8gLpDElCDHnDSnWl4eKX1dmucdi
pkTKobcMY5ZOy5UtGVVvg6MhVwvtKHL7atLZAWW1dRxqb80yTL8V4wdKSl5nnzaj
L14JtxhhpD0Qr+gSUWerS+FjwSdoMxWZRQWuvkYQ4FSRwbMrn/P57+8fQ5x6NbjI
22wYyWztTm7CpuKOVxoeJBnWO+qJXT6LKxuIzn75lX0i0b5uh8Hq72a4bGexiLUp
MAt7Pesb07xwsfpvJkEUyDlEGQ4ulPIxidszunUmZjf8ebGQSs9jlBtlbc4CT5i/
RfVtIStbKTDCycLKs7HrQSyqW0oSUet1hoyEzDiGw03ZvXmx6X59r24DU2fA7dHl
RWI7chwYBgc2VvqwGQywhjOmDYaeFFYg0/P/qFTKDp9fizWTXisDji7dsC5dUhcn
nkSrl4PygKaOx7Vrb+fyW2SwGlZelRlqDHqgIMynq82jU3hLWwmCWhffZX86FTYI
szQZIkhakJUtLfEqIXtk
=HF/7
-----END PGP SIGNATURE-----

--ef8eQmdvO1j1gFMO--
