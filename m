Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbbAIPRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:17:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbbAIPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:17:10 -0500
Message-ID: <54AFF0F4.1030608@suse.com>
Date: Fri, 09 Jan 2015 16:17:08 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 2/3] xen: correct race in alloc_p2m_pmd()
References: <1420736490-15351-1-git-send-email-jgross@suse.com> <1420736490-15351-3-git-send-email-jgross@suse.com> <54AFEF2A.3090403@citrix.com>
In-Reply-To: <54AFEF2A.3090403@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:09 PM, David Vrabel wrote:
> On 08/01/15 17:01, Juergen Gross wrote:
>> When allocating a new pmd for the linear mapped p2m list a check is
>> done for not introducing another pmd when this just happened on
>> another cpu. In this case the old pte pointer was returned which
>> points to the p2m_missing or p2m_identity page. The correct value
>> would be the pointer to the found new page.
>
> Looking at the check I don't see how it works at all.
>
> alloc_p2m() looks up the address of the PTE page
>
> 	ptep = lookup_address(addr, &level);
> 	pte_pg = (pte_t *)((unsigned long)ptep & ~(PAGE_SIZE - 1));
>
> But the check under the lock that is still true does:
>
> 	ptechk = lookup_address(vaddr, &level);
> 	if (ptechk == pte_pg) {
>
> So I don't see how this works unless (by chance) we happen to get the
> first entry in the PTE page.

The check under lock tests vaddr which is pmd aligned.

> It also doesn't handle racing with p2m_missing_pte to p2m_identity_pte
> (or vice-versa) change.

The change is always and only for missing/identity to individual pmd.
There is no transition between all missing and identity pmds.

> Something like:
>
> 	ptechk = lookup_address(vaddr, &level);
> 	ptechk = (pte_t *)((unsigned long)ptechk & ~(PAGE_SIZE - 1));
> 	if (ptechk == p2m_missing_pte || ptechk == p2m_identity) {
>                set_pmd(..)
>
> Perhaps?

Would work, but is more complicated than needed. :-)


Juergen

>
> David
>
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
>> @@ -440,10 +440,9 @@ EXPORT_SYMBOL_GPL(get_phys_to_machine);
>>    * a new pmd is to replace p2m_missing_pte or p2m_identity_pte by a individual
>>    * pmd. In case of PAE/x86-32 there are multiple pmds to allocate!
>>    */
>> -static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
>> +static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *pte_pg)
>>   {
>>   	pte_t *ptechk;
>> -	pte_t *pteret = ptep;
>>   	pte_t *pte_newpg[PMDS_PER_MID_PAGE];
>>   	pmd_t *pmdp;
>>   	unsigned int level;
>> @@ -477,8 +476,6 @@ static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
>>   		if (ptechk == pte_pg) {
>>   			set_pmd(pmdp,
>>   				__pmd(__pa(pte_newpg[i]) | _KERNPG_TABLE));
>> -			if (vaddr == (addr & ~(PMD_SIZE - 1)))
>> -				pteret = pte_offset_kernel(pmdp, addr);
>>   			pte_newpg[i] = NULL;
>>   		}
>>
>> @@ -492,7 +489,7 @@ static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
>>   		vaddr += PMD_SIZE;
>>   	}
>>
>> -	return pteret;
>> +	return lookup_address(addr, &level);
>>   }
>>
>>   /*
>> @@ -521,7 +518,7 @@ static bool alloc_p2m(unsigned long pfn)
>>
>>   	if (pte_pg == p2m_missing_pte || pte_pg == p2m_identity_pte) {
>>   		/* PMD level is missing, allocate a new one */
>> -		ptep = alloc_p2m_pmd(addr, ptep, pte_pg);
>> +		ptep = alloc_p2m_pmd(addr, pte_pg);
>>   		if (!ptep)
>>   			return false;
>>   	}
>>
>
>

