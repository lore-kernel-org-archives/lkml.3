Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaLRJou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:44:50 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45634 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaLRJor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:44:47 -0500
Date: Thu, 18 Dec 2014 10:44:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org
Subject: Re: randconfig build error with next-20141204, in drivers/pwm
Message-ID: <20141218094442.GA24383@ulmo>
References: <CA+r1Zhj2ugeO7yqfmnbmkF4xqmZiiSbvq0zVXDMXdfOYGiHcRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <CA+r1Zhj2ugeO7yqfmnbmkF4xqmZiiSbvq0zVXDMXdfOYGiHcRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 09:10:55AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
>=20
> ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!

This took a while to figure out. The attached patch fixes this build
failure, though the driver should probably be fixed to avoid division by
zero, just in case. Adding Boris for visibility.

Thierry

--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-pwm-atmel-hlcdc-Depend-on-HAVE_CLK.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 7933af1d2e5f3941d934eec88f32f5547ee218c3 Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <thierry.reding@gmail.com>
Date: Thu, 18 Dec 2014 10:09:42 +0100
Subject: [PATCH] pwm: atmel-hlcdc: Depend on HAVE_CLK

The include/linux/clk.h header defines dummy implementations for the
various clk_*() functions if HAVE_CLK is not selected to improve build
coverage in randconfig builds.

The dummy implementation of clk_get_rate() returns 0, which causes the
Atmel HLCDC PWM driver's atmel_hlcdc_pwm_config() implementation to end
up calling:

	do_div(clk_period_ns, 0)

On x86, do_div(n, base) will end up evaluating to this:

	n >>=3D ilog2(base)

with base =3D 0, the implementation of ilog2() will call ____ilog2_NaN(),
which is purposely undefined and results in a linker failure:

	ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!

The implementation of do_div() checks that base is a power of 2 before
calling ilog2(). The compiler doesn't optimize this away, presumably
because is_power_of_2() is an inline function and the compiler doesn't
or can't inspect it closely enough. ilog2() being a macro it still ends
up generating the ____ilog2_NaN() because of the constant 0.

The root of the problem is that the driver really should be checking
before possibly dividing by zero. That should eventually be fixed, but
for now just assume that the clock runs at a sensible frequency when
available.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
---
 drivers/pwm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index a3ecf5809634..468af1b4ca30 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -53,6 +53,7 @@ config PWM_ATMEL
 config PWM_ATMEL_HLCDC_PWM
 	tristate "Atmel HLCDC PWM support"
 	depends on MFD_ATMEL_HLCDC
+	depends on HAVE_CLK
 	help
 	  Generic PWM framework driver for the PWM output of the HLCDC
 	  (Atmel High-end LCD Controller). This PWM output is mainly used
--=20
2.1.3


--n8g4imXOkfNTN/H1--

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUkqIKAAoJEN0jrNd/PrOhbysQAJR7BIVOgonYo43vuEkCa8p4
m9WvLK8GBbgOboM3W5ysN9n8rUH3cKvn/hk23fwSp/owdAVQqEYL4RTXjbT3VVc4
W2fyFbf91kOlzKryHZq0zIOqv/XX9w7HRUuk6TJtIH3GwxhMcmC0uJFUcViEUiFe
mKPnvnx85Mdu0DznJtyxnqGIvkIrWX5yj350WPAC+YpKH2nQi4/6qiNvq/byzA5E
hjDYu+e3V21n0RdpwUK+4CGoEhT2Pj7nr09t8xPoI9/Rxdry6MEcvOyWAaANAJ2j
o72P19g4nYcmfloPIejWtAk0yfRtSDwK9jCANU7E0c5k+JMuhDOC7q9HwdxVKqam
WOIKc/So6otjOTYGrIf2SXjaRYR4d8yhZZ1m8L/9wXhf4VlrhGLKTT//x9ivtOg+
shvNb5hCK19SKx2xIzHYDP8XA2QSc5pHFnAD7G8b5CR3jUvjLtZIhtsL3T0cIqSv
ncKhKWgJUhynB1LGP1dh1WuYCAQo+YQEFLbTISEAMiRbct6hGydSIjgEVQ2NcSgf
oTl6pa58VykAKlWnV9qTXONvCYf4ah0LBIR6tsK2HmptyeeN0V7OLqW9TyjC6tWb
cZ1E1OB8MWGgorjHsapYEV57dMzDfdXAKr6LKjPot07d+qYgPMQXP99Mi38U+m0F
43EgOCelqOByO0Glfzpn
=iN5h
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
