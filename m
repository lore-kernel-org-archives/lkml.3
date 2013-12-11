Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3LKLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:34:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3LKLe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:34:27 -0500
Date: Wed, 11 Dec 2013 19:33:54 +0800
From: WANG Chao <chaowang@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vmcore: copy fractional pages into buffers in the
 kdump 2nd kernel
Message-ID: <20131211113354.GC1537@dhcp-17-89.nay.redhat.com>
References: <52A579EE.6090107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A579EE.6090107@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 at 05:06pm, HATAYAMA Daisuke wrote:
> This is a patch for fixing mmap failure due to fractional page issue.
> 
> This patch might be still a bit too large as a single patch and might need to split.
> If you think patch refactoring is needed, please suggest.
> 
> Change Log:
> 
> v1 => v2)
> 
> - Copy fractional pages from 1st kernel to 2nd kernel to reduce read
>   to the fractional pages for reliability.
> 
> - Deal with the case where multiple System RAM areas are contained in
>   a single fractional page.
> 
> Test:
> 
> Tested on X86_64. Fractional pages are created using memmap= kernel
> parameter on the kdump 1st kernel.
> 
> From fd6b0aca54caf7f0b5fd3841ef9e5ff081121ab8 Mon Sep 17 00:00:00 2001
> From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Date: Mon, 9 Dec 2013 09:12:32 +0900
> Subject: [PATCH] vmcore: copy fractional pages into buffers in the kdump 2nd kernel
> 
> As Vivek reported in https://lkml.org/lkml/2013/11/13/439, in real
> world there's platform that allocates System RAM area and Reserved
> area in a single same page. As a result, mmap fails at sanity check
> that comapres memory cache types in a given range, causing user-land
> tools to exit abnormally in the middle of crash dumping.
> 
> Although in the current case the data in Reserved area is ACPI data,
> in general, arbitrary data can possibly be located in a single page
> together with System RAM area. If they are, for example, mmio, read or
> write to the area could affect the corresponding devices and so a
> whole system. We should avoid doing such operations as much as
> possible in order to keep reliability.
> 
> To address this issue, we copy fractional pages into buffers in the
> kdump 2nd kernel, and then read data on the fractional pages from the
> buffers in the kdump 2nd kernel, not from the fractional pages on the
> kdump 1st kernel. Similarly, we mmap data on the buffers on the 2nd
> kernel, not on the 1st kernel. These are done just as we've already
> done for ELF note segments.
> 
> Rigorously, we should avoid even mapping pages containing non-System
> RAM area since mapping could cause some platform specific optimization
> that could then lead to some kind of prefetch to the page. However, as
> long as trying to read the System RAM area in the page, we cannot
> avoid mapping the page. Therefore, reliable possible way is to supress
> the number of times of reading the fractional pages to just once by
> buffering System RAM part of the fractional page in the 2nd kerenel.
> 
> To implement this, extend vmcore structure to represent object in
> buffer on the 2nd kernel, i.e., introducing VMCORE_2ND_KERNEL flag;
> for a vmcore object, if it has VMCORE_2ND_KERNEL set, then its data is
> on the buffer on the 2nd kernel that is pointed to by ->buf member.
> 
> Only non-trivial case is where multiple System RAM areas are contained
> in a single page. I want to think there's unlikely to be such system,
> but the issue addressed here is already odd enough, so we should
> consider there would be likely enough to be.
> 
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

Hi, HATAMAYA Daisuke

Thanks for the fix.

My workstation has been experiencing the same issue. It has a fractional
page, one part contains system ram and the other contains ACPI data:

# cat /proc/iomem
[..]
00100000-bfdffbff : System RAM
  01000000-0167b6a5 : Kernel code
  0167b6a6-01d06cbf : Kernel data
  01e6d000-01feafff : Kernel bss
  bb000000-bf7fffff : Crash kernel
bfdffc00-bfe53bff : ACPI Non-volatile Storage

I apply your patch on top of 3.13-rc3. And makedumpfile can successfully
extract dump with mmap().

Thanks,
WANG Chao


> ---
>  fs/proc/vmcore.c      | 271 +++++++++++++++++++++++++++++++++++++++++---------
>  include/linux/kcore.h |   4 +
>  2 files changed, 229 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 9100d69..ca79120 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -231,11 +231,20 @@ static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
>  
>  	list_for_each_entry(m, &vmcore_list, list) {
>  		if (*fpos < m->offset + m->size) {
> -			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
> -			start = m->paddr + *fpos - m->offset;
> -			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
> -			if (tmp < 0)
> -				return tmp;
> +			tsz = min_t(size_t, m->offset+m->size-*fpos, buflen);
> +			if ((m->flags & VMCORE_2ND_KERNEL)) {
> +				void *kaddr;
> +
> +				kaddr = m->buf + *fpos - m->offset;
> +				if (copy_to(buffer, kaddr, tsz, userbuf))
> +					return -EFAULT;
> +			} else {
> +				start = m->paddr + *fpos - m->offset;
> +				tmp = read_from_oldmem(buffer, tsz, &start,
> +						       userbuf);
> +				if (tmp < 0)
> +					return tmp;
> +			}
>  			buflen -= tsz;
>  			*fpos += tsz;
>  			buffer += tsz;
> @@ -300,10 +309,10 @@ static const struct vm_operations_struct vmcore_mmap_ops = {
>  };
>  
>  /**
> - * alloc_elfnotes_buf - allocate buffer for ELF note segment in
> - *                      vmalloc memory
> + * alloc_copy_buf - allocate buffer to copy ELF note segment or
> + *                      fractional pages in vmalloc memory
>   *
> - * @notes_sz: size of buffer
> + * @sz: size of buffer
>   *
>   * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
>   * the buffer to user-space by means of remap_vmalloc_range().
> @@ -311,12 +320,12 @@ static const struct vm_operations_struct vmcore_mmap_ops = {
>   * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
>   * disabled and there's no need to allow users to mmap the buffer.
>   */
> -static inline char *alloc_elfnotes_buf(size_t notes_sz)
> +static inline char *alloc_copy_buf(size_t sz)
>  {
>  #ifdef CONFIG_MMU
> -	return vmalloc_user(notes_sz);
> +	return vmalloc_user(sz);
>  #else
> -	return vzalloc(notes_sz);
> +	return vzalloc(sz);
>  #endif
>  }
>  
> @@ -383,14 +392,24 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>  
>  	list_for_each_entry(m, &vmcore_list, list) {
>  		if (start < m->offset + m->size) {
> -			u64 paddr = 0;
> -
>  			tsz = min_t(size_t, m->offset + m->size - start, size);
> -			paddr = m->paddr + start - m->offset;
> -			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
> -						   paddr >> PAGE_SHIFT, tsz,
> -						   vma->vm_page_prot))
> -				goto fail;
> +			if ((m->flags & VMCORE_2ND_KERNEL)) {
> +				unsigned long uaddr = vma->vm_start + len;
> +				void *kaddr = m->buf + start - m->offset;
> +
> +				if (remap_vmalloc_range_partial(vma, uaddr,
> +								kaddr, tsz))
> +					goto fail;
> +			} else {
> +				u64 paddr = paddr = m->paddr+start-m->offset;
> +
> +				if (remap_oldmem_pfn_range(vma,
> +							   vma->vm_start + len,
> +							   paddr >> PAGE_SHIFT,
> +							   tsz,
> +							   vma->vm_page_prot))
> +					goto fail;
> +			}
>  			size -= tsz;
>  			start += tsz;
>  			len += tsz;
> @@ -580,7 +599,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  		return rc;
>  
>  	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
> -	*notes_buf = alloc_elfnotes_buf(*notes_sz);
> +	*notes_buf = alloc_copy_buf(*notes_sz);
>  	if (!*notes_buf)
>  		return -ENOMEM;
>  
> @@ -760,7 +779,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  		return rc;
>  
>  	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
> -	*notes_buf = alloc_elfnotes_buf(*notes_sz);
> +	*notes_buf = alloc_copy_buf(*notes_sz);
>  	if (!*notes_buf)
>  		return -ENOMEM;
>  
> @@ -807,7 +826,7 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>  	Elf64_Ehdr *ehdr_ptr;
>  	Elf64_Phdr *phdr_ptr;
>  	loff_t vmcore_off;
> -	struct vmcore *new;
> +	struct vmcore *m, *new;
>  
>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>  	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
> @@ -816,27 +835,106 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>  	vmcore_off = elfsz + elfnotes_sz;
>  
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> -		u64 paddr, start, end, size;
> +		u64 start, end, size, rest;
> +		u64 start_up, start_down, end_up, end_down;
> +		loff_t offset;
> +		int rc, reuse = 0;
>  
>  		if (phdr_ptr->p_type != PT_LOAD)
>  			continue;
>  
> -		paddr = phdr_ptr->p_offset;
> -		start = rounddown(paddr, PAGE_SIZE);
> -		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
> -		size = end - start;
> +		start = phdr_ptr->p_offset;
> +		start_up = roundup(start, PAGE_SIZE);
> +		start_down = rounddown(start, PAGE_SIZE);
> +
> +		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
> +		end_up = roundup(end, PAGE_SIZE);
> +		end_down = rounddown(end, PAGE_SIZE);
> +
> +		size = end_up - start_down;
> +		rest = phdr_ptr->p_memsz;
> +
> +		/* Add a head fractional page to vmcore list. */
> +		if (!PAGE_ALIGNED(start)) {
> +			/* Reuse the same buffer if multiple System
> +			 * RAM entries show up in the same page. */
> +			list_for_each_entry(m, vc_list, list) {
> +				if (m->paddr == start_down &&
> +				    m->flags == VMCORE_2ND_KERNEL) {
> +					new = m;
> +					reuse = 1;
> +					goto skip;
> +				}
> +			}
> +
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->buf = alloc_copy_buf(PAGE_SIZE);
> +			if (!new->buf) {
> +				kfree(new);
> +				return -ENOMEM;
> +			}
> +			new->flags = VMCORE_2ND_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->paddr = start_down;
> +			list_add_tail(&new->list, vc_list);
> +		skip:
> +
> +			offset = start;
> +			rc = __read_vmcore(new->buf + (start - start_down),
> +					   min(start_up, end) - start,
> +					   &offset, 0);
> +			if (rc < 0)
> +				return rc;
> +
> +			rest -= min(start_up, end) - start;
> +		}
>  
>  		/* Add this contiguous chunk of memory to vmcore list.*/
> -		new = get_new_element();
> -		if (!new)
> -			return -ENOMEM;
> -		new->paddr = start;
> -		new->size = size;
> -		list_add_tail(&new->list, vc_list);
> +		if (rest > 0 && start_up < end_down) {
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->size = end_down - start_up;
> +			new->paddr = start_up;
> +			list_add_tail(&new->list, vc_list);
> +			rest -= end_down - start_up;
> +		}
> +
> +		/* Add a tail fractional page to vmcore list. */
> +		if (rest > 0) {
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->buf = alloc_copy_buf(PAGE_SIZE);
> +			if (!new->buf) {
> +				kfree(new);
> +				return -ENOMEM;
> +			}
> +			new->flags = VMCORE_2ND_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->paddr = end_down;
> +			list_add_tail(&new->list, vc_list);
> +
> +			offset = end_down;
> +			rc = __read_vmcore(new->buf, end - end_down, &offset,
> +					   0);
> +			if (rc < 0)
> +				return rc;
> +
> +			rest -= end - end_down;
> +		}
> +
> +		WARN_ON(rest > 0);
>  
>  		/* Update the program header offset. */
> -		phdr_ptr->p_offset = vmcore_off + (paddr - start);
> +		phdr_ptr->p_offset = vmcore_off + (start - start_down);
>  		vmcore_off = vmcore_off + size;
> +		if (reuse) {
> +			phdr_ptr->p_offset -= PAGE_SIZE;
> +			vmcore_off -= PAGE_SIZE;
> +		}
>  	}
>  	return 0;
>  }
> @@ -850,7 +948,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  	Elf32_Ehdr *ehdr_ptr;
>  	Elf32_Phdr *phdr_ptr;
>  	loff_t vmcore_off;
> -	struct vmcore *new;
> +	struct vmcore *m, *new;
>  
>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>  	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
> @@ -859,27 +957,106 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  	vmcore_off = elfsz + elfnotes_sz;
>  
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> -		u64 paddr, start, end, size;
> +		u64 start, end, size, rest;
> +		u64 start_up, start_down, end_up, end_down;
> +		loff_t offset;
> +		int rc, reuse = 0;
>  
>  		if (phdr_ptr->p_type != PT_LOAD)
>  			continue;
>  
> -		paddr = phdr_ptr->p_offset;
> -		start = rounddown(paddr, PAGE_SIZE);
> -		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
> -		size = end - start;
> +		start = phdr_ptr->p_offset;
> +		start_up = roundup(start, PAGE_SIZE);
> +		start_down = rounddown(start, PAGE_SIZE);
> +
> +		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
> +		end_up = roundup(end, PAGE_SIZE);
> +		end_down = rounddown(end, PAGE_SIZE);
> +
> +		size = end_up - start_down;
> +		rest = phdr_ptr->p_memsz;
> +
> +		/* Add a head fractional page to vmcore list. */
> +		if (!PAGE_ALIGNED(start)) {
> +			/* Reuse the same buffer if multiple System
> +			 * RAM entries show up in the same page. */
> +			list_for_each_entry(m, vc_list, list) {
> +				if (m->paddr == start_down &&
> +				    m->flags == VMCORE_2ND_KERNEL) {
> +					new = m;
> +					reuse = 1;
> +					goto skip;
> +				}
> +			}
> +
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->buf = alloc_copy_buf(PAGE_SIZE);
> +			if (!new->buf) {
> +				kfree(new);
> +				return -ENOMEM;
> +			}
> +			new->flags = VMCORE_2ND_KERNEL;
> +			new->paddr = start_down;
> +			new->size = PAGE_SIZE;
> +			list_add_tail(&new->list, vc_list);
> +		skip:
> +
> +			offset = start;
> +			rc = __read_vmcore(new->buf + (start - start_down),
> +					   min(start_up, end) - start,
> +					   &offset, 0);
> +			if (rc < 0)
> +				return rc;
> +
> +			rest -= min(start_up, end) - start;
> +		}
>  
>  		/* Add this contiguous chunk of memory to vmcore list.*/
> -		new = get_new_element();
> -		if (!new)
> -			return -ENOMEM;
> -		new->paddr = start;
> -		new->size = size;
> -		list_add_tail(&new->list, vc_list);
> +		if (rest > 0 && start_up < end_down) {
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->size = end_down - start_up;
> +			new->paddr = start_up;
> +			list_add_tail(&new->list, vc_list);
> +			rest -= end_down - start_up;
> +		}
> +
> +		/* Add a tail fractional page to vmcore list. */
> +		if (rest > 0) {
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->buf = (void *)get_zeroed_page(GFP_KERNEL);
> +			if (!new->buf) {
> +				kfree(new);
> +				return -ENOMEM;
> +			}
> +			new->flags = VMCORE_2ND_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->paddr = end_down;
> +			list_add_tail(&new->list, vc_list);
> +
> +			offset = end_down;
> +			rc = __read_vmcore(new->buf, end - end_down, &offset,
> +					   0);
> +			if (rc < 0)
> +				return rc;
> +
> +			rest -= end - end_down;
> +		}
> +
> +		WARN_ON(rest > 0);
>  
>  		/* Update the program header offset */
> -		phdr_ptr->p_offset = vmcore_off + (paddr - start);
> +		phdr_ptr->p_offset = vmcore_off + (start - start_down);
>  		vmcore_off = vmcore_off + size;
> +		if (reuse) {
> +			phdr_ptr->p_offset -= PAGE_SIZE;
> +			vmcore_off -= PAGE_SIZE;
> +		}
>  	}
>  	return 0;
>  }
> @@ -1100,6 +1277,8 @@ void vmcore_cleanup(void)
>  
>  		m = list_entry(pos, struct vmcore, list);
>  		list_del(&m->list);
> +		if ((m->flags & VMCORE_2ND_KERNEL))
> +			vfree(m->buf);
>  		kfree(m);
>  	}
>  	free_elfcorebuf();
> diff --git a/include/linux/kcore.h b/include/linux/kcore.h
> index d927622..3a86423 100644
> --- a/include/linux/kcore.h
> +++ b/include/linux/kcore.h
> @@ -19,11 +19,15 @@ struct kcore_list {
>  	int type;
>  };
>  
> +#define VMCORE_2ND_KERNEL 0x1
> +
>  struct vmcore {
>  	struct list_head list;
>  	unsigned long long paddr;
>  	unsigned long long size;
>  	loff_t offset;
> +	char *buf;
> +	unsigned long flags;
>  };
>  
>  #ifdef CONFIG_PROC_KCORE
> -- 
> 1.8.3.1
> 
> -- 
> Thanks.
> HATAYAMA, Daisuke
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
