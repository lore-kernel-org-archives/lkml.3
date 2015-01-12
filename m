Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbbALXS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:18:28 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:38648 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbALXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:18:27 -0500
Date: Tue, 13 Jan 2015 00:18:14 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1686507423.20150113001814@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit b81975eade8c
In-Reply-To: <54B3E1AC.6080902@citrix.com>
References: <1767175032.20150110201202@eikelenboom.it> <1421069966-19729-1-git-send-email-jiang.liu@linux.intel.com> <54B3E1AC.6080902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, January 12, 2015, 4:01:00 PM, you wrote:

> On 12/01/15 13:39, Jiang Liu wrote:
>> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
>> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
>> setup_IO_APIC(), so no irqdomains created for IOAPICs and
>> mp_map_pin_to_irq() fails at the very beginning.
>> 
>> Enhance xen_smp_prepare_cpus() to call setup_IO_APIC() to initialize
>> irqdomain for IOAPICs.

> Having Xen call setup_IO_APIC() to initialize the irq domains then having to
> add special cases to it is just wrong.

> The bits of init deferred by mp_register_apic() are also deferred to
> two different places which looks odd.

> What about something like the following (untested) patch?

Hi David / Gerry,

David's patch (after fixing a few compile issues) fixes the problem.

The power button now works for me on:
- intel baremetal
- intel xen
- amd baremetal (no issues with the override anymore)
- amd xen       (no freeze issues anymore)

Big thanks David !

--
Sander


> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 3f5f604..e180680 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -253,8 +253,10 @@ int __init arch_early_ioapic_init(void)
>         if (!nr_legacy_irqs())
>                 io_apic_irqs = ~0UL;
>  
> -       for_each_ioapic(i)
> +       for_each_ioapic(i) {
> +               BUG_ON(mp_irqdomain_create(ioapic));
>                 alloc_ioapic_saved_registers(i);
> +       }
>  
>         /*
>          * For legacy IRQ's, start with assigning irq0 to irq15 to
> @@ -2379,8 +2381,6 @@ void __init setup_IO_APIC(void)
>         io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
>  
>         apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
> -       for_each_ioapic(ioapic)
> -               BUG_ON(mp_irqdomain_create(ioapic));
>  
>         /*
>           * Set up IO-APIC IRQ routing.
> @@ -2929,7 +2929,8 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>         /*
>          * If mp_register_ioapic() is called during early boot stage when
>          * walking ACPI/SFI/DT tables, it's too early to create irqdomain,
> -        * we are still using bootmem allocator. So delay it to setup_IO_APIC().
> +        * we are still using bootmem allocator. So delay it to
> +        * arch_early_ioapic_init().
>          */
>         if (hotplug) {
>                 if (mp_irqdomain_create(idx)) {

>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -2369,6 +2381,15 @@ static void ioapic_destroy_irqdomain(int idx)
>>       ioapics[idx].pin_info = NULL;
>>  }
>>  
>> +static void setup_IO_APIC_IDs(void)
>> +{
>> +     if (xen_domain())
>> +             return;

> This would have to xen_pv_domain().

> David


