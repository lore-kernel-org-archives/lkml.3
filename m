Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3IKSjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:39:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56908 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3IKSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:39:43 -0400
Date: Wed, 11 Sep 2013 13:38:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130911183825.GC10105@radagast>
Reply-To: <balbi@ti.com>
References: <20130910190901.GA10105@radagast>
 <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
> Hi Felipe,
>=20
> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
> rates. First patch is close to a complete fix, but still contains
> div-by-zero issue. Here is my version:
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index 816d1a2..808a880 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
> unsigned int baud)
>  {
>         unsigned int n13 =3D port->uartclk / (13 * baud);
>         unsigned int n16 =3D port->uartclk / (16 * baud);
> -       int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
> -       int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
> +       int baudAbsDiff13 =3D n13 ? (baud - (port->uartclk / (13 * n13)))=
 : INT_MAX;
> +       int baudAbsDiff16 =3D n16 ? (baud - (port->uartclk / (16 * n16)))=
 : INT_MAX;

IOW:

int baudAbsDiff13 =3D 0;

if (n13)
	baudAbsDiff13 =3D (baud - (port->uartclk / (13 * n13)));

which is exactly what my patch did. I fail to see where division by zero
would be coming from.

>         if(baudAbsDiff13 < 0)
>                 baudAbsDiff13 =3D -baudAbsDiff13;
>         if(baudAbsDiff16 < 0)
>=20
>=20
> With 48MHz UART clock, it will give
> 300: divisor =3D 12307 (13), real rate 300 (0.000000%)
> 600: divisor =3D 6153 (13), real rate 600 (0.000000%)
> 1200: divisor =3D 3076 (13), real rate 1200 (0.000000%)
> 2400: divisor =3D 1538 (13), real rate 2400 (0.000000%)

TRM has these all set with oversampling of 16. In fact only 460800,
921600, 1843200 and 3686400 should be using oversampling of 13.

--=20
balbi

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMLihAAoJEIaOsuA1yqREg5QP/19hCQd5KWHH/DBYJz+VCV4T
/5b3AfKiUBhe41SO3pdbLqfKe2BJzYsKftwOA7534/wjI2eRtMSxd/9Y6gbAiliE
W9MiIMapDwTduqGSRJGnL/RW5CMCe9Z78UbDB3kx7uH+aE2DxNfr98jXkqiidihB
KnNOjzGDI7PkneG80WBf/iLhonQkXaof+crw6OAvll79x2LeJ7bfWfCFwhebXEru
OfLrn/S/nrddQrHU3F8EyKvOKwH8crX8lRmTVwocvCE2Mq81Ne99eNjdlIVmqCK6
BPpO/Njlx/86nUdFsa36ufmo0KVwGqCmyr8kK+wLbjfUTpK0FXGaQlzawQyVbCDn
8ohPteVBTE+bh5Mc1ROut7qKlOCjmc6NbNlBLK4KKlaRifzcz3fcdRDwT3Wx0Fe5
2HA54FpjWLtkbcARtAVQqWt07zeUCKwUtBpp2DiViUXLV3THl0VesdAsf3jHoTK/
nAtfH6n6Wk9KOGrBeaynbzQGJcaSvABFOyJYBB+5jfUgPIzWIztDDgnOUi20TT71
g0L9HmhkAMXDJwVddYvpND03WyXzoWewJnOlI4c3VJf/ShPvZhzPgy+dydCKmGAk
c2qmjILzjk1i/drVzVIhUpq0CqnbpxZE8UNZuzpfo2UenMDflcNcIzO+4bCd/2FW
ppe2IVvY0l67k37DDhKG
=E6B7
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
