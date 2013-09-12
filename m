Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3ILMWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:22:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45553 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab3ILMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:22:28 -0400
Date: Thu, 12 Sep 2013 07:21:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130912122135.GP10105@radagast>
Reply-To: <balbi@ti.com>
References: <20130910190901.GA10105@radagast>
 <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast>
 <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast>
 <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
 <20130911204714.GH10105@radagast>
 <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
 <CAOmKuSpRpb0mRnORvK-q1MMV3BHZaY8_yTyQV-iE+=gj1hqK7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+gHRqQ1BTyNna/y8"
Content-Disposition: inline
In-Reply-To: <CAOmKuSpRpb0mRnORvK-q1MMV3BHZaY8_yTyQV-iE+=gj1hqK7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+gHRqQ1BTyNna/y8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 12, 2013 at 07:37:07AM +0300, Alexey Pelykh wrote:
> Actually, here it is, but not formatted properly
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index 816d1a2..146e712 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -240,14 +240,14 @@ serial_omap_baud_is_mode16(struct uart_port
> *port, unsigned int baud)
>  {
>   unsigned int n13 =3D port->uartclk / (13 * baud);
>   unsigned int n16 =3D port->uartclk / (16 * baud);
> - int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
> - int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
> + int baudAbsDiff13 =3D n13 ? (baud - (port->uartclk / (13 * n13))) : INT=
_MAX;
> + int baudAbsDiff16 =3D n16 ? (baud - (port->uartclk / (16 * n16))) : INT=
_MAX;
>   if(baudAbsDiff13 < 0)
>   baudAbsDiff13 =3D -baudAbsDiff13;
>   if(baudAbsDiff16 < 0)
>   baudAbsDiff16 =3D -baudAbsDiff16;
>=20
> - return (baudAbsDiff13 > baudAbsDiff16);
> + return (baudAbsDiff13 >=3D baudAbsDiff16);
>  }
>=20
>  /*
> @@ -258,13 +258,13 @@ serial_omap_baud_is_mode16(struct uart_port
> *port, unsigned int baud)
>  static unsigned int
>  serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
>  {
> - unsigned int divisor;
> + unsigned int mode;
>=20
>   if (!serial_omap_baud_is_mode16(port, baud))
> - divisor =3D 13;
> + mode =3D 13;
>   else
> - divisor =3D 16;
> - return port->uartclk/(baud * divisor);
> + mode =3D 16;
> + return port->uartclk/(mode * baud);
>  }
>=20
>  static void serial_omap_enable_ms(struct uart_port *port)

looks good to me, but I'd split it as suggested as a reply to previous
email.

--=20
balbi

--+gHRqQ1BTyNna/y8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMbHPAAoJEIaOsuA1yqREvgcP/At1CuLnB+sdWrhZLMKY6FJK
GXtRovh4J0tkVoPXfIp5X1nF54YjFAi94owB2xBgAfD4mgpgE+OlC/Gt/HvEwKoV
hg4p0xLXlR8CcyRvBE/BD9kWrf8BW/7UjCpXnbwHItLzu4aWcr9NpaqAVaq8b+Dk
fzW3v0WQaGI3c+306Z5Y7qTgQED4oR8ZxRyMDnBgOiqFcEX+Uo3kEXZYVR7XYird
L8AkidZX1rVYcWFhVHQLqlALh5j4Xk+aD/ItGfSRoIcTmXluCPk2+iynbpSxWB7X
OELLL7zBiTGINp/Ztpu3VNg2qlyjrxQiEc0OI0l545pXz+2DwYxdxUaK3gJflQGk
FxAQET27HPrPH2acgD8y54bZ85lmHZTiiN9qKpgBgGXIedBe3TlNE4xO1+ND8ro8
7yDa7LfhnUgD3KJ51g3T7KpyrDIicWA7zXttVLP/xUncIVhTEMcIFiMfWuknqCDf
o1zssgh/1u64C9nHwwHFO1izASUpt6c9XJw3hpQxdrXQYgIdlQEpyv86ZA5PlSZ0
A9v6Vk4z9VUEyiAiJ88vHgeLX2zVAwsMmNTSLIcUkd09nnzKMmFGN87FEBo6TwO+
Ph3cV5RlXJ7Dvgx9stvusTqsJlRnzAOE6Gevjr9qrfQTuOe6AJTyeQgPe23zsgel
KjNlPES0vRFH3VdIgVsP
=9Gv7
-----END PGP SIGNATURE-----

--+gHRqQ1BTyNna/y8--
