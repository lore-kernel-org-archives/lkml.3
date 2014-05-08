Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaEHGFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:05:19 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55173 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaEHGFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <5368F136.6070804@samsung.com>
References: <1398665874-31238-1-git-send-email-gautam.vivek@samsung.com>
	<5368F136.6070804@samsung.com>
Date: Thu, 8 May 2014 11:35:13 +0530
X-Google-Sender-Auth: 5lnD0dCVmZk7KeSoDjfrCy8dJ4g
Message-ID: <CAFp+6iHN-W-k6ow5YykK_QWgBJ+GgzXwPX6suWtizxwJWOiGtg@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        kishon <kishon@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Tue, May 6, 2014 at 7:57 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 28/04/14 08:17, Vivek Gautam wrote:
>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> The new driver uses the generic PHY framework and will interact
>> with DWC3 controller present on Exynos5 series of SoCs.
>> Thereby, removing old phy-samsung-usb3 driver and related code
>> used untill now which was based on usb/phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Changes from v6:
>>  - Addressed review comments:
>>    -- Sorted config entries in Kconfig and Makefile
>>    -- Made #define to_usbdrd_phy(inst) to a static inline routine.
>>    -- Restructured exynos5_rate_to_clk() as suggested.
>>    -- Amended 'val' field for regmap_update_bits() in the routine
>>       exynos5_usbdrd_phy_isol().
>>    -- Removed sentinel entry from exynos5_usbdrd_phy_cfg[] struct.
>>    -- Removed check for 'match' entry in probe().
>>
>>  .../devicetree/bindings/phy/samsung-phy.txt        |   40 ++
>>  drivers/phy/Kconfig                                |   11 +
>>  drivers/phy/Makefile                               |    1 +
>>  drivers/phy/phy-exynos5-usbdrd.c                   |  627 ++++++++++++++++++++
>>  4 files changed, 679 insertions(+)
>>  create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>>
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index b422e38..51efe4c 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -114,3 +114,43 @@ Example:
>>               compatible = "samsung,exynos-sataphy-i2c";
>>               reg = <0x38>;
>>       };
>> +
>> +Samsung Exynos5 SoC series USB DRD PHY controller
>> +--------------------------------------------------
>> +
>> +Required properties:
>> +- compatible : Should be set to one of the following supported values:
>> +     - "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>> +     - "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>> +- reg : Register offset and length of USB DRD PHY register set;
>> +- clocks: Clock IDs array as required by the controller
>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>> +            Required clocks:
>> +     - phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
>> +            used for register access.
>> +     - ref: PHY's reference clock (usually crystal clock), used for
>> +            PHY operations, associated by phy name. It is used to
>> +            determine bit values for clock settings register.
>> +            For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
>> +- samsung,pmu-syscon: phandle for PMU system controller interface, used to
>> +                   control pmu registers for power isolation.
>> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
>> +                   base.
>
> It doesn't seem right to have register offset encoded in the device tree
> like this. I think it'd be more appropriate to associate such an offset
> with the compatible string's value in the driver.

Ok, it makes more sense.
Just out of curiosity, what difference would this make ?

>
> Also it might be sensible to create a new header file in include/linux/mfd/
> syscon/ for Exynos5 SoCs and put any required PMU offset definitions there.
> Instead having them scattered and possibly duplicated in various drivers.
>
>> +- #phy-cells : from the generic PHY bindings, must be 1;
>> +
>> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
>> +compatible PHYs, the second cell in the PHY specifier identifies the
>> +PHY id, which is interpreted as follows:
>> +  0 - UTMI+ type phy,
>> +  1 - PIPE3 type phy,
>> +
>> +Example:
>> +     usb3_phy: usbphy@12100000 {
>> +             compatible = "samsung,exynos5250-usbdrd-phy";
>> +             reg = <0x12100000 0x100>;
>> +             clocks = <&clock 286>, <&clock 1>;
>> +             clock-names = "phy", "ref";
>> +             samsung,pmu-syscon = <&pmu_system_controller>;
>> +             samsung,pmu-offset = <0x704>;
>> +             #phy-cells = <1>;
>> +     };
> [...]
>> +struct usbdrd_phy_config {
>
> Isn't name of this data structure too generic ?
> Perhaps rename it to exynos_usbdrd_phy_config ?

Sure, will change this name, and thereby change the names of its instances.

>
>> +     u32 id;
>> +     void (*phy_isol)(struct phy_usb_instance *inst, u32 on);
>> +     void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
>> +     unsigned int (*set_refclk)(struct phy_usb_instance *inst);
>> +};
>> +
>> +struct exynos5_usbdrd_phy_drvdata {
>> +     const struct usbdrd_phy_config *phy_cfg;
>> +};
>> +
> [...]
>> +const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
>> +     .phy_cfg                = exynos5_usbdrd_phy_cfg,
>> +};
>> +
>> +const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
>> +     .phy_cfg                = exynos5_usbdrd_phy_cfg,
>> +};
>> +
>> +static const struct of_device_id exynos5_usbdrd_phy_of_match[] = {
>> +     {
>> +             .compatible = "samsung,exynos5250-usbdrd-phy",
>> +             .data = &exynos5250_usbdrd_phy
>> +     }, {
>> +             .compatible = "samsung,exynos5420-usbdrd-phy",
>> +             .data = &exynos5420_usbdrd_phy
>> +     },
>> +     { },
>> +};
>> +
>> +static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
>> +{
> [...]
>> +     reg_pmu = syscon_regmap_lookup_by_phandle(dev->of_node,
>> +                                                "samsung,pmu-syscon");
>> +     if (IS_ERR(reg_pmu)) {
>> +             dev_err(dev, "Failed to map PMU register (via syscon)\n");
>
> nit: Maybe change it to: "Failed to lookup PMU regmap\n" ?

Sure, will change this.

>
>> +             return PTR_ERR(reg_pmu);
>> +     }
>> +
>> +     ret = of_property_read_u32(node, "samsung,pmu-offset", &pmu_offset);
>> +     if (ret) {
>> +             dev_err(dev, "Missing pmu-offset for phy isolation\n");
>> +             return ret;
>> +     }
>
> Otherwise the patch looks good.

Thanks for the review.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
