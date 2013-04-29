Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab3D2XMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:12:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41824 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab3D2XMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:12:00 -0400
Date: Tue, 30 Apr 2013 01:11:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/2] x86, efi: Add 1:1 mapping of runtime services
Message-ID: <20130429231148.GG7049@pd.tnic>
References: <1366712152-8097-1-git-send-email-bp@alien8.de>
 <1366712152-8097-3-git-send-email-bp@alien8.de>
 <20130426130919.GA23038@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130426130919.GA23038@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 02:09:19PM +0100, Matt Fleming wrote:
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index 4b70be21fe0a..9e45eac3c33a 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -649,15 +649,24 @@ static int __init efi_runtime_init(void)
> >  		pr_err("Could not map the runtime service table!\n");
> >  		return -ENOMEM;
> >  	}
> > -	/*
> > -	 * We will only need *early* access to the following
> > -	 * two EFI runtime services before set_virtual_address_map
> > -	 * is invoked.
> > -	 */
> > -	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
> > -	efi_phys.set_virtual_address_map =
> > -		(efi_set_virtual_address_map_t *)
> > -		runtime->set_virtual_address_map;
> > +
> > +#define efi_phys_assign(f) \
> > +	efi_phys.f = (efi_ ##f## _t *)runtime->f
> > +
> > +	efi_phys_assign(get_time);
> > +	efi_phys_assign(set_time);
> > +	efi_phys_assign(get_wakeup_time);
> > +	efi_phys_assign(set_wakeup_time);
> > +	efi_phys_assign(get_variable);
> > +	efi_phys_assign(get_next_variable);
> > +	efi_phys_assign(set_variable);
> > +	efi_phys_assign(get_next_high_mono_count);
> > +	efi_phys_assign(reset_system);
> > +	efi_phys_assign(set_virtual_address_map);
> > +	efi_phys_assign(query_variable_info);
> > +	efi_phys_assign(update_capsule);
> > +	efi_phys_assign(query_capsule_caps);
> > +
> 
> Why is this change needed? We still don't access these other functions
> via their early addresses.

Because I need the physical addresses of the EFI runtime functions
and assign them to efi.systab->runtime->[function_name] later, see
efi_assign in efi_enter_virtual_mode(). And efi_phys is already there so
we can use it.

Unless you have a better idea, of course.

> >  	/*
> >  	 * Make efi_get_time can be called before entering
> >  	 * virtual mode.
> > @@ -845,9 +854,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
> >   */
> >  void __init efi_enter_virtual_mode(void)
> >  {
> > +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> >  	efi_memory_desc_t *md, *prev_md = NULL;
> >  	efi_status_t status;
> > -	unsigned long size;
> > +	unsigned long size, page_flags;
> >  	u64 end, systab, start_pfn, end_pfn;
> >  	void *p, *va, *new_memmap = NULL;
> >  	int count = 0;
> > @@ -895,7 +905,8 @@ void __init efi_enter_virtual_mode(void)
> >  		md = p;
> >  		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> >  		    md->type != EFI_BOOT_SERVICES_CODE &&
> > -		    md->type != EFI_BOOT_SERVICES_DATA)
> > +		    md->type != EFI_BOOT_SERVICES_DATA &&
> > +		    md->type != EFI_CONVENTIONAL_MEMORY)
> >  			continue;
> >  
> >  		size = md->num_pages << EFI_PAGE_SHIFT;
> > @@ -920,11 +931,26 @@ void __init efi_enter_virtual_mode(void)
> >  			continue;
> >  		}
> >  
> > +		page_flags = 0;
> > +
> > +		if (md->type == EFI_RUNTIME_SERVICES_DATA ||
> > +		    md->type == EFI_BOOT_SERVICES_DATA)
> > +			page_flags = _PAGE_NX;
> > +
> > +		if (!(md->attribute & EFI_MEMORY_WB))
> > +			page_flags |= _PAGE_PCD;
> > +
> > +		kernel_map_pages_in_pgd(pgd, md->phys_addr,
> > +					md->num_pages, page_flags);
> > +
> >  		systab = (u64) (unsigned long) efi_phys.systab;
> >  		if (md->phys_addr <= systab && systab < end) {
> >  			systab += md->virt_addr - md->phys_addr;
> >  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
> >  		}
> > +
> > +		md->virt_addr = md->phys_addr;
> > +
> 
> Now we have the EFI regions mapped in two places synchronisation is
> probably required, e.g. mappings are accessible via the direct kernel
> mapping/ioremap space, and via the 1:1 mapping.

Actually, after the efi_assign things above are done, all efi_virt*
calls are done solely through the 1:1 mapping.

And Matthew wanted to keep the virtual mappings around for those funny
Macs.

Which means, we need some sort of synchronization. Hmm.

So, what do we want to do?

Have a bunch of functions called phys_efi_*, in the manner
of phys_efi_get_time, which call the address saved in
efi_phys.<function_name> and they all use the 1:1 mappings so that they
can be used later in kexec, etc.

Then we can keep all those efi_virt* functions untouched (specifically,
do not do ->virt_addr = ->phys_addr).

phys_efi* and virt_efi* functions will use a global lock and there's
your synchronization.

However, this all depends on whether we can use md->phys_addr to call
runtime services after SetVirtualAddressMap() has run. Can we? Because
if we do, then that way it should work. Otherwise either the Macs or
kexec is hosed.

We probably should discuss this further on IRC.

> Also, you'll want to look at fixing efi_lookup_mapped_addr() which
> assumes it can access md->virt_addr in the current pgd.

No need to if we keep the ioremap mappings.

> Actually, I _think_ we can get away with only double mapping those
> regions that we use as ram, see do_add_efi_memmap() and exit_boot() in
> arch/x86/boot/compressed/eboot.c. We can probably skip the ioremap()
> calls now, since they're only for the benefit of firmware. Which in
> turn should mean we can delete efi_ioremap().

Yeah, I think this doesn't change if we keep two sets of mappings.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
