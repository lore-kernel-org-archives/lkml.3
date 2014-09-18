Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbaIRD0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:26:01 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:52788 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbaIRDZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <5419BCC9.6000607@ti.com>
References: <1410840408-19954-1-git-send-email-gautam.vivek@samsung.com>
	<1410843726-4235-1-git-send-email-gautam.vivek@samsung.com>
	<5419BCC9.6000607@ti.com>
Date: Thu, 18 Sep 2014 08:55:58 +0530
X-Google-Sender-Auth: YiwXSfuUWESqn9GMoZMxTPejfpU
Message-ID: <CAFp+6iGNNygVrpQFaEao+aGAad=vgb6EDpJqRj8cA+5XSC8ZSg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: exynos-dp-video: Use syscon support to
 control pmu register
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        inki.dae@samsung.com, Sean Paul <seanpaul@google.com>,
        Jingoo Han <jg1.han@samsung.com>, ajaykumar.rs@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On Wed, Sep 17, 2014 at 10:24 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
>
> On Tuesday 16 September 2014 10:32 AM, Vivek Gautam wrote:
>> Currently the DP_PHY_ENABLE register is mapped in the driver,
>> and accessed to control power to the PHY.
>> With mfd-syscon and regmap interface available at our disposal,
>> it's wise to use that instead of using a 'reg' property for the
>> controller and allocating a memory resource for that.
>>
>> To facilitate this, we have added another compatible string
>> for Exynso5420 SoC to acquire driver data which contains
>> different DP-PHY-CONTROL register offset.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>
> Taking this in linux-phy tree. If someone has already taken this patch, please
> let me know.

Thanks for taking this. But just one check, i think i need to separate
out the Documentation
to a separate patch even before this driver patch. Isn't it ?

>
> Thanks
> Kishon
>
>> ---
>>
>> Changes since v2:
>>  - Using 'EXYNOS5_PHY_ENABLE' macro instead of 'EXYNOS_DPTX_PHY_ENABLE'
>>    since that's available with us in "linux/mfd/syscon/exynos5-pmu.h" file.
>>
>> Changes since v1:
>>  - state->regs should have been "struct regmap *" instead of
>>    "void __iomem *". So corrected the same.
>>
>>  .../devicetree/bindings/phy/samsung-phy.txt        |    7 +-
>>  drivers/phy/phy-exynos-dp-video.c                  |   79 +++++++++++++-------
>>  2 files changed, 59 insertions(+), 27 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index 7a6feea..15e0f2c 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -17,8 +17,11 @@ Samsung EXYNOS SoC series Display Port PHY
>>  -------------------------------------------------
>>
>>  Required properties:
>> -- compatible : should be "samsung,exynos5250-dp-video-phy";
>> -- reg : offset and length of the Display Port PHY register set;
>> +- compatible : should be one of the following supported values:
>> +      - "samsung,exynos5250-dp-video-phy"
>> +      - "samsung,exynos5420-dp-video-phy"
>> +- samsung,pmu-syscon: phandle for PMU system controller interface, used to
>> +                   control pmu registers for power isolation.
>>  - #phy-cells : from the generic PHY bindings, must be 0;
>>
>>  Samsung S5P/EXYNOS SoC series USB PHY
>> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
>> index 8b3026e..53f44a0 100644
>> --- a/drivers/phy/phy-exynos-dp-video.c
>> +++ b/drivers/phy/phy-exynos-dp-video.c
>> @@ -13,44 +13,55 @@
>>  #include <linux/io.h>
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/mfd/syscon/exynos5-pmu.h>
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>>  #include <linux/phy/phy.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>>
>> -/* DPTX_PHY_CONTROL register */
>> -#define EXYNOS_DPTX_PHY_ENABLE               (1 << 0)
>> +struct exynos_dp_video_phy_drvdata {
>> +     u32 phy_ctrl_offset;
>> +};
>>
>>  struct exynos_dp_video_phy {
>> -     void __iomem *regs;
>> +     struct regmap *regs;
>> +     const struct exynos_dp_video_phy_drvdata *drvdata;
>>  };
>>
>> -static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
>> +static void exynos_dp_video_phy_pwr_isol(struct exynos_dp_video_phy *state,
>> +                                                     unsigned int on)
>>  {
>> -     u32 reg;
>> +     unsigned int val;
>> +
>> +     if (IS_ERR(state->regs))
>> +             return;
>>
>> -     reg = readl(state->regs);
>> -     if (on)
>> -             reg |= EXYNOS_DPTX_PHY_ENABLE;
>> -     else
>> -             reg &= ~EXYNOS_DPTX_PHY_ENABLE;
>> -     writel(reg, state->regs);
>> +     val = on ? 0 : EXYNOS5_PHY_ENABLE;
>>
>> -     return 0;
>> +     regmap_update_bits(state->regs, state->drvdata->phy_ctrl_offset,
>> +                        EXYNOS5_PHY_ENABLE, val);
>>  }
>>
>>  static int exynos_dp_video_phy_power_on(struct phy *phy)
>>  {
>>       struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
>>
>> -     return __set_phy_state(state, 1);
>> +     /* Disable power isolation on DP-PHY */
>> +     exynos_dp_video_phy_pwr_isol(state, 0);
>> +
>> +     return 0;
>>  }
>>
>>  static int exynos_dp_video_phy_power_off(struct phy *phy)
>>  {
>>       struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
>>
>> -     return __set_phy_state(state, 0);
>> +     /* Enable power isolation on DP-PHY */
>> +     exynos_dp_video_phy_pwr_isol(state, 1);
>> +
>> +     return 0;
>>  }
>>
>>  static struct phy_ops exynos_dp_video_phy_ops = {
>> @@ -59,11 +70,31 @@ static struct phy_ops exynos_dp_video_phy_ops = {
>>       .owner          = THIS_MODULE,
>>  };
>>
>> +static const struct exynos_dp_video_phy_drvdata exynos5250_dp_video_phy = {
>> +     .phy_ctrl_offset        = EXYNOS5_DPTX_PHY_CONTROL,
>> +};
>> +
>> +static const struct exynos_dp_video_phy_drvdata exynos5420_dp_video_phy = {
>> +     .phy_ctrl_offset        = EXYNOS5420_DPTX_PHY_CONTROL,
>> +};
>> +
>> +static const struct of_device_id exynos_dp_video_phy_of_match[] = {
>> +     {
>> +             .compatible = "samsung,exynos5250-dp-video-phy",
>> +             .data = &exynos5250_dp_video_phy,
>> +     }, {
>> +             .compatible = "samsung,exynos5420-dp-video-phy",
>> +             .data = &exynos5420_dp_video_phy,
>> +     },
>> +     { },
>> +};
>> +MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
>> +
>>  static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>>  {
>>       struct exynos_dp_video_phy *state;
>>       struct device *dev = &pdev->dev;
>> -     struct resource *res;
>> +     const struct of_device_id *match;
>>       struct phy_provider *phy_provider;
>>       struct phy *phy;
>>
>> @@ -71,11 +102,15 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>>       if (!state)
>>               return -ENOMEM;
>>
>> -     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -
>> -     state->regs = devm_ioremap_resource(dev, res);
>> -     if (IS_ERR(state->regs))
>> +     state->regs = syscon_regmap_lookup_by_phandle(dev->of_node,
>> +                                                   "samsung,pmu-syscon");
>> +     if (IS_ERR(state->regs)) {
>> +             dev_err(dev, "Failed to lookup PMU regmap\n");
>>               return PTR_ERR(state->regs);
>> +     }
>> +
>> +     match = of_match_node(exynos_dp_video_phy_of_match, dev->of_node);
>> +     state->drvdata = match->data;
>>
>>       phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops, NULL);
>>       if (IS_ERR(phy)) {
>> @@ -89,12 +124,6 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>>       return PTR_ERR_OR_ZERO(phy_provider);
>>  }
>>
>> -static const struct of_device_id exynos_dp_video_phy_of_match[] = {
>> -     { .compatible = "samsung,exynos5250-dp-video-phy" },
>> -     { },
>> -};
>> -MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
>> -
>>  static struct platform_driver exynos_dp_video_phy_driver = {
>>       .probe  = exynos_dp_video_phy_probe,
>>       .driver = {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
