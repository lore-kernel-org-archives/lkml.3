Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3JHPvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:51:51 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:65205 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3JHPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:51:34 -0400
Message-ID: <52542A00.5090808@gmail.com>
Date: Tue, 08 Oct 2013 17:51:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] irqchip: add DesignWare APB ICTL interrupt controller
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-2-git-send-email-sebastian.hesselbarth@gmail.com> <20131008132421.GC1412@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131008132421.GC1412@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 03:24 PM, Mark Rutland wrote:
> On Tue, Oct 08, 2013 at 01:24:26PM +0100, Sebastian Hesselbarth wrote:
>> This adds an irqchip driver and corresponding devicetree binding for the
>> secondary interrupt controllers based on Synopsys DesignWare IP dw_apb_ictl.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
[...]
>> diff --git a/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
>> new file mode 100644
>> index 0000000..7ccd1ba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
>> @@ -0,0 +1,29 @@
>> +Synopsys DesignWare APB interrupt controller (dw_apb_ictl)
>> +
>> +Synopsys DesignWare provides interrupt controller IP for APB known as
>> +dw_apb_ictl. The IP is used as secondary interrupt controller in some SoCs with
>> +APB bus, e.g. Marvell Armada 1500.
>> +
>> +Required properties:
>> +- compatible: shall be "snps,dw-apb-ictl"
>> +- reg: base address of interrupt registers starting with ENABLE_LOW register
>
> Is ENABLE_LOW the first register? Or are there registers before?

ENABLE_LOW is the first register.

> Is there only one bank of registers that needs to be defined?

The u-boot sources which this driver is based on have registers from
0x00 to 0xe0. So, yes it is one register block.

> This isn't just a base address, as it has a size too. The terminology's
> rather inconsistent for reg properties in general...

Ok, I will reword the reg related property descriptions.

>> +- interrupt-controller: identifies the node as an interrupt controller
>> +- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
>
> s/interrupt source/interrupt-specifier/

Ok.

>> +- interrupts: interrupt reference to primary interrupt controller
>
> - interrupts: interrupts specifier for the sole interrupt fed to the
>                parent interrupt controller.
>
> Is there only a single output interrupt?

At least for the SoC I am working with, yes.

> Is this required? Is it possible for this to be wired directly into a
> CPU rather than another interrupt controller?

Again, possible.

In general, for me it is impossible to foresee all possible scenarios
where this DW (!) IP is used in. Based on my current knowledge, this IP
is a secondary interrupt controller with 2-64 normal IRQs and one
upstream irq, FIQs are optional.

Synopsys website isn't a real chatterbox about their IP, googling
"dw_apb_ictl" gives e.g. [1]

[1] 
http://kona.ee.pitt.edu/socvlsi/lib/exe/fetch.php?media=dw_digital_ip_quickref.pdf

>> +- interrupt-parent: (optional) reference specific primary interrupt controller
>> +
>> +The interrupt sources map to the corresponding bits in the interrupt
>> +registers, i.e.
>> +- 0 maps to bit 0 of low interrupts,
>> +- 1 maps to bit 1 of low interrupts,
>> +- 32 maps to bit 0 of high interrupts, and so on.
>
> I couldn't see any public documentation for this, so I can't really
> follow the "and so on", but I saw that this had optional FIQ support so
> I assume there are more interrupt values that can be encoded?

Well, there is no public documentation.

As there can be 2-64 normal IRQs, I have chosen to number them according
to their bit position, starting with lower register bit 0 as hwirq 0.
Bit 0 of higher register gives hwirq 32 "and so on".

If FIQs are configured on a specific irq controller, that may give more
than 64 normal IRQs. If someone ever finds this IP with FIQs enabled,
I suggest to put them on 64+n. According to [1], it allows 1-8 optional
FIQs.

>> +Example:
>> +	aic: interrupt-controller@3000 {
>> +		compatible = "snps,dw-apb-ictl";
>> +		reg = <0x3000 0xc00>;
>> +		interrupt-controller;
>> +		#interrupt-cells = <1>;
>> +		interrupt-parent = <&gic>;
>> +		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
>> +	};
[...]
>> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
>> new file mode 100644
>> index 0000000..bbcacee
>> --- /dev/null
>> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
>> @@ -0,0 +1,142 @@
>> +/*
>> + * Synopsys DW APB ICTL irqchip driver.
>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + *
>> + * based on GPL'ed 2.6 kernel sources
>> + *  (c) Marvell International Ltd.
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
[...]
>> +static int __init dw_apb_ictl_init(struct device_node *np,
>> +				   struct device_node *parent)
>> +{
>> +	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
>> +	struct resource r;
>> +	struct irq_domain *domain;
>> +	struct irq_chip_generic *gc;
>> +	void __iomem *iobase;
>> +	int ret, nrirqs, irq;
>> +	u32 reg;
>> +
>> +	/* Map the parent interrupt for the chained handler */
>> +	irq = irq_of_parse_and_map(np, 0);
>> +	if (irq <= 0) {
>> +		pr_err("%s: unable to parse irq\n", np->name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = of_address_to_resource(np, 0, &r);
>> +	if (ret) {
>> +		pr_err("%s: unable to get resource\n", np->name);
>> +		return ret;
>> +	}
>> +
>> +	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
>> +		pr_err("%s: unable to request mem region\n", np->name);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	iobase = ioremap(r.start, resource_size(&r));
>> +	if (!iobase) {
>> +		pr_err("%s: unable to map resource\n", np->name);
>> +		return -ENOMEM;
>> +	}
>
> Could you not use of_iomap?

Sure, but - correct me if I am wrong - while of_iomap just translates
and maps the resource, the above additionally protects the resource
from others mapping it.

> Also, I'd recommend using np->full_name for error messages, as that
> gives you the full path for the node, which is far more helpful for
> debugging than just the unqualified node name.

Ok.

>> +
>> +	/*
>> +	 * DW IP can be configured to allow 2-64 irqs. We can determine
>> +	 * the number of irqs supported by writing into enable register
>> +	 * and look for bits not set, as corresponding flip-flops will
>> +	 * have been removed by sythesis tool.
>> +	 */
>
> Is that always true?

 From my personal experience with hardware description and synthesis
tools, I'd say "yes, it is always true".

Even if it is not true, you register some irqs more than neccessary
and those will never trigger. What you know is, this number will never
be less than the real number of irqs supported.

Usually, for DW IP the number of configured features is somewhere in
the IPs registers. But without any documentation it is really not that
easy to guess the meaning of those bits.

Sebastian
