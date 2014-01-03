Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaACTSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:18:32 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:35988 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaACTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:18:31 -0500
Date: Fri, 3 Jan 2014 15:18:12 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH v12 14/18] xen/grant: Implement an grant frame array struct.
Message-ID: <20140103191812.GA31994@andromeda.dapyr.net>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1401031644120.8667@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031644120.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 04:53:59PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
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
>      ^appropriate
> 
> 
> > To round it off, change the name from 'xen_hvm_resume_frames' to
> > a more descriptive one - 'xen_auto_xlat_grant_frames'.
> > 
> > For PVH, in patch "xen/pvh: Piggyback on PVHVM for grant driver"
> > we will populate the 'xen_auto_xlat_grant_frames' by ourselves.
> > 
> > Suggested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/arm/xen/enlighten.c   |  9 +++++++--
> >  drivers/xen/grant-table.c  | 45 ++++++++++++++++++++++++++++++++++++++++-----
> >  drivers/xen/platform-pci.c | 10 +++++++---
> >  include/xen/grant_table.h  |  9 ++++++++-
> >  4 files changed, 62 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 8550123..2162172 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -208,6 +208,7 @@ static int __init xen_guest_init(void)
> >  	const char *version = NULL;
> >  	const char *xen_prefix = "xen,xen-";
> >  	struct resource res;
> > +	unsigned long grant_frames;
> >  
> >  	node = of_find_compatible_node(NULL, NULL, "xen,xen");
> >  	if (!node) {
> > @@ -224,10 +225,10 @@ static int __init xen_guest_init(void)
> >  	}
> >  	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
> >  		return 0;
> > -	xen_hvm_resume_frames = res.start;
> > +	grant_frames = res.start;
> >  	xen_events_irq = irq_of_parse_and_map(node, 0);
> >  	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
> > -			version, xen_events_irq, (xen_hvm_resume_frames >> PAGE_SHIFT));
> > +			version, xen_events_irq, (grant_frames >> PAGE_SHIFT));
> >  	xen_domain_type = XEN_HVM_DOMAIN;
> >  
> >  	xen_setup_features();
> > @@ -265,6 +266,10 @@ static int __init xen_guest_init(void)
> >  	if (xen_vcpu_info == NULL)
> >  		return -ENOMEM;
> >  
> > +	if (gnttab_setup_auto_xlat_frames(grant_frames)) {
> > +		free_percpu(xen_vcpu_info);
> > +		return -ENOMEM;
> > +	}
> >  	gnttab_init();
> >  	if (!xen_initial_domain())
> >  		xenbus_probe(NULL);
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index cc1b4fa..b117fd6 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -65,8 +65,8 @@ static unsigned int nr_grant_frames;
> >  static int gnttab_free_count;
> >  static grant_ref_t gnttab_free_head;
> >  static DEFINE_SPINLOCK(gnttab_list_lock);
> > -unsigned long xen_hvm_resume_frames;
> > -EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
> > +struct grant_frames xen_auto_xlat_grant_frames;
> > +EXPORT_SYMBOL_GPL(xen_auto_xlat_grant_frames);
> 
> it should be static now

Can't be. The arch/x86/xen/grant-table.c has to use it.

I can drop the 'EXPORT_SYMBOL_GPL' though.

> 
> 
> >  static union {
> >  	struct grant_entry_v1 *v1;
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
> > +
> > +	xen_auto_xlat_grant_frames.vaddr = addr;
> > +	xen_auto_xlat_grant_frames.pfn = pfn;
> > +	xen_auto_xlat_grant_frames.count = max_nr_gframes;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(gnttab_setup_auto_xlat_frames);
> > +
> > +void gnttab_free_auto_xlat_frames(void)
> > +{
> > +	if (!xen_auto_xlat_grant_frames.count)
> > +		return;
> > +	kfree(xen_auto_xlat_grant_frames.pfn);
> > +	xen_auto_xlat_grant_frames.pfn = NULL;
> > +	xen_auto_xlat_grant_frames.count = 0;
> > +	xen_auto_xlat_grant_frames.vaddr = 0;
> > +}
> > +EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
> 
> I would leave vaddr alone in gnttab_setup_auto_xlat_frames and
> gnttab_free_auto_xlat_frames

Actually, I like David's suggestion. Patch coming out soon.
