Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937313Ab3DIJzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:55:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50366 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935627Ab3DIJzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:55:39 -0400
Message-ID: <5163E589.1040809@ti.com>
Date: Tue, 9 Apr 2013 12:55:21 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <rnayak@ti.com>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, "Menon, Nishanth" <nm@ti.com>,
        <grygorii.strashko@ti.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com> <20130403234242.GE10155@atomide.com> <515D2D30.3000306@ti.com> <20130404164137.GH10155@atomide.com> <515EA9E3.1010409@ti.com> <20130405155851.GA10155@atomide.com>
In-Reply-To: <20130405155851.GA10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 06:58 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130405 03:44]:
>> On 04/04/2013 07:41 PM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [130404 00:39]:
>>>> On 04/04/2013 02:42 AM, Tony Lindgren wrote:
>>> For v3.10, let's just make sure that USB works with DT as then
>>> after v3.10 we can make omap4 DT only and get rid of estimated
>>> 7K lines of code and data. I guess this is the last piece missing
>>> for that, or are we also missing something else?
>>
>> For panda we just need a way to map the auxclk to the USB PHY device
>> and the relevant dts data to get USB host working with DT.
>> Beagle USB host should work already with DT without any changes.
>>
>>>
>>> Can't you set up a clock alias for your device so it can find the
>>> auxclk when requesting it with the dev entry?
>>>
>>
>> which clock is mapped to which PHY device depends on board design
>> and that cannot be per-determined at one place. This information
>> needs to come from the board.dts file.
> 
> OK that makes sense.
>  
>> There was an earlier attempt to provide a way of building clock aliases
>> at runtime from device tree [1], but the current approach is way better
>>
>> [1]
>> https://lkml.org/lkml/2013/3/12/241
>>
>>> For the DT clock driver if needed for v3.10, how about just do a
>>> minimal drivers/clock/omap/ that uses the standard binding?
>>> Then that driver can just do clk_get() from cclock44xx_data.c
>>
>> I don't understand how to do it and why it is better than the current
>> approach.
> 
> Well your approach is fine as a first step moving all the clock
> code, but it needs to be a real driver under drivers/clock/omap.
> And the DT binding needs to stay the same for the driver(s) in the
> long term as we start moving clocks to DT + /lib/firmware.

The code needs to be there were the clock structs are defined.
Currently they are in arch/arm/mach-omap2/cclock44xx_data.c for OMAP4.

> 
> If this all is too late for v3.10, I suggest you just set up the
> right clock alias for panda with machine_is_compatible flag in
> board-generic.c so we get EHCI working with DT for v3.10. Then
> it's easy to to deal with it properly for v3.11.

OK, let's do it this way for Panda for 3.10.

> 
>> How can that driver do clk_get() from cclock44xx_data.c?
>> from where does it get the clk_id to pass into clk_get()?
> 
> Can't you just use the clock name there to get it?

In device tree we don't pass around clock names. You can either get
a phandle or an index to the clock.

e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt

>  
>>> for now? And then later on we'll just move all the clocks to a
>>> combination of DT + /lib/firmware.
>>
>> What is the benefit of moving clock data to /lib/firmware? We could
>> as well just move it to DT only, no?
> 
> DT only clocks option is naturally available with this too. It
> just gets easily inefficient with such a huge number of clocks.
>  

OK.
>>>> e.g. auxclk are required to be specified in DT nodes for USB PHY.
>>>> Without this we can't get USB host working on Panda.
>>>
>>> OK. So if the USB PHY has a dev entry, can't you just set up a
>>> clock alias in struct omap_clk omap44xx_clks[] for it?
>>
>> I've explained why this can't be done above.
> 
> Yes I understand now, the clock is board specific. 
>   
>>>> As Rajendra points out, it seems moving entire clock data to DT is not
>>>> going to happen soon. So this is the simplistic way things can work.
>>>
>>> Right but seems like we can get started there without moving
>>> them all at once.
>>>
>> What if we provide a complete clock list instead of only auxclks in
>> dt_clks[]?
>>
>> This approach is similar to arch/arm/mach-imx/clk-imx35.c
>>
>> Device drivers can then use them as they migrate to DT. Then later
>> we could migrate clock data to DT, without impacting device drivers.
> 
> As long as the binding stays the same in the long run too, this
> clock remapping approach is just fine as a starting point. And
> the driver needs to go to drivers/clock/omap. But in the long run
> we just want to get the huge amounts static data out of the kernel
> for clocks and hwmod data to fix things for good.

In that case we need to identify what clocks need to be supported.
If it is all (~200) of them, is this method good enough?

cheers,
-roger
