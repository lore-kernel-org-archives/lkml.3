Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaGVJSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:18:11 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58840 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaGVJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:18:08 -0400
Date: Tue, 22 Jul 2014 10:18:00 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140707124627.GG6407@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for reviewing, see my comments inline below: -

On Mon, 07 Jul 2014, Lee Jones wrote:

> On Sat, 05 Jul 2014, Peter Griffin wrote:
> 
> > This patch adds the ST glue logic to manage the DWC3 HC
> > on STiH407 SoC family. It manages the powerdown signal,
> > and configures the internal glue logic and syscfg registers.
> > 
> > Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  drivers/usb/dwc3/Kconfig   |   9 ++
> >  drivers/usb/dwc3/Makefile  |   1 +
> >  drivers/usb/dwc3/dwc3-st.c | 325 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 335 insertions(+)
> >  create mode 100644 drivers/usb/dwc3/dwc3-st.c
> > 
> > diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> > index 8eb996e..6c85c43 100644
> > --- a/drivers/usb/dwc3/Kconfig
> > +++ b/drivers/usb/dwc3/Kconfig
> > @@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
> >  	  Support of USB2/3 functionality in TI Keystone2 platforms.
> >  	  Say 'Y' or 'M' here if you have one such device
> >  
> > +config USB_DWC3_ST
> > +	tristate "STMicroelectronics Platforms"
> > +	depends on ARCH_STI && OF
> > +	default USB_DWC3_HOST
> > +	help
> > +	  STMicroelectronics SoCs with one DesignWare Core USB3 IP
> > +	  inside (i.e. STiH407).
> > +	  Say 'Y' or 'M' if you have one such device.
> > +
> >  comment "Debugging features"
> >  
> >  config USB_DWC3_DEBUG
> > diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> > index 10ac3e7..11c9f54 100644
> > --- a/drivers/usb/dwc3/Makefile
> > +++ b/drivers/usb/dwc3/Makefile
> > @@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
> >  obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
> >  obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
> >  obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
> > +obj-$(CONFIG_USB_DWC3_ST)		+= dwc3-st.o
> > diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
> > new file mode 100644
> > index 0000000..2cae9d3
> > --- /dev/null
> > +++ b/drivers/usb/dwc3/dwc3-st.c
> > @@ -0,0 +1,325 @@
> > +/**
> > + * dwc3-st.c Support for dwc3 platform devices on ST Microelectronics platforms
> > + *
> > + * This is a small platform driver for the dwc3 to provide the glue logic
> > + * to configure the controller. Tested on STi platforms.
> 
> Not sure about the use of the term 'platform driver' here and in the
> title.  We don't normally differentiate.  I can find examples to the
> contrary, but not many.

Ok, removed 'platform' in V3
> 
> > + * Copyright (C) 2014 Stmicroelectronics
> > + *
> > + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > + * Contributors: Aymen Bouattay <aymen.bouattay@st.com>
> > + *               Peter Griffin <peter.griffin@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * Inspired by dwc3-omap.c and dwc3-exynos.c.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/ioport.h>
> > +#include <linux/io.h>
> > +#include <linux/of.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/delay.h>
> > +#include <linux/regmap.h>
> > +#include <linux/reset.h>
> > +
> > +#include "core.h"
> > +#include "io.h"
> > +
> > +/* Reg glue registers */
> > +#define USB2_CLKRST_CTRL 0x00
> > +#define aux_clk_en(n) ((n)<<0)
> > +#define sw_pipew_reset_n(n) ((n)<<4)
> > +#define ext_cfg_reset_n(n) ((n)<<8)
> > +#define xhci_revision(n) ((n)<<12)
> 
> These all need reformatting, see CodingStyle - 3.1: Spaces

Ok I have added a space either side of the shift operator and aligned
using tabs.

> 
>   #define xhci_revision(n)     ((n) << 12)
> 
> Lining them up with TABs would make them easier to read.

Ok fixed in v3

> 
> Also, I don't think there is a requirement to encapsulate the 'n'.

Ok removed brackets around the 'n'

> 
> > +#define USB2_VBUS_MNGMNT_SEL1 0x2C
> > +/*
> > + * 2'b00 : Override value from Reg 0x30 is selected
> > + * 2'b01 : utmiotg_vbusvalid from usb3_top top is selected
> > + * 2'b10 : pipew_powerpresent from PIPEW instance is selected
> > + * 2'b11 : value is 1'b0
> > + */
> 
> What is this documenting?  Isn't documentation meant to make things
> clearer?  Now I'm just really confused - by the documentation.

It is documenting the bitfields in VBUS_MNGMNT_SEL1 register. I've 
hopefully made it a bit clearer by adding the following comment and
slightly adjusting the descriptions a little.

/*
 * For all fields in USB2_VBUS_MNGMNT_SEL1
 * 2’b00 : Override value from Reg 0x30 is selected
 * 2’b01 : utmiotg_<signal_name> from usb3_top is selected
 * 2’b10 : pipew_<signal_name> from PIPEW instance is selected
 * 2’b11 : value is 1'b0
 */

Apart from that it's a standard way to describe bitfields. You can find
some examples in cx231xx-pcb-cfg.h, bnx2x_link.h and cx231xx-avcore.c

> 
> > +#define SEL_OVERRIDE_VBUSVALID(n) ((n)<<0)
> > +#define SEL_OVERRIDE_POWERPRESENT(n) ((n)<<4)
> > +#define SEL_OVERRIDE_BVALID(n) ((n)<<8)
> > +
> > +#define USB2_VBUS_MNGMNT_VAL1 0x30
> > +#define OVERRIDE_VBUSVALID_VAL (1 << 0)
> > +#define OVERRIDE_POWERPRESENT_VAL (1 << 4)
> > +#define OVERRIDE_BVALID_VAL (1 << 8)
> 
> Use BIT() for all of these bit setting macros.

Ok fixed in V3
> 
> > +/* Static DRD configuration */
> > +#define USB_HOST_DEFAULT_MASK	0xffe
> > +#define USB_SET_PORT_DEVICE	0x1
> > +
> > +struct st_dwc3 {
> > +	struct platform_device *dwc3;	/* platform device pointer */
> > +	struct device *dev;	/* device pointer */
> > +	void __iomem *glue_base;	/* ioaddr for programming the glue */
> > +	struct regmap *regmap;	/* regmap for getting syscfg */
> > +	int syscfg_reg_off;	/* usb syscfg control offset */
> > +	bool drd_device_conf;	/* DRD static host/device conf */
> > +	struct reset_control *rstc_pwrdn;/* Rst control for powerdown*/
> > +};
> 
> This is a mess.  Use kerneldoc formatting instead.

Ok, converted to kerneldoc in V3
> 
> > +static inline u32 st_dwc3_readl(void __iomem *base, u32 offset)
> > +{
> > +	return readl_relaxed(base + offset);
> > +}
> > +
> > +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u32 value)
> > +{
> > +	writel_relaxed(value, base + offset);
> > +}
> 
> Why are these being abstracted?
> 
> Just use {read,write}l_relaxed() directly.

Ok, unabstracted in v3
> 
> > +/**
> > + * st_dwc3_drd_init: program the port
> > + * @dwc3_data: driver private structure
> > + * Description: this function is to program the port as either host or device
> > + * according to the static configuration passed from devicetree.
> > + * OTG and dual role are not yet supported!
> > + */
> > +static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
> > +{
> > +	u32 val;
> > +
> > +	regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
> 
> Shouldn't you be checking the return value of regmap_read()?

Ok, fixed in V3

> 
> > +	if (dwc3_data->drd_device_conf)
> > +		val |= USB_SET_PORT_DEVICE;
> > +	else
> > +		val &= USB_HOST_DEFAULT_MASK;
> > +
> > +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, val);
> > +}
> > +
> > +/**
> > + * st_dwc3_init: init the controller via glue logic
> > + * @dwc3_data: driver private structure
> > + */
> > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > +{
> > +	u32 reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > +
> > +	reg |= aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> > +	reg &= ~sw_pipew_reset_n(1);
> 
> 1?  Better to add defines for these magic numbers.  What is 1 anyway?

They are just bit setting macros, I've converted them over to use BIT macro now,
so it no longer takes a parameter.

> Port one?  If so, shouldn't this function be called
> st_dwc2_init_port_one(), or similar?

No.

> 
> > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> > +
> > +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> > +	reg |= SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> > +	    SEL_OVERRIDE_BVALID(1);
> > +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> > +	udelay(100);
> 
> Why 100?

I've asked ST how this value was derirved and why. It came from validation. 
The docs don't mention that it is necessary, and removing it
seems to have no ill effects. So I've removed this udelay in v3.
> 
> > +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > +	reg |= sw_pipew_reset_n(1);
> > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> > +}
> > +
> > +static void st_dwc3_dt_get_pdata(struct platform_device *pdev,
> > +				 struct st_dwc3 *dwc3_data)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +
> > +	dwc3_data->drd_device_conf =
> > +	    of_property_read_bool(np, "st,dwc3-drd-device");
> 
> This requires a DT Ack.

Ok. Do the DT folks have any comment on this?

> 
> > +}
> > +
> > +/**
> > + * st_dwc3_probe: main probe function
> > + * @pdev: platform_device
> > + * Description: this is the probe function that gets all the resources to manage
> > + * the glue-logic, setup the controller and take out of powerdown.
> > + */
> 
> I've never seen .probe() documented before?  I think you can safely
> remove this kerneldoc header.

Ok I have removed the documentation in V3
> 
> > +static int st_dwc3_probe(struct platform_device *pdev)
> > +{
> > +	struct platform_device *dwc3;
> > +	struct st_dwc3 *dwc3_data;
> > +	struct resource *res;
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *node = dev->of_node;
> > +	struct regmap *regmap;
> > +	int ret = 0;
> 
> No need to initialise.

Ok fixed in v3

> 
> > +	if (!node) {
> > +		dev_err(dev, "device node not found\n");
> > +		return -EINVAL;
> > +	}
> 
> Remove this and make the driver depend on OF.

I have removed the check, as driver already depends on OF.

> 
> > +	dwc3_data = devm_kzalloc(dev, sizeof(*dwc3_data), GFP_KERNEL);
> > +	if (!dwc3_data)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg-glue");
> > +	if (!res)
> > +		return -ENXIO;
> 
> No need to check res here, devm_request_and_ioremap() does it for you.

Ok removed error check, and added comment explaining why there is no checking
> 
> > +	dwc3_data->glue_base = devm_request_and_ioremap(dev, res);
> > +	if (!dwc3_data->glue_base)
> > +		return -EADDRNOTAVAIL;
> 
> What?  Better to return the value from devm_request_and_ioremap() than
> make up your own.

Actually it isn't made up, devm_request_and_ioremap returns either the remapped 
pointer or NULL on error. Returning -EADDRNOTAVAIL is
taken from the devm_request_and_ioremap kerneldoc usage example.
> 
> > +	regmap = syscon_regmap_lookup_by_phandle(node, "st,syscfg");
> > +	if (IS_ERR(regmap))
> > +		return PTR_ERR(regmap);
> > +
> > +	dwc3 = platform_device_alloc("st-dwc3", PLATFORM_DEVID_AUTO);
> > +	if (!dwc3) {
> > +		dev_err(&pdev->dev, "couldn't allocate dwc3 device\n");
> > +		return -ENOMEM;
> > +	}
> 
> I'm confused.  What is this doing?  Isn't this the DWC3 driver, which
> already had a platform device structure associated to it?  Perhaps a
> small ASCII diagram describing the layers might be useful.

Your right, this was wrong. It was some legacy code which is unnecessary and 
I've removed this in v3.
> 
> > +	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
> > +
> > +	dwc3->dev.parent = &pdev->dev;
> > +	dwc3->dev.dma_mask = pdev->dev.dma_mask;
> > +	dwc3->dev.dma_parms = pdev->dev.dma_parms;
> > +
> > +	dwc3_data->dwc3 = dwc3;
> > +	dwc3_data->dev = &pdev->dev;
> 
> We're saving this twice, it's already available in dwc3, which we just
> saved.

Fixed in V3

> 
> > +	dwc3_data->regmap = regmap;
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg");
> > +	if (!res) {
> > +		ret = -ENXIO;
> > +		goto undo_platform_dev_alloc;
> > +	}
> > +
> > +	dwc3_data->syscfg_reg_off = res->start;
> > +
> > +	dev_info(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
> > +		 dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
> 
> I think this should be removed.  At the very least downgraded to
> dev_dbg().

Ok downgraded to dev_dbg in V3

> 
> > +	dwc3_data->rstc_pwrdn = devm_reset_control_get(dwc3_data->dev, NULL);
> > +	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
> > +		dev_err(&pdev->dev, "could not get reset controller\n");
> > +		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
> > +		goto undo_platform_dev_alloc;
> > +	}
> > +
> > +	/* Manage PowerDown */
> > +	reset_control_deassert(dwc3_data->rstc_pwrdn);
> > +
> > +	st_dwc3_dt_get_pdata(pdev, dwc3_data);
> 
> As there is only one line in this function and this driver is DT only,
> I would bring that line directly into .probe().

Ok, fixed in v3

> 
> > +	/* Allocate and initialize the core */
> > +	ret = of_platform_populate(node, NULL, NULL, dev);
> > +	if (ret) {
> > +		dev_err(dev, "failed to add dwc3 core\n");
> > +		goto undo_powerdown;
> > +	}
> > +
> > +	/*
> > +	 * Configure the USB port as device or host according to the static
> > +	 * configuration passed from the platform.
> > +	 * DRD is the only mode currently supported so this will be enhanced
> > +	 * later as soon as OTG will be available.
> > +	 */
> > +	ret = st_dwc3_drd_init(dwc3_data);
> > +	if (ret) {
> > +		dev_err(dev, "st_dwc3_drd_init failed\n");
> 
> I wouldn't have names of functions in the kernel log.
> 
> Swap out for something like "initialisation failed\n"

Ok, changed to "drd initialisation failed" in v3
> 
> > +		goto undo_powerdown;
> > +	}
> > +
> > +	dev_info(&pdev->dev, "configured as %s DRD\n",
> > +		 dwc3_data->drd_device_conf ? "device" : "host");
> > +
> > +	/* ST glue logic init */
> > +	st_dwc3_init(dwc3_data);
> 
> Can this fail?

Intresting question, basically no it can't except if the IP is not clocked or held in
reset in which case it would hang the chip and never return.

> 
> > +	ret = platform_device_add_resources(dwc3_data->dwc3, pdev->resource,
> > +					    pdev->num_resources);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "couldn't add resources to dwc3 device\n");
> > +		goto undo_powerdown;
> > +	}
> > +
> > +	ret = platform_device_add(dwc3_data->dwc3);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to register dwc3 device\n");
> > +		goto undo_powerdown;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, dwc3_data);
> > +
> > +	return 0;
> > +
> > +undo_powerdown:
> > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > +undo_platform_dev_alloc:
> > +	platform_device_put(pdev);
> > +
> > +	return ret;
> > +
> 
> Remove the '\n' here.

Ok removed in V3
> 
> > +}
> > +
> > +static int st_dwc3_remove(struct platform_device *pdev)
> > +{
> > +	struct st_dwc3 *dwc3_data = platform_get_drvdata(pdev);
> > +
> > +	platform_device_unregister(dwc3_data->dwc3);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int st_dwc3_suspend(struct device *dev)
> > +{
> > +	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
> > +
> > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > +
> > +	pinctrl_pm_select_sleep_state(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int st_dwc3_resume(struct device *dev)
> > +{
> > +	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
> > +
> > +	pinctrl_pm_select_default_state(dev);
> > +
> > +	reset_control_deassert(dwc3_data->rstc_pwrdn);
> > +
> > +	return 0;
> > +}
> > +
> 
> Remove the '\n' here.

Ok removed in V3

> 
> > +#endif /* CONFIG_PM_SLEEP */
> > +
> > +static const struct dev_pm_ops st_dwc3_dev_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(st_dwc3_suspend, st_dwc3_resume)
> > +};
> 
> Use SIMPLE_DEV_PM_OPS().

Ok fixed in V3
> 
> > +static struct of_device_id st_dwc3_match[] = {
> > +	{ .compatible = "st,stih407-dwc3" },
> > +	{ /* sentinel */ },
> > +};
> > +
> > +MODULE_DEVICE_TABLE(of, st_dwc3_match);
> > +
> > +static struct platform_driver st_dwc3_driver = {
> > +	.probe = st_dwc3_probe,
> > +	.remove = st_dwc3_remove,
> > +	.driver = {
> > +		.name = "usb-st-dwc3",
> > +		.owner = THIS_MODULE,
> 
> This is done for you elese where, you can remove.

Ok removed in V3
> 
> > +		.of_match_table = of_match_ptr(st_dwc3_match),
> > +		.pm = &st_dwc3_dev_pm_ops,
> > +	},
> > +};
> > +
> > +module_platform_driver(st_dwc3_driver);
> > +
> > +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> > +MODULE_DESCRIPTION("DesignWare USB3 STi Glue Layer");
> > +MODULE_LICENSE("GPL v2");
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
