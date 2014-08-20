Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaHTSJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:09:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36001 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHTSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:09:22 -0400
Date: Wed, 20 Aug 2014 13:08:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <balbi@ti.com>, <lee.jones@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140820180850.GV24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BcZrms9gUsdgyR6a"
Content-Disposition: inline
In-Reply-To: <1406734091-16202-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 30, 2014 at 04:28:09PM +0100, Peter Griffin wrote:
> This patch adds the ST glue logic to manage the DWC3 HC
> on STiH407 SoC family. It manages the powerdown signal,
> and configures the internal glue logic and syscfg registers.
>=20
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/usb/dwc3/Kconfig   |   9 ++
>  drivers/usb/dwc3/Makefile  |   1 +
>  drivers/usb/dwc3/dwc3-st.c | 336 +++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 346 insertions(+)
>  create mode 100644 drivers/usb/dwc3/dwc3-st.c
>=20
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 8eb996e..6c85c43 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
>  	  Support of USB2/3 functionality in TI Keystone2 platforms.
>  	  Say 'Y' or 'M' here if you have one such device
> =20
> +config USB_DWC3_ST
> +	tristate "STMicroelectronics Platforms"
> +	depends on ARCH_STI && OF
> +	default USB_DWC3_HOST

this seems wrong as USB_DWC3_{HOST,GADGET,DUAL_ROLE} are booleans and
USB_DWC3_ST is a tristate. Better to stick with defaulting to USB_DWC3
instead like all the others.

> +	help
> +	  STMicroelectronics SoCs with one DesignWare Core USB3 IP
> +	  inside (i.e. STiH407).
> +	  Say 'Y' or 'M' if you have one such device.
> +
>  comment "Debugging features"
> =20
>  config USB_DWC3_DEBUG
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index 10ac3e7..11c9f54 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+=3D dwc3-omap.o
>  obj-$(CONFIG_USB_DWC3_EXYNOS)		+=3D dwc3-exynos.o
>  obj-$(CONFIG_USB_DWC3_PCI)		+=3D dwc3-pci.o
>  obj-$(CONFIG_USB_DWC3_KEYSTONE)		+=3D dwc3-keystone.o
> +obj-$(CONFIG_USB_DWC3_ST)		+=3D dwc3-st.o
> diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
> new file mode 100644
> index 0000000..227698f
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-st.c
> @@ -0,0 +1,336 @@
> +/**
> + * dwc3-st.c Support for dwc3 platform devices on ST Microelectronics pl=
atforms
> + *
> + * This is a small driver for the dwc3 to provide the glue logic
> + * to configure the controller. Tested on STi platforms.
> + *
> + * Copyright (C) 2014 Stmicroelectronics
> + *
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + * Contributors: Aymen Bouattay <aymen.bouattay@st.com>
> + *               Peter Griffin <peter.griffin@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Inspired by dwc3-omap.c and dwc3-exynos.c.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <linux/usb/of.h>
> +
> +#include "core.h"
> +#include "io.h"
> +
> +/* glue registers */
> +#define CLKRST_CTRL		0x00
> +#define AUX_CLK_EN		BIT(0)
> +#define SW_PIPEW_RESET_N	BIT(4)
> +#define EXT_CFG_RESET_N		BIT(8)
> +/*
> + * 1'b0 : The host controller complies with the xHCI revision 0.96
> + * 1'b1 : The host controller complies with the xHCI revision 1.0
> + */
> +#define XHCI_REVISION		BIT(12)
> +
> +#define USB2_VBUS_MNGMNT_SEL1	0x2C
> +/*
> + * For all fields in USB2_VBUS_MNGMNT_SEL1
> + * 2=E2=80=99b00 : Override value from Reg 0x30 is selected
> + * 2=E2=80=99b01 : utmiotg_<signal_name> from usb3_top is selected
> + * 2=E2=80=99b10 : pipew_<signal_name> from PIPEW instance is selected
> + * 2=E2=80=99b11 : value is 1'b0
> + */
> +#define USB2_VBUS_REG30		0x0
> +#define USB2_VBUS_UTMIOTG	0x1
> +#define USB2_VBUS_PIPEW		0x2
> +#define USB2_VBUS_ZERO		0x3
> +
> +#define SEL_OVERRIDE_VBUSVALID(n)	(n << 0)
> +#define SEL_OVERRIDE_POWERPRESENT(n)	(n << 4)
> +#define SEL_OVERRIDE_BVALID(n)		(n << 8)
> +
> +/* Static DRD configuration */
> +#define USB_HOST_DEFAULT_MASK	0xffe
> +#define USB_SET_PORT_DEVICE	0x1
> +
> +/**
> + * struct st_dwc3 - dwc3-st driver private structure
> + * @dev:		device pointer
> + * @glue_base:		ioaddr for the glue registers
> + * @regmap:		regmap pointer for getting syscfg
> + * @syscfg_reg_off:	usb syscfg control offset
> + * @dr_mode:		drd static host/device config
> + * @rstc_pwrdn:		rest controller for powerdown signal
> + * @rstc_rst:		reset controller for softreset signal
> + */
> +
> +struct st_dwc3 {
> +	struct device *dev;
> +	void __iomem *glue_base;
> +	struct regmap *regmap;
> +	int syscfg_reg_off;
> +	enum usb_dr_mode dr_mode;
> +	struct reset_control *rstc_pwrdn;
> +	struct reset_control *rstc_rst;
> +};
> +
> +static inline u32 st_dwc3_readl(void __iomem *base, u32 offset)
> +{
> +	return readl_relaxed(base + offset);
> +}
> +
> +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u32 va=
lue)
> +{
> +	writel_relaxed(value, base + offset);

why relaxed ?

> +}
> +
> +/**
> + * st_dwc3_drd_init: program the port
> + * @dwc3_data: driver private structure
> + * Description: this function is to program the port as either host or d=
evice
> + * according to the static configuration passed from devicetree.
> + * OTG and dual role are not yet supported!
> + */
> +static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
> +{
> +	u32 val;
> +	int err;
> +
> +	err =3D regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
> +	if (err)
> +		return err;
> +
> +	switch (dwc3_data->dr_mode) {
> +	case USB_DR_MODE_PERIPHERAL:
> +		val |=3D USB_SET_PORT_DEVICE;
> +		dev_dbg(dwc3_data->dev, "Configuring as Device\n");
> +		break;
> +
> +	case USB_DR_MODE_HOST:
> +		val &=3D USB_HOST_DEFAULT_MASK;

are you missing a ~ here ? Also, shouldn't you mask off the bits before
this switch ?

> +		dev_dbg(dwc3_data->dev, "Configuring as Host\n");
> +		break;
> +
> +	default:
> +		dev_err(dwc3_data->dev, "Unsupported mode of operation %d\n",
> +			dwc3_data->dr_mode);
> +		return -EINVAL;
> +	}
> +
> +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, val);
> +}
> +
> +/**
> + * st_dwc3_init: init the controller via glue logic
> + * @dwc3_data: driver private structure
> + */
> +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> +{
> +

this blank line isn't necessary.

> +	u32 reg =3D st_dwc3_readl(dwc3_data->glue_base, CLKRST_CTRL);
> +
> +	reg |=3D AUX_CLK_EN | EXT_CFG_RESET_N | XHCI_REVISION;
> +	reg &=3D ~SW_PIPEW_RESET_N;
> +	st_dwc3_writel(dwc3_data->glue_base, CLKRST_CTRL, reg);
> +
> +	/* configure mux for vbus, powerpresent and bvalid signals */
> +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> +
> +	reg |=3D SEL_OVERRIDE_VBUSVALID(USB2_VBUS_UTMIOTG) |
> +		SEL_OVERRIDE_POWERPRESENT(USB2_VBUS_UTMIOTG) |
> +		SEL_OVERRIDE_BVALID(USB2_VBUS_UTMIOTG);
> +
> +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> +
> +	reg =3D st_dwc3_readl(dwc3_data->glue_base, CLKRST_CTRL);
> +	reg |=3D SW_PIPEW_RESET_N;
> +	st_dwc3_writel(dwc3_data->glue_base, CLKRST_CTRL, reg);
> +}
> +
> +static int st_dwc3_probe(struct platform_device *pdev)
> +{
> +	struct st_dwc3 *dwc3_data;
> +	struct resource *res;
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *node =3D dev->of_node, *child;
> +	struct regmap *regmap;
> +	int ret;
> +
> +	dwc3_data =3D devm_kzalloc(dev, sizeof(*dwc3_data), GFP_KERNEL);
> +	if (!dwc3_data)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg-glue");
> +	dwc3_data->glue_base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(dwc3_data->glue_base))
> +		return PTR_ERR(dwc3_data->glue_base);
> +
> +	regmap =3D syscon_regmap_lookup_by_phandle(node, "st,syscfg");
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	dma_set_coherent_mask(dev, dev->coherent_dma_mask);
> +	dwc3_data->dev =3D dev;
> +	dwc3_data->regmap =3D regmap;
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg"=
);
> +	if (!res) {
> +		ret =3D -ENXIO;
> +		goto undo_platform_dev_alloc;
> +	}
> +
> +	dwc3_data->syscfg_reg_off =3D res->start;
> +
> +	dev_dbg(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
> +		dwc3_data->glue_base, dwc3_data->syscfg_reg_off);

looks like this message would be more of a dev_vdbg().

> +	dwc3_data->rstc_pwrdn =3D devm_reset_control_get(dev, "powerdown");
> +	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
> +		dev_err(&pdev->dev, "could not get power controller\n");
> +		ret =3D PTR_ERR(dwc3_data->rstc_pwrdn);
> +		goto undo_platform_dev_alloc;
> +	}
> +
> +	/* Manage PowerDown */
> +	reset_control_deassert(dwc3_data->rstc_pwrdn);
> +
> +	dwc3_data->rstc_rst =3D devm_reset_control_get(dev, "softreset");
> +	if (IS_ERR(dwc3_data->rstc_rst)) {
> +		dev_err(&pdev->dev, "could not get reset controller\n");
> +		ret =3D PTR_ERR(dwc3_data->rstc_pwrdn);
> +		goto undo_powerdown;
> +	}
> +
> +	/* Manage SoftReset */
> +	reset_control_deassert(dwc3_data->rstc_rst);
> +
> +	child =3D of_get_child_by_name(node, "dwc3");
> +	if (!child) {
> +		dev_err(&pdev->dev, "failed to find dwc3 core node\n");
> +		ret =3D -ENODEV;
> +		goto undo_softreset;
> +	}
> +
> +	dwc3_data->dr_mode =3D of_usb_get_dr_mode(child);
> +
> +	/* Allocate and initialize the core */
> +	ret =3D of_platform_populate(node, NULL, NULL, dev);
> +	if (ret) {
> +		dev_err(dev, "failed to add dwc3 core\n");
> +		goto undo_softreset;
> +	}
> +
> +	/*
> +	 * Configure the USB port as device or host according to the static
> +	 * configuration passed from DT.
> +	 * DRD is the only mode currently supported so this will be enhanced
> +	 * as soon as OTG is available.
> +	 */
> +	ret =3D st_dwc3_drd_init(dwc3_data);
> +	if (ret) {
> +		dev_err(dev, "drd initialisation failed\n");
> +		goto undo_softreset;
> +	}
> +
> +	/* ST glue logic init */
> +	st_dwc3_init(dwc3_data);
> +
> +	platform_set_drvdata(pdev, dwc3_data);
> +	return 0;
> +
> +undo_softreset:
> +	reset_control_assert(dwc3_data->rstc_rst);
> +undo_powerdown:
> +	reset_control_assert(dwc3_data->rstc_pwrdn);
> +undo_platform_dev_alloc:
> +	platform_device_put(pdev);
> +	return ret;
> +}
> +
> +
> +static int st_dwc3_remove_child(struct device *dev, void *c)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +
> +	of_device_unregister(pdev);
> +
> +	return 0;
> +}
> +
> +static int st_dwc3_remove(struct platform_device *pdev)
> +{
> +	struct st_dwc3 *dwc3_data =3D platform_get_drvdata(pdev);
> +
> +	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);
> +
> +	reset_control_assert(dwc3_data->rstc_pwrdn);
> +	reset_control_assert(dwc3_data->rstc_rst);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int st_dwc3_suspend(struct device *dev)
> +{
> +	struct st_dwc3 *dwc3_data =3D dev_get_drvdata(dev);
> +
> +	reset_control_assert(dwc3_data->rstc_pwrdn);
> +	reset_control_assert(dwc3_data->rstc_rst);

Two questions:

1) how would you handle the case when this device is a wakeup source ?
2) when resuming, wouldn't you have to reinitialize the entire core ?

--=20
balbi

--BcZrms9gUsdgyR6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OQyAAoJEIaOsuA1yqREGCQP/1U0rvFShKhH/zlVgjIIYfwG
Z8HW34NIOoiWCKDGPgGRiWPy97BN7Nalz20mZuhRuClVojILmoD4qFb34Lxbn5uy
6Yc+aUB+O032voo5yvCMgI1p8D3fFtNfpX4/fvHqvjypHQxoyKTLU+Rwuz9XKg7I
vT5EYz6GUzByAPvwR6yUIF60tVVfCNnmMuFc6NFV8WJzurjLpkd4ls1PVgwHBGGQ
SZnxJjt4p+WQhiFCalG8eVhIuq5pqGmq8FmJSgY04sw3A6a1x7CCZm/yaZJP9lFv
8wgOUrZ9LKae+wCOjsuvAWO5G53dbjw34PZgOYx3g47BuaSFl6tdEVwbGSYBj9aJ
nfPIPbf/IrApgq8WXtG9HXVAzzFxBlYf5HQ+sbadzqg7gWv4WhmyzAmbwd5FbwXY
thRSq8TZnKlhOYImMq0guBci6edgHIMsQQ76hMVjFXtB+9eAoTUBv67HrqhmUEFH
W0n19dhgsctDH9JU32BmVT5zTUo2IHrxljQuZkuxytJiWCbcp4gdDFA/BSLUYaO3
g7DCdoLihAb97A5iIs0NeiAvvqiAGw4+J/KmxUs/H9Bse+8DoAEcI3+U1DgW90z5
UC0T9haT21mLS//cOvPDUfJRfy6QN17m/e00aOfQndknnvMjUXr8Tv/aJ5nm+9k4
BehEeVNi/Wjpxz5uQDqy
=XmDO
-----END PGP SIGNATURE-----

--BcZrms9gUsdgyR6a--
