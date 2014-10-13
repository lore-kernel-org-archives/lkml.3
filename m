Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaJMJZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:25:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46500 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaJMJZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:25:35 -0400
Message-ID: <543B9A87.4050204@arm.com>
Date: Mon, 13 Oct 2014 10:25:27 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Joe.C" <yingjoe.chen@mediatek.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sricharan R <r.sricharan@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-4-git-send-email-yingjoe.chen@mediatek.com> <543B93B4.3040404@arm.com>
In-Reply-To: <543B93B4.3040404@arm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Oct 2014 09:25:29.0594 (UTC) FILETIME=[A14AADA0:01CFE6C7]
X-MC-Unique: 114101310253202701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/14 09:56, Marc Zyngier wrote:
> On 09/10/14 15:29, Joe.C wrote:
>> From: "Joe.C" <yingjoe.chen@mediatek.com>
>>
>> Add support to use gic as a parent for stacked irq domain.
>>
>> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
>> ---
>>  drivers/irqchip/irq-gic.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 48 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index dda6dbc..17f5aa6 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -767,19 +767,17 @@ void __init gic_init_physaddr(struct device_node *node)
>>  static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>>  				irq_hw_number_t hw)
>>  {
>> +	irq_domain_set_hwirq_and_chip(d, irq, hw, &gic_chip, d->host_data);
>>  	if (hw < 32) {
>>  		irq_set_percpu_devid(irq);
>> -		irq_set_chip_and_handler(irq, &gic_chip,
>> -					 handle_percpu_devid_irq);
>> +		irq_set_handler(irq, handle_percpu_devid_irq);
>>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>>  	} else {
>> -		irq_set_chip_and_handler(irq, &gic_chip,
>> -					 handle_fasteoi_irq);
>> +		irq_set_handler(irq, handle_fasteoi_irq);
>>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>>  
>>  		gic_routable_irq_domain_ops->map(d, irq, hw);
>>  	}
>> -	irq_set_chip_data(irq, d->host_data);
>>  	return 0;
>>  }
>>  
>> @@ -795,8 +793,6 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>>  {
>>  	unsigned long ret = 0;
>>  
>> -	if (d->of_node != controller)
>> -		return -EINVAL;
>>  	if (intsize < 3)
>>  		return -EINVAL;
>>  
>> @@ -839,6 +835,46 @@ static struct notifier_block gic_cpu_notifier = {
>>  };
>>  #endif
>>  
>> +
>> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
>> +static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
>> +				unsigned int nr_irqs, void *arg)
>> +{
>> +	int i, ret;
>> +	irq_hw_number_t hwirq;
>> +	unsigned int type = IRQ_TYPE_NONE;
>> +	struct of_phandle_args *irq_data = arg;
>> +
>> +	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
>> +				   irq_data->args_count, &hwirq, &type);
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (i = 0; i < nr_irqs; i++)
>> +		gic_irq_domain_map(domain, virq+i, hwirq+i);
>> +
>> +	return 0;
>> +}
>> +
>> +static void gic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
>> +				unsigned int nr_irqs)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < nr_irqs; i++) {
>> +		irq_set_handler(virq + i, NULL);
>> +		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
>> +	}
>> +}
>> +
>> +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
>> +	.alloc = gic_irq_domain_alloc,
>> +	.free = gic_irq_domain_free,
>> +};
>> +#else
>> +#define gic_irq_domain_hierarchy_ops 0
>> +#endif /* CONFIG_IRQ_DOMAIN_HIERARCHY */
>> +
>>  static const struct irq_domain_ops gic_irq_domain_ops = {
>>  	.map = gic_irq_domain_map,
>>  	.unmap = gic_irq_domain_unmap,
>> @@ -952,7 +988,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>  
>>  	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
>>  
>> -	if (of_property_read_u32(node, "arm,routable-irqs",
>> +	if (IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) &&
>> +		of_find_property(node, "arm,irq-domain-hierarchy", NULL))
>> +		gic->domain = irq_domain_add_linear(node, gic_irqs,
>> +					&gic_irq_domain_hierarchy_ops, gic);
>> +	else if (of_property_read_u32(node, "arm,routable-irqs",
>>  				 &nr_routable_irqs)) {
>>  		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
>>  					   numa_node_id());
>>
> 
> So I've been playing with this over the weekend (with quite a few
> tweaks), and I'm hitting a not-so-nice effect of the automatic platform
> device creation from the device tree.
> 
> What happens is the following:
> - Kernel starts
> - GIC gets initialized with a linear domain supporting hierarchy
> - per-cpu timers are up and running
> - platform devices get created from the device tree:
>   - irq_of_parse_and_map()
>   - irq_create_of_mapping()
>   - irq_domain_alloc_irqs()
> 
> Here, we start re-allocating interrupts that have already been allocated
> (the timer interrupts). This has a side effect of nuking the
> percpu_dev_id, and everything explodes on the next timer tick. Grmbl.
> 
> The main issue here is that we have a single path that:
> - translates the interrupt from DT to HW
> - configures the interrupts
> and that we use it more than once.
> 
> The non-hierarchy path works because the the "map" operation takes place
> only once, and virtual interrupts are allocated upfront.
> 
> When we switch to this more dynamic way of doing things, the fact that
> the virqs only available at allocation time is screwing us up.
> 
> I can see a way out of this, which would involve having a way of
> detecting that a hwirq has already been allocated (which requires having
> the xlate callback instantiated). Something like this (not even
> compile-tested):
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index dd8d3ab..6a45821 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -479,6 +479,21 @@ unsigned int irq_create_of_mapping(struct
> of_phandle_args *irq_data)
>  	}
> 
>  	if (irq_domain_is_hierarchy(domain)) {
> +		if (domain->ops->xlate) {
> +			/*
> +			 * If we've already configured this interrupt,
> +			 * don't do it again, or hell will break loose.
> +			 */
> +			if (domain->ops->xlate(domain, irq_data->np,
> +					       irq_data->args,
> +					       irq_data->args_count,
> +					       &hwirq, &type))
> +				return 0;
> +
> +			virq = irq_find_mapping(domain, hwirq);
> +			if (virq)
> +				return virq;
> +		}
>  		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
>  		return virq <= 0 ? 0 : virq;
>  	}
> 
> Thoughts?

For the record, I just booted a pure DT system with the above patch, and
everything seems to be fine. Haven't completely convinced myself this is
the right fix though.

	M.
-- 
Jazz is not dead. It just smells funny...

