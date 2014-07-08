Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaGHIJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaGHIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:09:08 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmap_vmcore: skip non-ram pages reported by hypervisors
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
	<20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
Date: Tue, 08 Jul 2014 10:08:58 +0200
In-Reply-To: <20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
	(Andrew Morton's message of "Mon, 7 Jul 2014 13:33:01 -0700")
Message-ID: <87k37o46hx.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon,  7 Jul 2014 17:05:49 +0200 Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> we have a special check in read_vmcore() handler to check if the page was
>> reported as ram or not by the hypervisor (pfn_is_ram()). However, when
>> vmcore is read with mmap() no such check is performed. That can lead to
>> unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
>> mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
>> enormous load in both DomU and Dom0.
>> 
>> Fix the issue by mapping each non-ram page to the zero page. Keep direct
>> path with remap_oldmem_pfn_range() to avoid looping through all pages on
>> bare metal.
>> 
>> The issue can also be solved by overriding remap_oldmem_pfn_range() in
>> xen-specific code, as remap_oldmem_pfn_range() was been designed for.
>> That, however, would involve non-obvious xen code path for all x86 builds
>> with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
>> code on x86 arch from doing the same override.
>
> I'd like to get some reviewed-by's and tested-by's on this one please.
>

This patch can be tested with Xen PVHVM guest only as it is the only
platform which registers oldmem_pfn_is_ram atm.

>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -328,6 +328,46 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
>>   * virtually contiguous user-space in ELF layout.
>>   */
>>  #ifdef CONFIG_MMU
>> +static u64 remap_oldmem_pfn_checked(struct vm_area_struct *vma, u64 len,
>> +				    unsigned long pfn, unsigned long page_count)
>> +{
>> +	unsigned long pos;
>> +	size_t size;
>> +	unsigned long vma_addr;
>> +	unsigned long emptypage_pfn = __pa(empty_zero_page) >> PAGE_SHIFT;
>
> That's old-school.  Can we use my_zero_pfn() here?
>
> Also, "zeropage_pfn" is a better name - let's not introduce the
> hitherto unknown concept of an "empty page".
>

Sure!

>> +	for (pos = pfn; (pos - pfn) <= page_count; pos++) {
>> +		if (!pfn_is_ram(pos) || (pos - pfn) == page_count) {
>> +			/* we hit a page which is not ram or reached the end */
>> +			if (pos - pfn > 0) {
>> +				/* remapping continuous region */
>> +				size = (pos - pfn) << PAGE_SHIFT;
>> +				vma_addr = vma->vm_start + len;
>> +				if (remap_oldmem_pfn_range(vma, vma_addr,
>> +							   pfn, size,
>> +							   vma->vm_page_prot))
>> +					return len;
>> +				len += size;
>> +				page_count -= (pos - pfn);
>> +			}
>> +			if (page_count > 0) {
>> +				/* we hit a page which is not ram, replacing
>> +				   with an empty one */
>
> I suggest
>
> 				/*
> 				 * We hit a page which is not ram.  Replace it
> 				 * with the zero page.
> 				 */
>

:-)

>> +				vma_addr = vma->vm_start + len;
>> +				if (remap_oldmem_pfn_range(vma, vma_addr,
>> +							   emptypage_pfn,
>> +							   PAGE_SIZE,
>> +							   vma->vm_page_prot))
>> +					return len;
>> +				len += PAGE_SIZE;
>> +				pfn = pos + 1;
>> +				page_count--;
>> +			}
>> +		}
>> +	}
>> +	return len;
>> +}
>
> Also, this loop seems unnecessarily hard to follow.  It *look* like the
> `for' statement has an off-by-one because of the "<=", but page_count
> is mofidied inside the loop!  Despite it being an incoming formal
> argument.

There is no off-by-one error here (I believe) as I'm checking two
possible conditions to remap the continuous region:
1) We hit a non-ram page
2) We reached the end
so we exclude the page pos is pointing us to in both cases.

I tried to avoid code duplication e.g. having one 'remap continuous
region' inside the loop to do the remapping when we hit a non-ram page
and having the other one outside the loop to remap the tail.

>
> None of this is made any easier by the function's lack of
> documentation.  Some description of the incoming args would help, along
> with an overall description of the function's responsibilities.
>
> That being said, can't we just do something nice and simple like
>
> 	pos = pfn;
> 	while (pos < pfn + page_count) {
> 		stuff which advances `pos'
> 	}
>
> ?
>

I completely agree it's possible to make this code easier to
understand, will do.

>>  static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>>  {
>>  	size_t size = vma->vm_end - vma->vm_start;
>> @@ -383,17 +423,33 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>>  
>>  	list_for_each_entry(m, &vmcore_list, list) {
>>  		if (start < m->offset + m->size) {
>> -			u64 paddr = 0;
>> +			u64 paddr = 0, original_len;
>> +			unsigned long pfn, page_count;
>>  
>>  			tsz = min_t(size_t, m->offset + m->size - start, size);
>>  			paddr = m->paddr + start - m->offset;
>> -			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
>> -						   paddr >> PAGE_SHIFT, tsz,
>> -						   vma->vm_page_prot))
>> -				goto fail;
>> +
>> +			/* check if oldmem_pfn_is_ram was registered to avoid
>> +			   looping over all pages without a reason */
>
> Please lay out the comments in the usual fashion:
>
> 	/*
> 	 * ...
> 	 * ..
> 	 */
>
> And sentences start whith upper-case letters!
>
>> +			if (oldmem_pfn_is_ram) {
>> +				pfn = paddr >> PAGE_SHIFT;
>> +				page_count = tsz >> PAGE_SHIFT;
>> +				original_len = len;
>> +				len = remap_oldmem_pfn_checked(vma, len, pfn,
>> +							       page_count);
>> +				if (len != original_len + tsz)
>> +					goto fail;
>> +			} else {
>> +				if (remap_oldmem_pfn_range(vma,
>> +							   vma->vm_start + len,
>> +							   paddr >> PAGE_SHIFT,
>> +							   tsz,
>> +							   vma->vm_page_prot))
>> +					goto fail;
>> +				len += tsz;
>> +			}
>>  			size -= tsz;
>>  			start += tsz;
>> -			len += tsz;
>>  
>>  			if (size == 0)
>>  				return 0;

Thank you very much for your review! I'm working on v2.

-- 
  Vitaly
