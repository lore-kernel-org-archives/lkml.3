Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3KNBjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:39:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab3KNBjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:39:12 -0500
Date: Thu, 14 Nov 2013 09:38:19 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
Message-ID: <20131114013818.GB4081@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
 <20131113155008.GA17248@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113155008.GA17248@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 at 03:50pm, Matt Fleming wrote:
> On Tue, 05 Nov, at 04:20:08PM, dyoung@redhat.com wrote:
> > Kexec kernel will use saved runtime virtual mapping, so add a
> > new function efi_remap_region to remapping it directly without
> > calculate the virt addr from efi_va.
> > 
> > The md is passed in from 1st kernel, the virtual addr is
> > saved in md->virt_addr.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/include/asm/efi.h     |    1 +
> >  arch/x86/platform/efi/efi_32.c |    3 +++
> >  arch/x86/platform/efi/efi_64.c |   19 +++++++++++++++++++
> >  3 files changed, 23 insertions(+)
> 
> [...]
> 
> > @@ -203,6 +203,25 @@ void __init efi_map_region(efi_memory_de
> >  	md->virt_addr = efi_va;
> >  }
> >  
> > +/*
> > + * kexec kernel will use efi_map_region_fixed to map efi
> > + * runtime memory ranges. md->virt_addr is the original virtual
> > + * address which had been mapped in kexec 1st kernel.
> > + */
> > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> > +{
> > +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> > +	unsigned long pf = 0;
> > +
> > +	if (!(md->attribute & EFI_MEMORY_WB))
> > +		pf |= _PAGE_PCD;
> > +
> > +	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr,
> > +			md->num_pages, pf))
> > +		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
> > +			   md->phys_addr, md->virt_addr);
> > +}
> > +
> 
> This function is almost identical to __map_region(). Please implement
> efi_map_region_fixed() in terms of __map_region(), e.g.
> 
> void __init efi_map_region_fixed(efi_memory_desc_t *md)
> {
> 	__map_region(md, md->virt_addr);
> }

Good suggestion, will do

> 
> > @@ -47,6 +47,9 @@ void __init efi_map_region(efi_memory_de
> >  	old_map_region(md);
> >  }
> >  
> > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> > +{}
> > +
> 
> The braces should be on the same line as the rest of the function
> prototype. Look at how it's done elsewhere in this file.

Ok, will do

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
