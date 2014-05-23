Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaEWVj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:39:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbaEWVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:39:25 -0400
Message-ID: <537FC002.6080701@free-electrons.com>
Date: Fri, 23 May 2014 23:39:14 +0200
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
Subject: Re: [PATCH 4/5] usb: host: xhci-plat: add optional PHY support
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com> <1400257376-13251-4-git-send-email-gregory.clement@free-electrons.com> <537F14D4.1090705@ti.com>
In-Reply-To: <537F14D4.1090705@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2014 11:28, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 16 May 2014 09:52 PM, Gregory CLEMENT wrote:
>> This commit extends the xhci-plat so that it can optionally be passed
>> a reference to a PHY through the Device Tree. It will be useful for
>> the Armada 375 SoCs. If no PHY is provided then the behavior of the
>> driver is unchanged.
>>
>> As for the clock, to achieve this, it adds a 'struct phy *' member in
>> xhci_hcd. While only used for now in xhci-plat, here again, it might
>> be used by other drivers in the future.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  drivers/usb/host/xhci-plat.c | 29 ++++++++++++++++++++++++++++-
>>  drivers/usb/host/xhci.h      |  2 ++
>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index 0f5f4c8f5bf6..34239b582621 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/dma-mapping.h>
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>> +#include <linux/phy/phy.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/slab.h>
>>  
>> @@ -94,6 +95,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
>>  	struct resource         *res;
>>  	struct usb_hcd		*hcd;
>>  	struct clk              *clk;
>> +	struct phy              *phy;
>>  	int			ret;
>>  	int			irq;
>>  
>> @@ -160,9 +162,23 @@ static int xhci_plat_probe(struct platform_device *pdev)
>>  			goto unmap_registers;
>>  	}
>>  
>> +	phy = devm_phy_optional_get(&pdev->dev, "usb");
>> +	if (IS_ERR(phy)) {
>> +		ret = PTR_ERR(phy);
>> +		goto disable_clk;
>> +	} else {
>> +		ret = phy_init(phy);
>> +		if (ret)
>> +			goto disable_phy;
> s
> I think you meant disable_clk here?

yes indeed!


>> +
>> +		ret = phy_power_on(phy);
>> +		if (ret)
>> +			goto disable_phy;
>> +	}
>> +
>>  	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
>>  	if (ret)
>> -		goto disable_clk;
>> +		goto power_off_phy;
>>  
>>  	device_wakeup_enable(hcd->self.controller);
>>  
>> @@ -198,6 +214,12 @@ put_usb3_hcd:
>>  dealloc_usb2_hcd:
>>  	usb_remove_hcd(hcd);
>>  
>> +power_off_phy:
>> +	if (!IS_ERR(phy))
> 
> This check is unnecessary here since you do power_off only if PHY is not error.

Good catch again!


>> +		phy_power_off(phy);
>> +disable_phy:
>> +	if (!IS_ERR(phy))
> 
> same here..

I agree

>> +		phy_exit(phy);
>>  disable_clk:
>>  	if (!IS_ERR(clk))
>>  		clk_disable_unprepare(clk);
>> @@ -219,6 +241,7 @@ static int xhci_plat_remove(struct platform_device *dev)
>>  	struct usb_hcd	*hcd = platform_get_drvdata(dev);
>>  	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
>>  	struct clk *clk = xhci->clk;
>> +	struct phy *phy = xhci->phy;
>>  
>>  	usb_remove_hcd(xhci->shared_hcd);
>>  	usb_put_hcd(xhci->shared_hcd);
>> @@ -226,6 +249,10 @@ static int xhci_plat_remove(struct platform_device *dev)
>>  	usb_remove_hcd(hcd);
>>  	if (!IS_ERR(clk))
>>  		clk_disable_unprepare(clk);
>> +	if (!IS_ERR(phy)) {
> 
> same here..

I agree too

Thanks for you review,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
