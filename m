Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3JHKJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:09:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41288 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3JHKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:09:14 -0400
Message-ID: <5253D9A1.1080106@pengutronix.de>
Date: Tue, 08 Oct 2013 12:08:33 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        Marc Pignat <marc.pignat@hevs.ch>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] clockevents: Sanitize ticks to nsec conversion
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de> <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SWmkV4UUofTEQm6CLFEvSHCm3sQI9rmUE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SWmkV4UUofTEQm6CLFEvSHCm3sQI9rmUE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/24/2013 09:50 PM, Uwe Kleine-K=C3=B6nig wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>=20
> Marc Kleine-Budde pointed out, that commit 77cc982 "clocksource: use
> clockevents_config_and_register() where possible" caused a regression
> for some of the converted subarchs.
>=20
> The reason is, that the clockevents core code converts the minimal
> hardware tick delta to a nanosecond value for core internal
> usage. This conversion is affected by integer math rounding loss, so
> the backwards conversion to hardware ticks will likely result in a
> value which is less than the configured hardware limitation. The
> affected subarchs used their own workaround (SIGH!) which got lost in
> the conversion.
>=20
> The solution for the issue at hand is simple: adding evt->mult - 1 to
> the shifted value before the integer divison in the core conversion
> function takes care of it. But this only works for the case where for
> the scaled math mult/shift pair "mult <=3D 1 << shift" is true. For the=

> case where "mult > 1 << shift" we can apply the rounding add only for
> the minimum delta value to make sure that the backward conversion is
> not less than the given hardware limit. For the upper bound we need to
> omit the rounding add, because the backwards conversion is always
> larger than the original latch value. That would violate the upper
> bound of the hardware device.
>=20
> Though looking closer at the details of that function reveals another
> bogosity: The upper bounds check is broken as well. Checking for a
> resulting "clc" value greater than KTIME_MAX after the conversion is
> pointless. The conversion does:
>=20
>       u64 clc =3D (latch << evt->shift) / evt->mult;
>=20
> So there is no sanity check for (latch << evt->shift) exceeding the
> 64bit boundary. The latch argument is "unsigned long", so on a 64bit
> arch the handed in argument could easily lead to an unnoticed shift
> overflow. With the above rounding fix applied the calculation before
> the divison is:
>=20
>        u64 clc =3D (latch << evt->shift) + evt->mult - 1;
>=20
> So we need to make sure, that neither the shift nor the rounding add
> is overflowing the u64 boundary.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: nicolas.ferre@atmel.com
> Cc: Marc Pignat <marc.pignat@hevs.ch>
> Cc: john.stultz@linaro.org
> Cc: kernel@pengutronix.de
> Cc: Ronald Wahl <ronald.wahl@raritan.com>
> Cc: LAK <linux-arm-kernel@lists.infradead.org>
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> [ukl: move assignment to rnd after eventually changing mult, fix build
>  issue and correct comment with the right math]
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

What's the status of this patch?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--SWmkV4UUofTEQm6CLFEvSHCm3sQI9rmUE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJT2aEACgkQjTAFq1RaXHM+EACcDoF1uDknzVQrfTugI/6O37b7
P8EAn2dJq5yiMu3sMt/zUC5gc7zxe32e
=HOsF
-----END PGP SIGNATURE-----

--SWmkV4UUofTEQm6CLFEvSHCm3sQI9rmUE--
