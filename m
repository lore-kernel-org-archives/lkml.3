Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaGISNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:13:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaGISNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:13:15 -0400
Date: Wed, 9 Jul 2014 14:13:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: hpa@linux.intel.com, david.vrabel@citrix.com, linux@eikelenboom.it,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] espfix/xen: Fix allocation of pages for paravirt page
 tables
Message-ID: <20140709181304.GA32419@laptop.dumpdata.com>
References: <1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:18:18PM -0400, Boris Ostrovsky wrote:
> init_espfix_ap() is currently off by one level when informing hypervisor
> that allocated pages will be used for ministacks' page tables.
> 
> The most immediate effect of this on a PV guest is that if
> 'stack_page = __get_free_page()' returns a non-zeroed-out page the hypervisor
> will refuse to use it for a page table (which it shouldn't be anyway). This will
> result in warnings by both Xen and Linux.
> 
> More importantly, a subsequent write to that page (again, by a PV guest) is
> likely to result in fatal page fault.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

<sigh>
> ---
>  arch/x86/kernel/espfix_64.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
> index 6afbb16..94d857f 100644
> --- a/arch/x86/kernel/espfix_64.c
> +++ b/arch/x86/kernel/espfix_64.c
> @@ -175,7 +175,7 @@ void init_espfix_ap(void)
>  	if (!pud_present(pud)) {
>  		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
>  		pud = __pud(__pa(pmd_p) | (PGTABLE_PROT & ptemask));
> -		paravirt_alloc_pud(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
> +		paravirt_alloc_pmd(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
>  		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
>  			set_pud(&pud_p[n], pud);
>  	}
> @@ -185,7 +185,7 @@ void init_espfix_ap(void)
>  	if (!pmd_present(pmd)) {
>  		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
>  		pmd = __pmd(__pa(pte_p) | (PGTABLE_PROT & ptemask));
> -		paravirt_alloc_pmd(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
> +		paravirt_alloc_pte(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
>  		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
>  			set_pmd(&pmd_p[n], pmd);
>  	}
> @@ -193,7 +193,6 @@ void init_espfix_ap(void)
>  	pte_p = pte_offset_kernel(&pmd, addr);
>  	stack_page = (void *)__get_free_page(GFP_KERNEL);
>  	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
> -	paravirt_alloc_pte(&init_mm, __pa(stack_page) >> PAGE_SHIFT);
>  	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
>  		set_pte(&pte_p[n*PTE_STRIDE], pte);
>  
> -- 
> 1.8.1.4
> 
