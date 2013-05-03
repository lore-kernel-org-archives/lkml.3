Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257Ab3ECNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:13:26 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43193 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356Ab3ECNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:13:24 -0400
Message-ID: <5183B7ED.7030800@gmail.com>
Date: Fri, 03 May 2013 15:13:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130503125527.GE18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130503125527.GE18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 14:55, Russell King - ARM Linux wrote:
> On Fri, May 03, 2013 at 01:48:35AM +0200, Sebastian Hesselbarth wrote:
>> This patch adds an irqchip driver for the main interrupt controller found
>> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
>> Corresponding device tree documentation is also added.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Note: This patch triggers a checkpatch warning for
>>    WARNING: Avoid CamelCase: <handle_IRQ>
>>
>> Changelog:
>> v1->v2:
>> - rename compatible string to "marvell,orion-intc" (Suggested by Jason Gunthorpe)
>> - request mem regions for irq base registers (Suggested by Jason Gunthorpe)
>> - make orion_handle_irq static (Suggested by Jason Gunthorpe)
>> - make use of IRQCHIP_DECLARE (Suggested by Jason Gunthorpe)
>
> It would still be a good idea to convert this to use the generic chip
> stuff which Thomas created, though exactly how is hard to see at the
> moment.

Russel,

that is the plan and that's why the whole patch set is preliminary.
Maybe it would have been more precise to call it RFC instead.

>> +static void orion_irq_mask(struct irq_data *irqd)
>> +{
>> +	unsigned int irq = irqd_to_hwirq(irqd);
>> +	unsigned int irq_off = irq % 32;
>> +	int reg = irq / 32;
>> +	u32 val;
>> +
>> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
>> +	writel(val & ~(1 << irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
>> +}
>
> This could be replaced with irq_gc_mask_clr_bit().
>
>> +
>> +static void orion_irq_unmask(struct irq_data *irqd)
>> +{
>> +	unsigned int irq = irqd_to_hwirq(irqd);
>> +	unsigned int irq_off = irq % 32;
>> +	int reg = irq / 32;
>> +	u32 val;
>> +
>> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
>> +	writel(val | (1 << irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
>> +}
>
> This with irq_gc_mask_set_bit().
>
>> +
>> +static struct irq_chip orion_irq_chip = {
>> +	.name		= "orion_irq",
>> +	.irq_mask	= orion_irq_mask,
>> +	.irq_unmask	= orion_irq_unmask,
>> +};
>> +
>> +static int orion_irq_map(struct irq_domain *d, unsigned int virq,
>> +			 irq_hw_number_t hw)
>> +{
>> +	irq_set_chip_and_handler(virq, &orion_irq_chip,
>> +				 handle_level_irq);
>> +	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
>
> This is where it starts to get tricky, because I can't see how you'd
> merge the irq_alloc_generic_chip() and irq_setup_generic_chip() with
> this.  Maybe you don't need to do anything here and just do all that
> in orion_of_init() instead?  But then you seem to need to know the
> virq range before hand, and I can't see how that's known.  Maybe Thomas
> can provide some enlightenment about how the gc irqchip stuff works
> with the irq domain stuff...

Exactly, and that is what I am looking into right now. But hell, I am
not an expert in linux irq yet. Moreover, I am not even sure if it is
okay to rely on irqdomain or at least irq_data->hw_irq at all.

My current impression is, that generic chip knowns nothing about irq
domains. But my first modification of it was to use irqd_to_hwirq(d)
where ever it uses d->irq instead. This should allow to abstract from
virtual irqs and retain compatibility (_if_ hw_irq is also set on
!CONFIG_IRQ_DOMAIN).

To add more juice: IRQF_VALID and IRQF_PROBE are ARM only flags. I
tried to find out what they are good for, but stopped googl'ing after
a while. (I know you explained that before somewhere)

> However, you wouldn't need the statically defined orion_irq_chip nor
> orion_irq_base[] either, because those would be held within the gc
> irqchip stuff and stored in the upper layer.

Yeah, that would be very nice. But the current limitation to one
register set with max 32 irqs of generic chip would still require to
keep a list of primary generic irq chips to flip through in the
irq_handler.

This also raises the question, how to check if an generic irq chip
flow handler has to be called. Current irq_chip_regs don't know nothing
about a cause/status register. And actually you don't even know if it
is high/low active and how to mask it with the high/low active mask
register or mask_cache.

Sebastian

