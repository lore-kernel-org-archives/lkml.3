Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3JON57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:57:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53857 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3JON55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:57:57 -0400
Date: Tue, 15 Oct 2013 08:56:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Vivek Gautam <gautamvivek1987@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
Message-ID: <20131015135655.GK11380@radagast>
Reply-To: <balbi@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
 <1378136591-7463-3-git-send-email-kishon@ti.com>
 <525814A9.7060106@ti.com>
 <525BB8C0.1070802@ti.com>
 <525BC5A9.3060904@ti.com>
 <20131015115741.GD11380@radagast>
 <525D30C2.8060208@ti.com>
 <20131015131934.GG11380@radagast>
 <525D47C3.207@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f54savKjS/tSNRaU"
Content-Disposition: inline
In-Reply-To: <525D47C3.207@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f54savKjS/tSNRaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 15, 2013 at 04:48:51PM +0300, Roger Quadros wrote:
> On 10/15/2013 04:19 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Oct 15, 2013 at 03:10:42PM +0300, Roger Quadros wrote:
> >>>>>>> @@ -665,6 +669,9 @@ struct dwc3 {
> >>>>>>>  	struct usb_phy		*usb2_phy;
> >>>>>>>  	struct usb_phy		*usb3_phy;
> >>>>>>> =20
> >>>>>>> +	struct phy		*usb2_generic_phy;
> >>>>>>> +	struct phy		*usb3_generic_phy;
> >>>>>>> +
> >>>>>>>  	void __iomem		*regs;
> >>>>>>>  	size_t			regs_size;
> >>>>>>> =20
> >>>>>>>
> >>>>>
> >>>>> Do you have any suggestions on how to get only individual PHYs? lik=
e only
> >>>>> usb2phy or usb3phy?
> >>>>
> >>>> My earlier understanding was that both PHYs are needed only if .spee=
d is "super-speed"
> >>>> and only usb2phy is needed for "high-speed". But as per Vivek's emai=
l it seems
> >>>> Samsung's exynos5 SoC doesn't need usb2phy for "super-speed".
> >>>>
> >>>> So to keeps things flexible, I can propose the following approach
> >>>> - if speed =3D=3D 'high-speed' usb2phy must be present. usb3phy will=
 be ignored if supplied.
> >>>> - if speed =3D=3D 'super-speed' usb3phy must be present and usb2phy =
is optional but must be
> >>>> initialized if supplied.
> >>>> - if speed is not specified, we default to 'super-speed'.
> >>>>
> >>>> Felipe, does this address the issue you were facing with OMAP5?
> >>>
> >>> on OMAP5 we cannot skip USB3 PHY initialization. But then it becomes a
> >>> question of supporting a test feature (in OMAP5 case it would be cool=
 to
> >>> force controller to lower speeds for testing) or coping with a broken
> >>> DTS.
> >>>
> >>
> >> I don't think we can protect ourselves from all possible broken
> >> configurations of DTS.
> >> I would vote for simplicity and maximum flexibility.
> >>
> >> So IMO we should just depend on DTS to provide the phys that are
> >> needed by the platform.
> >> In the driver we initialize whatever PHY is provided and don't
> >> complain if any or even all PHYs are missing.
> >=20
> > considering that DTS is an ABI, I really think eventually we *will* have
> > broken DTBs burned into ROM and we will have to find ways to work with
> > those too. Same thing already happens today with ACPI tables.
> >=20
> >> If this is not good enough then could you please suggest an
> >> alternative? Thanks.
> >=20
> > The alternative would be to mandate nop xceiv for the "missing" PHY, but
> > that doesn't solve anything, really, as DTS authors might still forget
> > about the NOP xceiv and you can argue that forcing NOP xceiv would be a
> > SW configuration.
> >=20
> > So, perhaps we go with the approach that all PHYs are optional, and
> > here's my original patch which makes USB3 PHY optional:
> >=20
> > commit 979b84f96e4b7559b596b2933ae198aba267f260
> > Author: Felipe Balbi <balbi@ti.com>
> > Date:   Sun Jun 30 18:39:23 2013 +0300
> >=20
> >     usb: dwc3: core: make USB3 PHY optional
> >    =20
> >     If we want a port to work at any speed lower
> >     than Superspeed, it makes no sense to even
> >     initialize/power up the USB3 transceiver,
> >     provided it won't be used.
> >    =20
> >     We can use the oportunity to save some power
> >     and leave the superspeed transceiver powered
> >     off.
> >    =20
> >     There is at least one such case which is
> >     Texas Instruments' AM437x which has one
> >     of its USB3 ports without a matching USB3
> >     PHY (that port is hardwired to work on USB2
> >     only).
> >    =20
> >     Signed-off-by: Felipe Balbi <balbi@ti.com>
> >=20
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 74f9cf0..7a5ab93 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -387,16 +387,34 @@ static int dwc3_probe(struct platform_device *pde=
v)
> >  	if (node) {
> >  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> > =20
> > -		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> > -		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> > +		switch (dwc->maximum_speed) {
> > +		case USB_SPEED_SUPER:
> > +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> > +			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> > +			break;
> > +		case USB_SPEED_HIGH:
> > +		case USB_SPEED_FULL:
> > +		case USB_SPEED_LOW:
> > +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> > +			break;
> > +		}
> > =20
> >  		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-resi=
ze");
> >  		dwc->dr_mode =3D of_usb_get_dr_mode(node);
> >  	} else if (pdata) {
> >  		dwc->maximum_speed =3D pdata->maximum_speed;
> > =20
> > -		dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > -		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> > +		switch (dwc->maximum_speed) {
> > +		case USB_SPEED_SUPER:
> > +			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > +			dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> > +			break;
> > +		case USB_SPEED_HIGH:
> > +		case USB_SPEED_FULL:
> > +		case USB_SPEED_LOW:
> > +			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > +			break;
> > +		}
>=20
> What if we try to get both PHYs irrespective of 'maximum_speed' but based
> on presence of phandle/pdata. That way there is some control in the adapt=
ation code (dts/pdata)
> as to which PHYs needs to be initialized for that particular instance.
>=20
> This is because there doesn't seem to be a consensus between different de=
signs.
> e.g. omap5 needs both phys for 'high-speed' whereas exynos5250 needs just=
 the
> usb3 phy for 'super-speed'

sure, can you write such a patch ? If it gets to my inbox in a couple
hours I guess I can still review and take it upstream on v3.13,
otherwise it's only on v3.14 :-(

>=20
> > =20
> >  		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
> >  		dwc->dr_mode =3D pdata->dr_mode;
> > @@ -424,19 +442,21 @@ static int dwc3_probe(struct platform_device *pde=
v)
> >  		return -EPROBE_DEFER;
> >  	}
> > =20
> > -	if (IS_ERR(dwc->usb3_phy)) {
> > -		ret =3D PTR_ERR(dwc->usb3_phy);
> > +	if (dwc->maximum_speed =3D=3D USB_SPEED_SUPER) {
> > +		if (IS_ERR(dwc->usb3_phy)) {
> > +			ret =3D PTR_ERR(dwc->usb3_phy);
> > =20
> > -		/*
> > -		 * if -ENXIO is returned, it means PHY layer wasn't
> > -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> > -		 * in that case, since no PHY driver will ever probe.
> > -		 */
> > -		if (ret =3D=3D -ENXIO)
> > -			return ret;
> > +			/*
> > +			 * if -ENXIO is returned, it means PHY layer wasn't
> > +			 * enabled, so it makes no sense to return -EPROBE_DEFER
> > +			 * in that case, since no PHY driver will ever probe.
> > +			 */
> > +			if (ret =3D=3D -ENXIO)
> > +				return ret;
> > =20
> > -		dev_err(dev, "no usb3 phy configured\n");
> > -		return -EPROBE_DEFER;
> > +			dev_err(dev, "no usb3 phy configured\n");
> > +			return -EPROBE_DEFER;
> > +		}
> >  	}
> > =20
> >  	dwc->xhci_resources[0].start =3D res->start;
> >=20
> >=20
> > what you guys are saying though, is that every PHY should be optional.
> >=20
> > Do we have any device which doesn't provide USB2 PHY, only USB3 ? Dude,
> > that's so non-standard! USB *must* be backwards compatible so I'd expect
> > USB2 PHY to always be available.
> >=20
>=20
> Maybe the USB2 PHY hardware is there on the Exynos5250 but it just
> doesn't have discrete power control.  Vivek?

I'd really like to hear that answer :-) But patch can come before that,
though.

cheers

--=20
balbi

--f54savKjS/tSNRaU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXUmnAAoJEIaOsuA1yqREPzgQAIx+n7uTfn/QwnQMZwWzPDNe
CpR/wsrMmnKA7Z1wZVix8oQAgkVLEf0lkpPYiBafQ4W22+7eQMx1bWZzG2HPXTRk
uuprV4QaMQhRx/22ODZZUtRRIrCxceRw7Kk7dAU4FEAisks/l0TheeYLVfpYHPal
BMlWF10qHmWuh96Az44yR6uzVpuA0V/Z2zYBgKML60gFERaGyGcY3qw2iE4iyFns
Y/PdAwBQEdottpgkvZLLFPgwzfjcSGWHqETaPi2z2kTF1A+8fGR7t0tnu8yL1hk3
imn11EQjpuIVvlYYb/Kc5xvpMXcnmQKZrae7Y0at278Yz1WI9QRcJmIF2VhsdcXI
gHl9v7qGx6zwPAul5EK50A3XYWPklVuv8X354XXp32gGufmNGgFWDyB2iCp/I/vN
9OKgAtENovKLejRT3x9B/mBwiGfOp0EJNUgClBRUeYNfJZkg/Z3hyg4HP69vkFe5
sropRlZy4iyc3AMzPIjIQipqJNVZEeLgbgZlpD3NLzv7OynnKyZL9JotnBbSYEep
vRzwxm+Bl/6ALaganpPDRVDXSfZKj4mD5aDN+nsj2IvZZ3cQWWnbkj6YSQP3rvs8
O5K4Zqt5kKx7IwSJyKe/MK9tK0ObuDNo6yDyqMMARg9BEkLs//fT3ueAgiNajJ3a
39E4+zLZjubQ2t8myvT5
=E26e
-----END PGP SIGNATURE-----

--f54savKjS/tSNRaU--
