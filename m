Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3AQNux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:50:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3AQNuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:50:51 -0500
Date: Thu, 17 Jan 2013 15:50:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
Message-ID: <20130117135043.GU18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com>
 <20130117090255.GD10814@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6E1A6F0F97@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GVLQrlG8+/jMfW4X"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E1A6F0F97@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GVLQrlG8+/jMfW4X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 06:07:56PM +0530, Venu Byravarasu wrote:
> > > @@ -605,6 +615,53 @@ static const struct dev_pm_ops
> > tegra_ehci_pm_ops =3D {
> > >
> > >  #endif
> > >
> > > +/* Bits of PORTSC1, which will get cleared by writing 1 into them */
> > > +#define TEGRA_PORTSC_RWC_BITS (USB_PORTSC1_CSC |
> > USB_PORTSC1_PEC)
> > > +
> > > +void tegra_ehci_set_wakeon_events(struct usb_phy *x, bool enable)
> > > +{
> > > +	unsigned long val;
> > > +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> > > +	void __iomem *base =3D hcd->regs;
> > > +	u32 wake =3D USB_PORTSC1_WKOC | USB_PORTSC1_WKDS |
> > USB_PORTSC1_WKCN;
> > > +
> > > +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> > > +	if (enable)
> > > +		val |=3D wake;
> > > +	else
> > > +		val &=3D ~wake;
> > > +	writel(val, base + USB_PORTSC1);
> > > +}
> > > +EXPORT_SYMBOL_GPL(tegra_ehci_set_wakeon_events);
> > > +
> > > +void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
> > > +{
> > > +	unsigned long val;
> > > +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> > > +	void __iomem *base =3D hcd->regs;
> > > +
> > > +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> > > +	val &=3D ~USB_PORTSC1_PTS(3);
> > > +	val |=3D USB_PORTSC1_PTS(pts_val & 3);
> > > +	writel(val, base + USB_PORTSC1);
> > > +}
> > > +EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
> > > +
> > > +void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
> > > +{
> > > +	unsigned long val;
> > > +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> > > +	void __iomem *base =3D hcd->regs;
> > > +
> > > +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> > > +	if (enable)
> > > +		val |=3D USB_PORTSC1_PHCD;
> > > +	else
> > > +		val &=3D ~USB_PORTSC1_PHCD;
> > > +	writel(val, base + USB_PORTSC1);
> > > +}
> > > +EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
> >=20
> > NAK to these three functions, you need to use whatever the PHY API
> > provides you, if it misses something, let's see how we can add those as
> > generic calls.
> >=20
> > In fact, I wonder why do you want PHY driver to access Host address
> > space. Why don't you let your host driver handle the above ?
>=20
> Tegra20 SOC contains 3 instances of USB controllers.

fair enough.

> Some of these controllers can be configured to use different varieties
> of PHYs e.g. instance 3 can be configured to use either UTMI or ICUSB
> PHYs.

just like OMAP...

> Bits 31 & 30 from PORTSC register were allocated by our SOC designers
> to inform the host controller about the PHY type to be used.=20

Wow, that's something you should never do. PORTSC register belongs to
the EHCI controller and those bits are reserved for future use and they
*MUST* return zero. I wouldn't be surprised if current EHCI driver
assumes those bits will be zero and/or makes sure they're set to zero
when writing to PORTSC register.

What if after configuring those two bits, ehci-hcd.ko clears them by
accident ? Your platform won't work.

> As type of PHY is a property related to PHY DT nodes, PHY driver will get=
 this info.
> (Will remove phy_type from controller DT node soon, after all patches get=
 merged.)
> However as PORTSC register is in controller domain, added tegra_ehci_set_=
pts() API
>  to serve the purpose.
>=20
> As per Tegra USB PHY design, need to wait for PHY clock to stabilize once=
 we
> set/clear PHCD bit. Hence this is being accessed from PHY driver. To serv=
e this
> purpose added tegra_ehci_set_phcd().
>=20
> On further analysis, seems tegra_ehci_set_wakeon_events() can be
> removed.
>=20
> If you are okay with above explanation, I can send updated patch for
> review.

not sure I want to sign-off such a patch. I understand it's how your HW
was done, but this shouldn't have been done, really.

Alan, what do you think ? Are you ok with PHY driver overwritting PORTSC
register ?

--=20
balbi

--GVLQrlG8+/jMfW4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+AGyAAoJEIaOsuA1yqREAREP/RLTuMtTept+X+1fxO4h75X4
wYKJaYOfBctBOoI0+v2vgFzBM/GhF/aNMo7PA6PXwh+Wg9gYWNSGeMx25F/R+gDh
NLWmbg/oEQRtxOwrCPrqf2nUwoFjvI/Gf0WbEYwgIeeTxI2WByVQ1L+EEEqSqgeN
4OisIw0YbB1JP6/D87eQYNCi8uws4hoT9QPLuCT7CJzetXGTvrLq5/gaTGSfTnMS
+ASEULQbIu4/qC/4LAcrHe68pj7uZVxoH2BzsO7eTOtIvbDvL6KSWbpX0WtSMCQU
WlBRJTm+WMqFM0kN24PM3qkNqL7L9GYAwdEh1vFmU358fFV0hd7Xkwvzf9y/6U07
RyGBZGNKzgPI+uSwP1RlcNqsP0V0wYrM/+LJShInTCIbHRYjaBxSdwcIbsRAYw2h
sR9kVp3J7lVNpbIWo1G22ZzLO8Kb70VmAZFX3RV6v6wajAK9Iutmd06kU2laxHyx
/5okO0F8FCktxjdOhGeEUljtBpql6ksHvErYo/1My1J/2dxeJ3Y0TkSyVpxITLBI
K/sZxKgSvmEEcrGrycTiXHXNfQxSzkuCVWtxnD+T2cgphoAU4fGPY4bCzf6SsDpV
o+KP1gZJqKuf2Nu6Tr2YE20K1UYbzLIqPp8aCv7yT55vYzpIkad8OisQTBT6nCMJ
Da5Jz5UxvAvTUPOOp5hh
=Z9Eg
-----END PGP SIGNATURE-----

--GVLQrlG8+/jMfW4X--
