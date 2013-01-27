Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3A0GGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:06:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab3A0GGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:06:44 -0500
Date: Sun, 27 Jan 2013 14:06:36 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] regulator-core: manage enable GPIO list
Message-ID: <20130127060532.GB8952@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E12B35@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12B35@DQHE02.ent.ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 04:35:46AM +0000, Kim, Milo wrote:

> +/**
> + * Balance enable_count of each GPIO and actual GPIO pin control.
> + * GPIO is enabled in case of initial use. (enable_count is 0)
> + * GPIO is disabled when it is not shared any more. (enable_count is 1)
> + */
> +static void _do_ena_gpio_ctrl(struct regulator_enable_gpio *pin,
> +			struct regulator_dev *rdev, bool enable)
> +{
> +	if (enable) {
> +		/* Enable GPIO at initial use */
> +		if (pin->enable_count == 0)
> +			gpio_set_value_cansleep(rdev->ena_gpio,
> +						!rdev->ena_gpio_invert);
> +
> +		rdev->ena_gpio_state = 1;

ena_gpio_state is redundant with this patch, we can just replace
references to it with pin->enable_count.

We'll also need a request count to keep track of how many regulators are
using the GPIO for use in cleanup.

> +	} else {
> +		rdev->ena_gpio_state = 0;
> +		if (pin->enable_count > 1) {
> +			pin->enable_count--;
> +			return;
> +		}
> +
> +		/* Disable GPIO if not used */
> +		if (pin->enable_count == 1) {
> +			gpio_set_value_cansleep(rdev->ena_gpio,
> +						rdev->ena_gpio_invert);
> +			pin->enable_count = 0;
> +		}

Ideally we should also check if we're trying to take the enable count
below zero and complain about that.

> +static void regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
> +{
> +	struct regulator_enable_gpio *pin;
> +
> +	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
> +		if (pin->gpio == rdev->ena_gpio) {
> +			_do_ena_gpio_ctrl(pin, rdev, enable);
> +			return;
> +		}
> +	}
> +}

This should return an error code as the users return errors, the GPIO
API won't give us errors but we can generate them internally.  It'd be
better to just add a pointer to the GPIO struct to the regulator_dev (in
place of the GPIO) so we don't need to scan through the list every time
we look for the GPIO.

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBMORAAoJELSic+t+oim9WkYP/ioIBRo1Y9ViLzVz2uWC1IdH
/rVsKB1Uodny5k2zKJIsS97JNBBctOHxwjn0flTD/NJCiAp5w3pIBEYJm/kMS+i6
aK4yd5w7NeRzGGMlJypIhX7WJpTXfCyu8112ia7zs0NxFJtTf6lzQXV5TkM6RqFo
LB60eyKwex46VeL0+cFrqGNypLEJQMekuapvYMtdZyW5ngN4DrhWoIQvfqHxKSCM
OJ4C8y6bPTpk/gj+HD68aowMfOmQXq4KwaVMA+qi1pmWMj1Qk1mZu9k/HYrQQ1PN
6r5rR0tnCzpPbJHtpenqHjpWZNLEUMpb5cUk/bzPgN+YhEC510POIshtvff9OGC2
ddjJYi3rGF4GOf2cN2qB9f6poHSLvQX87bQwRuhftUUYx7rK6ifQWiYhzR3Emyar
7hcMag1U6hdK2YH5MbSWru45kRtgVNBmiaX7RqsmY424pXtWY6Ks4ZaRryHWP+Oe
e8YjPc12X9YEaV5ElbXiTnpxwX2vCr5j9zpcNOrHppDQYk7vPe8j7IyPsWlIoRav
No012HHeuQnahrzZNtiQliuPCj1gfaxG7HoKU6EjpoAj8H4hpZNJ6uR4iuau371H
p678ERwFEh3FIrhf8QTO/XYsn0/azfUiUMbPKuXuWSZmuXpWiXL/RYHRLbuVnSHa
G/gTuZtim1h6BQQXo4/F
=SbUW
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
