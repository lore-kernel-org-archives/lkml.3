Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LMBnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:43:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51654 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3LMBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:43:04 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52AA65F5.5090902@jp.fujitsu.com>
Date: Fri, 13 Dec 2013 10:42:13 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vmcore: copy fractional pages into buffers in the
 kdump 2nd kernel
References: <52A579EE.6090107@jp.fujitsu.com> <20131212164249.GC31540@redhat.com>
In-Reply-To: <20131212164249.GC31540@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/13 1:42), Vivek Goyal wrote:
> On Mon, Dec 09, 2013 at 05:06:06PM +0900, HATAYAMA Daisuke wrote:
>> This is a patch for fixing mmap failure due to fractional page issue.
>>
>> This patch might be still a bit too large as a single patch and might need to split.
>> If you think patch refactoring is needed, please suggest.
>>
>> Change Log:
>>
>> v1 => v2)
>>
>> - Copy fractional pages from 1st kernel to 2nd kernel to reduce read
>>    to the fractional pages for reliability.
>>
>> - Deal with the case where multiple System RAM areas are contained in
>>    a single fractional page.
>>
>> Test:
>>
>> Tested on X86_64. Fractional pages are created using memmap= kernel
>> parameter on the kdump 1st kernel.
>>
>> >From fd6b0aca54caf7f0b5fd3841ef9e5ff081121ab8 Mon Sep 17 00:00:00 2001
>> From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> Date: Mon, 9 Dec 2013 09:12:32 +0900
>> Subject: [PATCH] vmcore: copy fractional pages into buffers in the kdump 2nd kernel
>>
>> As Vivek reported in https://lkml.org/lkml/2013/11/13/439, in real
>> world there's platform that allocates System RAM area and Reserved
>> area in a single same page. As a result, mmap fails at sanity check
>> that comapres memory cache types in a given range, causing user-land
>> tools to exit abnormally in the middle of crash dumping.
>>
>> Although in the current case the data in Reserved area is ACPI data,
>> in general, arbitrary data can possibly be located in a single page
>> together with System RAM area. If they are, for example, mmio, read or
>> write to the area could affect the corresponding devices and so a
>> whole system. We should avoid doing such operations as much as
>> possible in order to keep reliability.
>>
>> To address this issue, we copy fractional pages into buffers in the
>> kdump 2nd kernel, and then read data on the fractional pages from the
>> buffers in the kdump 2nd kernel, not from the fractional pages on the
>> kdump 1st kernel. Similarly, we mmap data on the buffers on the 2nd
>> kernel, not on the 1st kernel. These are done just as we've already
>> done for ELF note segments.
>>
>> Rigorously, we should avoid even mapping pages containing non-System
>> RAM area since mapping could cause some platform specific optimization
>> that could then lead to some kind of prefetch to the page. However, as
>> long as trying to read the System RAM area in the page, we cannot
>> avoid mapping the page. Therefore, reliable possible way is to supress
>> the number of times of reading the fractional pages to just once by
>> buffering System RAM part of the fractional page in the 2nd kerenel.
>>
>> To implement this, extend vmcore structure to represent object in
>> buffer on the 2nd kernel, i.e., introducing VMCORE_2ND_KERNEL flag;
>> for a vmcore object, if it has VMCORE_2ND_KERNEL set, then its data is
>> on the buffer on the 2nd kernel that is pointed to by ->buf member.
>>
>> Only non-trivial case is where multiple System RAM areas are contained
>> in a single page. I want to think there's unlikely to be such system,
>> but the issue addressed here is already odd enough, so we should
>> consider there would be likely enough to be.
>>
>> Reported-by: Vivek Goyal <vgoyal@redhat.com>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>   fs/proc/vmcore.c      | 271 +++++++++++++++++++++++++++++++++++++++++---------
>>   include/linux/kcore.h |   4 +
>>   2 files changed, 229 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
>> index 9100d69..ca79120 100644
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -231,11 +231,20 @@ static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
>>
>>   	list_for_each_entry(m, &vmcore_list, list) {
>>   		if (*fpos < m->offset + m->size) {
>> -			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
>> -			start = m->paddr + *fpos - m->offset;
>> -			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
>> -			if (tmp < 0)
>> -				return tmp;
>> +			tsz = min_t(size_t, m->offset+m->size-*fpos, buflen);
> 							     ^^
> spaces around "-".
>
>> +			if ((m->flags & VMCORE_2ND_KERNEL)) {
>
> I am finding this name "VMCORE_2ND_KERNEL" little odd. Given the fact
> that we are calling other memory as OLDMEM, how about calling a new
> flag as "VMCORE_OLDMEM" and anything which is in old memory should be
> flagged accordingly?
>

It sounds to me from VMCORE_OLDMEM that the memory flagged with it
resides in old memory, not buffer on the 2nd kernel.. How about:

#define VMCORE_OLDMEM 0
#define VMCORE_BUFFER 1

where the objects with VMCORE_OLDMEM refer to the memory that resides in
the 1st kernel (that is called oldmem), and the objects with VMCORE_BUFFER
refer to the memory that resides in the 2nd kernel by being copied into
there just as this patch is about to do.

>> +				void *kaddr;
>> +
>> +				kaddr = m->buf + *fpos - m->offset;
>> +				if (copy_to(buffer, kaddr, tsz, userbuf))
>> +					return -EFAULT;
>> +			} else {
>> +				start = m->paddr + *fpos - m->offset;
>> +				tmp = read_from_oldmem(buffer, tsz, &start,
>> +						       userbuf);
>> +				if (tmp < 0)
>> +					return tmp;
>> +			}
>>   			buflen -= tsz;
>>   			*fpos += tsz;
>>   			buffer += tsz;
>> @@ -300,10 +309,10 @@ static const struct vm_operations_struct vmcore_mmap_ops = {
>>   };
>>
>>   /**
>> - * alloc_elfnotes_buf - allocate buffer for ELF note segment in
>> - *                      vmalloc memory
>> + * alloc_copy_buf - allocate buffer to copy ELF note segment or
>> + *                      fractional pages in vmalloc memory
>
> Should we just call this alloc_buf()?
>
> Also I don't understand that why should we use ifdef CONFIG_MMU. What
> will happen if we just use vmalloc_user() for both CONFIG_MMU set and
> unset?
>

I disliked setting VM_USERMAP on no-MMU arch although there's no
mmap_vmcore support. But as you say, we can also say that it's safe
if using it commonly in both MMU and no-MMU archs since there's no
mmap_vmcore support.

Change it so use vmalloc_user() in either arches.

> I see for ELF headers we are using __get_free_pages(). I am trying to
> remember that why ELF headers have to be physically contiguous in
> memory. Why can't we use vmalloc_user() for ELF headers. Atleast a
> comment there to explain it would be nice.
>

I also don't have very good memory, but I guess the reason was that
the number of memory mapping is not so much large so size of program
header table doesn't become so large compared to ELF note segment, and
thus didn't use vmalloc() for ELF headers aggressively.

I'll fix this in next patch.

Maybe, we might be able to attack this implementation by 4MiB-unit
software hot-plug, though I have not used it, to make many hols.

>>    *
>> - * @notes_sz: size of buffer
>> + * @sz: size of buffer
>>    *
>>    * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
>>    * the buffer to user-space by means of remap_vmalloc_range().
>> @@ -311,12 +320,12 @@ static const struct vm_operations_struct vmcore_mmap_ops = {
>>    * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
>>    * disabled and there's no need to allow users to mmap the buffer.
>>    */
>> -static inline char *alloc_elfnotes_buf(size_t notes_sz)
>> +static inline char *alloc_copy_buf(size_t sz)
>>   {
>>   #ifdef CONFIG_MMU
>> -	return vmalloc_user(notes_sz);
>> +	return vmalloc_user(sz);
>>   #else
>> -	return vzalloc(notes_sz);
>> +	return vzalloc(sz);
>>   #endif
>>   }
>>
>> @@ -383,14 +392,24 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>>
>>   	list_for_each_entry(m, &vmcore_list, list) {
>>   		if (start < m->offset + m->size) {
>> -			u64 paddr = 0;
>> -
>>   			tsz = min_t(size_t, m->offset + m->size - start, size);
>> -			paddr = m->paddr + start - m->offset;
>> -			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
>> -						   paddr >> PAGE_SHIFT, tsz,
>> -						   vma->vm_page_prot))
>> -				goto fail;
>> +			if ((m->flags & VMCORE_2ND_KERNEL)) {
>> +				unsigned long uaddr = vma->vm_start + len;
>
> "uaddr" is same both for oldmem and newmem. So I think you can bring
> it out of if condition and use it for both the cases.
>
>> +				void *kaddr = m->buf + start - m->offset;
>> +
>> +				if (remap_vmalloc_range_partial(vma, uaddr,
>> +								kaddr, tsz))
>> +					goto fail;
>> +			} else {
>> +				u64 paddr = paddr = m->paddr+start-m->offset;
> 				     ^^^    ^^^
> Why "paddr" shows up twice?
>
>> +
>> +				if (remap_oldmem_pfn_range(vma,
>> +							   vma->vm_start + len,
>> +							   paddr >> PAGE_SHIFT,
>> +							   tsz,
>> +							   vma->vm_page_prot))
>> +					goto fail;
>> +			}
>>   			size -= tsz;
>>   			start += tsz;
>>   			len += tsz;
>> @@ -580,7 +599,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>>   		return rc;
>>
>>   	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
>> -	*notes_buf = alloc_elfnotes_buf(*notes_sz);
>> +	*notes_buf = alloc_copy_buf(*notes_sz);
>>   	if (!*notes_buf)
>>   		return -ENOMEM;
>>
>> @@ -760,7 +779,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>>   		return rc;
>>
>>   	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
>> -	*notes_buf = alloc_elfnotes_buf(*notes_sz);
>> +	*notes_buf = alloc_copy_buf(*notes_sz);
>>   	if (!*notes_buf)
>>   		return -ENOMEM;
>>
>> @@ -807,7 +826,7 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>>   	Elf64_Ehdr *ehdr_ptr;
>>   	Elf64_Phdr *phdr_ptr;
>>   	loff_t vmcore_off;
>> -	struct vmcore *new;
>> +	struct vmcore *m, *new;
>>
>>   	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>>   	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
>> @@ -816,27 +835,106 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>>   	vmcore_off = elfsz + elfnotes_sz;
>>
>>   	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>> -		u64 paddr, start, end, size;
>> +		u64 start, end, size, rest;
>> +		u64 start_up, start_down, end_up, end_down;
>> +		loff_t offset;
>> +		int rc, reuse = 0;
>>
>>   		if (phdr_ptr->p_type != PT_LOAD)
>>   			continue;
>>
>> -		paddr = phdr_ptr->p_offset;
>> -		start = rounddown(paddr, PAGE_SIZE);
>> -		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
>> -		size = end - start;
>> +		start = phdr_ptr->p_offset;
>> +		start_up = roundup(start, PAGE_SIZE);
>> +		start_down = rounddown(start, PAGE_SIZE);
>
> Following code is too long and looks messy. Seriously simplify it
> and break it into smaller functions so that it becomes easier to
> read.
>

I'll introduce some functions and refactor here. After that, please
comment it.

> Also you seem to be using __read_vmcore() to read from olmem. This
> is strange. __read_vmcore() relies on that we have finished preparing
> all the underlying data structures like vmcore_list and then we call
> it. Now we are in the process of preparing the list and we are calling
> it. It might not crash, but does not look clean to me. Also conceptually
> we are not reading vmcore. We are reading a part of old memory. So why
> not use read_from_oldmem() directly.
>

Exactly. I'll fix this.

>
>> +
>> +		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
>> +		end_up = roundup(end, PAGE_SIZE);
>> +		end_down = rounddown(end, PAGE_SIZE);
>> +
>> +		size = end_up - start_down;
>> +		rest = phdr_ptr->p_memsz;
>> +
>> +		/* Add a head fractional page to vmcore list. */
>> +		if (!PAGE_ALIGNED(start)) {
>> +			/* Reuse the same buffer if multiple System
>> +			 * RAM entries show up in the same page. */
>> +			list_for_each_entry(m, vc_list, list) {
>> +				if (m->paddr == start_down &&
>> +				    m->flags == VMCORE_2ND_KERNEL) {
>> +					new = m;
>> +					reuse = 1;
>> +					goto skip;
>> +				}
>> +			}
>
> Do we need this optimzation? Is it common to have multiple system RAM
> ranges in a single page. I don't have systems like that. If it is not
> common, let us remove this optimization for now. It is making code look
> uglier in current form.
>

OK for now.

-- 
Thanks.
HATAYAMA, Daisuke

