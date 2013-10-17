Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3JQOyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:54:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43560 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3JQOyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:54:52 -0400
Date: Thu, 17 Oct 2013 09:54:26 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
Message-ID: <20131017145425.GE11611@gimli>
Reply-To: <balbi@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
 <1381866857-3861-2-git-send-email-kishon@ti.com>
 <525E8E93.9010503@ti.com>
 <525E9046.3090209@ti.com>
 <525E943E.3080706@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Content-Disposition: inline
In-Reply-To: <525E943E.3080706@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 04:27:26PM +0300, Roger Quadros wrote:
> On 10/16/2013 04:10 PM, Kishon Vijay Abraham I wrote:
> > Hi roger,
> >=20
> > On Wednesday 16 October 2013 06:33 PM, Roger Quadros wrote:
> >> Hi Kishon,
> >>
> >> On 10/15/2013 10:54 PM, Kishon Vijay Abraham I wrote:
> >>> There can be systems which does not have a external usb_phy, so get
> >>> usb_phy only if dt data indicates the presence of PHY in the case of =
dt boot or
> >>> if platform_data indicates the presence of PHY. Also remove checking =
if
> >>> return value is -ENXIO since it's now changed to always enable usb_ph=
y layer.
> >>>
> >>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>> ---
> >>> In usb_get_phy_by_phandle, index 0 always refers to usb2 phy and inde=
x 1 always
> >>> refers to usb3 phy. Since we've lived so long with this, this patch w=
ill make
> >>> an assumption that if only one entry is populated in *usb-phy* proper=
ty, it will
> >>> be usb2 phy and the next entry will be usb3 phy.
> >>>
> >>>  drivers/usb/dwc3/Kconfig         |    1 +
> >>>  drivers/usb/dwc3/core.c          |   72 ++++++++++++++++++++--------=
----------
> >>>  drivers/usb/dwc3/platform_data.h |    2 ++
> >>>  3 files changed, 41 insertions(+), 34 deletions(-)
> >>>
> >>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> >>> index 70fc430..8e385b4 100644
> >>> --- a/drivers/usb/dwc3/Kconfig
> >>> +++ b/drivers/usb/dwc3/Kconfig
> >>> @@ -1,6 +1,7 @@
> >>>  config USB_DWC3
> >>>  	tristate "DesignWare USB3 DRD Core Support"
> >>>  	depends on (USB || USB_GADGET) && HAS_DMA
> >>> +	select USB_PHY
> >>>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
> >>>  	help
> >>>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> >>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >>> index 474162e..cb91d70 100644
> >>> --- a/drivers/usb/dwc3/core.c
> >>> +++ b/drivers/usb/dwc3/core.c
> >>> @@ -354,6 +354,7 @@ static int dwc3_probe(struct platform_device *pde=
v)
> >>>  	struct device_node	*node =3D dev->of_node;
> >>>  	struct resource		*res;
> >>>  	struct dwc3		*dwc;
> >>> +	int			count;
> >>> =20
> >>>  	int			ret =3D -ENOMEM;
> >>> =20
> >>> @@ -387,16 +388,49 @@ static int dwc3_probe(struct platform_device *p=
dev)
> >>>  	if (node) {
> >>>  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> >>> =20
> >>> -		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> >>> -		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> >>> +		count =3D of_count_phandle_with_args(node, "usb-phy", NULL);
> >>> +		switch (count) {
> >>> +		case 2:
> >>> +			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev,
> >>> +				"usb-phy", 1);
> >>> +			if (IS_ERR(dwc->usb3_phy)) {
> >>> +				dev_err(dev, "usb3 phy not found\n");
> >>> +				return PTR_ERR(dwc->usb3_phy);
> >>> +			}
> >>> +		case 1:
> >>> +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev,
> >>> +				"usb-phy", 0);
> >>> +			if (IS_ERR(dwc->usb2_phy)) {
> >>> +				dev_err(dev, "usb2 phy not found\n");
> >>> +				return PTR_ERR(dwc->usb2_phy);
> >>> +			}
> >>> +			break;
> >>
> >> In the Exynos case, there is only 1 phy and it is the USB3 phy. This c=
ode
> >> will wrongly treat it as usb2_phy.
> >=20
> > That was the case even before this patch no? Unfortunately the old USB =
PHY
> > library doesn't have APIs to get PHYs in a better way. If we try modify=
ing the
> > USB PHY library, it'll be kind of duplicating what is already there in =
the
> > Generic PHY library. I'd rather prefer Exynos guys to use the new frame=
work.
>=20
> OK. I agree with you.
> Do you know if there are users of dwc3 other than exynos5250 and omap5?
> If not, we should get rid of the old USB PHY altogether.

Intel's Baytrail, at least. But they don't use DT.

--=20
balbi

--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSX/ohAAoJEIaOsuA1yqRE6pIP/ib7lYpDsvp85gFngf6PsaHo
qFpD1B4ZAZc2P59YL2Ci/ec2BXs+Gat5zzULjDpZqUaZDVY/LeGQj8WG4kvs8jp5
bxMcFISzx3phDfBKUlE8s1NK2eZn4asovwH2nfGDIrhD4eP9r5olGlOn0q/5RduV
W0smPjh5kT2GhlK94VWBIJaHyrq4zL4VuH6z7p1BJDJcoHIz1i1n/pjBGChePFNB
omMvUpRXfdIt+T6fzOJPqDGrsfO7HQYaOaC15heaMqkPHaZ8l2e2HkL8AT1cwEig
KUXVUa8rQw6weWARH1hNSKlLrkIz2z6kMC69sMuw9fLJ0x+mdXgHAtRmULINuIPz
U3uaJQ9TLSvv/rCdbLdLkfVp1Hw0HX3i4W6sr6XKhMSD14+H4I/24J0e0asQQUK7
ZTfO4wntTkqNBgOcCCN2gPX8YAmcX6MeLCfiF/XK4tQni30eW8rot7kcuhl/gFQi
7tBtE3LyOcHarU3nZ7QCnnA2DWXi/XLBWROWdZPLsJZiiB7fZqbQ0eIqfRnVDeEq
tgf3VEik0kKBV46iNQMTxX+KOv8vs7ymProMNU1yUy647w8xpy/vozrkSMIK+btq
TcGXVgc845NEEnQlUcdzKZonawSU1rdT/8dFWdznnjvkelEJr1WGgUZaGBtT9Ki3
j7T5n6NSbkqZIRCPeKMN
=v7te
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--
