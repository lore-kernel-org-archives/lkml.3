Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaACSVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:21:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21748 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaACSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:21:29 -0500
Date: Fri, 3 Jan 2014 13:20:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
Message-ID: <20140103182022.GH27019@phenom.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401031722170.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031722170.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 05:26:39PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > In PVH the shared grant frame is the PFN and not MFN,
> > hence its mapped via the same code path as HVM.
> > 
> > The allocation of the grant frame is done differently - we
> > do not use the early platform-pci driver and have an
> > ioremap area - instead we use balloon memory and stitch
> > all of the non-contingous pages in a virtualized area.
> > 
> > That means when we call the hypervisor to replace the GMFN
> > with a XENMAPSPACE_grant_table type, we need to lookup the
> > old PFN for every iteration instead of assuming a flat
> > contingous PFN allocation.
> > 
> > Lastly, we only use v1 for grants. This is because PVHVM
> > is not able to use v2 due to no XENMEM_add_to_physmap
> > calls on the error status page (see commit
> > 69e8f430e243d657c2053f097efebc2e2cd559f0
> >  xen/granttable: Disable grant v2 for HVM domains.)
> > 
> > Until that is implemented this workaround has to
> > be in place.
> > 
> > Also per suggestions by Stefano utilize the PVHVM paths
> > as they share common functionality.
> > 
> > v2 of this patch moves most of the PVH code out in the
> > arch/x86/xen/grant-table driver and touches only minimally
> > the generic driver.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/grant-table.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/xen/gntdev.c       |  2 +-
> >  drivers/xen/grant-table.c  | 13 ++++++----
> >  3 files changed, 73 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
> > index 3a5f55d..040e064 100644
> > --- a/arch/x86/xen/grant-table.c
> > +++ b/arch/x86/xen/grant-table.c
> > @@ -125,3 +125,67 @@ void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
> >  	apply_to_page_range(&init_mm, (unsigned long)shared,
> >  			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
> >  }
> > +#ifdef CONFIG_XEN_PVHVM
> > +#include <xen/balloon.h>
> > +#include <linux/slab.h>
> > +static int __init xlated_setup_gnttab_pages(void)
> > +{
> > +	struct page **pages;
> > +	xen_pfn_t *pfns;
> > +	int rc, i;
> > +	unsigned long nr_grant_frames = gnttab_max_grant_frames();
> > +
> > +	BUG_ON(nr_grant_frames == 0);
> > +	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
> > +	if (!pages)
> > +		return -ENOMEM;
> > +
> > +	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
> > +	if (!pfns) {
> > +		kfree(pages);
> > +		return -ENOMEM;
> > +	}
> > +	rc = alloc_xenballooned_pages(nr_grant_frames, pages, 0 /* lowmem */);
> > +	if (rc) {
> > +		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
> > +			nr_grant_frames, rc);
> > +		kfree(pages);
> > +		kfree(pfns);
> > +		return rc;
> > +	}
> > +	for (i = 0; i < nr_grant_frames; i++)
> > +		pfns[i] = page_to_pfn(pages[i]);
> > +
> > +	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
> > +				    (void *)&xen_auto_xlat_grant_frames.vaddr);
> > +
> > +	kfree(pages);
> > +	if (rc) {
> > +		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> > +			nr_grant_frames, rc);
> > +		free_xenballooned_pages(nr_grant_frames, pages);
> > +		kfree(pfns);
> > +		return rc;
> > +	}
> > +
> > +	xen_auto_xlat_grant_frames.pfn = pfns;
> > +	xen_auto_xlat_grant_frames.count = nr_grant_frames;
> > +
> > +	return 0;
> > +}
> 
> Unfortunately this way pfns is leaked. Can we safely free it or is it
> reused at resume time?

You mean you want PVH to suspend and resume work out of the box?!

HA! I hadn't even tested that yet.

How about when we get to that point we will figure out the way to
do the right thing.

What actually happens during suspend/resume in a HVM guests? We just
need to call 'gnttab_setup' which calls 'gnttab_map' to do the
XENMAPSPACE_grant_table on the PFNs right? That should be OK
and the xen_auto_xlat_grant_frames.pfn  is used during that.

The suspend path would use unmap_frames -> arch_gnttab_unmap which
just clears the PTEs. There is no freeing off the memory
which is used as backing store.
