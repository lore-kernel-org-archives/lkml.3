Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3LMQ4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:56:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42608 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3LMQ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:56:06 -0500
Message-ID: <52AB3BD5.9090603@oracle.com>
Date: Fri, 13 Dec 2013 11:54:45 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        david.vrabel@citrix.com, Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V10 03/14] xen/pvh: Implement MMU changes for PVH.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 09:10 PM, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
>
> .. which are surprinsingly small compared to the amount for PV.
> First the set/clear mmio pte function make a hypercall to update the
> P2M in Xen with 1:1 mapping. Since PVH uses mostly native mmu ops, we
> leave the generic (native_*) for the majority and just overwrite the
> baremetal with the ones we need.
>
> Two local functions are introduced to add to Xen physmap for Xen remap
> interface. Xen unmap interface is introduced so that the privcmd PTe entries
> can be cleared in Xen P2M table.
>
> ijc -- rebase on top of ARM privcmd changes rather than vice versa,
> xen_remap_domain_mfn_range (and unmap) split into a separate patch
> earlier in the series.
>
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> [v1: Rebase on x86, mm, Xen: Remove mapping_pagetable_reserve()]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> Conflicts:
> 	arch/x86/xen/mmu.c
> [due to xen/mmu: On early bootup, flush the TLB when changing RO->RW
> bits Xen provided pagetables.]
> ---
>   arch/x86/xen/mmu.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>   arch/x86/xen/mmu.h |    2 +
>   2 files changed, 144 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index ce563be..c7de065 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -74,6 +74,7 @@
>   #include <xen/interface/version.h>
>   #include <xen/interface/memory.h>
>   #include <xen/hvc-console.h>
> +#include <xen/balloon.h>
>   
>   #include "multicalls.h"
>   #include "mmu.h"
> @@ -332,6 +333,20 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
>   	__xen_set_pte(ptep, pteval);
>   }
>   
> +void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
> +			      int nr_mfns, int add_mapping)

This probably belongs to the next patch since it's there where it is 
used for the first time.

> +{
> +	struct physdev_map_iomem iomem;
> +
> +	iomem.first_gfn = pfn;
> +	iomem.first_mfn = mfn;
> +	iomem.nr_mfns = nr_mfns;
> +	iomem.add_mapping = add_mapping;
> +
> +	if (HYPERVISOR_physdev_op(PHYSDEVOP_map_iomem, &iomem))
> +		BUG();
> +}
> +
>   static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
>   		    pte_t *ptep, pte_t pteval)
>   {
> @@ -1207,6 +1222,8 @@ static void __init xen_pagetable_init(void)
>   #endif
>   	paging_init();
>   	xen_setup_shared_info();
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
>   #ifdef CONFIG_X86_64
>   	if (!xen_feature(XENFEAT_auto_translated_physmap)) {

You can remove this check.

>   		unsigned long new_mfn_list;
> @@ -1556,6 +1573,10 @@ static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
>   static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
>   {
>   	struct mmuext_op op;
> +
> +	if (xen_feature(XENFEAT_writable_page_tables))
> +		return;
> +
>   	op.cmd = cmd;
>   	op.arg1.mfn = pfn_to_mfn(pfn);
>   	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
> @@ -1753,6 +1774,10 @@ static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
>   	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
>   	pte_t pte = pfn_pte(pfn, prot);
>   
> +	/* recall for PVH, page tables are native. */
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;

pfn/pte don't need to be initialized for PVH.

> +
>   	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, flags))
>   		BUG();
>   }
> @@ -1834,6 +1859,9 @@ static void convert_pfn_mfn(void *v)
>   	pte_t *pte = v;
>   	int i;
>   
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>   	/* All levels are converted the same way, so just treat them
>   	   as ptes. */
>   	for (i = 0; i < PTRS_PER_PTE; i++)
> @@ -1853,6 +1881,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
>   		(*pt_end)--;
>   	}
>   }
> +
>   /*
>    * Set up the initial kernel pagetable.
>    *
> @@ -1863,6 +1892,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
>    * but that's enough to get __va working.  We need to fill in the rest
>    * of the physical mapping once some sort of allocator has been set
>    * up.
> + * NOTE: for PVH, the page tables are native.
>    */
>   void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>   {
> @@ -1940,10 +1970,13 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>   	 * structure to attach it to, so make sure we just set kernel
>   	 * pgd.
>   	 */
> -	xen_mc_batch();
> -	__xen_write_cr3(true, __pa(init_level4_pgt));
> -	xen_mc_issue(PARAVIRT_LAZY_CPU);
> -
> +	if (xen_feature(XENFEAT_writable_page_tables)) {
> +		native_write_cr3(__pa(init_level4_pgt));
> +	} else {
> +		xen_mc_batch();
> +		__xen_write_cr3(true, __pa(init_level4_pgt));
> +		xen_mc_issue(PARAVIRT_LAZY_CPU);
> +	}
>   	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
>   	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
>   	 * the initial domain. For guests using the toolstack, they are in:
> @@ -2207,6 +2240,11 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>   void __init xen_init_mmu_ops(void)
>   {
>   	x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +		return;
> +	}
>   	pv_mmu_ops = xen_mmu_ops;
>   
>   	memset(dummy_mapping, 0xff, PAGE_SIZE);
> @@ -2487,6 +2525,89 @@ void __init xen_hvm_init_mmu_ops(void)
>   }
>   #endif
>   
> +/* Map foreign gmfn, fgmfn, to local pfn, lpfn. This for the user space
> + * creating new guest on PVH dom0 and needs to map domU pages.

Since we don't yet have dom0 PVH support in the hypervsor, should this 
be deferred (or at least separated into another patch)?

> + */
> +static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
> +			      unsigned int domid)
> +{
> +	int rc;
> +	struct xen_add_to_physmap xatp = { .foreign_domid = domid };

Why initialize foreign_domid with different syntax than the rest?


> +
> +	xatp.gpfn = lpfn;
> +	xatp.idx = fgmfn;
> +	xatp.domid = DOMID_SELF;
> +	xatp.space = XENMAPSPACE_gmfn_foreign;
> +	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
> +	if (rc)
> +		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d\n",
> +			lpfn, fgmfn, rc);
> +	return rc;
> +}
> +
> +static int pvh_rem_xen_p2m(unsigned long spfn, int count)

I don't think "rem" is a common abbreviation for "remove". Perhaps "rm", 
"del" or "remove"?

-boris

> +{
> +	struct xen_remove_from_physmap xrp;
> +	int i, rc;
> +
> +	for (i = 0; i < count; i++) {
> +		xrp.domid = DOMID_SELF;
> +		xrp.gpfn = spfn+i;
> +		rc = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrp);
> +		if (rc) {
> +			pr_warn("Failed to unmap pfn:%lx rc:%d done:%d\n",
> +				spfn+i, rc, i);
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +struct pvh_remap_data {
> +	unsigned long fgmfn;		/* foreign domain's gmfn */
> +	pgprot_t prot;
> +	domid_t  domid;
> +	int	 index;
> +	struct page **pages;
> +};
> +
> +static int pvh_map_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
> +			void *data)
> +{
> +	int rc;
> +	struct pvh_remap_data *remap = data;
> +	unsigned long pfn = page_to_pfn(remap->pages[remap->index++]);
> +	pte_t pteval = pte_mkspecial(pfn_pte(pfn, remap->prot));
> +
> +	rc = pvh_add_to_xen_p2m(pfn, remap->fgmfn, remap->domid);
> +	if (rc)
> +		return rc;
> +	native_set_pte(ptep, pteval);
> +
> +	return 0;
> +}
> +
> +static int pvh_remap_gmfn_range(struct vm_area_struct *vma,
> +				unsigned long addr, unsigned long mfn, int nr,
> +				pgprot_t prot, unsigned domid,
> +				struct page **pages)
> +{
> +	int err;
> +	struct pvh_remap_data pvhdata;
> +
> +	BUG_ON(!pages);
> +
> +	pvhdata.fgmfn = mfn;
> +	pvhdata.prot = prot;
> +	pvhdata.domid = domid;
> +	pvhdata.index = 0;
> +	pvhdata.pages = pages;
> +	err = apply_to_page_range(vma->vm_mm, addr, nr << PAGE_SHIFT,
> +				  pvh_map_pte_fn, &pvhdata);
> +	flush_tlb_all();
> +	return err;
> +}
> +
>   #define REMAP_BATCH_SIZE 16
>   
>   struct remap_data {
> @@ -2528,6 +2649,10 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>   
>   	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_IO)) == (VM_PFNMAP | VM_IO)));
>   
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		/* We need to update the local page tables and the xen HAP */
> +		return pvh_remap_gmfn_range(vma, addr, mfn, nr, prot, domid, pages);
> +	}
>   	rmd.mfn = mfn;
>   	rmd.prot = prot;
>   
> @@ -2565,6 +2690,18 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>   	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
>   		return 0;
>   
> -	return -EINVAL;
> +	while (numpgs--) {
> +
> +		/* the mmu has already cleaned up the process mmu resources at
> +		 * this point (lookup_address will return NULL). */
> +		unsigned long pfn = page_to_pfn(pages[numpgs]);
> +
> +		pvh_rem_xen_p2m(pfn, 1);
> +	}
> +	/* We don't need to flush tlbs because as part of pvh_rem_xen_p2m(),
> +	 * the hypervisor will do tlb flushes after removing the p2m entries
> +	 * from the EPT/NPT */
> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
> diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
> index 73809bb..6d0bb56 100644
> --- a/arch/x86/xen/mmu.h
> +++ b/arch/x86/xen/mmu.h
> @@ -23,4 +23,6 @@ unsigned long xen_read_cr2_direct(void);
>   
>   extern void xen_init_mmu_ops(void);
>   extern void xen_hvm_init_mmu_ops(void);
> +extern void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
> +				     int nr_mfns, int add_mapping);
>   #endif	/* _XEN_MMU_H */

