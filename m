Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3KYWOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:14:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39666 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3KYWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:14:19 -0500
Date: Mon, 25 Nov 2013 16:13:48 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        <linux-omap@vger.kernel.org>, <linaro-networking@linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 15/23] usb: musb: raw read and write endian fix
Message-ID: <20131125221348.GB18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
 <1384560086-11994-16-git-send-email-taras.kondratiuk@linaro.org>
 <20131125220749.GA18046@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yXyGAOZGgonRe4uu"
Content-Disposition: inline
In-Reply-To: <20131125220749.GA18046@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yXyGAOZGgonRe4uu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 25, 2013 at 04:07:49PM -0600, Felipe Balbi wrote:
> On Sat, Nov 16, 2013 at 02:01:18AM +0200, Taras Kondratiuk wrote:
> > From: Victor Kamensky <victor.kamensky@linaro.org>
> >=20
> > All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> > Need to use endian neutral functions to read/write h/w registers.
> > I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> > need to use read[lw]_relaxed and write[lw]_relaxed functions.
> > If the first simply reads/writes register, the second will byteswap
> > it if host operates in BE mode.
> >=20
> > Changes are trivial sed like replacement of __raw_xxx functions
> > with xxx_relaxed variant.
> >=20
> > Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> > Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> > ---
> >  drivers/usb/musb/musb_io.h |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
> > index eebeed7..76f4d2a 100644
> > --- a/drivers/usb/musb/musb_io.h
> > +++ b/drivers/usb/musb/musb_io.h
> > @@ -42,17 +42,17 @@
> >  /* NOTE:  these offsets are all in bytes */
> > =20
> >  static inline u16 musb_readw(const void __iomem *addr, unsigned offset)
> > -	{ return __raw_readw(addr + offset); }
> > +	{ return readw_relaxed(addr + offset); }
>=20
> x86 doesn't provide any of the write?_relaxed methods so this breaks
> build on x86 at least.

here's an untested patch which would "solve" the problem:

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..b6ad164 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -73,6 +73,9 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 #define __raw_readw __readw
 #define __raw_readl __readl
=20
+#define writeb_relaxed(d, a) __writeb(d, a)
+#define writew_relaxed(d, a) __writew(d, a)
+#define writel_relaxed(d, a) __writel(d, a)
 #define __raw_writeb __writeb
 #define __raw_writew __writew
 #define __raw_writel __writel
@@ -85,6 +88,7 @@ build_mmio_read(readq, "q", unsigned long, "=3Dr", :"memo=
ry")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
=20
 #define readq_relaxed(a)	readq(a)
+#define writeq_relaxed(d, a)	writeq(d, a)
=20
 #define __raw_readq(a)		readq(a)
 #define __raw_writeq(val, addr)	writeq(val, addr)


I'm not sure if it's correct though. Someone would have to tell me if
it's correct or not. For now, I have dropped $subject from my
testing/next branch.

--=20
balbi

--yXyGAOZGgonRe4uu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk8ucAAoJEIaOsuA1yqREA/UP/2JLqTG1p0UyoDBkiSEZjwm4
1IeqSpDr+ftc+3/zUJ/CcYxYJTYq4bOEJU2ThnAm7TvOmSdiaQnaJ4w2IOEPeJaI
cXqn7xYoQkLCXiVtzEaHCfY1uICrplD4IQRfIbJa+Xn96LOQ2oV5gdOe4Ge9VmpA
GDLxMbhc0S1gAS6WseO2QiFYSoZNLDwJL2LZu2rEis8vBjxhHbMx1hd0mMSpFGc1
CTaY3bEJe5mXyR1f8KownO072tN9rKwMG2J/nxqY5DxZReRebaOEezb8Xhv4rNfW
f1DRY8YC7SXmS+Jp7+w0/fCpsR9Iuqdi/w3QAPkdLTIYM4h5HyUY/Nl//0S+I/t5
keXW0yDbxGNR6z3PJMOoOF9FnHfVQ7+wzUuRK38jvqnCW+obJrAct2P9DTglapN2
O1Xwj2JAI3c+uxELNEgcpkU9+zncw4fS+7CavTl/TTBpclyO+WzfHng62+g7hRZS
GajEnUqw6Pg3oMSz51+9Kik7nLRfxPH1J4nbQ2J2JSR0DEzE7OhD9Cn/bZ6Lg/MR
Zs1U4Nn484gcWxbLVh9BjVayIq96rLmCfiQzoMPppRAnemPLbcjjSfm1EDdRrPaZ
mDr9KXcgOGwKBgvqjU1Ij4WPEa4KF+llECJN+KMdhWAdZdNAWQZh6ZO8UQHsDafr
eF9xYxieqWs+3K/Wm8SE
=BMdd
-----END PGP SIGNATURE-----

--yXyGAOZGgonRe4uu--
