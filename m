Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3ILMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:18:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45417 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3ILMSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:18:20 -0400
Date: Thu, 12 Sep 2013 07:17:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130912121726.GO10105@radagast>
Reply-To: <balbi@ti.com>
References: <20130910190901.GA10105@radagast>
 <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast>
 <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast>
 <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
 <20130911204714.GH10105@radagast>
 <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/UvyDgxjlFfP/4zZ"
Content-Disposition: inline
In-Reply-To: <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/UvyDgxjlFfP/4zZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 12, 2013 at 07:32:54AM +0300, Alexey Pelykh wrote:
> >> >> > On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
> >> >> >> Hi Felipe,
> >> >> >>
> >> >> >> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
> >> >> >> rates. First patch is close to a complete fix, but still contains
> >> >> >> div-by-zero issue. Here is my version:
> >> >> >>
> >> >> >> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/seri=
al/omap-serial.c
> >> >> >> index 816d1a2..808a880 100644
> >> >> >> --- a/drivers/tty/serial/omap-serial.c
> >> >> >> +++ b/drivers/tty/serial/omap-serial.c
> >> >> >> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port =
*port,
> >> >> >> unsigned int baud)
> >> >> >>  {
> >> >> >>         unsigned int n13 =3D port->uartclk / (13 * baud);
> >> >> >>         unsigned int n16 =3D port->uartclk / (16 * baud);
> >> >> >> -       int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13)=
);
> >> >> >> -       int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16)=
);
> >> >> >> +       int baudAbsDiff13 =3D n13 ? (baud - (port->uartclk / (13=
 * n13))) : INT_MAX;
> >> >> >> +       int baudAbsDiff16 =3D n16 ? (baud - (port->uartclk / (16=
 * n16))) : INT_MAX;
> >> >> >
> >> >> > IOW:
> >> >> >
> >> >> > int baudAbsDiff13 =3D 0;
> >> >> >
> >> >> > if (n13)
> >> >> >         baudAbsDiff13 =3D (baud - (port->uartclk / (13 * n13)));
> >> >>
> >> >> Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
> >> >> exception will still occur on 3686400.
> >> >
> >> > why, there's no division after that point, right ? Besides,
> >> > serial_omap_baud_is_mode16() is supposed to return a boolean value.
> >> >
> >> > Setting baudAbsDiff1[36] to 0 will cause no problems, you're only us=
ing
> >> > that value with a boolean expression, no divisions whatsoever. Divis=
ion
> >> > is done after using serial_omap_baud_is_mode16() to initialize divis=
or
> >> > to 13 or 16 (which is a misnamer, since that's the oversampling
> >> > parameter).
> >> >
> >>
> >> Yes, variables are a bit misnamed, that should be fixed someday.
> >> Regarding 0 vs INT_MAX, in case of 0 values will be
> >> 300: divisor =3D 12307 (13)
> >> 600: divisor =3D 6153 (13)
> >> 1200: divisor =3D 3076 (13)
> >> 2400: divisor =3D 1538 (13)
> >> 4800: divisor =3D 625 (16)
> >> 9600: divisor =3D 384 (13)
> >> 14400: divisor =3D 256 (13)
> >> 19200: divisor =3D 192 (13)
> >> 28800: divisor =3D 128 (13)
> >> 38400: divisor =3D 96 (13)
> >> 57600: divisor =3D 64 (13)
> >> 115200: divisor =3D 32 (13)
> >> 230400: divisor =3D 16 (13)
> >> 460800: divisor =3D 8 (13)
> >> 921600: divisor =3D 4 (13)
> >> 1000000: divisor =3D 3 (16)
> >> 1843200: divisor =3D 2 (13)
> >> 3000000: divisor =3D 1 (16)
> >> 3686400: divisor =3D 0 (16) << error here, should be 1 (13), as it is =
with INT_MAX
> >
> > I get it now... your boolean check wants to use the closer baud to
> > requested baud, so it's mode16 if the delta between baudAbsDiff16 and
> > requested rate is less than delta between baudAbsDiff13 and requested
> > baud.
> >
> >> >> > which is exactly what my patch did. I fail to see where division =
by zero
> >> >> > would be coming from.
> >> >> >
> >> >> >>         if(baudAbsDiff13 < 0)
> >> >> >>                 baudAbsDiff13 =3D -baudAbsDiff13;
> >> >> >>         if(baudAbsDiff16 < 0)
> >> >> >>
> >> >> >>
> >> >> >> With 48MHz UART clock, it will give
> >> >> >> 300: divisor =3D 12307 (13), real rate 300 (0.000000%)
> >> >> >> 600: divisor =3D 6153 (13), real rate 600 (0.000000%)
> >> >> >> 1200: divisor =3D 3076 (13), real rate 1200 (0.000000%)
> >> >> >> 2400: divisor =3D 1538 (13), real rate 2400 (0.000000%)
> >> >> >
> >> >> > TRM has these all set with oversampling of 16. In fact only 46080=
0,
> >> >> > 921600, 1843200 and 3686400 should be using oversampling of 13.
> >> >> >
> >> >>
> >> >> That's true, but TRM anyways does not contain all possible baud rat=
es
> >> >> (1M e.g.). IMO, as long as error rate is the same as in TRM,
> >> >> it makes no difference what combination of (mode, divisor) to use.
> >> >>
> >> >> > --
> >> >> > balbi
> >> >>
> >> >> A complex solution may be implemented: use LUT for baud rates that =
TRM
> >> >> defines explicitly, and use calculation if lookup failed.
> >> >
> >> > why would you try calculating anything if there is nothing in the ta=
ble
> >> > which can support it ? Whatever is in the lookup table, are the only
> >> > baud rates the SoC supports, right ?
> >> >
> >>
> >> Actually, I haven't found any statement in TRM, which would mention
> >> that listed baudrates in referenced table are the only supported baud
> >> rates,
> >> and all others are illegal.
> >
> > "The UART clocks are connected to produce a baud rate of up to 3.6 Mbps.
> > Table 24-122 lists the *supported* baud rates, requested divisor, and
> > corresponding error versus the standard baud rate."
> >
> >> At least 1M which I use extensively works perfectly, and I can not
> >> figure out any idea why it would not do so.
> >
> > it might very well work, but it's not officially *supported* by the IP.
>=20
> That's true, but I don't see any reason why driver should disallow
> usage of baud rates that are not supported, but possible by hardware:
> "The UART clocks are connected to produce a baud rate of up to 3.6M bits/=
s."

fair point.

> I've changed calculation a bit to give priority to mode16, and now it
> gives TRM table as-is + extra baud rates
> 300: divisor =3D 10000 (16), real rate 300 (0.000000%)
> 600: divisor =3D 5000 (16), real rate 600 (0.000000%)
> 1200: divisor =3D 2500 (16), real rate 1200 (0.000000%)
> 2400: divisor =3D 1250 (16), real rate 2400 (0.000000%)
> 4800: divisor =3D 625 (16), real rate 4800 (0.000000%)
> 9600: divisor =3D 312 (16), real rate 9615 (0.156250%)
> 14400: divisor =3D 208 (16), real rate 14423 (0.159722%)
> 19200: divisor =3D 156 (16), real rate 19230 (0.156250%)
> 28800: divisor =3D 104 (16), real rate 28846 (0.159722%)
> 38400: divisor =3D 78 (16), real rate 38461 (0.158854%)
> 57600: divisor =3D 52 (16), real rate 57692 (0.159722%)
> 115200: divisor =3D 26 (16), real rate 115384 (0.159722%)
> 230400: divisor =3D 13 (16), real rate 230769 (0.160156%)
> 460800: divisor =3D 8 (13), real rate 461538 (0.160156%)
> 921600: divisor =3D 4 (13), real rate 923076 (0.160156%)
> 1000000: divisor =3D 3 (16), real rate 1000000 (0.000000%)
> 1843200: divisor =3D 2 (13), real rate 1846153 (0.160211%)
> 3000000: divisor =3D 1 (16), real rate 3000000 (0.000000%)
> 3686400: divisor =3D 1 (13), real rate 3692307 (0.160238%)
>=20
> If that's acceptable behavior, I'll prepare a patch.

Sure but I'd suggest splitting the patch so we can get the bugfix in
mainline during this -rc. So first patch would only fix the
division-by-zero bug and second patch would 'fix' baudrate calculation.

Sounds good ?

--=20
balbi

--/UvyDgxjlFfP/4zZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMbDWAAoJEIaOsuA1yqREnqcP/j48qtErTBFvdpJx09r/2tdu
Ny2Yf3kQjj04T5ZpETNRvHsTZgnH5QGSCOaeGxguFpLgMJwG3tpm6LxbH+WXLyXE
iU4FBjVciLo/Y2aiMf/D4mDYg87+KZvMhUAX1eD/GvEQ+Q2XV0k44VIng87Rrhzp
tV+i9EmlWT6SqvrUl+p+Ru+56srRyu8UtUl95ZMFEdGEkirgzWWuNhNA58vTsuBq
SRf4iJ88GuBDMVj8LbXsFP6qGnaXMvh6Ru6dD9zPEt8EHZVgzXDQV4gSgogVo6+j
saoDl2bMj4o2eLnZmxIyGmTVYvZ8M+wU/5vmG/+wEBrdUlX4ZozxUNIXaguJprJN
lsuXuot3n+S5/Sez5BtWgJW7gWlfFOJarMjyjxPmBm3nCC2IUaL/GuIRPPzawLta
kXlAB2yb06YOwoQLP9J0ylvWVKPqXcYIt17TIC+CNh52cZ4o9dty6IeSHiXj2vtq
l4vinU/FEpLo3uqJwfJ31gqQu/CcpeK6rVA2/duwcegxu+bkXj7WsmnLVEv1r1fs
bj5PFS7mXCV1Xb1ob0FsZol+0L4gO/mZ+/ZC5u0wf97CAMP/F3ve0syKU7DzRasI
fxWarHh3akem70xCKi5+wRY7m7aJNli3ouOXM/IqcMKN8OvdwBOkuPJ36BCQC+qZ
1E9TvgK4QbdF5IeDr9gk
=qcUj
-----END PGP SIGNATURE-----

--/UvyDgxjlFfP/4zZ--
