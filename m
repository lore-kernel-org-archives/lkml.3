Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaDQQbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:31:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60702 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaDQQbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:31:25 -0400
Date: Thu, 17 Apr 2014 11:28:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <yuxu@marvell.com>
Subject: Re: [PATCH] usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
Message-ID: <20140417162855.GB22861@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397561783.1985.55.camel@x220>
 <20140415172310.GD16002@saruman.home>
 <1397585312.8212.13.camel@x220>
 <20140416043450.GB15056@saruman.home>
 <1397721028.24336.13.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <1397721028.24336.13.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 09:50:28AM +0200, Paul Bolle wrote:
> On Tue, 2014-04-15 at 23:34 -0500, Felipe Balbi wrote:
> > $ make drivers/usb/phy/phy-mv-u3d-usb.o
> >   CHK     include/config/kernel.release
> >   CHK     include/generated/uapi/linux/version.h
> >   CHK     include/generated/utsrelease.h
> > make[1]: `include/generated/mach-types.h' is up to date.
> >   CALL    scripts/checksyscalls.sh
> >   CC      drivers/usb/phy/phy-mv-u3d-usb.o
>=20
> (On x86_64 this manual make command triggers the error Greg reported in
> https://lkml.org/lkml/2014/2/11/693 .)
>=20
> > yup, builds just fine. Even if the ARCH support isn't in place, this
> > driver is *not* breaking anything, it's not preventing anyone from
> > getting work done and it might be helping Marvell decrease the amount of
> > changes they keep out of tree.
> >=20
> > I don't see any problems this driver in tree as long as there are people
> > working on it and I see the latest commit was 10 days ago, it wouldn't
> > be fair to Marvell to delete their driver if they're still finding ways
> > to make it useful one way or another.
>=20
> Wouldn't it then be better if this driver is at least hooked into the
> build system? Like, say, this:
>     config MV_U3D_PHY
>             bool "Marvell USB 3.0 PHY controller Driver"
>             # XXX should depend on CPU_MMP3 when support for MMP3 lands
>             depends on ARM && COMPILE_TEST
>             select USB_PHY
>             help
>               Enable this to support Marvell USB 3.0 phy controller for M=
arvell
>               SoC.
>=20
> (Or perhaps only ARCH_MMP && COMPILE_TEST.) That should give it build
> coverage by the automated tests people appear to run, while work is done
> on adding MMP3 support.

I guess we should make it depend on BROKEN instead, or we just apply the
patch below:

8<---------------------------------------------------------------------

=46rom 60e524d7db4ed04624850fcb84a844c609a960e3 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Thu, 17 Apr 2014 11:24:27 -0500
Subject: [PATCH] usb: phy: mv-u3d: switch over to writel/readl

by removing the _relaxed suffix, we can build
this driver in other architectures.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/phy/phy-mv-u3d-usb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/phy/phy-mv-u3d-usb.c b/drivers/usb/phy/phy-mv-u3d-=
usb.c
index d317903..d342175 100644
--- a/drivers/usb/phy/phy-mv-u3d-usb.c
+++ b/drivers/usb/phy/phy-mv-u3d-usb.c
@@ -39,8 +39,8 @@ static u32 mv_u3d_phy_read(void __iomem *base, u32 reg)
 	addr =3D base;
 	data =3D base + 0x4;
=20
-	writel_relaxed(reg, addr);
-	return readl_relaxed(data);
+	writel(reg, addr);
+	return readl(data);
 }
=20
 static void mv_u3d_phy_set(void __iomem *base, u32 reg, u32 value)
@@ -51,10 +51,10 @@ static void mv_u3d_phy_set(void __iomem *base, u32 reg,=
 u32 value)
 	addr =3D base;
 	data =3D base + 0x4;
=20
-	writel_relaxed(reg, addr);
-	tmp =3D readl_relaxed(data);
+	writel(reg, addr);
+	tmp =3D readl(data);
 	tmp |=3D value;
-	writel_relaxed(tmp, data);
+	writel(tmp, data);
 }
=20
 static void mv_u3d_phy_clear(void __iomem *base, u32 reg, u32 value)
@@ -65,10 +65,10 @@ static void mv_u3d_phy_clear(void __iomem *base, u32 re=
g, u32 value)
 	addr =3D base;
 	data =3D base + 0x4;
=20
-	writel_relaxed(reg, addr);
-	tmp =3D readl_relaxed(data);
+	writel(reg, addr);
+	tmp =3D readl(data);
 	tmp &=3D ~value;
-	writel_relaxed(tmp, data);
+	writel(tmp, data);
 }
=20
 static void mv_u3d_phy_write(void __iomem *base, u32 reg, u32 value)
@@ -78,8 +78,8 @@ static void mv_u3d_phy_write(void __iomem *base, u32 reg,=
 u32 value)
 	addr =3D base;
 	data =3D base + 0x4;
=20
-	writel_relaxed(reg, addr);
-	writel_relaxed(value, data);
+	writel(reg, addr);
+	writel(value, data);
 }
=20
 static void mv_u3d_phy_shutdown(struct usb_phy *phy)
--=20
1.9.2.459.g68773ac


--=20
balbi

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUAFHAAoJEIaOsuA1yqREbwYQAK7dg0A87T9VUumuERD9uB08
5r9fzIuswAS+tu0yYoC+iaUFz1a7m0k+2oTNEOPx1UL+lT0I8z53xkD/q/zc1dZ8
Sh0pNw+XQn3pH/GWwxOxauqNbTEOgTeb81GSXO7vHOWeB+eHpeeHreOaL8Q/4K2G
eFw7RlWmEyH2TL3UdnPzjAjiB3iJUyjadaA0iVtdpqOZjplnYHsDAfONNj7s6KWI
fdIwfPFfo8VSnm4/JF5Y+zA0NBaQL/HHIBkuZH1Ko0ShYbnow8oIDWVwZgCKDfcH
TqsuUDFzBfPu8YFtIEPpnZI8/dvhvgSa9A0CRaAlBC05x15UWoXNvJlc0oKrurP6
8w9oMjKEIPYgJT6i1ab04QVe/cLk9VbfMUpLhh9/6f4bT6rWtm+4k482gVs07ylw
bv0rHP5WNboS8rmLqixEy2i9oHzA1f/5pU8YHPkfnPwydwklM+9O24qVApa98OGX
Cu5HEYUm4XL0Z2WJKFW+S/GIQCcdMrYFjIpAasweLDbskfhAxe9/cDGQHEYDj4LP
MAJsr1Iz2//Wl3H8gvMKYkLBqW6IlMIkro57ajDGssu4G0eVsM6WkXXhtZJupDxU
tPpkwNi/8rUDA5/rLWruBFxmZeSCnW8Fn7yuIV4qQH2LVi1m9BSxdkY+B3FrAuNr
98hvO/yF4yi3Otvhfyh6
=JPo/
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
