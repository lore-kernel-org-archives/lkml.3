Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaACQyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:54:49 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5128 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaACQys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:54:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87403236"
Date: Fri, 3 Jan 2014 16:53:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 14/18] xen/grant: Implement an grant frame array
 struct.
In-Reply-To: <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031644120.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> The 'xen_hvm_resume_frames' used to be an 'unsigned long'
> and contain the virtual address of the grants. That was OK
> for most architectures (PVHVM, ARM) were the grants are contingous
> in memory. That however is not the case for PVH - in which case
> we will have to do a lookup for each virtual address for the PFN.
> 
> Instead of doing that, lets make it a structure which will contain
> the array of PFNs, the virtual address and the count of said PFNs.
> 
> Also provide a generic functions: gnttab_setup_auto_xlat_frames and
> gnttab_free_auto_xlat_frames to populate said structure with
> appropiate values for PVHVM and ARM.
     ^appropriate


> To round it off, change the name from 'xen_hvm_resume_frames' to
> a more descriptive one - 'xen_auto_xlat_grant_frames'.
> 
> For PVH, in patch "xen/pvh: Piggyback on PVHVM for grant driver"
> we will populate the 'xen_auto_xlat_grant_frames' by ourselves.
> 
> Suggested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/arm/xen/enlighten.c   |  9 +++++++--
>  drivers/xen/grant-table.c  | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  drivers/xen/platform-pci.c | 10 +++++++---
>  include/xen/grant_table.h  |  9 ++++++++-
>  4 files changed, 62 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 8550123..2162172 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -208,6 +208,7 @@ static int __init xen_guest_init(void)
>  	const char *version = NULL;
>  	const char *xen_prefix = "xen,xen-";
>  	struct resource res;
> +	unsigned long grant_frames;
>  
>  	node = of_find_compatible_node(NULL, NULL, "xen,xen");
>  	if (!node) {
> @@ -224,10 +225,10 @@ static int __init xen_guest_init(void)
>  	}
>  	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
>  		return 0;
> -	xen_hvm_resume_frames = res.start;
> +	grant_frames = res.start;
>  	xen_events_irq = irq_of_parse_and_map(node, 0);
>  	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
> -			version, xen_events_irq, (xen_hvm_resume_frames >> PAGE_SHIFT));
> +			version, xen_events_irq, (grant_frames >> PAGE_SHIFT));
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
>  	xen_setup_features();
> @@ -265,6 +266,10 @@ static int __init xen_guest_init(void)
>  	if (xen_vcpu_info == NULL)
>  		return -ENOMEM;
>  
> +	if (gnttab_setup_auto_xlat_frames(grant_frames)) {
> +		free_percpu(xen_vcpu_info);
> +		return -ENOMEM;
> +	}
>  	gnttab_init();
>  	if (!xen_initial_domain())
>  		xenbus_probe(NULL);
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index cc1b4fa..b117fd6 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -65,8 +65,8 @@ static unsigned int nr_grant_frames;
>  static int gnttab_free_count;
>  static grant_ref_t gnttab_free_head;
>  static DEFINE_SPINLOCK(gnttab_list_lock);
> -unsigned long xen_hvm_resume_frames;
> -EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
> +struct grant_frames xen_auto_xlat_grant_frames;
> +EXPORT_SYMBOL_GPL(xen_auto_xlat_grant_frames);

it should be static now


>  static union {
>  	struct grant_entry_v1 *v1;
> @@ -838,6 +838,40 @@ unsigned int gnttab_max_grant_frames(void)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
>  
> +int gnttab_setup_auto_xlat_frames(unsigned long addr)
> +{
> +	xen_pfn_t *pfn;
> +	unsigned int max_nr_gframes = __max_nr_grant_frames();
> +	int i;
> +
> +	if (xen_auto_xlat_grant_frames.count)
> +		return -EINVAL;
> +
> +	pfn = kcalloc(max_nr_gframes, sizeof(pfn[0]), GFP_KERNEL);
> +	if (!pfn)
> +		return -ENOMEM;
> +	for (i = 0; i < max_nr_gframes; i++)
> +		pfn[i] = PFN_DOWN(addr + (i * PAGE_SIZE));
> +
> +	xen_auto_xlat_grant_frames.vaddr = addr;
> +	xen_auto_xlat_grant_frames.pfn = pfn;
> +	xen_auto_xlat_grant_frames.count = max_nr_gframes;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(gnttab_setup_auto_xlat_frames);
> +
> +void gnttab_free_auto_xlat_frames(void)
> +{
> +	if (!xen_auto_xlat_grant_frames.count)
> +		return;
> +	kfree(xen_auto_xlat_grant_frames.pfn);
> +	xen_auto_xlat_grant_frames.pfn = NULL;
> +	xen_auto_xlat_grant_frames.count = 0;
> +	xen_auto_xlat_grant_frames.vaddr = 0;
> +}
> +EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);

I would leave vaddr alone in gnttab_setup_auto_xlat_frames and
gnttab_free_auto_xlat_frames


>  /* Handling of paged out grant targets (GNTST_eagain) */
>  #define MAX_DELAY 256
>  static inline void
> @@ -1068,6 +1102,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> +		BUG_ON(xen_auto_xlat_grant_frames.count < nr_gframes);
>  		/*
>  		 * Loop backwards, so that the first hypercall has the largest
>  		 * index, ensuring that the table will grow only once.
> @@ -1076,7 +1111,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
>  			xatp.space = XENMAPSPACE_grant_table;
> -			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
> +			xatp.gpfn = xen_auto_xlat_grant_frames.pfn[i];
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
>  			if (rc != 0) {
>  				pr_warn("grant table add_to_physmap failed, err=%d\n",
> @@ -1175,11 +1210,11 @@ static int gnttab_setup(void)
>  
>  	if (xen_feature(XENFEAT_auto_translated_physmap) && gnttab_shared.addr == NULL)
>  	{
> -		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
> +		gnttab_shared.addr = xen_remap(xen_auto_xlat_grant_frames.vaddr,
>  					       PAGE_SIZE * max_nr_gframes);

here you can xen_remap xen_auto_xlat_grant_frames.pfn[0] instead


>  		if (gnttab_shared.addr == NULL) {
>  			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
> -					xen_hvm_resume_frames);
> +					xen_auto_xlat_grant_frames.vaddr);
>  			return -ENOMEM;
>  		}
>  	}
> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> index 2f3528e..f1947ac 100644
> --- a/drivers/xen/platform-pci.c
> +++ b/drivers/xen/platform-pci.c
> @@ -108,6 +108,7 @@ static int platform_pci_init(struct pci_dev *pdev,
>  	long ioaddr;
>  	long mmio_addr, mmio_len;
>  	unsigned int max_nr_gframes;
> +	unsigned long grant_frames;
>  
>  	if (!xen_domain())
>  		return -ENODEV;
> @@ -154,13 +155,16 @@ static int platform_pci_init(struct pci_dev *pdev,
>  	}
>  
>  	max_nr_gframes = gnttab_max_grant_frames();
> -	xen_hvm_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> +	grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> +	if (gnttab_setup_auto_xlat_frames(grant_frames))
> +		goto out;
>  	ret = gnttab_init();
>  	if (ret)
> -		goto out;
> +		goto grant_out;
>  	xenbus_probe(NULL);
>  	return 0;
> -
> +grant_out:
> +	gnttab_free_auto_xlat_frames();
>  out:
>  	pci_release_region(pdev, 0);
>  mem_out:
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 694dcaf..a997406 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -178,8 +178,15 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
>  			   grant_status_t **__shared);
>  void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
>  
> -extern unsigned long xen_hvm_resume_frames;
> +struct grant_frames {
> +	xen_pfn_t *pfn;
> +	int count;
> +	unsigned long vaddr;
> +};
> +extern struct grant_frames xen_auto_xlat_grant_frames;
>  unsigned int gnttab_max_grant_frames(void);
> +int gnttab_setup_auto_xlat_frames(unsigned long addr);
> +void gnttab_free_auto_xlat_frames(void);
>  
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
>  
> -- 
> 1.8.3.1
> 
