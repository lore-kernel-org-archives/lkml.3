Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbbATPY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:24:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39013 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbATPY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:24:27 -0500
Date: Tue, 20 Jan 2015 09:23:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add ULPI interface support
Message-ID: <20150120152337.GA8988@saruman>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-3-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1421745502-169447-3-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 20, 2015 at 11:18:21AM +0200, Heikki Krogerus wrote:
> Registers ULPI interface with the ULPI bus if HSPHY type is
> ULPI.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>

you're doing quite a bit in a single patch...

> ---
>  drivers/usb/dwc3/Kconfig  |   7 ++++
>  drivers/usb/dwc3/Makefile |   4 ++
>  drivers/usb/dwc3/core.c   |   9 +++-
>  drivers/usb/dwc3/core.h   |  22 ++++++++++
>  drivers/usb/dwc3/ulpi.c   | 102 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 143 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/usb/dwc3/ulpi.c
>=20
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 58b5b2c..6d0c5e6 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -11,6 +11,13 @@ config USB_DWC3
> =20
>  if USB_DWC3
> =20
> +config USB_DWC3_ULPI
> +	bool "Provide ULPI PHY Interface"
> +	depends on ULPI_PHY=3Dy ||=A0ULPI_PHY=3DUSB_DWC3
> +	help
> +	  Select this if you have ULPI type PHY attached to your DWC3
> +	  controller.
> +
>  choice
>  	bool "DWC3 Mode Selection"
>  	default USB_DWC3_DUAL_ROLE if (USB && USB_GADGET)
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index bb34fbc..2fc44e0 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -16,6 +16,10 @@ ifneq ($(filter y,$(CONFIG_USB_DWC3_GADGET) $(CONFIG_U=
SB_DWC3_DUAL_ROLE)),)
>  	dwc3-y				+=3D gadget.o ep0.o
>  endif
> =20
> +ifneq ($(CONFIG_USB_DWC3_ULPI),)
> +	dwc3-y				+=3D ulpi.o
> +endif
> +
>  ifneq ($(CONFIG_DEBUG_FS),)
>  	dwc3-y				+=3D debugfs.o
>  endif
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 25ddc39..5219bc7 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -876,12 +876,17 @@ static int dwc3_probe(struct platform_device *pdev)
>  	dwc->hird_threshold =3D hird_threshold
>  		| (dwc->is_utmi_l1_suspend << 4);
> =20
> +	platform_set_drvdata(pdev, dwc);
> +
> +	ret =3D dwc3_ulpi_init(dwc);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D dwc3_core_get_phy(dwc);
>  	if (ret)
>  		return ret;
> =20
>  	spin_lock_init(&dwc->lock);
> -	platform_set_drvdata(pdev, dwc);

why do you need to move this ? Looks like this should be a cleanup and
split into a single patch.

it also appears that you need another patch moving dwc3_cache_hwparams()
before all of these other calls, so you can use it from
dwc3_ulpi_init().

> @@ -965,6 +970,7 @@ err1:
> =20
>  err0:
>  	dwc3_free_event_buffers(dwc);
> +	dwc3_ulpi_exit(dwc);
> =20
>  	return ret;
>  }
> @@ -984,6 +990,7 @@ static int dwc3_remove(struct platform_device *pdev)
>  	phy_power_off(dwc->usb3_generic_phy);
> =20
>  	dwc3_core_exit(dwc);
> +	dwc3_ulpi_exit(dwc);
> =20
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 0842aa8..f6881a6 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -32,6 +32,7 @@
>  #include <linux/usb/otg.h>
> =20
>  #include <linux/phy/phy.h>
> +#include <linux/phy/ulpi/interface.h>
> =20
>  #define DWC3_MSG_MAX	500
> =20
> @@ -174,6 +175,14 @@
>  #define DWC3_GUSB2PHYCFG_PHYSOFTRST	(1 << 31)
>  #define DWC3_GUSB2PHYCFG_SUSPHY		(1 << 6)
> =20
> +/* Global USB2 PHY Vendor Control Register */
> +#define DWC3_GUSB2PHYACC_NEWREGREQ	(1 << 25)
> +#define DWC3_GUSB2PHYACC_BUSY		(1 << 23)
> +#define DWC3_GUSB2PHYACC_WRITE		(1 << 22)
> +#define DWC3_GUSB2PHYACC_ADDR(n)	(n << 16)
> +#define DWC3_GUSB2PHYACC_EXTEND_ADDR(n)	(n << 8)
> +#define DWC3_GUSB2PHYACC_DATA(n)	(n & 0xff)

separate patch

> @@ -590,6 +599,7 @@ struct dwc3_hwparams {
>  #define DWC3_NUM_INT(n)		(((n) & (0x3f << 15)) >> 15)
> =20
>  /* HWPARAMS3 */
> +#define DWC3_ULPI_HSPHY		(1 << 3)

you also need a patch which defines this bit of HWPARAMS3. This is also
the wrong definition. Which core revision do you have ? I can see that
bit 3 is part of a 2 bit field called:

DWC_USB3_HSPHY_INTERFACE

moreover, there are systems which have both ULPI and UTMI enabled and
you can't really know which one the PHY is using.

This needs a bit more thought.

>  #define DWC3_NUM_IN_EPS_MASK	(0x1f << 18)
>  #define DWC3_NUM_EPS_MASK	(0x3f << 12)
>  #define DWC3_NUM_EPS(p)		(((p)->hwparams3 &		\
> @@ -739,6 +749,8 @@ struct dwc3 {
>  	struct phy		*usb2_generic_phy;
>  	struct phy		*usb3_generic_phy;
> =20
> +	struct ulpi		*ulpi;
> +
>  	void __iomem		*regs;
>  	size_t			regs_size;
> =20
> @@ -1035,4 +1047,14 @@ static inline int dwc3_gadget_resume(struct dwc3 *=
dwc)
>  }
>  #endif /* !IS_ENABLED(CONFIG_USB_DWC3_HOST) */
> =20
> +#if IS_ENABLED(CONFIG_USB_DWC3_ULPI)
> +int dwc3_ulpi_init(struct dwc3 *dwc);
> +void dwc3_ulpi_exit(struct dwc3 *dwc);
> +#else
> +static inline int dwc3_ulpi_init(struct dwc3 *dwc)
> +{ return 0; }
> +static inline void dwc3_ulpi_exit(struct dwc3 *dwc)
> +{ }
> +#endif
> +
>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
> diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
> new file mode 100644
> index 0000000..ee3ebbe
> --- /dev/null
> +++ b/drivers/usb/dwc3/ulpi.c
> @@ -0,0 +1,102 @@
> +/**
> + * ulpi.c - DesignWare USB3 Controller's ULPI PHY interface
> + *
> + * Copyright (C) 2015 Intel Corporation
> + *
> + * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/phy/ulpi/regs.h>
> +
> +#include "core.h"
> +#include "io.h"
> +
> +#define DWC3_ULPI_ADDR(a) \
> +		((a >=3D ULPI_EXT_VENDOR_SPECIFIC) ? \
> +		DWC3_GUSB2PHYACC_ADDR(ULPI_ACCESS_EXTENDED) | \
> +		DWC3_GUSB2PHYACC_EXTEND_ADDR(a) : DWC3_GUSB2PHYACC_ADDR(a))
> +
> +static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
> +{
> +	unsigned count =3D 1000;
> +	u32 reg;
> +
> +	while (count--) {
> +		reg =3D dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
> +		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
> +			return 0;

this could use a cpu_relax();

> +	}
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int dwc3_ulpi_read(struct ulpi_ops *ops, u8 addr)
> +{
> +	struct dwc3 *dwc =3D dev_get_drvdata(ops->dev);
> +	u32 reg;
> +	int ret;
> +
> +	reg =3D DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
> +	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
> +
> +	ret =3D dwc3_ulpi_busyloop(dwc);
> +	if (ret)
> +		return ret;
> +
> +	reg =3D dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
> +
> +	return DWC3_GUSB2PHYACC_DATA(reg);
> +}
> +
> +static int dwc3_ulpi_write(struct ulpi_ops *ops, u8 addr, u8 val)
> +{
> +	struct dwc3 *dwc =3D dev_get_drvdata(ops->dev);
> +	u32 reg;
> +	int ret;
> +
> +	reg =3D DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
> +	reg |=3D DWC3_GUSB2PHYACC_WRITE | val;
> +	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
> +
> +	ret =3D dwc3_ulpi_busyloop(dwc);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static struct ulpi_ops dwc3_ulpi =3D {
> +	.read =3D dwc3_ulpi_read,
> +	.write =3D dwc3_ulpi_write,
> +};
> +
> +int dwc3_ulpi_init(struct dwc3 *dwc)
> +{
> +	int ret;
> +
> +	/* First check if there is ULPI PHY */
> +	ret =3D dwc3_readl(dwc->regs, DWC3_GHWPARAMS3);
> +	if (!(ret & DWC3_ULPI_HSPHY))
> +		return 0;

should use the cached structure.

> +	/* Register the interface */
> +	dwc->ulpi =3D ulpi_register_interface(dwc->dev, &dwc3_ulpi);
> +	if (IS_ERR(dwc->ulpi)) {
> +		dev_err(dwc->dev, "failed to register ULPI interface");
> +		return PTR_ERR(dwc->ulpi);
> +	}
> +
> +	return 0;
> +}
> +
> +void dwc3_ulpi_exit(struct dwc3 *dwc)
> +{
> +	if (dwc->ulpi) {
> +		ulpi_unregister_interface(dwc->ulpi);
> +		dwc->ulpi =3D NULL;
> +	}
> +}
> --=20
> 2.1.4
>=20

--=20
balbi

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvnL4AAoJEIaOsuA1yqREIOUQALMHwGnRWV54cxVbA8WH6QG8
0y3YV7Hvx+Fp5s4lMHA6HQEYwV0RujEvaFd3uBWmImujgmuOMOL/rc8lYPdxx0AO
UWXgbE4ftNyH0uawkSzRAl/buPyBTuOMBAhf6ZlhtTJ3CNsDLOmm4g+RESyY7mhc
NTLD5BqLCwTaDIUtRxk83Y/SMtIGK6dr4jw+y9QUk3kfY0PgvNd8EwK3eStwxezP
wnlcYqn7rfzBzOlNR6AqKFJADeOe1kcWbE7DSqOfJnnWdc4TxqfGuwx1KMy44DlH
PcDPUF2JVyLkrdytADorxRq4elPpjbTGjYcprAhlsO86VPr3QuxNoB2z4LVNSnVx
dRR3GdZetb6K4wmYFV3clmKIHwTmSu2UJ3qJeKqX7lTiT/PWl0+FtOBjElPYRX7Z
SQtQAqqpawq+C/k7RJaOGUQe9LToiZC8kejyxZl8r2D6KkHVuseFUof1vPBsXkzI
6xod1bu5W+e80EFvIz+USKTsg3UEuT4miyOHRrMt659uw9PxFznkHQ5SaQMaDmoZ
FTZwlLXcT785JNip+wAdrCtWh4c5b8red/hTIf5uNaIIs52mipGc1veddwzLF+jN
fDicllmow9XSpdKewZCkH1/pOCQiVSJHn7se4MK0Zh6+3ObeYoc5I5GnWuN4Wh+F
UxBGAXnh7N9eZee3li0u
=mw9Q
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
