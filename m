Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaECBXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 21:23:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59419 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbaECBXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 21:23:23 -0400
Date: Fri, 2 May 2014 18:22:43 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140503012243.GG4090@lukather>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Content-Disposition: inline
In-Reply-To: <1398958893-30049-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Thu, May 01, 2014 at 08:41:29AM -0700, Guenter Roeck wrote:
> Some hardware implements reboot through its watchdog hardware,
> for example by triggering a watchdog timeout. Platform specific
> code starts to spread into watchdog drivers, typically by setting
> pointers to a callback functions which is then called from the
> platform reset handler.
>=20
> To simplify code and provide a unified API to trigger reboots by
> watchdog drivers, provide a single API to trigger such reboots
> through the watchdog subsystem.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
>  include/linux/watchdog.h         |   11 +++++++++++
>  2 files changed, 28 insertions(+)
>=20
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog=
_core.c
> index cec9b55..4ec6e2f 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -43,6 +43,17 @@
>  static DEFINE_IDA(watchdog_ida);
>  static struct class *watchdog_class;
> =20
> +static struct watchdog_device *wdd_reboot_dev;
> +
> +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
> +{
> +	if (wdd_reboot_dev) {
> +		if (wdd_reboot_dev->ops->reboot)
> +			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
> +	}
> +}
> +EXPORT_SYMBOL(watchdog_do_reboot);
> +
>  static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
>  {
>  	/*
> @@ -162,6 +173,9 @@ int watchdog_register_device(struct watchdog_device *=
wdd)
>  		return ret;
>  	}
> =20
> +	if (wdd->ops->reboot)
> +		wdd_reboot_dev =3D wdd;
> +

Overall, it looks really great, but I guess we can make it a
list. Otherwise, we might end up in a situation where we could not
reboot anymore, like this one for example:
  - a first watchdog is probed, registers a reboot function
  - a second watchdog is probed, registers a reboot function that
    overwrites the first one.
  - then, the second watchdog disappears for some reason, and the
    reboot is set to NULL

Or maybe we can just use the start callback, with the min timeout already
registered, and prevent the user to kick the watchdog.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZETjAAoJEBx+YmzsjxAgbD4QAKydo8fb0Xrb90bM/9AiO+Mg
kGU39UTMbBaJ4wAEQaEyDsdMADCYOzpqXymM2e9mfFHzEdmE9V8zJ6MfXCGNbnpC
ddXGnXEriNUAzegCmWjVJdizlmrw9R7w0U4u+069MZC0PkbgQymcqcgUGr3WD7Se
iE2yZTAgZgHspB5baZwdEJ5RD7S4YNN/dU2q2l45Et1vS2mTHMjMd2GaZvOACqFM
y8F39hf96IVT0IV0rr515x06T6ArQtmZHl7CjKQopeeQO9/Sxm1FpZHcxPJa6K7f
om1sX0j3cPGpGMb96VqlLYFDLHIhQ0yGLMeTwMFuSmSkhYrJkOcGZMOAjqU8xYdK
BRRLCmnda0UK4hlWVFTz5xY1jBxi/1avMUoe6goWW3yBYneF6S6L3ScDS/qcOHTN
PKTgl4pqiRrgXhQ5KPAOin69hL9tT/JURs9Blfg4iUKtyKlsaXZYthGpYS1L5ywu
haQgNzWZYcKofuNnF8H5JLAIrTFBXpL7g+V0py13ZEV6SXjmi30tufegxVG2U77u
CaXrO+wqG0H63SbA4RFkhIGkvKkUtW6ZBFoEbunHqq18eHG91agR2USf2Js0rvT4
ADKF7zRTW+PINQrkFaJqKWY1tLWqZWVTRVTHganaEWnWIqrUKu1Vvol78hqEFdyF
yhWP93qq2LAyZ3QGaSjc
=CYOb
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
