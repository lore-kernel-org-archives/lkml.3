Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3AQJDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:03:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50391 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab3AQJDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:03:05 -0500
Date: Thu, 17 Jan 2013 11:02:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
Message-ID: <20130117090255.GD10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 01:58:12PM +0530, Venu Byravarasu wrote:
> As Tegra PHY driver need to access one of the Host registers,
> added few APIs to ehci tegra driver.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Stephen is this another of those patches you're gonna take care of
yourself ?

> ---
> delta from v1:
> Taken care of RWC bits, while accessing PORTSC register.
>=20
>  drivers/usb/host/ehci-tegra.c     |   70 +++++++++++++++++++++++++++++++=
+++++-
>  drivers/usb/phy/tegra_usb_phy.c   |   51 +++++++--------------------
>  include/linux/usb/tegra_usb_phy.h |    6 +++
>  3 files changed, 88 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 55a9cde..6bbf66a 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -2,7 +2,7 @@
>   * EHCI-compliant USB host controller driver for NVIDIA Tegra SoCs
>   *
>   * Copyright (C) 2010 Google, Inc.
> - * Copyright (C) 2009 NVIDIA Corporation
> + * Copyright (C) 2009 - 2013 NVIDIA Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify =
it
>   * under the terms of the GNU General Public License as published by the
> @@ -33,6 +33,16 @@
>  #define TEGRA_USB2_BASE			0xC5004000
>  #define TEGRA_USB3_BASE			0xC5008000
> =20
> +/* PORTSC registers */
> +#define USB_PORTSC1			0x184
> +#define USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> +#define USB_PORTSC1_PHCD	(1 << 23)
> +#define USB_PORTSC1_WKOC	(1 << 22)
> +#define USB_PORTSC1_WKDS	(1 << 21)
> +#define USB_PORTSC1_WKCN	(1 << 20)
> +#define USB_PORTSC1_PEC		(1 << 3)
> +#define USB_PORTSC1_CSC		(1 << 1)

please prepend this with TEGRA_ just as other defines.

> +
>  #define TEGRA_USB_DMA_ALIGN 32
> =20
>  struct tegra_ehci_hcd {
> @@ -605,6 +615,53 @@ static const struct dev_pm_ops tegra_ehci_pm_ops =3D=
 {
> =20
>  #endif
> =20
> +/* Bits of PORTSC1, which will get cleared by writing 1 into them */
> +#define TEGRA_PORTSC_RWC_BITS (USB_PORTSC1_CSC | USB_PORTSC1_PEC)
> +
> +void tegra_ehci_set_wakeon_events(struct usb_phy *x, bool enable)
> +{
> +	unsigned long val;
> +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> +	void __iomem *base =3D hcd->regs;
> +	u32 wake =3D USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
> +
> +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> +	if (enable)
> +		val |=3D wake;
> +	else
> +		val &=3D ~wake;
> +	writel(val, base + USB_PORTSC1);
> +}
> +EXPORT_SYMBOL_GPL(tegra_ehci_set_wakeon_events);
> +
> +void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
> +{
> +	unsigned long val;
> +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> +	void __iomem *base =3D hcd->regs;
> +
> +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> +	val &=3D ~USB_PORTSC1_PTS(3);
> +	val |=3D USB_PORTSC1_PTS(pts_val & 3);
> +	writel(val, base + USB_PORTSC1);
> +}
> +EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
> +
> +void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
> +{
> +	unsigned long val;
> +	struct usb_hcd *hcd =3D bus_to_hcd(x->otg->host);
> +	void __iomem *base =3D hcd->regs;
> +
> +	val =3D readl(base + USB_PORTSC1) & ~TEGRA_PORTSC_RWC_BITS;
> +	if (enable)
> +		val |=3D USB_PORTSC1_PHCD;
> +	else
> +		val &=3D ~USB_PORTSC1_PHCD;
> +	writel(val, base + USB_PORTSC1);
> +}
> +EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);

NAK to these three functions, you need to use whatever the PHY API
provides you, if it misses something, let's see how we can add those as
generic calls.

In fact, I wonder why do you want PHY driver to access Host address
space. Why don't you let your host driver handle the above ?

--=20
balbi

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ974/AAoJEIaOsuA1yqREmZQP/1of37MLI+GoXDcHtn1OO8/Q
O3l8V+a+BkoNZNMImTxxsVFV10hrEz6liXH7Ugh71Ax2g2yCxyFK8LSkdT52kK5s
sS86Ow+EIYEPZWYntQwDazft+SMsObQl5yeAQlMEuabphFCI2ELL5zjh+fiujwzS
B1mNv5XbWv86oTqq9p1sOaYXMQ0582ob9tkPCYFQkC/yni0JBZbU/xWORJVHvKrh
OlaTN8/38jYTMymMIIPVoq5Rqr07hHSLZVIymvfbdesqcxxLU/pUxY6r93GbCnuQ
f+5U4Qi1vJMSZv/xYRA6Uv7hPaE++b236qvv+6FvQihXQrOZIITIUB6ljF3QIwBj
7sa/q0fr6BephrNUYID7OQ3xZXaLSMe5A4fSw4b8JEBTPKVBdxDsCUFBljK5SR9s
GCyaRb1wCw/kAUKmz8qeNY1NtLKVFhNqgK143rUUf+AcVDpDcfRVkgMQpux4tJGU
P6RuwRJCYvtzqww26t9KAlxAsdRyM4+MBdE1WTWNaKhjLc+tRm1e1sf8UJr+YpTg
mlZj6ceEKrenbi8oLBeGxGBwxr8vIDFC9fNkvsalH+N1Z8I81kOACUxRVLcrPwZ2
ySPWLrSepNFzgl3heNuGmGoGSQDFFCc519W6JgUozl9CsFhKd/KAU6hpTyPkJbs9
ddoTiYxsAm6YtimBr19q
=lfyJ
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
