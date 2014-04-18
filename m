Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaDRLnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:43:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbaDRLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:43:49 -0400
Message-ID: <53510FEC.7030803@free-electrons.com>
Date: Fri, 18 Apr 2014 13:43:40 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/8] usb: host: xhci-plat: Add support for the Armada
 38x glue code
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com> <1397816563-9000-3-git-send-email-gregory.clement@free-electrons.com> <535108E3.2010208@gmail.com>
In-Reply-To: <535108E3.2010208@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

[...]

>> @@ -0,0 +1,21 @@
>> +/*
>> + * Copyright (C) 2014 Marvell
>> + *
>> + * Gregory Clement <gregory.clement@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef __LINUX_XHCI_MVEBU_H
>> +#define __LINUX_XHCI_MVEBU_H
>> +
>> +#ifdef CONFIG_USB_XHCI_MVEBU
>> +int xhci_mvebu_probe(struct platform_device *pdev);
>> +int xhci_mvebu_remove(struct platform_device *pdev);
>> +#else
>> +#define xhci_mvebu_probe NULL
>> +#define xhci_mvebu_remove NULL
>> +#endif
>> +#endif /* __LINUX_XHCI_MVEBU_H */
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index 8029cc82edc4..f1261d3848a9 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/of_device.h>
>>  
>>  #include "xhci.h"
>> +#include "xhci-mvebu.h"
>>  
>>  static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>>  {
>> @@ -250,6 +251,11 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
>>  #endif /* CONFIG_PM */
>>  
>>  #ifdef CONFIG_OF
> 
> Gregory,
> 
> either you should #ifndef CONFIG_USB_XHCI_MVEBU this and the one below -
> or even better:

With the current code we don't need to add this, see xhci-mvebu.h: xhci_mvebu_*
are set to NULL if CONFIG_USB_XHCI_MVEBU is not define. Then the driver
is more multiplatform friendly.

> 
> Can you put driver stub with its of_match_table right into xhci-mvebu?
> That way platform specific probe wouldn't pollute the generic driver.

This sound more interesting. However the only "pollution" is to extend
the compatible list, the platform specific code is in is own file. Moreover
it could make sens to have all the compatible strings at the same place.

I wait for the opinion of the USB maintainers for this point.

Thanks,

Gregory

> 
> Greg will have a better opinion about it, but I remember some cleanup
> in ehci, that basically removed platform specific references from the
> generic code.
> 
>> +struct xhci_plat_ops xhci_plat_mvebu = {
>> +	.probe =  xhci_mvebu_probe,
>> +	.remove =  xhci_mvebu_remove,
>> +};
>> +
>>  static const struct of_device_id usb_xhci_of_match[] = {
>>  	{
>>  		.compatible = "generic-xhci",
>> @@ -259,6 +265,10 @@ static const struct of_device_id usb_xhci_of_match[] = {
>>  		.compatible = "xhci-platform",
>>  		.data = (void *) &xhci_plat_default,
>>  	},
>> +	{
>> +		.compatible = "marvell,xhci-armada-380",
> 
> nit: the ususal order we use on mvebu is "marvell,<soc>-<ip>", so this
> should be "marvell,armada-380-xhci".
> 
> Sebastian
> 
>> +		.data = (void *) &xhci_plat_mvebu,
>> +	},
>>  	{ },
>>  };
>>  MODULE_DEVICE_TABLE(of, usb_xhci_of_match);
>>
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
