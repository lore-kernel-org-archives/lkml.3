Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKDDiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:38:55 -0500
Received: from mail-bn1bn0101.outbound.protection.outlook.com ([157.56.110.101]:32384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbaKDDit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:38:49 -0500
X-WSS-ID: 0NEHW25-07-9GQ-02
X-M-MSG: 
Message-ID: <54584681.2010103@amd.com>
Date: Mon, 3 Nov 2014 21:22:41 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        <jason@lakedaemon.net>, <Catalin.Marinas@arm.com>,
        <Will.Deacon@arm.com>, <liviu.dudau@arm.com>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com>
 <alpine.DEB.2.11.1411032300160.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411032300160.5308@nanos>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(164054003)(189002)(24454002)(479174003)(199003)(377454003)(31966008)(50466002)(68736004)(110136001)(117636001)(21056001)(83506001)(86362001)(84676001)(92726001)(92566001)(120886001)(97736003)(77156002)(4396001)(99396003)(87266999)(54356999)(120916001)(102836001)(101416001)(87936001)(46102003)(76176999)(36756003)(64706001)(65806001)(47776003)(106466001)(99136001)(20776003)(19580395003)(44976005)(19580405001)(23746002)(59896002)(50986999)(62966003)(65956001)(107046002)(65816999)(105586002)(95666004)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/2014 4:51 PM, Thomas Gleixner wrote:
> On Mon, 3 Nov 2014, suravee.suthikulpanit@amd.com wrote:
>> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
>> +{
>> +	int pos;
>> +	struct v2m_data *v2m = container_of(chip, struct v2m_data, msi_chip);
>> +
>> +	spin_lock(&v2m->msi_cnt_lock);
>
> Why do you need an extra lock here? Is that stuff not serialized from
> the msi_chip layer already?
>
> If not, why don't we have the serialization there instead of forcing
> every callback to implement its own?

 From the following call paths:
   |--> pci_enable_msi_range
    |--> msi_capability_init
     |--> arch_setup_msi_irqs
      |--> arch_setup_msi_irq
and
   |--> pci_enable_msix
    |--> msix_capability_init
     |--> arch_setup_msi_irqs
      |--> arch_setup_msi_irq

It serialize when a PCI device driver tries to allocate multiple 
interrupts. However, AFAICT, it would not serialize the allocation when 
multiple drivers trying to setup MSI irqs at the same time. I needed 
that to protect the bitmap structure. I also noticed the same in other 
drivers as well.

I can look into this more to see where would be a good point.

>> +	pos = irq - v2m->spi_start;
>
> So this assumes that @irq is the hwirq number, right? How does the
> calling function know about that? It should only have knowledge about
> the virq number if I'm not missing something.
>
> And if I'm missing something, then that msi_chip stuff is seriously
> broken.

It works this way because of the direct mapping (as you noticed). But I 
am planning to change that. See below.

>
>> +	if (pos >= 0 && pos < v2m->nr_spis)
>
> So you simply avoid the clear bitmap instead of yelling loudly about
> being called with completely wrong data?

I'll provide appropriate warnings.

> I would not be surprised if that is related to my question above.

Not quite sure which of the above questions.

>> +	spin_lock(&v2m->msi_cnt_lock);
>> +	offset = bitmap_find_free_region(v2m->bm, v2m->nr_spis, 0);
>> +	spin_unlock(&v2m->msi_cnt_lock);
>> +	if (offset < 0)
>> +		return offset;
>> +
>> +	hwirq = v2m->spi_start + offset;
>> +	virq = __irq_domain_alloc_irqs(v2m->domain, hwirq,
>> +				       1, NUMA_NO_NODE, v2m, true);
>> +	if (virq < 0) {
>> +		gicv2m_teardown_msi_irq(chip, hwirq);
>> +		return virq;
>> +	}
>> +
>> +	irq_domain_set_hwirq_and_chip(v2m->domain, virq, hwirq,
>> +				&v2m_chip, v2m);
>> +
>> +	irq_set_msi_desc(hwirq, desc);
>> +	irq_set_irq_type(hwirq, IRQ_TYPE_EDGE_RISING);
>
> Sure both calls work perfectly fine as long as virq == hwirq, right?

I was running into an issue when calling the 
irq_domain_alloc_irq_parent(), it requires of_phandle_args pointer to be 
passed in. However, this does not work for GICv2m since it does not have 
interrupt information in the device tree. So, I decided at first to use 
direct (virq == hwirq) mapping, which simplifies the code a bit, but 
might not be ideal solution, as you pointed out.

An alternative would be to create a temporary struct of_phandle_args, 
and populate it with the interrupt information for the requested MSI. 
Then pass it to:
   --> irq_domain_alloc_irq_parent
    |--> gic_irq_domain_alloc
      |--> gic_irq_domain_xlate
      |--> gic_irq_domain_map

However, this would still not be ideal if we want to support ACPI. 
Another alternative would be coming up with a dedicate structure to be 
used here. I noticed on X86, it uses struct irq_alloc_info. May be 
that's what we also need here.

> [...]
> I do not care at all how YOU waste your time. But I care very much
> about the fact that YOU are wasting MY precious time by exposing me to
> your patch trainwrecks.

I don't intend to waste yours or anybody's precious time. Sorry if it 
takes a couple iterations to work out the issues. Also, I will try to 
put more comment in my code to make it more clear. Let me know what 
works best for you to work out the issues.

Thanks,

Suravee

>
> Thanks,
>
> 	tglx
>


