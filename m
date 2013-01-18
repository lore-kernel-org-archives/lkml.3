Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3ARL7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:59:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53202 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3ARL71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:59:27 -0500
Date: Fri, 18 Jan 2013 13:59:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] drivers: usb: phy: add a new driver for usb part of
 control module
Message-ID: <20130118115909.GA4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358502045-27008-1-git-send-email-kishon@ti.com>
 <1358502045-27008-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <1358502045-27008-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 18, 2013 at 03:10:42PM +0530, Kishon Vijay Abraham I wrote:
> Added a new driver for the usb part of control module. This has an API
> to power on the USB2 phy and an API to write to the mailbox depending on
> whether MUSB has to act in host mode or in device mode.
>=20
> Writing to control module registers for doing the above task which was
> previously done in omap glue and in omap-usb2 phy will be removed.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt |   26 ++-
>  Documentation/devicetree/bindings/usb/usb-phy.txt  |    5 +
>  drivers/usb/phy/Kconfig                            |    9 +
>  drivers/usb/phy/Makefile                           |    1 +
>  drivers/usb/phy/omap-control-usb.c                 |  204 ++++++++++++++=
++++++
>  include/linux/usb/omap_control_usb.h               |   72 +++++++
>  6 files changed, 316 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/usb/phy/omap-control-usb.c
>  create mode 100644 include/linux/usb/omap_control_usb.h
>=20
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documen=
tation/devicetree/bindings/usb/omap-usb.txt
> index 29a043e..ead6ba9 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -1,4 +1,4 @@
> -OMAP GLUE
> +OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
> =20
>  OMAP MUSB GLUE
>   - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
> @@ -16,6 +16,10 @@ OMAP MUSB GLUE
>   - power : Should be "50". This signifies the controller can supply upto
>     100mA when operating in host mode.
> =20
> +Optional properties:
> + - ctrl_module : phandle of the control module this glue uses to write to
> +   mailbox
> +
>  SOC specific device node entry
>  usb_otg_hs: usb_otg_hs@4a0ab000 {
>  	compatible =3D "ti,omap4-musb";
> @@ -23,6 +27,7 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
>  	multipoint =3D <1>;
>  	num_eps =3D <16>;
>  	ram_bits =3D <12>;
> +	ctrl_module =3D <&omap_control_usb>;
>  };
> =20
>  Board specific device node entry
> @@ -31,3 +36,22 @@ Board specific device node entry
>  	mode =3D <3>;
>  	power =3D <50>;
>  };
> +
> +OMAP CONTROL USB
> +
> +Required properties:
> + - compatible: Should be "ti,omap-control-usb"
> + - reg : Address and length of the register set for the device. It conta=
ins
> +   the address of "control_dev_conf" and "otghs_control".
> + - reg-names: The names of the register addresses corresponding to the r=
egisters
> +   filled in "reg".
> + - ti,has_mailbox: This is used to specify if the platform has mailbox in
> +   control module.
> +
> +omap_control_usb: omap-control-usb@4a002300 {
> +	compatible =3D "ti,omap-control-usb";
> +	reg =3D <0x4a002300 0x4>,
> +	      <0x4a00233c 0x4>;
> +	reg-names =3D "control_dev_conf", "otghs_control";
> +	ti,has_mailbox;
> +};
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Document=
ation/devicetree/bindings/usb/usb-phy.txt
> index 80d4148..2466b6f 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -8,10 +8,15 @@ Required properties:
>  add the address of control module dev conf register until a driver for
>  control module is added
> =20
> +Optional properties:
> + - ctrl_module : phandle of the control module used by PHY driver to pow=
er on
> +   the PHY.
> +
>  This is usually a subnode of ocp2scp to which it is connected.
> =20
>  usb2phy@4a0ad080 {
>  	compatible =3D "ti,omap-usb2";
>  	reg =3D <0x4a0ad080 0x58>,
>  	      <0x4a002300 0x4>;
> +	ctrl_module =3D <&omap_control_usb>;
>  };
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 5de6e7f..a7277ee 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -14,6 +14,15 @@ config OMAP_USB2
>  	  The USB OTG controller communicates with the comparator using this
>  	  driver.
> =20
> +config OMAP_CONTROL_USB
> +	tristate "OMAP CONTROL USB Driver"
> +	depends on ARCH_OMAP2PLUS
> +	help
> +	  Enable this to add support for the USB part present in the control
> +	  module. This driver has API to power on the PHY and to write to the
> +	  mailbox. The mailbox is present only in omap4 and the register to
> +	  power on the PHY is present in omap4 and omap5.
> +
>  config USB_ISP1301
>  	tristate "NXP ISP1301 USB transceiver support"
>  	depends on USB || USB_GADGET
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 1a579a8..0dea4d2 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -5,6 +5,7 @@
>  ccflags-$(CONFIG_USB_DEBUG) :=3D -DDEBUG
> =20
>  obj-$(CONFIG_OMAP_USB2)			+=3D omap-usb2.o
> +obj-$(CONFIG_OMAP_CONTROL_USB)		+=3D omap-control-usb.o
>  obj-$(CONFIG_USB_ISP1301)		+=3D isp1301.o
>  obj-$(CONFIG_MV_U3D_PHY)		+=3D mv_u3d_phy.o
>  obj-$(CONFIG_USB_EHCI_TEGRA)	+=3D tegra_usb_phy.o
> diff --git a/drivers/usb/phy/omap-control-usb.c b/drivers/usb/phy/omap-co=
ntrol-usb.c
> new file mode 100644
> index 0000000..7edeb41
> --- /dev/null
> +++ b/drivers/usb/phy/omap-control-usb.c
> @@ -0,0 +1,204 @@
> +/*
> + * omap-control-usb.c - The USB part of control module.
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/usb/omap_control_usb.h>
> +
> +static struct omap_control_usb *control_usb;
> +
> +/**
> + * get_omap_control_dev - returns the device pointer for this control de=
vice
> + *
> + * This API should be called to get the device pointer for this control
> + * module device. This device pointer should be passed to all other API's
> + * in this driver.
> + *
> + * To be used by PHY driver and glue driver
> + */
> +struct device *get_omap_control_dev(void)

let's do a small rename here and call it:

omap_get_control_dev(), just to keep consistency with rest of the file.

> +{
> +	if (!control_usb)
> +		return ERR_PTR(-ENODEV);
> +
> +	return control_usb->dev;
> +}
> +EXPORT_SYMBOL_GPL(get_omap_control_dev);
> +
> +/**
> + * omap_control_usb_phy_power - power on/off the phy using control modul=
e reg
> + * @dev: the control module device
> + * @on: 0 or 1, based on powering on or off the PHY
> + */
> +void omap_control_usb_phy_power(struct device *dev, int on)
> +{
> +	u32 val;
> +	struct omap_control_usb	*control_usb =3D dev_get_drvdata(dev);
> +
> +	if (on) {
> +		val =3D readl(control_usb->dev_conf);
> +		if (val & PHY_PD)
> +			writel(~PHY_PD, control_usb->dev_conf);
> +	} else {
> +		writel(PHY_PD, control_usb->dev_conf);
> +	}

this can be better. I would rather have this:

struct omap_control_usb *ctrl =3D dev_get_drvdata(dev);
u32 val;

val =3D readl(ctrl->dev_conf);

if (on)
	val &=3D ~OMAP_CTRL_DEV_PHY_PD;
else
	val |=3D OMAP_CTRL_DEV_PHY_PD;

writel(val, ctrl->dev_conf);



> +}
> +EXPORT_SYMBOL_GPL(omap_control_usb_phy_power);
> +
> +/**
> + * omap_control_usb_host_mode - set AVALID, VBUSVALID and ID pin in grou=
nded
> + * @dev: struct device *
> + *
> + * This is an API to write to the mailbox register to notify the usb cor=
e that
> + * a usb device has been connected.
> + */
> +void omap_control_usb_host_mode(struct device *dev)
> +{
> +	u32 val;
> +	struct omap_control_usb	*control_usb =3D dev_get_drvdata(dev);
> +
> +	val =3D AVALID | VBUSVALID;
> +
> +	writel(val, control_usb->otghs_control);

I would like to make this future proof too:

val =3D readl(ctrl->otghs_control);
val |=3D OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID;
writel(val, ctrl->otghs_control);

> +void omap_control_usb_device_mode(struct device *dev)
> +{
> +	u32 val;
> +	struct omap_control_usb	*control_usb =3D dev_get_drvdata(dev);
> +
> +	val =3D IDDIG | AVALID | VBUSVALID;

ditto. Read it before changing it. (the idea is that in future the other
bits might be used for something else, so you risk breaking future
functionality).

> +
> +	writel(val, control_usb->otghs_control);
> +}
> +EXPORT_SYMBOL_GPL(omap_control_usb_device_mode);
> +
> +/**
> + * omap_control_usb_set_sessionend - Enable SESSIONEND and IDIG to high
> + * impedance
> + * @dev: struct device *
> + *
> + * This is an API to write to the mailbox register to notify the usb core
> + * it's now in disconnected state.
> + */
> +void omap_control_usb_set_sessionend(struct device *dev)
> +{
> +	u32 val;
> +	struct omap_control_usb	*control_usb =3D dev_get_drvdata(dev);
> +
> +	val =3D SESSEND | IDDIG;

ditto

> +
> +	writel(val, control_usb->otghs_control);
> +}
> +EXPORT_SYMBOL_GPL(omap_control_usb_set_sessionend);
> +
> +static int omap_control_usb_probe(struct platform_device *pdev)
> +{
> +	struct resource	*res;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct omap_control_usb_platform_data *pdata =3D pdev->dev.platform_dat=
a;
> +
> +	control_usb =3D devm_kzalloc(&pdev->dev, sizeof(*control_usb),
> +	    GFP_KERNEL);

you're using space indentation here.

> +	if (!control_usb) {
> +		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (np) {
> +		control_usb->has_mailbox =3D of_property_read_bool(np,
> +		    "ti,has_mailbox");
> +	} else if (pdata) {
> +		control_usb->has_mailbox =3D pdata->has_mailbox;
> +	} else {
> +		dev_err(&pdev->dev, "no pdata present\n");
> +		return -EINVAL;

does it make sense to default to has_mailbox as true ? I mean, seems
like this is how it's going to be in future devices looking at the
current trend.

Another idea is to try to get the extra resource below, if it fails you
try to continue without it ;-)

> +	}
> +
> +	control_usb->dev	=3D &pdev->dev;
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +	    "control_dev_conf");

using space indentation here again.

> +	control_usb->dev_conf =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (control_usb->dev_conf =3D=3D NULL) {
> +		dev_err(&pdev->dev, "Failed to obtain io memory\n");
> +		return -EADDRNOTAVAIL;
> +	}
> +
> +	if (control_usb->has_mailbox) {
> +		res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +		    "otghs_control");
> +		control_usb->otghs_control =3D devm_request_and_ioremap(
> +		    &pdev->dev, res);
> +		if (control_usb->otghs_control =3D=3D NULL) {
> +			dev_err(&pdev->dev, "Failed to obtain io memory\n");
> +			return -EADDRNOTAVAIL;
> +		}
> +	}
> +
> +	dev_set_drvdata(control_usb->dev, control_usb);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id omap_control_usb_id_table[] =3D {
> +	{ .compatible =3D "ti,omap-control-usb" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
> +#endif
> +
> +static struct platform_driver omap_control_usb_driver =3D {
> +	.probe		=3D omap_control_usb_probe,
> +	.driver		=3D {
> +		.name	=3D "omap-control-usb",
> +		.owner	=3D THIS_MODULE,

no need to set owner here. When you register the platform_driver, it
will be set for you.

> +		.of_match_table =3D of_match_ptr(omap_control_usb_id_table),
> +	},
> +};
> +
> +static int __init omap_control_usb_init(void)
> +{
> +	return platform_driver_register(&omap_control_usb_driver);
> +}
> +subsys_initcall(omap_control_usb_init);
> +
> +static void __exit omap_control_usb_exit(void)
> +{
> +	platform_driver_unregister(&omap_control_usb_driver);
> +}
> +module_exit(omap_control_usb_exit);
> +
> +MODULE_ALIAS("platform: omap_control_usb");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_DESCRIPTION("OMAP CONTROL USB DRIVER");

don't scream to your users like that ;-)

MODULE_DESCRIPTION("OMAP Control Module USB Driver");

> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/oma=
p_control_usb.h
> new file mode 100644
> index 0000000..a16f993
> --- /dev/null
> +++ b/include/linux/usb/omap_control_usb.h
> @@ -0,0 +1,72 @@
> +/*
> + * omap_control_usb.h - Header file for the USB part of control module.
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __OMAP_CONTROL_USB_H__
> +#define __OMAP_CONTROL_USB_H__
> +
> +struct omap_control_usb {
> +	struct device *dev;
> +
> +	u32 __iomem *dev_conf;
> +	u32 __iomem *otghs_control;
> +
> +	u8 has_mailbox:1;
> +};
> +
> +struct omap_control_usb_platform_data {
> +	u8 has_mailbox:1;
> +};
> +
> +#define	PHY_PD		BIT(0)
> +
> +#define	AVALID		BIT(0)
> +#define	BVALID		BIT(1)
> +#define	VBUSVALID	BIT(2)
> +#define	SESSEND		BIT(3)
> +#define	IDDIG		BIT(4)

please prepend with OMAP_CTRL_ or something similar.

--=20
balbi

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+TkNAAoJEIaOsuA1yqREtc8P/jzY9zh+y87DBzWintPPOftC
f1wR0u1Bbkbp2WcUCDc1tTUQH+6y/3bHAcW6pDB77sUs9MeNP3+zPe1zxasUzOcg
P3bRMMAksLktyx1r6uzkCWppS+QwedzPylfzZ8lYBCwB7RDPOVeHBSeRQkjpoxUF
++2HzumkDICx/WJUbn/KcIFXL8YdgQz/krSN1+oe+NSCiSK2Tf67qxYUJqx32SjV
0k6fWp/LEcnKq2ma5TUBCZOeaFgCQShNY8MOQ3D8ikSjuKw2lp5Cw0CL9vF+wPds
5G/WPUIp8GpvE1kToK1jlXo88B1zWMBHPQjunPNJwn+ooE3qKiHGO2DUDmlRqhQa
R5Eq4RI5h086E+Pu9/u0P4JJD+VYpHrWh3Yb/L4di3p4KMqlYcMbMnIw4auVC8UJ
c0MaPaCcvNTAv48uJEk6Hz2OpNtG5+3wKslAr1iS8KYoI8+bnBOWrvdk3WCsRFOZ
yZWDI0fMNeGPcaQcuIjD5GSEEoAhb6iEwk+pwW/BbSpsBFzBmX5B0Q+xOkniYIoP
g52bEBNHaIzf9vgeSYNcpoI7EFJYz0TFxdyLltYIDcU0WEbSlN/KGNMoHtFBZDCV
RnJMLEW6fq0h2RP0E57a6Dqb7beb4mV9jkIJKAKWd6ACjxQVPBJs7ZOUiBczc56i
bGEAWWBdJXHlKUILW9PG
=4piC
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
