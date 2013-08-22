Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3HVNqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:46:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56941 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3HVNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:46:46 -0400
Message-ID: <5216160D.5000308@ti.com>
Date: Thu, 22 Aug 2013 09:45:49 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com> <51EFFBE1.4090505@ti.com> <51F0031B.1050307@ti.com> <51F00530.9090703@ti.com> <51F02069.3050207@ti.com> <51F0223E.4050008@ti.com> <51F0240F.3050507@ti.com> <20130813081003.GU7656@atomide.com> <520A02BA.4090805@ti.com> <CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com> <520D398D.9040806@ti.com> <CACRpkdYeo1y-HhftkRWgwyq8o-NVuJ978Uq+ON880LHhUxC=hg@mail.gmail.com> <520D44C5.6080205@ti.com> <CACRpkdagSHxzV3=427O9iftNxM+N=w9aPds=iDvGQPoG3H-cWw@mail.gmail.com> <5215F6F6.9060703@ti.com>
In-Reply-To: <5215F6F6.9060703@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 August 2013 07:33 AM, Sricharan R wrote:
> Hi Linus,
> 
> On Thursday 22 August 2013 02:40 AM, Linus Walleij wrote:
>> On Thu, Aug 15, 2013 at 11:14 PM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>> On Thursday 15 August 2013 04:51 PM, Linus Walleij wrote:
>> (...)
>>>> Sorry I don't understand what thread that is... can you point me there?
>>>> My previous statement on this issue what this:
>>>> http://marc.info/?l=linux-kernel&m=137442541628641&w=2
>> (...)
>>>>> I don't see how you can make this happen with an irqchip
>>>>> infrastructure.
>>>> I think my post above describes this.
>>>>
>>> Sorry for being dumb but I don't think cascaded irqchip examples
>>> like GPIO and cross-bars are same. If you take an example of
>>> GPIO irqchip, it always have a physical connection even if it
>>> is 1 IRQ line for (32 logical/sparse IRQs). That goes with
>>> other MFD examples too.
>>>
>>> So may be I am still missing something in your proposal.
>> Why does it matter if it is a GPIO or MFD or whatever?
>> The point is that the IRQ line passes thru something else,
>> and this we model as an irqdomain.
>>
>> Anyway here is a silicon cascaded IRQ chip:
>> arch/arm/mach-versatile/core.c
>> See versatile_init_irq():
>>
>> __vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0, np);
>> (...)
>> fpga_irq_init(VA_SIC_BASE, "SIC", IRQ_SIC_START,
>>                 IRQ_VICSOURCE31, PIC_VALID, np);
>>
>> The VIC in the versatile has the SIC cascaded from one of
>> its IRQ lines. Both the VIC and SIC (fpga IRQ) are
>> using irqdomains so the SIC spawns a child irqdomain
>> from IRQ 31 (last IRQ) of the VIC.
>  Ok, this is a typical example of irqchip cascaded.
>> The difference with a crossbar is that it can software-config
>> which IRQ goes where, and does not have a callback
>> to clear interrupts or anything like that, it just passes them
>> thru. But it is best modeled as an irqdomain IMO.
> We can model crossbar as irqchip and gic as its interrupt parent
> and peripherals to have crossbar as interrupt-parent.
>    
>  peripherals will do request_irq(crossbar_number)
>               |
>               |
>  crossbar_unmask()
>               |
>               |
>  maps crossbar number<->  to interrupt number and
>  calls request_irq(int_no, crossbar_handler,..)
> 
>  
>  crossbar_handler(interrupt number)
>             |
>             |
>  get crossbar number from interrupt number
>             |
>             |
>  handle_irq(crossbar_domain(crossbar number))
>                                                                              
> 
> So this means a extra dummy handler.
Its not optimal to go through the dummy call stack on
fast path but considering its not going to eat too many
instructions, its fine to have dummy handler. We should
try this out.

> Also the concern is by modelling it as irqchip, we will have
> to find a different solution for DMA crossbar.
> 
DMAEngine has a notion of logical channel and that was actually
used in the EDMA support series by Matt [1]
We can do something similar to handle that scenario.


[1] https://lkml.org/lkml/2013/6/18/56

