Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaBNNxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:53:55 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53593 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaBNNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <52F39710.80101@samsung.com>
References: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
	<1390225363-24210-1-git-send-email-gautam.vivek@samsung.com>
	<52F39710.80101@samsung.com>
Date: Fri, 14 Feb 2014 19:23:51 +0530
Message-ID: <CAFp+6iFYoN1w_BX7mMEa-Xx5ADaPTTKeDzjsSbQmwVKdSEsmOw@mail.gmail.com>
Subject: Re: [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        kishon <kishon@ti.com>, Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Julius Werner <jwerner@chromium.org>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Thu, Feb 6, 2014 at 7:37 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Vivek,
>
> This patch is just adding the PHY driver. I would also like to look at some
> users of it, to see how this works when put together.

The DWC3's changes had been posted by Kishon sometime back, which will enable
DWC3 to use generic PHY dirver. [1]
I had skipped posting corresponding arch patch to use DWC3 on Exynos5
(although i had
posted that in earlier versions of the patch-series).
I will post the corresponding arch patches in the next version of the
patch-series.

>
> For now, please see my comments inline.
>
>
> On 20.01.2014 14:42, Vivek Gautam wrote:
>>
>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> The new driver uses the generic PHY framework and will interact
>> with DWC3 controller present on Exynos5 series of SoCs.
>> Thereby, removing old phy-samsung-usb3 driver and related code
>> used untill now which was based on usb/phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Changes from v2:
>> 1) Added support for multiple PHYs (UTMI+ and PIPE3) and
>>     related changes in the driver structuring.
>
>
> I'm a bit skeptical about this separation. Can the PHY operate with just the
> UTMI+ or PIPE3 part enabled alone without the other? Can any PHY consumer
> operate this way?

Yes :-)
As also pointed by Kishon the PHY consumer (which is DWC3 in case of
Exynos5 SoC series)
should theoretically be able use either UTMI+ phy for High speed
operations or both (UTMI+ and PIPE3)
for Super Speed operations.

>
> Introducing separation of something that can't exist alone doesn't add any
> value, but instead makes things more difficult to work with. Of course, it's
> fine if the answer to my questions above if yes, but better safe than sorry.



>
>
>> 2) Added a xlate function to get the required phy out of
>>     number of PHYs in mutiple PHY scenerio.
>> 3) Changed the names of few structures and variables to
>>     have a clearer meaning.
>> 4) Added 'usb3phy_config' structure to take care of mutiple
>>     phys for a SoC having 'exynos5_usb3phy_drv_data' driver data.
>> 5) Not deleting support for old driver 'phy-samsung-usb3' until
>>     required support for generic phy is added to DWC3.
>
>
> [snip]
>
>
>> +
>> +- aliases: For SoCs like Exynos5420 having multiple USB PHY controllers,
>> +          'usb3_phy' nodes should have numbered alias in the aliases
>> node,
>> +          in the form of usb3phyN, N = 0, 1... (depending on number of
>> +          controllers).
>> +Example:
>> +       aliases {
>> +               usb3phy0 = &usb3_phy0;
>> +               usb3phy1 = &usb3_phy1;
>> +       };
>
>
> What is the reason to have these aliases?
>
>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 330ef2d..32f9f38 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -51,4 +51,12 @@ config PHY_EXYNOS_DP_VIDEO
>>         help
>>           Support for Display Port PHY found on Samsung EXYNOS SoCs.
>>
>> +config PHY_EXYNOS5_USB3
>> +       tristate "Exynos5 SoC series USB 3.0 PHY driver"
>> +       depends on ARCH_EXYNOS5
>> +       select GENERIC_PHY
>> +       select MFD_SYSCON
>> +       help
>> +         Enable USB 3.0 PHY support for Exynos 5 SoC series
>> +
>>   endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index d0caae9..9c06a61 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)       +=
>> phy-exynos-dp-video.o
>>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)   += phy-exynos-mipi-video.o
>>   obj-$(CONFIG_OMAP_USB2)                       += phy-omap-usb2.o
>>   obj-$(CONFIG_TWL4030_USB)             += phy-twl4030-usb.o
>> +obj-$(CONFIG_PHY_EXYNOS5_USB3)         += phy-exynos5-usb3.o
>> diff --git a/drivers/phy/phy-exynos5-usb3.c
>> b/drivers/phy/phy-exynos5-usb3.c
>> new file mode 100644
>> index 0000000..24efed0
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5-usb3.c
>> @@ -0,0 +1,621 @@
>> +/*
>> + * Samsung EXYNOS5 SoC series USB 3.0 PHY driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Author: Vivek Gautam <gautam.vivek@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mutex.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>> +
>> +/* Exynos USB PHY registers */
>> +#define EXYNOS5_FSEL_9MHZ6             0x0
>> +#define EXYNOS5_FSEL_10MHZ             0x1
>> +#define EXYNOS5_FSEL_12MHZ             0x2
>> +#define EXYNOS5_FSEL_19MHZ2            0x3
>> +#define EXYNOS5_FSEL_20MHZ             0x4
>> +#define EXYNOS5_FSEL_24MHZ             0x5
>> +#define EXYNOS5_FSEL_50MHZ             0x7
>> +
>> +/* EXYNOS5: USB 3.0 DRD PHY registers */
>> +#define EXYNOS5_DRD_LINKSYSTEM                 (0x04)
>
>
> nit: No need for parentheses around simple literal. (+ more occurrences
> below)
Ok, will remove them.

>
>
>> +
>> +#define LINKSYSTEM_FLADJ_MASK                  (0x3f << 1)
>> +#define LINKSYSTEM_FLADJ(_x)                   ((_x) << 1)
>> +#define LINKSYSTEM_XHCI_VERSION_CONTROL                (0x1 << 27)
>
>
> nit: BIT() macro could be used for single bits. (+ more occurrences below)

Pointed out by Kishon too. :-)
Will use them.

>
>
>> +
>> +#define EXYNOS5_DRD_PHYUTMI                    (0x08)

[snip]

>> +
>> +static int exynos5_usb3phy_init(struct phy *phy)
>> +{
>> +       int ret;
>> +       u32 phyparam0;
>> +       u32 phyparam1;
>> +       u32 linksystem;
>> +       u32 phybatchg;
>> +       u32 phytest;
>> +       u32 phyclkrst;
>> +       struct phy_usb_instance *inst = phy_get_drvdata(phy);
>> +       struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
>> +
>> +       ret = clk_prepare_enable(drv->clk);
>> +       if (ret)
>> +               return ret;
>> +
>> +       drv->extrefclk = exynos5_rate_to_clk(drv->rate);
>> +       if (drv->extrefclk == -EINVAL) {
>> +               dev_err(drv->dev, "Clock rate (%ld) not supported\n",
>> +                                               drv->rate);
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Reset USB 3.0 PHY */
>> +       writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
>> +
>> +       phyparam0 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
>> +       /* Select PHY CLK source */
>> +       phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
>> +       /* Set Loss-of-Signal Detector sensitivity */
>> +       phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
>> +       phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
>> +       writel(phyparam0, drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
>> +
>> +       writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYRESUME);
>> +
>> +       /*
>> +        * Setting the Frame length Adj value[6:1] to default 0x20
>> +        * See xHCI 1.0 spec, 5.2.4
>> +        */
>> +       linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
>> +                    LINKSYSTEM_FLADJ(0x20);
>> +       writel(linksystem, drv->reg_phy + EXYNOS5_DRD_LINKSYSTEM);
>> +
>> +       phyparam1 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
>> +       /* Set Tx De-Emphasis level */
>> +       phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
>> +       phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
>> +       writel(phyparam1, drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
>> +
>> +       phybatchg = readl(drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
>> +       phybatchg |= PHYBATCHG_UTMI_CLKSEL;
>> +       writel(phybatchg, drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
>> +
>> +       /* PHYTEST POWERDOWN Control */
>> +       phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
>> +       phytest &= ~(PHYTEST_POWERDOWN_SSP |
>> +                    PHYTEST_POWERDOWN_HSP);
>> +       writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
>> +
>> +       /* UTMI Power Control */
>> +       writel(PHYUTMI_OTGDISABLE, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
>> +
>> +       phyclkrst = exynos5_usb3phy_set_refclk(drv);
>> +
>> +       phyclkrst |= PHYCLKRST_PORTRESET |
>> +                    /* Digital power supply in normal operating mode */
>> +                    PHYCLKRST_RETENABLEN |
>> +                    /* Enable ref clock for SS function */
>> +                    PHYCLKRST_REF_SSP_EN |
>> +                    /* Enable spread spectrum */
>> +                    PHYCLKRST_SSC_EN |
>> +                    /* Power down HS Bias and PLL blocks in suspend mode
>> */
>> +                    PHYCLKRST_COMMONONN;
>> +
>> +       writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +       udelay(10);
>> +
>> +       phyclkrst &= ~PHYCLKRST_PORTRESET;
>> +       writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +       clk_disable_unprepare(drv->clk);
>
>
> I'm still not convinced that this is the right place for this setup. This
> way you force consumer driver to always call phy_power_on() and phy_init()
> together, otherwise the PHY won't work.

Isn't how the things are supposed to work ?
call phy_init() to initialize the PHY and then call phy_power_on().
power_on() will simply
take care of disabling the power isolation for PHY (or simply provide
enable power to PHY)
and therefore doesn't need to worry about the initialization part.
Atleast that's the approach in DWC3 patch from Kishon [1]

>
> I believe the right thing to do here is to do all the initialization in
> .power_on() and let the driver simply call phy_power_on() when it needs the
> PHY and phy_power_off() otherwise.

If this is what we should be doing then what will be the purpose of
two separate APIs :
phy_power_on() and phy_init().
Am i missing while understanding the things.

>
> Analogically, .exit() should be merged into .power_off().
>
>
>> +
>> +       return 0;
>> +}
>
>
> [snip]
>
>
>> +       /*
>> +        * Exynos5420 SoC has multiple channels for USB 3.0 PHY, with
>> +        * each having separate power control registers.
>> +        * 'drv->channel' facilitates to set such registers.
>> +        */
>> +       if (drv->drv_data->has_multi_controller) {
>> +               drv->channel = of_alias_get_id(node, "usb3phy");
>> +               if (drv->channel < 0) {
>> +                       dev_err(dev, "Invalid usb3drd phy node\n");
>> +                       return -EINVAL;
>> +               }
>> +       }
>
>
> Aha, so this is why you need aliases. Maybe a "samsung,pmu-offset" property,
> simply specifying the offset to PMU regs would be better here?
Ok.

>
>
>> +
>> +       drv->clk = devm_clk_get(dev, "phy");
>> +       if (IS_ERR(drv->clk)) {
>> +               dev_err(dev, "Failed to get clock of phy controller\n");
>> +               return PTR_ERR(drv->clk);
>> +       }
>> +
>> +       /*
>> +        * Exysno5420 SoC has an additional special clock, used for
>> +        * for USB 3.0 PHY operation, this clock goes to the PHY block
>> +        * as a reference clock to clock generation block of the
>> controller,
>> +        * named as 'USB30_SCLK_100M'.
>> +        */
>> +       if (drv_data->has_usb30_sclk) {
>> +               drv->usb30_sclk = devm_clk_get(dev, "usb30_sclk_100m");
>> +               if (IS_ERR(drv->usb30_sclk)) {
>> +                       dev_err(dev, "Failed to get phy reference
>> clock\n");
>> +                       return PTR_ERR(drv->usb30_sclk);
>> +               }
>> +       }
>> +
>> +       clk = clk_get(dev, "usb3phy_refclk");
>> +       if (IS_ERR(clk)) {
>> +               dev_err(dev, "Failed to get reference clock of usb3drd
>> phy\n");
>> +               return PTR_ERR(clk);
>> +       }
>> +       drv->rate = clk_get_rate(clk);
>> +       clk_put(clk);
>
>
> To comply with clock API semantics, you should keep the reference on this
> clock until the driver is removed. Moreover, I believe you should call
> clk_prepare_enable() on it as well, to make sure that the clock is enabled,
> even if current implementation of clock drivers for Exynos 5 can't disable
> this clock.

Ok will do this.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
