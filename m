Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaH0H5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:57:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:47974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbaH0H5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="590454793"
Message-ID: <53FD8F64.20300@linux.intel.com>
Date: Wed, 27 Aug 2014 15:57:24 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Patch] irqdomain: Introduce new interfaces to support hierarchy
 irqdomains
References: <1406880493-18859-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1408261053450.3323@nanos>
In-Reply-To: <alpine.DEB.2.10.1408261053450.3323@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Thanks for your great comments! Please refer to
inline comments below.
Regards!
Gerry

On 2014/8/27 5:06, Thomas Gleixner wrote:
> Jiang,
> 
> On Fri, 1 Aug 2014, Jiang Liu wrote:
> 
>> First, architecture needs to define struct irq_map_info, which will be
>> used to pass architecture specific information to controller specific
>> callbacks.
> 
> We should not have another "universal" data structure which needs to
> fit various levels of the hierarchy. See below.
> 
>> Second, all new interfaces have parameter 'size' to support multiple
>> continous IRQs, which is needed by MSI when interrupt remapping is
>> enabled on x86.
> 
> Nitpick: nrirqs would be more intuitive.
Will use nrirqs in next version.

>  
>> Third, a special value IRQDOMAIN_AUTO_ASSIGN_HWIRQ is defined out of
>> irq_hw_number_t, which indicates that irqdomain callbacks should
>> automatically hardware interrupt number for clients. This will be used
>> to support CPU vector allocation and interrupt remapping controller
>> on x86 platforms.
> 
> I can't see the point of this. If we have a hierarchy then this is a
> property of the hierarchy itself not of an indiviual call.
When invoking irqdomain interfaces, we need to pass in an hwirq. For
IOAPIC, it's the pin number. But for remap and vector domains, caller
can't provide hwirq, it's assigned by remap and vector domains
themselves. So introduced IRQDOMAIN_AUTO_ASSIGN_HWIRQ to indicate
that irqdomain will assign hwirq for callers.

>  
>> Fourth, the flag IRQDOMAIN_FLAG_HIERARCHY is used to indicate weather
>> irqdomain operations are hierarchy request. The irqdomain core uses
> 
> Why do we need that flag? If a domain has a parent domain, we already
> know that this domain is part of a hierarchy.
This flag is passed into hierarchy irqdomain interfaces for two
purposes:
1) to protect irq_data->hwirq and irq_data->domain
2) to solve recursive lock issues in irqdomain core.

> 
>> domain and hwirq fields in struct irq_data to save domain and hardware
>> interrupt number, but this causes trouble when enabling hierarchy
>> irqdomain. We solve this limitation by:
>> 1) Still use domain and hwirq fields in struct irq_data to save
>>    infomation about the out-most irqdomain.
>> 2) For hierarchy irqdomains, the parent field in struct irq_domain is
>>    used to save point to parent irqdomain.
>> 3) For hierarchy irqdomains, it must implement a private method to save
>>    hardware interrupt number (hwirq).
> 
> I'm not so fond of this design decision. Let's look at a hierarchy:
> 
>     PCI-Device
> 	MSI Interrupt
> 	    Remap Entry
> 	    	  CPU Vector
> 
> But your data representation is not hierarchical because only the
> outmost domain map is stored in irq_data. For the parent domains you
> offload the storage to the domain implementation itself.
One of my design rules is only to change x86 arch specific code when
possible, so used above solution. If we could make changes to public
data structures, we may find better solution as you have suggested:)

> 
> We should be more clever and make the storage hierarchical and
> indivual itself.
> 
> What about adding a field:
> 
>      struct irq_data *parent_data;
> 
> to struct irq_data and allocate it when we allocate an interrupt down
> the hierarchy chain?
> 
> That allows to store hw_irq for each hierarchy level along with a
> pointer to the interrupt chip and irq specific data. So the storage
> would look like this:
> 
> irq
>    irq_desc
>       irq_data (hwirq, chip, chipdata, domain ...)
>          irq_data (hwirq, chip, chipdata, domain ...)
>              irq_data (hwirq, chip, chipdata, domain ...)
> 
> That allows us also to support scenarios where manipulation of the top
> level interrupt "irq" requires to walk down the hierarchy without
> consulting any irqdomain management code and without having specific
> knowledge in the interrupt chip callbacks. Assume a two level
> hierarchy which requires to mask/unmask both levels. In the current
> mode we need to deal with this in the chip callback of the outermost
> chip. But with a hierarchical data set, we can do:
> 
> mask(struct irqdata *d)
> {
> 	d->chip->irq_mask(d);
> 	if (d->parent_data)
> 	   mask(d->parent_data);
> }
> 
> and avoid magic conditionals in the chip callbacks.
That's a good suggestion. Should we reuse irq_data directly or
group some fields from irq_data into a new data structure?

> 
> Lets look at the current way of allocating a MSI interrupt with
> remapping.
> 
> msi_capability_init()
>   arch_setup_msi_irqs()
>     irq_remapping_setup_msi_irqs()
>       irq_alloc_hwirq()
>          __assign_irq_vector()
>       intel_msi_alloc_irq()
>          alloc_irte()
> 
> In a proper domain hierarchy it would look like this:
> 
> msi_capability_init()
>   arch_setup_msi_irqs()
>     irq_domain_alloc(msi_domain)
>        irq_domain_alloc(remap_domain)
>          irq_domain_alloc(vector_domain)
> 
> In a non remapped scenario the msi_domain parent would be
> vector_domain and the chain would look like this:
> 
> msi_capability_init()
>   arch_setup_msi_irqs()
>     irq_domain_alloc(msi_domain)
>       irq_domain_alloc(vector_domain)
That's what I want to achieve:)

> 
> So now the question is where the irq descriptor which is associated to
> "irq" is allocated. The most logical point is at the end of the
> hierarchy, i.e. the domain which has no parent domain. That makes a
> single level domain scenario just a natural subset of a multi level
> hierarchy, but that makes the hierarchical irq data allocation and
> handling more complex because the innermost domain would use the
> irqdata associated to irqdesc. Not a really good idea, if we look at
> it from the interrupt handling code. We could copy and shuffle stuff
> around, but thats ugly as hell.
> 
> So we are better off by doing:
> 
> irq_domain_alloc(....)
> {
>    int virq = alloc_irq_desc(nrirqs);
> 
>    if (domain->parent) {
>       ret = irq_domain_alloc_parent(domain->parent, virq, nrirqs);
>       ....
>    }
>    ....
>    return virq;
> }   
> 
> And have:
> 
> irq_domain_alloc_parent(struct irqdomain *domain, int virq,
> 			int nrirqs)
> {
>    alloc_irq_data(domain, virq, nrirqs);
> 
>    if (domain->parent) {
>       ret = irq_domain_alloc_parent(domain->parent, nrirqs, virq);
>       ....
>    }
>    /*
>     * Allocate the actual hardware resources in this domain and store
>     * the domain specific information in the proper hierarchy level
>     * irqdata.
>     */
>    domain->alloc_hwirqs(domain, virq, nrirqs);
>    ...
> }
> 
> alloc_irq_data(struct irqdomain *domain, int virq, int nrirqs)
> {
>    /* Allocate irq_data and domain specific storage in one go */	
>    int size = sizeof(struct irq_data) + domain->private_data_size;
>    void *p;
> 
>    p = kzalloc(nrirqs * size);
>   
>    for (i = 0; i < nrirqs; i++, virq++, hwirq++, p += size) {
>      struct irq_data *d = irq_get_irq_data(virq);
>    
>      while (d->parent_data)
>        d = d->parent_data;
> 
>      d->parent_data = p;
> 
>      d = p;
>      d->irq = virq;
>      d->domain = domain;
> 
>      /* If we have domain specific storage, let chip_data point to it */
>      if (domain->private_data_size)
>        d->chip_data = d + 1;
>    }
> }
> 
> To lookup the irqdata of a hierarchy level we need a helper function:
> 
> irq_get_domain_irq_data(int virq, struct irq_domain *d)
> {
>    struct irq_data *d = irq_get_irq_data(virq);
> 
>    while (d) {
>       if (d->domain == d)
>          break;
>       d = d->parent_data;
>    }
>    return d;	
> }
> 
> So if we look at the various hierarchy levels, then we really can make
> sensible use of the separate irq_data instances. Right now, the struct
> irq_2_iommu is part of the vector domain config structure, but thats
> not because the vector domain needs that information, it just happens
> to be there. So we can put it into the irqdata associated to the remap
> domain.
> 
> There are a few other things to consider. Right now the irq remapping
> code modifies the x86_ops to redirect the ioapic and the msi functions
> to the remap implementations and at irq setup time it also modifies
> the irq chip callbacks. That's a completely unreadable and
> undocumented maze of indirections and substitutions.
> 
> And just looking at the msi setup code makes me run away screaming.
> 
> So in the intel irq remapping case arch_setup_msi_irqs() ends up with
> the following call chain for a single MSI-X interrupt:
> 
> irq_remapping_setup_msi_irqs() 	      irq_remapping.c
>   do_setup_msix_irqs()
> 
>     irq_alloc_hwirq()		      irq core code
>       irq = __irq_alloc_descs()
>       arch_setup_hwirq(irq)	      io_apic.c
>         cfg = alloc_irq_cfg(irq)
>         __assign_irq_vector(irq, cfg)
> 	irq_set_chip_data(irq, cfg)
> 
>     msi_alloc_remapped_irq(irq)	      irq_remapping.c
>       intel_msi_alloc_irq(irq)	      intel_irq_remapping.c
>         alloc_irte(irq)
> 
>     setup_msi_irq(irq)		      io_apic.c
>       msi_compose_msg(irq)
>         assign_irq_vector()           <- Second invocation !?!?!
> 	x86_msi.compose_msi_msg()     
> 	  compose_remapped_msi_msg()  irq_remapping.c
>             intel_compose_msi_msg()   intel_irq_remapping.c
> 	      fiddle_with_irte()
>       write_msi_msg()		      io_apic.c/msi.c
>       setup_remapped_irq()	      irq_remapping.c
>         modify_irq_chip_call_backs()
> 
> All in all design from hell hacked into submission ...
> 
> So how can we do better with irq domains?
> 
> First of all we need to separate the resource allocation and the
> actual activation, i.e.:
> 
> Allocate irq descriptors, remap area and vector block first, then
> activate the interrupts. Doing it this way is also simpler for backoff
> in the error case than undoing a partial reservation/allocation which
> has already been activated.
> 
> irq_domain_alloc(msi_domain, nrirqs)
> {
>   virq = irq_alloc_desc(nriqs)
> 
>   irq_domain_alloc_parent(remap_domain, virq, nrirqs)
>   
>     irq_domain_alloc_parent(vector_domain, virq, nrirqs)
> }
> 
> Each parent allocation allocates the irqdata and stores the
> reservation/allocation information in it. Further it assigns an
> interrupt chip to the irqdata if appropriate.
> 
> So we don't need to activate the interrupt in this step at all. All we
> need to do is to allocate and reserve the necessary resources.
Yes, I have split it into two steps: resource allocation and activation.

> 
> The point where we really need to activate the interrupt is at
> request_irq() time. And here the interrupt chips which we assigned
> come into play:
> 
> request_irq(virq)
>     ....
>     irq_startup();
>     
> So we need to teach irq_startup about hierarchies, but that's not
> rocket science.
> 
> irq_startup(struct irq_desc *desc, bool resend)
> {
>   irq_startup_parent(&desc->irq_data);
>   ...
> }
> 
> And have
> 
> irq_startup_parent(struct irq_data *d)
> {
>   if (d->parent_data)
>     irq_startup_parent(d->parent_data);
> 
>   if (d->chip && d->irq_startup)
>     d->chip->irq_startup(d);  
> }
> 
> So in the PCI MSI[X] remapping case this would 
> 
> 1) Call down into the vector domain and the assigned irq chip would
>    have a startup function which finally activates the reserved
>    vector.
> 
> 2) Write the irte entry from the remap domain and compose the msi msg.
> 
> 3) Enable the msi msg from the msi domain
> 
> Now you might ask the question how #2 makes use of #1
> (cfg->vector/cfg->domain) and #3 makes use of #2 (msi msg). That's
> rather simple.
Currently we solve this issue by packing all data into irq_cfg,
we remap and ioapic level could access apic id and vector in
vector domain.

> 
> The remap domain chip knows that its parent is the vector domain, so
> it simply can look at d->parent_data->chip_data to retrieve irq_cfg
> which contains the vector and the domain.
> 
> Now the MSI domain chip checks, whether the parent domain has
> d->parent_data->msi_desc set and if not NULL it gets the remapped msi
> msg information from there. If remapping is disabled, then
> d->parent_data->msi_desc is NULL and the native msg composition takes
> place.
> 
> While we are at it can we please get rid of the abnomination of
> modifying the callbacks of the irq chip which is associated to a
> particular interrupt line. That's a nasty and fcking non obvious
> hack. Why would the MSI chip care about an override to irq_eoi?
> 
> What's wrong with either having proper interrupt chips for the
> remapped and non remapped case or modifying the msi chip callbacks
> once when interrupt remapping is enabled instead of doing it with the
> assbackwards setup_remapped_irq() function over and over again?
> 
> Now if you followed the above you'll notice that it will get rid of
> another annoying level of indirection, i.e. the x86_msi ops. And I'm
> pretty sure, that this also gets rid of the ioapic ops hackery if we
> treat it the same way.
That's one of my goal: to simplify x86_msi and ioapic ops structures,
get rid of callback override, so the code will be much more easier
to read and maintain.

> 
> Another benefit is that you can get rid of the whole irq_remapping.c
> indirection and conditional maze, which is completely overengineered
> and pointless.
> 
> So the whole irq_remapping mess will boil down to establish the proper
> domain parent pointers for MSI, HPET_MSI, IOAPIC and whatever gets
> mangled through the remap code. That's a simple setup time operation
> and does not require any x86_*ops overrides at all. So if we do it
> right we can get rid of quite some pointless shite.
> 
> I probably missed a few things, though I don't see any real show
> stopper right now. I did not elaborate on irq_set_affinity() but that
> should be an obvious excercise; if not we need to think it through
> again and maybe from a different angle, but we really want a proper
> cleanup for the existing pile of shite and not another bolted on
> solution.
One more issue I'm facing now.

I plan to build one irqdomain to support MSI/MSIx, but system may have
multiple interrupt remapping units. It's a little tricky to maintain
hierarchy relationship between MSI irqdomain and remapping irqdomain.
It's hard to maintain N:N relationship for MSI and remapping irqdomains.
So should we maintain 1:N or 1:1 relationships? In other words, should
we build one irqdomain for each remapping unit or only build one
irqdomain for all remapping units?

On the other hand, it's a good news that we almost have the same goals,
and just have different ways to achieve our goals. I tried to change
x86 arch code only, and you suggest to touch the irq public code.
To be honest, I have no enough confidence to touch irq public code
at the first step:(

And I have a working patch set based on the draft design, should I
send out it fore RFC? I know I will rewrite them based on your
suggestions, but it may help to find more design issues with my
current implementation.

Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
