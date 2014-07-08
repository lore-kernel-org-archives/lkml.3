Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaGHR14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:27:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaGHR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:27:53 -0400
Date: Tue, 8 Jul 2014 12:29:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] mmap_vmcore: skip non-ram pages reported by
 hypervisors
Message-ID: <20140708162930.GC9727@laptop.dumpdata.com>
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 05:05:49PM +0200, Vitaly Kuznetsov wrote:
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

Could the 'remap_oldmem_pfn_range' become an function ops? I see there
is an 'register_oldmem_pfn_is_ram' - so could there be similar one for
'pfn_range'?

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  fs/proc/vmcore.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 382aa89..2716e19 100644
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
> +
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
> +
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
> -- 
> 1.9.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
