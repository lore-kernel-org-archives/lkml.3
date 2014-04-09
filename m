Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaDILt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:49:57 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63665 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDILtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <534529B2.2020107@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
	<534529B2.2020107@samsung.com>
Date: Wed, 9 Apr 2014 17:19:52 +0530
X-Google-Sender-Auth: gBwduc-eYc9G3YbMYB-OLWNGW6I
Message-ID: <CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Apr 9, 2014 at 4:36 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Vivek,
>
> Please see my comments inline.
>
>
> On 08.04.2014 16:36, Vivek Gautam wrote:
>>
>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> The new driver uses the generic PHY framework and will interact
>> with DWC3 controller present on Exynos5 series of SoCs.
>> Thereby, removing old phy-samsung-usb3 driver and related code
>> used untill now which was based on usb/phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>   .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>>   drivers/phy/Kconfig                                |   11 +
>>   drivers/phy/Makefile                               |    1 +
>>   drivers/phy/phy-exynos5-usbdrd.c                   |  668
>> ++++++++++++++++++++
>>   4 files changed, 722 insertions(+)
>>   create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>
>
> [snip]
>
>
>> +       Additional clock required for Exynos5420:
>> +       - usb30_sclk_100m: Additional special clock used for PHY operation
>> +                          depicted as 'sclk_usbphy30' in CMU of
>> Exynos5420.
>
>
> Are you sure this isn't simply a gate for the ref clock, as it can be found
> on another SoC that is not upstream yet? I don't have documentation for
> Exynos 5420 so I can't tell, but I'd like to ask you to recheck this.

>From what i can see in the manual :
sclk_usbphy30 is derived from OSCCLK.
It is coming from a MUX (default input line to this is OSCCLK)  and
then through a DIV
there's this gate.

      {OSCCLK  + other sources} --->[MUX] ---> [DIV] --> [GATE for
sclk_usbphy30]

the {rate of sclk_usbphy30} == OSCCLK

However the 'ref' clock that we have been using is the actual oscillator clock.
And on SoC Exynos5250, we don't have any such gate (sclk_usbphy30).
So should this mean that ref clock and sclk_usbphy30 are still be controlled by
two different gates ?

>
>
>> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
>> +                         control pmu registers for power isolation.
>> +- samsung,pmu-offset: phy power control register offset to
>> pmu-system-controller
>> +                     base.
>> +- #phy-cells : from the generic PHY bindings, must be 1;
>> +
>> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
>> +compatible PHYs, the second cell in the PHY specifier identifies the
>> +PHY id, which is interpreted as follows:
>> +  0 - UTMI+ type phy,
>> +  1 - PIPE3 type phy,
>> +
>> +Example:
>> +       usb3_phy: usbphy@12100000 {
>> +               compatible = "samsung,exynos5250-usbdrd-phy";
>> +               reg = <0x12100000 0x100>;
>> +               clocks = <&clock 286>, <&clock 1>;
>> +               clock-names = "phy", "usb3phy_refclk";
>
>
> Binding description above doesn't mention "usb3phy_refclk" entry.

my bad !! will correct this.

>
>
>> +               samsung,syscon-phandle = <&pmu_syscon>;
>> +               samsung,pmu-offset = <0x704>;
>> +               #phy-cells = <1>;
>> +       };
>
>
> [snip]
>
>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c
>> b/drivers/phy/phy-exynos5-usbdrd.c
>> new file mode 100644
>> index 0000000..ff54a7c
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>
>
> [snip]
>
>
>> +static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct device_node *node = dev->of_node;
>> +       struct exynos5_usbdrd_phy *phy_drd;
>> +       struct phy_provider *phy_provider;
>> +       struct resource *res;
>> +       const struct of_device_id *match;
>> +       const struct exynos5_usbdrd_phy_drvdata *drv_data;
>> +       struct regmap *reg_pmu;
>> +       u32 pmu_offset;
>> +       int i;
>> +
>> +       /*
>> +        * Exynos systems are completely DT enabled,
>> +        * so lets not have any platform data support for this driver.
>> +        */
>> +       if (!node) {
>> +               dev_err(dev, "no device node found\n");
>
>
> This error message is not very meaningful. I'd rather use something like
> "This driver can be only instantiated using Device Tree".

Sure, will amend this.

>
>
>> +               return -ENODEV;
>> +       }
>> +
>> +       match = of_match_node(exynos5_usbdrd_phy_of_match,
>> pdev->dev.of_node);
>> +       if (!match) {
>> +               dev_err(dev, "of_match_node() failed\n");
>> +               return -EINVAL;
>> +       }
>> +       drv_data = match->data;
>> +
>> +       phy_drd = devm_kzalloc(dev, sizeof(*phy_drd), GFP_KERNEL);
>> +       if (!phy_drd)
>> +               return -ENOMEM;
>> +
>> +       dev_set_drvdata(dev, phy_drd);
>> +       phy_drd->dev = dev;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       phy_drd->reg_phy = devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(phy_drd->reg_phy)) {
>> +               dev_err(dev, "Failed to map register memory (phy)\n");
>
>
> devm_ioremap_resource() already prints an error message.
Ok, will remove this message.

>
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
