Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaKSBHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:07:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:47215 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaKSBHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:07:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,413,1413270000"; 
   d="scan'208";a="639366224"
Message-ID: <546BED38.9030707@linux.intel.com>
Date: Wed, 19 Nov 2014 09:07:04 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v2 02/13] irqchip: GICv3: Convert to domain hierarchy
References: <1416336788-22634-1-git-send-email-marc.zyngier@arm.com> <1416336788-22634-3-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1416336788-22634-3-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/19 2:52, Marc Zyngier wrote:
> In order to start supporting stacked domains, convert the GICv3
> code base to the new domain hierarchy framework, which mostly
> amounts to supporting the new alloc/free callbacks.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/Kconfig      |  1 +
>  drivers/irqchip/irq-gic-v3.c | 42 +++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..4631685 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -14,6 +14,7 @@ config ARM_GIC_V3
>  	bool
>  	select IRQ_DOMAIN
>  	select MULTI_IRQ_HANDLER
> +	select IRQ_DOMAIN_HIERARCHY
>  
>  config ARM_NVIC
>  	bool
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index aa17ae8..aef4b9e 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -594,14 +594,14 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  	/* PPIs */
>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_percpu_devid_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_percpu_devid_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	}
>  	/* SPIs */
>  	if (hw >= 32 && hw < gic_data.irq_nr) {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_fasteoi_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_fasteoi_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  	}
>  	irq_set_chip_data(irq, d->host_data);
> @@ -633,9 +633,41 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>  	return 0;
>  }
>  
> +static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs, void *arg)
> +{
> +	int i, ret;
> +	irq_hw_number_t hwirq;
> +	unsigned int type = IRQ_TYPE_NONE;
> +	struct of_phandle_args *irq_data = arg;
> +
> +	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
> +				   irq_data->args_count, &hwirq, &type);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < nr_irqs; i++)
> +		gic_irq_domain_map(domain, virq + i, hwirq + i);
> +
> +	return 0;
> +}
> +
> +static void gic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
> +				unsigned int nr_irqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		irq_set_handler(virq + i, NULL);
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
Please try irq_domain_reset_irq_data() :)

> +	}
> +}
> +
> +
>  static const struct irq_domain_ops gic_irq_domain_ops = {
> -	.map = gic_irq_domain_map,
>  	.xlate = gic_irq_domain_xlate,
> +	.alloc = gic_irq_domain_alloc,
> +	.free = gic_irq_domain_free,
>  };
>  
>  static int __init gic_of_init(struct device_node *node, struct device_node *parent)
> 
