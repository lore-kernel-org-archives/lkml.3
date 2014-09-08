Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaIHOZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:25:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59831 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbaIHOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:25:50 -0400
Message-ID: <540DBC68.7040905@ti.com>
Date: Mon, 8 Sep 2014 19:55:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: phy: twl4030-usb: Move code from twl4030_phy_power
 to the runtime PM calls
References: <1409182091-31191-1-git-send-email-tony@atomide.com> <1409182091-31191-4-git-send-email-tony@atomide.com> <54086E3D.4000200@ti.com> <20140904170723.GA14282@atomide.com>
In-Reply-To: <20140904170723.GA14282@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thursday 04 September 2014 10:37 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [140904 06:51]:
>> Hi Tony,
>>
>> On Thursday 28 August 2014 04:58 AM, Tony Lindgren wrote:
>>> We don't need twl4030_phy_power() any longer now that we have
>>> the runtime PM calls. Let's get rid of it as it's confusing.
>>> No functional changes, just move the code and use res instead
>>> of ret as we are not returning that value.
>>
>> Now that you are doing pm_runtime_get_sync in twl4030_phy_init, won't it power
>> on the phy even before initializing it (since runtime_resume will be invoked
>> even before doing phy_init)?
> 
> Yes. The logic being that it should not matter as we are not
> configuring the phy until in twl4030_phy_power_on(). Maybe we
> should add code to make sure the phy is deconfigured initially
> though :)
> 
> In twl4030_phy_init() we just want to check the ID pin state to get
> things right initially. In the twl4030-usb case the I2C chip is
> always on, but let's try to get the runtime PM set up like any
> standard Linux driver would do it to avoid confusion.
> 
>> Even if pm_runtime_get_sync in not done in twl4030_phy_init, phy-core itself
>> does pm_runtime_get_sync in phy_init().
> 
> Hmm OK. Looking at that, looks like we don't neeed any of these
> custom exports though:
> 
> $ git grep phy_pm_runtime | grep EXPORT_SYMBOL
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get);
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get_sync);
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put);
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put_sync);
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_allow);
> drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_forbid);
> 
> The reasons why I think we don't need the above at all is:
> 
> 1. We already have a framework for that in Linux runtime PM and we
>    can follow the standard Linux runtime PM calls and not proxy
>    them in phy-core.c

The reason for adding these are for providing fine grained control of the PHY
by the controller drivers. In most cases the controller driver determines when
the PHY should be active or idle.
> 
> 2. We can allow idling the phy properly on the bus it's connected
>    to, in this case I2C, even if USB driver is not loaded. We
>    eventually should idle the phy even if usb_add_phy_dev()
>    failed

yes.. that's why we have ops like phy_power_on to tell when the PHY should be
active. So these PHYs can be idled in probe.
> 
> 3. There's no actual need for phy-core.c to proxy the runtime
>    PM calls
> 
> So we can and should just let the phy drivers do their own runtime PM
> as needed based on just the phy init, power_on and power_off calls.
> 
> Probably the same goes for the regulator_enable in phy-core.c. That
> should be handled in the phy driver as phy-core is already unable
> to handle it properly. For example, for phy-twl4030-usb.c we have
> three regulators to deal with and the phy framework won't have any
> idea how to deal with those.

hmm.. It was modelled for basic PHY drivers that have a single regulator (e.g.,
TI PIPE3 PHY). The idea is not to duplicate getting and enabling regulator in
each of the PHY drivers when it can be abstracted in phy-core.

Thanks
Kishon
