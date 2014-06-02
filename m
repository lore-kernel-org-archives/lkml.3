Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaFBO2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:28:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35279 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaFBO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:28:43 -0400
Message-ID: <538C89F5.1010605@ti.com>
Date: Mon, 2 Jun 2014 10:28:05 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-4-git-send-email-m-karicheri2@ti.com> <538C16DB.7060002@ti.com>
In-Reply-To: <538C16DB.7060002@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2014 2:16 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>
> On Thursday 15 May 2014 09:31 PM, Murali Karicheri wrote:
>> This phy driver is used by keystone PCI driver. The hw vendor that
>> provides the phy hw published only registers and their values. So
>> this driver uses these hard coded values to initialize the phy.
>>
>> CC: Grant Likely <grant.likely@linaro.org>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Mohit Kumar <mohit.kumar@st.com>
>> CC: Jingoo Han <jg1.han@samsung.com>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   drivers/phy/Kconfig        |    6 ++
>>   drivers/phy/Makefile       |    1 +
>>   drivers/phy/phy-keystone.c |  230 ++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 237 insertions(+)
>>   create mode 100644 drivers/phy/phy-keystone.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 4906c27..e5f4b5a 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -167,4 +167,10 @@ config PHY_XGENE
>>   	help
>>   	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>>   
>> +config PHY_TI_KEYSTONE
>> +	bool "TI Keystone PHY support"
>> +	depends on ARCH_KEYSTONE
>> +	select GENERIC_PHY
>> +	help
>> +	  This option enables support for TI Keystone PHY (serdes).
>>   endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 7728518..bd306a7 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -19,3 +19,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
>>   phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>>   phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>>   obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
>> +obj-$(CONFIG_PHY_TI_KEYSTONE)		+= phy-keystone.o
>> diff --git a/drivers/phy/phy-keystone.c b/drivers/phy/phy-keystone.c
>> new file mode 100644
>> index 0000000..ba1b9fa
>> --- /dev/null
>> +++ b/drivers/phy/phy-keystone.c
>> @@ -0,0 +1,230 @@
>> +/*
>> + * PCIe Keystone platform specific driver code
>> + *
>> + * Copyright (C) 2013-2014 Texas Instruments, Inc.
>> + *		http://www.ti.com
>> + *
>> + * Author: Murali Karicheri <m-karicheri2@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +
>> +#define reg_dump(addr, mask) \
>> +		pr_debug("reg %p has value %x\n", (void *)addr, \
>> +			(readl(addr) & ~mask))
>> +
>> +/* mask bits point to bits being modified */
>> +#define reg_rmw(addr, value, mask) \
>> +		writel(((readl(addr) & (~(mask))) | \
>> +			(value & (mask))), (addr))
>> +struct serdes_config {
>> +	u32 reg;
>> +	u32 val;
>> +	u32 mask;
>> +};
>> +
>> +struct phy_keystone {
>> +	struct device *dev;
>> +	void __iomem *base;
>> +};
>> +
>> +static struct serdes_config ks_100mhz_pcie_5gbps_serdes[] = {
>> +	{0x0000, 0x00000800, 0x0000ff00},
>> +	{0x0060, 0x00041c5c, 0x00ffffff},
>> +	{0x0064, 0x0343c700, 0xffffff00},
>> +	{0x006c, 0x00000012, 0x000000ff},
>> +	{0x0068, 0x00070000, 0x00ff0000},
>> +	{0x0078, 0x0000c000, 0x0000ff00},
>> +
>> +	{0x0200, 0x00000000, 0x000000ff},
>> +	{0x0204, 0x5e000080, 0xff0000ff},
>> +	{0x0208, 0x00000006, 0x000000ff},
>> +	{0x0210, 0x00000023, 0x000000ff},
>> +	{0x0214, 0x2e003060, 0xff00ffff},
>> +	{0x0218, 0x76000000, 0xff000000},
>> +	{0x022c, 0x00200002, 0x00ff00ff},
>> +	{0x02a0, 0xffee0000, 0xffff0000},
>> +	{0x02a4, 0x0000000f, 0x000000ff},
>> +	{0x0204, 0x5e000000, 0xff000000},
>> +	{0x0208, 0x00000006, 0x000000ff},
>> +	{0x0278, 0x00002000, 0x0000ff00},
>> +	{0x0280, 0x00280028, 0x00ff00ff},
>> +	{0x0284, 0x2d0f0385, 0xffffffff},
>> +	{0x0250, 0xd0000000, 0xff000000},
>> +	{0x0284, 0x00000085, 0x000000ff},
>> +	{0x0294, 0x20000000, 0xff000000},
>> +
>> +	{0x0400, 0x00000000, 0x000000ff},
>> +	{0x0404, 0x5e000080, 0xff0000ff},
>> +	{0x0408, 0x00000006, 0x000000ff},
>> +	{0x0410, 0x00000023, 0x000000ff},
>> +	{0x0414, 0x2e003060, 0xff00ffff},
>> +	{0x0418, 0x76000000, 0xff000000},
>> +	{0x042c, 0x00200002, 0x00ff00ff},
>> +	{0x04a0, 0xffee0000, 0xffff0000},
>> +	{0x04a4, 0x0000000f, 0x000000ff},
>> +	{0x0404, 0x5e000000, 0xff000000},
>> +	{0x0408, 0x00000006, 0x000000ff},
>> +	{0x0478, 0x00002000, 0x0000ff00},
>> +	{0x0480, 0x00280028, 0x00ff00ff},
>> +	{0x0484, 0x2d0f0385, 0xffffffff},
>> +	{0x0450, 0xd0000000, 0xff000000},
>> +	{0x0494, 0x20000000, 0xff000000},
>> +
>> +	{0x0604, 0x00000080, 0x000000ff},
>> +	{0x0600, 0x00000000, 0x000000ff},
>> +	{0x0604, 0x5e000000, 0xff000000},
>> +	{0x0608, 0x00000006, 0x000000ff},
>> +	{0x0610, 0x00000023, 0x000000ff},
>> +	{0x0614, 0x2e003060, 0xff00ffff},
>> +	{0x0618, 0x76000000, 0xff000000},
>> +	{0x062c, 0x00200002, 0x00ff00ff},
>> +	{0x06a0, 0xffee0000, 0xffff0000},
>> +	{0x06a4, 0x0000000f, 0x000000ff},
>> +	{0x0604, 0x5e000000, 0xff000000},
>> +	{0x0608, 0x00000006, 0x000000ff},
>> +	{0x0678, 0x00002000, 0x0000ff00},
>> +	{0x0680, 0x00280028, 0x00ff00ff},
>> +	{0x0684, 0x2d0f0385, 0xffffffff},
>> +	{0x0650, 0xd0000000, 0xff000000},
>> +	{0x0694, 0x20000000, 0xff000000},
>> +
>> +	{0x0800, 0x00000000, 0x000000ff},
>> +	{0x0804, 0x5e000080, 0xff0000ff},
>> +	{0x0808, 0x00000006, 0x000000ff},
>> +	{0x0810, 0x00000023, 0x000000ff},
>> +	{0x0814, 0x2e003060, 0xff00ffff},
>> +	{0x0818, 0x76000000, 0xff000000},
>> +	{0x082c, 0x00200002, 0x00ff00ff},
>> +	{0x08a0, 0xffee0000, 0xffff0000},
>> +	{0x08a4, 0x0000000f, 0x000000ff},
>> +	{0x0804, 0x5e000000, 0xff000000},
>> +	{0x0808, 0x00000006, 0x000000ff},
>> +	{0x0878, 0x00002000, 0x0000ff00},
>> +	{0x0880, 0x00280028, 0x00ff00ff},
>> +	{0x0884, 0x2d0f0385, 0xffffffff},
>> +	{0x0850, 0xd0000000, 0xff000000},
>> +	{0x0894, 0x20000000, 0xff000000},
>> +
>> +	{0x0a00, 0x00000100, 0x0000ff00},
>> +	{0x0a08, 0x00e12c08, 0x00ffffff},
>> +	{0x0a0c, 0x00000081, 0x000000ff},
>> +	{0x0a18, 0x00e80000, 0x00ff0000},
>> +	{0x0a30, 0x002f2f00, 0x00ffff00},
>> +	{0x0a4c, 0xac820000, 0xffff0000},
>> +	{0x0a54, 0xc0000000, 0xff000000},
>> +	{0x0a58, 0x00001441, 0x0000ffff},
>> +	{0x0a84, 0x00000301, 0x0000ffff},
>> +
>> +	{0x0a8c, 0x81030000, 0xffff0000},
>> +	{0x0a90, 0x00006001, 0x0000ffff},
>> +	{0x0a94, 0x01000000, 0xff000000},
>> +	{0x0aa0, 0x81000000, 0xff000000},
>> +	{0x0abc, 0xff000000, 0xff000000},
>> +	{0x0ac0, 0x0000008b, 0x000000ff},
>> +
>> +	{0x0000, 0x00000003, 0x000000ff},
>> +	{0x0a00, 0x0000009f, 0x000000ff},
>> +
>> +	{0x0a44, 0x5f733d00, 0xffffff00},
>> +	{0x0a48, 0x00fdca00, 0x00ffff00},
>> +	{0x0a5c, 0x00000000, 0xffff0000},
>> +	{0x0a60, 0x00008000, 0xffffffff},
>> +	{0x0a64, 0x0c581220, 0xffffffff},
>> +	{0x0a68, 0xe13b0602, 0xffffffff},
>> +	{0x0a6c, 0xb8074cc1, 0xffffffff},
>> +	{0x0a70, 0x3f02e989, 0xffffffff},
>> +	{0x0a74, 0x00000001, 0x000000ff},
>> +	{0x0b14, 0x00370000, 0x00ff0000},
>> +	{0x0b10, 0x37000000, 0xff000000},
>> +	{0x0b14, 0x0000005d, 0x000000ff},
> Which of these is powering on/off the PHY? Which of these is for clocks? Which
> of these is for TX or RX? Which of these is for lane configuration?...
>
> Imagining how would it be if all peripherals are programmed this way in linux..
>
> -Kishon
Kishon, Jingoo,

You are right and I also agree with you. This was originally discussed 
with Arnd on the list.
There is a NDA between TI and owner of the IP not to disclose the 
register details. So we
have to keep the driver the way it is. Once we have permission to 
disclose the details, this
driver will be updated. As per Arnd's request I have also checked the 
existing drivers for
similar register map and couldn't find any. So there is no duplication.

Murali
>> +};
>> +
>> +static int ks_phy_init(struct phy *phy)
>> +{
>> +	struct serdes_config *p;
>> +	struct phy_keystone *ks_phy = phy_get_drvdata(phy);
>> +
>> +	int i;
>> +
>> +	for (i = 0, p = &ks_100mhz_pcie_5gbps_serdes[0];
>> +		i < ARRAY_SIZE(ks_100mhz_pcie_5gbps_serdes);
>> +		i++, p++) {
>> +		reg_rmw((ks_phy->base + p->reg), p->val, p->mask);
>> +		reg_dump((ks_phy->base + p->reg), p->mask);
>> +	}
>> +	udelay(2000);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct phy_ops ks_phy_ops = {
>> +	.init		= ks_phy_init,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int ks_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct phy_provider *phy_provider;
>> +	struct device *dev = &pdev->dev;
>> +	struct phy_keystone *ks_phy;
>> +	struct phy *phy;
>> +	struct resource *res;
>> +
>> +	ks_phy = devm_kzalloc(dev, sizeof(*ks_phy), GFP_KERNEL);
>> +	if (!ks_phy)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg_serdes");
>> +	ks_phy->base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(ks_phy->base))
>> +		return PTR_ERR(ks_phy->base);
>> +
>> +	ks_phy->dev = dev;
>> +	phy = devm_phy_create(dev, &ks_phy_ops, NULL);
>> +	if (IS_ERR(phy))
>> +		return PTR_ERR(phy);
>> +
>> +	phy_set_drvdata(phy, ks_phy);
>> +	phy_provider = devm_of_phy_provider_register(ks_phy->dev,
>> +				of_phy_simple_xlate);
>> +
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>> +	dev_info(dev, "keystone phy initialized\n");
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ks_phy_of_match[] = {
>> +	{ .compatible = "ti,keystone-phy" },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(of, ks_phy_of_match);
>> +
>> +static struct platform_driver ks_phy_driver = {
>> +	.probe	= ks_phy_probe,
>> +	.driver = {
>> +		.of_match_table	= ks_phy_of_match,
>> +		.name  = "ti,keystone-phy",
>> +		.owner = THIS_MODULE,
>> +	}
>> +};
>> +module_platform_driver(ks_phy_driver);
>> +
>> +MODULE_DESCRIPTION("TI Keystone SerDes PHY driver");
>> +MODULE_LICENSE("GPL V2");
>> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>>

