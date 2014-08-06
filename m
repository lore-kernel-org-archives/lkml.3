Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaHFQBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:01:24 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34965 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751857AbaHFQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:01:23 -0400
Message-ID: <53E25149.5070604@arm.com>
Date: Wed, 06 Aug 2014 17:01:13 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Liu hua <sdu.liu@huawei.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@126.com" <liusdu@126.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH V2 1/1] GIC: introduce method to deactive interupts
References: <1407125860-37718-1-git-send-email-sdu.liu@huawei.com> <1407125860-37718-2-git-send-email-sdu.liu@huawei.com> <53DF55AC.5030705@arm.com> <53E1EACA.6070502@huawei.com> <53E1F96C.2030307@arm.com> <53E21D07.7070407@huawei.com>
In-Reply-To: <53E21D07.7070407@huawei.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 13:18, Liu hua wrote:
> On 2014/8/6 17:46, Marc Zyngier wrote:
>> Hi Liu,
>>
>> On 06/08/14 09:43, Liu hua wrote:
>>> 于 2014/8/4 17:43, Marc Zyngier 写道:
>>>> Hi Liu,
>>>>
>>>> On 04/08/14 05:17, Liu Hua wrote:
>>>>> When using kdump on ARM platform, if kernel panics in interrupt handler
>>>>> (maybe PPI), the capture kernel can not recive certain interrupt, and 
>>>>> fails to boot.
>>>>>
>>>>> On this situation, We have read register GICC_IAR. But we have no chance
>>>>> to write relative bit to register GICC_EOIR (kernel paniced before). So
>>>>> the state of this type interrupt remains active. And that makes gic not
>>>>> deliver this type interrupt to cpu interface.
>>>>>
>>>>> So we should not assume that all interrut states of GIC are inactive when
>>>>> kernel inittailize the GIC. This patch will identify these type interrupts
>>>>> and deactive them
>>>>>
>>>>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>>>>> ---
>>>>>  drivers/irqchip/irq-gic.c | 26 ++++++++++++++++++++++++++
>>>>>  1 file changed, 26 insertions(+)
>>>>>
>>>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>>>> index b2648fc..7708df1 100644
>>>>> --- a/drivers/irqchip/irq-gic.c
>>>>> +++ b/drivers/irqchip/irq-gic.c
>>>>> @@ -351,12 +351,37 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>>>>>  	return mask;
>>>>>  }
>>>>>  
>>>>> +void gic_eois(u32 active, int irq_off, void __iomem *cpu_base)
>>>>> +{
>>>>> +	int bit = -1;
>>>>> +
>>>>> +	for_each_set_bit(bit, (unsigned long *)&active, 32)
>>>>> +		writel_relaxed(bit + irq_off, cpu_base + GIC_CPU_EOI);
>>>>> +}
>>>>> +
>>>>> +void gic_dist_clear_active(void __iomem *dist_base,
>>>>> +			void __iomem *cpu_base, int gic_irqs)
>>>>> +{
>>>>> +	int irq, offset;
>>>>> +	u32 active;
>>>>> +
>>>>> +	for (irq = 0; irq < gic_irqs; irq += 32) {
>>>>> +		offset = GIC_DIST_ACTIVE_SET + irq * 4 / 32;
>>>>> +		active = readl_relaxed(dist_base + offset);
>>>>> +		if (!active)
>>>>> +			continue;
>>>>> +		gic_eois(active, irq, cpu_base);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +
>>>>>  static void __init gic_dist_init(struct gic_chip_data *gic)
>>>>>  {
>>>>>  	unsigned int i;
>>>>>  	u32 cpumask;
>>>>>  	unsigned int gic_irqs = gic->gic_irqs;
>>>>>  	void __iomem *base = gic_data_dist_base(gic);
>>>>> +	void __iomem *cpu_base = gic_data_cpu_base(gic);
>>>>>  
>>>>>  	writel_relaxed(0, base + GIC_DIST_CTRL);
>>>>>  
>>>>> @@ -371,6 +396,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>>>>>  
>>>>>  	gic_dist_config(base, gic_irqs, NULL);
>>>>>  
>>>>> +	gic_dist_clear_active(base, cpu_base, gic_irqs);
>>>>>  	writel_relaxed(1, base + GIC_DIST_CTRL);
>>>>>  }
>>>>
>>>> So while this is solving a real issue, I don't think you can just fix it
>>>> for the UP case. You'll have to fix the same thing for secondary CPUs
>>>> (shouldn't be too hard to split things between local and global interrupts).
>>> Hi Marc,
>>>
>>> Thanks very much for you reply!
>>>
>>> when I tried to implement your ideas. I found that: when kdump is deployed
>>> and without my patch,
>>>
>>> (1) panic in PPI, the capture kernel can not boot up.
>>> (2) panic in SPI, the capture kernel boot up regularly.
>>>
>>> I was confused and there may be something I did not catch. I glanced the kdump
>>> code and found that function machine_kexec_mask_interrupts. It will clear the
>>> GIC active state only if the IRQD_IRQ_INPROGRESS bit in d->state_use_accessors
>>> is set.
>>>
>>> And the PPI handler does not set this flag. So there are two ways to solve this
>>> problem.
>>>
>>>  (1) consider this problem common, as you and I thought before. we should fix secondary CPUs issues;
>>>
>>>
>>>  (2)just set flag IRQD_IRQ_INPROGRESS in PPI. we need patch like this:
>>>
>>> 	-------------(2) patch start-----------
>>> 	diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>>> 	index a2b28a2..0a5dfe0 100644
>>> 	--- a/kernel/irq/chip.c
>>> 	+++ b/kernel/irq/chip.c
>>> 	@@ -677,10 +677,18 @@ void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
>>>         	if (chip->irq_ack)
>>>                 	chip->irq_ack(&desc->irq_data);
>>>
>>> 	+ raw_spin_lock(&desc->lock);
>>> 	+ irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>>> 	+ raw_spin_unlock(&desc->lock);
>>> 	+
>>>         trace_irq_handler_entry(irq, action);
>>>         res = action->handler(irq, dev_id);
>>>         trace_irq_handler_exit(irq, action, res);
>>>
>>> 	+ raw_spin_lock(&desc->lock);
>>> 	+ irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>>> 	+ raw_spin_unlock(&desc->lock);
>>> 	+
>>>         if (chip->irq_eoi)
>>>                 chip->irq_eoi(&desc->irq_data);
>>> 	 }
>>> 	-------------(2) patch end-----------
>>>
>>> Way 2 seems to be needed anyway.
>>> For way 1, I do not find another situation that the gic interrupt states remains active when kernel booting.
>>> And for kdump process, Way 2 is enough.
>>>
>>> What do you think about them?
>>
>> Your second approach doesn't work, because you can have multiple CPUs
>> handling the same PPI at the same time. Remember these are per-processor
>> interrupts, despite having the same number. So you can't just have one
>> bit, you'd need one bit per CPU (and that's not going to happen).
> 
> Yes, But during kdump process, the crash cpu will send IPIs to other CPUs
> and wait until other CPUs reply these IPIs. So at last only the crash CPU's
> active state of PPI should be cleared. My second approach seems enough for
> this situation.

But this is also buggy. Imagine two timer interrupts (both the same PPI)
taking place on two CPUs, where CPU0 crashes in the handler, and CPU1
doesn't.

CPU1 will clear the INPROGRESS bit before getting the IPI from CPU0, and
you will never notice that you had an interrupt in flight.

>> I'm afraid that for PPIs, parsing the active bits is the only way.
> 
> I think so, For other situation, the second approach is not enough. I should
> expend my first solution.

Yes, I think this is the best solution so far. I wonder if you could get
away with just clearing the active bits though, instead of writing to
the EOI register...

> BTW, if we have to "parsing the active bits" as you said, Is it necessary to
> change IRQD_IRQ_INPROGRESS flag in PPI as my second patch?

As I've explained above, this doesn't really help.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
