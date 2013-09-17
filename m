Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3IQPtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:49:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49091 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3IQPtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:49:05 -0400
Date: Tue, 17 Sep 2013 10:45:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Roger Quadros <rogerq@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        <george.cherian@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY
Message-ID: <20130917154509.GJ15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
 <1378136591-7463-2-git-send-email-kishon@ti.com>
 <52319912.8030203@ti.com>
 <CAFp+6iE+xbSWWp2bNc5MRSUrA4Fi6qVU4vhR4+mtZHZGidkMGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
Content-Disposition: inline
In-Reply-To: <CAFp+6iE+xbSWWp2bNc5MRSUrA4Fi6qVU4vhR4+mtZHZGidkMGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 12, 2013 at 04:17:08PM +0530, Vivek Gautam wrote:
> On Thu, Sep 12, 2013 at 4:06 PM, Roger Quadros <rogerq@ti.com> wrote:
> > Hi Kishon,
> >
> > On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> >> There can be systems which does not have a external usb_phy, so get
> >> usb_phy only if usb-phy property is added in the case of dt boot or if
> >> platform_data indicates the presence of PHY. Also remove checking if
> >> return value is -ENXIO since it's now changed to always enable usb_phy=
 layer.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >>  drivers/usb/dwc3/Kconfig         |    1 +
> >>  drivers/usb/dwc3/core.c          |   60 +++++++++++++++++------------=
---------
> >>  drivers/usb/dwc3/platform_data.h |    1 +
> >>  3 files changed, 28 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> >> index f969ea2..cfc16dd 100644
> >> --- a/drivers/usb/dwc3/Kconfig
> >> +++ b/drivers/usb/dwc3/Kconfig
> >> @@ -2,6 +2,7 @@ config USB_DWC3
> >>       tristate "DesignWare USB3 DRD Core Support"
> >>       depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
> >>       depends on EXTCON
> >> +     select USB_PHY
> >>       select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
> >>       help
> >>         Say Y or M here if your system has a Dual Role SuperSpeed
> >> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >> index 474162e..428c29e 100644
> >> --- a/drivers/usb/dwc3/core.c
> >> +++ b/drivers/usb/dwc3/core.c
> >> @@ -387,16 +387,38 @@ static int dwc3_probe(struct platform_device *pd=
ev)
> >>       if (node) {
> >>               dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> >>
> >> -             dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-=
phy", 0);
> >> -             dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-=
phy", 1);
> >> +             if (of_property_read_bool(node, "usb-phy")) {
> >> +                     dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(de=
v,
> >> +                             "usb-phy", 0);
> >> +                     if (IS_ERR(dwc->usb2_phy))
> >> +                             return PTR_ERR(dwc->usb2_phy);
> >> +                     dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(de=
v,
> >> +                             "usb-phy", 1);
> >> +                     if (IS_ERR(dwc->usb3_phy))
> >> +                             return PTR_ERR(dwc->usb3_phy);
> >
> > Some DWC3 instances use only usb2_phy. e.g. on DRA7 the 2nd dwc3 instan=
ce doesn't use usb3_phy.
> > This needs to be a valid case and driver shouldn't error out.
>=20
> So, i think adding flexibility to DWC3 to have either
> usb2-phy/usb3-phy or both of them seems to be valid point.
> Any suggestions ?

I've gone through that. There's no easy way to make USB3 PHY optional.

For platforms which actually have the USB3 side of things, not
initializing the PHY kills dwc3.

I've been trying to understand what it is that the USB3 PHY generates
and gets backfed into dwc3, but so far no luck.

I even have a patch for that, which I have dropped when I found out
about this problem.

--=20
balbi

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHkFAAoJEIaOsuA1yqREI+QP+wXTnOtz61O0X2jqImlVG463
mjX+fp5xf82wkFmsaVHzvnji1iqdc7ArvOjejIlhDpvtaA9TftAGCvS5OKYFBAjy
Vf4ZtbFmw0gh82MOcmHQCWibV+5M9MiwYf16zsZXFXLUPWCm+VvShrZR2ESEJ1Xe
sruFZWLFf8xFGt8HpWhrQUQejnvaBVEQDhjuF4muGu8c3TYsxLmSr/CqymZm9FMH
J2z7QkbAYHFi6sPBFJbPPoHrSLZzbmeAFYQdyZ/GJYjiu9XKvb2DLewbkBXDm/fT
re8PcDg0ddG05eOG9PSd7nuzyVw3c5EcpjXU5UAHNAM+lLnFQ6ajizTeMH2YDEAA
CXDuVfq6QYgQ69xO3JejubFrvc6EF7dqjG30fpm2YALLtKnbzfFSWOKbzp9yKG4n
SFZMkosMHe9LiCEOsMuv187ClWCdmYkQalwq5++PA4drOcQ/KDgTZAD6EgU0Drma
S4ekQnfuZCXHc2Ryw1ek/hE51OI0Sy97Ww9S1JFtTnvZ4PV0Om2RdwEivDwbmC66
aA8LIZo6X66okEsRk+lUlneHDDgdQ92gEv1OhYf/2JRVPBHhy+6Qd66DLwd+HOW0
01csfFM7IZhAVuP0J5ZbQB1+k8bL2Q7IhW/XhbOJlypJVAWuoWaUNPTRCHb7Jp4K
YqAhR/yarpQxFKP+zTfV
=OIPS
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
