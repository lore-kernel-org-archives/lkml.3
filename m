Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaKXOUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:20:13 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46702 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaKXOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:20:11 -0500
Message-ID: <54733E7C.60005@huawei.com>
Date: Mon, 24 Nov 2014 22:19:40 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <547325A9.3000109@huawei.com> <alpine.DEB.2.11.1411241405560.6439@nanos> <54733A4E.8020304@huawei.com> <54733C7D.2010405@linux.intel.com>
In-Reply-To: <54733C7D.2010405@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54733E86.01FB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7e1ae2310568d419ea66557ddbfd4639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 22:11, Jiang Liu wrote:

> On 2014/11/24 22:01, Yun Wu (Abel) wrote:
>> On 2014/11/24 21:13, Thomas Gleixner wrote:
>>
>>> On Mon, 24 Nov 2014, Yun Wu (Abel) wrote:
>>>> Hi Thomas, Jiang,
>>>> On 2014/11/12 21:42, Thomas Gleixner wrote:
>>>>
>>>>> From: Jiang Liu <jiang.liu@linux.intel.com>
>>>>>
>>>> [...]
>>>>>  /* Number of irqs reserved for a legacy isa controller */
>>>>>  #define NUM_ISA_INTERRUPTS	16
>>>>> @@ -64,6 +66,16 @@ struct irq_domain_ops {
>>>>>  	int (*xlate)(struct irq_domain *d, struct device_node *node,
>>>>>  		     const u32 *intspec, unsigned int intsize,
>>>>>  		     unsigned long *out_hwirq, unsigned int *out_type);
>>>>> +
>>>>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>>>>> +	/* extended V2 interfaces to support hierarchy irq_domains */
>>>>> +	int (*alloc)(struct irq_domain *d, unsigned int virq,
>>>>> +		     unsigned int nr_irqs, void *arg);
>>>>> +	void (*free)(struct irq_domain *d, unsigned int virq,
>>>>> +		     unsigned int nr_irqs);
>>>>> +	void (*activate)(struct irq_domain *d, struct irq_data *irq_data);
>>>>> +	void (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
>>>>
>>>> What's the usage of the parameter domain reference in activate/deactivate?
>>>> I think the purpose of the two callbacks is to activate/deactivate the
>>>> irq_data->hwirq in irq_data->domain. If so, the first parameter @domain is
>>>> required to be equal to irq_data->domain (which makes @domain useless).
>>>> Besides, the main responsibility of interrupt domains is to manage mappings
>>>> between hardware and linux interrupt numbers, so would it be better if move
>>>> the two callbacks into struct irq_chip?
>>>
>>> No. It's not a function of the irq_chip to activate/deactivate a
>>> hierarchy. As I explained you before:
>>>
>>> The existing irqdomain code maps between hardware and virtual
>>> interrupts and thereby activates the interrupt in hardware.
>>>
>>> In the hierarchical case we do not touch the hardware in the
>>> allocation step, so we need to activate the allocated interrupt in the
>>> hardware before we can use it. And that's clearly a domain interface
>>> not a irq chip issue.
>>>
>>
>> Makes sense, now the interrupt domain seems to be the best place.
>> And when the @domain parameter can be really useful? I haven't see
>> anyone using it so far.
> We will use it for IOAPIC on x86, as below:
> void mp_irqdomain_deactivate(struct irq_domain *domain,
>                              struct irq_data *irq_data)
> {
>         ioapic_mask_entry(mp_irqdomain_ioapic_idx(domain),
>                           (int)irq_data->hwirq);
> }
> 
>>From an object oriented point of view, we pass the object as the
> first parameter. It's true that we could retrieve domain from
> irq_data->domain instead of explicitly passing it in, but that
> will cause irqdomain interfaces depends on irq_data, not sounds
> a good situation:)

Hi Gerry,

Is there any possibility that domain doesn't equal to irq_data->domain?
I'm a little confused..

Thanks,
	Abel

