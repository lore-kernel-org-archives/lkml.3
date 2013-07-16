Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3GPIXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:23:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54488 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3GPIXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:23:25 -0400
Date: Tue, 16 Jul 2013 11:22:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Daniel Mack <zonque@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130716082247.GD8880@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
 <51E4EF70.3040502@ti.com>
 <20130716080836.GC8880@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <20130716080836.GC8880@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2013 at 11:08:36AM +0300, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Jul 16, 2013 at 12:30:00PM +0530, Kishon Vijay Abraham I wrote:
> > On Tuesday 16 July 2013 12:03 PM, Daniel Mack wrote:
> > > Hi Aaro,
> > >=20
> > > On 16.07.2013 00:56, Aaro Koskinen wrote:
> > >> Hi,
> > >>
> > >> I think USB tree introduced regressions in v3.11-rc1, at least for s=
ome
> > >> OMAP devices using legacy boot.
> > >=20
> > > Thanks for checking the tree so early.
> > >=20
> > >> I have only bisected these; I have no
> > >> idea what the real fixes are but the following reverts make Nokia OM=
AP2+
> > >> boards again usable for kernel development work (they need working U=
SB
> > >> connection for interacting with the device):
> > >>
> > >> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
> > >>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
> > >>    commits:
> > >>
> > >> 	09fc7d22b024692b2fe8a943b246de1af307132b
> > >> 	usb: musb: fix incorrect usage of resource pointer
> > >> 	(Reverting this fixes the g_ether probe failure "couldn't find
> > >> 	 an available UDC")
> >=20
> > I've posted a patch fixing the issue
> > http://comments.gmane.org/gmane.linux.usb.general/89541
> > There were some comments on it. I'll be posting a new version for it.
>=20
> hmm, n8x0 used tusb6010, so perhaps a similar patch needs to be cooked
> for that too. Right now, let's to the minimum fix, which is just to
> increment the array size to 3 and for v3.12 we do the changes that I
> suggested.

this should solve the problem on n900 and n8x0, it's pretty much
kishon's original patch, so I guess it deserves his authorship:

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 6708a3b..f44e8b5 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -481,7 +481,7 @@ static u64 omap2430_dmamask =3D DMA_BIT_MASK(32);
=20
 static int omap2430_probe(struct platform_device *pdev)
 {
-	struct resource			musb_resources[2];
+	struct resource			musb_resources[3];
 	struct musb_hdrc_platform_data	*pdata =3D pdev->dev.platform_data;
 	struct omap_musb_board_data	*data;
 	struct platform_device		*musb;
@@ -581,6 +581,11 @@ static int omap2430_probe(struct platform_device *pdev)
 	musb_resources[1].end =3D pdev->resource[1].end;
 	musb_resources[1].flags =3D pdev->resource[1].flags;
=20
+	musb_resources[2].name =3D pdev->resource[2].name;
+	musb_resources[2].start =3D pdev->resource[2].start;
+	musb_resources[2].end =3D pdev->resource[2].end;
+	musb_resources[2].flags =3D pdev->resource[2].flags;
+
 	ret =3D platform_device_add_resources(musb, musb_resources,
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 2c06a89..6f8a9ca 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1156,7 +1156,7 @@ static u64 tusb_dmamask =3D DMA_BIT_MASK(32);
=20
 static int tusb_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource musb_resources[3];
 	struct musb_hdrc_platform_data	*pdata =3D pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct tusb6010_glue		*glue;
@@ -1199,6 +1199,11 @@ static int tusb_probe(struct platform_device *pdev)
 	musb_resources[1].end =3D pdev->resource[1].end;
 	musb_resources[1].flags =3D pdev->resource[1].flags;
=20
+	musb_resources[2].name =3D pdev->resource[2].name;
+	musb_resources[2].start =3D pdev->resource[2].start;
+	musb_resources[2].end =3D pdev->resource[2].end;
+	musb_resources[2].flags =3D pdev->resource[2].flags;
+
 	ret =3D platform_device_add_resources(musb, musb_resources,
 			ARRAY_SIZE(musb_resources));
 	if (ret) {

--=20
balbi

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5QLXAAoJEIaOsuA1yqREUTgQALDwjHa3LTuQIIi3oU63IFi1
X6ZlXFSx7H5dFmz0rKF78PdLTH6DiwucMaktcM2w9DFhHE1msY9oXRkzXgSFUvK3
i6MqKW+HoEKFgeP4vUNQ+4gHT5l5Yna/H16O29Q+a0TR/NWjovrcycA1Zz0DboKh
L+p8Zf/vlcg3RTgw/YfjBXyBJ2rGyg0JHaWyte/EQI3FUuQyNaEMEuV/r6nngp4t
MAIu5dhrSf8e79tXRAVnFobvbNM1IMuN+C767azXhiCXgd2V54MeVc/fivs3V1TP
v11HoEq6XMSZVUeAA8+VWtp9dxBL924Je8GxTNImpTAjrGjPUEHVQfGRGk8LYzEi
fpGsxbtOgm2IZ0Dt8RmOrJc6S16cTk1qgOz9Z9t2Vn6+aISZTodiu9fOugChnr4x
2KaZbps7WzZoULnoRaS8ilBz6pWyaJ+fhret0/eL0PECRONnZ52kCVgI00qf7fSI
UXY7WTK3hPIljQewuRA1kGCyT6gsbM6/7m914Mm730cVQxr504kcRBj36ssZu0zT
Be2GjVA/+xSxZZD2bi4hSS5mp14S+DSJNoaMB6tdp7knKZ4PHNhi8gaVVU2Cxg9d
9UCPnnKqI9fbWTTm/U2kUykSsP7xVHpyb+rJbJtqOXRYENhEw0GZ/iE5bFeGMGQh
/KFrdvGdS32vA72bqv1b
=yffj
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
