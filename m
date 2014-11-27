Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaK0SoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:44:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41155 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaK0SoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:44:10 -0500
Date: Thu, 27 Nov 2014 18:43:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20141127184342.GC7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkCVF37ElD4C4GZ7"
Content-Disposition: inline
In-Reply-To: <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/7] regulator: Use ena_gpio supplied with generic
 regulator bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VkCVF37ElD4C4GZ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 12:20:50PM +0100, Krzysztof Kozlowski wrote:
> Use ena_gpio from regulator constraints (filled by parsing generic
> bindings) to initialize the GPIO enable control. Support also the old
> way: ena_gpio supplied in regulator_config structure.
>=20
> This also adds a new set_ena_gpio() callback in regulator_ops structure
> which driver may provide to actually enable the GPIO control in
> hardware.

This seems really confused like it's trying to work around some other
problem - this all feels like it's at the wrong abstraction level.  As
far as I can tell this is trying to fix bugs in the previous patch and
do some other refactorings (the "also add this other random op" bit
especially) but I'm really not clear what the goal is.

Please try to think if the code you're writing makes sense at the big
picture level rather than just band aiding specific problems you see.
It's also a good idea to keep random code motion separate from
functional changes since it makes it much easier to follow what each is
supposed to do.

> @@ -1044,6 +1045,14 @@ static int set_machine_constraints(struct regulato=
r_dev *rdev,
>  		}
>  	}
> =20
> +	if (rdev->constraints->use_ena_gpio && ops->set_ena_gpio) {
> +		ret =3D ops->set_ena_gpio(rdev);
> +		if (ret < 0) {
> +			rdev_err(rdev, "failed to set enable GPIO control\n");
> +			goto out;
> +		}
> +	}

Why do we need some special magic operation for GPIO based enables
that's separate to any other enable operation?  This seems really
confusing, if the constraint setting doesn't work somehow for GPIO based
enables we should fix that.  Though since this operation takes no
parameters it's hard to see how it's supposed to apply constraints
unless it reparses them which doesn't seem like a good idea...

>  static int regulator_ena_gpio_request(struct regulator_dev *rdev,
> -				const struct regulator_config *config)

> -	ret =3D gpio_request_one(config->ena_gpio,
> -				GPIOF_DIR_OUT | config->ena_gpio_flags,
> +	ret =3D gpio_request_one(gpio, GPIOF_DIR_OUT | gpio_flags,
>  				rdev_get_name(rdev));

> +/*
> + * Request GPIO for enable control from regulator_config
> + * or init_data->constraints.
> + */
> +static int regulator_ena_gpio_setup(struct regulator_dev *rdev,
> +			const struct regulator_config *config,
> +			const struct regulator_init_data *init_data)

Why is setting up the GPIO different to requesting it, especially given
that we have an existing function called _request() which still exists?

--VkCVF37ElD4C4GZ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUd3DdAAoJECTWi3JdVIfQubEH/jxO9kh8fwL2jJoGAEkeE20D
btT3H3TlSuPN9k96FKZEPARBKUkSjH8cORtPl1PE0qOkMMTjl+Zh2dotUEtZf+lK
cxxYt4HRo8uSbg7Kmz5waZsVE3fRgmCzzJW/hiYakiuSI2t9792fyokpJdpTphoS
8gZ5bxUXQedUrrqn9V3qvorZOBFzhENsKpnrdDG9R4Y74SBqpwf0lPRNEdlKK2C9
UzVh2riLgJofGjvzxV1ykcUt1596rEbEXc5rZJ2ekRsWmfcuB4a0X01ZNvKV/Tjq
92aIHq9qwq9EKfYa6rCr5GMAGH439jcPIX16nW25CYvNgCSNFvlcywKwbr8EUh4=
=WT6H
-----END PGP SIGNATURE-----

--VkCVF37ElD4C4GZ7--
