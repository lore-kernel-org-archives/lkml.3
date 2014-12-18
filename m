Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaLRJyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:54:12 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44066 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaLRJyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:54:10 -0500
Date: Thu, 18 Dec 2014 10:54:06 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org
Subject: Re: randconfig build error with next-20141204, in drivers/pwm
Message-ID: <20141218095406.GB24383@ulmo>
References: <CA+r1Zhj2ugeO7yqfmnbmkF4xqmZiiSbvq0zVXDMXdfOYGiHcRg@mail.gmail.com>
 <20141218094442.GA24383@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20141218094442.GA24383@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 10:44:44AM +0100, Thierry Reding wrote:
> On Thu, Dec 04, 2014 at 09:10:55AM -0700, Jim Davis wrote:
> > Building with the attached random configuration file,
> >=20
> > ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!
>=20
> This took a while to figure out. The attached patch fixes this build
> failure, though the driver should probably be fixed to avoid division by
> zero, just in case. Adding Boris for visibility.
>=20
> Thierry

> From 7933af1d2e5f3941d934eec88f32f5547ee218c3 Mon Sep 17 00:00:00 2001
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Thu, 18 Dec 2014 10:09:42 +0100
> Subject: [PATCH] pwm: atmel-hlcdc: Depend on HAVE_CLK
>=20
> The include/linux/clk.h header defines dummy implementations for the
> various clk_*() functions if HAVE_CLK is not selected to improve build
> coverage in randconfig builds.
>=20
> The dummy implementation of clk_get_rate() returns 0, which causes the
> Atmel HLCDC PWM driver's atmel_hlcdc_pwm_config() implementation to end
> up calling:
>=20
> 	do_div(clk_period_ns, 0)
>=20
> On x86, do_div(n, base) will end up evaluating to this:
>=20
> 	n >>=3D ilog2(base)
>=20
> with base =3D 0, the implementation of ilog2() will call ____ilog2_NaN(),
> which is purposely undefined and results in a linker failure:
>=20
> 	ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!
>=20
> The implementation of do_div() checks that base is a power of 2 before
> calling ilog2(). The compiler doesn't optimize this away, presumably
> because is_power_of_2() is an inline function and the compiler doesn't
> or can't inspect it closely enough. ilog2() being a macro it still ends
> up generating the ____ilog2_NaN() because of the constant 0.

If I turn is_power_of_2() into a macro, then this build failure also
goes away. I suppose the reason is that now the do_div() evaluates such
that the branch that would reference the undefined symbol can be
discarded.

Still I think allowing that branch to remain will cause the linker
failure on division by (constant) zero, which has some value, too.

Thierry

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUkqQ+AAoJEN0jrNd/PrOhQUwP/iXNoh/5gRAYB57lvDrG7I7a
kxGGx2HqbnuWW/+z0Qj4FxelW1PQNt91ZNYDwScTOvQGn2e+XeULV1wZ7MESjtUs
VJN7LWUTJNfpApL8lAdtMW3bF8tfy4xO0SXxKeq1nYvVA94SFT/iZEKHgkGYUC60
NWvxOTwDtdnMGKxAzXb98iNd8S49IxyawfUFHU6eGyDL8iR4/QgN5y5uCZ9M12di
4KQ5UCI8IILVOPWB99dc05h44Pq5QmnK3LdoNnz/6zDGuY1KQBLTBee3QJJtLdrc
CEDduf9GFQeUq/tFV29UaW6J7SepWF5db7lUe+yIo29IS4Suj4VowYmGgMUQfoQE
fI/c9tnjkm5SKTYYfNWEQUDg9aMCkfIyXoULMaPvBSV/GrP/kIlXn2vJptr9m8qN
fca4bvfzDUfgxIgB80u8NtNPuPKyvV8AwOtw9CTmfNiLZNL88ks1vPVdPIdmtoFc
N/GObJ6+fGJtAX+LTiCcX4H3xKFRolUy08yKyTBoo1spMXc8bEHQNmAHqqo79r8s
3q0A9P04k9w1WMXj1PJF0xtElvTMdriSCpnW3230iVcgY8RlojXtDAQAQdtRe6fk
/80VG+ajqdY73WtS/FkoNzFXvrwfJv54066sCFteiTuJWYp4Olw8am4kOjiv8IvW
xUUH64GxJGEqOLLxWY6u
=n1CI
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
