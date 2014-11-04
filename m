Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKDRqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:46:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55357 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKDRqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:46:22 -0500
Message-ID: <545910EA.1010903@arm.com>
Date: Tue, 04 Nov 2014 17:46:18 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <alpine.DEB.2.11.1411032300160.5308@nanos> <54584681.2010103@amd.com> <alpine.DEB.2.11.1411040903340.5308@nanos> <5458E0BE.2090803@amd.com>
In-Reply-To: <5458E0BE.2090803@amd.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 04 Nov 2014 17:46:19.0900 (UTC) FILETIME=[3DC1FBC0:01CFF857]
X-MC-Unique: 114110417462003801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 14:20, Suravee Suthikulpanit wrote:
> 
> 
> On 11/4/14 04:06, Thomas Gleixner wrote:
>> On Mon, 3 Nov 2014, Suravee Suthikulanit wrote:
>>> On 11/3/2014 4:51 PM, Thomas Gleixner wrote:
>>>> On Mon, 3 Nov 2014, suravee.suthikulpanit@amd.com wrote:
>>>>> +	irq_domain_set_hwirq_and_chip(v2m->domain, virq, hwirq,
>>>>> +				&v2m_chip, v2m);
>>>>> +
>>>>> +	irq_set_msi_desc(hwirq, desc);
>>>>> +	irq_set_irq_type(hwirq, IRQ_TYPE_EDGE_RISING);
>>>>
>>>> Sure both calls work perfectly fine as long as virq == hwirq, right?
>>>
>>> I was running into an issue when calling the irq_domain_alloc_irq_parent(), it
>>> requires of_phandle_args pointer to be passed in. However, this does not work
>>> for GICv2m since it does not have interrupt information in the device tree.
>>> So, I decided at first to use direct (virq == hwirq) mapping, which simplifies
>>> the code a bit, but might not be ideal solution, as you pointed out.
>>
>> It's not only far from ideal. It's not a solution at all. Simply
>> because there is no guarantee for virq == hwirq.
>>
>>> An alternative would be to create a temporary struct of_phandle_args, and
>>> populate it with the interrupt information for the requested MSI. Then pass it
>>> to:
>>>    --> irq_domain_alloc_irq_parent
>>>     |--> gic_irq_domain_alloc
>>>       |--> gic_irq_domain_xlate
>>>       |--> gic_irq_domain_map
>>>
>>> However, this would still not be ideal if we want to support ACPI. Another
>>
>> Neither device tree nor ACPI has anything to do with MSI interrupts at
>> runtime.
>>
>> All they do is to tell that there is a MSI controller and where the
>> registers are and in the worst case fixups for a borked MSI_TYPER
>> register.
>>
>> So either the TYPER reg or DT/ACPI gives you a fixed hwirq range which
>> is reserved for MSI. And that's all you need, right?
>>
> Right, I get that part. Figuring out the fixed hwirq range for MSI is 
> not the point I am trying to make here.
> 
>> [...]
>> All you need is to pick one hwirq out of the existing fixed range and
>> associate it to a newly allocated virq. That's the only information
>> the underlying gic domain has to know about, because it needs to
>> translate from the hwirq to the virq in the low level entry handler
>> gic_handle_irq().
> 
> And that's what I am trying to do here except that GIC is expecting that 
> information to be passed to it via irq_domain_alloc_irqs(..., args) 
> where args is struct of_phandle_args (e.g. in the kernel/irqdomain.c: 
> irq_create_of_mapping). This works fine when specifying interrupt from 
> DT, but that is not always the case.
> 
> Currently, I can just create a fake of_phandle_args just to pass the 
> hwirq information to GIC.
> 
>      --> gicv2m_setup_msi_irq()
>       |    struct of_phandle_args phan;
>       |    phan.np = NULL;
>       |    phan.args_count = 3;
>       |    phan.args[0] = 0;
>       |    phan.args[1] = hwirq - 32;
>       |    phan.args[2] = IRQ_TYPE_EDGE_RISING;
>       |--> irq_domain_alloc_irqs(d, 1, NUMA_NO_NODE, &phan);
>        |--> gicv2m_domain_alloc(d, virq, nr_irqs, arg)
> 	|--> irq_domain_alloc_irqs_parent(d, virq, nr_irqs, arg);
> 
> I am trying to figure out what would be a common data structure for this 
> purpose that would work for both Dt and non-DT case (e.g. GICv2m MSI). 
> Unless you think this is ok.

I think of_phandle_args is the only thing we can use, whether this is DT
or this other non-DT thing. This is how we represent a GIC HW interrupt
outside of the GIC itself.

Of course, this creates a dependency between the different domains (a
child domain *must* know how the parent domain represents its
interrupt). Things like the v2m widget are completely fused with the GIC
anyway, so it makes sense.

Things like generic secondary irqchips don't fit that model, but they
can continue to use the existing framework.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

