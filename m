Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKDRFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:05:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36475 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751035AbaKDRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:05:04 -0500
Date: Tue, 4 Nov 2014 18:03:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/6] phy: Add driver to support individual USB PHYs on
 sun9i
Message-ID: <20141104170315.GJ26729@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwWFXG4JqVa0wfCP"
Content-Disposition: inline
In-Reply-To: <1415074039-16590-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dwWFXG4JqVa0wfCP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 12:07:16PM +0800, Chen-Yu Tsai wrote:
> Unlike previous Allwinner SoCs, there is no central PHY control block
> on the A80. Also, OTG support is completely split off into a different
> controller.
>=20
> This adds a new driver to support the regular USB PHYs.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  .../devicetree/bindings/phy/sun9i-usb-phy.txt      |  34 +++
>  drivers/phy/Kconfig                                |  12 ++
>  drivers/phy/Makefile                               |   1 +
>  drivers/phy/phy-sun9i-usb.c                        | 227 +++++++++++++++=
++++++
>  4 files changed, 274 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/sun9i-usb-phy.t=
xt
>  create mode 100644 drivers/phy/phy-sun9i-usb.c
>=20
> diff --git a/Documentation/devicetree/bindings/phy/sun9i-usb-phy.txt b/Do=
cumentation/devicetree/bindings/phy/sun9i-usb-phy.txt
> new file mode 100644
> index 0000000..27a6067
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/sun9i-usb-phy.txt
> @@ -0,0 +1,34 @@
> +Allwinner sun9i USB PHY
> +-----------------------
> +
> +Required properties:
> +- compatible : should be one of
> +  * allwinner,sun9i-a80-usb-phy
> +- reg : a list of offset + length pairs
> +- #phy-cells : from the generic phy bindings, must be 0
> +- clocks : phandle + clock specifier for the phy clocks
> +- clock-names :
> +  * "phy" for normal USB
> +  * "hsic_480M", "hsic_12M" for HSIC

Do you need all of them? phy and one of the hsic one?

> +- resets : a list of phandle + reset specifier pairs
> +- reset-names :
> +  * "phy" for normal USB
> +  * "hsic" for HSIC
> +- phy_type : "hsic" for HSIC usage;
> +	     other values or absence of this property indicates normal USB
> +
> +It is recommended to list all clocks and resets available.
> +The driver will only use those matching the phy_type.
> +
> +Example:
> +	usbphy1: phy@00a01800 {
> +		compatible =3D "allwinner,sun9i-a80-usb-phy";
> +		reg =3D <0x00a01800 0x4>;
> +		clocks =3D <&usb_phy_clk 2>, <&usb_phy_clk 10>,
> +		       <&usb_phy_clk 3>;
> +		clock-names =3D "hsic_480M", "hsic_12M", "phy";
> +		resets =3D <&usb_phy_clk 18>, <&usb_phy_clk 19>;
> +		reset-names =3D "hsic", "phy";
> +		status =3D "disabled";
> +		#phy-cells =3D <0>;
> +	};
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2a436e6..f5b7fbb 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -153,6 +153,18 @@ config PHY_SUN4I_USB
>  	  This driver controls the entire USB PHY block, both the USB OTG
>  	  parts, as well as the 2 regular USB 2 host PHYs.
> =20
> +config PHY_SUN9I_USB
> +	tristate "Allwinner sun9i SoC USB PHY driver"
> +	depends on ARCH_SUNXI && HAS_IOMEM && OF
> +	depends on RESET_CONTROLLER
> +	select USB_PHY
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the transceiver that is part of Allwinner
> +	  sun9i SoCs.
> +
> +	  This driver controls each individual USB 2 host PHY.
> +
>  config PHY_SAMSUNG_USB2
>  	tristate "Samsung USB 2.0 PHY driver"
>  	depends on HAS_IOMEM
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index c4590fc..c3977dc 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_TWL4030_USB)		+=3D phy-twl4030-usb.o
>  obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+=3D phy-exynos5250-sata.o
>  obj-$(CONFIG_PHY_HIX5HD2_SATA)		+=3D phy-hix5hd2-sata.o
>  obj-$(CONFIG_PHY_SUN4I_USB)		+=3D phy-sun4i-usb.o
> +obj-$(CONFIG_PHY_SUN9I_USB)		+=3D phy-sun9i-usb.o
>  obj-$(CONFIG_PHY_SAMSUNG_USB2)		+=3D phy-exynos-usb2.o
>  phy-exynos-usb2-y			+=3D phy-samsung-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+=3D phy-exynos4210-usb2.o
> diff --git a/drivers/phy/phy-sun9i-usb.c b/drivers/phy/phy-sun9i-usb.c
> new file mode 100644
> index 0000000..f9085d9
> --- /dev/null
> +++ b/drivers/phy/phy-sun9i-usb.c
> @@ -0,0 +1,227 @@
> +/*
> + * Allwinner sun9i USB phy driver
> + *
> + * Copyright (C) 2014 Chen-Yu Tsai <wens@csie.org>
> + *
> + * Based on phy-sun9i.c from

I doubt this is the file you were thinking of :)

> + * Hans de Goede <hdegoede@redhat.com>
> + *
> + * and code from
> + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/usb/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +
> +#define SUNXI_AHB_ICHR8_EN		BIT(10)
> +#define SUNXI_AHB_INCR4_BURST_EN	BIT(9)
> +#define SUNXI_AHB_INCRX_ALIGN_EN	BIT(8)
> +#define SUNXI_ULPI_BYPASS_EN		BIT(0)
> +
> +struct sun9i_usb_phy {
> +	struct phy *phy;
> +	void __iomem *pmu;
> +	struct regulator *vbus;
> +	struct reset_control *reset;
> +	struct clk *clk;
> +	struct clk *hsic_clk;
> +};
> +
> +static void sun9i_usb_phy_passby(struct sun9i_usb_phy *phy, int enable)
> +{
> +	u32 bits, reg_value;
> +
> +	bits =3D SUNXI_AHB_ICHR8_EN | SUNXI_AHB_INCR4_BURST_EN |
> +		SUNXI_AHB_INCRX_ALIGN_EN | SUNXI_ULPI_BYPASS_EN;
> +
> +	reg_value =3D readl(phy->pmu);
> +
> +	if (enable)
> +		reg_value |=3D bits;
> +	else
> +		reg_value &=3D ~bits;
> +
> +	writel(reg_value, phy->pmu);
> +}
> +
> +static int sun9i_usb_phy_init(struct phy *_phy)
> +{
> +	struct sun9i_usb_phy *phy =3D phy_get_drvdata(_phy);
> +	int ret;
> +
> +	ret =3D clk_prepare_enable(phy->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (phy->hsic_clk) {
> +		ret =3D clk_prepare_enable(phy->hsic_clk);
> +		if (ret) {
> +			clk_disable_unprepare(phy->clk);
> +			return ret;
> +		}
> +	}
> +
> +	ret =3D reset_control_deassert(phy->reset);
> +	if (ret) {
> +		if (phy->hsic_clk)
> +			clk_disable_unprepare(phy->hsic_clk);
> +		clk_disable_unprepare(phy->clk);
> +		return ret;

Gotos in your exit path please.

> +	}
> +
> +	sun9i_usb_phy_passby(phy, 1);
> +
> +	return 0;
> +}
> +
> +static int sun9i_usb_phy_exit(struct phy *_phy)
> +{
> +	struct sun9i_usb_phy *phy =3D phy_get_drvdata(_phy);
> +
> +	sun9i_usb_phy_passby(phy, 0);
> +	reset_control_assert(phy->reset);
> +	if (phy->hsic_clk)
> +		clk_disable_unprepare(phy->hsic_clk);
> +	clk_disable_unprepare(phy->clk);
> +
> +	return 0;
> +}
> +
> +static int sun9i_usb_phy_power_on(struct phy *_phy)
> +{
> +	struct sun9i_usb_phy *phy =3D phy_get_drvdata(_phy);
> +	int ret =3D 0;
> +
> +	if (phy->vbus)
> +		ret =3D regulator_enable(phy->vbus);
> +
> +	return ret;
> +}
> +
> +static int sun9i_usb_phy_power_off(struct phy *_phy)
> +{
> +	struct sun9i_usb_phy *phy =3D phy_get_drvdata(_phy);
> +
> +	if (phy->vbus)
> +		regulator_disable(phy->vbus);
> +
> +	return 0;
> +}
> +
> +static struct phy_ops sun9i_usb_phy_ops =3D {
> +	.init		=3D sun9i_usb_phy_init,
> +	.exit		=3D sun9i_usb_phy_exit,
> +	.power_on	=3D sun9i_usb_phy_power_on,
> +	.power_off	=3D sun9i_usb_phy_power_off,
> +	.owner		=3D THIS_MODULE,
> +};
> +
> +static int sun9i_usb_phy_probe(struct platform_device *pdev)
> +{
> +	struct sun9i_usb_phy *phy;
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	struct phy_provider *phy_provider;
> +	struct resource *res;
> +	enum usb_phy_interface phy_type;
> +
> +	phy =3D devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy)
> +		return -ENOMEM;
> +
> +	phy->vbus =3D devm_regulator_get_optional(dev, "vbus");
> +	if (IS_ERR(phy->vbus)) {
> +		if (PTR_ERR(phy->vbus) =3D=3D -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +		phy->vbus =3D NULL;
> +	}
> +
> +	phy_type =3D of_usb_get_phy_mode(np);
> +	if (phy_type =3D=3D USBPHY_INTERFACE_MODE_HSIC) {
> +		phy->clk =3D devm_clk_get(dev, "hsic_480M");
> +		if (IS_ERR(phy->clk)) {
> +			dev_err(dev, "failed to get hsic_480M clock\n");
> +			return PTR_ERR(phy->clk);
> +		}
> +
> +		phy->hsic_clk =3D devm_clk_get(dev, "hsic_12M");
> +		if (IS_ERR(phy->clk)) {
> +			dev_err(dev, "failed to get hsic_12M clock\n");
> +			return PTR_ERR(phy->clk);
> +		}
> +
> +		phy->reset =3D devm_reset_control_get(dev, "hsic");
> +		if (IS_ERR(phy->reset)) {
> +			dev_err(dev, "failed to get reset control\n");
> +			return PTR_ERR(phy->reset);
> +		}
> +	} else {
> +		phy->clk =3D devm_clk_get(dev, "phy");
> +		if (IS_ERR(phy->clk)) {
> +			dev_err(dev, "failed to get phy clock\n");
> +			return PTR_ERR(phy->clk);
> +		}
> +
> +		phy->reset =3D devm_reset_control_get(dev, "phy");
> +		if (IS_ERR(phy->reset)) {
> +			dev_err(dev, "failed to get reset control\n");
> +			return PTR_ERR(phy->reset);
> +		}
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy->pmu =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy->pmu))
> +		return PTR_ERR(phy->pmu);
> +
> +	phy->phy =3D devm_phy_create(dev, NULL, &sun9i_usb_phy_ops, NULL);
> +	if (IS_ERR(phy->phy)) {
> +		dev_err(dev, "failed to create PHY\n");
> +		return PTR_ERR(phy->phy);
> +	}
> +
> +	phy_set_drvdata(phy->phy, phy);
> +	dev_set_drvdata(dev, phy);
> +	phy_provider =3D devm_of_phy_provider_register(dev, of_phy_simple_xlate=
);
> +
> +	return PTR_ERR_OR_ZERO(phy_provider);
> +}
> +
> +static const struct of_device_id sun9i_usb_phy_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun9i-a80-usb-phy" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, sun9i_usb_phy_of_match);
> +
> +static struct platform_driver sun9i_usb_phy_driver =3D {
> +	.probe	=3D sun9i_usb_phy_probe,
> +	.driver =3D {
> +		.of_match_table	=3D sun9i_usb_phy_of_match,
> +		.name  =3D "sun9i-usb-phy",
> +	}
> +};
> +module_platform_driver(sun9i_usb_phy_driver);
> +
> +MODULE_DESCRIPTION("Allwinner sun9i USB phy driver");
> +MODULE_AUTHOR("Chen-Yu Tsai <wens@csie.org>");
> +MODULE_LICENSE("GPL v2");

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dwWFXG4JqVa0wfCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWQbTAAoJEBx+YmzsjxAgF5UP/3jJP6OG63B4lKN09r/z2PEj
jhxaaI8rkJyJTFTli3ZO5dOCHSap+F9zdzRVcWvznLQQaYGMQH2M+sigeCEDaaeM
VXnPVWGhiyIFbgT7ujAUPCH7NDVCLhPtHREKpa0ocDBxlNn26QyEqfXn8lKTOVcQ
ZCEtcKSu9tk5/nVwYLx1A9mLcOCVJiKvJqj9nNHkL5SkZ2eLc+rM/cKRsQAAKKmz
0wd/pXU0bDVh76BeM7+608vTXRKb4YsJaiaVWd0Ekyd9P/DsBWXrx21JQ+lsOdZQ
I5Dmma7EwZ9J2NBMiJ9s8y8HK/LSQ08uOgQv1GQl/Z5+G4Ftgld2S57Bhn1G1J4C
19inCoyzYH5jCZAnQ8IXoLiD/p3f1swSKZT0KghjC34zYamn1bqnpZ5H7IjJBNEm
o1jXTSK0jSr34qbyE0oqMA9aydjfS39dfO3C1Ig5GmBnPZdqdsrTCPkP/1GtWQYP
vCgofXqExhOnkoGGx1wanmlPbE+2LMeSjmRx/MZYAEnXXu//W4W82uGiQa4uljdn
UuPJ8kYH4RHH2fuYH3BVA2MAEB6Pny9+No7PIU3Xmj8fmQNptmaESB66f7ayZCo7
H+XzfnWJ4ZvumV+rgngsAwsPN85WpKdfJyLMQtbdbpt9Gu4+Gv6psTY//hYN6Oy3
XHSTFxKHTWsmbya1E4u4
=ty2V
-----END PGP SIGNATURE-----

--dwWFXG4JqVa0wfCP--
