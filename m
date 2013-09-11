Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3IKTB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:01:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58127 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3IKTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:01:25 -0400
Date: Wed, 11 Sep 2013 14:00:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130911190033.GD10105@radagast>
Reply-To: <balbi@ti.com>
References: <20130910190901.GA10105@radagast>
 <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast>
 <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2013 at 09:48:13PM +0300, Alexey Pelykh wrote:
> On Wed, Sep 11, 2013 at 9:38 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
> >> Hi Felipe,
> >>
> >> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
> >> rates. First patch is close to a complete fix, but still contains
> >> div-by-zero issue. Here is my version:
> >>
> >> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/oma=
p-serial.c
> >> index 816d1a2..808a880 100644
> >> --- a/drivers/tty/serial/omap-serial.c
> >> +++ b/drivers/tty/serial/omap-serial.c
> >> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
> >> unsigned int baud)
> >>  {
> >>         unsigned int n13 =3D port->uartclk / (13 * baud);
> >>         unsigned int n16 =3D port->uartclk / (16 * baud);
> >> -       int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
> >> -       int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
> >> +       int baudAbsDiff13 =3D n13 ? (baud - (port->uartclk / (13 * n13=
))) : INT_MAX;
> >> +       int baudAbsDiff16 =3D n16 ? (baud - (port->uartclk / (16 * n16=
))) : INT_MAX;
> >
> > IOW:
> >
> > int baudAbsDiff13 =3D 0;
> >
> > if (n13)
> >         baudAbsDiff13 =3D (baud - (port->uartclk / (13 * n13)));
>=20
> Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
> exception will still occur on 3686400.

why, there's no division after that point, right ? Besides,
serial_omap_baud_is_mode16() is supposed to return a boolean value.

Setting baudAbsDiff1[36] to 0 will cause no problems, you're only using
that value with a boolean expression, no divisions whatsoever. Division
is done after using serial_omap_baud_is_mode16() to initialize divisor
to 13 or 16 (which is a misnamer, since that's the oversampling
parameter).

> > which is exactly what my patch did. I fail to see where division by zero
> > would be coming from.
> >
> >>         if(baudAbsDiff13 < 0)
> >>                 baudAbsDiff13 =3D -baudAbsDiff13;
> >>         if(baudAbsDiff16 < 0)
> >>
> >>
> >> With 48MHz UART clock, it will give
> >> 300: divisor =3D 12307 (13), real rate 300 (0.000000%)
> >> 600: divisor =3D 6153 (13), real rate 600 (0.000000%)
> >> 1200: divisor =3D 3076 (13), real rate 1200 (0.000000%)
> >> 2400: divisor =3D 1538 (13), real rate 2400 (0.000000%)
> >
> > TRM has these all set with oversampling of 16. In fact only 460800,
> > 921600, 1843200 and 3686400 should be using oversampling of 13.
> >
>=20
> That's true, but TRM anyways does not contain all possible baud rates
> (1M e.g.). IMO, as long as error rate is the same as in TRM,
> it makes no difference what combination of (mode, divisor) to use.
>=20
> > --
> > balbi
>=20
> A complex solution may be implemented: use LUT for baud rates that TRM
> defines explicitly, and use calculation if lookup failed.

why would you try calculating anything if there is nothing in the table
which can support it ? Whatever is in the lookup table, are the only
baud rates the SoC supports, right ?

cheers

--=20
balbi

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSML3RAAoJEIaOsuA1yqREH5QP/jvwlDsejeTZidEvgb107dWx
J6Pm6Snow3QIjR3ZGWOrwFohjyn6iQP3ccr1R1WRMTSmCb8dMOioZxmOQyK4YTco
5MRIwoWJ+HWEhtvE+xmSkkqaVmKRpFibwZe6ApOlo0bdosU/mbA0rPkjq+/Nd3oM
nOrdUwF3SCFJuNMW5Fl8gDH4Cq4GaGaxtxeoGO2CfP7nEOk+B0KrQO9w1GtiQ0ha
01TuVGQMHOd5rQGkAf60d18dllo988Xnuq8AdzzVHObS56CrfeGLHI2dpkWKtWLm
PQOADnnnvI0FuFxyjAg8dwychpneTdBil5Yfq8BABAtoprmc9BfwyMAamfvDWDjC
yR4R9rIblIWeyepzVK5Q7C1BqgMuuGcvENUMClZf8lZg6V2ZVaR86ci7R7HfWNL3
zfKjdJuKsw3GlFrHDLx8vPOUt1UY1F5aPOPPNN+e/YGjULG1Ip068VJn0TwofPeE
PYueg4dMuWrmLtMuHtjfMiEtrKhT8sKqDWcvCQEWfAFlb1EN5ymKKo67hIUmBoRv
q0sBw4XZvua6sIFoLHRdl6GffR3fszwVMLjbDT4NnG6YfeAXbwLlRXsIhuaIvyon
HDkziZ6YkJdKGbWwqMUepzVF7fTa838rflriegH65XJxeFvKDjdC7R5TEPuboZIN
On6U7DhxkuvxX9xYCoZf
=jSCD
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
