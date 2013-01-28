Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3A1M3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:29:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44788 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab3A1M31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:29:27 -0500
Date: Mon, 28 Jan 2013 14:29:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] usb: dwc3: exynos: Enable runtime power management
Message-ID: <20130128122902.GK28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
 <20130128114755.GF28698@arwen.pp.htv.fi>
 <CAFp+6iEb4R3NQkvtrY8X4h8oMwPf7E+LDYfb_cS5z2WfdGHNWA@mail.gmail.com>
 <20130128121231.GH28698@arwen.pp.htv.fi>
 <CAFp+6iHvH8ZXRGEb=5AsVX+Ks+mAaPqwWW9DhH9O7RNdKo+cgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bX/mw5riLlTkt+Gv"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHvH8ZXRGEb=5AsVX+Ks+mAaPqwWW9DhH9O7RNdKo+cgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bX/mw5riLlTkt+Gv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 05:57:04PM +0530, Vivek Gautam wrote:
> On Mon, Jan 28, 2013 at 5:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Jan 28, 2013 at 05:28:30PM +0530, Vivek Gautam wrote:
> >> >> +static int dwc3_exynos_runtime_resume(struct device *dev)
> >> >> +{
> >> >> +     struct dwc3_exynos      *exynos =3D dev_get_drvdata(dev);
> >> >> +     struct platform_device  *pdev_dwc =3D exynos->dwc3;
> >> >> +     struct dwc3             *dwc =3D NULL;
> >> >> +
> >> >> +     dwc =3D platform_get_drvdata(pdev_dwc);
> >> >> +
> >> >> +     clk_enable(exynos->clk);
> >> >> +
> >> >> +     if (!dwc)
> >> >> +             return 0;
> >> >> +
> >> >> +     pm_runtime_get_sync(dwc->usb3_phy->dev);
> >> >
> >> > dude, this is wrong :-)
> >> >
> >> > look at this:
> >> >
> >> > pm_runtime_get() -> dwc3_exynos_runtime_resume() ->
> >> > pm_runtime_get_sync() -> dwc3_exynos_runtime_resume() -> ...
> >> >
> >> > only your clock enalbe should do
> >> >
> >>
> >> We want to wake up "dwc->usb3_phy" so tried to call pm_runtime_get_syn=
c()
> >> with "dwc->usb3_phy->dev".
> >> Missing something ? :-(
> >
> > oh, my bad. That's the PHY... But we can't really do that for samsung
> > only. It needs to be done generically for the entire dwc3 core driver,
> > and for that we need to introduce usb_phy_autopm_get(),
> > usb_phy_autopm_get_sync() and friends.
> >
>=20
> aah!! Ok. I definitely missed that part. :-(
>=20
> > Then, from dwc_probe() we call:
> >
> > phy =3D usb_get_phy();
> > usb_phy_autopm_enable(phy);
> > usb_phy_autopm_get_sync(phy);
> >
> > or something similar ;-) Bottom line, you shouldn't fiddle with phy->dev
> > directly.
> >
>=20
> Ok, the core should actually be handling the 'phy' not the glue layers.
> Right ?

that's right, thanks for doing this ;-)

> Will try putting these helper functions in place and come up with a
> solution. :-)

awesome ;-)

cheers

--=20
balbi

--bX/mw5riLlTkt+Gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBm8OAAoJEIaOsuA1yqREKCgP/2bAZHHZ8rmyhE93lUj/U/E2
jhuawf0rWh0Y9NPSx3KrAzsTN4vKHvxOTO8p9MOm+AJloCWk0yE/R5bzfQ83poxc
ZSg0MZGo22VtRKbaXhh8T7ihELVjBo0LF66tXboDp0ozNPCYd0O2OA392U4X1tbs
+V7RWOLVf6s5T7Kl4L6QPGz8qugs3A/ZA4Gb987XphxY+REH+LImpCSakk7fowUl
0eNR/z6Rc091oIHEp2jV+6L7yLAVkaWQNZQ/6DBFXBBsv49414vAqsFFo9mXx8/e
yngPaP7g7B1h+9jpTU5Ep9/F/l6dHS5eL0eTjEaWK06oQIGAtaN6rNoudILK6TDz
c/7R7hL0MJ3TmNjthh6QNHGtaLYfHLcucEIn6yEbiJmCsUZQiwvj+dAMVV7BFMEK
cYimykPtIT+2p6MarYsUJO6BxYUXIsVgfA1AZ040m4JukBwI+aljZSJjZzYyEUZh
q6Zxq2dH1B3oUm+XFsHmnQ5Lfxs/xisMm8iH2hjnO2f4/ba0iOXBRQDXTFDUh9wD
GKoQeiGzAr5paed6h43jFFc5eqB2fp+0swi/1IZfPu1FxGo51F5OhgDRDQm42FLq
79HKw6Y8ehsOv+1I7D1KXe9pjdghk3l8VzPIF1eNfm+1ZCBT+j16bQk63w2j95jt
GXjFwQzbEIG26y/KXV5W
=D5gd
-----END PGP SIGNATURE-----

--bX/mw5riLlTkt+Gv--
