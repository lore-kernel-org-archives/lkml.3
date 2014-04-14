Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaDNLzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:55:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33391 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbaDNLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:55:28 -0400
Message-ID: <534BCC91.8090108@ti.com>
Date: Mon, 14 Apr 2014 17:24:57 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <k.debski@samsung.com>, <jg1.han@samsung.com>,
        <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com> <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com> <534529B2.2020107@samsung.com>
In-Reply-To: <534529B2.2020107@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 09 April 2014 04:36 PM, Tomasz Figa wrote:
> Hi Vivek,
> 
> Please see my comments inline.
> 
> On 08.04.2014 16:36, Vivek Gautam wrote:
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
>>   drivers/phy/phy-exynos5-usbdrd.c                   |  668 ++++++++++++++++++++
>>   4 files changed, 722 insertions(+)
>>   create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
> 
> [snip]
> 
>> +    Additional clock required for Exynos5420:
>> +    - usb30_sclk_100m: Additional special clock used for PHY operation
>> +               depicted as 'sclk_usbphy30' in CMU of Exynos5420.
> 
> Are you sure this isn't simply a gate for the ref clock, as it can be found on
> another SoC that is not upstream yet? I don't have documentation for Exynos
> 5420 so I can't tell, but I'd like to ask you to recheck this.
> 
>> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
>> +              control pmu registers for power isolation.
>> +- samsung,pmu-offset: phy power control register offset to
>> pmu-system-controller
>> +              base.
>> +- #phy-cells : from the generic PHY bindings, must be 1;
>> +
>> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
>> +compatible PHYs, the second cell in the PHY specifier identifies the
>> +PHY id, which is interpreted as follows:
>> +  0 - UTMI+ type phy,
>> +  1 - PIPE3 type phy,
>> +
>> +Example:
>> +    usb3_phy: usbphy@12100000 {
>> +        compatible = "samsung,exynos5250-usbdrd-phy";
>> +        reg = <0x12100000 0x100>;
>> +        clocks = <&clock 286>, <&clock 1>;
>> +        clock-names = "phy", "usb3phy_refclk";
> 
> Binding description above doesn't mention "usb3phy_refclk" entry.
> 
>> +        samsung,syscon-phandle = <&pmu_syscon>;
>> +        samsung,pmu-offset = <0x704>;
>> +        #phy-cells = <1>;
>> +    };
> 
> [snip]
> 
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
>> new file mode 100644
>> index 0000000..ff54a7c
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> 
> [snip]
> 
>> +static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
>> +{
>> +    struct device *dev = &pdev->dev;
>> +    struct device_node *node = dev->of_node;
>> +    struct exynos5_usbdrd_phy *phy_drd;
>> +    struct phy_provider *phy_provider;
>> +    struct resource *res;
>> +    const struct of_device_id *match;
>> +    const struct exynos5_usbdrd_phy_drvdata *drv_data;
>> +    struct regmap *reg_pmu;
>> +    u32 pmu_offset;
>> +    int i;
>> +
>> +    /*
>> +     * Exynos systems are completely DT enabled,
>> +     * so lets not have any platform data support for this driver.
>> +     */
>> +    if (!node) {
>> +        dev_err(dev, "no device node found\n");
> 
> This error message is not very meaningful. I'd rather use something like "This
> driver can be only instantiated using Device Tree".

how about just adding depend_on OF in Kconfig?

Thanks
Kishon
