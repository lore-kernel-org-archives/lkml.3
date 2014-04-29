Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbaD2JgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:36:03 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52570 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbaD2Jf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:35:58 -0400
Message-ID: <535F7271.2010504@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 15:05:45 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        dave.hansen@intel.com
Subject: Re: [PATCH V3 1/2] mm: move FAULT_AROUND_ORDER to arch/
References: <1398675690-16186-1-git-send-email-maddy@linux.vnet.ibm.com> <1398675690-16186-2-git-send-email-maddy@linux.vnet.ibm.com> <20140428093606.95B90E009B@blue.fi.intel.com>
In-Reply-To: <20140428093606.95B90E009B@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042909-5140-0000-0000-000005068D3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2014 03:06 PM, Kirill A. Shutemov wrote:
> Madhavan Srinivasan wrote:
>> Kirill A. Shutemov with 8c6e50b029 commit introduced
>> vm_ops->map_pages() for mapping easy accessible pages around
>> fault address in hope to reduce number of minor page faults.
>>
>> This patch creates infrastructure to modify the FAULT_AROUND_ORDER
>> value using mm/Kconfig. This will enable architecture maintainers
>> to decide on suitable FAULT_AROUND_ORDER value based on
>> performance data for that architecture. Patch also defaults
>> FAULT_AROUND_ORDER Kconfig element to 4.
>>
>> Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>> ---
>>  mm/Kconfig  |    8 ++++++++
>>  mm/memory.c |   11 ++++-------
>>  2 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index ebe5880..c7fc4f1 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -176,6 +176,14 @@ config MOVABLE_NODE
>>  config HAVE_BOOTMEM_INFO_NODE
>>  	def_bool n
>>  
>> +#
>> +# Fault around order is a control knob to decide the fault around pages.
>> +# Default value is set to 4 , but the arch can override it as desired.
>> +#
>> +config FAULT_AROUND_ORDER
>> +	int
>> +	default	4
>> +
>>  # eventually, we can have this option just 'select SPARSEMEM'
>>  config MEMORY_HOTPLUG
>>  	bool "Allow for memory hot-add"
>> diff --git a/mm/memory.c b/mm/memory.c
>> index d0f0bef..457436d 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3382,11 +3382,9 @@ void do_set_pte(struct vm_area_struct *vma, unsigned long address,
>>  	update_mmu_cache(vma, address, pte);
>>  }
>>  
>> -#define FAULT_AROUND_ORDER 4
>> +unsigned int fault_around_order = CONFIG_FAULT_AROUND_ORDER;
>>  
>>  #ifdef CONFIG_DEBUG_FS
>> -static unsigned int fault_around_order = FAULT_AROUND_ORDER;
>> -
>>  static int fault_around_order_get(void *data, u64 *val)
>>  {
>>  	*val = fault_around_order;
>> @@ -3395,7 +3393,6 @@ static int fault_around_order_get(void *data, u64 *val)
>>  
>>  static int fault_around_order_set(void *data, u64 val)
>>  {
>> -	BUILD_BUG_ON((1UL << FAULT_AROUND_ORDER) > PTRS_PER_PTE);
>>  	if (1UL << val > PTRS_PER_PTE)
>>  		return -EINVAL;
>>  	fault_around_order = val;
>> @@ -3430,14 +3427,14 @@ static inline unsigned long fault_around_pages(void)
>>  {
>>  	unsigned long nr_pages;
>>  
>> -	nr_pages = 1UL << FAULT_AROUND_ORDER;
>> +	nr_pages = 1UL << fault_around_order;
>>  	BUILD_BUG_ON(nr_pages > PTRS_PER_PTE);
> 
> This BUILD_BUG_ON() doesn't make sense any more since compiler usually can't
> prove anything about extern variable.
> 
> Drop it or change to VM_BUG_ON() or something.
> 

Ok.

>>  	return nr_pages;
>>  }
>>  
>>  static inline unsigned long fault_around_mask(void)
>>  {
>> -	return ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1);
>> +	return ~((1UL << (PAGE_SHIFT + fault_around_order)) - 1);
> 
> fault_around_pages() and fault_around_mask() should be moved outside of
> #ifdef CONFIG_DEBUG_FS and consolidated since they are practically identical
> both branches after the changes.
> 

Agreed. Will change it.

>>  }
>>  #endif
>>  
>> @@ -3495,7 +3492,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>  	 * if page by the offset is not ready to be mapped (cold cache or
>>  	 * something).
>>  	 */
>> -	if (vma->vm_ops->map_pages) {
>> +	if ((vma->vm_ops->map_pages) && (fault_around_order)) {
> 
> Way too many parentheses.
> 

Sure. Will modify it.

Thanks for review
with regards
Maddy
>>  		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
>>  		do_fault_around(vma, address, pte, pgoff, flags);
>>  		if (!pte_same(*pte, orig_pte))

