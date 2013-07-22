Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab3GVQYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:24:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49168 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab3GVQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:23:57 -0400
Message-ID: <51ED5C66.1010407@ti.com>
Date: Mon, 22 Jul 2013 12:23:02 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>, Linus Walleij <linus.walleij@linaro.org>
CC: Nishanth Menon <nm@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-2-git-send-email-r.sricharan@ti.com> <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com>
In-Reply-To: <51ED2385.60108@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 July 2013 08:20 AM, Sricharan R wrote:
> Hi Linus,
> On Sunday 21 July 2013 10:19 PM, Linus Walleij wrote:
>> On Thu, Jul 18, 2013 at 8:56 PM, Nishanth Menon <nm@ti.com> wrote:
>>
>>> I carry forward my TI internal objection to this approach:
>> It is actually a very good sign of FOSS-maturity that you as a company
>> take unresolved architectural issues to the community. Kudos!
>>
>>> Lets see what happens as a result of this:
>>>
>>> https://patchwork.kernel.org/patch/2825148/ (introducing DTS for DRA7)
>>> uart1 to uart6 is defined. while in fact 10 uarts exist on IP block.
>>> uart1: serial@4806a000 {
>>> <snip>
>>> +                       interrupts = <0 72 0x4>;
>>> Assumes that GIC interrupt by default mapping used.
>> So introducing this inbetween the GIC lines and its actual device IRQ
>> lines inevitably means that the GIC three-cell concept is completely
>> ill-devised to handle this.
>>
>> For routing IRQs, I think the proper solution would be to use a
>> cascaded struct irqchip, which in turn contains an irqdomain
>> translation to remux the signal onto the GIC inputs.
>>
>> I.e. the interrupt-controller given to that serial would be the
>> crossbar irqchip, and that in turn will hog and allocate apropriate
>> lines from the gic to it would probably itself list *all* the IRQs
>> of the GIC as "its" IRQs.
>>
>> We already have plenty of cascading irqchips such as GPIO
>> controller providing IRQs, just that they only multiplex on a
>> single GIC line instead of the whole lot.
>>
>> Mock example:
>>
>>                 intc: interrupt-controller@0 {
>>                         compatible = "arm,cortex-a9-gic";
>>                         #interrupt-cells = <3>;
>>                         #address-cells = <1>;
>>                         interrupt-controller;
>>                         reg = ...;
>>                 };
>>
>>                 crossbar: crossbar@0 {
>>                         compatible = "...";
>>                         interrupt-controller;
>>                         #interrupt-cells = <1>;
>>                         interrupt-parent = <&intc>;
>>                         interrupts = <0 0 IRQ_TYPE_LEVEL_HIGH>,
>>                                           <0 1 IRQ_TYPE_LEVEL_HIGH>,
>>                                           <0 2 IRQ_TYPE_LEVEL_HIGH>,
>>                                           ....
>>                                           <0 n IRQ_TYPE_LEVEL_HIGH>;
>>                 };
>>
>>                 uart0: serial@0 {
>>                         compatible = "...";
>>                         interrupt-parent = <&crossbar>;
>>                         interrupts = <1234>;
>>                  };
>>
>> Maybe the interrupts provided from crossbar cannot even be
>> specified by a number, maybe a line name need to be used
>> or so. I don't know the particulars.
>>
>> Whether this as a whole is a good idea, I don't know,
>> but you would have to go about it something like this.
>>
>> What happens if there is no line to mux in a certain IRQ?
>  Thanks for this.
>  Was thinking of a similar kind of approach with irqchip.
>  But then, there was a GAP since crossbar does not have an irq unlike
>  other irqchips. But as you said  this can be done by setting the crossbar
>  to map and receive the GIC interrupts and then direct to devices.
>  Only thing is, this is fine for IRQs, and something different has to be done
>  for DMA crossbars  again. Also when we allocate dynamically here,
>  finding out a irq line when there is no free line is a question.
> 
>   With the other approach of using/extending  the pinctrl framework that you
>  gave, it is good to handle both irqs/dma.  I looked at the other example in
>  drivers/dma/amba-pl08x.c and i see that data is getting populated and passed
>  from the platform. I initially started with something similar, where the data
>  was passed statically from DT and a driver to use that.  So now it looks good
>  to extend the pinctrl fw. I will try a approach for that first and see how it looks.
> 
Right. Thats the reason its not a typical chained IRQChip like GPIO, MFD PMIC etc etc.
Those chips always has a primary interrupt line and then secondary interrupts which
are kind of controlled at SW level(secondary logical IRQs) using some common
registers.

Cross-bar is just a dummy hardware. The only interesting part from IRQ chip
or DMA subsystem is "request_irq" or "request_dma" look-up which happens
at driver probe ideally should be transparent and then program the appropriate
cross-bar mux for IRQ or DMA routing. The actual IRQ assertion reporting or ISR
execution etc all has to be handled by primary IRQ controller since the cross-bar
has no intelligence or IRQ controller like capability.

To summaries it again, what I understood from Sricharan's proposal,

- Setup all the routing at cross-bar probe so that kernel continue to
work like normal IRQ controller with cross-bar scope vanishes once
the routing is done. Cross-bar does this before any of the devices
are created.
- Something similar needs to happen for DMA lines as well or for any
other event routing in future.
- Cross-bar callbacks for device drivers for error paths.
(Sricharan, you have to drop these because it doesn't bring any
functionality and rather can create a side effects of drivers
getting polluted.)

The concern raised on above was instead of fixing the routing at DT
statically, doing at the driver probes where the loop-up for IRQ or DMA
lines should happen in background transparently on drivers call of
request_irq/request_dma_channel etc with cross-bar number as
an input to it. Though it will be nice to have
such feature, it doesn't bring anything special and brings the
notion of these APIs which expect that you know what IRQ and DMA
lines you want while calling these.

Note that mux inputs are pretty much fixed. Its his connection
to IRQ controller or DMA controller is what needs to be programmed.
So scope is pretty much limited. I felt this requirement is pretty
similar to pin-mux and hence thought of it as a viable option.

Having said all of above, if there is a better alternative than
enhanced pin-mux we surely can do that.

Regards,
Santosh 
















