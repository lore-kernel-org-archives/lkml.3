Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaDSOGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaDSOGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:06:06 -0400
Date: Sat, 19 Apr 2014 22:05:27 +0800
From: Baoquan He <bhe@redhat.com>
To: Bill Sumner <bill.sumner@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        zhenhua@hp.com
Subject: Re: [PATCH 2/8] Consolidate all .h lines at front of intel-iommu.c
 file
Message-ID: <20140419140444.GA1565@dhcp-17-102.nay.redhat.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
 <1397603349-30930-3-git-send-email-bill.sumner@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397603349-30930-3-git-send-email-bill.sumner@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

Could you rebase on latest linus's kernel tree, since there are several
changes in intel-iommu.c. This patch can't be applied because of below
commits. I think patch need be reabsed on latest linus's tree before
post, people will apply your patch without conflict.

commit b94e4117f8c4ffb591b1e462364d725e3a1c63c4
Author: Jiang Liu <jiang.liu@linux.intel.com>
Date:   Wed Feb 19 14:07:25 2014 +0800

    iommu/vt-d: Move private structures and variables into intel-iommu.c
    
    Move private structures and variables into intel-iommu.c, which will
    help to simplify locking policy for hotplug. Also delete redundant
    declarations.
    
    Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
    Signed-off-by: Joerg Roedel <joro@8bytes.org>


Thanks
Baoquan

On 04/15/14 at 05:09pm, Bill Sumner wrote:
>  In intel-iommu.c, move downward the few lines near the
>  front that should not move to an intel-iommu-private.h
>  file (mostly data-item definitions) This leaves a
>  consolidated block of the lines that would move to an
>  intel-iommu-private.h file at the front of the file.
> 
> 
> Signed-off-by: Bill Sumner <bill.sumner@hp.com>
> ---
>  drivers/iommu/intel-iommu.c | 74 +++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 8abcb6c..22298e9 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -165,17 +165,6 @@ static inline unsigned long virt_to_dma_pfn(void *p)
>  	return page_to_dma_pfn(virt_to_page(p));
>  }
>  
> -/* global iommu list, set NULL for ignored DMAR units */
> -static struct intel_iommu **g_iommus;
> -
> -static void __init check_tylersburg_isoch(void);
> -static int rwbf_quirk;
> -
> -/*
> - * set to 1 to panic kernel if can't successfully enable VT-d
> - * (used when kernel is launched w/ TXT)
> - */
> -static int force_on;
>  
>  /*
>   * 0: Present
> @@ -314,15 +303,6 @@ static inline int first_pte_in_page(struct dma_pte *pte)
>  	return !((unsigned long)pte & ~VTD_PAGE_MASK);
>  }
>  
> -/*
> - * This domain is a statically identity mapping domain.
> - *	1. This domain creats a static 1:1 mapping to all usable memory.
> - *	2. It maps to each iommu if successful.
> - *	3. Each iommu mapps to this domain if successful.
> - */
> -static struct dmar_domain *si_domain;
> -static int hw_pass_through = 1;
> -
>  /* devices under the same p2p bridge are owned in one domain */
>  #define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
>  
> @@ -380,6 +360,44 @@ struct device_domain_info {
>  	struct dmar_domain *domain; /* pointer to domain */
>  };
>  
> +static inline void *alloc_pgtable_page(int node)
> +{
> +	struct page *page;
> +	void *vaddr = NULL;
> +
> +	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
> +	if (page)
> +		vaddr = page_address(page);
> +	return vaddr;
> +}
> +
> +static inline void free_pgtable_page(void *vaddr)
> +{
> +	free_page((unsigned long)vaddr);
> +}
> +
> +
> +static void __init check_tylersburg_isoch(void);
> +
> +/* global iommu list, set NULL for ignored DMAR units */
> +static struct intel_iommu **g_iommus;
> +static int rwbf_quirk;
> +
> +/*
> + * set to 1 to panic kernel if can't successfully enable VT-d
> + * (used when kernel is launched w/ TXT)
> + */
> +static int force_on;
> +
> +/*
> + * This domain is a statically identity mapping domain.
> + *	1. This domain creats a static 1:1 mapping to all usable memory.
> + *	2. It maps to each iommu if successful.
> + *	3. Each iommu mapps to this domain if successful.
> + */
> +static struct dmar_domain *si_domain;
> +static int hw_pass_through = 1;
> +
>  static void flush_unmaps_timeout(unsigned long data);
>  
>  static DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
> @@ -468,22 +486,6 @@ static struct kmem_cache *iommu_domain_cache;
>  static struct kmem_cache *iommu_devinfo_cache;
>  static struct kmem_cache *iommu_iova_cache;
>  
> -static inline void *alloc_pgtable_page(int node)
> -{
> -	struct page *page;
> -	void *vaddr = NULL;
> -
> -	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
> -	if (page)
> -		vaddr = page_address(page);
> -	return vaddr;
> -}
> -
> -static inline void free_pgtable_page(void *vaddr)
> -{
> -	free_page((unsigned long)vaddr);
> -}
> -
>  static inline void *alloc_domain_mem(void)
>  {
>  	return kmem_cache_alloc(iommu_domain_cache, GFP_ATOMIC);
> -- 
> Bill Sumner <bill.sumner@hp.com>
> 
