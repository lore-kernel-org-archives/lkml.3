Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaKRNZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:25:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:11208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbaKRNZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609760501"
Message-ID: <546B48CF.50100@linux.intel.com>
Date: Tue, 18 Nov 2014 21:25:35 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 04/16] genirq: Introduce irq_chip.irq_compose_msi_msg()
 to support stacked irqchip
References: <20141112133941.647950773@linutronix.de> <20141112134120.137871641@linutronix.de> <546B10D2.4050300@huawei.com> <alpine.DEB.2.11.1411181059090.3909@nanos> <546B31CE.2020006@huawei.com> <546B3F01.2010005@linux.intel.com> <546B46C0.6070904@huawei.com>
In-Reply-To: <546B46C0.6070904@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 21:16, Yun Wu (Abel) wrote:
> On 2014/11/18 20:43, Jiang Liu wrote:
> 
>> On 2014/11/18 19:47, Yun Wu (Abel) wrote:
>>> On 2014/11/18 18:02, Thomas Gleixner wrote:
>>>
>>>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>>>> On 2014/11/12 21:42, Thomas Gleixner wrote:
>>>>>> +int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>>>>>> +{
>>>>>> +	struct irq_data *pos = NULL;
>>>>>> +
>>>>>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>>>>>> +	for (; data; data = data->parent_data)
>>>>>> +#endif
>>>>>> +		if (data->chip && data->chip->irq_compose_msi_msg)
>>>>>> +			pos = data;
>>>>>> +	if (!pos)
>>>>>> +		return -ENOSYS;
>>>>>> +
>>>>>> +	pos->chip->irq_compose_msi_msg(pos, msg);
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>
>>>>> Adding message composing routine to struct irq_chip is OK to me, and it should
>>>>> be because it is interrupt controllers' duty to compose messages (so that they
>>>>> can parse the messages correctly without any pre-defined rules that endpoint
>>>>> devices absolutely need not to know).
>>>>> However a problem comes out when deciding which parameters should be passed to
>>>>> this routine. A message can associate with multiple interrupts, which makes me
>>>>> think composing messages for each interrupt is not that appropriate. And we
>>>>> can take a look at the new routine irq_chip_compose_msi_msg(). It is called by
>>>>> msi_domain_activate() which will be called by irq_domain_activate_irq() in
>>>>> irq_startup() for each interrupt descriptor, result in composing a message for
>>>>> each interrupt, right? (Unless requiring a judge on the parameter @data when
>>>>> implementing the irq_compose_msi_msg() callback that only compose message for
>>>>> the first entry of that message. But I really don't like that...)
>>>>
>>>> No, that's not correct. You are looking at some random stale version
>>>> of this. The current state of affairs is in 
>>>>
>>>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain
>>>>
>>>> See also https://lkml.org/lkml/2014/11/17/764
>>>>
>>>> In activate we write the message, which is the right point to do so.
>>>>
>>>
>>> I checked the current state, it seems to be the same.
>>> Yes, the decision of postponing the actual hardware programming to the point
>>> where the interrupt actually gets used is right, but here above I was talking
>>> another thing.
>>> As I mentioned, a message can associate with multiple interrupts. Enabling
>>> any of them will call irq_startup(). So if we don't want to compose or write
>>> messages repeatedly, we'd better require performing some checks before
>>> activating the interrupts.
>> Hi Yun,
>> 	Seems you are talking about the case of multiple MSI support.
>> Yes, we have special treatment for multiple MSI, which only writes PCI
>> MSI registers when starting up the first MSI interrupt.
>> void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg
>> *msg)
>> {
>>         struct msi_desc *desc = irq_data->msi_desc;
>>
>>         /*
>>          * For MSI-X desc->irq is always equal to irq_data->irq. For
>>          * MSI only the first interrupt of MULTI MSI passes the test.
>>          */
>>         if (desc->irq == irq_data->irq)
>>                 __pci_write_msi_msg(desc, msg);
>> }
> 
> 
> Yes, I picked the case of multiple MSI support.
> The check should also be performed when composing messages. That's why
> I don't like its parameters. The @data only indicates one interrupt,
> while I prefer doing compose/write in the unit of message descriptor.
Hi Yun,
	The common abstraction is that every message interrupt could be
controlled independently, so have compose_msi_msg()/write_msi_msg() per
interrupt. MSI is abstracted as an special message signaled interrupt
with hardware limitation where multiple interrupts sharing the same
hardware registers. So we filter in pci_msi_domain_write_msg(). On the
other handle, the generic MSI framework caches msi_msg in msi_desc,
so we don't filter compose_msi_msg().
Regards!
Gerry
