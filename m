Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaLCTEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:04:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44263 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:04:39 -0500
Message-ID: <547F5EBD.6040705@arm.com>
Date: Wed, 03 Dec 2014 19:04:29 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, Thomas Gleixner <tglx@linutronix.de>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops
 conditional
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-4-git-send-email-stefan@agner.ch> <5174649.NxPq80uDz8@wuerfel> <alpine.DEB.2.11.1412031303000.16275@nanos> <8eccedc781df2636a132dae449cbe774@agner.ch>
In-Reply-To: <8eccedc781df2636a132dae449cbe774@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On 03/12/14 17:28, Stefan Agner wrote:
> On 2014-12-03 14:04, Thomas Gleixner wrote:
>> On Wed, 3 Dec 2014, Arnd Bergmann wrote:
>>
>>> On Wednesday 03 December 2014 01:12:02 Stefan Agner wrote:
>>>> The inline function register_routable_domain_ops is only usable if
>>>> CONFIG_ARM_GIC is set. Make it depend on this configuration. This
>>>> also allows other SoC interrupt controller to provide such a
>>>> function.
>>>>
>>>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>>>
>>> I don't think this is a good idea: either the interface is meant
>>> to be generic and should work with any interrupt controller, or
>>> it is specific to one irqchip and another irqchip should provide
>>> a different interface that has a nonconflicting name.
>>>
>>> I suppose you want the latter here, given that the declaration
>>> is part of the gic specific header file.
>>
>> That routable_domain stuff should have never been invented. In
>> hindsight we should have done the stacked irq domains back then
>> already, but in hindsight ...
> 
> I must admit that my first implementation even used arch_extn (through

I'm glad I didn't see that! ;-)

> the mask/unmask stuff). Then I saw the routable domain stuff, which
> looked more like a fit. But when I realized that only GIC has support
> for that, I soon realized that this might either need a proper
> framework... my hackish NVIC extension probably won't be acceptable...
> 
> Stack-able IRQ domain sounds like exactly what I was looking for...

Like Thomas said, we should have had that ages ago. It solves so many
problems in one go it's mind-boggling. On the down side, we end-up
refactoring *a lot* of the existing code...

>>
>> If you look at the crossbar scheme what we have now:
>>
>>    GIC domain
>> |--------------|
>> |              |---------- private
>> | non routable |---------- peripheral
>> |              |---------- peripheral
>> |              |
>> |--------------|
>> |              |---------- peripheral
>> |   routable   |---------- peripheral
>> |    |         |---------- peripheral
>> |--------------|
>>      |               |----------------|
>>      |-------------->| crossbar magic |
>>                      |----------------|
>>
>> which is not how the hardware looks. The hardware actually looks like
>> this:
>>
>>    GIC domain
>> |--------------|
>> |              |---------- private
>> | non routable |---------- peripheral
>> |              |---------- peripheral
>> |              |
>> |--------------|           |--------------|
>> |              |           |              |---------- peripheral
>> |   routable   |-----------| crossbar     |---------- peripheral
>> |              |           | domain       |---------- peripheral
>> |--------------|           |--------------|
>>
>> So it is completely obvious that the peripheral interrupts which need
>> to be routed through the crossbar belong to a different domain. We
>> really should convert crossbar to that scheme and get rid of the
>> routable domain stuff completely.
>>
>> With vybrid thats not different according to the diagram in the
>> reference manual.
>>
>>   GIC domain
>> |--------------|
>> |              |---------- private
>> | non routable |---------- peripheral
>> |              |---------- peripheral
>> |              |
>> |--------------|           |--------------|
>> |              |           |              |
>> |   routable   |-----------|  IRQ router  |
>> |              |           |  domain      |
>> |              |           |              |
>> |--------------|           |--------------|
>>                            | Shared state |---------- CPU to CPU 
>>   NVIC domain              | and hardware |---------- peripheral
>> |--------------|           |              |---------- peripheral
>> |              |           |--------------|
>> |              |           |              |
>> |   routable   |-----------|  IRQ router  |
>> |              |           |  domain      |
>> |              |           |              |
>> |--------------|           |--------------|
>> |              |
>> |              |---------- private
>> | non routable |---------- peripheral
>> |              |---------- peripheral
>> |--------------|
>>
>> The routable domain stuff is just an adhoc redirector which must be
>> tied to a particular base irq chip implementation (i.e. GIC). With
>> stacked irq domains there is no dependency on the underlying irq
>> chip. No ifdeffery, nothing. So you can use the same router domain
>> implementation for both the A5 and the M4 side.
>>
>> On the A5 side the router domain has the gic domain as parent and on
>> the M4 side the nvic domain.
>>
>> The shared interrupts are allocated through the router domain which
>> decides whether the interrupt can be assigned to a particular core or
>> not. If it can be assigned it allocates the corresponding interrupt in
>> the parent domain, sets up the routing and everything just works.
> 
> What do you mean by the shared state in the drawing above? Currently, I
> check whether a interrupt is already used by the other core by reading
> the register (do this configuration register reflect the "shared state"
> in your drawing?).

I think that is basically it. It should only be the register that
decides on the actual routing. BTW, how do you arbitrate between
concurrent accesses to this register? Or is only the A5 allowed to
change it?

> 
>>
>> See:
>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain-arm
>>
> 
> Thanks for the link. So my work would involve to support domain
> hierarchy for NVIC (proper irq_domain_ops, introduce arm,routable-irqs
> property, anything else?) and then make use of the hierarchy code in my
> MSCM driver like for instance the mtk-sysirq driver...?

I don't think we need the arm,routable-irq property at all, and I'm
looking at refactoring the crossbar thingy to remove most of its
entanglement with the GIC.

All you need to know is the range of interrupts you're allowed to
request through the "routable" domain. The inner-most irqchip shouldn't
even know about it (after all, they are just wires coming in). It should
be the duty of the outer-most irqchip (the "router") to generate the
correct request to the GIC/NVIC. So all the knowledge should be at the
router level.

The mtk-sysrq code is indeed a good example of what you can do.

> What is the state of the IRQ domain hierarchy, when will it go upstream?

Scheduled for 3.19, if everything goes according to plan. Don't think we
can go back anyway... ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
