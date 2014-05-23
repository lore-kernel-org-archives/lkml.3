Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaEWVvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:51:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57469 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923AbaEWVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:51:05 -0400
Message-ID: <537FC2BE.1040501@free-electrons.com>
Date: Fri, 23 May 2014 23:50:54 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] phy: add support for USB cluster on the Armada 375
 SoC
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com> <537F12F5.2030102@ti.com>
In-Reply-To: <537F12F5.2030102@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2014 11:20, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 16 May 2014 09:52 PM, Gregory CLEMENT wrote:
>> The Armada 375 SoC comes with an USB2 host and device controller and
>> an USB3 controller. The USB cluster control register allows to manage
>> common features of both USB controllers.
>>
>> This commit adds a driver integrated in the generic PHY framework to
>> control this USB cluster feature.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> ---
>>  drivers/phy/Kconfig                              |   6 +
>>  drivers/phy/Makefile                             |   1 +
>>  drivers/phy/phy-armada375-usb2.c                 | 140 +++++++++++++++++++++++
>>  include/dt-bindings/phy/armada-375-usb-cluster.h |  18 +++
[...]

>> +static struct phy_ops armada375_usb_phy_ops = {
>> +	.init = armada375_usb_phy_init,
>> +	.owner		= THIS_MODULE,
> 
> nitpick: unnecessary tab.

OK

>> +};
>> +
>> +/*
>> + * Only one controller can use this PHY. We shouldn't have the case
>> + * when two controllers want to use this PHY. But if this case occurs
>> + * then we provide a phy to the first one and return an error for the
>> + * next one. This error has also to be an error returned by
>> + * devm_phy_optional_get() so different from ENODEV for USB2. In the
>> + * USB3 case it still optional and we use ENODEV.
>> + */
>> +static struct phy *armada375_usb_phy_xlate(struct device *dev,
>> +					struct of_phandle_args *args)
>> +{
>> +	if (WARN_ON(usb_cluster_phy.phy_provided)) {
>> +		dev_err(dev, "This PHY has already been provided!\n");
>> +		dev_err(dev, "Check your device tree, only one controller can use it\n.");
>> +		if (args->args[0] == PHY_USB2)
>> +			return ERR_PTR(-EBUSY);
>> +		else
>> +			return ERR_PTR(-ENODEV);
>> +	}
>> +
>> +	if (args->args[0] == PHY_USB2)
>> +		usb_cluster_phy.use_usb3 = false;
>> +	else if (args->args[0] == PHY_USB3)
>> +		usb_cluster_phy.use_usb3 = true;
>> +	else {
>> +		dev_err(dev, "Invalid PHY mode\n");
>> +		return ERR_PTR(-ENODEV);
>> +	}
> 
> how will this behave if there is a phy_put and then a phy_get?

Badly I think :(

I have to think about a better solution then.

>> +
>> +	usb_cluster_phy.phy_provided = true;
>> +
>> +	return usb_cluster_phy.phy;
>> +}
>> +
>> +static int armada375_usb_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct phy *phy;
>> +	struct phy_provider *phy_provider;
>> +	void __iomem *usb_cluster_base;
>> +	struct resource *res;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	usb_cluster_base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (!usb_cluster_base)
>> +		return -ENOMEM;
>> +
>> +	phy = devm_phy_create(dev, &armada375_usb_phy_ops, NULL);
>> +	if (IS_ERR(phy)) {
>> +		dev_err(dev, "failed to create PHY \n");
>> +		return PTR_ERR(phy);
>> +	}
>> +
>> +	usb_cluster_phy.phy = phy;
>> +	usb_cluster_phy.reg = usb_cluster_base;
>> +	phy_set_drvdata(phy, &usb_cluster_phy);
>> +
>> +	phy_provider = devm_of_phy_provider_register(&pdev->dev,
>> +						     armada375_usb_phy_xlate);
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id of_usb_cluster_table[] = {
>> +	{ .compatible = "marvell,armada-375-usb-cluster", },
>> +	{ /* end of list */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, of_usb_cluster_table);
>> +
>> +static struct platform_driver armada375_usb_phy_driver = {
>> +	.probe	= armada375_usb_phy_probe,
>> +	.driver = {
>> +		.of_match_table	= of_usb_cluster_table,
>> +		.name  = "armada-375-usb-cluster",
>> +		.owner = THIS_MODULE,
>> +	}
>> +};
>> +module_platform_driver(armada375_usb_phy_driver);
>> +
>> +MODULE_DESCRIPTION("Armada 375 USB cluster driver");
>> +MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
>> +MODULE_LICENSE("GPL");
> 
> GPL v2?

See the header, I chose "GNU General Public License version 2 or later."
so "GPL" match it.


Thanks for your review, once I will have found a proper solution for the
phy_put/phy_get scenario, I will sent a new version with all the other issues
fixed.


Gregory

> 
> Thanks
> Kishon
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
