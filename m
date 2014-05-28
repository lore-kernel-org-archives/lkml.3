Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaE1FBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:01:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:64955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaE1FBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="349236372"
Message-ID: <53856D8E.3010401@linux.intel.com>
Date: Wed, 28 May 2014 13:01:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch V3 19/37] x86, irq: introduce mechanisms to support dynamically
 allocate IRQ for IOAPIC
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-20-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Thanks for your comments. Please refer to inline
comments below.

On 2014/5/28 3:58, Thomas Gleixner wrote:
> Jiang,
> 
> On Tue, 27 May 2014, Jiang Liu wrote:
> 
>> +static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
>>  {
>> +	int irq = -1;
>> +
>> +	if (gsi >= arch_dynirq_lower_bound(0)) {
>> +		irq = irq_create_mapping(domain, pin);
>> +	} else if (gsi < NR_IRQS_LEGACY) {
>> +		if (!ioapic_identity_map)
>> +			irq = irq_create_mapping(domain, pin);
>> +		else if (irq_domain_associate(domain, gsi, pin) == 0)
>> +			irq = gsi;
>> +	} else if (irq_create_strict_mappings(domain, gsi, pin, 1) == 0) {
>> +		irq = gsi;
>> +	}
> 
> So you have these cases covered here:
> 
> 1) The ACPI case of secondary ioapics. You only have the strict 1:1
>    mapping for the first ioapic
> 
> 2) The gsi < NR_IRQS_LEGACY case where you have two options:
> 
>     a) Let the core create a random virq number if ioapic_identity_map
>        is 0
> 
>        ioapic_identity_map is only set by SFI and devicetree
> 
>        So in all other cases we fall into that code path for all
>        legacy interrupts. So how is that supposed to work lets say for
>        i8042 which has hardcoded irq 1 and 12?
> 
>        irq_create_mapping(1)
>        
> 	    hint = 1 % nr_irqs; --> 1
> 	    virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
> 
> 	    This returns something >= 16, because the irq descriptors
> 	    for 0-15 (LEGACY) are allocated already.
> 
>        The pin association works, but how is the i8042 driver supposed
>        to figure out that it should request the virq >=16 which was
>        created instead of the hardcoded 1 ?
This is used to work around special non-ISA interrupts with GSI below
NR_IRQS_LEGACY. The original code for the special case is:
/*
 * Provide an identity mapping of gsi == irq except on truly
 * weird platforms that have non isa irqs in the first 16 gsis.
 */
return gsi >= NR_IRQS_LEGACY ? gsi : gsi_top + gsi;

We have one path to handle ISA IRQs before calling
alloc_irq_from_domain() as below:
        if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci))
                return mp_irqs[idx].srcbusirq;

> 	
>     b) Associate the gsi and the pin
> 
>        This only works because the virqs are already allocated at boot
>        time unconditionally due to arch_probe_nr_irqs() returning
>        NR_IRQS_LEGACY. So irq_domain_associate() works.
>        Undocumented works by chance behaviour.
Yes. It's a good suggestion to enhance legacy_pic to make this
code more clear.

> 
> 3) The case where gsi < arch_dynirq_lower_bound()
> 
>    You create a strict mapping here, fine.
> 
> This is confusing at best.
> 
> First of all, we should use legacy_pic->nr_legacy_irqs instead of
> NR_IRQS_LEGACY all over the place.
> 
> mshyperv, ce4100 and intel-mid use the null_legacy_pic which has
> nr_legacy_irqs = 0 and everything else uses the real pic which has
> nr_legacy_irqs = NR_IRQS_LEGACY. So why do we even bother to allocate
> and deal with NR_IRQS_LEGACY in the cases where we have no legacy?
I'm not sure whether it works with ce4100, so used NR_IRQS_LEGACY
instead of legacy_pic->nr_legacy_irqs for safety. Will try to refine
it in next version.

> 
> ce4100 is an oddball though. The ioapic is registered way before the
> interrupt subsystem is initialized and I have a hard time to
> understand that comment:
> 
>         /* We can't set this earlier, because we need to calibrate the timer */
>         legacy_pic = &null_legacy_pic;
I haven't figured out the story behind the comment yet:(

> 
> The timer calibration happens after the interrupts are set up. I
> assume it's check_timer() which wants that, but we know exactly how
> the ce4100 works, so we might be able to avoid that whole "testing"
> stuff. Sebastian, any input on this?
> 
> If it turns out that ce4100 needs the inital real legacy pic for some
> magic reason we still can be clever by extending the legacy pic data
> structure to tell us about that change, i.e. instead of using
> legacy_pic->nr_legacy_irqs having a field "nr_allocated_irqs", which
> is set to NR_IRQS_LEGACY for the real pic and to 0 for the null_pic
> and let ce4100 set that field to NR_IRQS_LEGACY before switching the
> legacy_pic over to the null implementation.
Good suggestion, will try this way.

> But what's really disgusting is the magic ioapic_identity_map and the
> extra ACPI specific ioapic_dynirq_base hackery.
> 
> Why do we need strict mappings in the non ACPI case for all ioapic
> pins? What's so different about ACPI? Or is this just to avoid
> breaking the existing SFI/devicetree stuff. If that's the reason I'm
> fine with it, but ...
It's to avoid breaking SFI/intel_mid stuff. intel_mid assumes IRQ
number equals to pin number and use pci_dev->irq to save both IRQ
number and pin number.

> 
> independent of this question we want to be more clever about the
> handling of strict, legacy and freely associated linux irq numbers.
> 
> So you have this weird ioapic_create_domain_fn callback in
> mp_register_ioapic, which is solely there so the different callers can
> hand in their domain ops and eventually set the magic
> ioapic_identity_map flag.
> 
> +void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
> +                              ioapic_create_domain_fn cb, void *arg)
> 
> What about having
> 
> struct ioapic_domain {
>        struct irqdomain             *domain;
>        const struct irq_domain_ops  *ops;
>        void                         *arg;
>        enum domain_type             type;
> };
> 
> and add this struct to the ioapic struct. type is:
> 
> enum domain_type {
>        IOAPIC_STRICT,
>        IOAPIC_LEGACY,
>        IOAPIC_DYNAMIC,
> };     
> 
> 
> Now the register function changes to:
> 
> void mp_register_ioapic(int id, u32 address, u32 gsi_base,
>      			const struct irq_domain_ops *ops,
> 			int type)
> {
> 	...
> 
>         ioapics[idx].irqdomain.ops = ops;
>         ioapics[idx].irqdomain.arg = arg;
> 	ioapics[idx].irqdomain.type = type;
>         ioapics[idx].irqdomain.domain = NULL;
> 	
> 	...
> }
> 
> and you can use mp_irqdomain_create() unconditionally for creating all
> domains. And there you do:
> 
> static int dynirq_lower_bound;
> 
> mp_irqdomain_create()
> {
>        ioapic->irqdomain.domain = irq_domain_add_linear(...);
>        
>        switch (ioapic->irqdomain.type) {
>        case IOAPIC_LEGACY:
>        	    /*
> 	     * Associate the legacy interrupts which have been
> 	     * already allocated.
> 	     */
> 	    for (i = 0; i < legacy_pic->nr_allocated_irqs; i++)
> 		irq_domain_associate(domain, i, i);
> 
>        case IOAPIC_STRICT:
>        	    dynirq_lower_bound += ioapic->nr_gsis;
> 
>        case IOAPIC_DYNAMIC:
>        	    break;
>        }
> }
> 
> So arch_dynirq_lower_bound() gets simplified to:
> {
>      return dynirq_lower_bound;
> }
> 
> And alloc_irq_from_domain() becomes:
> 
> int alloc_irq_from_domain(struct ioapic_domain *domain, int gsi, int pin)
> {
> 	switch (domain->type) {
> 	case IOAPIC_DYNAMIC:
> 	     return irq_create_mapping(domain->domain, pin);
> 	case IOAPIC_LEGACY:
> 	case IOAPIC_STRICT:     	    
> 	     return irq_create_strict_mappings(domain, gsi, pin, 1);
> 	}
> }
> 
> At the call site of alloc_irq_from_domain() you have already:
> 
>        irq = irq_find_mapping(domain, pin);
>        if (irq <=0 ....)
>        	       alloc_irq_from_domain(domain, gsi, pin);
> 
> So because we associated the legacy_pic->nr_allocated_irqs in
> mp_irqdomain_create() already, you'll never call into
> alloc_irq_from_domain() for those and the remaining ones for that
> first ioapic are handled by the IOAPIC_STRICT fall through.
> 
> For simplicity you can let SFI and devicetree register the ioapics
> with their specific domain ops plus IOAPIC_LEGACY for the first ioapic
> and IOAPIC_STRICT for all others. That also covers the case where the
> null_legacy_pic with legacy_pic->nr_allocated_irqs == 0 is used.
> 
> In the ACPI case you register with the acpi domain ops and
> IOAPIC_LEGACY for the first and IOAPIC_DYNAMIC for the extra ioapics.
> 
> Should be way cleaner and understandable, at least to me :)
Really good suggestions! Make thing much more clear.

> 
> Now there is that last oddity which bugs me in mp_map_pin_to_irq()
> 
>  	/*
> 	 * Don't use irqdomain to manage ISA IRQs because there may be
> 	 * multiple IOAPIC pins sharing the same ISA IRQ number and
> 	 * irqdomain only supports 1:1 mapping between IOAPIC pin and
> 	 * IRQ number.
>  	 */
> 	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
>  		irq = mp_irqs[idx].srcbusirq;
> 		if ((flags & IOAPIC_MAP_ALLOC) && info->count == 0 &&
> 		    mp_irqdomain_map(domain, irq, pin) != 0)
> 			irq = -1;
> 
> That really looks like a hack. I'm aware that the current irqdomain
> code cannot deal with that oddball case.
> 
> So what you are saying is that there are devices which have a separate
> physical wire to different ioapic pins, but the ioapic is supposed to
> bundle them to a shared interrupt.
> 
> I agree that this is odd enough to handle at the ioapic level, but
> it'd be nice to have a more elaborative comment on this.
Will try to improve the comment.

> 
> Aside of the above I'm pretty happy about the progress of this patch
> set. One thing, which needs to be looked at are the usage sites of
> irq_data->irq, whether they are safe. I did not spot any unsafe ones,
> but a few functions which are called with irq_data->irq and make no
> use of it.
Sure, will check usages of irq_data->irq.

Really appreciate you suggestions, it will improve the code a lot.
Thanks!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
