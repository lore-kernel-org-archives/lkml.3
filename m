Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaACPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:11:30 -0500
Received: from smtp.citrix.com ([66.165.176.89]:52503 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaACPLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:11:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89558466"
Date: Fri, 3 Jan 2014 15:10:22 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 10/12] xen/pvh: Piggyback on PVHVM for
 grant driver.
In-Reply-To: <20131218212150.GE11717@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1401031504500.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-11-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181831560.8667@kaball.uk.xensource.com> <20131218212150.GE11717@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 18, 2013 at 06:46:56PM +0000, Stefano Stabellini wrote:
> > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > In PVH the shared grant frame is the PFN and not MFN,
> > > hence its mapped via the same code path as HVM.
> > > 
> > > The allocation of the grant frame is done differently - we
> > > do not use the early platform-pci driver and have an
> > > ioremap area - instead we use balloon memory and stitch
> > > all of the non-contingous pages in a virtualized area.
> > > 
> > > That means when we call the hypervisor to replace the GMFN
> > > with a XENMAPSPACE_grant_table type, we need to lookup the
> > > old PFN for every iteration instead of assuming a flat
> > > contingous PFN allocation.
> > > 
> > > Lastly, we only use v1 for grants. This is because PVHVM
> > > is not able to use v2 due to no XENMEM_add_to_physmap
> > > calls on the error status page (see commit
> > > 69e8f430e243d657c2053f097efebc2e2cd559f0
> > >  xen/granttable: Disable grant v2 for HVM domains.)
> > > 
> > > Until that is implemented this workaround has to
> > > be in place.
> > > 
> > > Also per suggestions by Stefano utilize the PVHVM paths
> > > as they share common functionality.
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  drivers/xen/gntdev.c       |  2 +-
> > >  drivers/xen/grant-table.c  | 80 ++++++++++++++++++++++++++++++++++++++++++----
> > >  drivers/xen/platform-pci.c |  2 +-
> > >  include/xen/grant_table.h  |  2 +-
> > >  4 files changed, 76 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> > > index e41c79c..073b4a1 100644
> > > --- a/drivers/xen/gntdev.c
> > > +++ b/drivers/xen/gntdev.c
> > > @@ -846,7 +846,7 @@ static int __init gntdev_init(void)
> > >  	if (!xen_domain())
> > >  		return -ENODEV;
> > >  
> > > -	use_ptemod = xen_pv_domain();
> > > +	use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);
> > >  
> > >  	err = misc_register(&gntdev_miscdev);
> > >  	if (err != 0) {
> > > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > > index aa846a4..c0ded9f 100644
> > > --- a/drivers/xen/grant-table.c
> > > +++ b/drivers/xen/grant-table.c
> > > @@ -47,6 +47,7 @@
> > >  #include <xen/interface/xen.h>
> > >  #include <xen/page.h>
> > >  #include <xen/grant_table.h>
> > > +#include <xen/balloon.h>
> > >  #include <xen/interface/memory.h>
> > >  #include <xen/hvc-console.h>
> > >  #include <xen/swiotlb-xen.h>
> > > @@ -66,8 +67,8 @@ static unsigned int boot_max_nr_grant_frames;
> > >  static int gnttab_free_count;
> > >  static grant_ref_t gnttab_free_head;
> > >  static DEFINE_SPINLOCK(gnttab_list_lock);
> > > -unsigned long xen_hvm_resume_frames;
> > > -EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
> > > +unsigned long xen_auto_xlat_grant_frames;
> > > +EXPORT_SYMBOL_GPL(xen_auto_xlat_grant_frames);
> > >  
> > >  static union {
> > >  	struct grant_entry_v1 *v1;
> > > @@ -1060,7 +1061,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
> > >  	unsigned int nr_gframes = end_idx + 1;
> > >  	int rc;
> > >  
> > > -	if (xen_hvm_domain()) {
> > > +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> > >  		struct xen_add_to_physmap xatp;
> > >  		unsigned int i = end_idx;
> > >  		rc = 0;
> > > @@ -1069,10 +1070,24 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
> > >  		 * index, ensuring that the table will grow only once.
> > >  		 */
> > >  		do {
> > > +			unsigned long vaddr;
> > > +			unsigned int level;
> > > +			pte_t *pte;
> > > +
> > >  			xatp.domid = DOMID_SELF;
> > >  			xatp.idx = i;
> > >  			xatp.space = XENMAPSPACE_grant_table;
> > > -			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
> > > +
> > > +			/*
> > > +			 * Don't assume the memory is contingous. Lookup each.
> > > +			 */
> > > +			vaddr = xen_auto_xlat_grant_frames + (i * PAGE_SIZE);
> > > +			if (xen_hvm_domain())
> > > +				xatp.gpfn = vaddr >> PAGE_SHIFT;
> > > +			else {
> > > +				pte = lookup_address(vaddr, &level);
> > 
> > lookup_address is x86 only. I added an empty implementation under
> > arch/arm to be able to compile stuff under drivers/xen but I would like
> > to get rid of it.
> > If you can't find a way to replace lookup_address with something that
> > works on arm and arm64 too, you could always turn
> > xen_auto_xlat_grant_frames into an array and store the pfns there.
> 
> Yeah, that would work nicely too. Thought we would have to store the
> size somewhere. Maybe a struct then.
> 
> struct xlat_grant_frames {
> 	int	nr;
> 	xen_pfn_t	*array;
> 	struct page	*page;
> };

sounds good


> > > +			}
> > >  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
> > >  			if (rc != 0) {
> > >  				pr_warn("grant table add_to_physmap failed, err=%d\n",
> > > @@ -1135,7 +1150,7 @@ static void gnttab_request_version(void)
> > >  	int rc;
> > >  	struct gnttab_set_version gsv;
> > >  
> > > -	if (xen_hvm_domain())
> > > +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
> > 
> > just turn this to
> > 
> > if (xen_feature(XENFEAT_auto_translated_physmap))
> 
> Hmm, I would rather actually keep that until I fix the underlaying issue
> of why v2 can't be used. And then we can get rid of this workaround.

Given that HVM guests have XENFEAT_auto_translated_physmap, the two are
equivalent.


> > >  		gsv.version = 1;
> > >  	else
> > >  		gsv.version = 2;
> > > @@ -1161,6 +1176,46 @@ static void gnttab_request_version(void)
> > >  	pr_info("Grant tables using version %d layout\n", grant_table_version);
> > >  }
> > >  
> > > +static int xlated_setup_gnttab_pages(unsigned long nr_grant_frames,
> > > +				     unsigned long max, void *addr)
> > > +{
> > > +	struct page **pages;
> > > +	unsigned long *pfns;
> > > +	int rc, i;
> > > +
> > > +	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
> > > +	if (!pages)
> > > +		return -ENOMEM;
> > > +
> > > +	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
> > > +	if (!pfns) {
> > > +		kfree(pages);
> > > +		return -ENOMEM;
> > > +	}
> > > +	rc = alloc_xenballooned_pages(nr_grant_frames, pages, 0 /* lowmem */);
> > > +	if (rc) {
> > > +		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
> > > +			nr_grant_frames, rc);
> > > +		kfree(pages);
> > > +		kfree(pfns);
> > > +		return rc;
> > > +	}
> > > +	for (i = 0; i < nr_grant_frames; i++)
> > > +		pfns[i] = page_to_pfn(pages[i]);
> > > +
> > > +	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, max, addr);
> > > +
> > > +	kfree(pages);
> > > +	kfree(pfns);
> > > +	if (rc) {
> > > +		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> > > +			nr_grant_frames, rc);
> > > +		free_xenballooned_pages(nr_grant_frames, pages);
> > > +		return rc;
> > > +	}
> > > +	return rc;
> > > +}
> > 
> > Please move this function somewhere under arch/x86/xen and call it from
> > xen_start_kernel, it doesn't belong to common code.
> 
> <nods>
> 
> Actually, looking at how the xen-platform-pci does it. I am wondering
> if that can be just made in one function that will do the right
> thing.
> 
> Can the xen-platform-pci use balloon pages instead of the MMIO BARs?
> Or would that be a waste of memory?

I think they could be used but it would be a waste and they would need
to be contiguous in gpfn space.
