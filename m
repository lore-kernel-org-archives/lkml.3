Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbbAWQVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:21:46 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42016 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbAWQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:21:43 -0500
Date: Fri, 23 Jan 2015 16:21:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "zhichang.yuan@linaro.org" <zhichang.yuan@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liguozhu@huawei.com" <liguozhu@huawei.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm64:mm: free the useless initial page table
Message-ID: <20150123162126.GD9557@e104818-lin.cambridge.arm.com>
References: <1418110007-13270-1-git-send-email-zhichang.yuan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418110007-13270-1-git-send-email-zhichang.yuan@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 07:26:47AM +0000, zhichang.yuan@linaro.org wrote:
> From: "zhichang.yuan" <zhichang.yuan@linaro.org>
> 
> For 64K page system, after mapping a PMD section, the corresponding initial
> page table is not needed any more. That page can be freed.
> 
> Changes since v1:
> 
> * make consistent code between alloc_init_pmd and alloc_init_pud;
> * flush the TLB before the unused page table is freed;
> 
> Signed-off-by: Zhichang Yuan <zhichang.yuan@linaro.org>

I thought about queuing this patch but I realised that
alloc_init_pmd/pud may be called in a late context where memblock_free()
would no longer make sense. Cc'ing Laura and Ard for any ideas here but
I think we may just end up with a few old page table pages sitting
around (not many though). In general we don't go from smaller to larger
mappings (that's what this patch targets) but given the API, I'm not
sure we have any guarantee.

One solution would be to check for alloc == early_alloc or something
similar. Cc'ing Laura and Ard as they added the create_mapping_late()
code.

> ---
>  arch/arm64/include/asm/pgtable.h |    3 +++
>  arch/arm64/mm/mmu.c              |   15 ++++++++++++---
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 41a43bf..8a135b6 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -337,9 +337,12 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  
>  #ifdef CONFIG_ARM64_64K_PAGES
>  #define pud_sect(pud)		(0)
> +#define pud_table(pud)		(1)
>  #else
>  #define pud_sect(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
>  				 PUD_TYPE_SECT)
> +#define pud_table(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
> +					PUD_TYPE_TABLE)
>  #endif
>  
>  static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index f4f8b50..515f75b 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -191,8 +191,14 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
>  			 * Check for previous table entries created during
>  			 * boot (__create_page_tables) and flush them.
>  			 */
> -			if (!pmd_none(old_pmd))
> +			if (!pmd_none(old_pmd)) {
>  				flush_tlb_all();
> +				if (pmd_table(old_pmd)) {
> +					phys_addr_t table = __pa(pte_offset_map(&old_pmd, 0));
> +
> +					memblock_free(table, PAGE_SIZE);
> +				}
> +			}
>  		} else {
>  			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
>  				       prot_pte);
> @@ -234,9 +240,12 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
>  			 * Look up the old pmd table and free it.
>  			 */
>  			if (!pud_none(old_pud)) {
> -				phys_addr_t table = __pa(pmd_offset(&old_pud, 0));
> -				memblock_free(table, PAGE_SIZE);
>  				flush_tlb_all();
> +				if (pud_table(old_pud)) {
> +					phys_addr_t table = __pa(pmd_offset(&old_pud, 0));
> +
> +					memblock_free(table, PAGE_SIZE);
> +				}
>  			}
>  		} else {
>  			alloc_init_pmd(pud, addr, next, phys, map_io);
> -- 
> 1.7.9.5
