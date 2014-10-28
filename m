Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaJ1UOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:14:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44749 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaJ1UN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:13:58 -0400
Message-ID: <544FF900.4020601@arm.com>
Date: Tue, 28 Oct 2014 20:13:52 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [Patch Part2 v3 01/24] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>  <1414484803-10311-2-git-send-email-jiang.liu@linux.intel.com> <1414489711.32399.53.camel@mtksdaap41> <alpine.DEB.2.11.1410282010340.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410282010340.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 28 Oct 2014 20:13:54.0192 (UTC) FILETIME=[B26F7900:01CFF2EB]
X-MC-Unique: 114102820135504501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 19:37, Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Yingjoe Chen wrote:
>> On Tue, 2014-10-28 at 16:26 +0800, Jiang Liu wrote:
>> <deleted...>
>>> @@ -471,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>>  	struct irq_domain *domain;
>>>  	irq_hw_number_t hwirq;
>>>  	unsigned int type = IRQ_TYPE_NONE;
>>> -	unsigned int virq;
>>> +	int virq;
>>>  
>>>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>>>  	if (!domain) {
>>> @@ -480,6 +478,11 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>>  		return 0;
>>>  	}
>>>  
>>> +	if (irq_domain_is_hierarchy(domain)) {
>>> +		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
>>> +		return virq <= 0 ? 0 : virq;
>>> +	}
>>> +
>>>  	/* If domain has no translation, then we assume interrupt line */
>>>  	if (domain->ops->xlate == NULL)
>>>  		hwirq = irq_data->args[0];
>>> @@ -540,8 +543,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>>>  		return 0;
>>>  
>>>  	if (hwirq < domain->revmap_direct_max_irq) {
>>> -		data = irq_get_irq_data(hwirq);
>>> -		if (data && (data->domain == domain) && (data->hwirq == hwirq))
>>> +		data = irq_domain_get_irq_data(domain, hwirq);
>>> +		if (data && data->hwirq == hwirq)
>>>  			return hwirq;
>>>  	}
>>
>> Why do you want to move irq_domain_alloc_irqs up there?
> 
> That's the wrong question. The proper question is whether we can move
> it after the xlate part. I don't see a reason why we cannot do that.
> 
> Jiang was right not to incorporate your patch to do that simply
> because we want to keep the history of the evolution of this
> code. Your patch is an enhancement and it needs to be discussed and
> applied seperately.
> 
> So while we are at it:
> 
>> +	if (irq_domain_is_hierarchy(domain)) {
>> +		if (domain->ops->xlate) {
>> +			/*
>> +			 * If we've already configured this interrupt,
>> +			 * don't do it again, or hell will break loose.
>> +			 */
>> +			virq = irq_find_mapping(domain, hwirq);
>> +			if (virq)
>> +				return virq;
> 
> I can understand that it is an issue if the mapping exists already,
> but I have to ask WHY is it correct behaviour to call into that code
> for an existing mapping.

As I have originally looked at this, I'll answer the question:

The generic DT code parses the whole tree, and generates platform
devices as it goes. As part of the platform device creation, it
populates the IRQ resources, which translates into calling into
irq_create_of_mapping(). You could argue that this behaviour is crazy,
and I wouldn't disagree.

See http://www.spinics.net/lists/devicetree/msg53164.html for more gory
details.

> And why would this check only apply if domain->ops->xlate is set?
> irq_create_mapping() does it unconditionally.

My original code used the xlate callback to parse the opaque irq_data,
computing hwirq, and I suspect this is a leftover of it. The above code
seems to pull hwirq out of thin air, which is probably not the intended
behaviour. Joe?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

