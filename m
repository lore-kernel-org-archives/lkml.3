Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaDYPF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:05:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaDYPFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:05:22 -0400
Date: Fri, 25 Apr 2014 10:04:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 03/18] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140425150443.GD29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 04:07:01PM +0200, Gregory CLEMENT wrote:
> For the Armada 38x SoCs which come with an xhci controller, specific
> initialization must be done during probe related to the MBus windows
> configuration. This patch adds the support of this quirk.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/Kconfig      |  7 +++++
>  drivers/usb/host/Makefile     |  1 +
>  drivers/usb/host/xhci-mvebu.c | 71 +++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/usb/host/xhci-mvebu.h | 22 ++++++++++++++
>  drivers/usb/host/xhci-plat.c  |  5 +++
>  5 files changed, 106 insertions(+)
>  create mode 100644 drivers/usb/host/xhci-mvebu.c
>  create mode 100644 drivers/usb/host/xhci-mvebu.h
>=20
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e54062d62..e70943fac4a1 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -29,6 +29,13 @@ if USB_XHCI_HCD
>  config USB_XHCI_PLATFORM
>  	tristate
> =20
> +config USB_XHCI_MVEBU
> +	tristate "xHCI support for Marvell Armada 38x"
> +	select USB_XHCI_PLATFORM
> +	---help---
> +	  Say 'Y' to enable the support for the xHCI host controller
> +	  found in Marvell Armada 38x ARM SOCs.
> +
>  endif # USB_XHCI_HCD
> =20
>  config USB_EHCI_HCD
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index 7530468c9a4f..7a8db7f7dc01 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+=3D xhci-pci.o
> =20
>  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
>  	xhci-hcd-y		+=3D xhci-plat.o
> +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+=3D xhci-mvebu.o
>  endif
> =20
>  obj-$(CONFIG_USB_WHCI_HCD)	+=3D whci/
> diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
> new file mode 100644
> index 000000000000..09cf437499fb
> --- /dev/null
> +++ b/drivers/usb/host/xhci-mvebu.c
> @@ -0,0 +1,71 @@
> +/*
> + * Copyright (C) 2014 Marvell
> + * Author: Gregory CLEMENT <gregory.clement@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/mbus.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#define USB3_MAX_WINDOWS	4
> +#define USB3_WIN_CTRL(w)	(0x0 + ((w) * 8))
> +#define USB3_WIN_BASE(w)	(0x4 + ((w) * 8))
> +
> +static void __init mv_usb3_conf_mbus_windows(void __iomem *base,
> +			const struct mbus_dram_target_info *dram)
> +{
> +	int win;
> +
> +	/* Clear all existing windows */
> +	for (win =3D 0; win < USB3_MAX_WINDOWS; win++) {
> +		writel(0, base + USB3_WIN_CTRL(win));
> +		writel(0, base + USB3_WIN_BASE(win));
> +	}
> +
> +	/* Program each DRAM CS in a seperate window */
> +	for (win =3D 0; win < dram->num_cs; win++) {
> +		const struct mbus_dram_window *cs =3D dram->cs + win;
> +
> +		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
> +		       (dram->mbus_dram_target_id << 4) | 1,
> +		       base + USB3_WIN_CTRL(win));
> +
> +		writel((cs->base & 0xffff0000), base + USB3_WIN_BASE(win));
> +	}
> +}
> +
> +int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev)
> +{
> +	struct resource	*res;
> +	void __iomem	*base;
> +	const struct mbus_dram_target_info *dram;
> +	int ret =3D 0;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res)
> +		return -ENODEV;
> +
> +	/*
> +	 * We don't use devm_ioremap() because this mapping should
> +	 * only exists for the duration of this probe function.
> +	 */
> +	base =3D ioremap(res->start, resource_size(res));
> +	if (!base)
> +		return -ENODEV;
> +
> +	dram =3D mv_mbus_dram_info();
> +	mv_usb3_conf_mbus_windows(base, dram);
> +
> +	/*
> +	 * This memory area was only needed to configure the MBus
> +	 * windows, and is therefore no longer useful.
> +	 */
> +	iounmap(base);
> +
> +	return ret;
> +}
> diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
> new file mode 100644
> index 000000000000..5d7e647b3d27
> --- /dev/null
> +++ b/drivers/usb/host/xhci-mvebu.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (C) 2014 Marvell
> + *
> + * Gregory Clement <gregory.clement@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __LINUX_XHCI_MVEBU_H
> +#define __LINUX_XHCI_MVEBU_H
> +
> +#ifdef CONFIG_USB_XHCI_MVEBU

this is a tristate symbol, you're not treating the case where this is a
module. Have you really build-tested this patch ? It would give you
redefinition errors. Switch over to:

#if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)

> +int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev);
> +#else
> +static inline int xhci_mvebu_mbus_init_quirk(struct device dev)
> +{
> +	return 0;
> +}
> +#endif
> +#endif /* __LINUX_XHCI_MVEBU_H */
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index bb5d563f729c..c0e835b49e0d 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -19,6 +19,7 @@
>  #include <linux/slab.h>
> =20
>  #include "xhci.h"
> +#include "xhci-mvebu.h"
> =20
>  static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  {
> @@ -148,6 +149,9 @@ static int xhci_plat_probe(struct platform_device *pd=
ev)
>  	if (ret)
>  		return ret;
> =20
> +	if (of_device_is_compatible(pdev->dev.of_node, "marvell,armada-380-xhci=
"))

break the line at that , character

> +		xhci_mvebu_mbus_init_quirk(pdev);
> +
>  	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
>  	ret =3D dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
>  	if (ret)
> @@ -279,6 +283,7 @@ static const struct dev_pm_ops xhci_plat_pm_ops =3D {
>  static const struct of_device_id usb_xhci_of_match[] =3D {
>  	{ .compatible =3D "generic-xhci" },
>  	{ .compatible =3D "xhci-platform" },
> +	{ .compatible =3D "marvell,armada-380-xhci"},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, usb_xhci_of_match);
> --=20
> 1.8.1.2
>=20

--=20
balbi

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnmLAAoJEIaOsuA1yqREmHUP/1PI8l4zVtx6/9upVyGG7Gtx
PecKKJBtZdlxKWDSbcAEhU3yKQZmho6WTc/yBnQsliMxTbAuGr0ieTx0m8AKQ1Kr
Sk1nh4Xf3Yciecg0vg8JrzUGM6YukgNGXkJMpU8Gres29iKFZHDR2VIDeq5Ybi7G
lBbv1fHjYLUbYIjyxVAv5c8yjvEyBRyAyxeSiua69UrI4YYL3zd1MkocCuBbDef9
etDxS7j9AcaLba5POVUpMDAebsop+f/Te1dPAIh9nS6P1gDoxTTNU7Q8hs25cXfb
8aDGdPngoYeJlV4ccmvRULgVZhvIBL7V6WmLfo6nGoxKECSavI/fCWwrVin6c2/3
TXQmnQgg87ieGG8iRIS85IC4weamPQYK+r9E3i4Sc99hJpIExx60otb+uwUAI6MX
U5FsaNRYobIcH/yGqfDcUvw3PklKQE+o5dB2R+qZR/DQLLMAF379O+68Zt1wW7TY
rMmvAa5AnfjwHx6i9XPsdDCTQeXMTQHBLZG42FVlVtUkCiYXxQSj+lsktfdorSag
Usyfcplgq7mAIxmYCBOWVal4Rpe94cc6/h7DrEOEv75PCDoxOB03WRkMtHW2x/22
ofp3H9xdBffMFqP0VaDSObfhnjFd6yFauJ7WxpkaEpSpYV2PET3j6+qom/3JATBn
Dwak/PA1kg0G+CgDfocD
=wqfy
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
