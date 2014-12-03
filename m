Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLCR02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:26:28 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:35167 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaLCR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:26:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Dec 2014 18:28:33 +0100
From: Stefan Agner <stefan@agner.ch>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, shawn.guo@linaro.org, kernel@pengutronix.de,
        Russell King <linux@arm.linux.org.uk>, u.kleine-koenig@pengutronix.de,
        Jason Cooper <jason@lakedaemon.net>, olof@lixom.net,
        daniel.lezcano@linaro.org, mark.rutland@arm.com, pawel.moll@arm.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/12] irqchip: gic: define =?UTF-8?Q?register=5Frouta?=
 =?UTF-8?Q?ble=5Fdomain=5Fops=20conditional?=
In-Reply-To: <alpine.DEB.2.11.1412031303000.16275@nanos>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <1417565531-4507-4-git-send-email-stefan@agner.ch>
 <5174649.NxPq80uDz8@wuerfel> <alpine.DEB.2.11.1412031303000.16275@nanos>
Message-ID: <8eccedc781df2636a132dae449cbe774@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec  3 18:25:50 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547f479e12811119093646
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 14:04, Thomas Gleixner wrote:
> On Wed, 3 Dec 2014, Arnd Bergmann wrote:
> 
>> On Wednesday 03 December 2014 01:12:02 Stefan Agner wrote:
>> > The inline function register_routable_domain_ops is only usable if
>> > CONFIG_ARM_GIC is set. Make it depend on this configuration. This
>> > also allows other SoC interrupt controller to provide such a
>> > function.
>> >
>> > Signed-off-by: Stefan Agner <stefan@agner.ch>
>>
>> I don't think this is a good idea: either the interface is meant
>> to be generic and should work with any interrupt controller, or
>> it is specific to one irqchip and another irqchip should provide
>> a different interface that has a nonconflicting name.
>>
>> I suppose you want the latter here, given that the declaration
>> is part of the gic specific header file.
> 
> That routable_domain stuff should have never been invented. In
> hindsight we should have done the stacked irq domains back then
> already, but in hindsight ...

I must admit that my first implementation even used arch_extn (through
the mask/unmask stuff). Then I saw the routable domain stuff, which
looked more like a fit. But when I realized that only GIC has support
for that, I soon realized that this might either need a proper
framework... my hackish NVIC extension probably won't be acceptable...

Stack-able IRQ domain sounds like exactly what I was looking for...

> 
> If you look at the crossbar scheme what we have now:
> 
>    GIC domain
> |--------------|
> |              |---------- private
> | non routable |---------- peripheral
> |              |---------- peripheral
> |              |
> |--------------|
> |              |---------- peripheral
> |   routable   |---------- peripheral
> |    |         |---------- peripheral
> |--------------|
>      |               |----------------|
>      |-------------->| crossbar magic |
>                      |----------------|
> 
> which is not how the hardware looks. The hardware actually looks like
> this:
> 
>    GIC domain
> |--------------|
> |              |---------- private
> | non routable |---------- peripheral
> |              |---------- peripheral
> |              |
> |--------------|           |--------------|
> |              |           |              |---------- peripheral
> |   routable   |-----------| crossbar     |---------- peripheral
> |              |           | domain       |---------- peripheral
> |--------------|           |--------------|
> 
> So it is completely obvious that the peripheral interrupts which need
> to be routed through the crossbar belong to a different domain. We
> really should convert crossbar to that scheme and get rid of the
> routable domain stuff completely.
> 
> With vybrid thats not different according to the diagram in the
> reference manual.
> 
>   GIC domain
> |--------------|
> |              |---------- private
> | non routable |---------- peripheral
> |              |---------- peripheral
> |              |
> |--------------|           |--------------|
> |              |           |              |
> |   routable   |-----------|  IRQ router  |
> |              |           |  domain      |
> |              |           |              |
> |--------------|           |--------------|
>                            | Shared state |---------- CPU to CPU 
>   NVIC domain              | and hardware |---------- peripheral
> |--------------|           |              |---------- peripheral
> |              |           |--------------|
> |              |           |              |
> |   routable   |-----------|  IRQ router  |
> |              |           |  domain      |
> |              |           |              |
> |--------------|           |--------------|
> |              |
> |              |---------- private
> | non routable |---------- peripheral
> |              |---------- peripheral
> |--------------|
> 
> The routable domain stuff is just an adhoc redirector which must be
> tied to a particular base irq chip implementation (i.e. GIC). With
> stacked irq domains there is no dependency on the underlying irq
> chip. No ifdeffery, nothing. So you can use the same router domain
> implementation for both the A5 and the M4 side.
> 
> On the A5 side the router domain has the gic domain as parent and on
> the M4 side the nvic domain.
> 
> The shared interrupts are allocated through the router domain which
> decides whether the interrupt can be assigned to a particular core or
> not. If it can be assigned it allocates the corresponding interrupt in
> the parent domain, sets up the routing and everything just works.

What do you mean by the shared state in the drawing above? Currently, I
check whether a interrupt is already used by the other core by reading
the register (do this configuration register reflect the "shared state"
in your drawing?).


> 
> See:
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain-arm
> 

Thanks for the link. So my work would involve to support domain
hierarchy for NVIC (proper irq_domain_ops, introduce arm,routable-irqs
property, anything else?) and then make use of the hierarchy code in my
MSCM driver like for instance the mtk-sysirq driver...?

What is the state of the IRQ domain hierarchy, when will it go upstream?

--
Stefan


