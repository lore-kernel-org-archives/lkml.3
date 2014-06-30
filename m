Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaF3RBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:01:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33119 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbaF3RBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:01:19 -0400
Date: Mon, 30 Jun 2014 12:00:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andy Gross <agross@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>, <jackp@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [Patch v7 2/3] usb: phy: Add Qualcomm DWC3 HS/SS PHY drivers
Message-ID: <20140630170041.GD31442@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <1404144233-17222-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <1404144233-17222-3-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

first of all, since this is a brand new PHY driver, could you guys use
the generic phy framework instead ? (drivers/phy)

On Mon, Jun 30, 2014 at 11:03:52AM -0500, Andy Gross wrote:
> diff --git a/drivers/usb/phy/phy-qcom-hsusb.c b/drivers/usb/phy/phy-qcom-=
hsusb.c
> new file mode 100644
> index 0000000..7a44b13
> --- /dev/null
> +++ b/drivers/usb/phy/phy-qcom-hsusb.c
> @@ -0,0 +1,348 @@
> +/* Copyright (c) 2013-2014, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
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
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/usb/phy.h>
> +
> +/**
> + *  USB QSCRATCH Hardware registers
> + */
> +#define QSCRATCH_CTRL_REG		(0x04)
> +#define QSCRATCH_GENERAL_CFG		(0x08)
> +#define PHY_CTRL_REG			(0x10)
> +#define PARAMETER_OVERRIDE_X_REG	(0x14)
> +#define CHARGING_DET_CTRL_REG		(0x18)
> +#define CHARGING_DET_OUTPUT_REG		(0x1c)
> +#define ALT_INTERRUPT_EN_REG		(0x20)
> +#define PHY_IRQ_STAT_REG		(0x24)
> +#define CGCTL_REG			(0x28)
> +
> +#define PHY_3P3_VOL_MIN			3050000 /* uV */
> +#define PHY_3P3_VOL_MAX			3300000 /* uV */
> +#define PHY_3P3_HPM_LOAD		16000	/* uA */
> +
> +#define PHY_1P8_VOL_MIN			1800000 /* uV */
> +#define PHY_1P8_VOL_MAX			1800000 /* uV */
> +#define PHY_1P8_HPM_LOAD		19000	/* uA */
> +
> +/* TODO: these are suspicious */
> +#define USB_VDDCX_NO			1	/* index */
> +#define USB_VDDCX_MIN			5	/* index */
> +#define USB_VDDCX_MAX			7	/* index */
> +
> +/* PHY_CTRL_REG */
> +#define HSUSB_CTRL_DMSEHV_CLAMP			BIT(24)
> +#define HSUSB_CTRL_USB2_SUSPEND			BIT(23)
> +#define HSUSB_CTRL_UTMI_CLK_EN			BIT(21)
> +#define	HSUSB_CTRL_UTMI_OTG_VBUS_VALID		BIT(20)
> +#define HSUSB_CTRL_USE_CLKCORE			BIT(18)
> +#define HSUSB_CTRL_DPSEHV_CLAMP			BIT(17)
> +#define HSUSB_CTRL_COMMONONN			BIT(11)
> +#define HSUSB_CTRL_ID_HV_CLAMP			BIT(9)
> +#define HSUSB_CTRL_OTGSESSVLD_CLAMP		BIT(8)
> +#define HSUSB_CTRL_CLAMP_EN			BIT(7)
> +#define HSUSB_CTRL_RETENABLEN			BIT(1)
> +#define HSYSB_CTRL_POR				BIT(0)
> +
> +
> +/* QSCRATCH_GENERAL_CFG */
> +#define HSUSB_GCFG_XHCI_REV		BIT(2)
> +
> +struct qcom_dwc3_hs_phy {
> +	struct usb_phy		phy;
> +	void __iomem		*base;
> +	struct device		*dev;
> +
> +	struct clk		*xo_clk;
> +	struct clk		*utmi_clk;
> +
> +	struct regulator	*v3p3;
> +	struct regulator	*v1p8;
> +	struct regulator	*vddcx;
> +	struct regulator	*vbus;
> +};
> +
> +#define	phy_to_dw_phy(x)	container_of((x), struct qcom_dwc3_hs_phy, phy)
> +
> +/**
> + * Write register.
> + *
> + * @base - QCOM DWC3 PHY base virtual address.
> + * @offset - register offset.
> + * @val - value to write.
> + */
> +static inline void qcom_dwc3_hs_write(void __iomem *base, u32 offset, u3=
2 val)
> +{
> +	writel(val, base + offset);
> +}
> +
> +/**
> + * Write register and read back masked value to confirm it is written
> + *
> + * @base - QCOM DWC3 PHY base virtual address.
> + * @offset - register offset.
> + * @mask - register bitmask specifying what should be updated
> + * @val - value to write.
> + */
> +static inline void qcom_dwc3_hs_write_readback(void __iomem *base, u32 o=
ffset,
> +					    const u32 mask, u32 val)
> +{
> +	u32 write_val, tmp =3D readl(base + offset);
> +
> +	tmp &=3D ~mask;		/* retain other bits */
> +	write_val =3D tmp | val;
> +
> +	writel(write_val, base + offset);
> +
> +	/* Read back to see if val was written */
> +	tmp =3D readl(base + offset);
> +	tmp &=3D mask;		/* clear other bits */
> +
> +	if (tmp !=3D val)
> +		pr_err("write: %x to QSCRATCH: %x FAILED\n", val, offset);

really nit-picking - and I'm not even sure I care - but passing a dev
pointer to use dev_err() here might be a good idea.

> +}
> +
> +static void qcom_dwc3_hs_phy_shutdown(struct usb_phy *x)
> +{
> +	struct qcom_dwc3_hs_phy *phy =3D phy_to_dw_phy(x);
> +	int ret;
> +
> +	ret =3D regulator_set_voltage(phy->v3p3, 0, PHY_3P3_VOL_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for v3p3\n");
> +
> +	ret =3D regulator_set_voltage(phy->v1p8, 0, PHY_1P8_VOL_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for v1p8\n");
> +
> +	ret =3D regulator_disable(phy->v1p8);

alright, now this is really a personal doubt. Is it really necessary to
set zero 0 volts if you're going to shut it down ?

> +	if (ret)
> +		dev_err(phy->dev, "cannot disable v1p8\n");
> +
> +	ret =3D regulator_disable(phy->v3p3);
> +	if (ret)
> +		dev_err(phy->dev, "cannot disable v3p3\n");
> +
> +	ret =3D regulator_set_voltage(phy->vddcx, USB_VDDCX_NO, USB_VDDCX_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for vddcx\n");
> +
> +	ret =3D regulator_disable(phy->vddcx);
> +	if (ret)
> +		dev_err(phy->dev, "cannot enable vddcx\n");
> +
> +	clk_disable_unprepare(phy->utmi_clk);
> +}
> +
> +static int qcom_dwc3_hs_phy_init(struct usb_phy *x)
> +{
> +	struct qcom_dwc3_hs_phy	*phy =3D phy_to_dw_phy(x);
> +	int ret;
> +	u32 val;
> +
> +	clk_prepare_enable(phy->utmi_clk);
> +
> +	ret =3D regulator_set_voltage(phy->vddcx, USB_VDDCX_MIN, USB_VDDCX_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for vddcx\n");
> +
> +	ret =3D regulator_enable(phy->vddcx);
> +	if (ret)
> +		dev_err(phy->dev, "cannot enable vddcx\n");
> +
> +	ret =3D regulator_set_voltage(phy->v3p3, PHY_3P3_VOL_MIN,
> +				    PHY_3P3_VOL_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for v3p3\n");
> +
> +	ret =3D regulator_set_voltage(phy->v1p8, PHY_1P8_VOL_MIN,
> +				    PHY_1P8_VOL_MAX);
> +	if (ret)
> +		dev_err(phy->dev, "cannot set voltage for v1p8\n");
> +
> +	ret =3D regulator_set_optimum_mode(phy->v1p8, PHY_1P8_HPM_LOAD);
> +	if (ret < 0)
> +		dev_err(phy->dev, "cannot set HPM of regulator v1p8\n");
> +
> +	ret =3D regulator_enable(phy->v1p8);
> +	if (ret)
> +		dev_err(phy->dev, "cannot enable v1p8\n");
> +
> +	ret =3D regulator_set_optimum_mode(phy->v3p3, PHY_3P3_HPM_LOAD);
> +	if (ret < 0)
> +		dev_err(phy->dev, "cannot set HPM of regulator v3p3\n");
> +
> +	ret =3D regulator_enable(phy->v3p3);
> +	if (ret)
> +		dev_err(phy->dev, "cannot enable v3p3\n");
> +
> +	/*
> +	 * HSPHY Initialization: Enable UTMI clock, select 19.2MHz fsel
> +	 * enable clamping, and disable RETENTION (power-on default is ENABLED)
> +	 */
> +	val =3D HSUSB_CTRL_DPSEHV_CLAMP | HSUSB_CTRL_DMSEHV_CLAMP |
> +		HSUSB_CTRL_RETENABLEN  | HSUSB_CTRL_COMMONONN |
> +		HSUSB_CTRL_OTGSESSVLD_CLAMP | HSUSB_CTRL_ID_HV_CLAMP |
> +		HSUSB_CTRL_DPSEHV_CLAMP | HSUSB_CTRL_UTMI_OTG_VBUS_VALID |
> +		HSUSB_CTRL_UTMI_CLK_EN | HSUSB_CTRL_CLAMP_EN | 0x70;
> +
> +	/* use core clock if external reference is not present */
> +	if (!phy->xo_clk)
> +		val |=3D HSUSB_CTRL_USE_CLKCORE;
> +
> +	qcom_dwc3_hs_write(phy->base, PHY_CTRL_REG, val);
> +	usleep_range(2000, 2200);
> +
> +	/*
> +	 * write HSPHY init value to QSCRATCH reg to set HSPHY parameters like
> +	 * VBUS valid threshold, disconnect valid threshold, DC voltage level,
> +	 * preempasis and rise/fall time.
> +	 */
> +	qcom_dwc3_hs_write_readback(phy->base, PARAMETER_OVERRIDE_X_REG,
> +				0x03ffffff, 0x00d191a4);

this can be dangerous, actually. VBUS Valid Threshold, Session Valid
Threshold, etc, are all defined by the USB spec, why would you have to
change it ? Maybe this is related to some errata and should be wrapped
with a revision check or something ?

> +	/* Disable (bypass) VBUS and ID filters */
> +	qcom_dwc3_hs_write(phy->base, QSCRATCH_GENERAL_CFG,
> +		HSUSB_GCFG_XHCI_REV);
> +
> +	return 0;
> +}
> +
> +static int qcom_dwc3_hs_phy_set_vbus(struct usb_phy *x, int on)
> +{
> +	struct qcom_dwc3_hs_phy	*phy =3D phy_to_dw_phy(x);
> +	int ret =3D 0;
> +
> +	if (IS_ERR(phy->vbus))
> +		return on ? PTR_ERR(phy->vbus) : 0;

this regulator seems to be optional, should you error out here if it's
not available at all ?

> +
> +	if (on)
> +		ret =3D regulator_enable(phy->vbus);
> +	else
> +		ret =3D regulator_disable(phy->vbus);
> +
> +	if (ret)
> +		dev_err(x->dev, "Cannot %s Vbus\n", on ? "set" : "off");
> +	return ret;
> +}
> +
> +static int qcom_dwc3_hs_probe(struct platform_device *pdev)
> +{
> +	struct qcom_dwc3_hs_phy	*phy;
> +	struct resource		*res;
> +	void __iomem		*base;
> +
> +	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, phy);
> +
> +	phy->dev =3D &pdev->dev;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	base =3D devm_ioremap_resource(phy->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	phy->vddcx =3D devm_regulator_get(phy->dev, "vddcx");
> +	if (IS_ERR(phy->vddcx)) {
> +		dev_dbg(phy->dev, "cannot get vddcx\n");
> +		return  PTR_ERR(phy->vddcx);
> +	}
> +
> +	phy->v3p3 =3D devm_regulator_get(phy->dev, "v3p3");
> +	if (IS_ERR(phy->v3p3)) {
> +		dev_dbg(phy->dev, "cannot get v3p3\n");
> +		return PTR_ERR(phy->v3p3);
> +	}
> +
> +	phy->v1p8 =3D devm_regulator_get(phy->dev, "v1p8");
> +	if (IS_ERR(phy->v1p8)) {
> +		dev_dbg(phy->dev, "cannot get v1p8\n");
> +		return PTR_ERR(phy->v1p8);
> +	}
> +
> +	phy->vbus =3D devm_regulator_get(phy->dev, "vbus");
> +	if (IS_ERR(phy->vbus))
> +		dev_dbg(phy->dev, "Failed to get vbus\n");
> +
> +	phy->utmi_clk =3D devm_clk_get(phy->dev, "utmi");
> +	if (IS_ERR(phy->utmi_clk)) {
> +		dev_dbg(phy->dev, "cannot get UTMI handle\n");
> +		return PTR_ERR(phy->utmi_clk);
> +	}
> +
> +	phy->xo_clk =3D devm_clk_get(phy->dev, "xo");
> +	if (IS_ERR(phy->xo_clk)) {
> +		dev_dbg(phy->dev, "cannot get TCXO buffer handle\n");
> +		phy->xo_clk =3D NULL;
> +	}
> +
> +	clk_set_rate(phy->utmi_clk, 60000000);
> +
> +	if (phy->xo_clk)
> +		clk_prepare_enable(phy->xo_clk);
> +
> +	phy->base		=3D base;
> +	phy->phy.dev		=3D phy->dev;
> +	phy->phy.label		=3D "qcom-dwc3-hsphy";
> +	phy->phy.init		=3D qcom_dwc3_hs_phy_init;
> +	phy->phy.shutdown	=3D qcom_dwc3_hs_phy_shutdown;
> +	phy->phy.set_vbus	=3D qcom_dwc3_hs_phy_set_vbus;
> +	phy->phy.type		=3D USB_PHY_TYPE_USB2;
> +	phy->phy.state          =3D OTG_STATE_UNDEFINED;
> +
> +	usb_add_phy_dev(&phy->phy);
> +	return 0;
> +}
> +
> +static int qcom_dwc3_hs_remove(struct platform_device *pdev)
> +{
> +	struct qcom_dwc3_hs_phy *phy =3D platform_get_drvdata(pdev);
> +
> +	if (phy->xo_clk)
> +		clk_disable_unprepare(phy->xo_clk);
> +
> +	clk_disable_unprepare(phy->utmi_clk);
> +
> +	usb_remove_phy(&phy->phy);

you might have exposed a bug on the current PHY framework. There's no
guarantee that your regulators will be turned off when you remove this
driver. ehehehe..

ps: most comments are valid for the ssusb.c PHY driver as well. In fact,
they seem to be pretty similar; perhaps there's a way to share more code
between them ?

--=20
balbi

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsZe5AAoJEIaOsuA1yqREVcoP/iYiDDlaVoqI7tL1CpXXTuIv
0H5OKqfjvClE6DnnV4kFWdIrUmjp/E2AJC3pK3I6jiQB983DmbUHkC/dkJIDjfTu
G8K/nnaOZm7Tn6GAKS6V3TXpNJ412Gr+CX6slenmY+rIejJCIkxWYpTNMyM6Fg7K
A/bqp2MQD+IDML/am+YFvSMGuwBVQuJq/+nm0JS0SiIM0HAf+oo2R7n2iRGmHNv1
cAxu1CyvvzSxu1NaANZ8HqrXBeGdX4d0efZp4Mv+tSmbA/QtYXNHdQUwlF42koZq
+xrsF6DAlVMnreztMN7UrIRNmLMMCLSfrEKfsdmzssziCBvKVn8iiL0YDUdIJJl8
1UDjQR8sJXnlX/xB7M7jyFf/6Oozcpll5KH8wbQatKDfAFghh9m8Y2cYuUouK4Aq
KKl6qsQjXCPaaSYXbjbMYEcDy5SkyViL5UFw3aGR+3OckTBTPExScHmA8JEWzRKJ
skSs+MiO7nuBxtDTg8VOsOBbly9JhXxgsbHew07zfPHx3wQ4QYDPjpP3KhxgASQ3
6y06TvQkyKGE7e+vg70H0EOuFPJFaB53WmOV0QOmVhbHsC4lh+asEKrCNrA0zgl7
DeaSAarkPnc6g55Mv98MT0esjei9L+M+eUl5NYSNw1n18sKEBzwoHFYNl3/fTXRx
gYW52+lpx4rfdBhnH0Cr
=XyD6
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
