Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3IKUsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:48:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42589 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab3IKUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:48:07 -0400
Date: Wed, 11 Sep 2013 15:47:15 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130911204714.GH10105@radagast>
Reply-To: <balbi@ti.com>
References: <20130910190901.GA10105@radagast>
 <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast>
 <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast>
 <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNpeiK4tTqhYOExY"
Content-Disposition: inline
In-Reply-To: <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PNpeiK4tTqhYOExY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 11, 2013 at 10:19:47PM +0300, Alexey Pelykh wrote:
> On Wed, Sep 11, 2013 at 10:00 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, Sep 11, 2013 at 09:48:13PM +0300, Alexey Pelykh wrote:
> >> On Wed, Sep 11, 2013 at 9:38 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > Hi,
> >> >
> >> > On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
> >> >> Hi Felipe,
> >> >>
> >> >> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
> >> >> rates. First patch is close to a complete fix, but still contains
> >> >> div-by-zero issue. Here is my version:
> >> >>
> >> >> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/=
omap-serial.c
> >> >> index 816d1a2..808a880 100644
> >> >> --- a/drivers/tty/serial/omap-serial.c
> >> >> +++ b/drivers/tty/serial/omap-serial.c
> >> >> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *po=
rt,
> >> >> unsigned int baud)
> >> >>  {
> >> >>         unsigned int n13 =3D port->uartclk / (13 * baud);
> >> >>         unsigned int n16 =3D port->uartclk / (16 * baud);
> >> >> -       int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
> >> >> -       int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
> >> >> +       int baudAbsDiff13 =3D n13 ? (baud - (port->uartclk / (13 * =
n13))) : INT_MAX;
> >> >> +       int baudAbsDiff16 =3D n16 ? (baud - (port->uartclk / (16 * =
n16))) : INT_MAX;
> >> >
> >> > IOW:
> >> >
> >> > int baudAbsDiff13 =3D 0;
> >> >
> >> > if (n13)
> >> >         baudAbsDiff13 =3D (baud - (port->uartclk / (13 * n13)));
> >>
> >> Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
> >> exception will still occur on 3686400.
> >
> > why, there's no division after that point, right ? Besides,
> > serial_omap_baud_is_mode16() is supposed to return a boolean value.
> >
> > Setting baudAbsDiff1[36] to 0 will cause no problems, you're only using
> > that value with a boolean expression, no divisions whatsoever. Division
> > is done after using serial_omap_baud_is_mode16() to initialize divisor
> > to 13 or 16 (which is a misnamer, since that's the oversampling
> > parameter).
> >
>=20
> Yes, variables are a bit misnamed, that should be fixed someday.
> Regarding 0 vs INT_MAX, in case of 0 values will be
> 300: divisor =3D 12307 (13)
> 600: divisor =3D 6153 (13)
> 1200: divisor =3D 3076 (13)
> 2400: divisor =3D 1538 (13)
> 4800: divisor =3D 625 (16)
> 9600: divisor =3D 384 (13)
> 14400: divisor =3D 256 (13)
> 19200: divisor =3D 192 (13)
> 28800: divisor =3D 128 (13)
> 38400: divisor =3D 96 (13)
> 57600: divisor =3D 64 (13)
> 115200: divisor =3D 32 (13)
> 230400: divisor =3D 16 (13)
> 460800: divisor =3D 8 (13)
> 921600: divisor =3D 4 (13)
> 1000000: divisor =3D 3 (16)
> 1843200: divisor =3D 2 (13)
> 3000000: divisor =3D 1 (16)
> 3686400: divisor =3D 0 (16) << error here, should be 1 (13), as it is wit=
h INT_MAX

I get it now... your boolean check wants to use the closer baud to
requested baud, so it's mode16 if the delta between baudAbsDiff16 and
requested rate is less than delta between baudAbsDiff13 and requested
baud.

> >> > which is exactly what my patch did. I fail to see where division by =
zero
> >> > would be coming from.
> >> >
> >> >>         if(baudAbsDiff13 < 0)
> >> >>                 baudAbsDiff13 =3D -baudAbsDiff13;
> >> >>         if(baudAbsDiff16 < 0)
> >> >>
> >> >>
> >> >> With 48MHz UART clock, it will give
> >> >> 300: divisor =3D 12307 (13), real rate 300 (0.000000%)
> >> >> 600: divisor =3D 6153 (13), real rate 600 (0.000000%)
> >> >> 1200: divisor =3D 3076 (13), real rate 1200 (0.000000%)
> >> >> 2400: divisor =3D 1538 (13), real rate 2400 (0.000000%)
> >> >
> >> > TRM has these all set with oversampling of 16. In fact only 460800,
> >> > 921600, 1843200 and 3686400 should be using oversampling of 13.
> >> >
> >>
> >> That's true, but TRM anyways does not contain all possible baud rates
> >> (1M e.g.). IMO, as long as error rate is the same as in TRM,
> >> it makes no difference what combination of (mode, divisor) to use.
> >>
> >> > --
> >> > balbi
> >>
> >> A complex solution may be implemented: use LUT for baud rates that TRM
> >> defines explicitly, and use calculation if lookup failed.
> >
> > why would you try calculating anything if there is nothing in the table
> > which can support it ? Whatever is in the lookup table, are the only
> > baud rates the SoC supports, right ?
> >
>=20
> Actually, I haven't found any statement in TRM, which would mention
> that listed baudrates in referenced table are the only supported baud
> rates,
> and all others are illegal.

"The UART clocks are connected to produce a baud rate of up to 3.6 Mbps.
Table 24-122 lists the *supported* baud rates, requested divisor, and
corresponding error versus the standard baud rate."

> At least 1M which I use extensively works perfectly, and I can not
> figure out any idea why it would not do so.

it might very well work, but it's not officially *supported* by the IP.

--=20
balbi

--PNpeiK4tTqhYOExY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMNbSAAoJEIaOsuA1yqREj/4P/iQmgTaVpzXgQnH3RjByVrzP
N8/+9TCE7EiOR8paH+bcntB6vBtqvOlhYeICjBzvQ/57EEcHnBJYiOWN6Iq8dfc2
X6KpIwIM8Z145/M++2Xoa2HfDg1WjSH1Iu1v3eLAsxF+RcbSKzALEW9kTtLqnRSU
LUyhautSzUVx8AdOjk2lNMYWUPmaPgH6vHZpF1u/1FUk8K1AaV7QHyG1eBfmDzly
FpfO1P+UbRsWTC2LlPpnbqEKpwv4cRV1IAu810oQKhIExfVVZq+rlXAk1zbpUKiC
Q8Vs81AiGc9pe6CzrLhSj14tFvLj9K754Qcc+l5Ogis45gCXl78eGIN9Gnw/EYDf
DBg4//GcGprRbK7G+kX9+xUAIxbQ1ECMJI4Swz3u+nd67Pa+tFFk1FZSJ5x8Xk/Y
B0R8poYxFaVmzdqRdgnympIMND61W73sabEf+2ffTNLnBv1oWZJKnhWFawwabESR
yvhQLJHI18CYpjqUOEe9KeOLAKrLyYMeRQ7D/aQ+mouYxXgawjAu5Rh6aFy+CqyB
1e9ZWUuUaXzGnE+3nRCwV9q6ZUyqqiaNDYjkeR7eZclUUWBHWLDwi4Ocu65BTWw4
HQ6l2PY4+ZY+31H636ZYk23E2ZAHzJFJW4q4w5hazdhjV+ghNOS/LtLZJOoQ5riw
qIA4SYWsPJmpcvF7J1wo
=Yz9l
-----END PGP SIGNATURE-----

--PNpeiK4tTqhYOExY--
