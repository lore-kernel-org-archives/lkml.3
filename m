Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaKSHhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:37:47 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32918 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaKSHhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:37:45 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit\@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu \(Abel\)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v2 02/13] irqchip: GICv3: Convert to domain hierarchy
In-Reply-To: <546BED38.9030707@linux.intel.com> (Jiang Liu's message of "Wed,
	19 Nov 2014 01:07:04 +0000")
Organization: ARM Ltd
References: <1416336788-22634-1-git-send-email-marc.zyngier@arm.com>
	<1416336788-22634-3-git-send-email-marc.zyngier@arm.com>
	<546BED38.9030707@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Wed, 19 Nov 2014 07:37:33 +0000
Message-ID: <86h9xv8wua.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2014 at 01:07:04 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> On 2014/11/19 2:52, Marc Zyngier wrote:
>> In order to start supporting stacked domains, convert the GICv3
>> code base to the new domain hierarchy framework, which mostly
>> amounts to supporting the new alloc/free callbacks.
>> 
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/Kconfig      |  1 +
>>  drivers/irqchip/irq-gic-v3.c | 42 +++++++++++++++++++++++++++++++++++++-----
>>  2 files changed, 38 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
>> index b21f12f..4631685 100644
>> --- a/drivers/irqchip/Kconfig
>> +++ b/drivers/irqchip/Kconfig
>> @@ -14,6 +14,7 @@ config ARM_GIC_V3
>>  	bool
>>  	select IRQ_DOMAIN
>>  	select MULTI_IRQ_HANDLER
>> +	select IRQ_DOMAIN_HIERARCHY
>>  
>>  config ARM_NVIC
>>  	bool
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index aa17ae8..aef4b9e 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c

[...]

>> @@ -633,9 +633,41 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>>  	return 0;
>>  }
>>  
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
>> +		gic_irq_domain_map(domain, virq + i, hwirq + i);
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
> Please try irq_domain_reset_irq_data() :)

Ah, nice shortcut. I'll update this for v3.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
