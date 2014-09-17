Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaIQOVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:21:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbaIQOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:21:01 -0400
Message-ID: <541998CB.4000409@suse.com>
Date: Wed, 17 Sep 2014 16:20:59 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Subject: Re: [Xen-devel] [PATCH V2 3/3] xen: eliminate scalability issues
 from initial mapping setup
References: <1410927157-15069-1-git-send-email-jgross@suse.com> <1410927157-15069-4-git-send-email-jgross@suse.com> <54199589.9040703@citrix.com>
In-Reply-To: <54199589.9040703@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 04:07 PM, David Vrabel wrote:
> On 17/09/14 05:12, Juergen Gross wrote:
>> Direct Xen to place the initial P->M table outside of the initial
>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>> restriction on the size of the initial mapping limits the amount
>> of memory a domain can be handed initially.
>>
>> As the initial P->M table is copied rather early during boot to
>> domain private memory and it's initial virtual mapping is dropped,
>> the easiest way to avoid virtual address conflicts with other
>> addresses in the kernel is to use a user address area for the
>> virtual address of the initial P->M table. This allows us to just
>> throw away the page tables of the initial mapping after the copy
>> without having to care about address invalidation.
>
> This needs an additional paragraph like:
>
>    "This does not increase the amount of memory the guest can use.  This
> is still limited to 512 GiB by the 3-level p2m."
>
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1198,6 +1198,76 @@ static void __init xen_cleanhighmap(unsigned long vaddr,
> [...]
>> +/*
>> + * Since it is well isolated we can (and since it is perhaps large we should)
>> + * also free the page tables mapping the initial P->M table.
>> + */
>> +static void __init xen_cleanmfnmap(unsigned long vaddr)
>> +{
>> +	unsigned long va = vaddr & PMD_MASK;
>> +	unsigned long pa;
>> +	pgd_t *pgd = pgd_offset_k(va);
>> +	pud_t *pud_page = pud_offset(pgd, 0);
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +	unsigned int i;
>> +
>> +	set_pgd(pgd, __pgd(0));
>> +	do {
>> +		pud = pud_page + pud_index(va);
>> +		if (pud_none(*pud)) {
>> +			va += PUD_SIZE;
>> +		} else if (pud_large(*pud)) {
>> +			pa = pud_val(*pud) & PHYSICAL_PAGE_MASK;
>> +			xen_free_ro_pages(pa, PUD_SIZE);
>> +			va += PUD_SIZE;
>
> Are you missing a ClearPagePinned(..) here?

Probably, yes.

>
>> +		} else {
>> +			pmd = pmd_offset(pud, va);
>> +			if (pmd_large(*pmd)) {
>> +				pa = pmd_val(*pmd) & PHYSICAL_PAGE_MASK;
>> +				xen_free_ro_pages(pa, PMD_SIZE);
>> +			} else if (!pmd_none(*pmd)) {
>> +				pte = pte_offset_kernel(pmd, va);
>> +				for (i = 0; i < PTRS_PER_PTE; ++i) {
>> +					if (pte_none(pte[i]))
>> +						break;
>> +					pa = pte_pfn(pte[i]) << PAGE_SHIFT;
>> +					xen_free_ro_pages(pa, PAGE_SIZE);
>> +				}
>
>> +				pa = __pa(pte) & PHYSICAL_PAGE_MASK;
>> +				ClearPagePinned(virt_to_page(__va(pa)));
>> +				xen_free_ro_pages(pa, PAGE_SIZE);
>
> Put this into a helper function?  It's used here...

Good idea.

>
>> +			}
>> +			va += PMD_SIZE;
>> +			if (pmd_index(va))
>> +				continue;
>> +			pa = __pa(pmd) & PHYSICAL_PAGE_MASK;
>> +			ClearPagePinned(virt_to_page(__va(pa)));
>> +			xen_free_ro_pages(pa, PAGE_SIZE);
>
> ...and here...
>
>> +		}
>> +
>> +	} while (pud_index(va) || pmd_index(va));
>> +	pa = __pa(pud_page) & PHYSICAL_PAGE_MASK;
>> +	ClearPagePinned(virt_to_page(__va(pa)));
>> +	xen_free_ro_pages(pa, PAGE_SIZE);
>
> ... and here.
>
>> @@ -1529,6 +1604,22 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>>   #else /* CONFIG_X86_64 */
>>   static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>>   {
>> +	unsigned long pfn;
>> +
>> +	if (xen_feature(XENFEAT_writable_page_tables) ||
>> +	    xen_feature(XENFEAT_auto_translated_physmap) ||
>> +	    xen_start_info->mfn_list >= __START_KERNEL_map)
>> +		return pte;
>> +
>> +	/*
>> +	 * Pages belonging to the initial p2m list mapped outside the default
>> +	 * address range must be mapped read-only.
>
> Why?  I didn't think was anything special about these MFNs.

The hypervisor complained when I did otherwise. I think the main reason
is that the hypervisor will set up some more page tables to be able to
map then mfn_list outside the "normal" address range. They are located
in the range starting at xen_start_info->first_p2m_pfn (otherwise the
info in first_p2m_pfn and nr_p2m_frames wouldn't be needed).

And page tables must be mapped read-only.


Juergen
