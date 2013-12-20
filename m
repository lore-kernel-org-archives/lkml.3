Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3LTGFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:05:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3LTGFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:05:08 -0500
Date: Fri, 20 Dec 2013 14:04:29 +0800
From: Baoquan He <bhe@redhat.com>
To: Bill Sumner <bill.sumner@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com
Subject: Re: [PATCHv2 4/6] Crashdump-Accepting-Active-IOMMU-Copy-Translations
Message-ID: <20131220060429.GB32194@dhcp-16-116.nay.redhat.com>
References: <1387507787-14163-1-git-send-email-bill.sumner@hp.com>
 <1387507787-14163-5-git-send-email-bill.sumner@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387507787-14163-5-git-send-email-bill.sumner@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 at 07:49pm, Bill Sumner wrote:

> +static int copy_page_addr(u64 page_addr, u32 shift, u32 bus, u32 devfn,
> +				u64 pte, struct dmar_domain *domain,
> +				void *parms)
> +{
> +	struct copy_page_addr_parms *ppap = parms;
> +
> +	u64 page_size = ((u64)1 << shift);	/* page_size */
> +	u64 pfn_lo;				/* For reserving IOVA range */
> +	u64 pfn_hi;				/* For reserving IOVA range */
> +	struct iova *iova_p;			/* For reserving IOVA range */
> +
> +	if (!ppap) {
> +		pr_err("ERROR: ppap is NULL: 0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
> +			bus, bus, devfn, devfn,  page_addr,
> +			page_size, page_size);
> +		return 0;
> +	}
> +

> +	/* Prepare for a new page */
> +	ppap->first     = 0;		/* Not first-time anymore */
> +	ppap->bus       = bus;
> +	ppap->devfn     = devfn;
> +	ppap->shift     = shift;
> +	ppap->pte       = pte;
> +	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
> +
> +	ppap->page_addr = page_addr;	/* Addr(new page) */
> +	ppap->page_size = page_size;	/* Size(new page) */
> +
> +	ppap->domain    = domain;	/* adr(domain for the new range) */

Here I am confused, ppap is used to collect the copied ranges and
necessary information. To my understanding, this domain is the
dmar_domain which the 1st device is on. When ppat->last is set to 1,
among the whole collected range, there may be many domains. I just feel
not good for this. Is it OK to define a specific lock for ppap
structure, possibly? Please correct me if I am wrong.

> +
> +	return 0;
> +}
> +

> +
> +
> +
> +static int copy_context_entry(struct intel_iommu *iommu, u32 bus, u32 devfn,
> +			      void *ppap, struct context_entry *ce)
> +{
> +	int ret = 0;			/* Integer Return Code */
> +	u32 shift = 0;			/* bits to shift page_addr  */
> +	u64 page_addr = 0;		/* Address of translated page */
> +	struct dma_pte *pgt_old_phys;	/* Adr(page_table in the old kernel) */
> +	struct dma_pte *pgt_new_phys;	/* Adr(page_table in the new kernel) */
> +	unsigned long asr;		/* New asr value for new context */
> +	u8  t;				/* Translation-type from context */
> +	u8  aw;				/* Address-width from context */
> +	u32 aw_shift[8] = {
> +		12+9+9,		/* [000b] 30-bit AGAW (2-level page table) */
> +		12+9+9+9,	/* [001b] 39-bit AGAW (3-level page table) */
> +		12+9+9+9+9,	/* [010b] 48-bit AGAW (4-level page table) */
> +		12+9+9+9+9+9,	/* [011b] 57-bit AGAW (5-level page table) */
> +		12+9+9+9+9+9+9,	/* [100b] 64-bit AGAW (6-level page table) */
> +		0,		/* [111b] Reserved */
> +		0,		/* [110b] Reserved */
> +		0,		/* [111b] Reserved */
> +	};
> +
> +	struct dmar_domain *domain = NULL;	/* To hold domain & device */
> +						/*    values from old kernel */
> +	struct device_domain_info *info = NULL;	/* adr(new for this device) */
> +	struct device_domain_info *i = NULL;	/* iterator for foreach */
> +
> +
 +	/* info->segment = segment;	 May need this later */
> +	info->bus = bus;
> +	info->devfn = devfn;
> +	info->iommu = iommu;
> +
> +	list_for_each_entry(i, &device_domain_values_list[iommu->seq_id],
> +				global) {
> +		if (i->domain->id == (int) context_get_did(ce)) {
> +			domain = i->domain;
> +			pr_debug("CTXT B:D:F:%2.2x:%2.2x:%1.1x Found did=0x%4.4x\n",
> +				bus, devfn >> 3, devfn & 0x7, i->domain->id);
> +			break;
> +		}
> +	}
> +
> +	if (!domain) {
> +		domain = alloc_domain();
> +		if (!domain) {
> +			ret = -ENOMEM;
> +			goto exit;
> +		}
> +		INIT_LIST_HEAD(&domain->devices);
> +		domain->id = (int) context_get_did(ce);
> +		domain->agaw = (int) context_get_aw(ce);
> +		domain->pgd = NULL;
		
Here the domain is created and initialized, but its member iovad is not
initialized. This will cause domain->iovad.iova_rbtree_lock deadlock
because its initial value is random. And the rbtree operation will
crash. This happen in reserve_iova invoked in copy_page_addr in high
frequency.

I add 1 line of code as below and it works well.

		init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
> +
> +		pr_debug("CTXT Allocated new list entry, did:%d\n",
> +			domain->id);
> +	}
> +
> +	info->domain = domain;
> +	list_add(&info->link, &domain->devices);
> +	list_add(&info->global, &device_domain_values_list[iommu->seq_id]);
> +
> +	if (domain->pgd) {
> +		asr = virt_to_phys(domain->pgd) >> VTD_PAGE_SHIFT;
> +		context_put_asr(ce, asr);
> +		ret = 4;
> +		goto exit;
> +	}
> +
> +	t = context_get_t(ce);
> +
> +	if (t == 0 || t == 1) {		/* If (context has page tables) */
> +		aw = context_get_aw(ce);
> +		shift = aw_shift[aw];
> +
> +		pgt_old_phys = (struct dma_pte *)(context_get_asr(ce) << 12);
> +
> +		ret = copy_page_table(&pgt_new_phys, pgt_old_phys,
> +			shift-9, page_addr, iommu, bus, devfn, domain, ppap);
> +
> +		if (ret)		/* if (problem) bail out */
> +			goto exit;
> +
> +		asr = ((unsigned long)(pgt_new_phys)) >> VTD_PAGE_SHIFT;
> +		context_put_asr(ce, asr);
> +		domain->pgd = phys_to_virt((unsigned long)pgt_new_phys);
> +		ret = 1;
> +		goto exit;
> +	}
> +
> +	return ret;
> +}
> +
