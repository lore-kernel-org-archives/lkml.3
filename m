Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaGGUdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:33:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaGGUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:33:03 -0400
Date: Mon, 7 Jul 2014 13:33:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmap_vmcore: skip non-ram pages reported by hypervisors
Message-Id: <20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
In-Reply-To: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Jul 2014 17:05:49 +0200 Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> we have a special check in read_vmcore() handler to check if the page was
> reported as ram or not by the hypervisor (pfn_is_ram()). However, when
> vmcore is read with mmap() no such check is performed. That can lead to
> unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
> mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
> enormous load in both DomU and Dom0.
> 
> Fix the issue by mapping each non-ram page to the zero page. Keep direct
> path with remap_oldmem_pfn_range() to avoid looping through all pages on
> bare metal.
> 
> The issue can also be solved by overriding remap_oldmem_pfn_range() in
> xen-specific code, as remap_oldmem_pfn_range() was been designed for.
> That, however, would involve non-obvious xen code path for all x86 builds
> with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
> code on x86 arch from doing the same override.

I'd like to get some reviewed-by's and tested-by's on this one please.

> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -328,6 +328,46 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
>   * virtually contiguous user-space in ELF layout.
>   */
>  #ifdef CONFIG_MMU
> +static u64 remap_oldmem_pfn_checked(struct vm_area_struct *vma, u64 len,
> +				    unsigned long pfn, unsigned long page_count)
> +{
> +	unsigned long pos;
> +	size_t size;
> +	unsigned long vma_addr;
> +	unsigned long emptypage_pfn = __pa(empty_zero_page) >> PAGE_SHIFT;

That's old-school.  Can we use my_zero_pfn() here?

Also, "zeropage_pfn" is a better name - let's not introduce the
hitherto unknown concept of an "empty page".

> +	for (pos = pfn; (pos - pfn) <= page_count; pos++) {
> +		if (!pfn_is_ram(pos) || (pos - pfn) == page_count) {
> +			/* we hit a page which is not ram or reached the end */
> +			if (pos - pfn > 0) {
> +				/* remapping continuous region */
> +				size = (pos - pfn) << PAGE_SHIFT;
> +				vma_addr = vma->vm_start + len;
> +				if (remap_oldmem_pfn_range(vma, vma_addr,
> +							   pfn, size,
> +							   vma->vm_page_prot))
> +					return len;
> +				len += size;
> +				page_count -= (pos - pfn);
> +			}
> +			if (page_count > 0) {
> +				/* we hit a page which is not ram, replacing
> +				   with an empty one */

I suggest

				/*
				 * We hit a page which is not ram.  Replace it
				 * with the zero page.
				 */

> +				vma_addr = vma->vm_start + len;
> +				if (remap_oldmem_pfn_range(vma, vma_addr,
> +							   emptypage_pfn,
> +							   PAGE_SIZE,
> +							   vma->vm_page_prot))
> +					return len;
> +				len += PAGE_SIZE;
> +				pfn = pos + 1;
> +				page_count--;
> +			}
> +		}
> +	}
> +	return len;
> +}

Also, this loop seems unnecessarily hard to follow.  It *look* like the
`for' statement has an off-by-one because of the "<=", but page_count
is mofidied inside the loop!  Despite it being an incoming formal
argument.

None of this is made any easier by the function's lack of
documentation.  Some description of the incoming args would help, along
with an overall description of the function's responsibilities.

That being said, can't we just do something nice and simple like

	pos = pfn;
	while (pos < pfn + page_count) {
		stuff which advances `pos'
	}

?

>  static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>  {
>  	size_t size = vma->vm_end - vma->vm_start;
> @@ -383,17 +423,33 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>  
>  	list_for_each_entry(m, &vmcore_list, list) {
>  		if (start < m->offset + m->size) {
> -			u64 paddr = 0;
> +			u64 paddr = 0, original_len;
> +			unsigned long pfn, page_count;
>  
>  			tsz = min_t(size_t, m->offset + m->size - start, size);
>  			paddr = m->paddr + start - m->offset;
> -			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
> -						   paddr >> PAGE_SHIFT, tsz,
> -						   vma->vm_page_prot))
> -				goto fail;
> +
> +			/* check if oldmem_pfn_is_ram was registered to avoid
> +			   looping over all pages without a reason */

Please lay out the comments in the usual fashion:

	/*
	 * ...
	 * ..
	 */

And sentences start whith upper-case letters!

> +			if (oldmem_pfn_is_ram) {
> +				pfn = paddr >> PAGE_SHIFT;
> +				page_count = tsz >> PAGE_SHIFT;
> +				original_len = len;
> +				len = remap_oldmem_pfn_checked(vma, len, pfn,
> +							       page_count);
> +				if (len != original_len + tsz)
> +					goto fail;
> +			} else {
> +				if (remap_oldmem_pfn_range(vma,
> +							   vma->vm_start + len,
> +							   paddr >> PAGE_SHIFT,
> +							   tsz,
> +							   vma->vm_page_prot))
> +					goto fail;
> +				len += tsz;
> +			}
>  			size -= tsz;
>  			start += tsz;
> -			len += tsz;
>  
>  			if (size == 0)
>  				return 0;

