Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaKFGJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:09:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:54741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKFGJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:09:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="603257950"
Message-ID: <545B1093.1050403@linux.intel.com>
Date: Thu, 06 Nov 2014 14:09:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [Patch Part2 v4 01/31] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-2-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411060044100.24960@nanos>
In-Reply-To: <alpine.DEB.2.11.1411060044100.24960@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/6 7:48, Thomas Gleixner wrote:
> On Tue, 4 Nov 2014, Jiang Liu wrote:
>>  /* Number of irqs reserved for a legacy isa controller */
>>  #define NUM_ISA_INTERRUPTS	16
>> @@ -64,6 +66,16 @@ struct irq_domain_ops {
>>  	int (*xlate)(struct irq_domain *d, struct device_node *node,
>>  		     const u32 *intspec, unsigned int intsize,
>>  		     unsigned long *out_hwirq, unsigned int *out_type);
>> +
>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +	/* extended V2 interfaces to support hierarchy irq_domains */
>> +	int (*alloc)(struct irq_domain *d, unsigned int virq,
>> +		     unsigned int nr_irqs, void *arg);
>> +	void (*free)(struct irq_domain *d, unsigned int virq,
>> +		     unsigned int nr_irqs);
>> +	int (*activate)(struct irq_domain *d, struct irq_data *irq_data);
>> +	int (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
> 
> Why do we have a return value here? Especially the deactivate one
> makes no sense at all.
> 
>> +extern int irq_domain_activate_irq(struct irq_data *irq_data);
>> +extern int irq_domain_deactivate_irq(struct irq_data *irq_data);
> 
> And here.
> 
>> @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
>>  	irq_state_clr_disabled(desc);
>>  	desc->depth = 0;
>>  
>> +	irq_domain_activate_irq(&desc->irq_data);
> 
> We do not check it and we cannot do here AFAICT.
> 
>>  	if (desc->irq_data.chip->irq_startup) {
>>  		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
>>  		irq_state_clr_masked(desc);
>> @@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
>>  		desc->irq_data.chip->irq_disable(&desc->irq_data);
>>  	else
>>  		desc->irq_data.chip->irq_mask(&desc->irq_data);
>> +	irq_domain_deactivate_irq(&desc->irq_data);
> 
> Ditto.
> 
> So the return value for irq_domain_deactivate_irq() is silly to begin
> with, but also the return value for irq_domain_activate_irq() does not
> really make sense. We've allocated the resources for the interrupt
> already down the hierarchy chain. So there is no reason why the actual
> activation should fail.
Hi Thomas,
	Fair enough, I have changed them to return void, which also
simplify the implementation. But add one or two BUG_ON()s:)
Regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
