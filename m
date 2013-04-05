Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161871Ab3DEKj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:39:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34516 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab3DEKjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:39:54 -0400
Message-ID: <515EA9E3.1010409@ti.com>
Date: Fri, 5 Apr 2013 13:39:31 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <rnayak@ti.com>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com> <20130403234242.GE10155@atomide.com> <515D2D30.3000306@ti.com> <20130404164137.GH10155@atomide.com>
In-Reply-To: <20130404164137.GH10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 07:41 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130404 00:39]:
>> On 04/04/2013 02:42 AM, Tony Lindgren wrote:
>>>> --- a/arch/arm/mach-omap2/cclock44xx_data.c
>>>> +++ b/arch/arm/mach-omap2/cclock44xx_data.c
>>>> @@ -27,6 +27,7 @@
>>>>  #include <linux/clk-private.h>
>>>>  #include <linux/clkdev.h>
>>>>  #include <linux/io.h>
>>>> +#include <linux/of.h>
>>>>  
>>>>  #include "soc.h"
>>>>  #include "iomap.h"
>>>> @@ -1663,6 +1664,40 @@ static struct omap_clk omap44xx_clks[] = {
>>>>  	CLK(NULL,	"cpufreq_ck",	&dpll_mpu_ck,	CK_443X),
>>>>  };
>>>>  
>>>> +static struct clk *scrm_clks[] = {
>>>> +	&auxclk0_ck,
>>>> +	&auxclk1_ck,
>>>> +	&auxclk2_ck,
>>>> +	&auxclk3_ck,
>>>> +	&auxclk4_ck,
>>>> +	&auxclk5_ck,
>>>> +};
>>>
>>> Hmm I don't like the idea of specifying the auxclk both in the
>>> cclock44xx_data.c and in DT..
>>
>> Right, but till we have all clocks moved to DT we only need this
>> approach for general purpose clocks that are not mapped to devices
>> by hwmod.
> 
> For v3.10, let's just make sure that USB works with DT as then
> after v3.10 we can make omap4 DT only and get rid of estimated
> 7K lines of code and data. I guess this is the last piece missing
> for that, or are we also missing something else?

For panda we just need a way to map the auxclk to the USB PHY device
and the relevant dts data to get USB host working with DT.
Beagle USB host should work already with DT without any changes.

> 
> Can't you set up a clock alias for your device so it can find the
> auxclk when requesting it with the dev entry?
> 

which clock is mapped to which PHY device depends on board design
and that cannot be per-determined at one place. This information
needs to come from the board.dts file.

There was an earlier attempt to provide a way of building clock aliases
at runtime from device tree [1], but the current approach is way better

[1]
https://lkml.org/lkml/2013/3/12/241

> For the DT clock driver if needed for v3.10, how about just do a
> minimal drivers/clock/omap/ that uses the standard binding?
> Then that driver can just do clk_get() from cclock44xx_data.c

I don't understand how to do it and why it is better than the current
approach.

How can that driver do clk_get() from cclock44xx_data.c?
from where does it get the clk_id to pass into clk_get()?

> for now? And then later on we'll just move all the clocks to a
> combination of DT + /lib/firmware.

What is the benefit of moving clock data to /lib/firmware? We could
as well just move it to DT only, no?

> 
>> e.g. auxclk are required to be specified in DT nodes for USB PHY.
>> Without this we can't get USB host working on Panda.
> 
> OK. So if the USB PHY has a dev entry, can't you just set up a
> clock alias in struct omap_clk omap44xx_clks[] for it?

I've explained why this can't be done above.

>  
>> As Rajendra points out, it seems moving entire clock data to DT is not
>> going to happen soon. So this is the simplistic way things can work.
> 
> Right but seems like we can get started there without moving
> them all at once.
> 
What if we provide a complete clock list instead of only auxclks in
dt_clks[]?

This approach is similar to arch/arm/mach-imx/clk-imx35.c

Device drivers can then use them as they migrate to DT. Then later
we could migrate clock data to DT, without impacting device drivers.

cheers,
-roger
