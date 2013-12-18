Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3LROtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:49:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44051 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3LROtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:49:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83510332"
Date: Wed, 18 Dec 2013 14:48:38 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 08/12] xen/pvh: MMU changes for PVH
In-Reply-To: <1387313503-31362-9-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181442050.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-9-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> .. which are surprinsingly small compared to the amount for PV code.
> 
> PVH uses mostly native mmu ops, we leave the generic (native_*) for
> the majority and just overwrite the baremetal with the ones we need.
> 
> We also optimize one - the TLB flush. The native operation would
> needlessly IPI offline VCPUs causing extra wakeups. Using the
> Xen one avoids that and lets the hypervisor determine which
> VCPU needs the TLB flush.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c | 35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index ce563be..77b7622 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -74,6 +74,7 @@
>  #include <xen/interface/version.h>
>  #include <xen/interface/memory.h>
>  #include <xen/hvc-console.h>
> +#include <xen/balloon.h>
>  
>  #include "multicalls.h"
>  #include "mmu.h"
> @@ -1207,6 +1208,8 @@ static void __init xen_pagetable_init(void)
>  #endif
>  	paging_init();
>  	xen_setup_shared_info();
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
>  #ifdef CONFIG_X86_64
>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>  		unsigned long new_mfn_list;

At the very least you should remove the second
XENFEAT_auto_translated_physmap check.  Also xen_setup_shared_info
contains yet another XENFEAT_auto_translated_physmap check. Maybe we
could refactor the code a bit to look nicer. Having a separate
xen_pagetable_init function for PVH could help.


> @@ -1556,6 +1559,10 @@ static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
>  static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
>  {
>  	struct mmuext_op op;
> +
> +	if (xen_feature(XENFEAT_writable_page_tables))
> +		return;
> +
>  	op.cmd = cmd;
>  	op.arg1.mfn = pfn_to_mfn(pfn);
>  	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))

Why do we need this? I thought that all the callers of pin_pagetable_pfn
are not actually enabled on PVH.


> @@ -1753,6 +1760,10 @@ static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
>  	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
>  	pte_t pte = pfn_pte(pfn, prot);
>  
> +	/* recall for PVH, page tables are native. */
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, flags))
>  		BUG();
>  }

This one too. Is it because we are reusing xen_setup_kernel_pagetable on
PVH?


> @@ -1834,6 +1845,9 @@ static void convert_pfn_mfn(void *v)
>  	pte_t *pte = v;
>  	int i;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	/* All levels are converted the same way, so just treat them
>  	   as ptes. */
>  	for (i = 0; i < PTRS_PER_PTE; i++)

This is getting pretty bad.
Can we find a way to refactor xen_setup_kernel_pagetable so that we
don't need all this? Maybe we need a new function?


> @@ -1863,6 +1877,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
>   * but that's enough to get __va working.  We need to fill in the rest
>   * of the physical mapping once some sort of allocator has been set
>   * up.
> + * NOTE: for PVH, the page tables are native.
>   */
>  void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  {
> @@ -1940,10 +1955,13 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	 * structure to attach it to, so make sure we just set kernel
>  	 * pgd.
>  	 */
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
>  	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
>  	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
>  	 * the initial domain. For guests using the toolstack, they are in:
> @@ -2207,6 +2225,15 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>  void __init xen_init_mmu_ops(void)
>  {
>  	x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +	/* Optimization - we can use the HVM one but it has no idea which
> +	 * VCPUs are descheduled - which means that it will needlessly IPI
> +	 * them. Xen knows so let it do the job.
> +	 */
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +		return;
> +	}
>  	pv_mmu_ops = xen_mmu_ops;
>  
>  	memset(dummy_mapping, 0xff, PAGE_SIZE);
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
