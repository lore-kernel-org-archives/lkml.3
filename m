Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3LRSrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:47:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:32903 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab3LRSrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:47:31 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85866655"
Date: Wed, 18 Dec 2013 18:46:56 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 10/12] xen/pvh: Piggyback on PVHVM for
 grant driver.
In-Reply-To: <1387313503-31362-11-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181831560.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-11-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
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
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/gntdev.c       |  2 +-
>  drivers/xen/grant-table.c  | 80 ++++++++++++++++++++++++++++++++++++++++++----
>  drivers/xen/platform-pci.c |  2 +-
>  include/xen/grant_table.h  |  2 +-
>  4 files changed, 76 insertions(+), 10 deletions(-)
> 
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
> index aa846a4..c0ded9f 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -47,6 +47,7 @@
>  #include <xen/interface/xen.h>
>  #include <xen/page.h>
>  #include <xen/grant_table.h>
> +#include <xen/balloon.h>
>  #include <xen/interface/memory.h>
>  #include <xen/hvc-console.h>
>  #include <xen/swiotlb-xen.h>
> @@ -66,8 +67,8 @@ static unsigned int boot_max_nr_grant_frames;
>  static int gnttab_free_count;
>  static grant_ref_t gnttab_free_head;
>  static DEFINE_SPINLOCK(gnttab_list_lock);
> -unsigned long xen_hvm_resume_frames;
> -EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
> +unsigned long xen_auto_xlat_grant_frames;
> +EXPORT_SYMBOL_GPL(xen_auto_xlat_grant_frames);
>  
>  static union {
>  	struct grant_entry_v1 *v1;
> @@ -1060,7 +1061,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  	unsigned int nr_gframes = end_idx + 1;
>  	int rc;
>  
> -	if (xen_hvm_domain()) {
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> @@ -1069,10 +1070,24 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  		 * index, ensuring that the table will grow only once.
>  		 */
>  		do {
> +			unsigned long vaddr;
> +			unsigned int level;
> +			pte_t *pte;
> +
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
>  			xatp.space = XENMAPSPACE_grant_table;
> -			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
> +
> +			/*
> +			 * Don't assume the memory is contingous. Lookup each.
> +			 */
> +			vaddr = xen_auto_xlat_grant_frames + (i * PAGE_SIZE);
> +			if (xen_hvm_domain())
> +				xatp.gpfn = vaddr >> PAGE_SHIFT;
> +			else {
> +				pte = lookup_address(vaddr, &level);

lookup_address is x86 only. I added an empty implementation under
arch/arm to be able to compile stuff under drivers/xen but I would like
to get rid of it.
If you can't find a way to replace lookup_address with something that
works on arm and arm64 too, you could always turn
xen_auto_xlat_grant_frames into an array and store the pfns there.


> +				xatp.gpfn = pte_mfn(*pte);

Do you actually need the mfn here? Don't you just need the pfn?



> +			}
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
>  			if (rc != 0) {
>  				pr_warn("grant table add_to_physmap failed, err=%d\n",
> @@ -1135,7 +1150,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))

just turn this to

if (xen_feature(XENFEAT_auto_translated_physmap))


>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;
> @@ -1161,6 +1176,46 @@ static void gnttab_request_version(void)
>  	pr_info("Grant tables using version %d layout\n", grant_table_version);
>  }
>  
> +static int xlated_setup_gnttab_pages(unsigned long nr_grant_frames,
> +				     unsigned long max, void *addr)
> +{
> +	struct page **pages;
> +	unsigned long *pfns;
> +	int rc, i;
> +
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
> +	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, max, addr);
> +
> +	kfree(pages);
> +	kfree(pfns);
> +	if (rc) {
> +		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
> +			nr_grant_frames, rc);
> +		free_xenballooned_pages(nr_grant_frames, pages);
> +		return rc;
> +	}
> +	return rc;
> +}

Please move this function somewhere under arch/x86/xen and call it from
xen_start_kernel, it doesn't belong to common code.


>  static int gnttab_setup(void)
>  {
>  	unsigned int max_nr_gframes;
> @@ -1169,15 +1224,26 @@ static int gnttab_setup(void)
>  	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap) && !xen_auto_xlat_grant_frames) {
> +		/*
> +		 * xen_auto_xlat_grant_frames is setup for PVHVM by
> +		 * alloc_xen_mmio by the time this is called.
> +		 */
> +		int rc = xlated_setup_gnttab_pages(max_nr_gframes, max_nr_gframes,
> +						   &gnttab_shared.addr);
> +		if (rc)
> +			return rc;
> +		xen_auto_xlat_grant_frames = (unsigned long)gnttab_shared.addr;
> +	}

I think you should do this from arch/x86/xen. When gnttab_setup is
called in your guest, xen_auto_xlat_grant_frames should have already
been setup correctly.


>  	if (xen_pv_domain())
>  		return gnttab_map(0, nr_grant_frames - 1);
>  
>  	if (gnttab_shared.addr == NULL) {
> -		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
> +		gnttab_shared.addr = xen_remap(xen_auto_xlat_grant_frames,
>  						PAGE_SIZE * max_nr_gframes);
>  		if (gnttab_shared.addr == NULL) {
>  			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
> -					xen_hvm_resume_frames);
> +					xen_auto_xlat_grant_frames);
>  			return -ENOMEM;
>  		}
>  	}
> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> index 2f3528e..44bc5a6 100644
> --- a/drivers/xen/platform-pci.c
> +++ b/drivers/xen/platform-pci.c
> @@ -154,7 +154,7 @@ static int platform_pci_init(struct pci_dev *pdev,
>  	}
>  
>  	max_nr_gframes = gnttab_max_grant_frames();
> -	xen_hvm_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> +	xen_auto_xlat_grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
>  	ret = gnttab_init();
>  	if (ret)
>  		goto out;
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 694dcaf..24280ac 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -178,7 +178,7 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
>  			   grant_status_t **__shared);
>  void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
>  
> -extern unsigned long xen_hvm_resume_frames;
> +extern unsigned long xen_auto_xlat_grant_frames;
>  unsigned int gnttab_max_grant_frames(void);
>  
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))

You need to s/xen_hvm_resume_frames/xen_auto_xlat_grant_frames under
arch/arm/xen too.
