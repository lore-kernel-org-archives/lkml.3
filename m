Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaGVO5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:57:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaGVO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:57:51 -0400
Date: Tue, 22 Jul 2014 09:57:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140722145711.GC20588@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
 <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 22, 2014 at 10:18:00AM +0100, Peter Griffin wrote:
> > > +static inline u32 st_dwc3_readl(void __iomem *base, u32 offset)
> > > +{
> > > +	return readl_relaxed(base + offset);
> > > +}
> > > +
> > > +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u3=
2 value)
> > > +{
> > > +	writel_relaxed(value, base + offset);
> > > +}
> >=20
> > Why are these being abstracted?
> >=20
> > Just use {read,write}l_relaxed() directly.
>=20
> Ok, unabstracted in v3

no, no... all other glues add their own local helpers for register
access. This is good for tracing, it's very easy to add a tracepoint to
this sort of function and get very low overhead tracing of every
register access.

> > > +	if (dwc3_data->drd_device_conf)
> > > +		val |=3D USB_SET_PORT_DEVICE;
> > > +	else
> > > +		val &=3D USB_HOST_DEFAULT_MASK;
> > > +
> > > +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, v=
al);
> > > +}
> > > +
> > > +/**
> > > + * st_dwc3_init: init the controller via glue logic
> > > + * @dwc3_data: driver private structure
> > > + */
> > > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > > +{
> > > +	u32 reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > > +
> > > +	reg |=3D aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> > > +	reg &=3D ~sw_pipew_reset_n(1);
> >=20
> > 1?  Better to add defines for these magic numbers.  What is 1 anyway?
>=20
> They are just bit setting macros, I've converted them over to use BIT mac=
ro now,
> so it no longer takes a parameter.

the macros are better, but make them upper case as everybody else.

> > > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> > > +
> > > +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> > > +	reg |=3D SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> > > +	    SEL_OVERRIDE_BVALID(1);
> > > +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> > > +	udelay(100);
> >=20
> > Why 100?
>=20
> I've asked ST how this value was derirved and why. It came from validatio=
n.=20
> The docs don't mention that it is necessary, and removing it
> seems to have no ill effects. So I've removed this udelay in v3.

make sure to test with many, many iterations just to make sure.

> > > +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > > +	reg |=3D sw_pipew_reset_n(1);
> > > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> > > +}
> > > +
> > > +static void st_dwc3_dt_get_pdata(struct platform_device *pdev,
> > > +				 struct st_dwc3 *dwc3_data)
> > > +{
> > > +	struct device_node *np =3D pdev->dev.of_node;
> > > +
> > > +	dwc3_data->drd_device_conf =3D
> > > +	    of_property_read_bool(np, "st,dwc3-drd-device");
> >=20
> > This requires a DT Ack.
>=20
> Ok. Do the DT folks have any comment on this?

look at the child's dr-mode property instead of adding your own.

> > > +	dwc3_data->glue_base =3D devm_request_and_ioremap(dev, res);

use devm_ioremap_resource()

> > > +	regmap =3D syscon_regmap_lookup_by_phandle(node, "st,syscfg");
> > > +	if (IS_ERR(regmap))
> > > +		return PTR_ERR(regmap);
> > > +
> > > +	dwc3 =3D platform_device_alloc("st-dwc3", PLATFORM_DEVID_AUTO);
> > > +	if (!dwc3) {
> > > +		dev_err(&pdev->dev, "couldn't allocate dwc3 device\n");
> > > +		return -ENOMEM;
> > > +	}
> >=20
> > I'm confused.  What is this doing?  Isn't this the DWC3 driver, which
> > already had a platform device structure associated to it?  Perhaps a
> > small ASCII diagram describing the layers might be useful.
>=20
> Your right, this was wrong. It was some legacy code which is
> unnecessary and I've removed this in v3.

if you're going for DT, why don't you create the parent and the child
=66rom DT as omap/exynos/qcom are doing ?

> > > +	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
> > > +
> > > +	dwc3->dev.parent =3D &pdev->dev;
> > > +	dwc3->dev.dma_mask =3D pdev->dev.dma_mask;
> > > +	dwc3->dev.dma_parms =3D pdev->dev.dma_parms;

stick to DT device creation. Look into dwc3-omap.c

> > > +static int st_dwc3_remove(struct platform_device *pdev)
> > > +{
> > > +	struct st_dwc3 *dwc3_data =3D platform_get_drvdata(pdev);
> > > +
> > > +	platform_device_unregister(dwc3_data->dwc3);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> > > +static int st_dwc3_suspend(struct device *dev)
> > > +{
> > > +	struct st_dwc3 *dwc3_data =3D dev_get_drvdata(dev);
> > > +
> > > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > > +
> > > +	pinctrl_pm_select_sleep_state(dev);

pinctrl will select sleep and default states automatically for you.

--=20
balbi

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTznvHAAoJEIaOsuA1yqREpVMP/jkGe5yLTxr+K+egeGvQXHgN
26ikpoyXrnv8MbrPcdeUTGTZ/Z2SP0CNVzGZ4vFV4n+XrjL/CbwU4oxn2CHW1Ig+
ruAjBE4aQTC0U/OIjBWA6NhBb/41ej7MbpPEOMgpZ0ErYM/g8Ax2662z2AEHXe8g
9oqIZgMA++7zCElIQRnQav2IoeQ3BXVu/0ujMskUjH038LYTDstKJ4xu/JPzK4Xm
TREeKJPXZVMF4gxLwer2MpbhMEeSrxTI/+XFU3/qhvSTvoEliXCKqhiIa7SKcXZU
RzieJMzVnWxu6vK43CyFfzYRfi+LRy6FfMCRTfwa6HkhOGjw6pwUddHZC2z4HcQq
PP6ysPLXWhc/oCmwDxG1pM9A2EFjI6Ge1cDU2AfDWmhmql6GVE8tP/aGIQneYFcm
2XBhDG40kPuJNGx1jIwUECRH/1yJ5jxtEe6J9frFd+GVO/J/JR+XVBBMHzws77U+
rKe4F/O7yRIyPMKG+w4mfoF6Q223JPN1DEc0MxFy98G+u480XqSPslPfaSA7aIZ6
VM6d9ka28AGYJFroUonNSZZrCoPe+r9qDxi35r01N1rBmZsWqE5CkKbJoNmzGjoU
GnSQNe7D3rqefPdwLMIpaxjejVbB0ao9jIiOkLqLKa0K0MbtYjfFynEWzhqxystq
GQy7+l17bpfvqL+4oVaf
=9Vkc
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
