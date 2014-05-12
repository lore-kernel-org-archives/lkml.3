Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbaELOS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:18:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34796 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356AbaELOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:18:55 -0400
Message-ID: <5370D84A.9030405@gmail.com>
Date: Mon, 12 May 2014 16:18:50 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] phy: add a driver for the Berlin SATA PHY
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com> <1399886217-20474-2-git-send-email-antoine.tenart@free-electrons.com> <5370C2B6.8030908@ti.com>
In-Reply-To: <5370C2B6.8030908@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 02:46 PM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Monday 12 May 2014 02:46 PM, Antoine Ténart wrote:
>> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>>
>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>> ---
>>   drivers/phy/Kconfig           |   5 ++
>>   drivers/phy/Makefile          |   1 +
>>   drivers/phy/phy-berlin-sata.c | 179 ++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 185 insertions(+)
>>   create mode 100644 drivers/phy/phy-berlin-sata.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 4906c27fa3bd..b31b1986fda4 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -15,6 +15,11 @@ config GENERIC_PHY
>>   	  phy users can obtain reference to the PHY. All the users of this
>>   	  framework should select this config.
>>
>> +config PHY_BERLIN_SATA
>> +	bool
>> +	depends on ARCH_BERLIN && OF
>> +	select GENERIC_PHY
>> +
>>   config PHY_EXYNOS_MIPI_VIDEO
>>   	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
>>   	depends on HAS_IOMEM
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 7728518572a4..40278706ac1b 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -3,6 +3,7 @@
>>   #
>>
>>   obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
>> +obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
>>   obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>>   obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>> diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
>> new file mode 100644
>> index 000000000000..f20f5ece1a7f
>> --- /dev/null
>> +++ b/drivers/phy/phy-berlin-sata.c
>> @@ -0,0 +1,179 @@
>> +/*
>> + * Marvell Berlin SATA PHY driver
>> + *
>> + * Copyright (C) 2014 Marvell Technology Group Ltd.
>> + *
>> + * Antoine Ténart <antoine.tenart@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/io.h>
>> +#include <linux/platform_device.h>
>> +
>> +#define HOST_VSA_ADDR		0x0
>> +#define HOST_VSA_DATA		0x4
>> +
>> +#define CONTROL_REGISTER	0x0
>> +#define MBUS_SIZE_CONTROL	0x4
>> +
>> +#define POWER_DOWN_SATA0		BIT(6)
>> +#define POWER_DOWN_SATA1		BIT(14)
>> +#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
>> +#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
>> +
>> +#define BERLIN_SATA_PHY_NB	2
>> +
>> +#define to_berlin_sata_phy_priv(desc)	\
>> +	container_of((desc), struct priv, phys[(desc)->index])
>> +
>> +struct phy_desc {
>
> to be consistent, lets name it phy_berlin_desc.
>> +	struct phy	*phy;
>> +	u32		val;
>> +	unsigned	index;
>> +};
>> +
>> +struct priv {

And phy_berlin_priv then?

[...]
>> +static int phy_berlin_sata_probe(struct platform_device *pdev)
>> +{
>> +	struct phy *phy;
>> +	struct phy_provider *phy_provider;
>> +	struct priv *priv;
>> +	struct resource *res;
>> +	int i;
>> +
>> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	priv->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>> +	if (IS_ERR(priv->base))
>> +		return PTR_ERR(priv->base);
>> +
>> +	phy = devm_phy_create(&pdev->dev, &phy_berlin_sata_ops, NULL);
>> +	if (IS_ERR(phy))
>> +		return PTR_ERR(phy);
>> +
>> +	dev_set_drvdata(&pdev->dev, priv);
>> +	spin_lock_init(&priv->lock);
>> +
>> +	for (i = 0; i < BERLIN_SATA_PHY_NB; i++) {
>
> huh.. this should come from dt data. For devices which have multiple PHYs, each
> PHY should be modelled as the sub-node of the *PHY provider* device node.

Just to make sure we get it right:

You want the PHY (provider) node look like this:

sata_phy: phy@f7e900a0 {
	compatible = "marvell,berlin-sata-phy";
	reg = <0xf7e900a0 0x10>;
	#address-cells = <1>;
	#size-cells = <0>;
	#phy-cells = <1>;
	status = "okay";

	sata_phy0: phy@0 { reg = <0>; };

	sata_phy1: phy@1 { reg = <1>; };
};

and parse the number of individual PHYs with
for_each_child_of_node()?

Sebastian

>> +		struct phy *phy = devm_phy_create(&pdev->dev,
>> +						  &phy_berlin_sata_ops, NULL);
>> +		if (IS_ERR(phy)) {
>> +			dev_err(&pdev->dev, "failed to create PHY %d\n", i);
>> +			return PTR_ERR(phy);
>> +		}
>> +
>> +		priv->phys[i].phy = phy;
>> +		priv->phys[i].val = desc[i].val;
>> +		priv->phys[i].index = i;
>> +		phy_set_drvdata(phy, &priv->phys[i]);
>> +
>> +		/* Make sure the PHY is off */
>> +		phy_berlin_sata_power_off(phy);
>> +	}
>> +
>> +	phy_provider = devm_of_phy_provider_register(&pdev->dev,
>> +						     berlin_sata_phy_xlate);
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id phy_berlin_sata_of_match[] = {
>> +	{ .compatible = "marvell,berlin-sata-phy" },
>> +	{ },
>> +};
>> +
>> +static struct platform_driver phy_berlin_sata_driver = {
>> +	.probe	= phy_berlin_sata_probe,
>> +	.driver	= {
>> +		.name		= "phy-berlin-sata",
>> +		.owner		= THIS_MODULE,
>> +		.of_match_table	= phy_berlin_sata_of_match,
>> +	},
>> +};
>> +module_platform_driver(phy_berlin_sata_driver);
>> +
>> +MODULE_DESCRIPTION("Marvell Berlin SATA PHY driver");
>> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
>> +MODULE_LICENSE("GPL");
>
> GPL v2 as the file header states so?
>
> Thanks
> Kishon
>

