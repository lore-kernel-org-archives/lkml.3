Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3IRQ6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:58:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39776 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3IRQ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:58:05 -0400
Date: Wed, 18 Sep 2013 11:56:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Felipe Balbi <balbi@ti.com>, Kumar Gala <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Message-ID: <20130918165657.GO21559@radagast>
Reply-To: <balbi@ti.com>
References: <1376062832-23288-1-git-send-email-galak@codeaurora.org>
 <20130809162848.GW27325@e106331-lin.cambridge.arm.com>
 <1A03353A-9299-4D73-9786-4ECBC1DD4E05@codeaurora.org>
 <20130812180553.GD27954@radagast>
 <20130813133410.GO27165@e106331-lin.cambridge.arm.com>
 <20130827185329.GT3005@radagast>
 <20130828160151.GA17229@e106331-lin.cambridge.arm.com>
 <20130918142118.GJ21559@radagast>
 <20130918164610.GC17453@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Content-Disposition: inline
In-Reply-To: <20130918164610.GC17453@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 18, 2013 at 05:46:10PM +0100, Mark Rutland wrote:
> > > > I even wrote a patch making USB3 PHY optional, but didn't push it
> > > > exactly because it broke some other systems and I can't guarantee u=
sers
> > > > won't mess up their DTS/pdata.
> > >=20
> > > Does that mean that their dts or pdata are wrong at the moment, but
> > > they're spared because the driver bails out due to a missing phy? If
> > > their pdata's wrong, that should be fixable relatively easily, but if
> > > the dt is wrong then I'm not sure how we can support those systems
> > > sensibly. That sounds like an ideal candidate for a dt quirks
> > > mechanism...
> >=20
> > hmm, the idea of the patch was:
> >=20
> > 	switch (maximum-speed) {
> > 	case SUPER:
> > 		grab_and_initialize_usb3_phy();
> > 		grab_and_initialize_usb2_phy();
> > 		break;
> > 	case HIGH:
> > 	case FULL:
> > 	case LOW:
> > 		grab_and_initialize_usb2_phy();
> > 		break;
> > 	}
> >=20
> > now, imagine someone wants to run his dwc3 in highspeed mode, we
> > wouldn't initialize USB3 PHY which could cause the whole IP to break.
>=20
> When you say wants to run it in highspeed mode, you mean that they want
> this configured at run-time, or they deliberately omit a phy when
> describing the hardware in the DT?

it doesn't really matter, I guess. TI's DRA7xx platforms, for instance,
don't even provide a USB3 PHY and now way to connect one (since PIPE3
interface isn't brought out of the chip).

Granted the problem is bigger in superspeed capable integration where we
want to run at highspeed for e.g. test purposes.

> For the former I appreciate that it's a problem, but for the latter I'd
> argue that's their fault. As far as I can see we initialise both PHYs in

true, we can look at it that way.

> the probe path and never uninitialise them, so the only problem would be
> if someone's trying to be too clever. As we never check the return value
> of usb_phy_init, they can still attempt to work around our best
> efforts...
>=20
> I appreciate that we should not break existing DTs. More on that below.

k

> > I tried poking around on device's registers to see if there was any way
> > to detect that the IP needs somethin back from USB3 PHY, but couldn't
> > find anything.
> >=20
> > Since we can't know how the IP was integrated, it's best to leave it
> > alone and require NOP xceiv to be used.
>=20
> Agreed for the existing systems, but I still think we can work around
> this for new DTs...

perhaps, but wouldn't that be a quirk ? If it's a quirk, perhaps we'd be
better off adding a quirk flag to skip USB?PHY in some platforms. Then
we could:

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 474162e..5d39e0e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -387,16 +387,29 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (node) {
 		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
=20
-		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
-		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+		if (of_device_is_compatible(node, "ti,dra7xxx-dwc3"))
+			dwc->quirks |=3D DWC3_SKIP_USB3PHY;
+
+		if (!dwc->quirks & DWC3_SKIP_USB2_PHY)
+			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev,
+					"usb-phy", 0);
+
+		if (!dwc->quirks & DWC3_SKIP_USB3_PHY)
+			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev,
+					"usb-phy", 1);
=20
 		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode =3D of_usb_get_dr_mode(node);
+
 	} else if (pdata) {
 		dwc->maximum_speed =3D pdata->maximum_speed;
+		dwc->quirks =3D pdata->quirks;
=20
-		dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
+		if (!dwc->quirks & DWC3_SKIP_USB2_PHY)
+			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+
+		if (!dwc->quirks & DWC3_SKIP_USB3_PHY)
+			dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
=20
 		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
 		dwc->dr_mode =3D pdata->dr_mode;
@@ -732,6 +745,9 @@ static const struct dev_pm_ops dwc3_dev_pm_ops =3D {
 #ifdef CONFIG_OF
 static const struct of_device_id of_dwc3_match[] =3D {
 	{
+		.compatible =3D "ti,dra7xxx-dwc3",
+	},
+	{
 		.compatible =3D "snps,dwc3"
 	},
 	{

> > > > > You can describe the USB2-only case in the dt by only listing the=
 first
> > > > > phy (though the driver won't support it as it expects both to be
> > > > > present), but it's impossible to describe that you've wired up a =
single
> > > > > phy that's USB3 capable.
> > > >=20
> > > > you might be right there...
> > >=20
> > > Would it be possible to have something like (an optional) usb-phy-nam=
es?
> > > If not present, we assume the current situation, if present then we u=
se
> > > it to figure out which phys are present. Maybe I'm missing something
> > > that makes that impossible?
> >=20
> > you're missing the point regarding the IP possibly needing something
> > back from the PHY (e.g. a clock which PHY generates).
>=20
> I'm not sure why that detracts from the usb-phy-names idea -- if not
> present, we stick with the current behaviour and require both PHYs or
> fail early. No existing dts suddently explode, though none gain new
> functionality either.
>=20
> If someone's explicitly placed usb-phy-names, we know that they're
> up-to-date on the lastest binding, something like:
>=20
>  - usb-phy: A list of phandles to PHYs. If usb-phy-names is not
> 	    present, the USB2/HS PHY should be first, followed by the
> 	    USB3/SS PHY. If usb-phy-names is present, it defines the
> 	    order of PHYs.
>=20
>  - usb-phy-names: The names of PHYs described in the usb-phy property.
> 		  Valid values are "usb2" and "usb3". Should be used iff
> 		  a subset of PHYs are connected.
>=20
> 		  Compatibility note: The DWC3 IP can be integrated in
> 		  such a way as to require outputs from particular PHYs
> 		  for *any* level of operation. This cannot be detected
> 		  by the OS, and on such systems all required PHYs must
> 		  be described.
>=20
> Given that, if they list fewer PHYs than present and their system really
> requires a particular PHY, we can quite happily allow their system to
> explode in the knowledge it's their fault, not ours :)

LOL :-) Perhaps :-D

> If they try to use their new DT on an old platform then the kernel will
> refuse to use the DWC3, which would currently be the case anyway.

right.

--=20
balbi

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOdtZAAoJEIaOsuA1yqREA78P/3gD2ZH3pMndxKTXvti71s44
Vfnj/ADP5rJwJiqKIAvdteN/5K2fkCh4UQ8BLDhiQqJSx45fNOOTkIjHgrchiNUc
ICnA355KnopcCShx00C+VW9MotDPBqgrzblKbBK/w9G+relDQ0nnEOUaXcukhuK4
olgRq5gvlm8MSP/DIVMvJm9Zq1XTisBpPfzaNzFzv7NK8coVre/c5eyD5oMLPYi8
OhOIg4hExaT1OCetMZsEoXtmA4GZGFTNrFPkNwJDE/9UU1YuiEjcFvVAt+Tzne6M
XWU1bc2zlxBxWTddzSQnR5SbWtWoRi+c/VJnLLAkWHH+wAEZ2jOcBCnKKqR6+K0A
w1Fx698lMXDOYpsfnOVgA3mZhgAckThBCkFZs/zKZO7eKCxeC4FF/F0iRqVPXffM
8XkrJRRqJqTTv8smL+6OSqwoA/+9Lddc/faYr4H8Mcs7Xiw5z8ki5rPm6UE7Pp/h
HK15KlmzyVYfCQDaRfiQjN7nu+076VWcZS74GVG3xZPFQR+1bOdG7oTU4ptmIDAx
pRMflUzfB4dYpkZcndC8MRpuO2WhTloiA9ycyIXgkTvTGkrvyJkTepkXFYl2N7uE
eWsBUx9Mxqm5nPGBS1L7nt+x0WYrsHe1oj3w9Fs06qk9S83jXjXdfSujIQAj/BDu
qHXVhu/cslVlzqLVDWHa
=9f4b
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
