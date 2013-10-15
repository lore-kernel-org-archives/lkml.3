Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3JONUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:20:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54610 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3JONU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:20:28 -0400
Date: Tue, 15 Oct 2013 08:19:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautamvivek1987@gmail.com>, <bcousson@baylibre.com>,
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
Message-ID: <20131015131934.GG11380@radagast>
Reply-To: <balbi@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
 <1378136591-7463-3-git-send-email-kishon@ti.com>
 <525814A9.7060106@ti.com>
 <525BB8C0.1070802@ti.com>
 <525BC5A9.3060904@ti.com>
 <20131015115741.GD11380@radagast>
 <525D30C2.8060208@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cyV/sMl4KAhiehtf"
Content-Disposition: inline
In-Reply-To: <525D30C2.8060208@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cyV/sMl4KAhiehtf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 15, 2013 at 03:10:42PM +0300, Roger Quadros wrote:
> >>>>> @@ -665,6 +669,9 @@ struct dwc3 {
> >>>>>  	struct usb_phy		*usb2_phy;
> >>>>>  	struct usb_phy		*usb3_phy;
> >>>>> =20
> >>>>> +	struct phy		*usb2_generic_phy;
> >>>>> +	struct phy		*usb3_generic_phy;
> >>>>> +
> >>>>>  	void __iomem		*regs;
> >>>>>  	size_t			regs_size;
> >>>>> =20
> >>>>>
> >>>
> >>> Do you have any suggestions on how to get only individual PHYs? like =
only
> >>> usb2phy or usb3phy?
> >>
> >> My earlier understanding was that both PHYs are needed only if .speed =
is "super-speed"
> >> and only usb2phy is needed for "high-speed". But as per Vivek's email =
it seems
> >> Samsung's exynos5 SoC doesn't need usb2phy for "super-speed".
> >>
> >> So to keeps things flexible, I can propose the following approach
> >> - if speed =3D=3D 'high-speed' usb2phy must be present. usb3phy will b=
e ignored if supplied.
> >> - if speed =3D=3D 'super-speed' usb3phy must be present and usb2phy is=
 optional but must be
> >> initialized if supplied.
> >> - if speed is not specified, we default to 'super-speed'.
> >>
> >> Felipe, does this address the issue you were facing with OMAP5?
> >=20
> > on OMAP5 we cannot skip USB3 PHY initialization. But then it becomes a
> > question of supporting a test feature (in OMAP5 case it would be cool to
> > force controller to lower speeds for testing) or coping with a broken
> > DTS.
> >=20
>=20
> I don't think we can protect ourselves from all possible broken
> configurations of DTS.
> I would vote for simplicity and maximum flexibility.
>=20
> So IMO we should just depend on DTS to provide the phys that are
> needed by the platform.
> In the driver we initialize whatever PHY is provided and don't
> complain if any or even all PHYs are missing.

considering that DTS is an ABI, I really think eventually we *will* have
broken DTBs burned into ROM and we will have to find ways to work with
those too. Same thing already happens today with ACPI tables.

> If this is not good enough then could you please suggest an
> alternative? Thanks.

The alternative would be to mandate nop xceiv for the "missing" PHY, but
that doesn't solve anything, really, as DTS authors might still forget
about the NOP xceiv and you can argue that forcing NOP xceiv would be a
SW configuration.

So, perhaps we go with the approach that all PHYs are optional, and
here's my original patch which makes USB3 PHY optional:

commit 979b84f96e4b7559b596b2933ae198aba267f260
Author: Felipe Balbi <balbi@ti.com>
Date:   Sun Jun 30 18:39:23 2013 +0300

    usb: dwc3: core: make USB3 PHY optional
   =20
    If we want a port to work at any speed lower
    than Superspeed, it makes no sense to even
    initialize/power up the USB3 transceiver,
    provided it won't be used.
   =20
    We can use the oportunity to save some power
    and leave the superspeed transceiver powered
    off.
   =20
    There is at least one such case which is
    Texas Instruments' AM437x which has one
    of its USB3 ports without a matching USB3
    PHY (that port is hardwired to work on USB2
    only).
   =20
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 74f9cf0..7a5ab93 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -387,16 +387,34 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (node) {
 		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
=20
-		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
-		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+		switch (dwc->maximum_speed) {
+		case USB_SPEED_SUPER:
+			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
+			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+			break;
+		case USB_SPEED_HIGH:
+		case USB_SPEED_FULL:
+		case USB_SPEED_LOW:
+			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
+			break;
+		}
=20
 		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode =3D of_usb_get_dr_mode(node);
 	} else if (pdata) {
 		dwc->maximum_speed =3D pdata->maximum_speed;
=20
-		dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
+		switch (dwc->maximum_speed) {
+		case USB_SPEED_SUPER:
+			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+			dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
+			break;
+		case USB_SPEED_HIGH:
+		case USB_SPEED_FULL:
+		case USB_SPEED_LOW:
+			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+			break;
+		}
=20
 		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
 		dwc->dr_mode =3D pdata->dr_mode;
@@ -424,19 +442,21 @@ static int dwc3_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
=20
-	if (IS_ERR(dwc->usb3_phy)) {
-		ret =3D PTR_ERR(dwc->usb3_phy);
+	if (dwc->maximum_speed =3D=3D USB_SPEED_SUPER) {
+		if (IS_ERR(dwc->usb3_phy)) {
+			ret =3D PTR_ERR(dwc->usb3_phy);
=20
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret =3D=3D -ENXIO)
-			return ret;
+			/*
+			 * if -ENXIO is returned, it means PHY layer wasn't
+			 * enabled, so it makes no sense to return -EPROBE_DEFER
+			 * in that case, since no PHY driver will ever probe.
+			 */
+			if (ret =3D=3D -ENXIO)
+				return ret;
=20
-		dev_err(dev, "no usb3 phy configured\n");
-		return -EPROBE_DEFER;
+			dev_err(dev, "no usb3 phy configured\n");
+			return -EPROBE_DEFER;
+		}
 	}
=20
 	dwc->xhci_resources[0].start =3D res->start;


what you guys are saying though, is that every PHY should be optional.

Do we have any device which doesn't provide USB2 PHY, only USB3 ? Dude,
that's so non-standard! USB *must* be backwards compatible so I'd expect
USB2 PHY to always be available.

--=20
balbi

--cyV/sMl4KAhiehtf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXUDmAAoJEIaOsuA1yqREJ0AQAKC3ONkDwVbbl3kjvgwifnSx
eHhmEt2PQyoMgUIskjaLFSJ41PxKFMt9pb7o5miQmk98MldFCAHhSatyvAXFnGr3
wNxQrUfCQUo1F9KagcBTOGe0RU+7oFDBlUu/LBu6lmVQg4My6481IQellJz52Aen
sUCC+h8N2u1zfqTHPJBSjySeFke6a7ZKS2QLKknmKcMJAOMbvinDYcpEHDJzsThm
zKJE+Z4sbll0PssDirJ0s1YeYOtT8LwIgLOAw4RTO60oJK/423GSkjvA0nWLGhpY
PJsu82pm8nTx8Rg2K/QeLVC/VTtfChnc+oSqSfVZ/T6SFIP5T9dIve2yD980wJT8
enVvYldF7nc8vwzStacYjQLt4wadpb28o1kfsfixoC0L0wVkr3d/V/Y5jZ/yqY/z
mh5PQOSBjcw7H35FKmIgjx3LrTX8ykzjOws0LadQ5gVCsaTGgpqYZX8pP6giORj0
dYkR/wyGgXM1ADAV/aa0mM5GNxhFSC1BsUEHio7EArRFV+KaXdkJppdMFl9AVGca
ia5vfcjv6nK1F0aMSZ+nVZnjOwRRM6LaUrlOAhOKVKT1wVEuD4QpwcrFa2UaNXYN
JoLGE5NP5NNQjTw1KSXpnhXJ2UJEHDR+HVW9yF8a4ZnbUWO+ZEYGTVJ35/w+dYuG
HozZBaMwPnSfPaNRRHLX
=znSu
-----END PGP SIGNATURE-----

--cyV/sMl4KAhiehtf--
