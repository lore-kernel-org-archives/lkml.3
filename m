Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaABStF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:49:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30595 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaABStD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:49:03 -0500
Date: Thu, 2 Jan 2014 13:47:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 14/18] xen/grant: Implement an grant frame array
 struct.
Message-ID: <20140102184754.GF3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com>
 <52C59367.70707@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C59367.70707@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:27:19PM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > The 'xen_hvm_resume_frames' used to be an 'unsigned long'
> > and contain the virtual address of the grants. That was OK
> > for most architectures (PVHVM, ARM) were the grants are contingous
> > in memory. That however is not the case for PVH - in which case
> > we will have to do a lookup for each virtual address for the PFN.
> > 
> > Instead of doing that, lets make it a structure which will contain
> > the array of PFNs, the virtual address and the count of said PFNs.
> > 
> > Also provide a generic functions: gnttab_setup_auto_xlat_frames and
> > gnttab_free_auto_xlat_frames to populate said structure with
> > appropiate values for PVHVM and ARM.
> > 
> > To round it off, change the name from 'xen_hvm_resume_frames' to
> > a more descriptive one - 'xen_auto_xlat_grant_frames'.
> > 
> > For PVH, in patch "xen/pvh: Piggyback on PVHVM for grant driver"
> > we will populate the 'xen_auto_xlat_grant_frames' by ourselves.
> [...]
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> [...]
> > @@ -838,6 +838,40 @@ unsigned int gnttab_max_grant_frames(void)
> >  }
> >  EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
> >  
> > +int gnttab_setup_auto_xlat_frames(unsigned long addr)
> > +{
> > +	xen_pfn_t *pfn;
> > +	unsigned int max_nr_gframes = __max_nr_grant_frames();
> > +	int i;
> > +
> > +	if (xen_auto_xlat_grant_frames.count)
> > +		return -EINVAL;
> > +
> > +	pfn = kcalloc(max_nr_gframes, sizeof(pfn[0]), GFP_KERNEL);
> > +	if (!pfn)
> > +		return -ENOMEM;
> > +	for (i = 0; i < max_nr_gframes; i++)
> > +		pfn[i] = PFN_DOWN(addr + (i * PAGE_SIZE));
> 
> PFN_DOWN(addr) + i looks better to me.
> 
> > +
> > +	xen_auto_xlat_grant_frames.vaddr = addr;
> 
> Huh? addr is a physical address but you're assigning it to a field
> called vaddr?  I think you mean to set this field to the result of the
> xen_remap() call, yes?

It ends up doing that in gnttab_init. Not to
xen_auto_xlat_grant_frames.vaddr but to gnttab_shared.addr.

But not for PVH, which already has done so (via vmap).

It is kind of silly - for PVHVM we use a physical address (the MMIO
of the plaform-pci) and ioremap it. For PVH, we need to use balloon
memory and vmap it. We can't use ioremap on it because the it is RAM
pages and ioremap will complain.

We end up with special casing - for PVHVM do ioremap, for PVH, just
assign it to gnttab_shared.addr as it already has an virtual address.

Perhaps I should just make this a union field? 
> 
> > --- a/include/xen/grant_table.h
> > +++ b/include/xen/grant_table.h
> > @@ -178,8 +178,15 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
> >  			   grant_status_t **__shared);
> >  void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
> >  
> > -extern unsigned long xen_hvm_resume_frames;
> > +struct grant_frames {
> > +	xen_pfn_t *pfn;
> > +	int count;
> 
> unsigned int.
> 
> > +	unsigned long vaddr;
> 
> void * if this is a virtual address.

It is a physical address for PVHVM, and a virtual address for PVH
(see above rant). 
> 
> David
> 
