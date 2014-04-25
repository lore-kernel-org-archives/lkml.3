Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDYOpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:45:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47921 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbaDYOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:44:56 -0400
Message-ID: <535A74DF.6090106@free-electrons.com>
Date: Fri, 25 Apr 2014 16:44:47 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/18] usb: host: xhci-plat: Add clocks support
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>	<1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com> <20140425161517.20821c65@skate>
In-Reply-To: <20140425161517.20821c65@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/2014 16:15, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Fri, 25 Apr 2014 16:07:00 +0200, Gregory CLEMENT wrote:
>> Some platform (such as the Armada 38x ones) can gate the clock of
>> their USB controller. This patch add the support for the clock, by
>> enabling them during probe and disabling them on remove.
>>
>> As not all platforms have clock support then enabling and disabling
>> the clocks have been placed in separate functions. Then if the clocks
>> are not supported we still can use the same calls, and there is no
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  drivers/usb/host/xhci-plat.c | 52 ++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 50 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index f5351af4b2c5..bb5d563f729c 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -11,6 +11,7 @@
>>   * version 2 as published by the Free Software Foundation.
>>   */
>>  
>> +#include <linux/clk.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>> @@ -85,6 +86,42 @@ static const struct hc_driver xhci_plat_xhci_driver = {
>>  	.bus_resume =		xhci_bus_resume,
>>  };
>>  
>> +#if defined(CONFIG_HAVE_CLK)
>> +static int try_enable_clk(struct platform_device *pdev)
>> +{
>> +	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
>> +
>> +	/* Not all platforms have a clk so it is not an error if the clock
>> +	   does not exists. */
>> +	if (!IS_ERR(clk))
> 
> Instead, do:
> 
> 	if (IS_ERR(clk))
> 		return 0;

As explained in the comment: Not all platforms have a clk so it is not an
error if the clock does not exists.

> 
> 	return clk_prepare_enable(clk);
> 
>> +		if (clk_prepare_enable(clk))
>> +			return  -ENODEV;
>> +	return 0;
>> +}
>> +
>> +static int try_disable_clk(struct platform_device *pdev)
>> +{
>> +	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
> 
> No, this isn't correct: you shouldn't be getting the clock to
> disable/unprepare it, otherwise you have an unbalanced number of
> get()/put() calls on the clocks.
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
