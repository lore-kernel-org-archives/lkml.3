Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaA3ETa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 23:19:30 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:62783 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3ET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 23:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <52E61F63.1090200@ti.com>
References: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
	<1390225363-24210-1-git-send-email-gautam.vivek@samsung.com>
	<52E61F63.1090200@ti.com>
Date: Thu, 30 Jan 2014 09:49:26 +0530
Message-ID: <CAFp+6iHGchyZFRGyT1D3O3mv6TFOMGUdYvc4qmLEanCKwMrDkw@mail.gmail.com>
Subject: Re: [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Julius Werner <jwerner@chromium.org>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On Mon, Jan 27, 2014 at 2:27 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,

Thanks for review. Please find my answers inline below.

>
> On Monday 20 January 2014 07:12 PM, Vivek Gautam wrote:
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
>>    related changes in the driver structuring.
>> 2) Added a xlate function to get the required phy out of
>>    number of PHYs in mutiple PHY scenerio.
>> 3) Changed the names of few structures and variables to
>>    have a clearer meaning.
>> 4) Added 'usb3phy_config' structure to take care of mutiple
>>    phys for a SoC having 'exynos5_usb3phy_drv_data' driver data.
>> 5) Not deleting support for old driver 'phy-samsung-usb3' until
>>    required support for generic phy is added to DWC3.
>>
>>  .../devicetree/bindings/phy/samsung-phy.txt        |   49 ++
>>  drivers/phy/Kconfig                                |    8 +
>>  drivers/phy/Makefile                               |    1 +
>>  drivers/phy/phy-exynos5-usb3.c                     |  621 ++++++++++++++++++++
>>  4 files changed, 679 insertions(+)
>>  create mode 100644 drivers/phy/phy-exynos5-usb3.c
[snip]

>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 330ef2d..32f9f38 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -51,4 +51,12 @@ config PHY_EXYNOS_DP_VIDEO
>>       help
>>         Support for Display Port PHY found on Samsung EXYNOS SoCs.
>>
>> +config PHY_EXYNOS5_USB3
>> +     tristate "Exynos5 SoC series USB 3.0 PHY driver"
>> +     depends on ARCH_EXYNOS5
>> +     select GENERIC_PHY
>> +     select MFD_SYSCON
>
> add depends on 'HAS_IOMEM'. Someone reported getting
> undefined reference to `devm_ioremap_resource' with it.

Ok will add it.

>> +     help
>> +       Enable USB 3.0 PHY support for Exynos 5 SoC series
>> +
>>  endmenu
[snip]

>> diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
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
>> +#define EXYNOS5_FSEL_9MHZ6           0x0
>> +#define EXYNOS5_FSEL_10MHZ           0x1
>> +#define EXYNOS5_FSEL_12MHZ           0x2
>> +#define EXYNOS5_FSEL_19MHZ2          0x3
>> +#define EXYNOS5_FSEL_20MHZ           0x4
>> +#define EXYNOS5_FSEL_24MHZ           0x5
>> +#define EXYNOS5_FSEL_50MHZ           0x7
>> +
>> +/* EXYNOS5: USB 3.0 DRD PHY registers */
>> +#define EXYNOS5_DRD_LINKSYSTEM                       (0x04)
>> +
>> +#define LINKSYSTEM_FLADJ_MASK                        (0x3f << 1)
>> +#define LINKSYSTEM_FLADJ(_x)                 ((_x) << 1)
>> +#define LINKSYSTEM_XHCI_VERSION_CONTROL              (0x1 << 27)
>> +
>> +#define EXYNOS5_DRD_PHYUTMI                  (0x08)
>> +
>> +#define PHYUTMI_OTGDISABLE                   (0x1 << 6)
>> +#define PHYUTMI_FORCESUSPEND                 (0x1 << 1)
>> +#define PHYUTMI_FORCESLEEP                   (0x1 << 0)
>
> use BIT macro here and below?

Ok.

>> +
>> +#define EXYNOS5_DRD_PHYPIPE                  (0x0c)
>> +
>> +#define EXYNOS5_DRD_PHYCLKRST                        (0x10)
>> +
>> +#define PHYCLKRST_EN_UTMISUSPEND             (0x1 << 31)
>> +
>> +#define PHYCLKRST_SSC_REFCLKSEL_MASK         (0xff << 23)
>> +#define PHYCLKRST_SSC_REFCLKSEL(_x)          ((_x) << 23)
>> +
>> +#define PHYCLKRST_SSC_RANGE_MASK             (0x03 << 21)
>> +#define PHYCLKRST_SSC_RANGE(_x)                      ((_x) << 21)
>> +
>> +#define PHYCLKRST_SSC_EN                     (0x1 << 20)
>> +#define PHYCLKRST_REF_SSP_EN                 (0x1 << 19)
>> +#define PHYCLKRST_REF_CLKDIV2                        (0x1 << 18)
>> +
>> +#define PHYCLKRST_MPLL_MULTIPLIER_MASK               (0x7f << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF (0x19 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF    (0x32 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF  (0x68 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF  (0x7d << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF       (0x02 << 11)
>> +
>> +#define PHYCLKRST_FSEL_MASK                  (0x3f << 5)
>> +#define PHYCLKRST_FSEL(_x)                   ((_x) << 5)
>> +#define PHYCLKRST_FSEL_PAD_100MHZ            (0x27 << 5)
>> +#define PHYCLKRST_FSEL_PAD_24MHZ             (0x2a << 5)
>> +#define PHYCLKRST_FSEL_PAD_20MHZ             (0x31 << 5)
>> +#define PHYCLKRST_FSEL_PAD_19_2MHZ           (0x38 << 5)
>> +
>> +#define PHYCLKRST_RETENABLEN                 (0x1 << 4)
>> +
>> +#define PHYCLKRST_REFCLKSEL_MASK             (0x03 << 2)
>> +#define PHYCLKRST_REFCLKSEL_PAD_REFCLK               (0x2 << 2)
>> +#define PHYCLKRST_REFCLKSEL_EXT_REFCLK               (0x3 << 2)
>> +
>> +#define PHYCLKRST_PORTRESET                  (0x1 << 1)
>> +#define PHYCLKRST_COMMONONN                  (0x1 << 0)
>> +
>> +#define EXYNOS5_DRD_PHYREG0                  (0x14)
>> +#define EXYNOS5_DRD_PHYREG1                  (0x18)
>> +
>> +#define EXYNOS5_DRD_PHYPARAM0                        (0x1c)
>> +
>> +#define PHYPARAM0_REF_USE_PAD                        (0x1 << 31)
>> +#define PHYPARAM0_REF_LOSLEVEL_MASK          (0x1f << 26)
>> +#define PHYPARAM0_REF_LOSLEVEL                       (0x9 << 26)
>> +
>> +#define EXYNOS5_DRD_PHYPARAM1                        (0x20)
>> +
>> +#define PHYPARAM1_PCS_TXDEEMPH_MASK          (0x1f << 0)
>> +#define PHYPARAM1_PCS_TXDEEMPH                       (0x1c)
>> +
>> +#define EXYNOS5_DRD_PHYTERM                  (0x24)
>> +
>> +#define EXYNOS5_DRD_PHYTEST                  (0x28)
>> +
>> +#define PHYTEST_POWERDOWN_SSP                        (0x1 << 3)
>> +#define PHYTEST_POWERDOWN_HSP                        (0x1 << 2)
>> +
>> +#define EXYNOS5_DRD_PHYADP                   (0x2c)
>> +
>> +#define EXYNOS5_DRD_PHYBATCHG                        (0x30)
>> +
>> +#define PHYBATCHG_UTMI_CLKSEL                        (0x1 << 2)
>> +
>> +#define EXYNOS5_DRD_PHYRESUME                        (0x34)
>> +#define EXYNOS5_DRD_LINKPORT                 (0x44)
>> +
>> +/* Power isolation defined in power management unit */
>> +#define EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET   (0x704)
>> +#define EXYNOS5_USB3DRD_PMU_ISOL             (1 << 0)
>> +
>> +#define KHZ  1000
>> +#define MHZ  (KHZ * KHZ)
>> +
>> +enum exynos5_usb3phy_id {
>> +     EXYNOS5_USB3PHY_UTMI,
>> +     EXYNOS5_USB3PHY_PIPE3,
>> +     EXYNOS5_USB3PHYS_NUM,
>> +};
>> +
>> +struct usb3phy_config {
>> +     u32 id;
>> +     u32 reg_pmu_offset;
>> +     void (*phy_isol)(struct phy *phy, u32 on);
>> +};
>> +
>> +struct exynos5_usb3phy_drv_data {
>> +     bool has_usb30_sclk;
>> +     bool has_multi_controller;
>> +     const struct usb3phy_config *phy_cfg;
>> +};
>> +
>> +/**
>> + * struct exynos5_usb3phy_driver - driver data for USB 3.0 PHY
>
> Is this really a driver data? I think it should be just exynos5_usb3phy.
Yes, not a driver data, rather just 'exynos_usb3phy' structure. will
modify the name

>> + * @dev: pointer to device instance of this platform device
>> + * @reg_phy: usb phy controller register memory base
>> + * @clk: phy clock for register access
>> + * @usb30_sclk: additional special clock for phy operations
>> + * @drv_data: pointer to SoC level driver data structure
>> + * @phys[]: array for 'EXYNOS5_USB3PHYS_NUM' number of PHY
>> + *       instances each with its 'phy' and 'phy_cfg'.
>> + * @extrefclk: frequency select settings when using 'separate
>> + *          reference clocks' for SS and HS operations
>> + * @rate: rate of reference clock to PHY block
>> + * @channel: number of PHY channels present in SoC
>> + */
>> +struct exynos5_usb3phy_driver {
>> +     struct device *dev;
>> +     void __iomem *reg_phy;
>> +     struct clk *clk;
>> +     struct clk *usb30_sclk;
>> +     const struct exynos5_usb3phy_drv_data *drv_data;
>> +     struct phy_usb_instance {
>> +             struct phy *phy;
>> +             u32 index;
>> +             struct regmap *reg_isol;
>> +             const struct usb3phy_config *phy_cfg;
>> +     } phys[EXYNOS5_USB3PHYS_NUM];
>> +     u32 extrefclk;
>> +     unsigned long rate;
>> +     u32 channel;
>> +};
>> +
>> +#define to_usb3phy_driver(inst) \
>> +     container_of((inst), struct exynos5_usb3phy_driver, \
>> +                  phys[(inst)->index]);
>> +
>> +/*
>> + * exynos5_rate_to_clk() converts the supplied clock rate to the value that
>> + * can be written to the phy register.
>> + */
>> +static u32 exynos5_rate_to_clk(unsigned long rate)
>> +{
>> +     unsigned int clksel;
>> +
>> +     /* EXYNOS5_FSEL_MASK */
>> +
>> +     switch (rate) {
>> +     case 9600 * KHZ:
>> +             clksel = EXYNOS5_FSEL_9MHZ6;
>> +             break;
>> +     case 10 * MHZ:
>> +             clksel = EXYNOS5_FSEL_10MHZ;
>> +             break;
>> +     case 12 * MHZ:
>> +             clksel = EXYNOS5_FSEL_12MHZ;
>> +             break;
>> +     case 19200 * KHZ:
>> +             clksel = EXYNOS5_FSEL_19MHZ2;
>> +             break;
>> +     case 20 * MHZ:
>> +             clksel = EXYNOS5_FSEL_20MHZ;
>> +             break;
>> +     case 24 * MHZ:
>> +             clksel = EXYNOS5_FSEL_24MHZ;
>> +             break;
>> +     case 50 * MHZ:
>> +             clksel = EXYNOS5_FSEL_50MHZ;
>> +             break;
>> +     default:
>> +             clksel = -EINVAL;
>> +     }
>> +
>> +     return clksel;
>> +}
>> +
>> +static void exynos5_usb3phy_isol(struct phy *phy, unsigned int on)
>> +{
>> +     u32 pmu_offset;
>> +     struct phy_usb_instance *inst = phy_get_drvdata(phy);
>> +     struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
>> +
>> +     pmu_offset = inst->phy_cfg->reg_pmu_offset;
>> +     if (!inst->reg_isol)
>> +             return;
>> +
>> +     switch (drv->channel) {
>> +     case 1:
>> +             /* Channel 1 is at 0x708 offset */
>> +             pmu_offset += sizeof(&pmu_offset);
>> +             break;
>> +     case 0:
>> +     default:
>> +             /* Channel 0 is at 0x704 offset */
>> +             break;
>> +     }
>
> This can be in a simple 'if' stmt no?
What if there are systems with more channels? In that case also we
will have to fall back to a switch-case statement ?

>> +
>> +     regmap_update_bits(inst->reg_isol, pmu_offset,
>> +                        EXYNOS5_USB3DRD_PMU_ISOL, ~on);
>> +}
>> +
>> +/*
>> + * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
>> + */
>> +static u32 exynos5_usb3phy_set_refclk(struct exynos5_usb3phy_driver *drv)
>> +{
>> +     u32 reg;
>> +
>> +     reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
>> +           PHYCLKRST_FSEL(drv->extrefclk);
>> +
>> +     switch (drv->extrefclk) {
>> +     case EXYNOS5_FSEL_50MHZ:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>> +             break;
>> +     case EXYNOS5_FSEL_24MHZ:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>> +             break;
>> +     case EXYNOS5_FSEL_20MHZ:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>> +             break;
>> +     case EXYNOS5_FSEL_19MHZ2:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>> +             break;
>> +     default:
>> +             dev_dbg(drv->dev, "unsupported ref clk\n");
>> +             break;
>> +     }
>> +
>> +     return reg;
>> +}
>> +
>> +static int exynos5_usb3phy_init(struct phy *phy)
>> +{
>> +     int ret;
>> +     u32 phyparam0;
>> +     u32 phyparam1;
>> +     u32 linksystem;
>> +     u32 phybatchg;
>> +     u32 phytest;
>> +     u32 phyclkrst;
>
> instead you can define a single variable 'u32 reg' for register read and writes.

Right.

>> +     struct phy_usb_instance *inst = phy_get_drvdata(phy);
>> +     struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
>> +
>> +     ret = clk_prepare_enable(drv->clk);
>> +     if (ret)
>> +             return ret;
>> +
>> +     drv->extrefclk = exynos5_rate_to_clk(drv->rate);
>> +     if (drv->extrefclk == -EINVAL) {
>> +             dev_err(drv->dev, "Clock rate (%ld) not supported\n",
>> +                                             drv->rate);
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* Reset USB 3.0 PHY */
>> +     writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
>> +
>> +     phyparam0 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
>> +     /* Select PHY CLK source */
>> +     phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
>> +     /* Set Loss-of-Signal Detector sensitivity */
>> +     phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
>> +     phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
>> +     writel(phyparam0, drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
>> +
>> +     writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYRESUME);
>> +
>> +     /*
>> +      * Setting the Frame length Adj value[6:1] to default 0x20
>> +      * See xHCI 1.0 spec, 5.2.4
>> +      */
>> +     linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
>> +                  LINKSYSTEM_FLADJ(0x20);
>> +     writel(linksystem, drv->reg_phy + EXYNOS5_DRD_LINKSYSTEM);
>> +
>> +     phyparam1 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
>> +     /* Set Tx De-Emphasis level */
>> +     phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
>> +     phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
>> +     writel(phyparam1, drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
>> +
>> +     phybatchg = readl(drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
>> +     phybatchg |= PHYBATCHG_UTMI_CLKSEL;
>> +     writel(phybatchg, drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
>> +
>> +     /* PHYTEST POWERDOWN Control */
>> +     phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
>> +     phytest &= ~(PHYTEST_POWERDOWN_SSP |
>> +                  PHYTEST_POWERDOWN_HSP);
>> +     writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
>> +
>> +     /* UTMI Power Control */
>> +     writel(PHYUTMI_OTGDISABLE, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
>
> All these UTMI configuration should be done in usb2 init.
Ok, will move this to separate function.

>> +
>> +     phyclkrst = exynos5_usb3phy_set_refclk(drv);
>> +
>> +     phyclkrst |= PHYCLKRST_PORTRESET |
>> +                  /* Digital power supply in normal operating mode */
>> +                  PHYCLKRST_RETENABLEN |
>> +                  /* Enable ref clock for SS function */
>> +                  PHYCLKRST_REF_SSP_EN |
>> +                  /* Enable spread spectrum */
>> +                  PHYCLKRST_SSC_EN |
>> +                  /* Power down HS Bias and PLL blocks in suspend mode */
>> +                  PHYCLKRST_COMMONONN;
>> +
>> +     writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +     udelay(10);
>> +
>> +     phyclkrst &= ~PHYCLKRST_PORTRESET;
>> +     writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +     clk_disable_unprepare(drv->clk);
>> +
>> +     return 0;
>> +}
>> +
>> +static int exynos5_usb3phy_exit(struct phy *phy)
>> +{
>> +     int ret;
>> +     u32 phyutmi;
>> +     u32 phyclkrst;
>> +     u32 phytest;
>
> same here..
right, will do it.

>> +     struct phy_usb_instance *inst = phy_get_drvdata(phy);
>> +     struct exynos5_usb3phy_driver *drv = to_usb3phy_driver(inst);
>> +
>> +     ret = clk_prepare_enable(drv->clk);
>> +     if (ret)
>> +             return ret;
>> +
>> +     phyutmi = PHYUTMI_OTGDISABLE |
>> +               PHYUTMI_FORCESUSPEND |
>> +               PHYUTMI_FORCESLEEP;
>> +     writel(phyutmi, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
>
> here too.. UTMI configuration should be part of USB2.
ok.

>> +
[snip]

>> +
>> +static struct phy_ops exynos5_usb3phy_ops = {
>> +     .init           = exynos5_usb3phy_init,
>> +     .exit           = exynos5_usb3phy_exit,
>> +     .power_on       = exynos5_usb3phy_power_on,
>> +     .power_off      = exynos5_usb3phy_power_off,
>> +     .owner          = THIS_MODULE,
>> +};
>> +
>> +const struct usb3phy_config exynos5_usb3phy_cfg[] = {
>> +     {
>> +             .id             = EXYNOS5_USB3PHY_UTMI,
>
> This should be USB2 no?
Actually the thought was to have similar naming for enums.
EXYNOS5_USB3PHY_UTMI
EXYNOS5_USB3PHY_PIPE3

Since the entire driver was going that way.
But will change these to a more common name
EXYNOS5_DRDPHY_UTMI
EXYNOS5_DRDPHY_PIPE3,
in the same fashion the register names are defined.
Will that be fine ?

>> +             .reg_pmu_offset = EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
>> +             .phy_isol       = exynos5_usb3phy_isol,
>> +     },
>> +     {
>> +             .id             = EXYNOS5_USB3PHY_PIPE3,
>> +             .reg_pmu_offset = EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
>> +             .phy_isol       = exynos5_usb3phy_isol,
>> +     },
>> +     {},
>> +};
>> +
>> +const struct exynos5_usb3phy_drv_data exynos5420_usb3phy = {
>> +     .has_usb30_sclk         = true,
>> +     .has_multi_controller   = true,
>> +     .phy_cfg                = exynos5_usb3phy_cfg,
>> +};
>> +
>> +const struct exynos5_usb3phy_drv_data exynos5250_usb3phy = {
>> +     .has_usb30_sclk         = false,
>> +     .has_multi_controller   = false,
>> +     .phy_cfg                = exynos5_usb3phy_cfg,
>> +};
>> +
>> +static const struct of_device_id exynos5_usb3phy_of_match[] = {
>> +     {
>> +             .compatible = "samsung,exynos5250-usb3phy",
>> +             .data = &exynos5250_usb3phy
>> +     }, {
>> +             .compatible = "samsung,exynos5420-usb3phy",
>> +             .data = &exynos5420_usb3phy
>> +     },
>> +     { },
>> +};
>> +
>> +static int exynos5_usb3phy_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct device_node *node = dev->of_node;
>> +     struct exynos5_usb3phy_driver *drv;
>> +     struct phy_provider *phy_provider;
>> +     struct resource *res;
>> +     struct clk *clk;
>> +     const struct of_device_id *match;
>> +     const struct exynos5_usb3phy_drv_data *drv_data;
>> +     struct regmap *reg_isol;
>> +     int i;
>> +
>> +     /*
>> +      * Exynos systems are completely DT enabled,
>> +      * so lets not have any platform data support for this driver.
>> +      */
>
> Then you should add depend on OF for this driver.
Right. depends on CONFIG_OF. Will add one.

>> +     if (!node) {
>> +             dev_err(dev, "no device node found\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     match = of_match_node(exynos5_usb3phy_of_match, pdev->dev.of_node);
>> +     if (!match) {
>> +             dev_err(dev, "of_match_node() failed\n");
>> +             return -EINVAL;
>> +     }
>> +     drv_data = match->data;
>> +
>> +     drv = devm_kzalloc(dev, sizeof(*drv), GFP_KERNEL);
>> +     if (!drv) {
>> +             dev_err(dev, "Failed to allocate memory\n");
>
> dev_err is not needed here.

Right, will remove it.

>> +             return -ENOMEM;
>> +     }
>> +
[snip]

>> +     dev_dbg(dev, "Creating usb3drd phy\n");
> dev_vdbg?

Sure.

>
> Cheers
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
