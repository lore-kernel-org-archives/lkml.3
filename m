Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbbAGLzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:55:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42290 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbAGLze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:55:34 -0500
Message-ID: <1420631728.3191.52.camel@pengutronix.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, kernel@pengutronix.de,
        Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Heiko Stuebner <heiko@sntech.de>
Date: Wed, 07 Jan 2015 12:55:28 +0100
In-Reply-To: <54AD15E5.5070803@samsung.com>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
	 <35536202.10QfWIDQqq@wuerfel> <1420628264.3191.27.camel@pengutronix.de>
	 <54AD15E5.5070803@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Am Mittwoch, den 07.01.2015, 16:47 +0530 schrieb Pankaj Dubey:
> Hi Philipp,
> 
> On Wednesday 07 January 2015 04:27 PM, Philipp Zabel wrote:
> > Am Dienstag, den 06.01.2015, 20:36 +0100 schrieb Arnd Bergmann:
> >> On Tuesday 06 January 2015 16:30:36 Philipp Zabel wrote:
> >>> Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
> >>> breaks probing pure syscon devices from device tree, such as anatop and
> >>> iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
> >>> "syscon" compatible device tree nodes.
> >>>
> >>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> >>>
> >>
> >> I don't understand it. Why is this required?
> >
> > The debugfs entries vanished and I'd like to have a device to register
> > platform device children to.
> 
> Yes debugfs entries will not be present for syscon, this is as per 
> discussion happened here [1]. At that time one suggestion came from Arnd 
> that we can have a different representation for syscon regmaps, instead 
> of based on devices just based on of_node pointer.
> 
> 1: https://lkml.org/lkml/2014/9/26/73

Thank you for the pointer. That would work for me just as well.

> I was just thinking, missing debugfs entry is your concern, or you want 
> to make child devices of syscon devices? Basically I am still trying to 
> understand your requirement.

Both. I'd like to somehow get the debug entry back, whether by
optionally associating syscon with a device or by adding special syscon
support to regmap.
And I'd like to eventually register platform devices under the syscon
node in the device tree. Currently in the i.MX device tree we have three
overlapping nodes next to each other:

	gpr: iomuxc-gpr@20e00000 {
		compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
		reg = <0x020e0000 0x38>;
	};

	iomuxc: iomuxc@020e0000 {
		compatible = "fsl,imx6q-iomuxc";
		reg = <0x020e0000 0x4000>;
	};

	ldb: ldb@020e0008 {
		compatible = "fsl,imx6q-ldb";
		gpr = <&gpr>;
	};

The ldb device is controlled purely through the gpr regmap, so in my
opinion it should be a child to the iomuxc-gpr node:

	gpr: iomuxc-gpr@20e00000 {
		compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
		reg = <0x020e0000 0x38>;

		ldb: ldb@020e0008 {
			compatible = "fsl,imx6q-ldb";
			gpr = <&gpr>;
		};
	};

	iomuxc: iomuxc@020e0000 {
		compatible = "fsl,imx6q-iomuxc";
		reg = <0x020e0000 0x4000>;
	};

In that case, if there is no device associated with iomuxc-gpr, which
device should be the parent to ldb? If the syscon is created from the
iomuxc device, the ldb device could be made a child to iomuxc.
In fact, since the gpr registers are part of the iomuxc register space,
one could even think about merging the iomuxg-gpr syscon into the iomuxc
node:

	gpr: iomuxc: iomuxc@020e0000 {
		compatible = "fsl,imx6q-iomuxc", "fsl,imx6q-iomuxc-gpr";
		reg = <0x020e0000 0x4000>;

		ldb: ldb@020e0008 {
			compatible = "fsl,imx6q-ldb";
		};
	};

> I guess for i.MX iomuxc it could be argued
> > that the iomuxc-gpr syscon should be merged into the iomuxc pinctrl
> > device instead of probing iomuxc-gpr as a platform device by itself.
> > How about allowing to register a syscon for a given device:
> >
> > ----8<----
> > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> > index d2280d6..2633b27 100644
> > --- a/drivers/mfd/syscon.c
> > +++ b/drivers/mfd/syscon.c
> > @@ -42,13 +42,14 @@ static struct regmap_config syscon_regmap_config = {
> >   	.reg_stride = 4,
> >   };
> >
> > -static struct syscon *of_syscon_register(struct device_node *np)
> > +struct syscon *syscon_register(struct device *dev, struct device_node *np)
> >   {
> >   	struct syscon *syscon;
> >   	struct regmap *regmap;
> >   	void __iomem *base;
> >   	int ret;
> >   	struct regmap_config syscon_config = syscon_regmap_config;
> > +	struct resource res;
> >
> >   	if (!of_device_is_compatible(np, "syscon"))
> >   		return ERR_PTR(-EINVAL);
> > @@ -57,7 +58,12 @@ static struct syscon *of_syscon_register(struct device_node *np)
> >   	if (!syscon)
> >   		return ERR_PTR(-ENOMEM);
> >
> > -	base = of_iomap(np, 0);
> > +	if (of_address_to_resource(np, 0, &res)) {
> > +		ret = -ENOMEM;
> > +		goto err_map;
> > +	}
> > +
> > +	base = ioremap(res.start, resource_size(&res));
> >   	if (!base) {
> >   		ret = -ENOMEM;
> >   		goto err_map;
> > @@ -69,7 +75,8 @@ static struct syscon *of_syscon_register(struct device_node *np)
> >   	 else if (of_property_read_bool(np, "little-endian"))
> >   		syscon_config.val_format_endian = REGMAP_ENDIAN_LITTLE;
> >
> > -	regmap = regmap_init_mmio(NULL, base, &syscon_config);
> > +	syscon_regmap_config.max_register = res.end - res.start - 3;
> > +	regmap = regmap_init_mmio(dev, base, &syscon_config);
> >   	if (IS_ERR(regmap)) {
> >   		pr_err("regmap init failed\n");
> >   		ret = PTR_ERR(regmap);
> > @@ -91,6 +98,12 @@ err_map:
> >   	kfree(syscon);
> >   	return ERR_PTR(ret);
> >   }
> > +EXPORT_SYMBOL_GPL(syscon_register);
> > +
> 
> In past a similar approach [2] for letting device driver to register 
> themselves as syscon provided, has been rejected giving reason that 
> syscon should not need it's own platform device.

In that mail Arnd mentions registering a syscon with both an optional
device and an explicit device_node pointer, which is what this patch
would do. There is no need for a platform device.

regards
Philipp

