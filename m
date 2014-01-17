Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaAQLvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:51:05 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48457 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAQLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <52D00C33.4060305@samsung.com>
References: <1389337208-11325-1-git-send-email-yuvaraj.cd@samsung.com>
	<1389337208-11325-2-git-send-email-yuvaraj.cd@samsung.com>
	<52D00C33.4060305@samsung.com>
Date: Fri, 17 Jan 2014 17:20:58 +0530
Message-ID: <CAKuRcOKEvvq7s8EwKq97KL2RY1bX_pVtQvtncoi6VsopdpXafg@mail.gmail.com>
Subject: Re: [PATCH V6 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mark Rutland <mark.rutland@arm.com>, Jingoo Han <jg1.han@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        sunil joshi <joshi@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-ide@vger.kernel.org, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sorry for the late reply.

On Fri, Jan 10, 2014 at 8:35 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Yuvaraj,
>
> In general this version looks pretty good, but I have some questions inline.
Please find my comments inline.
>
> On 10.01.2014 08:00, Yuvaraj Kumar C D wrote:
> [snip]
>
>> diff --git a/drivers/phy/phy-exynos5250-sata-i2c.c
>> b/drivers/phy/phy-exynos5250-sata-i2c.c
>> new file mode 100644
>> index 0000000..206e337
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5250-sata-i2c.c
>> @@ -0,0 +1,40 @@
>> +/*
>> + * Copyright (C) 2013 Samsung Electronics Co.Ltd
>> + * Author:
>> + *     Yuvaraj C D <yuvaraj.cd@samsung.com>
>> + *
>> + * This program is free software; you can redistribute  it and/or modify
>> it
>> + * under  the terms of  the GNU General  Public License as published by
>> the
>> + * Free Software Foundation;  either version 2 of the  License, or (at
>> your
>> + * option) any later version.
>> + *
>> + */
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +
>> +static int exynos_sata_i2c_probe(struct i2c_client *client,
>> +               const struct i2c_device_id *i2c_id)
>> +{
>> +       return 0;
>> +}
>> +
>> +static const struct i2c_device_id sataphy_i2c_device_match[] = {
>> +       { "exynos-sataphy-i2c", 0 },
>> +};
>> +
>> +static struct i2c_driver sataphy_i2c_driver = {
>> +       .probe          = exynos_sata_i2c_probe,
>> +       .id_table       = sataphy_i2c_device_match,
>> +       .driver   = {
>> +               .name = "exynos-sataphy-i2c",
>> +               .owner = THIS_MODULE,
>> +       },
>> +};
>> +
>> +static int __init exynos5250_phy_i2c_init(void)
>> +{
>> +       return i2c_add_driver(&sataphy_i2c_driver);
>> +}
>> +module_init(exynos5250_phy_i2c_init);
>
>
> Hmm, is this driver even necessary now?
Yes.It will not necessary now with of_find_i2c_device_by_node.I will
remove phy-exynos5250-sata-i2c.c
>
> Wolfram, would it be possible to use an i2c_client without a driver bound to
> it?
>
>
>> diff --git a/drivers/phy/phy-exynos5250-sata.c
>> b/drivers/phy/phy-exynos5250-sata.c
>> new file mode 100644
>> index 0000000..6e5ff8d
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5250-sata.c
>> @@ -0,0 +1,238 @@
>> +/*
>> + * Samsung SATA SerDes(PHY) driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Authors: Girish K S <ks.giri@samsung.com>
>> + *         Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/i2c.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/mfd/syscon.h>
>> +
>> +#define EXYNOS5_SATA_RESET             0x4
>> +#define RESET_CMN_RST_N                        (1 << 1)
>> +#define LINK_RESET                     0xF0000
>
>
> nit: Lowercase is preferred in hexadecimal notation.
> + all other occurrences in this file.
Ok.
>
>
>> +#define EXYNOS5_SATA_MODE0             0x10
>> +#define EXYNOS5_SATAPHY_PMU_ENABLE     (1 << 0)
>> +#define SATA_SPD_GEN3                  (2 << 0)
>> +#define EXYNOS5_SATA_CTRL0             0x14
>> +#define CTRL0_P0_PHY_CALIBRATED_SEL    (1 << 9)
>> +#define CTRL0_P0_PHY_CALIBRATED                (1 << 8)
>> +#define EXYNOS5_SATA_PHSATA_CTRLM      0xE0
>> +#define PHCTRLM_REF_RATE               (1 << 1)
>> +#define PHCTRLM_HIGH_SPEED             (1 << 0)
>> +#define EXYNOS5_SATA_PHSATA_STATM      0xF0
>> +#define PHSTATM_PLL_LOCKED             (1 << 0)
>> +#define EXYNOS_SATA_PHY_EN             (1 << 0)
>> +#define SATAPHY_CONTROL_OFFSET         0x0724
>> +
>> +struct exynos_sata_phy {
>> +       struct phy *phy;
>> +       struct clk *phyclk;
>> +       void __iomem *regs;
>> +       void __iomem *pmureg;
>> +       struct i2c_client *client;
>> +};
>> +
>> +static bool wait_for_reg_status(void __iomem *base, u32 reg, u32
>> checkbit,
>> +                               u32 status)
>> +{
>> +       unsigned long timeout = jiffies + usecs_to_jiffies(1000);
>
>
> nit: It would be better to define the timeout using a macro to not use magic
> numbers.
Ok
>
>
>> +
>> +       while (time_before(jiffies, timeout)) {
>> +               if ((readl(base + reg) & checkbit) == status)
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
>> +static int exynos_sata_phy_power_on(struct phy *phy)
>> +{
>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>> +
>> +       regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
>
>
> regmap_update_bits can return an error. Wouldn't it be better to return it
> as return value of this function instead of returning 0 all the time? As a
> side effect, this would make the function smaller by two lines.
Yes.Will incorporate in next version.
>
>
>> +
>> +       return 0;
>> +}
>> +
>> +static int exynos_sata_phy_power_off(struct phy *phy)
>> +{
>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>> +
>> +       regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, ~EXYNOS_SATA_PHY_EN);
>
>
> Same here.
Yes.Will incorporate in next version.
>
>
>> +
>> +       return 0;
>> +}
>> +
>> +static int exynos_sata_phy_init(struct phy *phy)
>> +{
>> +       u32 val = 0;
>> +       int ret = 0;
>> +       u8 buf[] = { 0x3A, 0x0B };
>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>> +
>> +       regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
>
>
> regmap_update_bits returns an error code.
Yes.Will incorporate in next version.
>
>
>> +
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>> +       val |= 0xFF;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>> +       val |= LINK_RESET;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>> +       val |= RESET_CMN_RST_N;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>> +       val &= ~PHCTRLM_REF_RATE;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>> +
>> +       /* High speed enable for Gen3 */
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>> +       val |= PHCTRLM_HIGH_SPEED;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_CTRL0);
>> +       val |= CTRL0_P0_PHY_CALIBRATED_SEL | CTRL0_P0_PHY_CALIBRATED;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_CTRL0);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_MODE0);
>> +       val |= SATA_SPD_GEN3;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_MODE0);
>> +
>> +       ret = i2c_master_send(sata_phy->client, buf, sizeof(buf));
>> +       if (ret < 0)
>> +               return -ENXIO;
>
>
> Wouldn't it be better to return the same error code as i2c_master_send
> returned?
Yes.Will incorporate in next version.
>
>
>> +
>> +       /* release cmu reset */
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>> +       val &= ~RESET_CMN_RST_N;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>> +       val |= RESET_CMN_RST_N;
>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>> +
>> +       return (wait_for_reg_status(sata_phy->regs,
>> EXYNOS5_SATA_PHSATA_STATM,
>> +               PHSTATM_PLL_LOCKED, 1)) ? 0 : -EINVAL;
>> +
>
>
> nit: Stray blank line.
Ok.will remove
>
> Also it might be more readable after making wait_for_reg_status() return an
> integer error code (0 and e.g. -EFAULT) and rewriting the last line to:
>
>         ret = wait_for_reg_status(sata_phy->regs,
>                                         EXYNOS5_SATA_PHSATA_STATM,
>                                         PHSTATM_PLL_LOCKED, 1);
>         if (ret < 0)
>                 dev_err(&sata_phy->client->dev,
>                         "PHY PLL locking failed\n");
>
>         return ret;
>
Ok.
> By the way, isn't this initialization really needed whenever the PHY is
> powered on?
In Exynos5250, we do require to power on the phy before writing
anything into phy controller register space.
As you know,phy_ops have separate callbacks power_on and init .So I
just used those to separate these functionalities.
>
>
>> +}
>> +
>> +static struct phy_ops exynos_sata_phy_ops = {
>> +       .init           = exynos_sata_phy_init,
>> +       .power_on       = exynos_sata_phy_power_on,
>> +       .power_off      = exynos_sata_phy_power_off,
>> +       .owner          = THIS_MODULE,
>> +};
>> +
>> +static int exynos_sata_phy_probe(struct platform_device *pdev)
>> +{
>> +       struct exynos_sata_phy *sata_phy;
>> +       struct device *dev = &pdev->dev;
>> +       struct resource *res;
>> +       struct phy_provider *phy_provider;
>> +       struct device_node *node;
>> +       int ret = 0;
>> +
>> +       sata_phy = devm_kzalloc(dev, sizeof(*sata_phy), GFP_KERNEL);
>> +       if (!sata_phy)
>> +               return -ENOMEM;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +       sata_phy->regs = devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(sata_phy->regs))
>> +               return PTR_ERR(sata_phy->regs);
>> +
>> +       sata_phy->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
>> +                                       "samsung,syscon-phandle");
>
>
> pmureg is defined as (void __iomem *) in struct exynos_sata_phy, but
> syscon_regmap_lookup_by_phandle() returns (struct regmap *). Moreover it
> does not return NULL on error, but rather ERR_PTR(). Please correct this.
Ohh!my mistake.Will correct in next version.
>
>
>> +       if (!sata_phy->pmureg) {
>> +               dev_err(dev, "syscon regmap lookup failed.\n");
>> +               return PTR_ERR(sata_phy->pmureg);
>> +       }
>> +
>> +       node = of_parse_phandle(dev->of_node,
>> +                       "samsung,exynos-sataphy-i2c-phandle", 0);
>> +       if (!node)
>> +               return -ENODEV;
>
>
> An error here means that a required DT property was not specified or was
> specified incorrectly. IMHO -EINVAL would be better here.
ok
>
>
>> +
>> +       sata_phy->client = of_find_i2c_device_by_node(node);
>> +       if (!sata_phy->client)
>> +               return -EPROBE_DEFER;
>> +
>> +       dev_set_drvdata(dev, sata_phy);
>> +
>> +       sata_phy->phyclk = devm_clk_get(dev, "sata_phyctrl");
>> +       if (IS_ERR(sata_phy->phyclk)) {
>> +               dev_err(dev, "failed to get clk for PHY\n");
>> +               return PTR_ERR(sata_phy->phyclk);
>> +       }
>> +
>> +       ret = clk_prepare_enable(sata_phy->phyclk);
>> +       if (ret < 0) {
>> +               dev_err(dev, "failed to enable source clk\n");
>> +               return ret;
>> +       }
>> +
>> +       sata_phy->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
>> +       if (IS_ERR(sata_phy->phy)) {
>> +               clk_disable_unprepare(sata_phy->phyclk);
>> +               dev_err(dev, "failed to create PHY\n");
>> +               return PTR_ERR(sata_phy->phy);
>> +       }
>> +
>> +       phy_set_drvdata(sata_phy->phy, sata_phy);
>> +
>> +       phy_provider = devm_of_phy_provider_register(dev,
>> +                                       of_phy_simple_xlate);
>> +       if (IS_ERR(phy_provider)) {
>> +               clk_disable_unprepare(sata_phy->phyclk);
>> +               return PTR_ERR(phy_provider);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id exynos_sata_phy_of_match[] = {
>> +       { .compatible = "samsung,exynos5250-sata-phy" },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, exynos_sata_phy_of_match);
>> +
>> +static struct platform_driver exynos_sata_phy_driver = {
>> +       .probe  = exynos_sata_phy_probe,
>
>
> If this driver can be compiled as module, don't you also need remove?
Will add in next version.
>
> Best regards,
> Tomasz
