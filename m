Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3A1MNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:13:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36936 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3A1MM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:12:57 -0500
Date: Mon, 28 Jan 2013 14:12:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] usb: dwc3: exynos: Enable runtime power management
Message-ID: <20130128121231.GH28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
 <20130128114755.GF28698@arwen.pp.htv.fi>
 <CAFp+6iEb4R3NQkvtrY8X4h8oMwPf7E+LDYfb_cS5z2WfdGHNWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEb4R3NQkvtrY8X4h8oMwPf7E+LDYfb_cS5z2WfdGHNWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 28, 2013 at 05:28:30PM +0530, Vivek Gautam wrote:
> >> +static int dwc3_exynos_runtime_resume(struct device *dev)
> >> +{
> >> +     struct dwc3_exynos      *exynos =3D dev_get_drvdata(dev);
> >> +     struct platform_device  *pdev_dwc =3D exynos->dwc3;
> >> +     struct dwc3             *dwc =3D NULL;
> >> +
> >> +     dwc =3D platform_get_drvdata(pdev_dwc);
> >> +
> >> +     clk_enable(exynos->clk);
> >> +
> >> +     if (!dwc)
> >> +             return 0;
> >> +
> >> +     pm_runtime_get_sync(dwc->usb3_phy->dev);
> >
> > dude, this is wrong :-)
> >
> > look at this:
> >
> > pm_runtime_get() -> dwc3_exynos_runtime_resume() ->
> > pm_runtime_get_sync() -> dwc3_exynos_runtime_resume() -> ...
> >
> > only your clock enalbe should do
> >
>=20
> We want to wake up "dwc->usb3_phy" so tried to call pm_runtime_get_sync()
> with "dwc->usb3_phy->dev".
> Missing something ? :-(

oh, my bad. That's the PHY... But we can't really do that for samsung
only. It needs to be done generically for the entire dwc3 core driver,
and for that we need to introduce usb_phy_autopm_get(),
usb_phy_autopm_get_sync() and friends.

Then, from dwc_probe() we call:

phy =3D usb_get_phy();
usb_phy_autopm_enable(phy);
usb_phy_autopm_get_sync(phy);

or something similar ;-) Bottom line, you shouldn't fiddle with phy->dev
directly.

--=20
balbi

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBmsvAAoJEIaOsuA1yqREavAQALWOFDxyumbTkI6lXtC8YX5f
Y9cnlIbLXFoqq+4qgLF3vds5uxT7HTNejw4qa1Cs1fIcc2L/VXeDn+AJYoL6357l
ynLcugulc8os0li8lWpDsyP1xEb+nlfqVbFzbmZNGHgPSpvlZ5+9OM2EcoQKh6EL
s0JQ3dOdOjMqDuqVHmo9opTj1OTIdNiYk7hmRAbxlx5YiCqY1hwZMaEl7zjeWNVB
SSb2HdastxppYXWvOVyEmteHcKonuOUX5TxOmPZcykvw4Gs7EgqfxvtCZPNZAY13
xRSMefDAMPULNxCZ+pRa0+UDujmoxY1keJvWvWqr1Li5F6rfFW1ty5OUveTv6M0O
+IL0LiY8/fZlU8prQlSlQD1qAS8KRZz/KD/kaiCyYz/brTlS3DInTJ2Eb4fBfW7p
3cXBt9tGwfAc/FW805wL1ajnyi4b78NraR0OzB0NtPv7flSGL11v6lRGEIKtTFo9
5ER07ely6lhjStSi2nqyIOnV1ITK7gSWOWS2MoAwGroOLFHLUq9nRSRnw2pdX0nD
oV35ykTBONM02XoxCAl+W9Otx32+hdIjUCKpB/DGXidiInzqwFMLoLKEK8pHa6ef
FX1HNdzexuaqXvUJKo278TZ8I3Yd28WTntoRdivpF03iranBIWDkqgqKy8KXzyOJ
IrFvI66vJPFgaA/mpjhK
=HoRc
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
