Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaACR1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:27:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18439 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaACR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:27:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87412828"
Date: Fri, 3 Jan 2014 17:26:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
In-Reply-To: <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031722170.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> In PVH the shared grant frame is the PFN and not MFN,
> hence its mapped via the same code path as HVM.
> 
> The allocation of the grant frame is done differently - we
> do not use the early platform-pci driver and have an
> ioremap area - instead we use balloon memory and stitch
> all of the non-contingous pages in a virtualized area.
> 
> That means when we call the hypervisor to replace the GMFN
> with a XENMAPSPACE_grant_table type, we need to lookup the
> old PFN for every iteration instead of assuming a flat
> contingous PFN allocation.
> 
> Lastly, we only use v1 for grants. This is because PVHVM
> is not able to use v2 due to no XENMEM_add_to_physmap
> calls on the error status page (see commit
> 69e8f430e243d657c2053f097efebc2e2cd559f0
>  xen/granttable: Disable grant v2 for HVM domains.)
> 
> Until that is implemented this workaround has to
> be in place.
> 
> Also per suggestions by Stefano utilize the PVHVM paths
> as they share common functionality.
> 
> v2 of this patch moves most of the PVH code out in the
> arch/x86/xen/grant-table driver and touches only minimally
> the generic driver.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/grant-table.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/xen/gntdev.c       |  2 +-
>  drivers/xen/grant-table.c  | 13 ++++++----
>  3 files changed, 73 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
> index 3a5f55d..040e064 100644
> --- a/arch/x86/xen/grant-table.c
> +++ b/arch/x86/xen/grant-table.c
> @@ -125,3 +125,67 @@ void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
>  	apply_to_page_range(&init_mm, (unsigned long)shared,
>  			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
>  }
> +#ifdef CONFIG_XEN_PVHVM
> +#include <xen/balloon.h>
> +#include <linux/slab.h>
> +static int __init xlated_setup_gnttab_pages(void)
> +{
> +	struct page **pages;
> +	xen_pfn_t *pfns;
> +	int rc, i;
> +	unsigned long nr_grant_frames = gnttab_max_grant_frames();
> +
> +	BUG_ON(nr_grant_frames == 0);
> +	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
> +	if (!pfns) {
> +		kfree(pages);
> +		return -ENOMEM;
> +	}
> +	rc = alloc_xenballooned_pages(nr_grant_frames, pages, 0 /* lowmem */);
> +	if (rc) {
> +		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		kfree(pages);
> +		kfree(pfns);
> +		return rc;
> +	}
> +	for (i = 0; i < nr_grant_frames; i++)
> +		pfns[i] = page_to_pfn(pages[i]);
> +
> +	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
> +				    (void *)&xen_auto_xlat_grant_frames.vaddr);
> +
> +	kfree(pages);
> +	if (rc) {
> +		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		free_xenballooned_pages(nr_grant_frames, pages);
> +		kfree(pfns);
> +		return rc;
> +	}
> +
> +	xen_auto_xlat_grant_frames.pfn = pfns;
> +	xen_auto_xlat_grant_frames.count = nr_grant_frames;
> +
> +	return 0;
> +}

Unfortunately this way pfns is leaked. Can we safely free it or is it
reused at resume time?


> +static int __init xen_pvh_gnttab_setup(void)
> +{
> +	if (!xen_domain())
> +		return -ENODEV;
> +
> +	if (!xen_pv_domain())
> +		return -ENODEV;
> +
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		return -ENODEV;
> +
> +	return xlated_setup_gnttab_pages();
> +}
> +core_initcall(xen_pvh_gnttab_setup); /* Call it _before_ __gnttab_init */
> +#endif
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index e41c79c..073b4a1 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -846,7 +846,7 @@ static int __init gntdev_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> -	use_ptemod = xen_pv_domain();
> +	use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);
>  
>  	err = misc_register(&gntdev_miscdev);
>  	if (err != 0) {
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index b117fd6..2fa3a4c 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1098,7 +1098,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  	unsigned int nr_gframes = end_idx + 1;
>  	int rc;
>  
> -	if (xen_hvm_domain()) {
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> @@ -1174,7 +1174,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;
> @@ -1210,8 +1210,11 @@ static int gnttab_setup(void)
>  
>  	if (xen_feature(XENFEAT_auto_translated_physmap) && gnttab_shared.addr == NULL)
>  	{
> -		gnttab_shared.addr = xen_remap(xen_auto_xlat_grant_frames.vaddr,
> -					       PAGE_SIZE * max_nr_gframes);
> +		if (xen_hvm_domain()) {
> +			gnttab_shared.addr = xen_remap(xen_auto_xlat_grant_frames.vaddr,
> +						       PAGE_SIZE * max_nr_gframes);
> +		} else
> +			gnttab_shared.addr = xen_auto_xlat_grant_frames.vaddr;
>  		if (gnttab_shared.addr == NULL) {
>  			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
>  					xen_auto_xlat_grant_frames.vaddr);
> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
>  	return gnttab_init();
>  }
>  
> -core_initcall(__gnttab_init);
> +core_initcall_sync(__gnttab_init);
