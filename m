Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaGIJq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:46:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbaGIJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:46:56 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] mmap_vmcore: skip non-ram pages reported by hypervisors
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
	<20140708191159.GA17746@redhat.com>
Date: Wed, 09 Jul 2014 11:46:40 +0200
In-Reply-To: <20140708191159.GA17746@redhat.com> (Vivek Goyal's message of
	"Tue, 8 Jul 2014 15:11:59 -0400")
Message-ID: <87mwciooe7.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jul 07, 2014 at 05:05:49PM +0200, Vitaly Kuznetsov wrote:
>> we have a special check in read_vmcore() handler to check if the page was
>> reported as ram or not by the hypervisor (pfn_is_ram()).
>
> I am wondering if this name pfn_is_ram() appropriate for what we are 
> doing. So IIUC, a balooned memory is also RAM just that it has not 
> been allocated yet. That means we can safely assume that there is no
> data and can safely fill it with zeros?

For Xen pfn_is_ram() returns 0 in case the page is an mmio. Ballooned
pages are also considered being mmio (HVMOP_get_mem_type returns
HVMMEM_mmio_dm).

>
> If yes, then page_is_zero_filled() might be a more approprate name.
>

It's not as mmio page is not always zero-filled. We just don't need
these pages in vmcore.

> Also I am wondering why it was not done as part of copy_oldmem_page()
> so that respective arch could hide all the details.
>

Afaiac that wouldn't solve the mmap issue I'm trying to address but we
can ask Olaf why he preferred pfn_is_ram() path.

>> However, when
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
> I am not sure I understand this part. So what is "all other hypervisor
> specic" code which will like to do this. And will that code is compiled
> at the same time as CONFIG_XEN_PVHVM?
>

I meant to say that we have many hypervisors for x86 supported. In case
I override __weak remap_oldmem_pfn_range() in xen-specific code it will
*always* get executed when this code was compiled. In case we'll have to
do similar override in e.g. Hyperv or KVM code in future we'll have a
mess (in which order do we need to execute these overrides?).

In few words, Xen-PVHVM is not an architecture so I'm not following
"Architectures may override this function to map oldmem" path.

>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  fs/proc/vmcore.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 62 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
>> index 382aa89..2716e19 100644
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
>> +
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
>> +
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
>
> Why are we defining both remap_oldmem_pfn_checked()? Can't we just
> modify remap_oldmem_pfn_range() to *always* check for if
> pfn_is_zero_filled() and map accordingly.

I wanted to preserve the direct path without the check to make things
faster when the pfn_is_ram() handler was not registered. oldmem is huge
sometimes and issuing a single call per pfn can cost us something.

>
> Thanks
> Vivek

-- 
  Vitaly
