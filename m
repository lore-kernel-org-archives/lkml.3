Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaL2R0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:26:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54591 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaL2R0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:26:38 -0500
Date: Mon, 29 Dec 2014 17:25:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141229172555.GE17800@sirena.org.uk>
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com>
 <1418612879-16094-3-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QGJc34MDtiY7Hvtp"
Content-Disposition: inline
In-Reply-To: <1418612879-16094-3-git-send-email-zyw@rock-chips.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QGJc34MDtiY7Hvtp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2014 at 11:07:58AM +0800, Chris Zhong wrote:

> +	sel <<=3D ffs(rdev->desc->vsel_mask) - 1;
> +	sel |=3D old_sel & ~rdev->desc->vsel_mask;
> +
> +	ret =3D regmap_write(rdev->regmap, reg, sel);
> +	if (ret)
> +		return ret;
> +
> +	gpiod_set_value(gpio, !gpio_level);

So, this seems a bit odd.  What we appear to be doing here is
alternating between the two different voltage setting registers which is
all well and good but makes me wonder why we're bothering - it's a bit
more work than just sticking with one.  We do get...

> +	/*
> +	 * dvsok pin would be pull down when dvs1/2 pin changed, and
> +	 * it would be pull up once the voltage regulate complete.
> +	 * No need to wait dvsok signal when voltage falling.
> +	 */

=2E..this but unless the voltage typically ramps much faster than spec
it's never clear to me that we're actually winning by polling the pin
instead of just dead reckoning the time, it's more work for the CPU to
poll the GPIO than to sleep after all.

One thing we can do with hardware like this is to program in a voltage
we're likely to want to switch to quickly and then use the GPIO to get
there.  That can be a bit hard to arrange with the regulator API as it
currently stands since we don't exactly have an interface for it. =20

We can just check to see what the two values are current set to before
switching and skip the register write if it's the same (making things
faster since we're typically avoiding an I2C or SPI transaction by doing
that) but that's a bit meh.  We can also try to do things like keep the
top voltage from the voltage ranges we're being given programmed which
for DVS typically ends up doing a reasonable job since governors often
like to jump straight to top speed when things get busy so that's one of
the common cases where we most want to change voltages as quickly as
possible.

--QGJc34MDtiY7Hvtp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoY6iAAoJECTWi3JdVIfQVagH/0+6i3HlMrX2KplxM17WikDs
J/V9Waw/yJZNU2vuu8i5a44SYsAmlZPW33CxAk6Qq4DeUwxOB+QLDMvM4msRyTsL
IqCZi7YJA4a9bopu37gG+MPq459LD3wJPaQPCWW5P7z4p4tV0l+s/eJVP4HzdM9K
gltUjfZU4JJ3V6UEP60kIYZGRsk+hdNSvqjqlmOsYBj8jCl6oHGY+p03pGyfjw2Q
Fgb73G1XpRvtzwvThl8ykNKdn0ckDKSdcWaFkapUnUfVkm5w89FLRRNjZZXOFVdN
nm6gyUuEkXELoBTW5A77t+GNH0XNFiXwB9Nzz7GxSoHAejeZffcmYDUUa0H9hSg=
=UrRe
-----END PGP SIGNATURE-----

--QGJc34MDtiY7Hvtp--
