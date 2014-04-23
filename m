Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaDWPZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:25:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58809 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbaDWPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:25:38 -0400
Date: Wed, 23 Apr 2014 10:22:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: <balbi@ti.com>, Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/8] usb: host: xhci-plat: Add support for the Armada 38x
 glue code
Message-ID: <20140423152234.GG9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
 <1397816563-9000-3-git-send-email-gregory.clement@free-electrons.com>
 <20140420032035.GB26893@saruman.home>
 <53576F79.6070908@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline
In-Reply-To: <53576F79.6070908@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 23, 2014 at 09:44:57AM +0200, Gregory CLEMENT wrote:
> > On Fri, Apr 18, 2014 at 12:22:37PM +0200, Gregory CLEMENT wrote:
> >> For the armada 38x SoCs which come with an xhci controller, specific
> >> initialization must be done during probe, especially in relation with
> >> the MBus windows initialization. This patch adds this support.
> >>
> >> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >> ---
> >>  drivers/usb/host/Kconfig      |   7 +++
> >>  drivers/usb/host/Makefile     |   1 +
> >>  drivers/usb/host/xhci-mvebu.c | 105 +++++++++++++++++++++++++++++++++=
+++++++++
> >>  drivers/usb/host/xhci-mvebu.h |  21 +++++++++
> >>  drivers/usb/host/xhci-plat.c  |  10 ++++
> >>  5 files changed, 144 insertions(+)
> >>  create mode 100644 drivers/usb/host/xhci-mvebu.c
> >>  create mode 100644 drivers/usb/host/xhci-mvebu.h
> >>
> >> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> >> index 3d9e54062d62..e70943fac4a1 100644
> >> --- a/drivers/usb/host/Kconfig
> >> +++ b/drivers/usb/host/Kconfig
> >> @@ -29,6 +29,13 @@ if USB_XHCI_HCD
> >>  config USB_XHCI_PLATFORM
> >>  	tristate
> >> =20
> >> +config USB_XHCI_MVEBU
> >> +	tristate "xHCI support for Marvell Armada 38x"
> >> +	select USB_XHCI_PLATFORM
> >> +	---help---
> >> +	  Say 'Y' to enable the support for the xHCI host controller
> >> +	  found in Marvell Armada 38x ARM SOCs.
> >> +
> >>  endif # USB_XHCI_HCD
> >> =20
> >>  config USB_EHCI_HCD
> >> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> >> index 7530468c9a4f..7a8db7f7dc01 100644
> >> --- a/drivers/usb/host/Makefile
> >> +++ b/drivers/usb/host/Makefile
> >> @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+=3D xhci-pci.o
> >> =20
> >>  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> >>  	xhci-hcd-y		+=3D xhci-plat.o
> >> +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+=3D xhci-mvebu.o
> >>  endif
> >> =20
> >>  obj-$(CONFIG_USB_WHCI_HCD)	+=3D whci/
> >> diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mve=
bu.c
> >> new file mode 100644
> >> index 000000000000..dc9c7648ab65
> >> --- /dev/null
> >> +++ b/drivers/usb/host/xhci-mvebu.c
> >> @@ -0,0 +1,105 @@
> >> +/*
> >> + * Copyright (C) 2014 Marvell
> >> + * Author: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public License
> >> + * version 2 as published by the Free Software Foundation.
> >> + */
> >> +
> >> +#include <linux/clk.h>
> >> +#include <linux/io.h>
> >> +#include <linux/mbus.h>
> >> +#include <linux/of.h>
> >> +#include <linux/platform_device.h>
> >> +
> >> +#include "xhci.h"
> >> +
> >> +#define USB3_MAX_WINDOWS	4
> >> +#define USB3_WIN_CTRL(w)	(0x0 + ((w) * 8))
> >> +#define USB3_WIN_BASE(w)	(0x4 + ((w) * 8))
> >> +
> >> +static void __init mv_usb3_conf_mbus_windows(void __iomem *base,
> >> +			const struct mbus_dram_target_info *dram)
> >> +{
> >> +	int win;
> >> +
> >> +	/* Clear all existing windows */
> >> +	for (win =3D 0; win < USB3_MAX_WINDOWS; win++) {
> >> +		writel(0, base + USB3_WIN_CTRL(win));
> >> +		writel(0, base + USB3_WIN_BASE(win));
> >> +	}
> >> +
> >> +	/* Program each DRAM CS in a seperate window */
> >> +	for (win =3D 0; win < dram->num_cs; win++) {
> >> +		const struct mbus_dram_window *cs =3D dram->cs + win;
> >> +
> >> +		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
> >> +		       (dram->mbus_dram_target_id << 4) | 1,
> >> +		       base + USB3_WIN_CTRL(win));
> >> +
> >> +		writel((cs->base & 0xffff0000), base + USB3_WIN_BASE(win));
> >> +	}
> >> +}
> >> +
> >> +int xhci_mvebu_probe(struct platform_device *pdev)
> >> +{
> >> +	struct resource	*res;
> >> +	void __iomem	*base;
> >> +	const struct mbus_dram_target_info *dram;
> >> +	int ret;
> >> +	struct clk *clk;
> >> +
> >> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> >> +	if (!res)
> >> +		return -ENODEV;
> >> +
> >> +	/*
> >> +	 * We don't use devm_ioremap() because this mapping should
> >> +	 * only exists for the duration of this probe function.
> >> +	 */
> >> +	base =3D ioremap(res->start, resource_size(res));
> >> +	if (!base)
> >> +		return -ENODEV;
> >> +
> >> +	clk =3D devm_clk_get(&pdev->dev, NULL);
> >> +	if (IS_ERR(clk)) {
> >> +		iounmap(base);
> >> +		return PTR_ERR(clk);
> >> +	}
> >> +
> >> +	ret =3D clk_prepare_enable(clk);
> >> +	if (ret < 0) {
> >> +		iounmap(base);
> >> +		return ret;
> >> +	}
> >=20
> > it's best to teach generic xhci-plat about clocks, just make it
> > optional.
>=20
> OK
>=20
> >=20
> >> +	dram =3D mv_mbus_dram_info();
> >> +	mv_usb3_conf_mbus_windows(base, dram);
> >> +
> >> +	/*
> >> +	 * This memory area was only needed to configure the MBus
> >> +	 * windows, and is therefore no longer useful.
> >> +	 */
> >> +	iounmap(base);
> >=20
> > so I suppose MBus is the Marvell interconnect, am I right ? Wouldn't you
> > be duplicating this sort of initialization for most drivers ?
>=20
> Actually most of them don't need it.
>=20
> >=20
> >> +	ret =3D common_xhci_plat_probe(pdev, clk);
> >=20
> > I would much rather reverse this, instead of exposing xhci-plat's probe,
> > turn this mbus initialization into a quirk which will ioremap the extra
> > resource, initialize some registers and iounmap it.
>=20
> This approach have been inspired by what have been done for SDHCI and AHC=
I.
> The infrastructure allowing adding platform code is in the generic file b=
ut
> all the specific code is in the platform file.
>=20
> But if for USB you think we should do it in a different way, I will do it.

Yeah, I think it'll look slightly cleaner to have quirks called from
xhci-plat rather than having the quirk call into xhci-plat. Just look at
what *hci do on PCI-based platforms.

--=20
balbi

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV9q6AAoJEIaOsuA1yqRE/KkQAKVyRLWqytavBGK6T+AxJrfI
eWltYpofdYF53RJ+vmsFQIeSOzABnDRSjNrJ3e+IMnQs3C0/oalZd75jGdF4kbke
ajPJjZLitWiVfo2HgJBhdkWcsWjRR+WjlMpkfFuFD2q1owAkRe9IS7pEylUX4J+F
/3D6gK7dsmTwFSYZdYFm2jyJB5uZpxyp2dS6MoLX9xNmT2K8YNCHgJ12cocu+dwY
G4Mg1Xij1bLIGVgCTmoxqRgJW2Yuw7BxNsG8ZpyUC4Gf7XTrsfz/XJ16LIQVMwzO
vVdb9J4KNAAxrDRscebHptd1BbLonYE9thXOswS61Qck6EvGCaJMeAScZK5P/WXo
gioTfPfmwtRTtpcuf1yRC3ND5TORt4auZI3K2krTyD4OAIFVhKc/Rhm2caFe75ls
8fhy5m/ury79e80dgEjeepqHk5DBQrOfUSID3YRrFe+FXoyMfSxYxnXf82HlXTww
aFtYibzbJu3ymoUQyy/Qt842BmHOWkVOlaSyaHwcHxZ8mtDW5SQSIEPdoCgObgJp
5weSw0ZnWIRKGhaZkhtLLkzJeH9z/3Xk9A/NZqvLxqK5RzIRDgZJ6ZroRoxog63g
KUVZ5O6yIHLRXt9UmsMPWUSRyY/PDQKYQXPuZ/WyrFSZsspxDt0zfYu4QNJI4jg4
B4qHtXuU3Ab6w+2+lq1p
=kF5i
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--
