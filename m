Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbbANMXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:23:49 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:53016 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbANMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:23:47 -0500
Date: Wed, 14 Jan 2015 13:23:42 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <154273028.20150114132342@eikelenboom.it>
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit b81975eade8c
In-Reply-To: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
References: <alpine.DEB.2.11.1501131000410.17382@nanos> <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, January 14, 2015, 4:09:35 AM, you wrote:

> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
> setup_IO_APIC(), so no irqdomains created for IOAPICs and
> mp_map_pin_to_irq() fails at the very beginning.

> So move creating of IOAPIC irqdomains from setup_IO_APIC() into
> arch_early_ioapic_init().

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Reported-and-tested-by: Sander Eikelenboom <linux@eikelenboom.it>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks Gerry !
Will you send (a backport) to stable for 3.17 and 3.18 when 
it's applied to -tip ?

--
Sander

> ---
>  arch/x86/kernel/apic/io_apic.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 3f5f60406ab1..1117c84cefe4 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -245,6 +245,8 @@ static void free_ioapic_saved_registers(int idx)
>         ioapics[idx].saved_registers = NULL;
>  }
>  
> +static int mp_irqdomain_create(int ioapic);
> +
>  int __init arch_early_ioapic_init(void)
>  {
>         struct irq_cfg *cfg;
> @@ -253,8 +255,10 @@ int __init arch_early_ioapic_init(void)
>         if (!nr_legacy_irqs())
>                 io_apic_irqs = ~0UL;
>  
> -       for_each_ioapic(i)
> +       for_each_ioapic(i) {
> +               BUG_ON(mp_irqdomain_create(i));
>                 alloc_ioapic_saved_registers(i);
> +       }
>  
>         /*
>          * For legacy IRQ's, start with assigning irq0 to irq15 to
> @@ -2371,16 +2375,12 @@ static void ioapic_destroy_irqdomain(int idx)
>  
>  void __init setup_IO_APIC(void)
>  {
> -       int ioapic;
> -
>         /*
>          * calling enable_IO_APIC() is moved to setup_local_APIC for BP
>          */
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
> +        * we are still using bootmem allocator.So delay it to
> +        * arch_early_ioapic_init().
>          */
>         if (hotplug) {
>                 if (mp_irqdomain_create(idx)) {

